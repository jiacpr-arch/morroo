/**
 * Fulfillment for a bank-transfer (slip) payment order.
 *
 * Called from:
 * - /api/payment/submit-slip when the slip auto-verified successfully
 * - /api/admin/payments/review when an admin approves manually
 *
 * Idempotency: only a `pending` order can be fulfilled. The status flip to
 * `approved` happens first with a `.eq("status", "pending")` guard, so two
 * concurrent calls can't double-activate or double-invoice.
 *
 * Returns the same `notify` payload shape as fulfillCheckoutSession so
 * sendFulfillmentNotifications() works unchanged for both paths.
 */

import { createAdminClient } from "@/lib/supabase/admin";
import { enqueueBoardGenJobs } from "@/lib/board/enqueue";
import type { FulfillmentResult } from "./fulfill-checkout";
import {
  PLAN_LABELS_TH,
  activateMembership,
  applyReferralReward,
  calcMembershipExpiry,
  computeVat,
  nextInvoiceNumber,
} from "./fulfillment-core";

export async function fulfillSlipOrder(args: {
  orderId: string;
  /** Admin user id for manual approval; null when auto-verified. */
  reviewedBy: string | null;
}): Promise<FulfillmentResult> {
  const { orderId, reviewedBy } = args;
  const supabase = createAdminClient();

  const { data: order } = await supabase
    .from("payment_orders")
    .select("id, user_id, plan_type, amount, status")
    .eq("id", orderId)
    .maybeSingle();

  if (!order) {
    console.error("[fulfill-slip] order not found:", orderId);
    return { alreadyProcessed: false };
  }
  if (order.status !== "pending") {
    return { alreadyProcessed: true };
  }

  const now = new Date();

  // Flip to approved first, guarded on pending — this is the idempotency
  // lock. If another request already flipped it, we bail out.
  const { data: flipped, error: flipError } = await supabase
    .from("payment_orders")
    .update({
      status: "approved",
      reviewed_by: reviewedBy,
      reviewed_at: now.toISOString(),
    })
    .eq("id", orderId)
    .eq("status", "pending")
    .select("id");

  if (flipError) {
    console.error("[fulfill-slip] failed to approve order:", flipError);
    return { alreadyProcessed: false };
  }
  if (!flipped || flipped.length === 0) {
    return { alreadyProcessed: true };
  }

  const { data: buyerProfile } = await supabase
    .from("profiles")
    .select("name, email, line_user_id")
    .eq("id", order.user_id)
    .maybeSingle();

  const expiresAt = calcMembershipExpiry(order.plan_type, now);
  await activateMembership(supabase, order.user_id, order.plan_type, expiresAt);

  const totalAmount = Number(order.amount);
  const invoiceNumber = await nextInvoiceNumber(supabase, now);
  const { amountBeforeVat, vatAmount } = computeVat(totalAmount);

  const { error: invoiceError } = await supabase.from("invoices").insert({
    invoice_number: invoiceNumber,
    user_id: order.user_id,
    order_id: order.id,
    payment_method: "bank_transfer",
    stripe_session_id: null,
    plan_type: order.plan_type,
    amount: amountBeforeVat,
    vat_amount: vatAmount,
    total_amount: totalAmount,
    buyer_name: buyerProfile?.name ?? null,
    buyer_tax_id: null,
    buyer_address: null,
    buyer_email: buyerProfile?.email ?? null,
    status: "paid",
  });

  if (invoiceError) {
    console.error("[fulfill-slip] failed to create invoice:", invoiceError);
  }

  const { referrerLineUserId, referrerRewardDays } = await applyReferralReward(
    supabase,
    order.user_id
  );

  if (order.plan_type === "board_monthly" || order.plan_type === "board_yearly") {
    try {
      await enqueueBoardGenJobs({
        admin: supabase,
        userId: order.user_id,
        stripeSessionId: `slip:${order.id}`,
        targetCount: 30,
        trigger: "subscription",
      });
    } catch (err) {
      console.error("[fulfill-slip] board gen enqueue failed:", err);
    }
  }

  return {
    alreadyProcessed: false,
    notify: {
      sessionId: `slip:${order.id}`,
      userId: order.user_id,
      planType: order.plan_type,
      planLabel: PLAN_LABELS_TH[order.plan_type] ?? order.plan_type,
      totalAmount,
      amountBeforeVat,
      vatAmount,
      invoiceNumber,
      orderId: order.id,
      publishedOn: now.toISOString().slice(0, 10),
      expiresAt,
      invoiceName: buyerProfile?.name ?? "",
      invoiceTaxId: "",
      invoiceAddress: "",
      invoiceEmail: buyerProfile?.email ?? "",
      buyerLineUserId: buyerProfile?.line_user_id ?? null,
      referrerLineUserId,
      referrerRewardDays,
    },
  };
}
