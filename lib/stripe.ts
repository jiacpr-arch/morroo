import Stripe from "stripe";

let _stripe: Stripe | null = null;

export function getStripe(): Stripe {
  if (!_stripe) {
    const key = process.env.STRIPE_SECRET_KEY;
    if (!key) throw new Error("STRIPE_SECRET_KEY is not set");
    _stripe = new Stripe(key);
  }
  return _stripe;
}

export const STRIPE_PLANS: Record<string, { amount: number; name: string }> = {
  monthly: { amount: 199, name: "MorRoo รายเดือน" },
  yearly: { amount: 1490, name: "MorRoo รายปี" },
  bundle: { amount: 299, name: "MorRoo ชุดข้อสอบ 10 ข้อ" },
};
