/**
 * Daily admin digest cron — the ONE LINE push the admin gets every morning
 * (08:00 BKK). Everything the overnight pipeline produced is folded in here
 * so the admin is not pinged by each cron separately:
 *
 *  - today (Asia/Bangkok): attempts, active users, accuracy, new users, revenue
 *  - all-time totals (students, 7d actives, weakest subject)
 *  - AI grading failure count in the last 24h
 *  - yesterday's web funnel (marketing snapshot) + Meta ads performance
 *  - overnight ads-ops results: ads-autofix findings/auto-pauses,
 *    post-merge verdicts, and new AI suggest-PRs (the ads crons write to
 *    DB only — this digest is where their results reach LINE). New suggest
 *    PRs are attached as extra bubbles in the SAME push so the
 *    merge/dismiss buttons keep working (LINE allows 5 messages per push).
 *  - autopilot changes (LINE CTA / hero A/B / pricing promo) — run before
 *    the flex is built so they appear inside the digest instead of as
 *    separate text messages
 *  - Mondays: trailing-7-day analytics summary (absorbed the old
 *    analytics-digest cron)
 *
 * Auth: Vercel Cron injects `Authorization: Bearer $CRON_SECRET`.
 * External callers can use `?secret=$BLOG_GENERATE_SECRET`.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, type LineMessage } from "@/lib/line";
import {
  buildAdminDigestFlex,
  buildAdsSuggestFlex,
  type AdsOpsSummary,
} from "@/lib/line-flex-templates";
import { bangkokDayWindow, buildMarketingSnapshot } from "@/lib/marketing-digest";
import { fetchAdInsights } from "@/lib/ads-diagnostics";
import { summarizeAdsDay, type AdsDailySummary } from "@/lib/ads-daily-summary";
import { fetchWeeklyAnalytics, type WeeklyAnalyticsSummary } from "@/lib/analytics-weekly";
import { runLineCtaAutopilot } from "@/lib/line-cta-config";
import { runHeroAutopilot, runPricingPromoAutopilot } from "@/lib/site-config";

export const runtime = "nodejs";
export const maxDuration = 60;

// LINE push API caps a single push at 5 messages: 1 digest + up to 4 cards.
const MAX_SUGGEST_CARDS = 4;

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

  // Ads performance for yesterday's Bangkok day — same optionality as the
  // marketing section: a Meta API failure must not block the digest.
  let adsYesterday: AdsDailySummary | null = null;
  try {
    const yesterday = bangkokDayWindow(now, 1);
    adsYesterday = summarizeAdsDay(
      await fetchAdInsights(yesterday.label, yesterday.label)
    );
  } catch (err) {
    console.error("[admin-digest] ads snapshot failed:", err);
  }

  // --- Overnight ads-ops pipeline results (written by the ads crons) ---
  let adsOps: AdsOpsSummary | null = null;
  const suggestCards: LineMessage[] = [];
  try {
    // Latest ads-autofix diagnostics run in the last 24h.
    const { data: runRows } = await supabase
      .from("ad_diagnostics_runs")
      .select("id, ok, findings_count, actions_count, summary")
      .gte("started_at", last24hUtc)
      .order("started_at", { ascending: false })
      .limit(1);
    let autofix: AdsOpsSummary["autofix"] = null;
    const run = runRows?.[0] as
      | {
          id: number;
          ok: boolean;
          findings_count: number;
          actions_count: number;
          summary: { bySeverity?: { critical?: number } } | null;
        }
      | undefined;
    if (run) {
      const { data: topRows } = await supabase
        .from("ad_diagnostics_findings")
        .select("entity_label, entity_id, recommendation")
        .eq("run_id", run.id)
        .eq("severity", "critical")
        .order("created_at", { ascending: false })
        .limit(2);
      autofix = {
        ok: run.ok,
        findingsCount: run.findings_count,
        critical: run.summary?.bySeverity?.critical ?? topRows?.length ?? 0,
        autoPaused: run.actions_count,
        topIssues: (topRows ?? []).map((f) => ({
          label: (f.entity_label as string | null) ?? (f.entity_id as string),
          recommendation: f.recommendation as string,
        })),
      };
    }

    // Post-merge verdicts resolved in the last 24h (written by ads-postmerge-watch).
    const { data: pmRows } = await supabase
      .from("ad_suggest_prs")
      .select(
        "page_path, pr_number, outcome, revert_pr_number, baseline_metrics, post_merge_metrics"
      )
      .gte("outcome_resolved_at", last24hUtc)
      .not("outcome", "is", null);
    const postMerge = ((pmRows ?? []) as {
      page_path: string;
      pr_number: number;
      outcome: "improved" | "degraded" | "flat";
      revert_pr_number: number | null;
      baseline_metrics: Record<string, unknown> | null;
      post_merge_metrics: Record<string, unknown> | null;
    }[]).map((r) => ({
      pagePath: r.page_path,
      prNumber: r.pr_number,
      outcome: r.outcome,
      revertPrNumber: r.revert_pr_number,
      baselineRate:
        r.baseline_metrics?.signupRatePct != null
          ? Number(r.baseline_metrics.signupRatePct)
          : null,
      currentRate:
        r.post_merge_metrics?.signupRatePct != null
          ? Number(r.post_merge_metrics.signupRatePct)
          : null,
    }));

    // Open suggest PRs: new ones (last 24h) become interactive cards in this
    // push; the rest are counted so stale approvals don't get forgotten.
    const { data: openRows } = await supabase
      .from("ad_suggest_prs")
      .select("finding_id, page_path, pr_number, pr_url, baseline_metrics, created_at")
      .eq("status", "open")
      .order("created_at", { ascending: false });
    const open = ((openRows ?? []) as {
      finding_id: number | null;
      page_path: string;
      pr_number: number;
      pr_url: string;
      baseline_metrics: Record<string, number | string | null>;
      created_at: string;
    }[]);
    const newOpen = open.filter((r) => r.created_at >= last24hUtc);

    const findingIds = newOpen
      .slice(0, MAX_SUGGEST_CARDS)
      .map((r) => r.finding_id)
      .filter((id): id is number => id != null);
    const { data: findingRows } = findingIds.length
      ? await supabase
          .from("ad_diagnostics_findings")
          .select("id, recommendation, severity")
          .in("id", findingIds)
      : { data: [] };
    const findingById = new Map(
      ((findingRows ?? []) as { id: number; recommendation: string; severity: string }[]).map(
        (f) => [f.id, f]
      )
    );

    for (const row of newOpen.slice(0, MAX_SUGGEST_CARDS)) {
      const finding = row.finding_id != null ? findingById.get(row.finding_id) : undefined;
      suggestCards.push(
        buildAdsSuggestFlex({
          pagePath: row.page_path,
          recommendation: finding?.recommendation ?? "AI เสนอปรับหน้านี้เพื่อเพิ่ม conversion",
          severity: finding?.severity ?? "warn",
          prNumber: row.pr_number,
          prUrl: row.pr_url,
          baseline: row.baseline_metrics,
        })
      );
    }

    adsOps = {
      autofix,
      postMerge,
      suggestsNew: newOpen.length,
      suggestsOpenTotal: open.length,
    };
  } catch (err) {
    console.error("[admin-digest] ads-ops summary failed:", err);
  }

  // --- Autopilots — run BEFORE building the flex so their changes appear
  // inside the digest. Reversible config-only changes; failures must not
  // affect the digest itself. ---
  const autopilotChanges: string[] = [];

  let lineCtaAutopilot: { previousLevel: number; level: number; changed: boolean; reason: string } | null = null;
  if (marketing) {
    try {
      const { previousLevel, decision } = await runLineCtaAutopilot(supabase, marketing);
      lineCtaAutopilot = { previousLevel, ...decision };
      if (decision.changed) {
        const arrow = decision.level > previousLevel ? "⬆️ ดันขึ้น" : "⬇️ ลดลง";
        autopilotChanges.push(
          `🤖 ปุ่มชวนแชท LINE: ${arrow} level ${previousLevel} → ${decision.level} — ${decision.reason}`
        );
      }
    } catch (err) {
      console.error("[admin-digest] line-cta autopilot failed:", err);
    }
  }

  let heroAutopilot: { previous: string | null; forced: string | null; changed: boolean; reason: string } | null = null;
  if (marketing) {
    try {
      const { previous, decision } = await runHeroAutopilot(supabase, marketing.heroAB);
      heroAutopilot = { previous, ...decision };
      if (decision.changed) {
        autopilotChanges.push(`🧪 หน้าแรก A/B: ${decision.reason}`);
      }
    } catch (err) {
      console.error("[admin-digest] hero autopilot failed:", err);
    }
  }

  let pricingPromoAutopilot: { previous: number; level: number; changed: boolean; reason: string } | null = null;
  if (marketing) {
    try {
      const { previous, decision } = await runPricingPromoAutopilot(supabase, marketing);
      pricingPromoAutopilot = { previous, ...decision };
      if (decision.changed) {
        const state = decision.level === 1 ? "เปิด" : "ปิด";
        autopilotChanges.push(`🏷️ แถบโปรหน้าราคา: ${state} — ${decision.reason}`);
      }
    } catch (err) {
      console.error("[admin-digest] pricing promo autopilot failed:", err);
    }
  }

  // --- Monday edition: trailing-7-day analytics summary ---
  let weekly: WeeklyAnalyticsSummary | null = null;
  if (bangkokNow.getUTCDay() === 1) {
    try {
      weekly = await fetchWeeklyAnalytics(supabase, now);
    } catch (err) {
      console.error("[admin-digest] weekly analytics failed:", err);
    }
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
    adsYesterday,
    adsOps,
    autopilotChanges,
    weekly,
  });

  const ok = await sendLineMessage(adminLineId, [flex, ...suggestCards]);

  return NextResponse.json({
    ok,
    suggestCardsAttached: suggestCards.length,
    lineCtaAutopilot,
    heroAutopilot,
    pricingPromoAutopilot,
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
      adsYesterday,
      adsOps,
      weekly,
    },
  });
}
