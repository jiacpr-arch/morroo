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
 *
 * The mechanics (expiry math, invoice numbering, VAT, referral reward) live
 * in lib/billing/fulfillment-core.ts, shared with the bank-transfer path.
 */

import type Stripe from "stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { enqueueBoardGenJobs } from "@/lib/board/enqueue";
import {
  PLAN_LABELS_TH,
  activateMembership,
  applyReferralReward,
  calcMembershipExpiry,
  computeVat,
  nextInvoiceNumber,
} from "./fulfillment-core";

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

  const now = new Date();
  const expiresAt = calcMembershipExpiry(planType, now);

  await activateMembership(supabase, userId, planType, expiresAt);

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

  const invoiceNumber = await nextInvoiceNumber(supabase, now);
  const { amountBeforeVat, vatAmount } = computeVat(totalAmount);

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

  const { referrerLineUserId, referrerRewardDays } = await applyReferralReward(
    supabase,
    userId
  );

  // Board subscription → enqueue AI MCQ generation jobs (one row per
  // under-target specialty). Cron processes them ≤ 1 specialty/min.
  // Failure here must not block fulfillment.
  if (planType === "board_monthly" || planType === "board_yearly") {
    try {
      await enqueueBoardGenJobs({
        admin: supabase,
        userId,
        stripeSessionId: session.id,
        targetCount: 30,
        trigger: "subscription",
      });
    } catch (err) {
      console.error("[fulfill] board gen enqueue failed:", err);
    }
  }

  // Fetch buyer LINE ID for post-response notification
  const { data: buyerProfile } = await supabase
    .from("profiles")
    .select("line_user_id")
    .eq("id", userId)
    .maybeSingle();

  const publishedOn = now.toISOString().slice(0, 10);

  return {
    alreadyProcessed: false,
    notify: {
      sessionId: session.id,
      userId,
      planType,
      planLabel: PLAN_LABELS_TH[planType] ?? planType,
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
