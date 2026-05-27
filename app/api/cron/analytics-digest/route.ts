/**
 * Weekly analytics digest — pushes a Flex summary to the admin's LINE.
 *
 * Reads from analytics_events (mirrored copy of @vercel/analytics events,
 * see /api/analytics/track). Covers the trailing 7 days.
 *
 * Auth: Vercel Cron injects `Authorization: Bearer $CRON_SECRET`.
 * External callers can use `?secret=$BLOG_GENERATE_SECRET`.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { buildAnalyticsDigestFlex } from "@/lib/line-flex-templates";

export const runtime = "nodejs";
export const maxDuration = 30;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  ) {
    return true;
  }
  return false;
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
  const bangkok = (d: Date) =>
    new Date(d.getTime() + 7 * 60 * 60 * 1000);
  const s = bangkok(start);
  const e = bangkok(end);
  const month = s.toLocaleDateString("th-TH", { month: "short", timeZone: "UTC" });
  const year = s.toLocaleDateString("th-TH", { year: "numeric", timeZone: "UTC" });
  return `${s.getUTCDate()}–${e.getUTCDate()} ${month} ${year}`;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const adminLineId = process.env.ADMIN_LINE_USER_ID;
  if (!adminLineId) {
    return NextResponse.json(
      { error: "ADMIN_LINE_USER_ID not configured" },
      { status: 500 }
    );
  }

  const now = new Date();
  const start = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("analytics_events")
    .select("event_name,session_id,path,referrer")
    .gte("created_at", start.toISOString())
    .lte("created_at", now.toISOString())
    .limit(50000);

  if (error) {
    return NextResponse.json({ ok: false, error: error.message }, { status: 500 });
  }

  const agg = aggregate((data as EventRow[] | null) ?? []);

  const flex = buildAnalyticsDigestFlex({
    rangeLabel: rangeLabel(start, now),
    pageViews: agg.pageViews,
    uniqueVisitors: agg.uniqueVisitors,
    signups: agg.signups,
    examStarts: agg.examStarts,
    checkoutClicks: agg.checkoutClicks,
    socialLineClicks: agg.socialLineClicks,
    topPath: agg.topPath,
    topReferrer: agg.topReferrer,
    signupConversion: ratio(agg.signups, agg.uniqueVisitors),
    checkoutConversion: ratio(agg.checkoutClicks, agg.signups),
  });

  const ok = await sendLineMessage(adminLineId, [flex]);

  return NextResponse.json({ ok, snapshot: agg });
}
