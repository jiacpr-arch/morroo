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
  | "page_low_signup"
  | "page_high_bounce"
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

export interface PageStats {
  path: string;
  sessions: number;
  pageViews: number;
  singleEventSessions: number;
  signups: number;
  examStarts: number;
  checkouts: number;
}

export interface AdInsight {
  ad_id: string;
  ad_name: string;
  adset_id: string;
  adset_name: string;
  campaign_id: string;
  campaign_name: string;
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
};

const FUNNEL_EVENTS = new Set([
  "pageview",
  "signup_submit",
  "exam_start_click",
  "stripe_checkout_click",
]);

/** Top-level path bucket (`/lp/foo/bar` → `/lp/foo`). Keeps cardinality sane. */
function bucketPath(path: string): string {
  const clean = path.split("?")[0] || "/";
  const segments = clean.split("/").filter(Boolean);
  if (segments.length === 0) return "/";
  if (segments.length === 1) return `/${segments[0]}`;
  return `/${segments[0]}/${segments[1]}`;
}

export async function fetchPageStats(
  supabase: SupabaseClient,
  sinceIso: string
): Promise<PageStats[]> {
  const { data, error } = await supabase
    .from("analytics_events")
    .select("event_name, session_id, path")
    .gte("created_at", sinceIso)
    .in("event_name", Array.from(FUNNEL_EVENTS))
    .limit(100000);

  if (error) throw new Error(`fetchPageStats: ${error.message}`);

  type Bucket = {
    path: string;
    sessions: Set<string>;
    pageViews: number;
    signups: number;
    examStarts: number;
    checkouts: number;
    sessionEventCount: Map<string, number>;
  };
  const buckets = new Map<string, Bucket>();

  for (const row of (data as RawEventRow[] | null) ?? []) {
    if (!row.path) continue;
    const bucket = bucketPath(row.path);
    let entry = buckets.get(bucket);
    if (!entry) {
      entry = {
        path: bucket,
        sessions: new Set(),
        pageViews: 0,
        signups: 0,
        examStarts: 0,
        checkouts: 0,
        sessionEventCount: new Map(),
      };
      buckets.set(bucket, entry);
    }
    if (row.session_id) {
      entry.sessions.add(row.session_id);
      entry.sessionEventCount.set(
        row.session_id,
        (entry.sessionEventCount.get(row.session_id) ?? 0) + 1
      );
    }
    switch (row.event_name) {
      case "pageview":
        entry.pageViews += 1;
        break;
      case "signup_submit":
        entry.signups += 1;
        break;
      case "exam_start_click":
        entry.examStarts += 1;
        break;
      case "stripe_checkout_click":
        entry.checkouts += 1;
        break;
    }
  }

  return Array.from(buckets.values()).map((b) => {
    let singleEventSessions = 0;
    for (const count of b.sessionEventCount.values()) {
      if (count <= 1) singleEventSessions += 1;
    }
    return {
      path: b.path,
      sessions: b.sessions.size,
      pageViews: b.pageViews,
      singleEventSessions,
      signups: b.signups,
      examStarts: b.examStarts,
      checkouts: b.checkouts,
    };
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
  const priority = ["lead", "onsite_conversion.lead_grouped", "complete_registration"];
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

    const snapshot = {
      sessions: p.sessions,
      pageViews: p.pageViews,
      signups: p.signups,
      checkouts: p.checkouts,
      signupRatePct: Number(signupRate.toFixed(2)),
      bounceRatePct: Number(bounceRate.toFixed(2)),
    };

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
          `หน้า ${p.path} มี ${p.sessions} sessions แต่ 0 conversion เลย — ` +
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
  }

  return findings;
}

export function diagnoseAds(ads: AdInsight[]): Finding[] {
  const findings: Finding[] = [];

  for (const ad of ads) {
    if (ad.spend < THRESHOLDS.adMinSpendThb) continue;
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

    // ad_no_lead_high_spend — strongest signal, auto-pause
    if (ad.leads === 0 && ad.spend >= THRESHOLDS.adNoLeadSpendCeilingThb) {
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
