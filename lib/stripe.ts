import Stripe from "stripe";

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

export const STRIPE_PLANS: Record<string, { amount: number; name: string }> = {
  monthly: { amount: 199, name: "MorRoo รายเดือน" },
  yearly: { amount: 1490, name: "MorRoo รายปี" },
  bundle: { amount: 299, name: "MorRoo ชุดข้อสอบ 10 ข้อ" },
};
