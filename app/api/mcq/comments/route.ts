import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import {
  buildThreads,
  countVisible,
  isUuid,
  validateCreateComment,
  type CommentRow,
} from "@/lib/mcq-comments";
import { COMMENT_FIELDS, toPublicComments } from "@/lib/supabase/queries-mcq-comments";
import { ACTIVE_MOCK_BLOCK_MESSAGE, isQuestionInActiveMock } from "@/lib/mcq-active-mock";

// Hard cap per question — discussions on a single MCQ are small; this just
// keeps a pathological thread from producing a huge payload.
const MAX_COMMENTS = 500;

// GET /api/mcq/comments?question_id=<uuid>
// Returns { threads, count } — visible comments (plus the viewer's own hidden
// ones) grouped into one level of replies and sorted by upvotes → recency.
// Reading is free for any signed-in user (no premium gate).
export async function GET(request: NextRequest) {
  const questionId = request.nextUrl.searchParams.get("question_id");
  if (!isUuid(questionId)) {
    return NextResponse.json({ error: "question_id ไม่ถูกต้อง" }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json(
      { error: "ต้องเข้าสู่ระบบก่อนจึงจะดูการอภิปรายได้" },
      { status: 401 }
    );
  }

  // คอมเมนต์มักเฉลยคำตอบ — ไม่ให้อ่านระหว่างที่ข้อนี้อยู่ใน Mock ที่กำลังสอบ
  if (await isQuestionInActiveMock(createAdminClient(), user.id, questionId)) {
    return NextResponse.json({ error: ACTIVE_MOCK_BLOCK_MESSAGE }, { status: 403 });
  }

  // RLS: status='visible' OR own comment.
  const { data: rows, error } = await supabase
    .from("mcq_comments")
    .select(COMMENT_FIELDS)
    .eq("question_id", questionId)
    .order("created_at", { ascending: false })
    .limit(MAX_COMMENTS);

  if (error) {
    console.error("[mcq/comments] list error:", error);
    return NextResponse.json({ error: "โหลดความคิดเห็นไม่สำเร็จ" }, { status: 500 });
  }

  const commentRows = (rows ?? []) as CommentRow[];
  const votedIds = new Set<string>();
  if (commentRows.length > 0) {
    const { data: votes } = await supabase
      .from("mcq_comment_votes")
      .select("comment_id")
      .eq("user_id", user.id)
      .in(
        "comment_id",
        commentRows.map((r) => r.id)
      );
    for (const v of (votes ?? []) as { comment_id: string }[]) votedIds.add(v.comment_id);
  }

  const comments = await toPublicComments(createAdminClient(), commentRows, user.id, votedIds);
  const threads = buildThreads(comments);

  return NextResponse.json({ threads, count: countVisible(threads) });
}

// POST /api/mcq/comments
// Body: { question_id, body, parent_id? }
// Posting is open to any signed-in user (same as reading — no premium gate).
export async function POST(request: NextRequest) {
  let payload: unknown;
  try {
    payload = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const parsed = validateCreateComment(payload);
  if (!parsed.ok) {
    return NextResponse.json({ error: parsed.error }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json(
      { error: "ต้องเข้าสู่ระบบก่อนจึงจะแสดงความคิดเห็นได้" },
      { status: 401 }
    );
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:comment-write", RATE_LIMITS.mcqCommentWrite);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqCommentWrite);
  if (rlResp) return rlResp;

  const { question_id, parent_id, body } = parsed.value;

  // Friendlier errors than the DB trigger's: parent must be a visible
  // top-level comment on the same question.
  if (parent_id) {
    const { data: parent } = await supabase
      .from("mcq_comments")
      .select("id, question_id, parent_id, status")
      .eq("id", parent_id)
      .maybeSingle();
    if (!parent || parent.status !== "visible" || parent.question_id !== question_id) {
      return NextResponse.json({ error: "ไม่พบความคิดเห็นที่ต้องการตอบกลับ" }, { status: 404 });
    }
    if (parent.parent_id) {
      return NextResponse.json({ error: "ตอบกลับได้เพียงหนึ่งระดับ" }, { status: 400 });
    }
  }

  const { data: row, error } = await supabase
    .from("mcq_comments")
    .insert({ question_id, parent_id, body, user_id: user.id })
    .select(COMMENT_FIELDS)
    .single();

  if (error || !row) {
    // 23503 = FK violation (question deleted / bad id)
    if (error?.code === "23503") {
      return NextResponse.json({ error: "ไม่พบข้อสอบนี้" }, { status: 404 });
    }
    console.error("[mcq/comments] insert error:", error);
    return NextResponse.json({ error: "บันทึกความคิดเห็นไม่สำเร็จ" }, { status: 500 });
  }

  const [comment] = await toPublicComments(
    createAdminClient(),
    [row as CommentRow],
    user.id,
    new Set()
  );
  return NextResponse.json({ comment }, { status: 201 });
}
