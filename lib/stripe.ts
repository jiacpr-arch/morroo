import Stripe from "stripe";

let _stripe: Stripe | null = null;

export function getStripe(): Stripe {
  if (!_stripe) {
    _stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
  }
  return _stripe;
}

/** @deprecated Use getStripe() instead — kept for backward compatibility */
export const stripe = new Proxy({} as Stripe, {
  get(_target, prop) {
    return (getStripe() as unknown as Record<string | symbol, unknown>)[prop];
  },
});

export const STRIPE_PLANS: Record<string, { amount: number; name: string }> = {
  monthly: { amount: 199, name: "MorRoo รายเดือน" },
  yearly: { amount: 1490, name: "MorRoo รายปี" },
  bundle: { amount: 299, name: "MorRoo ชุดข้อสอบ 10 ข้อ" },
};
