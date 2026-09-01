/**
 * Daily trial-expiry conversion cron — D-3 / D-1 email reminders.
 *
 * Targets users with active monthly memberships about to expire and nudges
 * them to upgrade before they lapse to free. Dedupes via
 * trial_messages_sent so the cron is safe to retry / run multiple times
 * per day without spamming.
 *
 * D-1 (last reminder): we use D-1 not D-0 so the email arrives the day
 * BEFORE expiry. Sending on expiry day is too late — the user wakes up to
 * features already locked.
 *
 * Auth: Vercel Cron's Bearer header (CRON_SECRET) or ?secret=BLOG_GENERATE_SECRET.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendTrialExpiryEmail } from "@/lib/email/send";

export const runtime = "nodejs";
export const maxDuration = 60;

type ReminderDay = 3 | 1;
const REMINDER_DAYS: ReminderDay[] = [3, 1];

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
  email: string | null;
  name: string | null;
  membership_expires_at: string;
};

type Summary = {
  d3_sent: number;
  d3_skipped: number;
  d1_sent: number;
  d1_skipped: number;
  errors: number;
};

async function run(): Promise<Summary> {
  const supabase = createAdminClient();
  const summary: Summary = {
    d3_sent: 0,
    d3_skipped: 0,
    d1_sent: 0,
    d1_skipped: 0,
    errors: 0,
  };

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

  for (const days of REMINDER_DAYS) {
    // Window: profiles whose membership expires `days` to `days-1` days
    // from now. A daily cron sees each profile in exactly one window per
    // reminder day.
    const lower = new Date(
      Date.now() + (days - 1) * 24 * 60 * 60 * 1000
    ).toISOString();
    const upper = new Date(
      Date.now() + days * 24 * 60 * 60 * 1000
    ).toISOString();

    const { data: profiles, error } = await supabase
      .from("profiles")
      .select("id, email, name, membership_expires_at")
      .eq("membership_type", "monthly")
      .not("email", "is", null)
      .gte("membership_expires_at", lower)
      .lt("membership_expires_at", upper);

    if (error) {
      console.error(`[trial-expiry] D-${days} query failed:`, error);
      summary.errors++;
      continue;
    }

    for (const p of (profiles ?? []) as Profile[]) {
      try {
        const { data: alreadySent } = await supabase
          .from("trial_messages_sent")
          .select("profile_id")
          .eq("profile_id", p.id)
          .eq("days_before_expiry", days)
          .eq("channel", "email")
          .maybeSingle();
        if (alreadySent) {
          if (days === 3) summary.d3_skipped++;
          else summary.d1_skipped++;
          continue;
        }

        // Skip placeholder LINE-only emails — Resend will reject these and
        // we'd waste retries. A real email is required for delivery.
        if (!p.email || p.email.endsWith("@line.morroo.com")) {
          if (days === 3) summary.d3_skipped++;
          else summary.d1_skipped++;
          continue;
        }

        await sendTrialExpiryEmail({
          email: p.email,
          name: p.name ?? "คุณหมอ",
          expiresAt: p.membership_expires_at,
          pricingUrl: `${siteUrl}/pricing`,
          daysBeforeExpiry: days,
        });

        const { error: insertError } = await supabase
          .from("trial_messages_sent")
          .insert({
            profile_id: p.id,
            days_before_expiry: days,
            channel: "email",
          });
        if (insertError && insertError.code !== "23505") {
          console.error("[trial-expiry] dedupe insert failed:", insertError);
        }

        if (days === 3) summary.d3_sent++;
        else summary.d1_sent++;
      } catch (e) {
        console.error("[trial-expiry] failed for profile", p.id, e);
        summary.errors++;
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
