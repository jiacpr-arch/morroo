import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

type ReportRow = {
  comment_id: string;
  reason: string;
  created_at: string;
};

type AdminCommentRow = {
  id: string;
  question_id: string;
  user_id: string;
  parent_id: string | null;
  body: string;
  created_at: string;
  edited_at: string | null;
  status: "visible" | "hidden";
  upvotes: number;
  moderated_at: string | null;
  mcq_questions: { scenario: string } | null;
};

/**
 * GET /api/admin/mcq/comments
 *
 * Moderation queue for MCQ discussion comments: every hidden comment plus
 * every comment that has at least one report. Each row carries its report
 * tally split into "open" (filed after the last admin review) and total.
 */
export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const admin = createAdminClient();

  const [{ data: reports, error: reportsError }, { data: hidden, error: hiddenError }] =
    await Promise.all([
      admin
        .from("mcq_comment_reports")
        .select("comment_id, reason, created_at")
        .order("created_at", { ascending: false })
        .limit(2000),
      admin
        .from("mcq_comments")
        .select("id")
        .eq("status", "hidden")
        .order("created_at", { ascending: false })
        .limit(500),
    ]);

  const listError = reportsError ?? hiddenError;
  if (listError) {
    console.error("[admin/mcq/comments] list error:", listError);
    return NextResponse.json({ error: "โหลดความคิดเห็นไม่สำเร็จ" }, { status: 500 });
  }

  const reportsByComment = new Map<string, ReportRow[]>();
  for (const r of (reports ?? []) as ReportRow[]) {
    const list = reportsByComment.get(r.comment_id) ?? [];
    list.push(r);
    reportsByComment.set(r.comment_id, list);
  }

  const ids = [
    ...new Set([
      ...reportsByComment.keys(),
      ...((hidden ?? []) as { id: string }[]).map((h) => h.id),
    ]),
  ];
  if (ids.length === 0) {
    return NextResponse.json({ comments: [] });
  }

  const { data: rows, error } = await admin
    .from("mcq_comments")
    .select(
      "id, question_id, user_id, parent_id, body, created_at, edited_at, status, upvotes, moderated_at, mcq_questions(scenario)"
    )
    .in("id", ids);
  if (error) {
    console.error("[admin/mcq/comments] fetch error:", error);
    return NextResponse.json({ error: "โหลดความคิดเห็นไม่สำเร็จ" }, { status: 500 });
  }

  const commentRows = (rows ?? []) as unknown as AdminCommentRow[];
  const userIds = [...new Set(commentRows.map((r) => r.user_id))];
  const authors = new Map<string, { name: string | null; email: string | null }>();
  if (userIds.length > 0) {
    const { data: profs } = await admin
      .from("profiles")
      .select("id, name, email")
      .in("id", userIds);
    for (const p of (profs ?? []) as { id: string; name: string | null; email: string | null }[]) {
      authors.set(p.id, { name: p.name, email: p.email });
    }
  }

  const comments = commentRows
    .map((c) => {
      const reps = reportsByComment.get(c.id) ?? [];
      const reviewedAt = c.moderated_at ? Date.parse(c.moderated_at) : null;
      const openReports =
        reviewedAt === null
          ? reps
          : reps.filter((r) => Date.parse(r.created_at) > reviewedAt);
      const reasons: Record<string, number> = {};
      for (const r of openReports) reasons[r.reason] = (reasons[r.reason] ?? 0) + 1;
      return {
        id: c.id,
        question_id: c.question_id,
        parent_id: c.parent_id,
        body: c.body,
        created_at: c.created_at,
        edited_at: c.edited_at,
        status: c.status,
        upvotes: c.upvotes,
        moderated_at: c.moderated_at,
        question_scenario: c.mcq_questions?.scenario ?? null,
        author: authors.get(c.user_id) ?? null,
        report_count: reps.length,
        open_report_count: openReports.length,
        open_reasons: reasons,
        last_reported_at: reps[0]?.created_at ?? null,
      };
    })
    // Unreviewed first, then most-reported, then most recent activity.
    .sort((a, b) => {
      if (b.open_report_count !== a.open_report_count) {
        return b.open_report_count - a.open_report_count;
      }
      const at = a.last_reported_at ?? a.created_at;
      const bt = b.last_reported_at ?? b.created_at;
      return Date.parse(bt) - Date.parse(at);
    });

  return NextResponse.json({ comments });
}
