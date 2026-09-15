/**
 * Discount coupons at Stripe checkout.
 *
 * `validateDiscountCoupon` runs at checkout-session creation (and for the
 * payment page's live preview): every rule of `redeem_coupon_code` is
 * re-checked here read-only, the discounted amount is computed, and the
 * coupon id travels in the session metadata. `recordDiscountRedemption`
 * runs at fulfillment and consumes one use atomically via the RPC — a
 * coupon that got exhausted between checkout and payment is still honoured
 * (the customer already paid the discounted price) but logged.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import {
  COUPON_PLATFORM,
  applyDiscount,
  couponAppliesTo,
  isDiscountCoupon,
} from "@/lib/coupons";

export type DiscountError =
  | "not_found"
  | "inactive"
  | "wrong_platform"
  | "not_started"
  | "expired"
  | "exhausted"
  | "already_redeemed"
  | "not_discount"
  | "wrong_plan";

export type DiscountResult =
  | {
      ok: true;
      couponId: string;
      code: string;
      couponType: "discount_percent" | "discount_fixed";
      value: number;
      originalAmount: number;
      finalAmount: number;
      discount: number;
    }
  | { ok: false; error: DiscountError };

export async function validateDiscountCoupon(
  rawCode: string,
  userId: string,
  planType: string,
  amount: number
): Promise<DiscountResult> {
  const code = rawCode.trim().toUpperCase();
  if (!code) return { ok: false, error: "not_found" };
  const admin = createAdminClient();

  const { data: c } = await admin
    .from("coupon_codes")
    .select(
      "id, code, coupon_type, value, platform, max_uses, max_uses_per_user, current_uses, starts_at, expires_at, is_active, plan_type"
    )
    .eq("code", code)
    .maybeSingle();
  if (!c) return { ok: false, error: "not_found" };
  if (!isDiscountCoupon(c.coupon_type)) return { ok: false, error: "not_discount" };
  if (!c.is_active) return { ok: false, error: "inactive" };
  if (c.platform !== "all" && c.platform !== COUPON_PLATFORM) {
    return { ok: false, error: "wrong_platform" };
  }
  const now = Date.now();
  if (c.starts_at && new Date(c.starts_at).getTime() > now) return { ok: false, error: "not_started" };
  if (c.expires_at && new Date(c.expires_at).getTime() <= now) return { ok: false, error: "expired" };
  if (c.max_uses != null && (c.current_uses ?? 0) >= c.max_uses) return { ok: false, error: "exhausted" };
  if (!couponAppliesTo(c.plan_type, planType)) return { ok: false, error: "wrong_plan" };

  const { count } = await admin
    .from("coupon_redemptions")
    .select("id", { count: "exact", head: true })
    .eq("coupon_id", c.id)
    .eq("user_id", userId);
  if ((count ?? 0) >= (c.max_uses_per_user ?? 1)) return { ok: false, error: "already_redeemed" };

  const finalAmount = applyDiscount(amount, c.coupon_type, c.value);
  return {
    ok: true,
    couponId: c.id,
    code: c.code,
    couponType: c.coupon_type,
    value: c.value,
    originalAmount: amount,
    finalAmount,
    discount: amount - finalAmount,
  };
}

/** Consume one use after a discounted session is paid (idempotent per session). */
export async function recordDiscountRedemption(
  code: string,
  userId: string,
  stripeSessionId: string
): Promise<void> {
  const admin = createAdminClient();
  const { data: existing } = await admin
    .from("coupon_redemptions")
    .select("id")
    .eq("stripe_session_id", stripeSessionId)
    .maybeSingle();
  if (existing) return;

  const { data, error } = await admin.rpc("redeem_coupon_code", {
    p_code: code,
    p_user_id: userId,
    p_platform: COUPON_PLATFORM,
  });
  if (error) {
    console.error("[coupon] record redemption failed:", code, error.message);
    return;
  }
  const row = (Array.isArray(data) ? data[0] : data) as { coupon_id: string } | undefined;
  if (row?.coupon_id) {
    await admin
      .from("coupon_redemptions")
      .update({ stripe_session_id: stripeSessionId })
      .eq("coupon_id", row.coupon_id)
      .eq("user_id", userId)
      .is("stripe_session_id", null);
  }
}

export const DISCOUNT_ERROR_TH: Record<DiscountError, string> = {
  not_found: "ไม่พบโค้ดนี้",
  inactive: "โค้ดนี้ถูกปิดใช้งาน",
  wrong_platform: "โค้ดนี้ใช้กับแพลตฟอร์มอื่น",
  not_started: "โค้ดนี้ยังไม่เริ่มใช้งาน",
  expired: "โค้ดนี้หมดอายุแล้ว",
  exhausted: "โค้ดนี้ถูกใช้ครบจำนวนแล้ว",
  already_redeemed: "คุณใช้โค้ดนี้ไปแล้ว",
  not_discount: "โค้ดนี้เป็นโค้ดสมาชิกฟรี — กรอกที่หน้า /redeem",
  wrong_plan: "โค้ดนี้ใช้กับแพ็กอื่น",
};
