import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

/**
 * GET /api/admin/mcq/reports
 *
 * Admin view of student-submitted MCQ error reports, enriched with the
 * flagged question and the reporter's profile, plus a Bug Hunter leaderboard.
 */
export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const admin = createAdminClient();

  const { data: reports, error } = await admin
    .from("mcq_question_reports")
    .select(
      "id, question_id, reason, note, suggested_answer, status, points_awarded, created_at, reviewed_at, user_id, mcq_questions(scenario, correct_answer, status)"
    )
    .order("created_at", { ascending: false })
    .limit(300);

  if (error) {
    console.error("[admin/mcq/reports] list error:", error);
    return NextResponse.json({ error: "โหลดรายงานไม่สำเร็จ" }, { status: 500 });
  }

  // reports.user_id references auth.users (not profiles), so enrich separately.
  const userIds = [
    ...new Set((reports ?? []).map((r) => r.user_id).filter(Boolean)),
  ] as string[];

  const profilesById: Record<
    string,
    { id: string; name: string | null; email: string | null; reporter_points: number; reporter_points_spent: number }
  > = {};

  if (userIds.length > 0) {
    const { data: profs } = await admin
      .from("profiles")
      .select("id, name, email, reporter_points, reporter_points_spent")
      .in("id", userIds);
    for (const p of profs ?? []) {
      profilesById[p.id] = p as (typeof profilesById)[string];
    }
  }

  const enriched = (reports ?? []).map((r) => ({
    ...r,
    reporter: r.user_id ? profilesById[r.user_id] ?? null : null,
  }));

  const { data: leaderboard } = await admin
    .from("profiles")
    .select("id, name, email, reporter_points, reporter_points_spent")
    .gt("reporter_points", 0)
    .order("reporter_points", { ascending: false })
    .limit(15);

  return NextResponse.json({
    reports: enriched,
    leaderboard: leaderboard ?? [],
  });
}
