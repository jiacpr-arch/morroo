import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update image/video metadata (alt/caption) or delete it (and its
// storage object, when the src points into the acls-images bucket — video
// links point at YouTube instead and are just removed as a row).
// Ported from acls-emr's src/services/alsAdminService.js#updateImage/deleteImage.

export const runtime = "nodejs";

const BUCKET = "acls-images";

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
  const { error } = await supabase.from("acls_images").update(patch).eq("id", id);
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

  const { data: row } = await supabase.from("acls_images").select("src").eq("id", id).maybeSingle();
  const src = (row as { src?: string } | null)?.src;
  const marker = `/${BUCKET}/`;
  if (src && src.includes(marker)) {
    const path = src.split(marker)[1];
    if (path) await supabase.storage.from(BUCKET).remove([path]);
  }

  const { error } = await supabase.from("acls_images").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
