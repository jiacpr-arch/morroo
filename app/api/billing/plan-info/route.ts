import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { resolvePurchasable } from "@/lib/billing/plan-resolver";
import { isFirstPurchase, priceFor } from "@/lib/billing/intro-price";
import { PLAN_CATALOG, planIntroAmount, type PlanType, type Product } from "@/lib/membership";

export const runtime = "nodejs";

/**
 * GET /api/billing/plan-info?planType=<plan | item:…>
 *
 * Public, read-only description of anything purchasable, used by the
 * /payment/[plan] page for items (whose price and name come from the
 * database, not the static catalog).
 *
 *   → { name, amount, regularAmount, intro, period, product,
 *       anchors: [{ planType, label, amount, period }] }
 *
 * `amount` is what the signed-in caller would pay before coupons: the
 * first-purchase price when they qualify (anonymous callers count as
 * first-time — checkout re-checks). `regularAmount` is the struck-through
 * regular price when `intro` is true.
 *
 * `anchors` are the bigger plans to show next to a small item (product
 * monthly, then the student pack) so the item reads as the entry point.
 */

const PRODUCT_MONTHLY: Record<Product, PlanType> = {
  mcq: "mcq_monthly",
  meq: "meq_monthly",
  longcase: "longcase_monthly",
  school: "school_monthly",
  board: "board_monthly",
};

export async function GET(request: NextRequest) {
  const planType = request.nextUrl.searchParams.get("planType") ?? "";
  if (!planType || planType.length > 120) {
    return NextResponse.json({ error: "missing_plan" }, { status: 400 });
  }
  const p = await resolvePurchasable(planType);
  if (!p) return NextResponse.json({ error: "not_found" }, { status: 404 });

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  const firstPurchase = user ? await isFirstPurchase(user.id) : true;

  if (p.kind === "plan") {
    const price = priceFor(p, firstPurchase);
    return NextResponse.json({
      kind: "plan",
      name: p.label,
      amount: price.amount,
      regularAmount: price.regularAmount,
      intro: price.intro,
      period: p.period,
      product: p.product,
      anchors: [],
    });
  }

  const item = p.item;
  const anchors: PlanType[] = [PRODUCT_MONTHLY[item.product]];
  if (item.product !== "board") anchors.push("monthly");
  return NextResponse.json({
    kind: "item",
    name: item.label,
    amount: item.amount,
    period: item.period,
    product: item.product,
    anchors: anchors.map((plan) => ({
      planType: plan,
      label: PLAN_CATALOG[plan].label,
      amount: firstPurchase ? planIntroAmount(plan) : PLAN_CATALOG[plan].amount,
      period: PLAN_CATALOG[plan].duration === "year" ? "/ ปี" : "/ เดือน",
    })),
  });
}
