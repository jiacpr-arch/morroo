import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin-only: full ACLS/BLS student roster (name + phone + class + pass
// status) across all classes. Computed by public.get_acls_student_roster()
// (service-role only RPC).
// Ported from acls-emr's api/admin/students.js.
//
// NOTE: distinct from morroo's own /admin/students (main product students) —
// this is /admin/acls/students, scoped to the ACLS/BLS course roster.

export const runtime = "nodejs";
export const maxDuration = 10;

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase.rpc("get_acls_student_roster");
  if (error) {
    console.error("get_acls_student_roster failed:", error.message);
    return NextResponse.json({ error: "Failed to load student roster" }, { status: 500 });
  }
  return NextResponse.json({ students: data || [] });
}
