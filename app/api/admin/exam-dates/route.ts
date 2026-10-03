import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import { ROUND_KINDS } from "@/lib/exam-round-extract";
import { isRealIsoDate } from "@/lib/thai-date";

export const runtime = "nodejs";

const COLUMNS =
  "id, kind, label, exam_date, confirmed, is_active, source, source_url, evidence, locked, previous_date, updated_at";

type Parsed = { ok: true; fields: Record<string, unknown> } | { ok: false; error: string };

/** ตรวจ body ที่แอดมินส่งมา; partial=true สำหรับ PATCH (ส่งเฉพาะฟิลด์ที่แก้) */
function parseFields(body: Record<string, unknown>, partial: boolean): Parsed {
  const f: Record<string, unknown> = {};
  if (!partial || "kind" in body) {
    if (typeof body.kind !== "string" || !(ROUND_KINDS as readonly string[]).includes(body.kind)) {
      return { ok: false, error: "kind ไม่ถูกต้อง" };
    }
    f.kind = body.kind;
  }
  if (!partial || "label" in body) {
    const label = typeof body.label === "string" ? body.label.trim() : "";
    if (!label || label.length > 200) return { ok: false, error: "ชื่อรอบไม่ถูกต้อง" };
    f.label = label;
  }
  if (!partial || "exam_date" in body) {
    if (typeof body.exam_date !== "string" || !isRealIsoDate(body.exam_date)) {
      return { ok: false, error: "วันที่ไม่ถูกต้อง (YYYY-MM-DD)" };
    }
    f.exam_date = body.exam_date;
  }
  for (const k of ["confirmed", "is_active"] as const) {
    if (k in body) {
      if (typeof body[k] !== "boolean") return { ok: false, error: `${k} ต้องเป็น boolean` };
      f[k] = body[k];
    } else if (!partial && k === "confirmed") {
      f.confirmed = true;
    }
  }
  return { ok: true, fields: f };
}

export async function GET() {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const { data, error } = await createAdminClient()
    .from("exam_rounds")
    .select(COLUMNS)
    .order("exam_date", { ascending: true });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ rounds: data ?? [] });
}

export async function POST(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const parsed = parseFields(body, false);
  if (!parsed.ok) return NextResponse.json({ error: parsed.error }, { status: 400 });
  const { data, error } = await createAdminClient()
    .from("exam_rounds")
    .insert({ ...parsed.fields, source: "manual", locked: true })
    .select(COLUMNS)
    .single();
  if (error) {
    const msg = error.code === "23505" ? "มีรอบชนิด/ชื่อนี้อยู่แล้ว" : error.message;
    return NextResponse.json({ error: msg }, { status: error.code === "23505" ? 409 : 500 });
  }
  return NextResponse.json({ round: data });
}

export async function PATCH(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  if (typeof body.id !== "string") return NextResponse.json({ error: "ต้องมี id" }, { status: 400 });
  const parsed = parseFields(body, true);
  if (!parsed.ok) return NextResponse.json({ error: parsed.error }, { status: 400 });
  const update: Record<string, unknown> = { ...parsed.fields, updated_at: new Date().toISOString() };
  // แอดมินแก้เอง = ล็อก กันระบบอัตโนมัติมาทับ; ปลดล็อกได้ด้วย locked:false
  update.locked = typeof body.locked === "boolean" ? body.locked : true;
  if (Object.keys(parsed.fields).length === 0 && typeof body.locked !== "boolean") {
    return NextResponse.json({ error: "ไม่มีฟิลด์ที่แก้ได้" }, { status: 400 });
  }
  const { data, error } = await createAdminClient()
    .from("exam_rounds")
    .update(update)
    .eq("id", body.id)
    .select(COLUMNS)
    .single();
  if (error) {
    const msg = error.code === "23505" ? "มีรอบชนิด/ชื่อนี้อยู่แล้ว" : error.message;
    return NextResponse.json({ error: msg }, { status: error.code === "23505" ? 409 : 500 });
  }
  return NextResponse.json({ round: data });
}

export async function DELETE(request: Request) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;
  const id = new URL(request.url).searchParams.get("id");
  if (!id) return NextResponse.json({ error: "ต้องมี id" }, { status: 400 });
  const { error } = await createAdminClient().from("exam_rounds").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
