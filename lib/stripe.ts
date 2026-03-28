import Stripe from "stripe";

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export const STRIPE_PLANS: Record<string, { amount: number; name: string }> = {
  monthly: { amount: 199, name: "MorRoo รายเดือน" },
  yearly: { amount: 1490, name: "MorRoo รายปี" },
  bundle: { amount: 299, name: "MorRoo ชุดข้อสอบ 10 ข้อ" },
};
