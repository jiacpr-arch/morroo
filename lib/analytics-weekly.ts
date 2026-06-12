/**
 * Trailing-7-day analytics summary — aggregated from analytics_events
 * (mirrored copy of @vercel/analytics events, see /api/analytics/track).
 *
 * Used by the Monday edition of the admin daily digest
 * (/api/cron/admin-digest), which absorbed the old standalone
 * analytics-digest cron so the admin gets one LINE push per day.
 */

import type { SupabaseClient } from "@supabase/supabase-js";

export interface WeeklyAnalyticsSummary {
  rangeLabel: string; // e.g. "15–21 พ.ค. 2026"
  pageViews: number;
  uniqueVisitors: number;
  signups: number;
  examStarts: number;
  checkoutClicks: number;
  socialLineClicks: number;
  topPath: { path: string; count: number } | null;
  topReferrer: { ref: string; count: number } | null;
  signupConversion: number | null; // signups / unique visitors %
  checkoutConversion: number | null; // checkouts / signups %
}

type EventRow = {
  event_name: string;
  session_id: string | null;
  path: string | null;
  referrer: string | null;
};

const FUNNEL = {
  pageview: "pageview",
  signup: "signup_submit",
  examStart: "exam_start_click",
  checkout: "stripe_checkout_click",
} as const;

function aggregate(rows: EventRow[]) {
  let pageViews = 0;
  let signups = 0;
  let examStarts = 0;
  let checkoutClicks = 0;
  let socialLineClicks = 0;

  const sessions = new Set<string>();
  const pathCounts = new Map<string, number>();
  const refCounts = new Map<string, number>();

  for (const r of rows) {
    if (r.session_id) sessions.add(r.session_id);

    switch (r.event_name) {
      case FUNNEL.pageview:
        pageViews++;
        if (r.path) pathCounts.set(r.path, (pathCounts.get(r.path) ?? 0) + 1);
        if (r.referrer) {
          const host = hostnameOf(r.referrer);
          if (host) refCounts.set(host, (refCounts.get(host) ?? 0) + 1);
        }
        break;
      case FUNNEL.signup:
        signups++;
        break;
      case FUNNEL.examStart:
        examStarts++;
        break;
      case FUNNEL.checkout:
        checkoutClicks++;
        break;
      case "social_click":
        socialLineClicks++;
        break;
    }
  }

  const topPath = pickTop(pathCounts);
  const topRef = pickTop(refCounts);

  return {
    pageViews,
    uniqueVisitors: sessions.size,
    signups,
    examStarts,
    checkoutClicks,
    socialLineClicks,
    topPath: topPath ? { path: topPath[0], count: topPath[1] } : null,
    topReferrer: topRef ? { ref: topRef[0], count: topRef[1] } : null,
  };
}

function hostnameOf(url: string): string | null {
  try {
    return new URL(url).hostname.replace(/^www\./, "");
  } catch {
    return null;
  }
}

function pickTop(counts: Map<string, number>): [string, number] | null {
  let best: [string, number] | null = null;
  for (const entry of counts.entries()) {
    if (!best || entry[1] > best[1]) best = entry;
  }
  return best;
}

function ratio(num: number, denom: number): number | null {
  if (denom <= 0) return null;
  return (num / denom) * 100;
}

function rangeLabel(start: Date, end: Date): string {
  const bangkok = (d: Date) => new Date(d.getTime() + 7 * 60 * 60 * 1000);
  const s = bangkok(start);
  const e = bangkok(end);
  const month = s.toLocaleDateString("th-TH", { month: "short", timeZone: "UTC" });
  const year = s.toLocaleDateString("th-TH", { year: "numeric", timeZone: "UTC" });
  return `${s.getUTCDate()}–${e.getUTCDate()} ${month} ${year}`;
}

export async function fetchWeeklyAnalytics(
  supabase: SupabaseClient,
  now: Date
): Promise<WeeklyAnalyticsSummary> {
  const start = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  const { data, error } = await supabase
    .from("analytics_events")
    .select("event_name,session_id,path,referrer")
    .gte("created_at", start.toISOString())
    .lte("created_at", now.toISOString())
    .limit(50000);
  if (error) throw new Error(error.message);

  const agg = aggregate((data as EventRow[] | null) ?? []);

  return {
    rangeLabel: rangeLabel(start, now),
    ...agg,
    signupConversion: ratio(agg.signups, agg.uniqueVisitors),
    checkoutConversion: ratio(agg.checkoutClicks, agg.signups),
  };
}
