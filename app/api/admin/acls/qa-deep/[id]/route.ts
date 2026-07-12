import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update (question/answer/chapter_id/sort_order) or delete a Q&A
// Deep item (also removes its storage images). Reordering mirrors the
// content editors — client swaps sort_order between adjacent items.
// Ported from acls-emr's src/services/qaDeepAdminService.js#updateQaItem/deleteQaItem/moveQaItem.

export const runtime = "nodejs";

const BUCKET = "acls-images";

function extractStoragePath(src: string | null | undefined): string | null {
  if (!src) return null;
  const marker = `/${BUCKET}/`;
  const idx = src.indexOf(marker);
  if (idx < 0) return null;
  return src.slice(idx + marker.length);
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: { question?: string; answer?: string; chapter_id?: string | null; sort_order?: number };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = { updated_at: new Date().toISOString() };
  if (body.question !== undefined) patch.question = body.question;
  if (body.answer !== undefined) patch.answer = body.answer;
  if (body.chapter_id !== undefined) patch.chapter_id = body.chapter_id;
  if (body.sort_order !== undefined) patch.sort_order = body.sort_order;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_qa_deep_items").update(patch).eq("id", id);
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

  const { data: imgs } = await supabase.from("acls_qa_deep_images").select("src").eq("item_id", id);
  const paths = ((imgs ?? []) as { src: string }[]).map((i) => extractStoragePath(i.src)).filter(Boolean) as string[];
  if (paths.length) await supabase.storage.from(BUCKET).remove(paths);

  const { error } = await supabase.from("acls_qa_deep_items").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
