import { NextRequest, NextResponse } from "next/server";
import { stripe, STRIPE_PLANS } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";
import { createCashInvoice } from "@/lib/flowaccount";
import { lineNotifyNewOrder, emailReceipt } from "@/lib/notifications";
import Stripe from "stripe";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("stripe-signature");

  if (!signature) {
    return NextResponse.json({ error: "Missing stripe-signature" }, { status: 400 });
  }

  const whSecret = process.env.STRIPE_WEBHOOK_SECRET ?? "";
  console.log("[webhook] secret:", whSecret.slice(0, 25), "sig:", signature?.slice(0, 30));

  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(body, signature, whSecret);
  } catch (err) {
    console.error("[webhook] sig failed:", String(err).slice(0, 100));
    const bodyArr = Array.from(Buffer.from(body, 'utf8')).slice(0, 10);
    return NextResponse.json({
      error: "Invalid signature",
      _sec: whSecret.slice(0, 20),
      _bodyLen: body.length,
      _bodyStart: bodyArr,
      _sigStart: signature?.slice(0, 30),
    }, { status: 400 });
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

    // Referral reward: extend referrer membership by 30 days
    const { data: buyer } = await supabase
      .from("profiles")
      .select("referred_by, membership_expires_at")
      .eq("id", userId)
      .single();

    if (buyer?.referred_by) {
      const { data: pendingReferral } = await supabase
        .from("referrals")
        .select("id, referrer_id, reward_days")
        .eq("referred_id", userId)
        .eq("code", buyer.referred_by)
        .eq("status", "pending")
        .single();

      if (pendingReferral) {
        // Extend referrer's membership
        const { data: referrer } = await supabase
          .from("profiles")
          .select("membership_expires_at, membership_type")
          .eq("id", pendingReferral.referrer_id)
          .single();

        if (referrer) {
          const base =
            referrer.membership_expires_at && new Date(referrer.membership_expires_at) > new Date()
              ? new Date(referrer.membership_expires_at)
              : new Date();
          base.setDate(base.getDate() + (pendingReferral.reward_days ?? 30));

          await supabase
            .from("profiles")
            .update({ membership_expires_at: base.toISOString() })
            .eq("id", pendingReferral.referrer_id);
        }

        // Mark referral as rewarded
        await supabase
          .from("referrals")
          .update({ status: "rewarded", rewarded_at: new Date().toISOString() })
          .eq("id", pendingReferral.id);

        // Notify referrer via LINE
        const { data: referrerProfile } = await supabase
          .from("profiles")
          .select("line_user_id")
          .eq("id", pendingReferral.referrer_id)
          .single();

        if (referrerProfile?.line_user_id) {
          await sendLineMessage(referrerProfile.line_user_id, [{
            type: "text",
            text: `🎉 เพื่อนของคุณสมัครสมาชิก MorRoo แล้ว!\n\nคุณได้รับสิทธิ์ใช้งานเพิ่ม ${pendingReferral.reward_days ?? 30} วันทันที ✨`,
          }]);
        }
      }
    }

    // Notify buyer via LINE (personal account)
    const { data: buyerProfile } = await supabase
      .from("profiles")
      .select("line_user_id")
      .eq("id", userId)
      .single();

    if (buyerProfile?.line_user_id) {
      const planLabel: Record<string, string> = {
        monthly: "รายเดือน",
        yearly: "รายปี",
        bundle: "ชุดข้อสอบ",
      };
      await sendLineMessage(buyerProfile.line_user_id, [{
        type: "text",
        text: `✅ ชำระเงินสำเร็จ!\n\nแพ็กเกจ: MorRoo ${planLabel[planType] ?? planType}\nหมดอายุ: ${expiresAt.toLocaleDateString("th-TH", { year: "numeric", month: "long", day: "numeric" })}\n\nขอให้สอบผ่าน! 🏥`,
      }]);
    }

    const publishedOn = now.toISOString().slice(0, 10);
    const planName = STRIPE_PLANS[planType]?.name ?? planType;

    // แจ้ง admin group LINE + email ใบเสร็จ (non-blocking)
    Promise.all([
      lineNotifyNewOrder({ planName, totalAmount, invoiceNumber, buyerEmail: invoiceEmail }),
      emailReceipt({
        toEmail: invoiceEmail,
        planName,
        invoiceNumber,
        totalAmount,
        vatAmount,
        amountBeforeVat,
        buyerName: invoiceName || undefined,
        buyerTaxId: invoiceTaxId || undefined,
        publishedOn,
      }),
    ]).catch((err) => console.error("[Notify] error:", err));

    // สร้างใบกำกับภาษี/ใบเสร็จใน FlowAccount (non-blocking)
    createCashInvoice({
      planType,
      totalAmount,
      invoiceNumber,
      stripeSessionId: session.id,
      buyerName: invoiceName || undefined,
      buyerTaxId: invoiceTaxId || undefined,
      buyerAddress: invoiceAddress || undefined,
      buyerEmail: invoiceEmail || undefined,
      publishedOn,
    }).then((result) => {
      if (result.ok) {
        console.log(`[FlowAccount] สร้างเอกสาร ${result.documentNumber} สำเร็จ (${invoiceNumber})`);
      } else {
        console.error(`[FlowAccount] สร้างเอกสารไม่สำเร็จ (${invoiceNumber}): ${result.error}`);
      }
    }).catch((err) => {
      console.error("[FlowAccount] error:", err);
    });
  }

  return NextResponse.json({ received: true }, { status: 200 });
}
