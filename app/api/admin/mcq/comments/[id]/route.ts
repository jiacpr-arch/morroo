import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { isUuid } from "@/lib/mcq-comments";

const ALLOWED_STATUS = ["visible", "hidden"] as const;
type CommentStatus = (typeof ALLOWED_STATUS)[number];

/**
 * PATCH /api/admin/mcq/comments/[id]
 * Body: { status: "visible" | "hidden" }
 *
 * Hide or unhide a discussion comment. Stamps moderated_at so reports filed
 * before this review no longer count toward the auto-hide threshold.
 */
export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;
  if (!isUuid(id)) {
    return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });
  }

  let body: { status?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const status = body.status as CommentStatus;
  if (!ALLOWED_STATUS.includes(status)) {
    return NextResponse.json(
      { error: `status must be one of: ${ALLOWED_STATUS.join(", ")}` },
      { status: 400 }
    );
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("mcq_comments")
    .update({ status, moderated_at: new Date().toISOString() })
    .eq("id", id)
    .select("id, status, moderated_at")
    .maybeSingle();

  if (error) {
    console.error("[admin/mcq/comments] update error:", error);
    return NextResponse.json({ error: "อัปเดตไม่สำเร็จ" }, { status: 500 });
  }
  if (!data) {
    return NextResponse.json({ error: "ไม่พบความคิดเห็นนี้" }, { status: 404 });
  }

  return NextResponse.json({ ok: true, comment: data });
}

/** DELETE /api/admin/mcq/comments/[id] — permanently remove (replies cascade). */
export async function DELETE(
  _request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;
  if (!isUuid(id)) {
    return NextResponse.json({ error: "id ไม่ถูกต้อง" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("mcq_comments")
    .delete()
    .eq("id", id)
    .select("id");

  if (error) {
    console.error("[admin/mcq/comments] delete error:", error);
    return NextResponse.json({ error: "ลบไม่สำเร็จ" }, { status: 500 });
  }
  if (!data || data.length === 0) {
    return NextResponse.json({ error: "ไม่พบความคิดเห็นนี้" }, { status: 404 });
  }
  return NextResponse.json({ ok: true });
}
