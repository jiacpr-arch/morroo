import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { resolvePurchasable } from "@/lib/billing/plan-resolver";
import { DISCOUNT_ERROR_TH, validateDiscountCoupon } from "@/lib/billing/coupon-checkout";
import { COUPON_CODE_RE } from "@/lib/coupons";
import { resolveCheckoutAmount } from "@/lib/billing/intro-price";

export const runtime = "nodejs";

/**
 * POST /api/billing/coupon-check  { code, planType }
 *
 * Live preview for the payment page: is this discount code usable by the
 * signed-in user on this plan, and what does the price become? Nothing is
 * consumed here — /api/billing/checkout re-validates and fulfillment
 * records the use.
 *
 *   → { ok: true, code, originalAmount, finalAmount, discount }
 *   → { ok: false, error: <Thai message> }  (400)
 */
export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ ok: false, error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });

  let body: { code?: unknown; planType?: unknown };
  try {
    body = (await request.json()) as { code?: unknown; planType?: unknown };
  } catch {
    return NextResponse.json({ ok: false, error: "invalid_body" }, { status: 400 });
  }
  const code = typeof body.code === "string" ? body.code.trim().toUpperCase() : "";
  const planType = typeof body.planType === "string" ? body.planType : "";
  if (!COUPON_CODE_RE.test(code) || !planType || planType.length > 120) {
    return NextResponse.json({ ok: false, error: DISCOUNT_ERROR_TH.not_found }, { status: 400 });
  }

  const purchasable = await resolvePurchasable(planType);
  if (!purchasable) {
    return NextResponse.json({ ok: false, error: "ไม่พบแพ็กเกจนี้" }, { status: 400 });
  }
  // Same base as checkout: the first-purchase price when the user qualifies.
  const { amount } = await resolveCheckoutAmount(purchasable, user.id);

  const d = await validateDiscountCoupon(code, user.id, planType, amount);
  if (!d.ok) {
    return NextResponse.json({ ok: false, error: DISCOUNT_ERROR_TH[d.error] }, { status: 400 });
  }
  return NextResponse.json({
    ok: true,
    code: d.code,
    originalAmount: d.originalAmount,
    finalAmount: d.finalAmount,
    discount: d.discount,
  });
}
