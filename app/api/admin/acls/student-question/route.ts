import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: list all student-submitted questions (newest first), optionally
// filtered by status. The public submit route only inserts — this is the
// admin-only read/list surface.
// Ported from acls-emr's src/services/studentQuestionAdminService.js#listStudentQuestions.

export const runtime = "nodejs";

export async function GET(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { searchParams } = new URL(request.url);
  const status = searchParams.get("status");

  const supabase = createAdminClient();
  let query = supabase
    .from("acls_student_questions")
    .select(
      "id, question, student_name, student_contact, status, deepseek_answer, " +
        "suggested_chapter_id, classification_reason, generated_image_url, image_prompt, " +
        "admin_notes, error_message, published_item_id, created_at, processed_at, published_at, updated_at",
    )
    .order("created_at", { ascending: false });
  if (status) query = query.eq("status", status);

  const { data, error } = await query;
  if (error) {
    console.error("list student questions failed:", error.message);
    return NextResponse.json({ error: "Failed to load questions" }, { status: 500 });
  }

  return NextResponse.json({ items: data ?? [] });
}
