// Resend email sender
// Requires: RESEND_API_KEY in .env.local
// Requires: npm install resend

import { welcomeEmail, receiptEmail, weeklyNewsletterEmail } from "./templates";
import type {
  WelcomeEmailProps,
  ReceiptEmailProps,
  NewsletterPost,
} from "./templates";

const FROM_ADDRESS = "หมอรู้ <noreply@morroo.com>";

async function sendEmail({
  to,
  subject,
  html,
}: {
  to: string;
  subject: string;
  html: string;
}) {
  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    console.warn("[email] RESEND_API_KEY not set — skipping email");
    return { id: null };
  }

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ from: FROM_ADDRESS, to, subject, html }),
  });

  if (!res.ok) {
    const err = await res.text();
    console.error("[email] Resend error:", err);
    throw new Error(`Failed to send email: ${err}`);
  }

  return res.json() as Promise<{ id: string }>;
}

export async function sendWelcomeEmail(props: WelcomeEmailProps) {
  return sendEmail({
    to: props.email,
    subject: "ยินดีต้อนรับสู่หมอรู้! 🩺 เริ่มฝึกสอบได้เลย",
    html: welcomeEmail(props),
  });
}

export async function sendReceiptEmail(props: ReceiptEmailProps) {
  return sendEmail({
    to: props.email,
    subject: `ใบเสร็จหมอรู้ — ${props.packageType === "bundle" ? "Bundle Pack" : props.packageType === "monthly" ? "Full รายเดือน" : "Full รายปี"}`,
    html: receiptEmail(props),
  });
}

export async function sendWeeklyNewsletter({
  subscribers,
  newExamCount,
  tipTitle,
  tipContent,
  latestPosts = [],
}: {
  subscribers: Array<{ name: string; email: string }>;
  newExamCount: number;
  tipTitle: string;
  tipContent: string;
  latestPosts?: NewsletterPost[];
}) {
  const results = await Promise.allSettled(
    subscribers.map((s) =>
      sendEmail({
        to: s.email,
        subject: `📚 อัปเดตหมอรู้ประจำสัปดาห์ — ข้อสอบใหม่ ${newExamCount} เคส`,
        html: weeklyNewsletterEmail({
          name: s.name,
          newExamCount,
          tipTitle,
          tipContent,
          latestPosts,
        }),
      })
    )
  );

  const failed = results.filter((r) => r.status === "rejected");
  if (failed.length > 0) {
    console.error(`[email] ${failed.length}/${subscribers.length} emails failed`);
  }
  return { sent: results.length - failed.length, failed: failed.length };
}
