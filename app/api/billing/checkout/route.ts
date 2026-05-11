import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { stripe, STRIPE_PLANS } from "@/lib/stripe";
import { sendCapiEvent, getClientIp, getClientUserAgent } from "@/lib/facebook-capi";
import { sha256Norm, newEventId } from "@/lib/facebook-pixel";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
    }

    const body = await request.json();
    const { planType, invoiceData, attribution, fb_event_id_ic } = body as {
      planType: string;
      invoiceData?: { name: string; taxId: string; address: string } | null;
      attribution?: Record<string, string> | null;
      fb_event_id_ic?: string;
    };

    // Stripe metadata: 50 keys / 500 chars per value. Per-key layout (vs.
    // a single packed JSON blob) keeps backward-compat with sessions
    // created before this deploy. ~14 attribution keys + ~5 invoice keys
    // is well under the cap.
    const ATTRIBUTION_KEYS = [
      "gclid",
      "gbraid",
      "wbraid",
      "fbclid",
      "fbc",
      "fbp",
      "utm_source",
      "utm_medium",
      "utm_campaign",
    ] as const;
    const adsMeta: Record<string, string> = {};
    if (attribution && typeof attribution === "object") {
      for (const k of ATTRIBUTION_KEYS) {
        const v = attribution[k];
        if (typeof v === "string" && v.length > 0 && v.length < 480) {
          adsMeta[k] = v;
        }
      }
    }

    if (!planType || !STRIPE_PLANS[planType]) {
      return NextResponse.json({ error: "ประเภทแพ็กเกจไม่ถูกต้อง" }, { status: 400 });
    }

    const plan = STRIPE_PLANS[planType];
    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com").trim();

    // Pre-mint the Purchase event_id here so both the webhook-driven and
    // /verify-driven fulfillment paths use the same id (they read it from
    // session.metadata) — the success page client also reads it from the
    // /verify response so its Pixel fire dedups against the CAPI fire.
    const fbEventIdPurchase = newEventId();

    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      customer_email: user.email,
      line_items: [
        {
          price_data: {
            currency: "thb",
            unit_amount: plan.amount * 100,
            product_data: {
              name: plan.name,
            },
          },
          quantity: 1,
        },
      ],
      success_url: `${siteUrl}/payment/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${siteUrl}/payment/${planType}`,
      metadata: {
        userId: user.id,
        planType,
        invoiceName: invoiceData?.name ?? "",
        invoiceTaxId: invoiceData?.taxId ?? "",
        invoiceAddress: invoiceData?.address ?? "",
        invoiceEmail: user.email ?? "",
        fb_event_id_purchase: fbEventIdPurchase,
        ...adsMeta,
      },
    });

    // Fire-and-forget Meta CAPI InitiateCheckout. The browser-side Pixel
    // fire from `/payment/[plan]/page.tsx` uses the same fb_event_id_ic
    // for dedup.
    if (fb_event_id_ic) {
      const fbAttr = attribution && typeof attribution === "object" ? attribution : {};
      sendCapiEvent({
        eventName: "InitiateCheckout",
        eventId: fb_event_id_ic,
        actionSource: "website",
        eventSourceUrl: `${siteUrl}/payment/${planType}`,
        userData: {
          em: user.email ? sha256Norm(user.email) : undefined,
          fbc: fbAttr.fbc,
          fbp: fbAttr.fbp,
          client_ip_address: getClientIp(request.headers),
          client_user_agent: getClientUserAgent(request.headers),
          external_id: user.id,
        },
        customData: {
          value: plan.amount,
          currency: "THB",
          content_ids: [planType],
          content_name: plan.name,
        },
      }).catch((e) =>
        console.error("[checkout] CAPI InitiateCheckout failed:", e)
      );
    }

    return NextResponse.json({ url: session.url });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("Stripe checkout error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
