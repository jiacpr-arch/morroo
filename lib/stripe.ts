import Stripe from "stripe";
import { PLAN_CATALOG, PLAN_TYPES } from "@/lib/membership";

let _stripe: Stripe;

function getStripeClient(): Stripe {
  if (!_stripe) {
    _stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
  }
  return _stripe;
}

export const stripe: Stripe = new Proxy({} as Stripe, {
  get(_, prop: string | symbol) {
    return Reflect.get(getStripeClient(), prop);
  },
});

/**
 * Sellable plans for Stripe Checkout — derived from PLAN_CATALOG
 * (lib/membership.ts) so prices / names / products stay in one place.
 */
export const STRIPE_PLANS: Record<string, { amount: number; name: string }> =
  Object.fromEntries(
    PLAN_TYPES.map((plan) => [
      plan,
      { amount: PLAN_CATALOG[plan].amount, name: PLAN_CATALOG[plan].stripeName },
    ])
  );
