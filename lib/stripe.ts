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
  monthly: { amount: 199, name: "MorRoo Full รายเดือน" },
  yearly: { amount: 1490, name: "MorRoo Full รายปี" },
  bundle: { amount: 99, name: "MorRoo Bundle MCQ 10 ข้อ" },
  mcq_monthly: { amount: 99, name: "MorRoo MCQ รายเดือน" },
  mcq_yearly: { amount: 990, name: "MorRoo MCQ รายปี" },
  meq_monthly: { amount: 99, name: "MorRoo MEQ รายเดือน" },
  meq_yearly: { amount: 990, name: "MorRoo MEQ รายปี" },
  longcase_monthly: { amount: 99, name: "MorRoo Long Case รายเดือน" },
  longcase_yearly: { amount: 990, name: "MorRoo Long Case รายปี" },
};
