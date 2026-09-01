/**
 * Mint a signed upload URL for the school-imports bucket.
 *
 * The admin UI calls this before uploading a large PDF directly to Supabase
 * Storage (bypassing Vercel's serverless body limit). The returned path is
 * then passed to /api/admin/school/import as `storage_path` — that route
 * downloads the file with the service-role client, processes it, and
 * deletes it.
 */
import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

const BUCKET = "school-imports";

export async function POST() {
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

  const path = `${user.id}/${crypto.randomUUID()}.pdf`;
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
