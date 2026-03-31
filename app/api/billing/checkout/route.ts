import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
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
    const { planType, invoiceData, couponCode } = body as {
      planType: string;
      invoiceData?: { name: string; taxId: string; address: string } | null;
      couponCode?: string;
    };

    if (!planType || !STRIPE_PLANS[planType]) {
      return NextResponse.json({ error: "ประเภทแพ็กเกจไม่ถูกต้อง" }, { status: 400 });
    }

    const plan = STRIPE_PLANS[planType];
    let finalAmount = plan.amount;
    let discountLabel = "";

    // Apply coupon discount if provided
    if (couponCode) {
      const admin = createAdminClient();
      const { data: coupon } = await admin
        .from("coupon_codes")
        .select("id, coupon_type, value, is_active")
        .ilike("code", couponCode.toUpperCase().trim())
        .single();

      if (coupon && coupon.is_active) {
        // Verify user has redeemed this coupon
        const { data: hasRedeemed } = await admin
          .from("coupon_redemptions")
          .select("id")
          .eq("user_id", user.id)
          .eq("coupon_id", coupon.id)
          .single();

        if (hasRedeemed) {
          if (coupon.coupon_type === "discount_percent") {
            const discount = Math.round(finalAmount * coupon.value / 100);
            finalAmount = Math.max(0, finalAmount - discount);
            discountLabel = ` (ลด ${coupon.value}%)`;
          } else if (coupon.coupon_type === "discount_fixed") {
            finalAmount = Math.max(0, finalAmount - coupon.value);
            discountLabel = ` (ลด ${coupon.value} บาท)`;
          }
        }
      }
    }

    const siteUrl = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com").trim();

    const session = await getStripe().checkout.sessions.create({
      mode: "payment",
      customer_email: user.email,
      line_items: [
        {
          price_data: {
            currency: "thb",
            unit_amount: finalAmount * 100,
            product_data: {
              name: plan.name + discountLabel,
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
        couponCode: couponCode ?? "",
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
