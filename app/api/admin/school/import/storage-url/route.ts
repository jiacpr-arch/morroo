/**
 * Mint a signed upload URL for the school-imports bucket.
 *
 * The admin UI calls this before uploading source files directly to Supabase
 * Storage (bypassing Vercel's serverless body limit). The returned paths are
 * then passed to /api/admin/school/import as `storage_paths` — that route
 * downloads them with the service-role client, processes them, and deletes
 * them.
 *
 * One call mints one path, so the client loops when the batch has several
 * files. The extension encodes the file's type: the import route has only the
 * path to work from when rebuilding the media block.
 */
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { extensionForType } from "@/lib/school/import-files";

export const runtime = "nodejs";

const BUCKET = "school-imports";

export async function POST(req: NextRequest) {
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
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }

  // ชนิดไฟล์ไม่ได้ส่งมาก็ถือว่าเป็น PDF — เป็นกรณีที่เจอบ่อยที่สุด
  const body = (await req.json().catch(() => ({}))) as { contentType?: string };
  const ext = extensionForType(body.contentType ?? "application/pdf");
  if (!ext) {
    return NextResponse.json({ error: "รับเฉพาะ PDF หรือรูปภาพ" }, { status: 400 });
  }

  const path = `${user.id}/${crypto.randomUUID()}.${ext}`;
  const admin = createAdminClient();
  const { data, error } = await admin.storage
    .from(BUCKET)
    .createSignedUploadUrl(path);
  if (error || !data) {
    return NextResponse.json(
      { error: error?.message ?? "Failed to create signed URL" },
      { status: 500 },
    );
  }
  return NextResponse.json({
    bucket: BUCKET,
    path: data.path,
    token: data.token,
    signedUrl: data.signedUrl,
  });
}
