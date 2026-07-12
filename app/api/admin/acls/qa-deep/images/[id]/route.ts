import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update (alt/caption) or delete a Q&A Deep item's cover/infographic
// image (also removes the storage object).
// Ported from acls-emr's src/services/qaDeepAdminService.js#updateItemImage/deleteItemImage.

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

  let body: { alt?: string; caption?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (body.alt !== undefined) patch.alt = body.alt;
  if (body.caption !== undefined) patch.caption = body.caption;

  const supabase = createAdminClient();
  const { error } = await supabase.from("acls_qa_deep_images").update(patch).eq("id", id);
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

  const { data: row } = await supabase.from("acls_qa_deep_images").select("src").eq("id", id).maybeSingle();
  const path = extractStoragePath((row as { src?: string } | null)?.src);
  if (path) await supabase.storage.from(BUCKET).remove([path]);

  const { error } = await supabase.from("acls_qa_deep_images").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
