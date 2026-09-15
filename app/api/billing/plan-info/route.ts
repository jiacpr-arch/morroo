import { NextRequest, NextResponse } from "next/server";
import { resolvePurchasable } from "@/lib/billing/plan-resolver";
import { PLAN_CATALOG, type PlanType, type Product } from "@/lib/membership";

export const runtime = "nodejs";

/**
 * GET /api/billing/plan-info?planType=<plan | item:…>
 *
 * Public, read-only description of anything purchasable, used by the
 * /payment/[plan] page for items (whose price and name come from the
 * database, not the static catalog).
 *
 *   → { name, amount, period, product, anchors: [{ planType, label, amount, period }] }
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

  if (p.kind === "plan") {
    return NextResponse.json({
      kind: "plan",
      name: p.label,
      amount: p.amount,
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
      amount: PLAN_CATALOG[plan].amount,
      period: PLAN_CATALOG[plan].duration === "year" ? "/ ปี" : "/ เดือน",
    })),
  });
}
