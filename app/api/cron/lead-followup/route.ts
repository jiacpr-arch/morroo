/**
 * Daily lead follow-up cron — email reminders for unredeemed codes.
 *
 * Runs once per day. For each reminder day in the schedule (D1, D3, D6),
 * finds leads whose `code_issued` row is exactly that age, has an
 * unredeemed unexpired code, and hasn't received that day's email yet
 * (deduped via `lead_messages_sent` PK on (lead_id, day, channel)).
 *
 * Day 6 is the last reminder — codes expire at 7 days, so D6 = "1 day
 * left" rather than D7 = "expired today" which is too late to convert.
 *
 * Auth: Vercel Cron injects `Authorization: Bearer $CRON_SECRET`.
 * External callers can use `?secret=$BLOG_GENERATE_SECRET` (matches the
 * pattern in /api/billing/reconcile).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLeadFollowupEmail } from "@/lib/email/send";
import type { RewardType } from "@/lib/redeem";

export const runtime = "nodejs";
export const maxDuration = 60;

type ReminderDay = 1 | 3 | 6;
const REMINDER_DAYS: ReminderDay[] = [1, 3, 6];

const REWARD_LABEL: Record<RewardType, string> = {
  monthly_1m: "สมาชิกรายเดือน 1 เดือน",
  bundle_10q: "Bundle 10 ข้อ",
};

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

type LeadRow = {
  id: string;
  email: string;
  name: string | null;
  reward_choice: RewardType | null;
  created_at: string;
};

type CodeRow = {
  code: string;
  reward_type: RewardType;
  expires_at: string;
};

type Summary = Record<`d${ReminderDay}_sent` | `d${ReminderDay}_skipped`, number> & {
  errors: number;
};

async function run(): Promise<Summary> {
  const supabase = createAdminClient();
  const summary: Summary = {
    d1_sent: 0,
    d1_skipped: 0,
    d3_sent: 0,
    d3_skipped: 0,
    d6_sent: 0,
    d6_skipped: 0,
    errors: 0,
  };

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";

  for (const day of REMINDER_DAYS) {
    const upper = new Date(Date.now() - day * 24 * 60 * 60 * 1000).toISOString();
    const lower = new Date(Date.now() - (day + 1) * 24 * 60 * 60 * 1000).toISOString();

    // Leads exactly `day` days old that issued a code and haven't redeemed yet.
    const { data: leads, error: leadsError } = await supabase
      .from("leads")
      .select("id, email, name, reward_choice, created_at")
      .eq("stage", "code_issued")
      .not("email", "is", null)
      .gte("created_at", lower)
      .lt("created_at", upper);

    if (leadsError) {
      console.error("[lead-followup] leads query failed:", leadsError);
      summary.errors++;
      continue;
    }

    for (const lead of (leads ?? []) as LeadRow[]) {
      try {
        // Dedupe: skip if we already emailed this lead for this day.
        const { data: alreadySent } = await supabase
          .from("lead_messages_sent")
          .select("lead_id")
          .eq("lead_id", lead.id)
          .eq("day", day)
          .eq("channel", "email")
          .maybeSingle();
        if (alreadySent) {
          summary[`d${day}_skipped` as const]++;
          continue;
        }

        // Pick the most-recent unredeemed unexpired code for this lead.
        const { data: code } = await supabase
          .from("redeem_codes")
          .select("code, reward_type, expires_at")
          .eq("lead_id", lead.id)
          .is("redeemed_at", null)
          .gt("expires_at", new Date().toISOString())
          .order("created_at", { ascending: false })
          .limit(1)
          .maybeSingle<CodeRow>();

        if (!code) {
          // Already redeemed (different worker beat us) or all codes expired.
          summary[`d${day}_skipped` as const]++;
          continue;
        }

        const expiresAt = new Date(code.expires_at);
        const daysRemaining = Math.max(
          0,
          Math.ceil((expiresAt.getTime() - Date.now()) / (24 * 60 * 60 * 1000))
        );

        await sendLeadFollowupEmail({
          email: lead.email,
          name: lead.name ?? "คุณหมอ",
          code: code.code,
          rewardLabel: REWARD_LABEL[code.reward_type],
          redeemUrl: `${siteUrl}/redeem/${code.code}`,
          daysRemaining,
          day,
        });

        // Insert AFTER send so a transient send failure doesn't block retry
        // tomorrow. PK conflict means another worker beat us — that's fine.
        const { error: insertError } = await supabase
          .from("lead_messages_sent")
          .insert({ lead_id: lead.id, day, channel: "email" });
        if (insertError && insertError.code !== "23505") {
          console.error("[lead-followup] dedupe insert failed:", insertError);
        }

        summary[`d${day}_sent` as const]++;
      } catch (e) {
        console.error("[lead-followup] failed for lead", lead.id, e);
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
