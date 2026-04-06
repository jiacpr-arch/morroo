// Email HTML templates for Resend
// Usage: import { welcomeEmail, receiptEmail } from "@/lib/email/templates"

export interface WelcomeEmailProps {
  name: string;
  email: string;
}

export interface ReceiptEmailProps {
  name: string;
  email: string;
  packageType: "bundle" | "monthly" | "yearly";
  amount: number;
  expiresAt: string; // ISO date string
  chargeId: string;
}

const BRAND_COLOR = "#16A085";
const DARK_COLOR = "#1A2F23";

const baseStyle = `
  font-family: 'Sarabun', 'Helvetica Neue', Arial, sans-serif;
  max-width: 600px;
  margin: 0 auto;
  background: #ffffff;
`;

const headerHtml = `
  <div style="background: ${DARK_COLOR}; padding: 24px 32px; text-align: center;">
    <h1 style="color: #ffffff; font-size: 24px; margin: 0;">🩺 หมอรู้</h1>
    <p style="color: rgba(255,255,255,0.7); font-size: 13px; margin: 6px 0 0;">เตรียมสอบแพทย์ ด้วย AI ที่เข้าใจคุณ</p>
  </div>
`;

const footerHtml = `
  <div style="background: #f8f9fa; padding: 20px 32px; text-align: center; border-top: 1px solid #e9ecef;">
    <p style="color: #6c757d; font-size: 12px; margin: 0 0 6px;">
      © ${new Date().getFullYear()} หมอรู้ (MorRoo) — สงวนลิขสิทธิ์
    </p>
    <p style="color: #6c757d; font-size: 12px; margin: 0;">
      <a href="https://www.morroo.com/privacy" style="color: ${BRAND_COLOR};">นโยบายความเป็นส่วนตัว</a>
      &nbsp;·&nbsp;
      <a href="https://www.morroo.com" style="color: ${BRAND_COLOR};">morroo.com</a>
    </p>
  </div>
`;

function newsletterFooterHtml(unsubscribeUrl?: string): string {
  const unsubLine = unsubscribeUrl
    ? `<p style="color: #9ca3af; font-size: 11px; margin: 6px 0 0;">
        ไม่ต้องการรับอีเมลนี้?
        <a href="${unsubscribeUrl}" style="color: #9ca3af;">ยกเลิกการรับข่าวสาร</a>
      </p>`
    : "";
  return `
  <div style="background: #f8f9fa; padding: 20px 32px; text-align: center; border-top: 1px solid #e9ecef;">
    <p style="color: #6c757d; font-size: 12px; margin: 0 0 6px;">
      © ${new Date().getFullYear()} หมอรู้ (MorRoo) — สงวนลิขสิทธิ์
    </p>
    <p style="color: #6c757d; font-size: 12px; margin: 0;">
      <a href="https://www.morroo.com/privacy" style="color: ${BRAND_COLOR};">นโยบายความเป็นส่วนตัว</a>
      &nbsp;·&nbsp;
      <a href="https://www.morroo.com" style="color: ${BRAND_COLOR};">morroo.com</a>
    </p>
    ${unsubLine}
  </div>
`;
}

const PACKAGE_LABELS: Record<string, string> = {
  bundle: "Bundle Pack (30 วัน) — ฿99",
  monthly: "Full รายเดือน — ฿199/เดือน",
  yearly: "Full รายปี — ฿1,490/ปี",
};

const PACKAGE_FEATURES: Record<string, string[]> = {
  bundle: [
    "MCQ 20 ข้อเลือกเอง",
    "MEQ 5 เคส พร้อมเฉลยละเอียด",
    "Long Case 2 เคส",
    "AI ตรวจคำตอบ",
  ],
  monthly: [
    "MEQ + MCQ + Long Case ไม่จำกัด",
    "AI ตรวจคำตอบทุกข้อ",
    "ข้อสอบใหม่ทุกสัปดาห์",
    "ยกเลิกได้ทุกเมื่อ",
  ],
  yearly: [
    "MEQ + MCQ + Long Case ไม่จำกัด",
    "AI ตรวจคำตอบทุกข้อ",
    "ข้อสอบใหม่ทุกสัปดาห์",
    "สิทธิ์เข้าถึงก่อนใคร",
    "ประหยัด ฿898 เมื่อเทียบรายเดือน",
  ],
};

export function welcomeEmail({ name }: WelcomeEmailProps): string {
  return `<!DOCTYPE html>
<html lang="th">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f4f4f4;">
<div style="${baseStyle}">
  ${headerHtml}
  <div style="padding: 32px;">
    <h2 style="color: ${DARK_COLOR}; font-size: 22px; margin: 0 0 12px;">ยินดีต้อนรับสู่หมอรู้! 🎉</h2>
    <p style="color: #374151; font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
      สวัสดีคุณ <strong>${name}</strong>,
    </p>
    <p style="color: #374151; font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
      ขอบคุณที่สมัครสมาชิกกับหมอรู้ครับ! ตอนนี้คุณสามารถเริ่มใช้งานแพลตฟอร์มเตรียมสอบแพทย์ของเราได้แล้ว
    </p>

    <div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 20px; margin: 24px 0;">
      <h3 style="color: ${DARK_COLOR}; margin: 0 0 12px; font-size: 16px;">สิ่งที่คุณทำได้ฟรีวันนี้</h3>
      <ul style="color: #374151; font-size: 15px; line-height: 1.8; margin: 0; padding-left: 20px;">
        <li>MCQ 5 ข้อ ต่อสาขาวิชา (6 สาขา)</li>
        <li>ข้อสอบ MEQ 2 เคส พร้อม feedback</li>
        <li>Long Case กับ AI 1 เคส</li>
      </ul>
    </div>

    <div style="text-align: center; margin: 28px 0;">
      <a href="https://www.morroo.com/exams"
         style="display: inline-block; background: ${BRAND_COLOR}; color: #ffffff; text-decoration: none;
                padding: 14px 32px; border-radius: 8px; font-size: 16px; font-weight: 600;">
        เริ่มทำข้อสอบ MEQ →
      </a>
    </div>

    <p style="color: #6b7280; font-size: 14px; line-height: 1.6; margin: 20px 0 0;">
      ต้องการปลดล็อกข้อสอบทั้งหมด?
      <a href="https://www.morroo.com/pricing" style="color: ${BRAND_COLOR}; font-weight: 600;">ดูแพ็กเกจราคา</a>
      เริ่มต้นที่ ฿99 เท่านั้น
    </p>
  </div>
  ${footerHtml}
</div>
</body>
</html>`;
}

export function receiptEmail({
  name,
  packageType,
  amount,
  expiresAt,
  chargeId,
}: ReceiptEmailProps): string {
  const packageLabel = PACKAGE_LABELS[packageType] ?? packageType;
  const features = PACKAGE_FEATURES[packageType] ?? [];
  const expireDate = new Date(expiresAt).toLocaleDateString("th-TH", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
  const featuresHtml = features
    .map(
      (f) =>
        `<li style="color: #374151; font-size: 15px; line-height: 1.8;">${f}</li>`
    )
    .join("");

  return `<!DOCTYPE html>
<html lang="th">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f4f4f4;">
<div style="${baseStyle}">
  ${headerHtml}
  <div style="padding: 32px;">
    <h2 style="color: ${DARK_COLOR}; font-size: 22px; margin: 0 0 12px;">ใบเสร็จการชำระเงิน ✅</h2>
    <p style="color: #374151; font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
      สวัสดีคุณ <strong>${name}</strong>, ขอบคุณที่สมัครสมาชิกหมอรู้ครับ!
    </p>

    <div style="border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; margin: 20px 0;">
      <div style="background: ${BRAND_COLOR}; padding: 14px 20px;">
        <h3 style="color: #ffffff; margin: 0; font-size: 16px;">รายละเอียดการสั่งซื้อ</h3>
      </div>
      <div style="padding: 20px;">
        <table style="width: 100%; border-collapse: collapse;">
          <tr>
            <td style="color: #6b7280; font-size: 14px; padding: 6px 0;">แพ็กเกจ</td>
            <td style="color: #111827; font-size: 14px; font-weight: 600; text-align: right;">${packageLabel}</td>
          </tr>
          <tr>
            <td style="color: #6b7280; font-size: 14px; padding: 6px 0;">ยอดชำระ</td>
            <td style="color: #111827; font-size: 14px; font-weight: 600; text-align: right;">฿${amount.toLocaleString()}</td>
          </tr>
          <tr>
            <td style="color: #6b7280; font-size: 14px; padding: 6px 0;">ใช้งานได้ถึง</td>
            <td style="color: #111827; font-size: 14px; font-weight: 600; text-align: right;">${expireDate}</td>
          </tr>
          <tr>
            <td style="color: #6b7280; font-size: 14px; padding: 6px 0;">หมายเลขอ้างอิง</td>
            <td style="color: #6b7280; font-size: 12px; text-align: right; font-family: monospace;">${chargeId}</td>
          </tr>
        </table>
      </div>
    </div>

    <div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px; padding: 20px; margin: 20px 0;">
      <h3 style="color: ${DARK_COLOR}; margin: 0 0 12px; font-size: 16px;">สิทธิ์ที่คุณได้รับ</h3>
      <ul style="margin: 0; padding-left: 20px;">${featuresHtml}</ul>
    </div>

    <div style="text-align: center; margin: 28px 0;">
      <a href="https://www.morroo.com/exams"
         style="display: inline-block; background: ${BRAND_COLOR}; color: #ffffff; text-decoration: none;
                padding: 14px 32px; border-radius: 8px; font-size: 16px; font-weight: 600;">
        เริ่มฝึกสอบเลย →
      </a>
    </div>

    <p style="color: #6b7280; font-size: 13px; line-height: 1.6; margin: 20px 0 0;">
      มีปัญหาหรือข้อสงสัย ติดต่อเราได้ที่
      <a href="mailto:jiacpr@gmail.com" style="color: ${BRAND_COLOR};">jiacpr@gmail.com</a>
    </p>
  </div>
  ${footerHtml}
</div>
</body>
</html>`;
}

export interface NewsletterPost {
  title: string;
  slug: string;
  category: string;
  readingTime: number;
  description: string;
}

export function weeklyNewsletterEmail({
  name,
  newExamCount,
  tipTitle,
  tipContent,
  latestPosts = [],
  unsubscribeUrl,
}: {
  name: string;
  newExamCount: number;
  tipTitle: string;
  tipContent: string;
  latestPosts?: NewsletterPost[];
  unsubscribeUrl?: string;
}): string {
  const postsHtml = latestPosts.length > 0
    ? `<div style="margin: 0 0 24px;">
        <h3 style="color: ${DARK_COLOR}; margin: 0 0 12px; font-size: 16px;">📝 บทความล่าสุดจากหมอรู้</h3>
        ${latestPosts.map((p) => `
          <a href="https://www.morroo.com/blog/${p.slug}" style="display: block; text-decoration: none;
             border: 1px solid #e5e7eb; border-radius: 8px; padding: 14px 16px; margin-bottom: 10px;
             background: #ffffff;">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
              <span style="background: ${BRAND_COLOR}20; color: ${BRAND_COLOR}; font-size: 11px;
                           font-weight: 600; padding: 2px 8px; border-radius: 20px;">${p.category}</span>
              <span style="color: #9ca3af; font-size: 12px;">อ่าน ${p.readingTime} นาที</span>
            </div>
            <p style="color: #111827; font-size: 14px; font-weight: 600; margin: 0 0 4px;">${p.title}</p>
            <p style="color: #6b7280; font-size: 13px; margin: 0; overflow: hidden; display: -webkit-box;
                      -webkit-line-clamp: 2; -webkit-box-orient: vertical;">${p.description}</p>
          </a>`).join("")}
      </div>`
    : "";

  return `<!DOCTYPE html>
<html lang="th">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin:0;padding:0;background:#f4f4f4;">
<div style="${baseStyle}">
  ${headerHtml}
  <div style="padding: 32px;">
    <h2 style="color: ${DARK_COLOR}; font-size: 22px; margin: 0 0 12px;">อัปเดตประจำสัปดาห์ 📚</h2>
    <p style="color: #374151; font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
      สวัสดีคุณ <strong>${name}</strong>,
    </p>

    <div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px; padding: 20px; margin: 0 0 24px;">
      <h3 style="color: #1e40af; margin: 0 0 8px; font-size: 16px;">🆕 ข้อสอบใหม่สัปดาห์นี้</h3>
      <p style="color: #374151; font-size: 15px; margin: 0;">
        มีข้อสอบ MEQ ใหม่ <strong>${newExamCount} เคส</strong> เพิ่มเข้ามาแล้ว!
      </p>
    </div>

    ${postsHtml}

    <div style="background: #fefce8; border: 1px solid #fef08a; border-radius: 8px; padding: 20px; margin: 0 0 24px;">
      <h3 style="color: #854d0e; margin: 0 0 8px; font-size: 16px;">💡 เทคนิคประจำสัปดาห์</h3>
      <h4 style="color: #374151; margin: 0 0 8px; font-size: 15px;">${tipTitle}</h4>
      <p style="color: #374151; font-size: 14px; line-height: 1.6; margin: 0;">${tipContent}</p>
    </div>

    <div style="text-align: center; margin: 28px 0;">
      <a href="https://www.morroo.com/exams"
         style="display: inline-block; background: ${BRAND_COLOR}; color: #ffffff; text-decoration: none;
                padding: 14px 32px; border-radius: 8px; font-size: 16px; font-weight: 600; margin-right: 8px;">
        ทำข้อสอบ MEQ
      </a>
      <a href="https://www.morroo.com/nl"
         style="display: inline-block; background: transparent; color: ${BRAND_COLOR}; text-decoration: none;
                padding: 13px 24px; border-radius: 8px; font-size: 16px; font-weight: 600;
                border: 2px solid ${BRAND_COLOR};">
        ทำข้อสอบ MCQ
      </a>
    </div>
  </div>
  ${newsletterFooterHtml(unsubscribeUrl)}
</div>
</body>
</html>`;
}
