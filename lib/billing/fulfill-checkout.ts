/**
 * Shared, idempotent fulfillment logic for a paid Stripe Checkout Session.
 *
 * Used by BOTH:
 * - The Stripe webhook (primary path — fires when Stripe delivers
 *   `checkout.session.completed`)
 * - The `/api/billing/verify` endpoint (fallback — fires when the user lands
 *   on the success page, in case the webhook never arrived or failed)
 *
 * Idempotency is keyed on `payment_orders.stripe_session_id`: if a row
 * already exists for the given session, this function is a no-op and
 * returns `alreadyProcessed: true`.
 */

import type Stripe from "stripe";
import { createAdminClient } from "@/lib/supabase/admin";

export interface FulfillmentResult {
  alreadyProcessed: boolean;
  notify?: {
    // Fields the caller can use inside `after()` to run non-critical
    // side effects (LINE messages, email receipt, FlowAccount invoice).
    sessionId: string;
    userId: string;
    planType: string;
    planLabel: string;
    totalAmount: number;
    amountBeforeVat: number;
    vatAmount: number;
    invoiceNumber: string;
    orderId: string | null;
    publishedOn: string;
    expiresAt: Date;
    invoiceName: string;
    invoiceTaxId: string;
    invoiceAddress: string;
    invoiceEmail: string;
    buyerLineUserId: string | null;
    referrerLineUserId: string | null;
    referrerRewardDays: number;
  };
}

export async function fulfillCheckoutSession(
  session: Stripe.Checkout.Session
): Promise<FulfillmentResult> {
  const metadata = session.metadata ?? {};

  const userId = metadata.userId;
  const planType = metadata.planType;
  const invoiceName = metadata.invoiceName ?? "";
  const invoiceTaxId = metadata.invoiceTaxId ?? "";
  const invoiceAddress = metadata.invoiceAddress ?? "";
  const invoiceEmail = metadata.invoiceEmail ?? "";

  if (!userId || !planType) {
    console.error("[fulfill] missing metadata on session:", session.id);
    return { alreadyProcessed: false };
  }

  const supabase = createAdminClient();

  // Idempotency guard — if a payment_order already exists for this session,
  // we've already processed this checkout. Skip everything.
  const { data: existingOrder } = await supabase
    .from("payment_orders")
    .select("id")
    .eq("stripe_session_id", session.id)
    .maybeSingle();

  if (existingOrder) {
    return { alreadyProcessed: true };
  }

  // Calculate membership expiry
  const now = new Date();
  let expiresAt: Date;
  if (planType === "monthly") {
    expiresAt = new Date(now);
    expiresAt.setMonth(expiresAt.getMonth() + 1);
  } else if (planType === "yearly") {
    expiresAt = new Date(now);
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);
  } else {
    // bundle: 99 years
    expiresAt = new Date(now);
    expiresAt.setFullYear(expiresAt.getFullYear() + 99);
  }

  // Update profile membership
  const { error: profileError } = await supabase
    .from("profiles")
    .update({
      membership_type: planType,
      membership_expires_at: expiresAt.toISOString(),
    })
    .eq("id", userId);

  if (profileError) {
    console.error("[fulfill] failed to update profile:", profileError);
  }

  const totalAmount = (session.amount_total ?? 0) / 100;

  // Create payment order
  const { data: orderData, error: orderError } = await supabase
    .from("payment_orders")
    .insert({
      user_id: userId,
      plan_type: planType,
      amount: totalAmount,
      status: "approved",
      payment_method: "stripe",
      stripe_session_id: session.id,
    })
    .select("id")
    .single();

  if (orderError) {
    console.error("[fulfill] failed to create payment order:", orderError);
  }

  // Generate invoice number: INV-YYYY-NNNN, scoped to the current year
  const year = now.getFullYear();
  const yearStart = `${year}-01-01T00:00:00Z`;
  const yearEnd = `${year + 1}-01-01T00:00:00Z`;
  const { count: invoiceCount } = await supabase
    .from("invoices")
    .select("id", { count: "exact", head: true })
    .gte("issued_at", yearStart)
    .lt("issued_at", yearEnd);

  const sequence = ((invoiceCount ?? 0) + 1).toString().padStart(4, "0");
  const invoiceNumber = `INV-${year}-${sequence}`;

  // Calculate VAT (7%)
  const amountBeforeVat = Math.round((totalAmount / 1.07) * 100) / 100;
  const vatAmount = Math.round((totalAmount - amountBeforeVat) * 100) / 100;

  // Create invoice
  const { error: invoiceError } = await supabase.from("invoices").insert({
    invoice_number: invoiceNumber,
    user_id: userId,
    order_id: orderData?.id ?? null,
    payment_method: "stripe",
    stripe_session_id: session.id,
    plan_type: planType,
    amount: amountBeforeVat,
    vat_amount: vatAmount,
    total_amount: totalAmount,
    buyer_name: invoiceName || null,
    buyer_tax_id: invoiceTaxId || null,
    buyer_address: invoiceAddress || null,
    buyer_email: invoiceEmail || null,
    status: "paid",
  });

  if (invoiceError) {
    console.error("[fulfill] failed to create invoice:", invoiceError);
  }

  // Referral reward: extend referrer membership by 30 days
  const { data: buyer } = await supabase
    .from("profiles")
    .select("referred_by, membership_expires_at")
    .eq("id", userId)
    .maybeSingle();

  let referrerLineUserId: string | null = null;
  let referrerRewardDays = 30;

  if (buyer?.referred_by) {
    const { data: pendingReferral } = await supabase
      .from("referrals")
      .select("id, referrer_id, reward_days")
      .eq("referred_id", userId)
      .eq("code", buyer.referred_by)
      .eq("status", "pending")
      .maybeSingle();

    if (pendingReferral) {
      // Extend referrer's membership
      const { data: referrer } = await supabase
        .from("profiles")
        .select("membership_expires_at, membership_type")
        .eq("id", pendingReferral.referrer_id)
        .maybeSingle();

      if (referrer) {
        const base =
          referrer.membership_expires_at && new Date(referrer.membership_expires_at) > new Date()
            ? new Date(referrer.membership_expires_at)
            : new Date();
        base.setDate(base.getDate() + (pendingReferral.reward_days ?? 30));

        await supabase
          .from("profiles")
          .update({ membership_expires_at: base.toISOString() })
          .eq("id", pendingReferral.referrer_id);
      }

      // Mark referral as rewarded
      await supabase
        .from("referrals")
        .update({ status: "rewarded", rewarded_at: new Date().toISOString() })
        .eq("id", pendingReferral.id);

      const { data: referrerProfile } = await supabase
        .from("profiles")
        .select("line_user_id")
        .eq("id", pendingReferral.referrer_id)
        .maybeSingle();

      referrerLineUserId = referrerProfile?.line_user_id ?? null;
      referrerRewardDays = pendingReferral.reward_days ?? 30;
    }
  }

  // Fetch buyer LINE ID for post-response notification
  const { data: buyerProfile } = await supabase
    .from("profiles")
    .select("line_user_id")
    .eq("id", userId)
    .maybeSingle();

  const publishedOn = now.toISOString().slice(0, 10);
  const planLabels: Record<string, string> = {
    monthly: "รายเดือน",
    yearly: "รายปี",
    bundle: "ชุดข้อสอบ",
  };

  return {
    alreadyProcessed: false,
    notify: {
      sessionId: session.id,
      userId,
      planType,
      planLabel: planLabels[planType] ?? planType,
      totalAmount,
      amountBeforeVat,
      vatAmount,
      invoiceNumber,
      orderId: orderData?.id ?? null,
      publishedOn,
      expiresAt,
      invoiceName,
      invoiceTaxId,
      invoiceAddress,
      invoiceEmail,
      buyerLineUserId: buyerProfile?.line_user_id ?? null,
      referrerLineUserId,
      referrerRewardDays,
    },
  };
}
