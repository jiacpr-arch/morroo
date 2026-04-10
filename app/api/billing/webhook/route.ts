import { NextRequest, NextResponse, after } from "next/server";
import Stripe from "stripe";
import { fulfillCheckoutSession } from "@/lib/billing/fulfill-checkout";
import { sendFulfillmentNotifications } from "@/lib/billing/send-fulfillment-notifications";

export const runtime = "nodejs";

// Lazy-initialize Stripe so module load never touches
// process.env.STRIPE_SECRET_KEY. Stripe v21 throws at construction when
// the key is missing ("Neither apiKey nor config.authenticator
// provided"), and Next.js imports every route module at build time to
// analyze it. If the build environment doesn't have the secret set
// (common when a key is rotated in Production only, or in Vercel
// Preview environments where env vars are scoped separately), an eager
// `new Stripe(...)` at the top of this file would crash the entire
// deploy before webpack even starts compiling.
let _stripeForWebhook: Stripe | null = null;
function getStripeForWebhook(): Stripe {
  if (!_stripeForWebhook) {
    _stripeForWebhook = new Stripe(process.env.STRIPE_SECRET_KEY!);
  }
  return _stripeForWebhook;
}

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  const whSecret = (process.env.STRIPE_WEBHOOK_SECRET ?? "").trim();

  let event: Stripe.Event;
  try {
    event = getStripeForWebhook().webhooks.constructEvent(body, signature, whSecret);
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
