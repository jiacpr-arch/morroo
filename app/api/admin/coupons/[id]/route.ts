import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

export const runtime = "nodejs";

/**
 * PATCH /api/admin/coupons/[id]
 *   Body (any subset): { is_active, expires_at, max_uses, description, source }
 *
 * DELETE /api/admin/coupons/[id]
 *   Only allowed when nobody has redeemed the coupon; otherwise deactivate it
 *   (PATCH is_active=false) so the redemption history stays intact.
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
  if (typeof body.is_active === "boolean") patch.is_active = body.is_active;
  if ("expires_at" in body) {
    if (body.expires_at === null || body.expires_at === "") patch.expires_at = null;
    else {
      const d = new Date(String(body.expires_at));
      if (Number.isNaN(d.getTime())) {
        return NextResponse.json({ error: "expires_at is not a valid date" }, { status: 400 });
      }
      patch.expires_at = d.toISOString();
    }
  }
  if ("max_uses" in body) {
    if (body.max_uses === null || body.max_uses === "") patch.max_uses = null;
    else {
      const n = Number(body.max_uses);
      if (!Number.isInteger(n) || n < 1) {
        return NextResponse.json({ error: "max_uses must be >= 1 or empty" }, { status: 400 });
      }
      patch.max_uses = n;
    }
  }
  if (typeof body.description === "string") patch.description = body.description.trim() || null;
  if (typeof body.source === "string") patch.source = body.source.trim() || null;

  if (Object.keys(patch).length === 0) {
    return NextResponse.json({ error: "nothing to update" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("coupon_codes")
    .update(patch)
    .eq("id", id)
    .select("*")
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) return NextResponse.json({ error: "coupon not found" }, { status: 404 });
  return NextResponse.json({ item: data });
}

export async function DELETE(_request: Request, { params }: Ctx) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  const admin = createAdminClient();
  const { count } = await admin
    .from("coupon_redemptions")
    .select("id", { count: "exact", head: true })
    .eq("coupon_id", id);
  if ((count ?? 0) > 0) {
    return NextResponse.json(
      { error: "coupon has redemptions — deactivate it instead of deleting" },
      { status: 409 },
    );
  }

  const { data, error } = await admin
    .from("coupon_codes")
    .delete()
    .eq("id", id)
    .select("id")
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) return NextResponse.json({ error: "coupon not found" }, { status: 404 });
  return NextResponse.json({ ok: true });
}
