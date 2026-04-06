const FROM = "MorRoo <noreply@morroo.com>";
const API = "https://api.resend.com/emails";

async function send(to: string, subject: string, html: string) {
  const key = process.env.RESEND_API_KEY;
  if (!key) return;
  await fetch(API, {
    method: "POST",
    headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
    body: JSON.stringify({ from: FROM, to, subject, html }),
  });
}

// ────────────────────────────────────────────────
// Templates
// ────────────────────────────────────────────────

function base(content: string) {
  return `<!DOCTYPE html><html lang="th"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style>
body{margin:0;padding:0;background:#f5f5f0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;color:#1a1a1a}
.wrap{max-width:560px;margin:32px auto;background:#fff;border-radius:12px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.08)}
.header{background:#c0392b;padding:28px 32px;text-align:center}
.header h1{margin:0;color:#fff;font-size:22px;font-weight:700;letter-spacing:.5px}
.header p{margin:4px 0 0;color:rgba(255,255,255,.8);font-size:13px}
.body{padding:32px}
.btn{display:inline-block;margin:20px 0 0;padding:12px 28px;background:#c0392b;color:#fff!important;border-radius:8px;text-decoration:none;font-weight:600;font-size:15px}
.footer{background:#f9f9f7;padding:20px 32px;text-align:center;font-size:12px;color:#999;border-top:1px solid #eee}
h2{font-size:18px;margin:0 0 12px}p{font-size:15px;line-height:1.7;margin:0 0 12px;color:#444}
.tag{display:inline-block;background:#fff3cd;color:#856404;border-radius:6px;padding:3px 10px;font-size:13px;font-weight:600}
.box{background:#f9f9f7;border-radius:8px;padding:16px 20px;margin:16px 0}
</style></head><body><div class="wrap">
<div class="header"><h1>🏥 MorRoo</h1><p>เตรียมสอบใบประกอบวิชาชีพ</p></div>
<div class="body">${content}</div>
<div class="footer">MorRoo · ระบบฝึกข้อสอบใบประกอบวิชาชีพ<br>หากมีปัญหา ติดต่อ support@morroo.com</div>
</div></body></html>`;
}

// ────────────────────────────────────────────────
// Email functions
// ────────────────────────────────────────────────

export async function sendWelcomeEmail(to: string, name: string) {
  const html = base(`
    <h2>ยินดีต้อนรับสู่ MorRoo! 🎉</h2>
    <p>สวัสดีคุณ <strong>${name || "น้อง"}</strong></p>
    <p>บัญชีของคุณพร้อมใช้งานแล้ว เริ่มฝึกทำข้อสอบและติดตามความก้าวหน้าได้เลย</p>
    <div class="box">
      <p style="margin:0"><strong>เริ่มต้นได้ง่ายๆ:</strong></p>
      <p style="margin:8px 0 0">✅ เลือกสาขาที่ต้องการฝึก<br>✅ ตั้งเป้าหมายข้อสอบต่อวัน<br>✅ ดูสถิติและจุดอ่อนของตัวเอง</p>
    </div>
    <a href="https://morroo.com/nl" class="btn">เริ่มทำข้อสอบ →</a>
  `);
  await send(to, "ยินดีต้อนรับสู่ MorRoo! 🏥", html);
}

export async function sendPurchaseConfirmationEmail(
  to: string,
  name: string,
  planLabel: string,
  expiresAt: Date,
  invoiceNumber: string,
  amount: number
) {
  const expStr = expiresAt.toLocaleDateString("th-TH", { year: "numeric", month: "long", day: "numeric" });
  const html = base(`
    <h2>ชำระเงินสำเร็จ ✅</h2>
    <p>สวัสดีคุณ <strong>${name || "สมาชิก"}</strong></p>
    <p>ขอบคุณที่สมัครสมาชิก MorRoo! บัญชีของคุณได้รับการอัปเกรดแล้ว</p>
    <div class="box">
      <p style="margin:0 0 8px"><strong>รายละเอียดการสั่งซื้อ</strong></p>
      <p style="margin:4px 0">แพ็กเกจ: <span class="tag">${planLabel}</span></p>
      <p style="margin:4px 0">ยอดชำระ: ฿${amount.toLocaleString()}</p>
      <p style="margin:4px 0">หมดอายุ: ${expStr}</p>
      <p style="margin:4px 0;font-size:13px;color:#999">เลขที่ใบเสร็จ: ${invoiceNumber}</p>
    </div>
    <a href="https://morroo.com/nl" class="btn">เริ่มทำข้อสอบ →</a>
  `);
  await send(to, `ยืนยันการชำระเงิน — ${planLabel}`, html);
}

export async function sendReferralRewardEmail(
  to: string,
  name: string,
  rewardDays: number
) {
  const html = base(`
    <h2>เพื่อนของคุณสมัครแล้ว! 🎁</h2>
    <p>สวัสดีคุณ <strong>${name || "สมาชิก"}</strong></p>
    <p>เพื่อนที่คุณแนะนำได้สมัครสมาชิก MorRoo แล้ว!</p>
    <div class="box">
      <p style="margin:0;font-size:17px;font-weight:600;color:#c0392b">🎉 คุณได้รับ ${rewardDays} วัน ฟรี!</p>
      <p style="margin:8px 0 0;font-size:13px;color:#666">สิทธิ์ได้ถูกเพิ่มเข้าบัญชีของคุณอัตโนมัติแล้ว</p>
    </div>
    <p>ชวนเพื่อนคนต่อไปเพื่อรับสิทธิ์เพิ่มได้เลย!</p>
    <a href="https://morroo.com/profile" class="btn">ดูรหัสชวนเพื่อน →</a>
  `);
  await send(to, "เพื่อนสมัครแล้ว — คุณได้รับ 30 วันฟรี! 🎁", html);
}
