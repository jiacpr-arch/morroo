import { NextRequest, NextResponse, after } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { buildAdminAlertText, sendThrottledAdminAlert } from "@/lib/admin-alerts";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import { isUuid, validateReportReason } from "@/lib/mcq-comments";

// POST /api/mcq/comments/[id]/report
// Body: { reason } — flag a comment for moderation. One report per user per
// comment; the DB auto-hides a comment once it collects 3 reports.
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  if (!isUuid(id)) {
    return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });
  }

  let payload: { reason?: unknown };
  try {
    payload = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }
  const reason = validateReportReason(payload?.reason);
  if (!reason.ok) {
    return NextResponse.json({ error: reason.error }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "ต้องเข้าสู่ระบบก่อนจึงจะรายงานได้" }, { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:comment-report", RATE_LIMITS.mcqCommentReport);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqCommentReport);
  if (rlResp) return rlResp;

  const { data: comment } = await supabase
    .from("mcq_comments")
    .select("id, user_id, status")
    .eq("id", id)
    .maybeSingle();
  if (!comment || comment.status !== "visible") {
    return NextResponse.json({ error: "ไม่พบความคิดเห็นนี้" }, { status: 404 });
  }
  if (comment.user_id === user.id) {
    return NextResponse.json({ error: "รายงานความคิดเห็นของตัวเองไม่ได้" }, { status: 400 });
  }

  const { error } = await supabase
    .from("mcq_comment_reports")
    .insert({ comment_id: id, user_id: user.id, reason: reason.value });

  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ error: "คุณเคยรายงานความคิดเห็นนี้แล้ว" }, { status: 409 });
    }
    console.error("[mcq/comments/report] insert error:", error);
    return NextResponse.json({ error: "รายงานไม่สำเร็จ" }, { status: 500 });
  }

  // The comment was visible before this report; if the DB trigger just
  // auto-hid it (≥3 reports), tell the admin now — a wrongly silenced
  // comment shouldn't wait for the morning digest. Throttled per 6h.
  after(async () => {
    const admin = createAdminClient();
    const { data: current } = await admin
      .from("mcq_comments")
      .select("status, body")
      .eq("id", id)
      .maybeSingle();
    if ((current as { status?: string } | null)?.status !== "hidden") return;
    await sendThrottledAdminAlert(
      admin,
      "comment_autohidden",
      buildAdminAlertText({
        title: "🙈 คอมเมนต์ถูกซ่อนอัตโนมัติ (รายงานครบ 3 ครั้ง)",
        detail: `"${(current as { body?: string }).body ?? ""}"`,
        path: "/admin/mcq/comments",
      })
    );
  });

  return NextResponse.json({ ok: true });
}
