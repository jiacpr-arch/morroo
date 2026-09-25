import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import { isUuid, validateCommentBody, type CommentRow } from "@/lib/mcq-comments";
import { COMMENT_FIELDS, toPublicComments } from "@/lib/supabase/queries-mcq-comments";

// PATCH /api/mcq/comments/[id]
// Body: { body } — edit own comment. RLS limits this to the author's own
// visible comments; column grants limit it to the body (edited_at is
// stamped by a trigger).
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  if (!isUuid(id)) {
    return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });
  }

  let payload: { body?: unknown };
  try {
    payload = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }
  const parsed = validateCommentBody(payload?.body);
  if (!parsed.ok) {
    return NextResponse.json({ error: parsed.error }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "ต้องเข้าสู่ระบบก่อน" }, { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:comment-write", RATE_LIMITS.mcqCommentWrite);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqCommentWrite);
  if (rlResp) return rlResp;

  const { data: row, error } = await supabase
    .from("mcq_comments")
    .update({ body: parsed.value })
    .eq("id", id)
    .eq("user_id", user.id)
    .select(COMMENT_FIELDS)
    .maybeSingle();

  if (error) {
    console.error("[mcq/comments] update error:", error);
    return NextResponse.json({ error: "แก้ไขไม่สำเร็จ" }, { status: 500 });
  }
  if (!row) {
    return NextResponse.json(
      { error: "ไม่พบความคิดเห็นนี้ หรือไม่สามารถแก้ไขได้" },
      { status: 404 }
    );
  }

  const [comment] = await toPublicComments(
    createAdminClient(),
    [row as CommentRow],
    user.id,
    new Set() // own comments can't be self-voted
  );
  return NextResponse.json({ comment });
}

// DELETE /api/mcq/comments/[id] — delete own comment (replies cascade).
export async function DELETE(
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
    return NextResponse.json({ error: "ต้องเข้าสู่ระบบก่อน" }, { status: 401 });
  }

  const { data, error } = await supabase
    .from("mcq_comments")
    .delete()
    .eq("id", id)
    .eq("user_id", user.id)
    .select("id");

  if (error) {
    console.error("[mcq/comments] delete error:", error);
    return NextResponse.json({ error: "ลบไม่สำเร็จ" }, { status: 500 });
  }
  if (!data || data.length === 0) {
    return NextResponse.json({ error: "ไม่พบความคิดเห็นนี้" }, { status: 404 });
  }
  return NextResponse.json({ ok: true });
}
