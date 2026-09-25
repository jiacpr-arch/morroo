import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { isPlanType } from "@/lib/membership";
import { DEFAULT_ORG_PLAN, validateSeats, type Organization } from "@/lib/organizations";
import { assignOwner, findProfileByEmail, insertOrgWithCode } from "@/lib/organizations-server";

export const runtime = "nodejs";

/**
 * Group / institution plans — site admin only. Billing is manual for the MVP:
 * the org is created here after an offline payment / invoice.
 *
 * GET  /api/admin/organizations
 *   → { items: (Organization & { note, member_count, owners: {user_id,email,name}[] })[] }
 *
 * POST /api/admin/organizations
 *   Body: { name, seats, plan?, expires_at, note?, owner_email? }
 *   → { item: Organization, warning?: string }
 */

type MemberRow = { org_id: string; user_id: string; role: string };

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const admin = createAdminClient();
  const [{ data: orgs, error }, { data: members }] = await Promise.all([
    admin
      .from("organizations")
      .select("id, name, seats, plan, expires_at, join_code, note, created_at")
      .order("created_at", { ascending: false }),
    admin.from("organization_members").select("org_id, user_id, role"),
  ]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const rows = (members ?? []) as MemberRow[];
  const ownerIds = [...new Set(rows.filter((m) => m.role === "owner").map((m) => m.user_id))];
  const { data: profiles } = ownerIds.length
    ? await admin.from("profiles").select("id, email, name").in("id", ownerIds)
    : { data: [] };
  const profileById = new Map(
    ((profiles ?? []) as { id: string; email: string | null; name: string | null }[]).map((p) => [p.id, p])
  );

  const items = ((orgs ?? []) as (Organization & { note: string | null })[]).map((o) => {
    const mine = rows.filter((m) => m.org_id === o.id);
    return {
      ...o,
      member_count: mine.length,
      owners: mine
        .filter((m) => m.role === "owner")
        .map((m) => ({
          user_id: m.user_id,
          email: profileById.get(m.user_id)?.email ?? null,
          name: profileById.get(m.user_id)?.name ?? null,
        })),
    };
  });
  return NextResponse.json({ items });
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: Record<string, unknown>;
  try {
    body = (await request.json()) as Record<string, unknown>;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }

  const name = typeof body.name === "string" ? body.name.trim() : "";
  if (!name) return NextResponse.json({ error: "กรุณาใส่ชื่อกลุ่ม" }, { status: 400 });

  const seats = validateSeats(body.seats);
  if (!seats.ok) return NextResponse.json({ error: seats.error }, { status: 400 });

  const plan = body.plan === undefined || body.plan === "" ? DEFAULT_ORG_PLAN : body.plan;
  if (!isPlanType(plan)) return NextResponse.json({ error: "invalid plan" }, { status: 400 });

  const expires = new Date(String(body.expires_at ?? ""));
  if (Number.isNaN(expires.getTime())) {
    return NextResponse.json({ error: "วันหมดอายุไม่ถูกต้อง" }, { status: 400 });
  }

  const ownerEmail = typeof body.owner_email === "string" ? body.owner_email.trim() : "";
  const owner = ownerEmail ? await findProfileByEmail(ownerEmail) : null;
  if (ownerEmail && !owner) {
    return NextResponse.json(
      { error: `ไม่พบผู้ใช้อีเมล ${ownerEmail} (ต้องสมัครสมาชิกก่อน)` },
      { status: 400 }
    );
  }

  const { org, error } = await insertOrgWithCode({
    name,
    seats: seats.seats,
    plan,
    expires_at: expires.toISOString(),
    note: typeof body.note === "string" ? body.note.trim() || null : null,
    created_by: guard.userId,
  });
  if (!org) return NextResponse.json({ error: error ?? "create failed" }, { status: 500 });

  let warning: string | undefined;
  if (owner) {
    const err = await assignOwner(org.id, owner.id);
    if (err) warning = `สร้างกลุ่มแล้ว แต่ตั้งเจ้าของไม่สำเร็จ: ${err}`;
  }
  return NextResponse.json({ item: org, warning });
}
