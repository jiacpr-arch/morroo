/**
 * Unified membership-expiry reminder — D-7 / D-3 / D-1 before
 * membership_expires_at, one channel per profile per day so nobody gets
 * double-pinged.
 *
 * Used to be two separate crons that overlapped on day 3: this route
 * (LINE, D-7/D-3) and /api/cron/trial-expiry (email, D-3/D-1, monthly plans
 * only, retired — see that route's history). A profile with both a linked
 * LINE account and a real email got two different D-3 messages same day,
 * and anyone LINE-only never got a D-1 nudge at all. Now:
 *
 *   D-7  LINE only (if linked) — an early heads-up stays LINE-exclusive
 *        rather than adding a new email touch nobody asked for.
 *   D-3  LINE if linked, else email (never both).
 *   D-1  LINE if linked, else email (never both).
 *
 * Dedupe via trial_messages_sent (profile_id, days_before_expiry, channel)
 * — safe to retry / run multiple times a day without repeat sends.
 *
 * Scheduled via pg_cron (see supabase/migrations/20260512_cron_vault_rewrite.sql,
 * job `send-expiry-warning`, 0 2 * * * UTC = 09:00 Asia/Bangkok) hitting this
 * same path, so no cron-schedule change is needed for this rewrite.
 *
 * Auth: `?secret=$BLOG_GENERATE_SECRET` (matches the pg_cron job) or the
 * Bearer CRON_SECRET header used by every other cron route in this repo.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { sendTrialExpiryEmail } from "@/lib/email/send";
import { buildExpiryWarningMessage } from "@/lib/line-flex-templates";

export const runtime = "nodejs";
export const maxDuration = 60;

type ReminderDay = 7 | 3 | 1;
const REMINDER_DAYS: ReminderDay[] = [7, 3, 1];
/** Days that also support an email fallback (sendTrialExpiryEmail only has copy for these). */
type EmailReminderDay = 3 | 1;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;

  const auth = request.headers.get("authorization");
  if (auth && process.env.CRON_SECRET && auth === `Bearer ${process.env.CRON_SECRET}`) {
    return true;
  }
  return false;
}

export type ExpiryChannel = "line" | "email";

export interface ExpiryProfile {
  lineUserId: string | null;
  email: string | null;
}

/**
 * Pure channel decision so it's unit-testable without a Supabase mock:
 * LINE wins when linked (regardless of day); otherwise fall back to a real
 * email, but only on days that have an email template. A `@line.morroo.com`
 * placeholder email (assigned to LINE-only signups) never counts as "real".
 */
export function pickExpiryChannel(
  profile: ExpiryProfile,
  day: ReminderDay
): ExpiryChannel | null {
  if (profile.lineUserId) return "line";
  const hasRealEmail = !!profile.email && !profile.email.endsWith("@line.morroo.com");
  if (day !== 7 && hasRealEmail) return "email";
  return null;
}

/** Membership expires between (days-1) and (days) days from `now` — crosses this bucket exactly once per profile per day the cron runs. */
export function expiryWindow(now: number, days: ReminderDay): { from: string; to: string } {
  return {
    from: new Date(now + (days - 1) * 86400_000).toISOString(),
    to: new Date(now + days * 86400_000).toISOString(),
  };
}

type ProfileRow = {
  id: string;
  name: string | null;
  email: string | null;
  line_user_id: string | null;
  membership_type: string;
  membership_expires_at: string;
};

async function run() {
  const summary = {
    line_sent: 0,
    email_sent: 0,
    skipped_dedup: 0,
    skipped_no_channel: 0,
    errors: 0,
  };

  const supabase = createAdminClient();
  const quota = await checkLineQuota();
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  const now = Date.now();

  for (const days of REMINDER_DAYS) {
    const { from, to } = expiryWindow(now, days);

    const { data: users, error } = await supabase
      .from("profiles")
      .select("id, name, email, line_user_id, membership_type, membership_expires_at")
      .neq("membership_type", "free")
      .gte("membership_expires_at", from)
      .lt("membership_expires_at", to);

    if (error) {
      console.error(`[expiry-warning] D-${days} query error:`, error);
      summary.errors++;
      continue;
    }

    for (const user of (users ?? []) as ProfileRow[]) {
      try {
        let channel = pickExpiryChannel(
          { lineUserId: user.line_user_id, email: user.email },
          days
        );
        // Bulk LINE headroom is low — degrade to email instead of dropping
        // the reminder entirely, same as if LINE weren't linked at all.
        if (channel === "line" && quota.throttled) {
          const hasRealEmail = !!user.email && !user.email.endsWith("@line.morroo.com");
          channel = days !== 7 && hasRealEmail ? "email" : null;
        }

        if (!channel) {
          summary.skipped_no_channel++;
          continue;
        }

        const { data: alreadySent } = await supabase
          .from("trial_messages_sent")
          .select("profile_id")
          .eq("profile_id", user.id)
          .eq("days_before_expiry", days)
          .eq("channel", channel)
          .maybeSingle();
        if (alreadySent) {
          summary.skipped_dedup++;
          continue;
        }

        if (channel === "line") {
          const msg = buildExpiryWarningMessage({
            name: user.name ?? "",
            expiresAt: new Date(user.membership_expires_at),
            membershipType: user.membership_type,
          });
          const ok = await sendLineMessage(user.line_user_id!, [msg]);
          if (!ok) {
            summary.errors++;
            continue;
          }
          summary.line_sent++;
        } else {
          await sendTrialExpiryEmail({
            email: user.email!,
            name: user.name ?? "คุณหมอ",
            expiresAt: user.membership_expires_at,
            pricingUrl: `${siteUrl}/pricing`,
            daysBeforeExpiry: days as EmailReminderDay,
          });
          summary.email_sent++;
        }

        const { error: insertError } = await supabase
          .from("trial_messages_sent")
          .insert({ profile_id: user.id, days_before_expiry: days, channel });
        if (insertError && insertError.code !== "23505") {
          console.error("[expiry-warning] dedupe insert failed:", insertError);
        }
      } catch (err) {
        console.error("[expiry-warning] failed for profile", user.id, err);
        summary.errors++;
      }
    }
  }

  return summary;
}

export async function POST(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const summary = await run();
  console.log(`[expiry-warning] ${JSON.stringify(summary)}`);
  return NextResponse.json({ ok: true, ...summary });
}

export async function GET(request: Request) {
  return POST(request);
}
