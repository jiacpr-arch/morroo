import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: upload the Q&A Deep page cover image, returns its public URL — the
// client then PATCHes /api/admin/acls/qa-deep/page-settings with the URL.
// Ported from acls-emr's src/services/qaDeepAdminService.js#uploadPageCover.

export const runtime = "nodejs";
export const maxDuration = 30;

const BUCKET = "acls-images";
const DIR = "qa-deep-page";

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const form = await request.formData();
  const file = form.get("file");
  if (!(file instanceof File)) {
    return NextResponse.json({ error: "Missing file" }, { status: 400 });
  }

  const ext = (file.name.split(".").pop() || "png").toLowerCase();
  const path = `${DIR}/${crypto.randomUUID()}.${ext}`;
  const buffer = Buffer.from(await file.arrayBuffer());

  const supabase = createAdminClient();
  const { error: upErr } = await supabase.storage
    .from(BUCKET)
    .upload(path, buffer, { cacheControl: "3600", upsert: false, contentType: file.type || undefined });
  if (upErr) return NextResponse.json({ error: upErr.message }, { status: 500 });

  const { data } = supabase.storage.from(BUCKET).getPublicUrl(path);
  return NextResponse.json({ url: data.publicUrl });
}
