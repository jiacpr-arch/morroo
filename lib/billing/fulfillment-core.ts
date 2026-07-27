/**
 * Shared fulfillment building blocks used by BOTH payment paths:
 * - Stripe checkout (lib/billing/fulfill-checkout.ts)
 * - Bank-transfer slips (lib/billing/fulfill-slip-order.ts)
 *
 * Extracted verbatim from fulfill-checkout.ts so expiry math, invoice
 * numbering, VAT, and referral rewards can never drift between the two.
 */

import type { SupabaseClient } from "@supabase/supabase-js";

export const PLAN_LABELS_TH: Record<string, string> = {
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
  board_monthly: "Board รายเดือน",
  board_yearly: "Board รายปี",
};

export function calcMembershipExpiry(planType: string, now: Date = new Date()): Date {
  const expiresAt = new Date(now);
  if (planType === "monthly" || planType === "board_monthly") {
    expiresAt.setMonth(expiresAt.getMonth() + 1);
  } else if (planType === "yearly" || planType === "board_yearly") {
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);
  } else {
    // bundle: 99 years
    expiresAt.setFullYear(expiresAt.getFullYear() + 99);
  }
  return expiresAt;
}

export async function activateMembership(
  admin: SupabaseClient,
  userId: string,
  planType: string,
  expiresAt: Date
): Promise<void> {
  const { error } = await admin
    .from("profiles")
    .update({
      membership_type: planType,
      membership_expires_at: expiresAt.toISOString(),
    })
    .eq("id", userId);

  if (error) {
    console.error("[fulfill] failed to update profile:", error);
  }
}

/** Generate invoice number: INV-YYYY-NNNN, scoped to the current year. */
export async function nextInvoiceNumber(
  admin: SupabaseClient,
  now: Date = new Date()
): Promise<string> {
  const year = now.getFullYear();
  const yearStart = `${year}-01-01T00:00:00Z`;
  const yearEnd = `${year + 1}-01-01T00:00:00Z`;
  const { count: invoiceCount } = await admin
    .from("invoices")
    .select("id", { count: "exact", head: true })
    .gte("issued_at", yearStart)
    .lt("issued_at", yearEnd);

  const sequence = ((invoiceCount ?? 0) + 1).toString().padStart(4, "0");
  return `INV-${year}-${sequence}`;
}

/** VAT 7%, included in the total. */
export function computeVat(totalAmount: number): {
  amountBeforeVat: number;
  vatAmount: number;
} {
  const amountBeforeVat = Math.round((totalAmount / 1.07) * 100) / 100;
  const vatAmount = Math.round((totalAmount - amountBeforeVat) * 100) / 100;
  return { amountBeforeVat, vatAmount };
}

export interface ReferralRewardResult {
  referrerLineUserId: string | null;
  referrerRewardDays: number;
}

/**
 * Referral reward: extend the referrer's membership when the referred buyer
 * makes their first purchase. No-op when the buyer wasn't referred or the
 * referral was already rewarded.
 */
export async function applyReferralReward(
  admin: SupabaseClient,
  userId: string
): Promise<ReferralRewardResult> {
  const { data: buyer } = await admin
    .from("profiles")
    .select("referred_by, membership_expires_at")
    .eq("id", userId)
    .maybeSingle();

  let referrerLineUserId: string | null = null;
  let referrerRewardDays = 30;

  if (buyer?.referred_by) {
    const { data: pendingReferral } = await admin
      .from("referrals")
      .select("id, referrer_id, reward_days")
      .eq("referred_id", userId)
      .eq("code", buyer.referred_by)
      .eq("status", "pending")
      .maybeSingle();

    if (pendingReferral) {
      // Extend referrer's membership
      const { data: referrer } = await admin
        .from("profiles")
        .select("membership_expires_at, membership_type")
        .eq("id", pendingReferral.referrer_id)
        .maybeSingle();

      if (referrer) {
        const base =
          referrer.membership_expires_at &&
          new Date(referrer.membership_expires_at) > new Date()
            ? new Date(referrer.membership_expires_at)
            : new Date();
        base.setDate(base.getDate() + (pendingReferral.reward_days ?? 30));

        await admin
          .from("profiles")
          .update({ membership_expires_at: base.toISOString() })
          .eq("id", pendingReferral.referrer_id);
      }

      // Mark referral as rewarded
      await admin
        .from("referrals")
        .update({ status: "rewarded", rewarded_at: new Date().toISOString() })
        .eq("id", pendingReferral.id);

      const { data: referrerProfile } = await admin
        .from("profiles")
        .select("line_user_id")
        .eq("id", pendingReferral.referrer_id)
        .maybeSingle();

      referrerLineUserId = referrerProfile?.line_user_id ?? null;
      referrerRewardDays = pendingReferral.reward_days ?? 30;
    }
  }

  return { referrerLineUserId, referrerRewardDays };
}
