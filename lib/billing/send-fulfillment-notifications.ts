/**
 * Side-effect notifications fired after a checkout session has been
 * successfully fulfilled. Safe to call inside `after()` from `next/server`
 * so it runs after the HTTP response is sent to the caller.
 *
 * Each integration is wrapped in its own try/catch so a failure in one
 * (e.g. FlowAccount down) will not prevent the others from running.
 */

import { STRIPE_PLANS } from "@/lib/stripe";
import { sendLineMessage } from "@/lib/line";
import { createCashInvoice } from "@/lib/flowaccount";
import { lineNotifyNewOrder, emailReceipt, emailNotifyAdmin } from "@/lib/notifications";
import type { FulfillmentResult } from "./fulfill-checkout";

type NotifyPayload = NonNullable<FulfillmentResult["notify"]>;

export async function sendFulfillmentNotifications(data: NotifyPayload): Promise<void> {
  const planName = STRIPE_PLANS[data.planType]?.name ?? data.planType;

  // Notify referrer via LINE
  if (data.referrerLineUserId) {
    try {
      await sendLineMessage(data.referrerLineUserId, [{
        type: "text",
        text: `🎉 เพื่อนของคุณสมัครสมาชิก MorRoo แล้ว!\n\nคุณได้รับสิทธิ์ใช้งานเพิ่ม ${data.referrerRewardDays} วันทันที ✨`,
      }]);
    } catch (err) {
      console.error("[LINE referrer notify] error:", err);
    }
  }

  // Notify buyer via LINE
  if (data.buyerLineUserId) {
    const invoiceRequestUrl = `https://www.morroo.com/invoice-request/${data.orderId ?? ""}`;
    try {
      await sendLineMessage(data.buyerLineUserId, [{
        type: "text",
        text: `✅ ชำระเงินสำเร็จ!\n\nแพ็กเกจ: MorRoo ${data.planLabel}\nหมดอายุ: ${data.expiresAt.toLocaleDateString("th-TH", { year: "numeric", month: "long", day: "numeric" })}\n\n📄 ต้องการใบกำกับภาษี?\nกรอกข้อมูลได้ที่: ${invoiceRequestUrl}\n\nขอให้สอบผ่าน! 🏥`,
      }]);
    } catch (err) {
      console.error("[LINE buyer notify] error:", err);
    }
  }

  // Admin group LINE + admin email + buyer email receipt
  try {
    await Promise.all([
      lineNotifyNewOrder({
        planName,
        totalAmount: data.totalAmount,
        invoiceNumber: data.invoiceNumber,
        buyerEmail: data.invoiceEmail,
      }),
      emailNotifyAdmin({
        planName,
        totalAmount: data.totalAmount,
        invoiceNumber: data.invoiceNumber,
        buyerEmail: data.invoiceEmail,
        buyerName: data.invoiceName || undefined,
        publishedOn: data.publishedOn,
      }),
      emailReceipt({
        toEmail: data.invoiceEmail,
        planName,
        invoiceNumber: data.invoiceNumber,
        totalAmount: data.totalAmount,
        vatAmount: data.vatAmount,
        amountBeforeVat: data.amountBeforeVat,
        buyerName: data.invoiceName || undefined,
        buyerTaxId: data.invoiceTaxId || undefined,
        publishedOn: data.publishedOn,
      }),
    ]);
  } catch (err) {
    console.error("[Notify] error:", err);
  }

  // Create tax invoice/receipt in FlowAccount
  try {
    const result = await createCashInvoice({
      planType: data.planType,
      totalAmount: data.totalAmount,
      invoiceNumber: data.invoiceNumber,
      stripeSessionId: data.sessionId,
      buyerName: data.invoiceName || undefined,
      buyerTaxId: data.invoiceTaxId || undefined,
      buyerAddress: data.invoiceAddress || undefined,
      buyerEmail: data.invoiceEmail || undefined,
      publishedOn: data.publishedOn,
    });
    if (result.ok) {
      console.log(`[FlowAccount] สร้างเอกสาร ${result.documentNumber} สำเร็จ (${data.invoiceNumber})`);
    } else {
      console.error(`[FlowAccount] สร้างเอกสารไม่สำเร็จ (${data.invoiceNumber}): ${result.error}`);
    }
  } catch (err) {
    console.error("[FlowAccount] error:", err);
  }
}
