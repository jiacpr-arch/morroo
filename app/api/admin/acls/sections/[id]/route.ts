import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update (heading/body/sort_order) or delete a section.
// Reordering is done by the client issuing two PATCH calls that swap
// sort_order between adjacent sections (mirrors acls-emr's moveSection,
// simplified from a 3-step swap since acls_sections.sort_order has no
// unique constraint).
// Ported from acls-emr's src/services/alsAdminService.js#updateSection/deleteSection/moveSection.

export const runtime = "nodejs";

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: { heading?: string; body?: string; sort_order?: number };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (body.heading !== undefined) patch.heading = body.heading;
  if (body.body !== undefined) patch.body = body.body;
  if (body.sort_order !== undefined) patch.sort_order = body.sort_order;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_sections").update(patch).eq("id", id);
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
  const { error } = await supabase.from("acls_sections").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
