/**
 * Ads + landing-page auto-diagnostics.
 *
 * Two signal sources are joined:
 *
 *   1. analytics_events — server-mirror of the Vercel Web Analytics events.
 *      Used to compute per-path funnel rates (sessions → signups, checkouts).
 *
 *   2. Meta Marketing API insights — per-ad spend / CTR / CPL / clicks.
 *      Requires META_AD_ACCOUNT_ID + META_SYSTEM_USER_TOKEN. If either env
 *      var is missing we skip ad-level checks and still report page issues.
 *
 * The diagnose() pipeline is pure: it takes raw rows + insights and returns
 * a list of findings. The cron route is responsible for persistence and
 * for calling executeAutoActions() on the subset that's safe to auto-fix.
 *
 * Auto-actions are intentionally limited to reversible Meta API writes
 * (status = PAUSED). We never auto-edit landing-page code; high-severity
 * page findings become suggestions for the admin to review.
 */

import type { SupabaseClient } from "@supabase/supabase-js";
import { getLatestUserToken } from "@/lib/facebook";

// ─── Thresholds ──────────────────────────────────────────────────────────
//
// Centralised so the admin can tune them later without touching the rules.
// All currency values are THB; the Marketing API returns spend in the ad
// account's currency, which for morroo's account is THB.

export const THRESHOLDS = {
  // Page-level, rolling window
  pageWindowDays: 7,
  pageMinSessions: 150,                  // below this we don't have signal
  pageNoConversionMinSessions: 250,      // criteria for the harshest finding
  pageLowSignupRatePct: 1.0,             // signup_submit / sessions, %
  pageHighBounceRatePct: 80,             // 1-event-only sessions / sessions
  pageLineCtaMinSessions: 200,           // need this much traffic to call a dead LINE CTA
  pageLowCheckoutMinSessions: 150,       // signed up but nobody reaches checkout
  // Paid-traffic landing check: sessions that arrive from an ad (utm_medium=paid /
  // fbclid) and leave within `shortSessionSecs` without touching anything.
  // Sep 2026: a Story ad pointed at "/" produced 778 sessions, 85% under 5s,
  // 0 signups — while the same audience landing on the case game stayed a
  // median 16s. That's an ad/landing mismatch (or mis-taps), not a page bug.
  pageAdLandingMinSessions: 200,
  pageAdLandingShortRatePct: 70,
  shortSessionSecs: 5,

  // Ad-level, rolling window
  adWindowDays: 3,
  adMinSpendThb: 150,                    // ignore ads still in learning
  adHighCplThb: 200,                     // cost per lead ceiling
  adLowCtrPct: 0.5,                      // CTR floor (clicks/impressions %)
  adLowCtrMinImpressions: 1000,
  adAutoPauseCtrPct: 0.3,                // auto-pause if CTR worse than this…
  adAutoPauseMinImpressions: 3000,       // …and we have enough data
  adNoLeadSpendCeilingThb: 500,          // spend > X with 0 leads → auto-pause
  adHighFrequency: 4.0,                  // creative fatigue signal
} as const;

// ─── Types ───────────────────────────────────────────────────────────────

export type Severity = "info" | "warn" | "critical";

export type FindingCategory =
  | "page_no_conversion"
  | "ad_landing_mismatch"
  | "page_low_signup"
  | "page_high_bounce"
  | "page_low_line_cta"
  | "page_low_checkout"
  | "ad_high_cpl"
  | "ad_low_ctr"
  | "ad_no_lead_high_spend"
  | "ad_high_frequency";

export type EntityType = "page" | "ad" | "adset" | "campaign";

export interface Finding {
  severity: Severity;
  category: FindingCategory;
  entityType: EntityType;
  entityId: string;
  entityLabel?: string;
  metricSnapshot: Record<string, number | string | null>;
  recommendation: string;
  /** Only set when the cron is permitted to auto-act on this category. */
  autoAction?: AutoActionRequest;
}

export interface AutoActionRequest {
  action: "pause_ad" | "pause_adset";
  entityType: "ad" | "adset";
  entityId: string;
  reason: string;
}

/**
 * Per-landing-page funnel stats.
 *
 * Attribution is by LANDING SESSION: a session belongs to the bucket of the
 * first page it viewed, and every conversion that session makes later — on
 * /register, /pricing, anywhere — is credited to that landing page. Counting
 * by the path the event fired on (the old behaviour) gave "/" a permanent 0
 * because signup_submit always fires on /register, which sent the admin off
 * to "fix the homepage CTA" when the homepage was fine.
 *
 * `pageViews` stays path-based (views of this path from any session).
 */
export interface PageStats {
  path: string;
  /** Sessions that landed on this path. */
  sessions: number;
  pageViews: number;
  /** Landing sessions with no further pageview and no engagement event. */
  singleEventSessions: number;
  /** Landing sessions whose whole activity spans < THRESHOLDS.shortSessionSecs. */
  shortSessions: number;
  /** Landing sessions that arrived from a paid ad (utm_medium=paid / fbclid). */
  adSessions: number;
  /** Ad sessions that were also short — the mis-tap / mismatch signal. */
  adShortSessions: number;
  /** Top paid source tag for the ad sessions, e.g. "fb / 52588558588397". */
  adTopSource: string | null;
  signups: number;
  examStarts: number;
  checkouts: number;
  lineClicks: number;
}

export interface AdInsight {
  ad_id: string;
  ad_name: string;
  adset_id: string;
  adset_name: string;
  campaign_id: string;
  campaign_name: string;
  objective?: string | null;   // OUTCOME_LEADS / OUTCOME_TRAFFIC / LINK_CLICKS …
  status: string | null;       // ACTIVE / PAUSED / etc.
  effective_status: string | null;
  impressions: number;
  clicks: number;
  spend: number;
  leads: number;
  ctr: number;                 // %
  cpl: number | null;          // THB
  frequency: number;
}

// ─── Page analytics aggregation ──────────────────────────────────────────

type RawEventRow = {
  event_name: string;
  session_id: string | null;
  path: string | null;
  properties: Record<string, unknown> | null;
  created_at: string;
};

// Events that mean "the visitor did something" beyond auto-fired view pings.
// Auto-fired events (hero_variant_view, *_show) must NOT count, or every
// homepage session looks engaged.
const ENGAGEMENT_EVENTS = new Set([
  "signup_submit",
  "exam_start_click",
  "stripe_checkout_click",
  "social_click",
  "hero_variant_convert",
  "first_visit_nudge_cta_click",
  "exit_intent_cta_click",
  "free_try_cta_click",
  "casegame_start",
  "casegame_first_tap",
  "casegame_cta_click",
  "mcq_answer_submit",
  "pricing_view",
  "login_attempt",
]);

/** Top-level path bucket (`/lp/foo/bar` → `/lp/foo`). Keeps cardinality sane. */
function bucketPath(path: string): string {
  const clean = path.split("?")[0] || "/";
  const segments = clean.split("/").filter(Boolean);
  if (segments.length === 0) return "/";
  if (segments.length === 1) return `/${segments[0]}`;
  return `/${segments[0]}/${segments[1]}`;
}

/** Paid-source tag from a landing URL, or null for organic/direct. */
export function paidSourceOf(path: string): string | null {
  const qs = path.split("?")[1];
  if (!qs) return null;
  const params = new URLSearchParams(qs);
  const medium = params.get("utm_medium");
  const isPaid =
    medium === "paid" ||
    medium === "cpc" ||
    medium === "paid_social" ||
    params.has("fbclid") ||
    params.has("gclid") ||
    params.has("ttclid");
  if (!isPaid) return null;
  const source =
    params.get("utm_source") ??
    (params.has("fbclid") ? "fb" : params.has("gclid") ? "google" : "paid");
  const campaign = params.get("utm_campaign");
  return campaign ? `${source} / ${campaign}` : source;
}

export async function fetchPageStats(
  supabase: SupabaseClient,
  sinceIso: string
): Promise<PageStats[]> {
  const { data, error } = await supabase
    .from("analytics_events")
    .select("event_name, session_id, path, properties, created_at")
    .gte("created_at", sinceIso)
    .order("created_at", { ascending: true })
    .limit(100000);

  if (error) throw new Error(`fetchPageStats: ${error.message}`);

  return aggregatePageStats((data as RawEventRow[] | null) ?? []);
}

/** Pure aggregation, split out so the attribution rules are unit-testable. */
export function aggregatePageStats(rows: RawEventRow[]): PageStats[] {
  type Session = {
    landing: string | null;
    paidSource: string | null;
    pageviews: number;
    engaged: boolean;
    firstAt: number;
    lastAt: number;
    signups: number;
    examStarts: number;
    checkouts: number;
    lineClicks: number;
  };
  const sessions = new Map<string, Session>();
  const pageViewsByPath = new Map<string, number>();

  // Rows arrive ordered by created_at, but guard against callers that don't.
  const ordered = [...rows].sort(
    (a, b) => Date.parse(a.created_at) - Date.parse(b.created_at)
  );

  for (const row of ordered) {
    if (row.event_name === "pageview" && row.path) {
      const b = bucketPath(row.path);
      pageViewsByPath.set(b, (pageViewsByPath.get(b) ?? 0) + 1);
    }
    if (!row.session_id) continue;

    const at = Date.parse(row.created_at) || 0;
    let sess = sessions.get(row.session_id);
    if (!sess) {
      sess = {
        landing: null,
        paidSource: null,
        pageviews: 0,
        engaged: false,
        firstAt: at,
        lastAt: at,
        signups: 0,
        examStarts: 0,
        checkouts: 0,
        lineClicks: 0,
      };
      sessions.set(row.session_id, sess);
    }
    if (at < sess.firstAt) sess.firstAt = at;
    if (at > sess.lastAt) sess.lastAt = at;

    if (row.event_name === "pageview" && row.path) {
      sess.pageviews += 1;
      if (sess.landing === null) {
        sess.landing = bucketPath(row.path);
        sess.paidSource = paidSourceOf(row.path);
      }
      continue;
    }

    if (ENGAGEMENT_EVENTS.has(row.event_name)) sess.engaged = true;
    switch (row.event_name) {
      case "signup_submit":
        sess.signups += 1;
        break;
      case "exam_start_click":
        sess.examStarts += 1;
        break;
      case "stripe_checkout_click":
        sess.checkouts += 1;
        break;
      case "social_click":
        if (row.properties?.platform === "line") sess.lineClicks += 1;
        break;
    }
  }

  type Bucket = Omit<PageStats, "adTopSource"> & { sources: Map<string, number> };
  const buckets = new Map<string, Bucket>();
  const shortMs = THRESHOLDS.shortSessionSecs * 1000;

  for (const sess of sessions.values()) {
    // A session with no pageview at all (e.g. only a keepalive event after
    // the pageview row was lost) has no landing page to credit.
    if (!sess.landing) continue;
    let b = buckets.get(sess.landing);
    if (!b) {
      b = {
        path: sess.landing,
        sessions: 0,
        pageViews: pageViewsByPath.get(sess.landing) ?? 0,
        singleEventSessions: 0,
        shortSessions: 0,
        adSessions: 0,
        adShortSessions: 0,
        signups: 0,
        examStarts: 0,
        checkouts: 0,
        lineClicks: 0,
        sources: new Map(),
      };
      buckets.set(sess.landing, b);
    }
    const isShort = sess.lastAt - sess.firstAt < shortMs;
    const isBounce = sess.pageviews <= 1 && !sess.engaged;
    b.sessions += 1;
    if (isBounce) b.singleEventSessions += 1;
    if (isShort) b.shortSessions += 1;
    if (sess.paidSource) {
      b.adSessions += 1;
      if (isShort) b.adShortSessions += 1;
      b.sources.set(sess.paidSource, (b.sources.get(sess.paidSource) ?? 0) + 1);
    }
    b.signups += sess.signups;
    b.examStarts += sess.examStarts;
    b.checkouts += sess.checkouts;
    b.lineClicks += sess.lineClicks;
  }

  // Paths that were viewed but never landed on still get a row so callers
  // that look a page up by path (post-merge watch) find it.
  for (const [path, views] of pageViewsByPath) {
    if (!buckets.has(path)) {
      buckets.set(path, {
        path,
        sessions: 0,
        pageViews: views,
        singleEventSessions: 0,
        shortSessions: 0,
        adSessions: 0,
        adShortSessions: 0,
        signups: 0,
        examStarts: 0,
        checkouts: 0,
        lineClicks: 0,
        sources: new Map(),
      });
    }
  }

  return Array.from(buckets.values()).map(({ sources, ...b }) => {
    let top: string | null = null;
    let topN = 0;
    for (const [src, n] of sources) {
      if (n > topN) {
        top = src;
        topN = n;
      }
    }
    return { ...b, adTopSource: top };
  });
}

// ─── Meta Marketing API ──────────────────────────────────────────────────

const META_GRAPH_VERSION = "v24.0";

interface MetaInsightsRow {
  ad_id?: string;
  ad_name?: string;
  adset_id?: string;
  adset_name?: string;
  campaign_id?: string;
  campaign_name?: string;
  objective?: string;
  impressions?: string;
  clicks?: string;
  spend?: string;
  ctr?: string;
  frequency?: string;
  actions?: Array<{ action_type: string; value: string }>;
  cost_per_action_type?: Array<{ action_type: string; value: string }>;
}

interface MetaAdRow {
  id: string;
  status?: string;
  effective_status?: string;
}

function pickLeadsFromActions(
  actions: MetaInsightsRow["actions"] | undefined
): number {
  if (!actions) return 0;
  // Prefer "lead" (Instant Form) then fall back to common conversion types.
  // The pixel/CAPI registration event Morroo's signup campaign optimizes for
  // arrives as offsite_conversion.fb_pixel_complete_registration — without it
  // here the campaign always looks like "0 leads" and gets auto-paused.
  const priority = [
    "lead",
    "onsite_conversion.lead_grouped",
    "complete_registration",
    "offsite_conversion.fb_pixel_complete_registration",
  ];
  for (const key of priority) {
    const hit = actions.find((a) => a.action_type === key);
    if (hit) return Number(hit.value) || 0;
  }
  return 0;
}

export async function fetchAdInsights(
  sinceIso: string,
  untilIso: string
): Promise<AdInsight[]> {
  const accountId = process.env.META_AD_ACCOUNT_ID; // e.g. "act_123456"
  const token = await getLatestUserToken();
  if (!accountId || !token) return [];

  const fields = [
    "ad_id",
    "ad_name",
    "adset_id",
    "adset_name",
    "campaign_id",
    "campaign_name",
    "objective",
    "impressions",
    "clicks",
    "spend",
    "ctr",
    "frequency",
    "actions",
    "cost_per_action_type",
  ].join(",");

  const timeRange = encodeURIComponent(
    JSON.stringify({ since: sinceIso.slice(0, 10), until: untilIso.slice(0, 10) })
  );

  const url =
    `https://graph.facebook.com/${META_GRAPH_VERSION}/${accountId}/insights` +
    `?level=ad&fields=${fields}&time_range=${timeRange}&limit=200&access_token=${token}`;

  const res = await fetch(url);
  if (!res.ok) {
    const body = await res.text().catch(() => "<no body>");
    throw new Error(`Meta insights failed ${res.status}: ${body}`);
  }
  const json = (await res.json()) as { data?: MetaInsightsRow[] };
  const rows = json.data ?? [];
  if (rows.length === 0) return [];

  // Hydrate status for each ad in one batch call so we know what's
  // already paused and don't try to pause it again.
  const adIds = rows.map((r) => r.ad_id).filter(Boolean) as string[];
  const statusMap = new Map<string, MetaAdRow>();
  if (adIds.length) {
    const batchUrl =
      `https://graph.facebook.com/${META_GRAPH_VERSION}/?ids=${adIds.join(",")}` +
      `&fields=id,status,effective_status&access_token=${token}`;
    const sRes = await fetch(batchUrl);
    if (sRes.ok) {
      const sJson = (await sRes.json()) as Record<string, MetaAdRow>;
      for (const id of adIds) {
        const row = sJson[id];
        if (row) statusMap.set(id, row);
      }
    }
  }

  return rows.map((r) => {
    const impressions = Number(r.impressions ?? 0);
    const clicks = Number(r.clicks ?? 0);
    const spend = Number(r.spend ?? 0);
    const ctr = Number(r.ctr ?? 0);
    const frequency = Number(r.frequency ?? 0);
    const leads = pickLeadsFromActions(r.actions);
    const adId = r.ad_id ?? "";
    const status = statusMap.get(adId);
    return {
      ad_id: adId,
      ad_name: r.ad_name ?? "",
      adset_id: r.adset_id ?? "",
      adset_name: r.adset_name ?? "",
      campaign_id: r.campaign_id ?? "",
      campaign_name: r.campaign_name ?? "",
      objective: r.objective ?? null,
      status: status?.status ?? null,
      effective_status: status?.effective_status ?? null,
      impressions,
      clicks,
      spend,
      leads,
      ctr,
      cpl: leads > 0 ? spend / leads : null,
      frequency,
    };
  });
}

// ─── Diagnose ────────────────────────────────────────────────────────────

export function diagnosePages(pages: PageStats[]): Finding[] {
  const findings: Finding[] = [];

  for (const p of pages) {
    if (p.sessions < THRESHOLDS.pageMinSessions) continue;

    const signupRate = (p.signups / p.sessions) * 100;
    const bounceRate = (p.singleEventSessions / p.sessions) * 100;
    const hasAnyConversion = p.signups + p.checkouts > 0;
    const adShortRate =
      p.adSessions > 0 ? (p.adShortSessions / p.adSessions) * 100 : 0;

    const snapshot = {
      sessions: p.sessions,
      pageViews: p.pageViews,
      signups: p.signups,
      checkouts: p.checkouts,
      lineClicks: p.lineClicks,
      signupRatePct: Number(signupRate.toFixed(2)),
      bounceRatePct: Number(bounceRate.toFixed(2)),
      adSessions: p.adSessions,
      adShortRatePct: Number(adShortRate.toFixed(2)),
      adTopSource: p.adTopSource,
    };

    // ad_landing_mismatch — paid visitors arrive and leave within seconds.
    // The page isn't the suspect here: the ad promised something the landing
    // doesn't show, or the placement collects mis-taps (Story CTR ≫ 6%).
    // Reported instead of page_no_conversion so nobody rewrites the page.
    if (
      p.adSessions >= THRESHOLDS.pageAdLandingMinSessions &&
      adShortRate >= THRESHOLDS.pageAdLandingShortRatePct
    ) {
      findings.push({
        severity: "critical",
        category: "ad_landing_mismatch",
        entityType: "page",
        entityId: p.path,
        entityLabel: p.adTopSource ?? undefined,
        metricSnapshot: snapshot,
        recommendation:
          `โฆษณา${p.adTopSource ? ` (${p.adTopSource})` : ""} ส่งคนมาหน้า ${p.path} ${p.adSessions} sessions ` +
          `แต่ ${adShortRate.toFixed(0)}% ออกภายใน ${THRESHOLDS.shortSessionSecs} วินาที — ` +
          `เป็นปัญหาฝั่งโฆษณา ไม่ใช่หน้าเว็บ: เช็กว่า landing ตรงกับคำโฆษณาไหม, ` +
          `placement Story/Reels แตะพลาดหรือเปล่า (CTR สูงผิดปกติ), ลอง optimize เป็น Landing Page Views`,
      });
      continue;
    }

    if (
      p.sessions >= THRESHOLDS.pageNoConversionMinSessions &&
      !hasAnyConversion
    ) {
      findings.push({
        severity: "critical",
        category: "page_no_conversion",
        entityType: "page",
        entityId: p.path,
        metricSnapshot: snapshot,
        recommendation:
          `คนที่เข้าเว็บผ่านหน้า ${p.path} ${p.sessions} sessions ไม่มีใครสมัครหรือ checkout เลย` +
          `${p.adSessions > 0 ? ` (จากโฆษณา ${p.adSessions})` : ""} — ` +
          `เช็ก CTA, ฟอร์มสมัคร, และตัวพิกเซลของหน้านี้`,
      });
      continue;
    }

    if (signupRate < THRESHOLDS.pageLowSignupRatePct) {
      findings.push({
        severity: "warn",
        category: "page_low_signup",
        entityType: "page",
        entityId: p.path,
        metricSnapshot: snapshot,
        recommendation:
          `Signup rate ${signupRate.toFixed(2)}% ต่ำกว่า ${THRESHOLDS.pageLowSignupRatePct}% — ` +
          `ลองปรับ headline / ตำแหน่ง CTA / proof point ด้านบน fold`,
      });
    }

    if (bounceRate > THRESHOLDS.pageHighBounceRatePct) {
      findings.push({
        severity: "warn",
        category: "page_high_bounce",
        entityType: "page",
        entityId: p.path,
        metricSnapshot: snapshot,
        recommendation:
          `Bounce ~${bounceRate.toFixed(0)}% — โหลดช้า / hero ไม่ตรง intent ของโฆษณา?`,
      });
    }

    if (
      p.sessions >= THRESHOLDS.pageLineCtaMinSessions &&
      p.lineClicks === 0
    ) {
      findings.push({
        severity: "warn",
        category: "page_low_line_cta",
        entityType: "page",
        entityId: p.path,
        metricSnapshot: snapshot,
        recommendation:
          `หน้า ${p.path} มี ${p.sessions} sessions แต่ไม่มีใครกดปุ่ม LINE เลย — ` +
          `เพิ่ม/ดันปุ่มแอดเพื่อน LINE OA (https://line.me/R/ti/p/@901nmwcd) ให้เด่นเหนือ fold ` +
          `พร้อม benefit ชัดๆ เช่น "แอด LINE รับข้อสอบฟรีทุกเช้า"`,
      });
    }

    if (
      p.sessions >= THRESHOLDS.pageLowCheckoutMinSessions &&
      p.signups > 0 &&
      p.checkouts === 0
    ) {
      findings.push({
        severity: "warn",
        category: "page_low_checkout",
        entityType: "page",
        entityId: p.path,
        metricSnapshot: snapshot,
        recommendation:
          `หน้า ${p.path}: มีคนสมัคร ${p.signups} แต่ยังไม่มีใคร checkout เลย — ` +
          `เน้นปุ่มซื้อ/อัปเกรดให้ชัด, โชว์ราคา/ส่วนลด หรือ social proof ใกล้ปุ่มซื้อ`,
      });
    }
  }

  return findings;
}

// Objectives whose ads are legitimately judged on lead/conversion volume.
// Traffic / awareness / engagement objectives don't produce "leads" by
// design, so the no-lead auto-pause must never touch them — that rule was
// what kept killing the Morroo traffic campaign. An unknown objective falls
// back to the original behaviour (treated as lead-bearing).
const LEAD_OBJECTIVES = new Set([
  "OUTCOME_LEADS",
  "OUTCOME_SALES",
  "CONVERSIONS",
  "LEAD_GENERATION",
  "PRODUCT_CATALOG_SALES",
  "OUTCOME_APP_PROMOTION",
  "APP_INSTALLS",
  "MOBILE_APP_INSTALLS",
]);

export function diagnoseAds(ads: AdInsight[]): Finding[] {
  const findings: Finding[] = [];

  for (const ad of ads) {
    if (ad.spend < THRESHOLDS.adMinSpendThb) continue;
    const isLeadObjective =
      ad.objective == null || LEAD_OBJECTIVES.has(ad.objective);
    const alreadyPaused =
      ad.status === "PAUSED" ||
      ad.effective_status === "PAUSED" ||
      ad.effective_status === "ARCHIVED";

    const snapshot = {
      ad_name: ad.ad_name,
      campaign: ad.campaign_name,
      impressions: ad.impressions,
      clicks: ad.clicks,
      spend: Number(ad.spend.toFixed(2)),
      leads: ad.leads,
      ctrPct: Number(ad.ctr.toFixed(3)),
      cplThb: ad.cpl != null ? Number(ad.cpl.toFixed(2)) : null,
      frequency: Number(ad.frequency.toFixed(2)),
      status: ad.status,
    };

    // ad_no_lead_high_spend — strongest signal, auto-pause. Only for
    // lead/conversion objectives; traffic & awareness ads have no leads to
    // count and must not be paused on this basis.
    if (
      isLeadObjective &&
      ad.leads === 0 &&
      ad.spend >= THRESHOLDS.adNoLeadSpendCeilingThb
    ) {
      findings.push({
        severity: "critical",
        category: "ad_no_lead_high_spend",
        entityType: "ad",
        entityId: ad.ad_id,
        entityLabel: ad.ad_name,
        metricSnapshot: snapshot,
        recommendation:
          `ใช้ไป ${ad.spend.toFixed(0)} ฿ ไม่ได้ lead เลย — pause auto`,
        autoAction: alreadyPaused
          ? undefined
          : {
              action: "pause_ad",
              entityType: "ad",
              entityId: ad.ad_id,
              reason: `spend ${ad.spend.toFixed(0)} THB / 0 leads`,
            },
      });
      continue;
    }

    // ad_high_cpl
    if (ad.cpl != null && ad.cpl > THRESHOLDS.adHighCplThb) {
      findings.push({
        severity: "critical",
        category: "ad_high_cpl",
        entityType: "ad",
        entityId: ad.ad_id,
        entityLabel: ad.ad_name,
        metricSnapshot: snapshot,
        recommendation:
          `CPL ${ad.cpl.toFixed(0)} ฿ > เพดาน ${THRESHOLDS.adHighCplThb} ฿ — pause auto`,
        autoAction: alreadyPaused
          ? undefined
          : {
              action: "pause_ad",
              entityType: "ad",
              entityId: ad.ad_id,
              reason: `CPL ${ad.cpl.toFixed(0)} THB`,
            },
      });
      continue;
    }

    // ad_low_ctr — warn first, auto-pause only if egregious
    if (
      ad.impressions >= THRESHOLDS.adLowCtrMinImpressions &&
      ad.ctr < THRESHOLDS.adLowCtrPct
    ) {
      const shouldAutoPause =
        ad.impressions >= THRESHOLDS.adAutoPauseMinImpressions &&
        ad.ctr < THRESHOLDS.adAutoPauseCtrPct;
      findings.push({
        severity: shouldAutoPause ? "critical" : "warn",
        category: "ad_low_ctr",
        entityType: "ad",
        entityId: ad.ad_id,
        entityLabel: ad.ad_name,
        metricSnapshot: snapshot,
        recommendation: shouldAutoPause
          ? `CTR ${ad.ctr.toFixed(2)}% ที่ ${ad.impressions.toLocaleString()} imp — pause auto`
          : `CTR ${ad.ctr.toFixed(2)}% ต่ำกว่า ${THRESHOLDS.adLowCtrPct}% — เปลี่ยน hook/รูป`,
        autoAction:
          shouldAutoPause && !alreadyPaused
            ? {
                action: "pause_ad",
                entityType: "ad",
                entityId: ad.ad_id,
                reason: `CTR ${ad.ctr.toFixed(2)}%`,
              }
            : undefined,
      });
    }

    // ad_high_frequency — warn only, never auto-act
    if (ad.frequency >= THRESHOLDS.adHighFrequency) {
      findings.push({
        severity: "warn",
        category: "ad_high_frequency",
        entityType: "ad",
        entityId: ad.ad_id,
        entityLabel: ad.ad_name,
        metricSnapshot: snapshot,
        recommendation:
          `Frequency ${ad.frequency.toFixed(1)} — creative fatigue, ทำเวอร์ชันใหม่`,
      });
    }
  }

  return findings;
}

// ─── Auto-actions ────────────────────────────────────────────────────────

export interface AutoActionResult {
  request: AutoActionRequest;
  ok: boolean;
  priorState: { status?: string; effective_status?: string } | null;
  result: unknown;
  error?: string;
}

async function fetchEntityState(
  entityId: string,
  token: string
): Promise<{ status?: string; effective_status?: string } | null> {
  const res = await fetch(
    `https://graph.facebook.com/${META_GRAPH_VERSION}/${entityId}` +
      `?fields=status,effective_status&access_token=${token}`
  );
  if (!res.ok) return null;
  return (await res.json()) as { status?: string; effective_status?: string };
}

async function pauseEntity(
  entityId: string,
  token: string
): Promise<{ ok: boolean; result: unknown; error?: string }> {
  const res = await fetch(
    `https://graph.facebook.com/${META_GRAPH_VERSION}/${entityId}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: "PAUSED", access_token: token }),
    }
  );
  const body = (await res.json().catch(() => ({}))) as unknown;
  if (!res.ok) {
    return { ok: false, result: body, error: `HTTP ${res.status}` };
  }
  return { ok: true, result: body };
}

export async function executeAutoActions(
  requests: AutoActionRequest[]
): Promise<AutoActionResult[]> {
  if (requests.length === 0) return [];
  const token = await getLatestUserToken();
  if (!token) {
    return requests.map((r) => ({
      request: r,
      ok: false,
      priorState: null,
      result: null,
      error: "no Meta token",
    }));
  }

  const results: AutoActionResult[] = [];
  for (const req of requests) {
    const prior = await fetchEntityState(req.entityId, token);
    if (prior?.status === "PAUSED") {
      results.push({
        request: req,
        ok: true,
        priorState: prior,
        result: { skipped: "already paused" },
      });
      continue;
    }
    const { ok, result, error } = await pauseEntity(req.entityId, token);
    results.push({ request: req, ok, priorState: prior, result, error });
  }
  return results;
}
