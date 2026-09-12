import crypto from "crypto";
import type { CouponType } from "@/lib/types-standard";

// morroo is the "medical" platform; the shared DB also serves a pharmacy app.
export const COUPON_PLATFORM = "medical" as const;

// Coupon types the app can actually apply on its own. Discount coupons need a
// price adjustment at checkout, which the slip-based payment flow doesn't do
// yet, so they are listed but not redeemable via /redeem.
export const SELF_SERVE_COUPON_TYPES: readonly CouponType[] = ["free_trial", "free_month"];

export function isSelfServeCoupon(type: string): type is "free_trial" | "free_month" {
  return (SELF_SERVE_COUPON_TYPES as readonly string[]).includes(type);
}

/** Membership days granted by a self-serve coupon. */
export function couponRewardDays(type: "free_trial" | "free_month", value: number): number {
  return type === "free_trial" ? value : value * 30;
}

export function couponRewardLabel(type: CouponType, value: number): string {
  switch (type) {
    case "free_trial":
      return `สมาชิกฟรี ${value} วัน`;
    case "free_month":
      return `สมาชิกฟรี ${value} เดือน`;
    case "discount_percent":
      return `ส่วนลด ${value}%`;
    case "discount_fixed":
      return `ส่วนลด ฿${value}`;
  }
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
