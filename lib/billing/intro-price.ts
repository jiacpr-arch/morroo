/**
 * First-purchase ("intro") pricing. Plans in PLAN_CATALOG with an
 * `introAmount` sell at that price to a customer who has never paid for
 * anything, and at the regular `amount` afterwards. Items never get an
 * intro price. Checkout re-checks this server-side; the payment page only
 * displays it.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import { PLAN_CATALOG } from "@/lib/membership";
import type { Purchasable } from "@/lib/billing/plan-resolver";

/** True when the user has no approved order through any payment channel. */
export async function isFirstPurchase(userId: string): Promise<boolean> {
  const admin = createAdminClient();
  const { count, error } = await admin
    .from("payment_orders")
    .select("id", { count: "exact", head: true })
    .eq("user_id", userId)
    .eq("status", "approved");
  // Fail closed: on a lookup error charge the regular price.
  if (error) return false;
  return (count ?? 0) === 0;
}

export interface CheckoutAmount {
  /** What this buyer pays before any coupon. */
  amount: number;
  /** The regular price (struck through when `intro`). */
  regularAmount: number;
  intro: boolean;
}

/** Price `p` given whether the buyer qualifies for first-purchase pricing. */
export function priceFor(p: Purchasable, firstPurchase: boolean): CheckoutAmount {
  if (p.kind === "item") {
    return { amount: p.item.amount, regularAmount: p.item.amount, intro: false };
  }
  const introAmount = PLAN_CATALOG[p.planType].introAmount;
  if (firstPurchase && introAmount !== undefined && introAmount < p.amount) {
    return { amount: introAmount, regularAmount: p.amount, intro: true };
  }
  return { amount: p.amount, regularAmount: p.amount, intro: false };
}

/** Price `p` for a signed-in user (anonymous visitors count as first-time). */
export async function resolveCheckoutAmount(
  p: Purchasable,
  userId: string | null
): Promise<CheckoutAmount> {
  if (p.kind === "item") return priceFor(p, false);
  return priceFor(p, userId ? await isFirstPurchase(userId) : true);
}
