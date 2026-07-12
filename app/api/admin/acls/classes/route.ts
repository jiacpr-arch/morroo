import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin-only: every cohort class with both codes and its student count —
// the recovery path when an instructor loses their codes.
// Ported from acls-emr's api/admin/classes.js (GET half).

export const runtime = "nodejs";
export const maxDuration = 10;

interface ClassRow {
  id: string;
  code: string;
  instructor_code: string | null;
  name: string;
  course_mode: string;
  created_at: string;
  archived_at: string | null;
  cohort_students: { count: number }[] | null;
}

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("cohort_classes")
    .select("id, code, instructor_code, name, course_mode, created_at, archived_at, cohort_students(count)")
    .order("created_at", { ascending: false });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const classes = ((data ?? []) as ClassRow[]).map(({ cohort_students, ...c }) => ({
    ...c,
    student_count: cohort_students?.[0]?.count ?? 0,
  }));
  return NextResponse.json({ classes });
}
