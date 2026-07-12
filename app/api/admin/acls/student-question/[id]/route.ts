import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: edit a student question's draft fields (before publish), reject it,
// or permanently delete it.
// PATCH body shapes:
//   - draft edit:   { question?, deepseek_answer?, suggested_chapter_id?, generated_image_url?, admin_notes? }
//   - reject:       { status: 'rejected', admin_notes? }
// Ported from acls-emr's src/services/studentQuestionAdminService.js
// #updateStudentQuestionDraft/rejectStudentQuestion/deleteStudentQuestion.

export const runtime = "nodejs";

interface PatchBody {
  question?: string;
  deepseek_answer?: string;
  suggested_chapter_id?: string | null;
  generated_image_url?: string | null;
  admin_notes?: string | null;
  status?: "rejected";
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: PatchBody;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const supabase = createAdminClient();
  const patch: Record<string, unknown> = { updated_at: new Date().toISOString() };

  if (body.status === "rejected") {
    patch.status = "rejected";
    patch.admin_notes = body.admin_notes ?? null;
  } else {
    for (const k of [
      "question",
      "deepseek_answer",
      "suggested_chapter_id",
      "generated_image_url",
      "admin_notes",
    ] as const) {
      if (body[k] !== undefined) patch[k] = body[k];
    }
  }

  const { error } = await supabase.from("acls_student_questions").update(patch).eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}

export async function DELETE(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_student_questions").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
