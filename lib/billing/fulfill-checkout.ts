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
import { enqueueBoardGenJobs } from "@/lib/board/enqueue";
import { isPlanType, planLabel } from "@/lib/membership";
import { extendActiveProducts, grantItem, grantPlan } from "@/lib/entitlements";
import { isItemPlan } from "@/lib/items";
import { resolveItem } from "@/lib/billing/plan-resolver";
import { recordDiscountRedemption } from "@/lib/billing/coupon-checkout";
import { REFERRAL_MAX_REWARDS_PER_YEAR, REFERRAL_REWARD_DAYS } from "@/lib/referral";

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
  let expiresAt: Date;
  let label: string;

  if (isPlanType(planType)) {
    // Grant the plan's products (per-product entitlements, stacking on any
    // unexpired ones) and write the legacy profile summary.
    const granted = await grantPlan(userId, planType, {
      source: "stripe",
      reference: session.id,
    });
    if (!granted.ok) {
      console.error("[fulfill] failed to grant entitlements:", session.id);
    }
    expiresAt = granted.expiresAt;
    label = planLabel(planType);
  } else if (isItemPlan(planType)) {
    // One subject / specialty / exam / case / topic → scoped entitlement.
    // Items are not plans: the legacy profile summary is left untouched.
    const item = await resolveItem(planType);
    if (!item) {
      console.error("[fulfill] unknown item on session:", session.id, planType);
      return { alreadyProcessed: false };
    }
    const ok = await grantItem(userId, item, { source: "stripe", reference: session.id });
    if (!ok) console.error("[fulfill] failed to grant item:", session.id);
    expiresAt = new Date(now);
    if (item.days) expiresAt.setDate(expiresAt.getDate() + item.days);
    else expiresAt.setFullYear(expiresAt.getFullYear() + 99);
    label = item.label;
  } else {
    console.error("[fulfill] unknown planType on session:", session.id, planType);
    return { alreadyProcessed: false };
  }

  const totalAmount = (session.amount_total ?? 0) / 100;

  // A discount coupon priced into this session → consume one use now.
  if (metadata.couponCode) {
    await recordDiscountRedemption(metadata.couponCode, userId, session.id);
  }

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

  // Referral reward: extend referrer membership by the referral's reward_days,
  // up to REFERRAL_MAX_REWARDS_PER_YEAR rewarded friends per rolling year.
  const { data: buyer } = await supabase
    .from("profiles")
    .select("referred_by, membership_expires_at")
    .eq("id", userId)
    .maybeSingle();

  let referrerLineUserId: string | null = null;
  let referrerRewardDays = REFERRAL_REWARD_DAYS;

  if (buyer?.referred_by) {
    const { data: pendingReferral } = await supabase
      .from("referrals")
      .select("id, referrer_id, reward_days")
      .eq("referred_id", userId)
      .eq("code", buyer.referred_by)
      .eq("status", "pending")
      .maybeSingle();

    let capped = false;
    if (pendingReferral) {
      const yearAgo = new Date(Date.now() - 365 * 86400_000).toISOString();
      const { count: rewardedThisYear } = await supabase
        .from("referrals")
        .select("id", { count: "exact", head: true })
        .eq("referrer_id", pendingReferral.referrer_id)
        .eq("status", "rewarded")
        .gte("rewarded_at", yearAgo);
      capped = (rewardedThisYear ?? 0) >= REFERRAL_MAX_REWARDS_PER_YEAR;
      if (capped) {
        await supabase
          .from("referrals")
          .update({ status: "capped" })
          .eq("id", pendingReferral.id);
      }
    }

    if (pendingReferral && !capped) {
      // Extend referrer's active products (falls back to the student pack
      // when nothing is active) — also re-derives the legacy expiry.
      await extendActiveProducts(
        pendingReferral.referrer_id,
        pendingReferral.reward_days ?? REFERRAL_REWARD_DAYS,
        { source: "referral", reference: userId }
      );

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
      referrerRewardDays = pendingReferral.reward_days ?? REFERRAL_REWARD_DAYS;
    }
  }

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
      planLabel: label,
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
