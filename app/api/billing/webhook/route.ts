import { NextRequest, NextResponse } from "next/server";
import { stripe } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendPurchaseConfirmationEmail } from "@/lib/email";
import Stripe from "stripe";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      process.env.STRIPE_WEBHOOK_SECRET!
    );
  } catch (err) {
    console.error("Webhook signature verification failed:", err);
    return NextResponse.json({ error: "Invalid signature" }, { status: 400 });
  }

  if (event.type === "checkout.session.completed") {
    const session = event.data.object as Stripe.Checkout.Session;
    const metadata = session.metadata ?? {};

    const userId = metadata.userId;
    const planType = metadata.planType;
    const invoiceName = metadata.invoiceName ?? "";
    const invoiceTaxId = metadata.invoiceTaxId ?? "";
    const invoiceAddress = metadata.invoiceAddress ?? "";
    const invoiceEmail = metadata.invoiceEmail ?? "";

    if (!userId || !planType) {
      console.error("Missing metadata in checkout session:", session.id);
      return NextResponse.json({ error: "Missing metadata" }, { status: 400 });
    }

    const supabase = createAdminClient();

    // Calculate membership expiry
    const now = new Date();
    let expiresAt: Date;
    if (planType === "monthly") {
      expiresAt = new Date(now);
      expiresAt.setMonth(expiresAt.getMonth() + 1);
    } else if (planType === "yearly") {
      expiresAt = new Date(now);
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);
    } else {
      // bundle: 99 years
      expiresAt = new Date(now);
      expiresAt.setFullYear(expiresAt.getFullYear() + 99);
    }

    // Update profile membership
    const { error: profileError } = await supabase
      .from("profiles")
      .update({
        membership_type: planType,
        membership_expires_at: expiresAt.toISOString(),
      })
      .eq("id", userId);

    if (profileError) {
      console.error("Failed to update profile:", profileError);
    }

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
      console.error("Failed to create payment order:", orderError);
    }

    // Generate invoice number: INV-YYYY-NNNN
    const year = now.getFullYear();
    const { count: invoiceCount } = await supabase
      .from("invoices")
      .select("id", { count: "exact", head: true });

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
      console.error("Failed to create invoice:", invoiceError);
    }

    // Send purchase confirmation email
    const { data: buyerProfile } = await supabase
      .from("profiles")
      .select("email, name")
      .eq("id", userId)
      .single();

    if (buyerProfile?.email) {
      const planLabels: Record<string, string> = {
        monthly: "รายเดือน (1 เดือน)",
        yearly: "รายปี (1 ปี)",
        bundle: "ตลอดชีพ",
      };
      const planLabel = planLabels[planType] ?? planType;
      await sendPurchaseConfirmationEmail(
        buyerProfile.email,
        buyerProfile.name ?? "",
        planLabel,
        expiresAt,
        invoiceNumber,
        totalAmount
      );
    }
  }

  return NextResponse.json({ received: true }, { status: 200 });
}
