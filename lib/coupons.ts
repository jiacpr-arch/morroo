import crypto from "crypto";
import type { CouponType } from "@/lib/types-standard";
import { PLAN_CATALOG, isPlanType, planLabel } from "@/lib/membership";
import { isItemPlan } from "@/lib/items";

// morroo is the "medical" platform; the shared DB also serves a pharmacy app.
export const COUPON_PLATFORM = "medical" as const;

// Free coupons are applied by /redeem (grant days of a plan or item).
// Discount coupons are applied at Stripe checkout (lib/billing/coupon-checkout.ts).
export const SELF_SERVE_COUPON_TYPES: readonly CouponType[] = ["free_trial", "free_month"];
export const DISCOUNT_COUPON_TYPES: readonly CouponType[] = ["discount_percent", "discount_fixed"];

export function isSelfServeCoupon(type: string): type is "free_trial" | "free_month" {
  return (SELF_SERVE_COUPON_TYPES as readonly string[]).includes(type);
}

export function isDiscountCoupon(type: string): type is "discount_percent" | "discount_fixed" {
  return (DISCOUNT_COUPON_TYPES as readonly string[]).includes(type);
}

/** Membership days granted by a self-serve coupon. */
export function couponRewardDays(type: "free_trial" | "free_month", value: number): number {
  return type === "free_trial" ? value : value * 30;
}

/** Legacy default: a free coupon with no plan_type grants the student pack. */
export const DEFAULT_COUPON_PLAN = "monthly";

/** Plan string a free coupon grants (plan or item), never empty. */
export function couponGrantPlan(planType: string | null | undefined): string {
  return planType && planType.trim() ? planType.trim() : DEFAULT_COUPON_PLAN;
}

/** Accepts a PLAN_CATALOG plan or an item plan string (`item:…`). */
export function isValidCouponPlan(planType: unknown): planType is string {
  return typeof planType === "string" && (isPlanType(planType) || isItemPlan(planType));
}

/** Short Thai name for a plan string (item strings show their kind). */
export function couponPlanLabel(planType: string | null | undefined): string {
  const p = couponGrantPlan(planType);
  if (isPlanType(p)) return p === "monthly" || p === "yearly" ? `แพ็ก นศพ. ${PLAN_CATALOG[p].label}` : planLabel(p);
  if (isItemPlan(p)) return `รายการ ${p.slice("item:".length)}`;
  return p;
}

export function couponRewardLabel(type: CouponType, value: number, planType?: string | null): string {
  switch (type) {
    case "free_trial":
      return `${couponPlanLabel(planType)} ฟรี ${value} วัน`;
    case "free_month":
      return `${couponPlanLabel(planType)} ฟรี ${value} เดือน`;
    case "discount_percent":
      return `ส่วนลด ${value}%${planType ? ` (${couponPlanLabel(planType)})` : ""}`;
    case "discount_fixed":
      return `ส่วนลด ฿${value}${planType ? ` (${couponPlanLabel(planType)})` : ""}`;
  }
}

/** Stripe's minimum charge in THB. */
export const MIN_CHARGE_THB = 10;

/** Price after a discount coupon, never below the Stripe minimum. */
export function applyDiscount(
  amount: number,
  type: "discount_percent" | "discount_fixed",
  value: number
): number {
  const discounted =
    type === "discount_percent"
      ? Math.round(amount * (1 - Math.min(100, Math.max(0, value)) / 100))
      : amount - value;
  return Math.max(MIN_CHARGE_THB, discounted);
}

/** Does a coupon's plan restriction allow this plan string? (null = any) */
export function couponAppliesTo(couponPlan: string | null | undefined, planType: string): boolean {
  if (!couponPlan) return true;
  return couponPlan === planType;
}

// Crockford-ish alphabet without 0/O/1/I — same spirit as lib/redeem.ts.
const ALPHABET = "23456789ABCDEFGHJKMNPQRSTVWXYZ";

export function generateCouponCode(prefix = "MORROO", length = 6): string {
  const bytes = crypto.randomBytes(length);
  let out = "";
  for (let i = 0; i < length; i++) out += ALPHABET[bytes[i] % ALPHABET.length];
  return `${prefix.toUpperCase()}-${out}`;
}

export const COUPON_CODE_RE = /^[A-Z0-9-]{4,40}$/;
