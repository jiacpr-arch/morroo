import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { stripe } from "@/lib/stripe";
import { resolvePurchasable } from "@/lib/billing/plan-resolver";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
    }

    const body = await request.json();
    const { planType, invoiceData } = body as {
      planType: string;
      invoiceData?: { name: string; taxId: string; address: string } | null;
    };

    // A plan (PLAN_CATALOG) or an item — one subject / specialty / exam /
    // case / topic (lib/items.ts). Both are priced server-side; the client
    // only sends the plan string.
    const purchasable =
      typeof planType === "string" && planType.length <= 120
        ? await resolvePurchasable(planType)
        : null;
    if (!purchasable) {
      return NextResponse.json({ error: "ประเภทแพ็กเกจไม่ถูกต้อง" }, { status: 400 });
    }

    const plan =
      purchasable.kind === "plan"
        ? { amount: purchasable.amount, name: purchasable.stripeName }
        : { amount: purchasable.item.amount, name: purchasable.item.stripeName };
    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com").trim();

    // PromptPay is the dominant consumer payment rail in Thailand and settles
    // instantly (Stripe auto-verifies the QR), so it replaces the slow manual
    // bank-slip flow. Gated behind a flag so this is a no-op until PromptPay is
    // activated in the Stripe Dashboard — otherwise Stripe rejects the
    // unsupported payment_method_type and breaks checkout entirely. When the
    // flag is off we omit payment_method_types so Stripe keeps using the
    // dashboard-configured automatic methods (current behaviour).
    const paymentMethodTypes: Array<"promptpay" | "card"> | undefined =
      process.env.NEXT_PUBLIC_STRIPE_PROMPTPAY_ENABLED === "true"
        ? ["promptpay", "card"]
        : undefined;

    const session = await stripe.checkout.sessions.create({
      mode: "payment",
      ...(paymentMethodTypes
        ? { payment_method_types: paymentMethodTypes }
        : {}),
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
      cancel_url: `${siteUrl}/payment/${encodeURIComponent(planType)}`,
      metadata: {
        userId: user.id,
        planType,
        invoiceName: invoiceData?.name ?? "",
        invoiceTaxId: invoiceData?.taxId ?? "",
        invoiceAddress: invoiceData?.address ?? "",
        invoiceEmail: user.email ?? "",
        ttclid: request.cookies.get("ttclid")?.value ?? "",
        ttp: request.cookies.get("_ttp")?.value ?? "",
        // Meta click/browser IDs (set by the pixel) so the Purchase CAPI event
        // in app/api/billing/webhook can attribute the sale to the ad. The
        // webhook already reads session.metadata.fbc/fbp — it was just never
        // populated here, so purchases came through unattributed.
        fbc: request.cookies.get("_fbc")?.value ?? "",
        fbp: request.cookies.get("_fbp")?.value ?? "",
      },
    });

    return NextResponse.json({ url: session.url });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("Stripe checkout error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
