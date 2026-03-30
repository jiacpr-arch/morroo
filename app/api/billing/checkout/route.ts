import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getStripe, STRIPE_PLANS } from "@/lib/stripe";

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

    if (!planType || !STRIPE_PLANS[planType]) {
      return NextResponse.json({ error: "ประเภทแพ็กเกจไม่ถูกต้อง" }, { status: 400 });
    }

    const plan = STRIPE_PLANS[planType];
    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com").trim();

    const session = await getStripe().checkout.sessions.create({
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
      },
    });

    return NextResponse.json({ url: session.url });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("Stripe checkout error:", msg);
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
