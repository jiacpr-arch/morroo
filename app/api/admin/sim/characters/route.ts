import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { SIM_CHARACTERS } from "@/lib/sim/characters";

export const runtime = "nodejs";

const BUILTIN_IDS = new Set(Object.keys(SIM_CHARACTERS));

export async function GET() {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("sim_characters")
    .select("*")
    .order("created_at", { ascending: true });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ characters: data ?? [] });
}

export async function POST(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  let body: {
    slug?: string;
    name?: string;
    role?: string;
    plateTop?: string;
    plateBottom?: string;
    personality?: string;
    motion?: string;
  };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const slug = body.slug?.trim() ?? "";
  const name = body.name?.trim() ?? "";
  if (!/^[a-z0-9]+(_[a-z0-9]+)*$/.test(slug)) {
    return NextResponse.json(
      { error: 'slug ต้องเป็น snake_case เช่น "pharmacist_pim" (a-z, 0-9, ขีดล่าง)' },
      { status: 400 },
    );
  }
  if (!name) return NextResponse.json({ error: "กรุณาตั้งชื่อตัวละคร" }, { status: 400 });
  if (BUILTIN_IDS.has(slug)) {
    return NextResponse.json(
      { error: `slug "${slug}" ซ้ำกับตัวละคร built-in — ใช้ชื่ออื่น` },
      { status: 409 },
    );
  }

  const MOTIONS = ["none", "bob", "sway", "pulse"];
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("sim_characters")
    .insert({
      slug,
      name,
      role: body.role?.trim() || null,
      plate_top: body.plateTop?.trim() || "#2FA8A0",
      plate_bottom: body.plateBottom?.trim() || "#17706B",
      personality: body.personality?.trim() || null,
      motion: MOTIONS.includes(body.motion ?? "") ? body.motion : "none",
    })
    .select("id")
    .single();
  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ error: `slug "${slug}" มีอยู่แล้ว` }, { status: 409 });
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  return NextResponse.json({ id: data.id });
}
