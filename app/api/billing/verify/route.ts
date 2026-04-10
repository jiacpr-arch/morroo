/**
 * Self-healing fallback for Stripe checkout fulfillment.
 *
 * The success page (`/payment/success?session_id=...`) calls this endpoint
 * on mount. We fetch the session from Stripe directly, verify it actually
 * belongs to the logged-in user and has been paid, then run the SAME
 * idempotent fulfillment helper the webhook uses.
 *
 * This guarantees that even if the Stripe webhook never arrives (network
 * issue, deploy blip, signature mismatch, etc.), the user will still get
 * their membership as long as they land on the success page.
 *
 * Because the helper is keyed on `payment_orders.stripe_session_id`, this
 * is a no-op if the webhook already processed the session — no duplicate
 * invoices, no duplicate notifications.
 */

import { NextRequest, NextResponse, after } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { stripe } from "@/lib/stripe";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "unauthenticated" }, { status: 401 });
    }

    const { sessionId } = (await request.json()) as { sessionId?: string };
    if (!sessionId || typeof sessionId !== "string") {
      return NextResponse.json({ error: "missing sessionId" }, { status: 400 });
    }

    // Fetch the session from Stripe. This is the source of truth — we
    // never trust the client for payment state.
    const session = await stripe.checkout.sessions.retrieve(sessionId);

    // Only the user who owns this session may reconcile it.
    if (session.metadata?.userId !== user.id) {
      return NextResponse.json({ error: "forbidden" }, { status: 403 });
    }

    // Only fulfill paid sessions.
    if (session.payment_status !== "paid") {
      return NextResponse.json({
        status: "pending",
        paymentStatus: session.payment_status,
      });
    }

    const result = await fulfillCheckoutSession(session);

    if (result.notify) {
      // Run side effects after the response (same pattern as the webhook)
      const notify = result.notify;
      after(() => sendFulfillmentNotifications(notify));
    }

    return NextResponse.json({
      status: "ok",
      alreadyProcessed: result.alreadyProcessed,
    });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[verify] error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
