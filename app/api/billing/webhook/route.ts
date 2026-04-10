import { NextRequest, NextResponse, after } from "next/server";
import Stripe from "stripe";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";

// Direct instance for webhook verification — avoids Proxy binding issues
const stripeForWebhook = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  const whSecret = (process.env.STRIPE_WEBHOOK_SECRET ?? "").trim();

  let event: Stripe.Event;
  try {
    event = stripeForWebhook.webhooks.constructEvent(body, signature, whSecret);
  } catch (err) {
    console.error("[webhook] sig failed:", String(err).slice(0, 100));
    return NextResponse.json({ error: "Invalid signature" }, { status: 400 });
  }

  // After the signature is valid, we always ack with 200 so Stripe stops
  // retrying. Any processing failure is logged for manual follow-up.
  try {
    if (event.type === "checkout.session.completed") {
      const session = event.data.object as Stripe.Checkout.Session;
      const result = await fulfillCheckoutSession(session);

      if (result.notify) {
        // Schedule non-critical HTTP side effects to run AFTER the 200
        // response is sent to Stripe. Slow or failing third-party APIs
        // can no longer cause Stripe to mark the delivery as failed.
        const notify = result.notify;
        after(() => sendFulfillmentNotifications(notify));
      }
    }
  } catch (err) {
    console.error("[webhook] handler error:", err);
  }

  return NextResponse.json({ received: true }, { status: 200 });
}
