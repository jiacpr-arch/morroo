import { NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  fetchAllEntitlements,
  fetchEntitlements,
  grantPlan,
  grantProduct,
  revokeProduct,
  setProduct,
  syncLegacyMembership,
} from "@/lib/entitlements";
import { isPlanType, isProduct } from "@/lib/membership";

export const runtime = "nodejs";

/**
 * Admin membership management — per-product entitlements
 * (school · mcq · meq · longcase · board).
 *
 * GET  /api/admin/membership
 *   → { entitlements: Record<userId, EntitlementRow[]> }
 *
 * POST /api/admin/membership
 *   Body (one of):
 *     { userId, action: "grant_plan", planType, reference? }
 *         → grant every product of a plan for its duration (like a purchase)
 *     { userId, action: "grant", product, days, reference? }
 *         → stack `days` on one product (null days = lifetime)
 *     { userId, action: "set", product, expiresAt: ISO | null, reference? }
 *         → overwrite one product's expiry (null = lifetime)
 *     { userId, action: "revoke", product, reference? }
 *         → expire one product now
 *   Any of grant / set / revoke may carry `scope` (e.g. "subject:<id>") to
 *   target one purchased item instead of the whole product.
 *   → { ok: true, entitlements: EntitlementRow[], profile: { membership_type, membership_expires_at } }
 *
 * Every write re-derives the legacy profiles.membership_type / expiry summary.
 */

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const entitlements = await fetchAllEntitlements();
  return NextResponse.json({ entitlements });
}

type Body = {
  userId?: unknown;
  action?: unknown;
  planType?: unknown;
  product?: unknown;
  days?: unknown;
  expiresAt?: unknown;
  reference?: unknown;
  scope?: unknown;
};

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: Body;
  try {
    body = (await request.json()) as Body;
  } catch {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const userId = typeof body.userId === "string" ? body.userId : "";
  const action = typeof body.action === "string" ? body.action : "";
  const reference = typeof body.reference === "string" ? body.reference : null;
  // Optional item scope (lib/items.ts) — omitted = the whole product.
  const scope =
    typeof body.scope === "string" && /^[A-Za-z0-9_\-:*.]{1,120}$/.test(body.scope)
      ? body.scope
      : undefined;
  if (!userId) return NextResponse.json({ error: "missing_user" }, { status: 400 });

  const opts = { source: "admin" as const, reference, grantedBy: guard.userId, scope };
  let ok = false;

  switch (action) {
    case "grant_plan": {
      if (!isPlanType(body.planType)) {
        return NextResponse.json({ error: "invalid_plan" }, { status: 400 });
      }
      ok = (await grantPlan(userId, body.planType, opts)).ok;
      break;
    }
    case "grant": {
      if (!isProduct(body.product)) {
        return NextResponse.json({ error: "invalid_product" }, { status: 400 });
      }
      const days =
        body.days === null
          ? null
          : typeof body.days === "number" && Number.isFinite(body.days) && body.days > 0
            ? Math.round(body.days)
            : NaN;
      if (Number.isNaN(days)) {
        return NextResponse.json({ error: "invalid_days" }, { status: 400 });
      }
      ok = await grantProduct(userId, body.product, days, opts);
      if (ok) ok = await syncLegacyMembership(userId);
      break;
    }
    case "set": {
      if (!isProduct(body.product)) {
        return NextResponse.json({ error: "invalid_product" }, { status: 400 });
      }
      let expiresAt: Date | null;
      if (body.expiresAt === null) {
        expiresAt = null;
      } else if (typeof body.expiresAt === "string" && !Number.isNaN(Date.parse(body.expiresAt))) {
        expiresAt = new Date(body.expiresAt);
      } else {
        return NextResponse.json({ error: "invalid_expires_at" }, { status: 400 });
      }
      ok = await setProduct(userId, body.product, expiresAt, opts);
      if (ok) ok = await syncLegacyMembership(userId);
      break;
    }
    case "revoke": {
      if (!isProduct(body.product)) {
        return NextResponse.json({ error: "invalid_product" }, { status: 400 });
      }
      ok = await revokeProduct(userId, body.product, opts);
      if (ok) ok = await syncLegacyMembership(userId);
      break;
    }
    default:
      return NextResponse.json({ error: "invalid_action" }, { status: 400 });
  }

  if (!ok) return NextResponse.json({ error: "apply_failed" }, { status: 500 });

  const admin = createAdminClient();
  const [entitlements, { data: profile }] = await Promise.all([
    fetchEntitlements(admin, userId),
    admin
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", userId)
      .maybeSingle(),
  ]);
  return NextResponse.json({ ok: true, entitlements, profile });
}
