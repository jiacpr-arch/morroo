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
  board_monthly: { amount: 499, name: "MorRoo Board รายเดือน" },
  board_yearly: { amount: 4990, name: "MorRoo Board รายปี" },
  // School (Y1–Y6) — ราคาต่ำกว่าแพ็ก นศพ. เพราะกำลังจ่ายของปี 1-3 ต่ำกว่า
  // extern/intern และแพ็ก นศพ. (monthly/yearly) รวมสิทธิ์ School อยู่แล้ว
  school_monthly: { amount: 129, name: "MorRoo School รายเดือน" },
  school_term: { amount: 349, name: "MorRoo School ราย 1 ภาคการศึกษา" },
  school_yearly: { amount: 890, name: "MorRoo School รายปี" },
};
