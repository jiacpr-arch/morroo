import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: upload a cover or infographic image for one Q&A Deep item.
// multipart/form-data { file, imageType: 'cover' | 'infographic' }.
// Ported from acls-emr's src/services/qaDeepAdminService.js#uploadItemImage.

export const runtime = "nodejs";
export const maxDuration = 30;

const BUCKET = "acls-images";
const DIR = "qa-deep";

export async function POST(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id: itemId } = await params;

  const form = await request.formData();
  const file = form.get("file");
  const imageType = String(form.get("imageType") || "");
  if (!(file instanceof File)) {
    return NextResponse.json({ error: "Missing file" }, { status: 400 });
  }
  if (imageType !== "cover" && imageType !== "infographic") {
    return NextResponse.json({ error: "imageType must be cover or infographic" }, { status: 400 });
  }

  const ext = (file.name.split(".").pop() || "png").toLowerCase();
  const path = `${DIR}/${itemId}/${crypto.randomUUID()}.${ext}`;
  const buffer = Buffer.from(await file.arrayBuffer());

  const supabase = createAdminClient();
  const { error: upErr } = await supabase.storage
    .from(BUCKET)
    .upload(path, buffer, { cacheControl: "3600", upsert: false, contentType: file.type || undefined });
  if (upErr) return NextResponse.json({ error: upErr.message }, { status: 500 });

  const { data: publicUrlData } = supabase.storage.from(BUCKET).getPublicUrl(path);

  const { data: existing, error: countErr } = await supabase
    .from("acls_qa_deep_images")
    .select("sort_order")
    .eq("item_id", itemId)
    .eq("image_type", imageType)
    .order("sort_order", { ascending: false })
    .limit(1);
  if (countErr) return NextResponse.json({ error: countErr.message }, { status: 500 });
  const nextOrder = ((existing?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data, error: insErr } = await supabase
    .from("acls_qa_deep_images")
    .insert({
      item_id: itemId,
      image_type: imageType,
      src: publicUrlData.publicUrl,
      alt: "",
      caption: "",
      sort_order: nextOrder,
    })
    .select()
    .single();
  if (insErr) return NextResponse.json({ error: insErr.message }, { status: 500 });

  return NextResponse.json({ image: data });
}
