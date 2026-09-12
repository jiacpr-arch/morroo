import { describe, it, expect } from "vitest";
import {
  MIN_CHARGE_THB,
  applyDiscount,
  couponAppliesTo,
  couponGrantPlan,
  couponRewardDays,
  couponRewardLabel,
  isDiscountCoupon,
  isSelfServeCoupon,
  isValidCouponPlan,
} from "./coupons";

describe("coupon plan target", () => {
  it("defaults free coupons to the student pack", () => {
    expect(couponGrantPlan(null)).toBe("monthly");
    expect(couponGrantPlan("")).toBe("monthly");
    expect(couponGrantPlan(" board_monthly ")).toBe("board_monthly");
  });
  it("accepts catalog plans and item strings only", () => {
    expect(isValidCouponPlan("board_yearly")).toBe(true);
    expect(isValidCouponPlan("item:board_specialty:surgery:month")).toBe(true);
    expect(isValidCouponPlan("gold")).toBe(false);
    expect(isValidCouponPlan(null)).toBe(false);
  });
  it("labels include the target", () => {
    expect(couponRewardLabel("free_trial", 7, null)).toContain("แพ็ก นศพ.");
    expect(couponRewardLabel("free_trial", 7, "board_monthly")).toContain("Board");
    expect(couponRewardLabel("free_month", 2, "mcq_monthly")).toContain("2 เดือน");
    expect(couponRewardLabel("discount_percent", 20, null)).toBe("ส่วนลด 20%");
    expect(couponRewardLabel("discount_fixed", 50, "yearly")).toContain("รายปี");
  });
  it("classifies types", () => {
    expect(isSelfServeCoupon("free_trial")).toBe(true);
    expect(isDiscountCoupon("free_trial")).toBe(false);
    expect(isDiscountCoupon("discount_fixed")).toBe(true);
    expect(couponRewardDays("free_month", 2)).toBe(60);
  });
});

describe("discounts", () => {
  it("percent and fixed", () => {
    expect(applyDiscount(199, "discount_percent", 20)).toBe(159);
    expect(applyDiscount(199, "discount_fixed", 50)).toBe(149);
  });
  it("never goes below the Stripe minimum", () => {
    expect(applyDiscount(29, "discount_fixed", 100)).toBe(MIN_CHARGE_THB);
    expect(applyDiscount(199, "discount_percent", 100)).toBe(MIN_CHARGE_THB);
  });
  it("plan restriction", () => {
    expect(couponAppliesTo(null, "monthly")).toBe(true);
    expect(couponAppliesTo("board_monthly", "board_monthly")).toBe(true);
    expect(couponAppliesTo("board_monthly", "monthly")).toBe(false);
  });
});
