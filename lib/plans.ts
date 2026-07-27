/**
 * Server-side plan catalog — the single source of truth for prices used by
 * payment routes. Never trust an amount sent from the client.
 *
 * Prices live in STRIPE_PLANS (lib/stripe.ts) so Stripe checkout and
 * bank-transfer slips can never drift apart.
 */

import { STRIPE_PLANS } from "@/lib/stripe";

export interface PlanInfo {
  amount: number;
  name: string;
}

export function getPlan(planType: string): PlanInfo | null {
  return STRIPE_PLANS[planType] ?? null;
}

export const PLAN_TYPES = Object.keys(STRIPE_PLANS);
