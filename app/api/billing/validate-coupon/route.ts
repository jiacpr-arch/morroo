/**
 * POST /api/billing/validate-coupon
 *
 * Validates a coupon code before checkout so the UI can show the discount.
 * Does NOT record redemption — that happens after payment succeeds.
 *
 * Body: { code: string, planType: string, originalPrice: number }
 */

import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { validateCoupon } from "@/lib/coupons";
import { STRIPE_PLANS } from "@/lib/stripe";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
  }

  const body = await request.json();
  const { code, planType } = body as { code?: string; planType?: string };

  if (!code || !planType || !STRIPE_PLANS[planType]) {
    return NextResponse.json({ valid: false, reason: "invalid_request" }, { status: 400 });
  }

  const plan = STRIPE_PLANS[planType];
  const result = await validateCoupon(code, planType, plan.amount, user.id);

  if (!result.valid) {
    const messages: Record<string, string> = {
      not_found: "ไม่พบโค้ดส่วนลดนี้",
      inactive: "โค้ดนี้ถูกปิดใช้งานแล้ว",
      expired: "โค้ดนี้หมดอายุแล้ว",
      not_started: "โค้ดนี้ยังไม่เริ่มใช้งาน",
      max_uses_reached: "โค้ดนี้ถูกใช้งานครบจำนวนแล้ว",
      plan_not_applicable: "โค้ดนี้ไม่สามารถใช้กับแพ็กเกจนี้ได้",
      already_used: "คุณเคยใช้โค้ดนี้แล้ว",
    };
    return NextResponse.json({
      valid: false,
      reason: result.reason,
      message: messages[result.reason] ?? "โค้ดไม่ถูกต้อง",
    });
  }

  return NextResponse.json({
    valid: true,
    couponId: result.couponId,
    discountType: result.discountType,
    discountValue: result.discountValue,
    discountAmount: result.discountAmount,
    finalPrice: result.finalPrice,
    description: result.description,
    originalPrice: plan.amount,
  });
}
