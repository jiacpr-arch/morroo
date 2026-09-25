import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import { isUuid } from "@/lib/mcq-comments";

// POST /api/mcq/comments/[id]/vote — toggle the viewer's upvote.
// Returns { voted, upvotes }. The upvotes counter is kept in sync by the
// trg_mcq_comment_votes_sync trigger.
export async function POST(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  if (!isUuid(id)) {
    return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "ต้องเข้าสู่ระบบก่อนจึงจะโหวตได้" }, { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:comment-vote", RATE_LIMITS.mcqCommentVote);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqCommentVote);
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
    return NextResponse.json({ error: "โหวตความคิดเห็นของตัวเองไม่ได้" }, { status: 400 });
  }

  // Try to remove an existing vote first; if nothing was removed, add one.
  const { data: removed, error: delError } = await supabase
    .from("mcq_comment_votes")
    .delete()
    .eq("comment_id", id)
    .eq("user_id", user.id)
    .select("comment_id");
  if (delError) {
    console.error("[mcq/comments/vote] delete error:", delError);
    return NextResponse.json({ error: "โหวตไม่สำเร็จ" }, { status: 500 });
  }

  let voted = false;
  if (!removed || removed.length === 0) {
    const { error: insError } = await supabase
      .from("mcq_comment_votes")
      .insert({ comment_id: id, user_id: user.id });
    // 23505: a concurrent request already inserted it — treat as voted.
    if (insError && insError.code !== "23505") {
      console.error("[mcq/comments/vote] insert error:", insError);
      return NextResponse.json({ error: "โหวตไม่สำเร็จ" }, { status: 500 });
    }
    voted = true;
  }

  const { data: fresh } = await supabase
    .from("mcq_comments")
    .select("upvotes")
    .eq("id", id)
    .maybeSingle();

  return NextResponse.json({ voted, upvotes: fresh?.upvotes ?? 0 });
}
