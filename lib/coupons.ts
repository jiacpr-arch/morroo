/**
 * Coupon / promotion engine.
 *
 * validate: checks if a coupon code is valid for a given plan and user.
 * apply:    records the redemption and increments uses_count atomically.
 */

import { createAdminClient } from "@/lib/supabase/admin";

export type DiscountType = "percent" | "fixed";

export interface CouponRow {
  id: string;
  code: string;
  description: string | null;
  discount_type: DiscountType;
  discount_value: number;
  max_uses: number | null;
  uses_count: number;
  applicable_plans: string[] | null;
  valid_from: string;
  valid_until: string | null;
  is_active: boolean;
}

export interface ValidateCouponResult {
  valid: true;
  couponId: string;
  discountType: DiscountType;
  discountValue: number;
  /** Final THB amount off (rounded to 2dp) */
  discountAmount: number;
  /** Price after discount */
  finalPrice: number;
  description: string | null;
}

export interface ValidateCouponError {
  valid: false;
  reason:
    | "not_found"
    | "inactive"
    | "expired"
    | "not_started"
    | "max_uses_reached"
    | "plan_not_applicable"
    | "already_used";
}

export type ValidateCouponResponse = ValidateCouponResult | ValidateCouponError;

export async function validateCoupon(
  code: string,
  planType: string,
  originalPrice: number,
  userId?: string
): Promise<ValidateCouponResponse> {
  const supabase = createAdminClient();
  const now = new Date().toISOString();

  const { data: coupon, error } = await supabase
    .from("coupons")
    .select("*")
    .eq("code", code.trim().toUpperCase())
    .maybeSingle();

  if (error || !coupon) return { valid: false, reason: "not_found" };
  if (!coupon.is_active) return { valid: false, reason: "inactive" };
  if (coupon.valid_from > now) return { valid: false, reason: "not_started" };
  if (coupon.valid_until && coupon.valid_until < now) return { valid: false, reason: "expired" };
  if (coupon.max_uses !== null && coupon.uses_count >= coupon.max_uses) {
    return { valid: false, reason: "max_uses_reached" };
  }

  const plans = coupon.applicable_plans as string[] | null;
  if (plans && plans.length > 0 && !plans.includes(planType)) {
    return { valid: false, reason: "plan_not_applicable" };
  }

  if (userId) {
    const { data: existing } = await supabase
      .from("coupon_redemptions")
      .select("id")
      .eq("coupon_id", coupon.id)
      .eq("user_id", userId)
      .maybeSingle();
    if (existing) return { valid: false, reason: "already_used" };
  }

  const discountAmount =
    coupon.discount_type === "percent"
      ? Math.round((originalPrice * coupon.discount_value) / 100 * 100) / 100
      : Math.min(coupon.discount_value, originalPrice);

  const finalPrice = Math.max(0, Math.round((originalPrice - discountAmount) * 100) / 100);

  return {
    valid: true,
    couponId: coupon.id,
    discountType: coupon.discount_type as DiscountType,
    discountValue: coupon.discount_value,
    discountAmount,
    finalPrice,
    description: coupon.description,
  };
}

export interface ApplyCouponArgs {
  couponId: string;
  userId: string;
  orderId?: string;
  planType: string;
  discountAmount: number;
}

export async function applyCoupon(args: ApplyCouponArgs): Promise<boolean> {
  const supabase = createAdminClient();

  const { error: redemptionError } = await supabase.from("coupon_redemptions").insert({
    coupon_id: args.couponId,
    user_id: args.userId,
    order_id: args.orderId ?? null,
    plan_type: args.planType,
    discount: args.discountAmount,
  });

  if (redemptionError) {
    console.error("[coupons] redemption insert failed:", redemptionError);
    return false;
  }

  // Increment uses_count
  const { error: incError } = await supabase.rpc("increment_coupon_uses", {
    p_coupon_id: args.couponId,
  });

  if (incError) {
    console.error("[coupons] uses_count increment failed:", incError);
  }

  return true;
}
