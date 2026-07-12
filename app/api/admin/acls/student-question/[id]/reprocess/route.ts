import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { processStudentQuestion } from "@/lib/courses/student-question/process";

// Admin-only: re-runs the AI pipeline on an existing student question (e.g.
// after a failure). Ported from acls-emr's api/student-question/reprocess.js.

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { id } = await params;
  if (!id) return NextResponse.json({ error: "id required" }, { status: 400 });

  const supabase = createAdminClient();

  try {
    await processStudentQuestion(id);
  } catch (err) {
    await supabase
      .from("acls_student_questions")
      .update({
        status: "failed",
        error_message: String(err instanceof Error ? err.message : err).slice(0, 1000),
        updated_at: new Date().toISOString(),
      })
      .eq("id", id);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : String(err) },
      { status: 500 },
    );
  }

  return NextResponse.json({ ok: true, id });
}
