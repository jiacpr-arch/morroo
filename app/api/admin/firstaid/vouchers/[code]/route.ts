import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

export const runtime = "nodejs";

/**
 * PATCH /api/admin/firstaid/vouchers/[code]
 *   Body: { status: "void" | "active" }
 *   - void:   cancel an unused code (active → void)
 *   - active: re-enable a voided code (void → active)
 *   Redeemed codes are immutable — the entitlement has already been granted.
 *
 * DELETE /api/admin/firstaid/vouchers/[code]
 *   Hard-delete a code that was never redeemed.
 */

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ code: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { code: raw } = await params;
  const code = decodeURIComponent(raw).trim().toUpperCase();

  let body: { status?: unknown };
  try {
    body = (await request.json()) as typeof body;
  } catch {
    return NextResponse.json({ error: "Invalid JSON" }, { status: 400 });
  }
  const next = body.status;
  if (next !== "void" && next !== "active") {
    return NextResponse.json(
      { error: "status must be 'void' or 'active'" },
      { status: 400 },
    );
  }
  const from = next === "void" ? "active" : "void";

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("fa_vouchers")
    .update({ status: next })
    .eq("code", code)
    .eq("status", from)
    .select("code, status")
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) {
    return NextResponse.json(
      { error: `voucher not found or not in '${from}' state` },
      { status: 409 },
    );
  }
  return NextResponse.json({ item: data });
}

export async function DELETE(
  _request: Request,
  { params }: { params: Promise<{ code: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const { code: raw } = await params;
  const code = decodeURIComponent(raw).trim().toUpperCase();

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("fa_vouchers")
    .delete()
    .eq("code", code)
    .neq("status", "redeemed")
    .select("code")
    .maybeSingle();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  if (!data) {
    return NextResponse.json(
      { error: "voucher not found or already redeemed" },
      { status: 409 },
    );
  }
  return NextResponse.json({ ok: true });
}
