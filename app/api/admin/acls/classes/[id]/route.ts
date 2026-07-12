import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin-only: archive (or restore) a cohort class. Archiving disables both
// codes — students can no longer join/sync and the instructor summary stops
// resolving (data itself is preserved).
// Ported from acls-emr's api/admin/classes.js (POST half).

export const runtime = "nodejs";
export const maxDuration = 10;

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: { archived?: boolean };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }
  if (typeof body.archived !== "boolean") {
    return NextResponse.json({ error: "archived (boolean) required" }, { status: 400 });
  }

  const supabase = createAdminClient();
  const { error } = await supabase
    .from("cohort_classes")
    .update({ archived_at: body.archived ? new Date().toISOString() : null })
    .eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
