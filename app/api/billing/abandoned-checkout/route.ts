/**
 * Abandoned Checkout Recovery
 *
 * Cron job ที่ scan Stripe checkout sessions ที่ expired (ลูกค้ากดจ่ายแล้วไม่จ่าย)
 * แล้วส่ง LINE/email ตามให้กลับมาจ่าย
 *
 * Schedule: ทุกวัน 11:00 UTC (18:00 Bangkok)
 * POST /api/billing/abandoned-checkout?secret=$BLOG_GENERATE_SECRET
 */

import { NextResponse } from "next/server";
import { stripe } from "@/lib/stripe";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";

export const runtime = "nodejs";
export const maxDuration = 60;

const LOOKBACK_SECONDS = 24 * 60 * 60; // 24 hours

export async function POST(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const since = Math.floor(Date.now() / 1000) - LOOKBACK_SECONDS;
  const supabase = createAdminClient();
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

  const summary = { scanned: 0, abandoned: 0, notified: 0, errors: 0 };

  try {
    const sessions = await stripe.checkout.sessions.list({
      limit: 100,
      created: { gte: since },
    });

    for (const session of sessions.data) {
      summary.scanned++;

      // Only care about expired (unpaid) sessions with our metadata
      if (session.status !== "expired") continue;
      if (!session.metadata?.userId || !session.metadata?.planType) continue;

      summary.abandoned++;

      const userId = session.metadata.userId;
      const planType = session.metadata.planType;

      // Check if user already paid (maybe via a different session)
      const { data: existingOrder } = await supabase
        .from("payment_orders")
        .select("id")
        .eq("user_id", userId)
        .eq("status", "approved")
        .gte("created_at", new Date(Date.now() - LOOKBACK_SECONDS * 1000).toISOString())
        .maybeSingle();

      if (existingOrder) continue; // Already paid via another session, skip

      // Get user profile for LINE notification
      const { data: profile } = await supabase
        .from("profiles")
        .select("line_user_id, email, name")
        .eq("id", userId)
        .single();

      if (!profile) continue;

      const planLabels: Record<string, string> = {
        monthly: "รายเดือน",
        yearly: "รายปี",
        bundle: "ชุดข้อสอบ",
      };
      const planLabel = planLabels[planType] ?? planType;

      // Send LINE if linked
      if (profile.line_user_id) {
        try {
          await sendLineMessage(profile.line_user_id, [{
            type: "text",
            text: [
              `สวัสดีครับ ${profile.name ?? ""} 👋`,
              ``,
              `เราสังเกตว่าคุณเลือกแพ็กเกจ MorRoo ${planLabel} ไว้ แต่ยังไม่ได้ชำระเงิน`,
              ``,
              `ถ้ายังสนใจ กดลิงก์ด้านล่างเพื่อดำเนินการต่อได้เลยครับ`,
              `${siteUrl}/payment/${planType}`,
              ``,
              `มีคำถามอะไร ทักมาได้เลยนะครับ 😊`,
            ].join("\n"),
          }]);
          summary.notified++;
        } catch (err) {
          summary.errors++;
          console.error(`[abandoned] LINE error for ${userId}:`, err);
        }
      }
    }

    console.log(`[abandoned-checkout] ${JSON.stringify(summary)}`);
    return NextResponse.json({ ok: true, summary });
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    console.error("[abandoned-checkout] fatal:", msg);
    return NextResponse.json({ ok: false, error: msg, summary }, { status: 500 });
  }
}
