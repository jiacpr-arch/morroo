/**
 * Marketing daily snapshot — reads analytics_events for yesterday's
 * Bangkok day window and the day before, then computes visitor, bounce,
 * social-click, conversion, A/B Hero, and traffic-source numbers along
 * with simple alert rules.
 *
 * Used by /api/cron/admin-digest to append a Marketing section to the
 * daily LINE Flex digest.
 */

import type { SupabaseClient } from "@supabase/supabase-js";

export interface MarketingSnapshot {
  dateLabel: string;
  visitors: number;
  visitorsDelta: number | null;
  bounceRate: number | null;
  engagedSessions: number;
  lineClicks: number;
  lineClicksDelta: number | null;
  formSubmits: number;
  conversionRate: number | null;
  pricingViewers: number;
  pricingViewRate: number | null;
  heroAB: {
    a: { views: number; converts: number; rate: number | null };
    b: { views: number; converts: number; rate: number | null };
  };
  topSources: { name: string; clicks: number; forms: number; conv: number }[];
  alerts: string[];
}

const BKK_OFFSET_MS = 7 * 60 * 60 * 1000;

type EventRow = {
  event_name: string;
  session_id: string | null;
  path: string | null;
  referrer: string | null;
  properties: Record<string, unknown> | null;
};

export function bangkokDayWindow(reference: Date, daysAgo: number) {
  const bkk = new Date(reference.getTime() + BKK_OFFSET_MS);
  const dayStartBkk = new Date(
    Date.UTC(
      bkk.getUTCFullYear(),
      bkk.getUTCMonth(),
      bkk.getUTCDate() - daysAgo
    )
  );
  const dayEndBkk = new Date(dayStartBkk.getTime() + 24 * 60 * 60 * 1000);
  return {
    startUtc: new Date(dayStartBkk.getTime() - BKK_OFFSET_MS),
    endUtc: new Date(dayEndBkk.getTime() - BKK_OFFSET_MS),
    label: formatBangkokDate(dayStartBkk),
  };
}

function formatBangkokDate(dayStartBkk: Date): string {
  // dayStartBkk is built from Date.UTC so its UTC fields hold Bangkok components.
  const y = dayStartBkk.getUTCFullYear();
  const m = String(dayStartBkk.getUTCMonth() + 1).padStart(2, "0");
  const d = String(dayStartBkk.getUTCDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
}

function hostnameOf(url: string): string | null {
  try {
    return new URL(url).hostname.replace(/^www\./, "");
  } catch {
    return null;
  }
}

function sourceOf(referrer: string | null): string {
  if (!referrer) return "direct";
  const host = hostnameOf(referrer);
  if (!host) return "direct";
  if (host.includes("google")) return "google";
  if (host.includes("facebook") || host.includes("fb.com")) return "facebook";
  if (host.includes("instagram")) return "instagram";
  if (host.includes("line")) return "line";
  if (host.includes("tiktok")) return "tiktok";
  if (host.includes("youtube")) return "youtube";
  if (host.includes("twitter") || host === "t.co" || host === "x.com")
    return "x";
  return host;
}

function pctChange(curr: number, prev: number): number | null {
  if (prev === 0) return curr === 0 ? 0 : null;
  return ((curr - prev) / prev) * 100;
}

interface Aggregated {
  sessions: Set<string>;
  pageviewsBySession: Map<string, number>;
  eventsBySession: Map<string, number>;
  lineClicks: number;
  formSubmitSessions: Set<string>;
  pricingViewSessions: Set<string>;
  heroViewsBySession: Map<string, "A" | "B">;
  heroConvertSessions: { A: Set<string>; B: Set<string> };
  sessionSource: Map<string, string>;
  // For source breakdown
  sourceLineClicks: Map<string, number>;
  sourceFormSubmits: Map<string, Set<string>>;
  sourceVisitors: Map<string, Set<string>>;
}

function freshAgg(): Aggregated {
  return {
    sessions: new Set(),
    pageviewsBySession: new Map(),
    eventsBySession: new Map(),
    lineClicks: 0,
    formSubmitSessions: new Set(),
    pricingViewSessions: new Set(),
    heroViewsBySession: new Map(),
    heroConvertSessions: { A: new Set(), B: new Set() },
    sessionSource: new Map(),
    sourceLineClicks: new Map(),
    sourceFormSubmits: new Map(),
    sourceVisitors: new Map(),
  };
}

function variantOf(properties: Record<string, unknown> | null): "A" | "B" | null {
  const v = properties?.variant;
  return v === "A" || v === "B" ? v : null;
}

function platformOf(properties: Record<string, unknown> | null): string | null {
  const p = properties?.platform;
  return typeof p === "string" ? p : null;
}

function aggregate(rows: EventRow[]): Aggregated {
  const agg = freshAgg();
  for (const r of rows) {
    if (!r.session_id) continue;
    agg.sessions.add(r.session_id);
    agg.eventsBySession.set(
      r.session_id,
      (agg.eventsBySession.get(r.session_id) ?? 0) + 1
    );

    if (!agg.sessionSource.has(r.session_id) && r.event_name === "pageview") {
      agg.sessionSource.set(r.session_id, sourceOf(r.referrer));
    }

    switch (r.event_name) {
      case "pageview":
        agg.pageviewsBySession.set(
          r.session_id,
          (agg.pageviewsBySession.get(r.session_id) ?? 0) + 1
        );
        break;
      case "social_click":
        if (platformOf(r.properties) === "line") {
          agg.lineClicks++;
          const src = agg.sessionSource.get(r.session_id) ?? "direct";
          agg.sourceLineClicks.set(
            src,
            (agg.sourceLineClicks.get(src) ?? 0) + 1
          );
        }
        break;
      case "signup_submit":
        agg.formSubmitSessions.add(r.session_id);
        break;
      case "pricing_view":
        agg.pricingViewSessions.add(r.session_id);
        break;
      case "hero_variant_view": {
        const v = variantOf(r.properties);
        if (v) agg.heroViewsBySession.set(r.session_id, v);
        break;
      }
      case "hero_variant_convert": {
        const v = variantOf(r.properties);
        if (v) agg.heroConvertSessions[v].add(r.session_id);
        break;
      }
    }
  }

  for (const sid of agg.sessions) {
    const src = agg.sessionSource.get(sid) ?? "direct";
    if (!agg.sourceVisitors.has(src)) agg.sourceVisitors.set(src, new Set());
    agg.sourceVisitors.get(src)!.add(sid);
  }
  for (const sid of agg.formSubmitSessions) {
    const src = agg.sessionSource.get(sid) ?? "direct";
    if (!agg.sourceFormSubmits.has(src))
      agg.sourceFormSubmits.set(src, new Set());
    agg.sourceFormSubmits.get(src)!.add(sid);
  }

  return agg;
}

function topSources(agg: Aggregated, limit = 4) {
  const all = new Set<string>([
    ...agg.sourceVisitors.keys(),
    ...agg.sourceLineClicks.keys(),
    ...agg.sourceFormSubmits.keys(),
  ]);
  const rows = Array.from(all).map((name) => {
    const visitors = agg.sourceVisitors.get(name)?.size ?? 0;
    return {
      name,
      visitors,
      clicks: agg.sourceLineClicks.get(name) ?? 0,
      forms: agg.sourceFormSubmits.get(name)?.size ?? 0,
      // "conv" surfaces hot-source detection (heuristic): any source where
      // form-submit rate beats the global average gets a fire icon.
      conv: 0,
    };
  });
  rows.sort((a, b) => b.visitors - a.visitors || b.clicks - a.clicks);
  const top = rows.slice(0, limit);
  // Mark sources whose visitor-to-form-submit rate is >= 2x the overall.
  const totalVisitors = Array.from(agg.sourceVisitors.values()).reduce(
    (s, set) => s + set.size,
    0
  );
  const totalForms = Array.from(agg.sourceFormSubmits.values()).reduce(
    (s, set) => s + set.size,
    0
  );
  const baseRate = totalVisitors > 0 ? totalForms / totalVisitors : 0;
  return top.map((r) => {
    const visitors = agg.sourceVisitors.get(r.name)?.size ?? 0;
    const rate = visitors > 0 ? r.forms / visitors : 0;
    const hot = baseRate > 0 && rate >= baseRate * 2 && r.forms > 0;
    return { name: r.name, clicks: r.clicks, forms: r.forms, conv: hot ? 1 : 0 };
  });
}

export async function buildMarketingSnapshot(
  supabase: SupabaseClient,
  reference: Date = new Date()
): Promise<MarketingSnapshot> {
  const yesterday = bangkokDayWindow(reference, 1);
  const dayBefore = bangkokDayWindow(reference, 2);

  const [yesterdayRows, dayBeforeRows] = await Promise.all([
    supabase
      .from("analytics_events")
      .select("event_name,session_id,path,referrer,properties")
      .gte("created_at", yesterday.startUtc.toISOString())
      .lt("created_at", yesterday.endUtc.toISOString())
      .limit(50000),
    supabase
      .from("analytics_events")
      .select("event_name,session_id,referrer,properties")
      .gte("created_at", dayBefore.startUtc.toISOString())
      .lt("created_at", dayBefore.endUtc.toISOString())
      .limit(50000),
  ]);

  const yest = aggregate(((yesterdayRows.data as EventRow[] | null) ?? []));
  const prev = aggregate(((dayBeforeRows.data as EventRow[] | null) ?? []));

  const visitors = yest.sessions.size;
  const prevVisitors = prev.sessions.size;

  let engaged = 0;
  for (const sid of yest.sessions) {
    const pvs = yest.pageviewsBySession.get(sid) ?? 0;
    const evts = yest.eventsBySession.get(sid) ?? 0;
    if (pvs > 1 || evts > 1) engaged++;
  }
  const bounceRate =
    visitors > 0 ? ((visitors - engaged) / visitors) * 100 : null;

  const lineClicks = yest.lineClicks;
  const prevLineClicks = prev.lineClicks;

  const formSubmits = yest.formSubmitSessions.size;
  const conversionRate =
    visitors > 0 ? (formSubmits / visitors) * 100 : null;

  const pricingViewers = yest.pricingViewSessions.size;
  const pricingViewRate =
    visitors > 0 ? (pricingViewers / visitors) * 100 : null;

  const heroAViews = Array.from(yest.heroViewsBySession.values()).filter(
    (v) => v === "A"
  ).length;
  const heroBViews = Array.from(yest.heroViewsBySession.values()).filter(
    (v) => v === "B"
  ).length;
  const heroAConv = yest.heroConvertSessions.A.size;
  const heroBConv = yest.heroConvertSessions.B.size;

  const sources = topSources(yest, 4);

  const alerts: string[] = [];
  if (bounceRate != null && bounceRate >= 70) {
    alerts.push(
      `Bounce rate สูง ${bounceRate.toFixed(1)}% (engaged ${engaged}/${visitors}) — hero copy/รูปอาจไม่ดึง`
    );
  }
  const lineDelta = pctChange(lineClicks, prevLineClicks);
  if (lineDelta != null && lineDelta <= -50 && prevLineClicks >= 3) {
    alerts.push(
      `LINE clicks ลดลง ${lineDelta.toFixed(0)}% เทียบเมื่อวานก่อน`
    );
  }
  if (visitors >= 50 && formSubmits === 0) {
    alerts.push(`มีคนเข้าเว็บ ${visitors} คน แต่ไม่มีใครส่งฟอร์มเลย`);
  }

  return {
    dateLabel: yesterday.label,
    visitors,
    visitorsDelta: pctChange(visitors, prevVisitors),
    bounceRate,
    engagedSessions: engaged,
    lineClicks,
    lineClicksDelta: lineDelta,
    formSubmits,
    conversionRate,
    pricingViewers,
    pricingViewRate,
    heroAB: {
      a: {
        views: heroAViews,
        converts: heroAConv,
        rate: heroAViews > 0 ? (heroAConv / heroAViews) * 100 : null,
      },
      b: {
        views: heroBViews,
        converts: heroBConv,
        rate: heroBViews > 0 ? (heroBConv / heroBViews) * 100 : null,
      },
    },
    topSources: sources,
    alerts,
  };
}
