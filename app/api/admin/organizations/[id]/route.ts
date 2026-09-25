import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { isPlanType } from "@/lib/membership";
import { validateSeats } from "@/lib/organizations";
import {
  assignOwner,
  countMembers,
  findProfileByEmail,
  regenerateJoinCode,
} from "@/lib/organizations-server";

export const runtime = "nodejs";

/**
 * PATCH /api/admin/organizations/[id]
 *   Body (any subset):
 *     { name, seats, plan, expires_at, note }  → update fields
 *     { regenerate_code: true }                → new join code (old links stop working)
 *     { owner_email }                          → add / promote that user as owner
 *   → { ok: true, join_code?, warning? }
 *
 * DELETE /api/admin/organizations/[id]
 *   Deletes the org and every membership (cascade) — members lose group
 *   access immediately. Setting expires_at to now keeps the history instead.
 */

type Ctx = { params: Promise<{ id: string }> };

export async function PATCH(request: Request, { params }: Ctx) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: Record<string, unknown>;
  try {
    body = (await request.json()) as Record<string, unknown>;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (typeof body.name === "string") {
    if (!body.name.trim()) return NextResponse.json({ error: "กรุณาใส่ชื่อกลุ่ม" }, { status: 400 });
    patch.name = body.name.trim();
  }
  if ("seats" in body) {
    const seats = validateSeats(body.seats, await countMembers(id));
    if (!seats.ok) return NextResponse.json({ error: seats.error }, { status: 400 });
    patch.seats = seats.seats;
  }
  if ("plan" in body) {
    if (!isPlanType(body.plan)) return NextResponse.json({ error: "invalid plan" }, { status: 400 });
    patch.plan = body.plan;
  }
  if ("expires_at" in body) {
    const d = new Date(String(body.expires_at ?? ""));
    if (Number.isNaN(d.getTime())) {
      return NextResponse.json({ error: "วันหมดอายุไม่ถูกต้อง" }, { status: 400 });
    }
    patch.expires_at = d.toISOString();
  }
  if (typeof body.note === "string") patch.note = body.note.trim() || null;

  const admin = createAdminClient();
  if (Object.keys(patch).length > 0) {
    const { error } = await admin.from("organizations").update(patch).eq("id", id);
    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  }

  let joinCode: string | undefined;
  if (body.regenerate_code === true) {
    const code = await regenerateJoinCode(id);
    if (!code) return NextResponse.json({ error: "สร้างรหัสใหม่ไม่สำเร็จ" }, { status: 500 });
    joinCode = code;
  }

  let warning: string | undefined;
  if (typeof body.owner_email === "string" && body.owner_email.trim()) {
    const owner = await findProfileByEmail(body.owner_email);
    if (!owner) {
      return NextResponse.json(
        { error: `ไม่พบผู้ใช้อีเมล ${body.owner_email.trim()} (ต้องสมัครสมาชิกก่อน)` },
        { status: 400 }
      );
    }
    const err = await assignOwner(id, owner.id);
    if (err) return NextResponse.json({ error: err }, { status: 500 });
    const [{ data: org }, count] = await Promise.all([
      admin.from("organizations").select("seats").eq("id", id).maybeSingle(),
      countMembers(id),
    ]);
    const seats = (org as { seats?: number } | null)?.seats ?? 0;
    if (count > seats) warning = `สมาชิก ${count} คน เกินจำนวนที่นั่ง (${seats}) แล้ว`;
  }

  return NextResponse.json({ ok: true, join_code: joinCode, warning });
}

export async function DELETE(_request: Request, { params }: Ctx) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;
  const admin = createAdminClient();
  const { error } = await admin.from("organizations").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ ok: true });
}
