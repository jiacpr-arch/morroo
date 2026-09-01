import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";
export const maxDuration = 60;

const BUCKET = "public-assets";
const PREFIX = "school";
const MAX_BYTES = 8 * 1024 * 1024; // 8 MB
const ALLOWED = ["image/png", "image/jpeg", "image/webp", "image/gif", "image/svg+xml"];

const EXT: Record<string, string> = {
  "image/png": "png",
  "image/jpeg": "jpg",
  "image/webp": "webp",
  "image/gif": "gif",
  "image/svg+xml": "svg",
};

/**
 * Admin-only image upload for School content. Stores the file in the
 * `public-assets` storage bucket and returns its permanent public URL, which
 * can be dropped into a lesson/book markdown (`![alt](url)`) or a
 * flashcard/visual image field.
 *
 * Body: multipart/form-data with a `file` field.
 * Returns: { url: string }
 */
export async function POST(req: NextRequest) {
  // Verify the caller is an admin (user-context client).
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .maybeSingle();
  if (profile?.role !== "admin") {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  const form = await req.formData();
  const file = form.get("file");
  if (!(file instanceof File)) {
    return NextResponse.json({ error: "Missing file" }, { status: 400 });
  }
  if (!ALLOWED.includes(file.type)) {
    return NextResponse.json(
      { error: `ชนิดไฟล์ไม่รองรับ (${file.type || "unknown"})` },
      { status: 400 }
    );
  }
  if (file.size > MAX_BYTES) {
    return NextResponse.json({ error: "ไฟล์ใหญ่เกิน 8 MB" }, { status: 400 });
  }

  const ext = EXT[file.type] ?? "png";
  const path = `${PREFIX}/${crypto.randomUUID()}.${ext}`;
  const buffer = Buffer.from(await file.arrayBuffer());

  // Service-role client bypasses storage RLS for the verified-admin upload.
  const admin = createAdminClient();
  const { error: uploadErr } = await admin.storage
    .from(BUCKET)
    .upload(path, buffer, { contentType: file.type, upsert: false });
  if (uploadErr) {
    return NextResponse.json({ error: uploadErr.message }, { status: 500 });
  }

  const { data } = admin.storage.from(BUCKET).getPublicUrl(path);
  return NextResponse.json({ url: data.publicUrl });
}
