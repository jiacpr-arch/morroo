import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

type Ctx = { params: Promise<{ id: string }> };

const POSES = new Set(["idle", "talk", "panic", "stern", "happy"]);
const ALLOWED_TYPES: Record<string, string> = {
  "image/webp": "webp",
  "image/png": "png",
  "image/jpeg": "jpg",
};
const MAX_BYTES = 4 * 1024 * 1024; // 4MB

function imageKey(pose: string, talk: boolean) {
  return `${pose}${talk ? "_talk" : ""}`;
}

/** อัปโหลดรูปหนึ่งท่า (multipart: file, pose, talk?) → เก็บ URL ลง images jsonb */
export async function POST(request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  let form: FormData;
  try {
    form = await request.formData();
  } catch {
    return NextResponse.json({ error: "ต้องส่งเป็น multipart/form-data" }, { status: 400 });
  }
  const file = form.get("file");
  const pose = String(form.get("pose") ?? "");
  const talk = form.get("talk") === "1";

  if (!(file instanceof Blob)) {
    return NextResponse.json({ error: "ไม่พบไฟล์รูป" }, { status: 400 });
  }
  if (!POSES.has(pose)) {
    return NextResponse.json({ error: `pose ต้องเป็น: ${[...POSES].join(", ")}` }, { status: 400 });
  }
  const ext = ALLOWED_TYPES[file.type];
  if (!ext) {
    return NextResponse.json({ error: "รองรับเฉพาะ .webp .png .jpg" }, { status: 400 });
  }
  if (file.size > MAX_BYTES) {
    return NextResponse.json({ error: "ไฟล์ใหญ่เกิน 4MB" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data: row } = await admin
    .from("sim_characters")
    .select("slug, images")
    .eq("id", id)
    .maybeSingle();
  if (!row) return NextResponse.json({ error: "ไม่พบตัวละคร" }, { status: 404 });

  const key = imageKey(pose, talk);
  const path = `${row.slug}/${key}.${ext}`;
  const { error: uploadError } = await admin.storage
    .from("sim-characters")
    .upload(path, file, { upsert: true, contentType: file.type });
  if (uploadError) {
    return NextResponse.json({ error: uploadError.message }, { status: 500 });
  }

  const { data: pub } = admin.storage.from("sim-characters").getPublicUrl(path);
  // cache-bust: URL เดิมอาจถูก CDN/เบราว์เซอร์แคชไว้หลังอัปทับ
  const url = `${pub.publicUrl}?v=${Date.now()}`;

  const images = { ...(row.images ?? {}), [key]: url };
  const { error } = await admin
    .from("sim_characters")
    .update({ images, updated_at: new Date().toISOString() })
    .eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ key, url });
}

/** ลบรูปหนึ่งท่า (?pose=idle&talk=1) */
export async function DELETE(request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  const { searchParams } = new URL(request.url);
  const pose = searchParams.get("pose") ?? "";
  const talk = searchParams.get("talk") === "1";
  if (!POSES.has(pose)) {
    return NextResponse.json({ error: "pose ไม่ถูกต้อง" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data: row } = await admin
    .from("sim_characters")
    .select("slug, images")
    .eq("id", id)
    .maybeSingle();
  if (!row) return NextResponse.json({ error: "ไม่พบตัวละคร" }, { status: 404 });

  const key = imageKey(pose, talk);
  // ชื่อไฟล์อาจเป็นได้หลายนามสกุล — ลบทุกแบบ
  await admin.storage
    .from("sim-characters")
    .remove(["webp", "png", "jpg"].map((ext) => `${row.slug}/${key}.${ext}`));

  const images = { ...(row.images ?? {}) };
  delete images[key];
  const { error } = await admin
    .from("sim_characters")
    .update({ images, updated_at: new Date().toISOString() })
    .eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
