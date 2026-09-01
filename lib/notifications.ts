/**
 * Notification service สำหรับ morroo.com
 * - LINE: แจ้ง admin group เมื่อมีออเดอร์ใหม่
 * - Email: ส่งใบเสร็จให้ลูกค้าอัตโนมัติ
 * - Email: แจ้ง admin เมื่อมีออเดอร์ใหม่ (backup ของ LINE)
 */

import { Resend } from "resend";

const LINE_TOKEN  = process.env.LINE_CHANNEL_TOKEN ?? "";
const LINE_TARGET = process.env.LINE_TARGET_ID     ?? "";
const RESEND_KEY  = process.env.RESEND_API_KEY     ?? "";
const FROM_EMAIL  = process.env.MAIL_FROM          ?? "noreply@morroo.com";
const ADMIN_EMAIL = process.env.ADMIN_EMAIL        ?? "";

// ─── LINE ────────────────────────────────────────────────────────────────────

export async function lineNotifyNewOrder(params: {
  planName: string;
  totalAmount: number;
  invoiceNumber: string;
  buyerEmail: string;
}): Promise<void> {
  if (!LINE_TOKEN || !LINE_TARGET) return;

  const text = [
    "🛒 ออเดอร์ใหม่ — MorRoo",
    `📦 ${params.planName}`,
    `💰 ${params.totalAmount.toLocaleString("th-TH")} บาท`,
    `📧 ${params.buyerEmail}`,
    `🧾 ${params.invoiceNumber}`,
  ].join("\n");

  try {
    await fetch("https://api.line.me/v2/bot/message/push", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${LINE_TOKEN}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ to: LINE_TARGET, messages: [{ type: "text", text }] }),
    });
  } catch (err) {
    console.error("[LINE] notify error:", err);
  }
}

// ─── Email Admin ─────────────────────────────────────────────────────────────

export async function emailNotifyAdmin(params: {
  planName: string;
  totalAmount: number;
  invoiceNumber: string;
  buyerEmail: string;
  buyerName?: string;
  publishedOn: string;
}): Promise<void> {
  if (!RESEND_KEY || !ADMIN_EMAIL) return;

  const resend = new Resend(RESEND_KEY);
  const fmt = (n: number) => n.toLocaleString("th-TH", { minimumFractionDigits: 2 });

  try {
    await resend.emails.send({
      from: `MorRoo <${FROM_EMAIL}>`,
      to: ADMIN_EMAIL.split(",").map((e) => e.trim()),
      subject: `🛒 ออเดอร์ใหม่ — ${params.planName} ฿${fmt(params.totalAmount)}`,
      html: `<!DOCTYPE html>
<html lang="th">
<head><meta charset="utf-8"></head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr><td align="center" style="padding:32px 16px;">
      <table width="480" cellpadding="0" cellspacing="0" style="background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.1);">
        <tr><td style="background:#0ea5e9;padding:20px 24px;">
          <p style="margin:0;font-size:18px;font-weight:700;color:#fff;">🛒 ออเดอร์ใหม่ — MorRoo</p>
        </td></tr>
        <tr><td style="padding:24px;">
          <table width="100%" cellpadding="0" cellspacing="0" style="font-size:14px;color:#374151;">
            <tr><td style="padding:6px 0;color:#6b7280;">แพ็กเกจ</td><td style="padding:6px 0;font-weight:600;">${params.planName}</td></tr>
            <tr><td style="padding:6px 0;color:#6b7280;">จำนวนเงิน</td><td style="padding:6px 0;font-weight:600;">฿${fmt(params.totalAmount)}</td></tr>
            <tr><td style="padding:6px 0;color:#6b7280;">เลขที่ใบเสร็จ</td><td style="padding:6px 0;">${params.invoiceNumber}</td></tr>
            <tr><td style="padding:6px 0;color:#6b7280;">อีเมลลูกค้า</td><td style="padding:6px 0;">${params.buyerEmail}</td></tr>
            ${params.buyerName ? `<tr><td style="padding:6px 0;color:#6b7280;">ชื่อลูกค้า</td><td style="padding:6px 0;">${params.buyerName}</td></tr>` : ""}
            <tr><td style="padding:6px 0;color:#6b7280;">วันที่</td><td style="padding:6px 0;">${params.publishedOn}</td></tr>
          </table>
          <p style="margin:20px 0 0;font-size:12px;color:#9ca3af;">
            <a href="https://dashboard.stripe.com" style="color:#0ea5e9;">Stripe Dashboard</a> ·
            <a href="https://www.morroo.com/admin/users" style="color:#0ea5e9;">Admin Users</a>
          </p>
        </td></tr>
      </table>
    </td></tr>
  </table>
</body>
</html>`,
    });
  } catch (err) {
    console.error("[Email Admin] send error:", err);
  }
}

// ─── Email Receipt ──────────────────────────────────────────────────────────

function receiptHtml(params: {
  planName: string;
  invoiceNumber: string;
  totalAmount: number;
  vatAmount: number;
  amountBeforeVat: number;
  buyerName?: string;
  buyerTaxId?: string;
  publishedOn: string;
}): string {
  const fmt = (n: number) => n.toLocaleString("th-TH", { minimumFractionDigits: 2 });

  return `<!DOCTYPE html>
<html lang="th">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ใบเสร็จรับเงิน ${params.invoiceNumber}</title>
</head>
<body style="margin:0;padding:0;background:#f4f4f4;font-family:sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0">
    <tr><td align="center" style="padding:32px 16px;">
      <table width="560" cellpadding="0" cellspacing="0" style="background:#fff;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.1);">

        <!-- Header -->
        <tr><td style="background:#0ea5e9;padding:28px 32px;">
          <p style="margin:0;font-size:22px;font-weight:700;color:#fff;">MorRoo</p>
          <p style="margin:4px 0 0;font-size:13px;color:#e0f2fe;">ใบเสร็จรับเงิน / Receipt</p>
        </td></tr>

        <!-- Body -->
        <tr><td style="padding:28px 32px;">
          <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
              <td style="font-size:13px;color:#6b7280;">เลขที่ใบเสร็จ</td>
              <td align="right" style="font-size:13px;font-weight:600;color:#111;">${params.invoiceNumber}</td>
            </tr>
            <tr><td colspan="2" style="padding:6px 0;"></td></tr>
            <tr>
              <td style="font-size:13px;color:#6b7280;">วันที่</td>
              <td align="right" style="font-size:13px;color:#111;">${params.publishedOn}</td>
            </tr>
            ${params.buyerName ? `
            <tr><td colspan="2" style="padding:6px 0;"></td></tr>
            <tr>
              <td style="font-size:13px;color:#6b7280;">ชื่อผู้ซื้อ</td>
              <td align="right" style="font-size:13px;color:#111;">${params.buyerName}</td>
            </tr>` : ""}
            ${params.buyerTaxId ? `
            <tr>
              <td style="font-size:13px;color:#6b7280;">เลขประจำตัวผู้เสียภาษี</td>
              <td align="right" style="font-size:13px;color:#111;">${params.buyerTaxId}</td>
            </tr>` : ""}
          </table>

          <!-- Divider -->
          <hr style="border:none;border-top:1px solid #e5e7eb;margin:20px 0;">

          <!-- Items -->
          <table width="100%" cellpadding="0" cellspacing="0">
            <tr style="background:#f9fafb;">
              <td style="padding:10px 12px;font-size:13px;font-weight:600;color:#374151;">รายการ</td>
              <td align="right" style="padding:10px 12px;font-size:13px;font-weight:600;color:#374151;">จำนวนเงิน</td>
            </tr>
            <tr>
              <td style="padding:12px 12px;font-size:14px;color:#111;">${params.planName}</td>
              <td align="right" style="padding:12px 12px;font-size:14px;color:#111;">${fmt(params.amountBeforeVat)} บาท</td>
            </tr>
          </table>

          <hr style="border:none;border-top:1px solid #e5e7eb;margin:12px 0;">

          <!-- Totals -->
          <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
              <td style="padding:4px 0;font-size:13px;color:#6b7280;">ราคาก่อน VAT</td>
              <td align="right" style="font-size:13px;color:#374151;">${fmt(params.amountBeforeVat)} บาท</td>
            </tr>
            <tr>
              <td style="padding:4px 0;font-size:13px;color:#6b7280;">VAT 7%</td>
              <td align="right" style="font-size:13px;color:#374151;">${fmt(params.vatAmount)} บาท</td>
            </tr>
            <tr>
              <td style="padding:10px 0 4px;font-size:15px;font-weight:700;color:#111;">ยอดรวมทั้งสิ้น</td>
              <td align="right" style="padding:10px 0 4px;font-size:15px;font-weight:700;color:#0ea5e9;">${fmt(params.totalAmount)} บาท</td>
            </tr>
          </table>

          <p style="margin:24px 0 0;font-size:12px;color:#9ca3af;line-height:1.6;">
            ขอบคุณที่ใช้บริการ MorRoo ครับ<br>
            หากมีคำถามเพิ่มเติม ติดต่อได้ที่ <a href="mailto:support@morroo.com" style="color:#0ea5e9;">support@morroo.com</a>
          </p>
        </td></tr>

        <!-- Footer -->
        <tr><td style="background:#f9fafb;padding:16px 32px;text-align:center;">
          <p style="margin:0;font-size:11px;color:#9ca3af;">© ${new Date().getFullYear()} MorRoo · morroo.com</p>
        </td></tr>

      </table>
    </td></tr>
  </table>
</body>
</html>`;
}

export async function emailReceipt(params: {
  toEmail: string;
  planName: string;
  invoiceNumber: string;
  totalAmount: number;
  vatAmount: number;
  amountBeforeVat: number;
  buyerName?: string;
  buyerTaxId?: string;
  publishedOn: string;
}): Promise<void> {
  if (!RESEND_KEY) {
    console.log("[Email] RESEND_API_KEY ไม่ได้ตั้งค่า — ข้ามการส่ง email");
    return;
  }

  const resend = new Resend(RESEND_KEY);

  try {
    await resend.emails.send({
      from: `MorRoo <${FROM_EMAIL}>`,
      to: params.toEmail,
      subject: `ใบเสร็จรับเงิน ${params.invoiceNumber} — MorRoo`,
      html: receiptHtml(params),
    });
  } catch (err) {
    console.error("[Email] send error:", err);
  }
}
