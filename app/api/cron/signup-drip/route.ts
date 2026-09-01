/**
 * Daily signup-drip cron — D1 / D3 / D7 LINE nudges for free signups
 * who haven't upgraded yet.
 *
 * Pairs with lead-followup (codes) and trial-expiry (paying members about
 * to lapse). Targets the gap in between: people who signed up free, are
 * still on free, and need a reason to come back.
 *
 * Dedupes via `signup_drip_sent (profile_id, days_after_signup, channel)`
 * so retries / multiple daily runs never spam the same user.
 *
 * Auth matches the other crons: Bearer CRON_SECRET header (Vercel Cron)
 * or `?secret=$BLOG_GENERATE_SECRET` for manual runs.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage } from "@/lib/line";

export const runtime = "nodejs";
export const maxDuration = 60;

type ReminderDay = 1 | 3 | 7;
const REMINDER_DAYS: ReminderDay[] = [1, 3, 7];

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (
    auth &&
    process.env.CRON_SECRET &&
    auth === `Bearer ${process.env.CRON_SECRET}`
  ) {
    return true;
  }
  return false;
}

type Profile = {
  id: string;
  name: string | null;
  line_user_id: string | null;
  created_at: string;
};

type DaySummary = {
  sent: number;
  skipped_dedup: number;
  skipped_no_line: number;
  failed: number;
};

type Summary = Record<`d${ReminderDay}`, DaySummary> & { errors: number };

function messageFor(day: ReminderDay, name: string, siteUrl: string): string {
  const who = name && name.trim().length > 0 ? name.trim() : "คุณหมอ";
  switch (day) {
    case 1:
      return (
        `สวัสดี ${who} 👋\n` +
        `1 วันที่ผ่านมาเริ่มทบทวนกันต่อ — หมอรู้มี MEQ 2 เคสฟรีรอใช้ AI ตรวจคำตอบทันที\n` +
        `${siteUrl}/exams`
      );
    case 3:
      return (
        `${who} ครบ 3 วันแล้ว 🎯\n` +
        `ลอง Long Case 1 เคสฟรี ซักประวัติ + นำเสนอ AI Examiner เหมือนสอบจริง\n` +
        `${siteUrl}/longcase`
      );
    case 7:
      return (
        `${who} ครบ 1 สัปดาห์ที่ลงทะเบียน 🚀\n` +
        `อัปเกรดเริ่มต้น ฿199/เดือน — ปลดล็อก MCQ 3,000+ ข้อ + Long Case ไม่จำกัด\n` +
        `${siteUrl}/pricing`
      );
  }
}

async function run(): Promise<Summary> {
  const supabase = createAdminClient();
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  const summary: Summary = {
    d1: { sent: 0, skipped_dedup: 0, skipped_no_line: 0, failed: 0 },
    d3: { sent: 0, skipped_dedup: 0, skipped_no_line: 0, failed: 0 },
    d7: { sent: 0, skipped_dedup: 0, skipped_no_line: 0, failed: 0 },
    errors: 0,
  };

  for (const days of REMINDER_DAYS) {
    // Sliding 24h window: signed up between (days) and (days-1) days ago.
    // A daily cron sees each profile in exactly one window per reminder day.
    const upper = new Date(
      Date.now() - (days - 1) * 24 * 60 * 60 * 1000
    ).toISOString();
    const lower = new Date(
      Date.now() - days * 24 * 60 * 60 * 1000
    ).toISOString();

    const { data: profiles, error } = await supabase
      .from("profiles")
      .select("id, name, line_user_id, created_at")
      .eq("membership_type", "free")
      .gte("created_at", lower)
      .lt("created_at", upper);

    if (error) {
      console.error(`[signup-drip] D${days} query failed:`, error);
      summary.errors++;
      continue;
    }

    const bucket = summary[`d${days}` as `d${ReminderDay}`];

    for (const p of (profiles ?? []) as Profile[]) {
      try {
        if (!p.line_user_id) {
          bucket.skipped_no_line++;
          continue;
        }

        const { data: alreadySent, error: dedupError } = await supabase
          .from("signup_drip_sent")
          .select("profile_id")
          .eq("profile_id", p.id)
          .eq("days_after_signup", days)
          .eq("channel", "line")
          .maybeSingle();
        if (dedupError) {
          // If the table is missing (migration not applied yet) abort the
          // whole run — sending without dedup tracking would re-spam on
          // every retry.
          console.error("[signup-drip] dedup query failed:", dedupError);
          summary.errors++;
          return summary;
        }
        if (alreadySent) {
          bucket.skipped_dedup++;
          continue;
        }

        const text = messageFor(days, p.name ?? "", siteUrl);
        const ok = await sendLineMessage(p.line_user_id, [
          { type: "text", text },
        ]);
        if (!ok) {
          bucket.failed++;
          continue;
        }

        const { error: insertError } = await supabase
          .from("signup_drip_sent")
          .insert({
            profile_id: p.id,
            days_after_signup: days,
            channel: "line",
          });
        if (insertError && insertError.code !== "23505") {
          console.error("[signup-drip] dedupe insert failed:", insertError);
        }

        bucket.sent++;
      } catch (e) {
        console.error("[signup-drip] failed for profile", p.id, e);
        bucket.failed++;
      }
    }
  }

  return summary;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const summary = await run();
  return NextResponse.json({ ok: true, ...summary });
}

export async function POST(request: Request) {
  return GET(request);
}
