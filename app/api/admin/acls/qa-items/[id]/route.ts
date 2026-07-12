import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update (q/a/sort_order) or delete a Q&A item. Reordering mirrors
// sections — the client swaps sort_order between adjacent items with two
// PATCH calls.
// Ported from acls-emr's src/services/alsAdminService.js#updateQa/deleteQa/moveQa.

export const runtime = "nodejs";

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: { q?: string; a?: string; sort_order?: number };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (body.q !== undefined) patch.q = body.q;
  if (body.a !== undefined) patch.a = body.a;
  if (body.sort_order !== undefined) patch.sort_order = body.sort_order;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_qa_items").update(patch).eq("id", id);
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
  const { error } = await supabase.from("acls_qa_items").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
