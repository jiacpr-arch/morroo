import { randomUUID } from "node:crypto";
import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  PE_ILLUSTRATION_CREDIT,
  generateIllustration,
  illustrationSceneError,
} from "@/lib/longcase-illustration";

export const runtime = "nodejs";
// gpt-image at "high" quality can take ~30-90s
export const maxDuration = 300;

const BUCKET = "longcase-media";

/** สร้างภาพประกอบ "ตรวจร่างกาย" ด้วย AI → เก็บใน longcase-media/pe/ → คืน URL ให้แอดมินวางเอง */
export async function POST(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) return NextResponse.json({ error: "ยังไม่ได้ตั้งค่า OPENAI_API_KEY" }, { status: 500 });

  const body = (await request.json().catch(() => ({}))) as { scene?: unknown };
  const scene = typeof body.scene === "string" ? body.scene : "";
  const invalid = illustrationSceneError(scene);
  if (invalid) return NextResponse.json({ error: invalid }, { status: 400 });

  let webp: Buffer;
  try {
    webp = await generateIllustration(scene, apiKey);
  } catch (err) {
    console.error("[pe-illustration]", err);
    return NextResponse.json({ error: "สร้างภาพไม่สำเร็จ ลองใหม่อีกครั้ง" }, { status: 502 });
  }

  // ชื่อไฟล์สุ่ม — ไม่มีชื่อโรคใน URL
  const path = `pe/${randomUUID()}.webp`;
  const admin = createAdminClient();
  const { error } = await admin.storage.from(BUCKET).upload(path, webp, { contentType: "image/webp" });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const { data } = admin.storage.from(BUCKET).getPublicUrl(path);
  return NextResponse.json({ url: data.publicUrl, credit: PE_ILLUSTRATION_CREDIT });
}
