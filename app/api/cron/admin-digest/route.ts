/**
 * Daily admin digest cron — pushes a Flex summary to the admin's LINE.
 *
 * Snapshot for today (Asia/Bangkok day window, computed in SQL via NOW()):
 *  - attempts, active users, avg accuracy, new users, revenue
 *  - all-time totals (students, 7d actives, weakest subject)
 *  - AI grading failure count in the last 24h (from Sentry-free signal:
 *    we count via a lightweight `_ai_grade_errors` view if present;
 *    otherwise reports 0)
 *
 * Auth: Vercel Cron injects `Authorization: Bearer $CRON_SECRET`.
 * External callers can use `?secret=$BLOG_GENERATE_SECRET`.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { buildAdminDigestFlex } from "@/lib/line-flex-templates";
import { buildMarketingSnapshot } from "@/lib/marketing-digest";

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

  const supabase = createAdminClient();

  // Day window in Asia/Bangkok (UTC+7) so "today" matches the admin's locale.
  const now = new Date();
  const bangkokOffsetMs = 7 * 60 * 60 * 1000;
  const bangkokNow = new Date(now.getTime() + bangkokOffsetMs);
  const dayStartBangkok = new Date(
    Date.UTC(
      bangkokNow.getUTCFullYear(),
      bangkokNow.getUTCMonth(),
      bangkokNow.getUTCDate()
    )
  );
  // Convert back to UTC ISO for SQL comparisons (treat as start of Bangkok day in UTC terms).
  const dayStartUtc = new Date(
    dayStartBangkok.getTime() - bangkokOffsetMs
  ).toISOString();

  const last24hUtc = new Date(now.getTime() - 24 * 60 * 60 * 1000).toISOString();

  const dateLabel = bangkokNow.toLocaleDateString("th-TH", {
    weekday: "short",
    day: "numeric",
    month: "short",
    year: "numeric",
    timeZone: "UTC", // bangkokNow is already shifted
  });

  // --- Today: attempts + accuracy + active users ---
  const todayAttemptsRes = await supabase
    .from("mcq_attempts")
    .select("user_id,is_correct", { count: "exact" })
    .gte("created_at", dayStartUtc);

  const todayRows =
    (todayAttemptsRes.data as { user_id: string; is_correct: boolean }[] | null) ??
    [];
  const attemptsToday = todayAttemptsRes.count ?? todayRows.length;
  const activeUsersToday = new Set(todayRows.map((r) => r.user_id)).size;
  const correctToday = todayRows.filter((r) => r.is_correct).length;
  const avgAccuracyToday =
    todayRows.length > 0
      ? Math.round((correctToday * 1000) / todayRows.length) / 10
      : null;

  // --- Today: new users ---
  const newUsersRes = await supabase
    .from("profiles")
    .select("id", { count: "exact", head: true })
    .gte("created_at", dayStartUtc);
  const newUsersToday = newUsersRes.count ?? 0;

  // --- Today: revenue (approved orders) ---
  const ordersRes = await supabase
    .from("payment_orders")
    .select("amount")
    .eq("status", "approved")
    .gte("reviewed_at", dayStartUtc);
  const orderRows = (ordersRes.data as { amount: number }[] | null) ?? [];
  const revenueTodayThb = orderRows.reduce(
    (sum, o) => sum + Number(o.amount || 0),
    0
  );

  // --- Overall stats via existing RPC ---
  const overallRes = await supabase.rpc("get_admin_overall_stats");
  const overall = Array.isArray(overallRes.data)
    ? (overallRes.data[0] as
        | {
            total_students: number;
            active_students_7d: number;
            weakest_subject_name_th: string | null;
            weakest_subject_icon: string | null;
          }
        | undefined)
    : undefined;

  // --- AI grading failures in last 24h (optional table, ignored if missing) ---
  let aiGradeFails24h = 0;
  try {
    const failRes = await supabase
      .from("_ai_grade_errors")
      .select("id", { count: "exact", head: true })
      .gte("created_at", last24hUtc);
    aiGradeFails24h = failRes.count ?? 0;
  } catch {
    // table doesn't exist — leave at 0
  }

  const weakestSubject =
    overall?.weakest_subject_name_th
      ? `${overall.weakest_subject_icon ?? ""} ${overall.weakest_subject_name_th}`.trim()
      : null;

  // Marketing snapshot — yesterday's Bangkok day vs the day before.
  // Failures here shouldn't block the student digest, so swallow errors.
  let marketing = null;
  try {
    marketing = await buildMarketingSnapshot(supabase, now);
  } catch (err) {
    console.error("[admin-digest] marketing snapshot failed:", err);
  }

  const flex = buildAdminDigestFlex({
    dateLabel,
    attemptsToday,
    activeUsersToday,
    newUsersToday,
    avgAccuracyToday,
    totalStudents: Number(overall?.total_students ?? 0),
    activeUsers7d: Number(overall?.active_students_7d ?? 0),
    weakestSubject,
    aiGradeFails24h,
    revenueTodayThb: revenueTodayThb > 0 ? revenueTodayThb : null,
    marketing,
  });

  const ok = await sendLineMessage(adminLineId, [flex]);

  return NextResponse.json({
    ok,
    snapshot: {
      dateLabel,
      attemptsToday,
      activeUsersToday,
      newUsersToday,
      avgAccuracyToday,
      revenueTodayThb,
      totalStudents: Number(overall?.total_students ?? 0),
      activeUsers7d: Number(overall?.active_students_7d ?? 0),
      weakestSubject,
      aiGradeFails24h,
      marketing,
    },
  });
}
