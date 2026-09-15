import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";
import { COUPON_CODE_RE, generateCouponCode, isValidCouponPlan } from "@/lib/coupons";
import { resolvePurchasable } from "@/lib/billing/plan-resolver";
import type { CouponCode, CouponType, CouponPlatform } from "@/lib/types-standard";

export const runtime = "nodejs";

/**
 * Admin coupon / voucher management (coupon_codes + coupon_redemptions).
 *
 * GET  /api/admin/coupons
 *   → { items: (CouponCode & { redemptions: {user_id,email,name,redeemed_at}[] })[] }
 *
 * POST /api/admin/coupons
 *   Body: {
 *     coupon_type: "free_trial" | "free_month" | "discount_percent" | "discount_fixed",
 *     value: number,            // days / months / % / THB
 *     platform?: "medical" | "pharmacy" | "all"   (default "all")
 *     code?: string,            // custom code; omit to auto-generate MORROO-XXXXXX
 *     count?: number,           // 1-100 auto-generated codes (ignored when code is given)
 *     max_uses?: number | null, // null = unlimited
 *     max_uses_per_user?: number,
 *     expires_at?: string | null,
 *     starts_at?: string | null,
 *     description?: string, source?: string,
 *     plan_type?: string,      // free_*: what to grant (default "monthly"); discount_*: limit to this plan
 *   }
 *   → { items: CouponCode[] }
 */

const TYPES: readonly CouponType[] = ["free_trial", "free_month", "discount_percent", "discount_fixed"];
const PLATFORMS: readonly CouponPlatform[] = ["medical", "pharmacy", "all"];

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const admin = createAdminClient();
  const [{ data: coupons, error }, { data: redemptions }] = await Promise.all([
    admin.from("coupon_codes").select("*").order("created_at", { ascending: false }).limit(500),
    admin
      .from("coupon_redemptions")
      .select("coupon_id, user_id, redeemed_at")
      .order("redeemed_at", { ascending: false })
      .limit(2000),
  ]);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  const userIds = Array.from(new Set((redemptions ?? []).map((r) => r.user_id).filter(Boolean)));
  const profileMap = new Map<string, { email: string | null; name: string | null }>();
  if (userIds.length > 0) {
    const { data: profiles } = await admin
      .from("profiles")
      .select("id, email, name")
      .in("id", userIds);
    for (const p of profiles ?? []) profileMap.set(p.id, { email: p.email, name: p.name });
  }

  const byCoupon = new Map<string, Array<{ user_id: string; email: string | null; name: string | null; redeemed_at: string }>>();
  for (const r of redemptions ?? []) {
    if (!r.coupon_id || !r.user_id) continue;
    const list = byCoupon.get(r.coupon_id) ?? [];
    list.push({
      user_id: r.user_id,
      email: profileMap.get(r.user_id)?.email ?? null,
      name: profileMap.get(r.user_id)?.name ?? null,
      redeemed_at: r.redeemed_at,
    });
    byCoupon.set(r.coupon_id, list);
  }

  const items = ((coupons ?? []) as CouponCode[]).map((c) => ({
    ...c,
    redemptions: byCoupon.get(c.id) ?? [],
  }));
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

  const couponType = String(body.coupon_type ?? "");
  if (!(TYPES as readonly string[]).includes(couponType)) {
    return NextResponse.json({ error: `coupon_type must be one of: ${TYPES.join(", ")}` }, { status: 400 });
  }
  const value = Number(body.value);
  if (!Number.isInteger(value) || value < 1) {
    return NextResponse.json({ error: "value must be a positive integer" }, { status: 400 });
  }
  if (couponType === "free_trial" && value > 365) {
    return NextResponse.json({ error: "free_trial value (days) must be 1-365" }, { status: 400 });
  }
  if (couponType === "discount_percent" && value > 100) {
    return NextResponse.json({ error: "discount_percent must be 1-100" }, { status: 400 });
  }
  const platform = String(body.platform ?? "all");
  if (!(PLATFORMS as readonly string[]).includes(platform)) {
    return NextResponse.json({ error: `platform must be one of: ${PLATFORMS.join(", ")}` }, { status: 400 });
  }

  const maxUses =
    body.max_uses === null || body.max_uses === undefined || body.max_uses === ""
      ? null
      : Number(body.max_uses);
  if (maxUses !== null && (!Number.isInteger(maxUses) || maxUses < 1 || maxUses > 100000)) {
    return NextResponse.json({ error: "max_uses must be 1-100000 or empty" }, { status: 400 });
  }
  const maxPerUser = body.max_uses_per_user === undefined ? 1 : Number(body.max_uses_per_user);
  if (!Number.isInteger(maxPerUser) || maxPerUser < 1) {
    return NextResponse.json({ error: "max_uses_per_user must be >= 1" }, { status: 400 });
  }

  function parseDate(v: unknown, field: string): string | null | { error: string } {
    if (v === null || v === undefined || v === "") return null;
    const d = new Date(String(v));
    if (Number.isNaN(d.getTime())) return { error: `${field} is not a valid date` };
    return d.toISOString();
  }
  const expiresAt = parseDate(body.expires_at, "expires_at");
  if (expiresAt && typeof expiresAt === "object") return NextResponse.json(expiresAt, { status: 400 });
  if (expiresAt && new Date(expiresAt) <= new Date()) {
    return NextResponse.json({ error: "expires_at must be in the future" }, { status: 400 });
  }
  const startsAt = parseDate(body.starts_at, "starts_at");
  if (startsAt && typeof startsAt === "object") return NextResponse.json(startsAt, { status: 400 });

  // What the coupon grants (free_*) or is limited to (discount_*): a
  // PLAN_CATALOG plan or an item string, validated against the catalog / DB.
  let planType: string | null = null;
  if (typeof body.plan_type === "string" && body.plan_type.trim()) {
    const candidate = body.plan_type.trim();
    if (!isValidCouponPlan(candidate) || !(await resolvePurchasable(candidate))) {
      return NextResponse.json({ error: "plan_type is not a known plan or item" }, { status: 400 });
    }
    planType = candidate;
  }

  const description = typeof body.description === "string" ? body.description.trim() || null : null;
  const source = typeof body.source === "string" ? body.source.trim() || null : null;

  const customCode = typeof body.code === "string" ? body.code.trim().toUpperCase() : "";
  let codes: string[];
  if (customCode) {
    if (!COUPON_CODE_RE.test(customCode)) {
      return NextResponse.json(
        { error: "code must be 4-40 chars of A-Z, 0-9 and '-'" },
        { status: 400 },
      );
    }
    codes = [customCode];
  } else {
    const count = Number(body.count ?? 1);
    if (!Number.isInteger(count) || count < 1 || count > 100) {
      return NextResponse.json({ error: "count must be 1-100" }, { status: 400 });
    }
    codes = Array.from({ length: count }, () => generateCouponCode());
  }

  const admin = createAdminClient();
  const rows = codes.map((code) => ({
    code,
    description,
    coupon_type: couponType,
    value,
    platform,
    max_uses: maxUses,
    max_uses_per_user: maxPerUser,
    current_uses: 0,
    starts_at: startsAt ?? new Date().toISOString(),
    expires_at: expiresAt,
    source,
    plan_type: planType,
    is_active: true,
    created_by: guard.userId,
  }));

  const { data, error } = await admin.from("coupon_codes").insert(rows).select("*");
  if (error) {
    const status = error.code === "23505" ? 409 : 500;
    const message = error.code === "23505" ? `โค้ด ${customCode || "(auto)"} มีอยู่แล้ว` : error.message;
    return NextResponse.json({ error: message }, { status });
  }
  return NextResponse.json({ items: data ?? [] });
}
