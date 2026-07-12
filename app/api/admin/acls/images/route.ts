import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: attach an image (or, for parentType='precourse-video', a YouTube
// link) to a section / qa item / pre-course step. Two request shapes:
//   - multipart/form-data { file, parentType, parentId } — uploads the file
//     to the acls-images bucket and inserts a row pointing at its public URL.
//   - application/json { parentType, parentId, src, alt?, caption? } — used
//     for pre-course video links (src = YouTube URL, no file upload).
// Ported from acls-emr's src/services/alsAdminService.js#uploadImage and
// src/services/precourseImageService.js#addPreCourseVideo.

export const runtime = "nodejs";
export const maxDuration = 30;

const BUCKET = "acls-images";
const VALID_PARENT_TYPES = new Set(["section", "qa", "precourse-step", "precourse-video"]);

// GET ?parentTypes=precourse-step,precourse-video — bulk-fetch every image
// row for the given parent types (used by the pre-course media admin page,
// which needs every step's media at once rather than one parent at a time).
export async function GET(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { searchParams } = new URL(request.url);
  const raw = searchParams.get("parentTypes");
  const parentTypes = (raw ? raw.split(",") : []).map((s) => s.trim()).filter((s) => VALID_PARENT_TYPES.has(s));
  if (!parentTypes.length) {
    return NextResponse.json({ error: "parentTypes required" }, { status: 400 });
  }

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("acls_images")
    .select("id, parent_type, parent_id, src, alt, caption, sort_order")
    .in("parent_type", parentTypes)
    .order("sort_order", { ascending: true });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ images: data ?? [] });
}

async function nextSortOrder(
  supabase: ReturnType<typeof createAdminClient>,
  parentType: string,
  parentId: string,
): Promise<number> {
  const { data } = await supabase
    .from("acls_images")
    .select("sort_order")
    .eq("parent_type", parentType)
    .eq("parent_id", parentId)
    .order("sort_order", { ascending: false })
    .limit(1);
  return ((data?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const contentType = request.headers.get("content-type") || "";

  if (contentType.includes("multipart/form-data")) {
    const form = await request.formData();
    const file = form.get("file");
    const parentType = String(form.get("parentType") || "");
    const parentId = String(form.get("parentId") || "");
    if (!(file instanceof File)) {
      return NextResponse.json({ error: "Missing file" }, { status: 400 });
    }
    if (!VALID_PARENT_TYPES.has(parentType) || !parentId) {
      return NextResponse.json({ error: "invalid parentType/parentId" }, { status: 400 });
    }

    const ext = (file.name.split(".").pop() || "png").toLowerCase();
    const path = `${parentType}/${parentId}/${crypto.randomUUID()}.${ext}`;
    const buffer = Buffer.from(await file.arrayBuffer());

    const { error: upErr } = await supabase.storage
      .from(BUCKET)
      .upload(path, buffer, { cacheControl: "3600", upsert: false, contentType: file.type || undefined });
    if (upErr) return NextResponse.json({ error: upErr.message }, { status: 500 });

    const { data: publicUrlData } = supabase.storage.from(BUCKET).getPublicUrl(path);

    const nextOrder = await nextSortOrder(supabase, parentType, parentId);
    const { data, error: insErr } = await supabase
      .from("acls_images")
      .insert({
        parent_type: parentType,
        parent_id: parentId,
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

  // JSON body — direct src insert (pre-course video links).
  let body: { parentType?: string; parentId?: string; src?: string; alt?: string; caption?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }
  const { parentType, parentId, src } = body;
  if (!parentType || !VALID_PARENT_TYPES.has(parentType) || !parentId || !src) {
    return NextResponse.json({ error: "parentType, parentId and src required" }, { status: 400 });
  }

  const nextOrder = await nextSortOrder(supabase, parentType, parentId);
  const { data, error } = await supabase
    .from("acls_images")
    .insert({
      parent_type: parentType,
      parent_id: parentId,
      src,
      alt: body.alt || "",
      caption: body.caption || "",
      sort_order: nextOrder,
    })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ image: data });
}
