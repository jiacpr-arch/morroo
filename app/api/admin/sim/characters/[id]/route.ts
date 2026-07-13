import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

type Ctx = { params: Promise<{ id: string }> };

export async function PATCH(request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  // slug แก้ไม่ได้ (เคสอ้างด้วย slug) — เปลี่ยนได้เฉพาะข้อมูลแสดงผล/สถานะ
  const map: Record<string, string> = {
    name: "name",
    role: "role",
    plateTop: "plate_top",
    plateBottom: "plate_bottom",
    personality: "personality",
    motion: "motion",
    status: "status",
  };
  const update: Record<string, unknown> = {};
  for (const [key, column] of Object.entries(map)) {
    if (key in body) update[column] = body[key];
  }
  if (Object.keys(update).length === 0) {
    return NextResponse.json({ error: "ไม่มีข้อมูลให้แก้ไข" }, { status: 400 });
  }
  if (update.status && !["active", "archived"].includes(update.status as string)) {
    return NextResponse.json({ error: "status ไม่ถูกต้อง" }, { status: 400 });
  }
  if (update.motion && !["none", "bob", "sway", "pulse"].includes(update.motion as string)) {
    return NextResponse.json({ error: "motion ไม่ถูกต้อง" }, { status: 400 });
  }
  update.updated_at = new Date().toISOString();

  const admin = createAdminClient();
  const { error } = await admin.from("sim_characters").update(update).eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}

export async function DELETE(_request: Request, context: Ctx) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { id } = await context.params;

  const admin = createAdminClient();
  const { data: row } = await admin
    .from("sim_characters")
    .select("slug")
    .eq("id", id)
    .maybeSingle();
  if (!row) return NextResponse.json({ error: "ไม่พบตัวละคร" }, { status: 404 });

  // ลบรูปทั้งหมดใน bucket ก่อนลบแถว
  const { data: files } = await admin.storage.from("sim-characters").list(row.slug);
  if (files?.length) {
    await admin.storage
      .from("sim-characters")
      .remove(files.map((f) => `${row.slug}/${f.name}`));
  }
  const { error } = await admin.from("sim_characters").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
