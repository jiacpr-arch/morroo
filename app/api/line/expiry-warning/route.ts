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
 *   D+1  win-back (LINE if linked, else email): plans are one-time purchases
 *        and don't auto-renew, so the day after access runs out we ask why
 *        they're not renewing — /renewal records the reason and shows a
 *        tailored offer (lib/winback.ts). Stored as days_before_expiry = -1.
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
import { sendTrialExpiryEmail, sendWinbackEmail } from "@/lib/email/send";
import { buildExpiryWarningMessage, buildWinbackMessage } from "@/lib/line-flex-templates";
import { getLapseState, getLatestFeedback } from "@/lib/winback-server";
import { canIssueWinback } from "@/lib/winback";
import { getTrialStatus, TRIAL_FULL_PRICES } from "@/lib/trial";

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

/** trial_messages_sent.days_before_expiry marker for the D+1 win-back. */
export const WINBACK_DAY = -1;

/** Access ran out within the last day — each lapsed profile lands here exactly once. */
export function lapsedWindow(now: number): { from: string; to: string } {
  return {
    from: new Date(now - 86400_000).toISOString(),
    to: new Date(now).toISOString(),
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
    winback_line_sent: 0,
    winback_email_sent: 0,
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
        // Free-trial users get trial copy (one-time trial, end date, prices).
        // D-7 would land on sign-up day for a 7-day trial, so it's skipped.
        const onTrial = (await getTrialStatus(user.id)).active;
        if (onTrial && days === 7) continue;

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
            trialPrices: onTrial ? TRIAL_FULL_PRICES : undefined,
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
            trialPrices: onTrial ? TRIAL_FULL_PRICES : undefined,
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

  // ── D+1 win-back ───────────────────────────────────────────────────────
  const lapsed = lapsedWindow(now);
  const { data: lapsedUsers, error: lapsedError } = await supabase
    .from("profiles")
    .select("id, name, email, line_user_id, membership_type, membership_expires_at")
    .neq("membership_type", "free")
    .neq("membership_type", "bundle")
    .gte("membership_expires_at", lapsed.from)
    .lt("membership_expires_at", lapsed.to);

  if (lapsedError) {
    console.error("[expiry-warning] D+1 query error:", lapsedError);
    summary.errors++;
  }

  for (const user of (lapsedUsers ?? []) as ProfileRow[]) {
    try {
      // Already answered the survey (e.g. from the profile page) — don't ask again.
      const latest = await getLatestFeedback(user.id);
      if (latest && !canIssueWinback(latest.created_at)) {
        summary.skipped_dedup++;
        continue;
      }

      let channel = pickExpiryChannel(
        { lineUserId: user.line_user_id, email: user.email },
        1
      );
      if (channel === "line" && quota.throttled) {
        const hasRealEmail = !!user.email && !user.email.endsWith("@line.morroo.com");
        channel = hasRealEmail ? "email" : null;
      }
      if (!channel) {
        summary.skipped_no_channel++;
        continue;
      }

      const { data: alreadySent } = await supabase
        .from("trial_messages_sent")
        .select("profile_id")
        .eq("profile_id", user.id)
        .eq("days_before_expiry", WINBACK_DAY)
        .eq("channel", channel)
        .maybeSingle();
      if (alreadySent) {
        summary.skipped_dedup++;
        continue;
      }

      const { wasTrial } = await getLapseState(user.id);
      if (channel === "line") {
        const ok = await sendLineMessage(user.line_user_id!, [
          buildWinbackMessage({ name: user.name ?? "", wasTrial }),
        ]);
        if (!ok) {
          summary.errors++;
          continue;
        }
        summary.winback_line_sent++;
      } else {
        await sendWinbackEmail({
          email: user.email!,
          name: user.name ?? "คุณหมอ",
          wasTrial,
          surveyUrl: `${siteUrl}/renewal?source=expiry_email`,
        });
        summary.winback_email_sent++;
      }

      const { error: insertError } = await supabase
        .from("trial_messages_sent")
        .insert({ profile_id: user.id, days_before_expiry: WINBACK_DAY, channel });
      if (insertError && insertError.code !== "23505") {
        console.error("[expiry-warning] win-back dedupe insert failed:", insertError);
      }
    } catch (err) {
      console.error("[expiry-warning] win-back failed for profile", user.id, err);
      summary.errors++;
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
