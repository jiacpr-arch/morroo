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
 * Two extra legs for chat-issued trial codes (`bot_intent_trial`):
 * - Auto-activate: the LINE OA userId and the LINE-login userId are the same,
 *   so when a lead has already registered with LINE we apply the trial to
 *   that account directly and tell them, instead of nagging about a code.
 * - Expired nudge (D8): the day after a code expires, invite them to ask for
 *   a new one (handleBotIntent re-issues up to a cap) or look at pricing.
 *
 * Auth: Vercel Cron injects `Authorization: Bearer $CRON_SECRET`.
 * External callers can use `?secret=$BLOG_GENERATE_SECRET` (matches the
 * pattern in /api/billing/reconcile).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLeadFollowupEmail } from "@/lib/email/send";
import { sendLineMessage, checkLineQuota } from "@/lib/line";
import { sendFbMessage } from "@/lib/facebook-messenger";
import { redeemCode, type RewardType } from "@/lib/redeem";

export const runtime = "nodejs";
export const maxDuration = 60;

type ReminderDay = 1 | 3 | 6;
const REMINDER_DAYS: ReminderDay[] = [1, 3, 6];

const REWARD_LABEL: Record<RewardType, string> = {
  monthly_1m: "ทดลองใช้ฟรี 7 วัน",
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

type LeadDmRow = {
  id: string;
  fb_psid: string | null;
  line_user_id: string | null;
  name: string | null;
};

type CodeDmRow = {
  code: string;
  reward_type: RewardType;
  expires_at: string;
  lead_id: string | null;
};

type PendingCodeRow = { code: string; lead_id: string };
type LineLeadRow = { id: string; line_user_id: string };
type ProfileRow = {
  id: string;
  line_user_id: string;
  membership_type: string | null;
  membership_expires_at: string | null;
};

const TRIAL_CAMPAIGN = "bot_intent_trial";
/** Dedupe "day" slots for the extra legs (lead_messages_sent PK is lead/day/channel). */
const DAY_ACTIVATED = 0;
const DAY_EXPIRED = 8;

function hasActivePaidMembership(p: ProfileRow, now: Date): boolean {
  if (!p.membership_type || p.membership_type === "free") return false;
  return !!p.membership_expires_at && new Date(p.membership_expires_at) > now;
}

const ACTIVATED_MESSAGE = [
  "🎉 พี่เปิดสิทธิ์ทดลองใช้ MorRoo ฟรี 7 วันให้น้องแล้วครับ (บัญชี LINE เดียวกับที่น้องสมัครไว้)",
  "",
  "เข้าใช้ได้เลยที่ https://www.morroo.com/dashboard",
  "ลอง MCQ 3,000+ ข้อ, MEQ และ Long Case ได้ไม่จำกัดตลอด 7 วันนี้เลย 🩺",
].join("\n");

const EXPIRED_MESSAGE = [
  "โค้ดทดลองใช้ของน้องหมดอายุแล้วครับ 😢",
  "",
  "ถ้ายังสนใจ ดูแพ็กเกจรายเดือน ฿199 ได้ที่ https://www.morroo.com/pricing",
  "หรือเริ่มใช้แบบฟรีได้เลย (MCQ 5 ข้อ/วิชา, Long Case 1 เคส/เดือน)",
].join("\n");

const DM_MESSAGES: Record<
  ReminderDay,
  (code: string, daysRemaining: number, redeemUrl: string) => string
> = {
  1: (code, days, url) =>
    `สวัสดีครับ! โค้ดทดลองใช้ MorRoo ฟรี 7 วันของน้องยังรอน้องอยู่นะครับ 🩺\n\nโค้ด: ${code}\n\nกดลิงก์นี้แล้ว login ด้วย LINE รับสิทธิ์ได้ทันที (เหลือ ${days} วัน)\n${url}`,
  3: (code, days, url) =>
    `น้องยังไม่ได้ใช้โค้ดเลยนะครับ! ยังมีเวลาอีก ${days} วัน 😊\n\nโค้ด: ${code}\n\nกดลิงก์เดียวจบ รับสิทธิ์ทดลองฟรี 7 วันเลยครับ\n${url}`,
  6: (code, _days, url) =>
    `⚠️ โค้ดของน้องจะหมดอายุพรุ่งนี้แล้ว! อย่าพลาดนะครับ\n\nโค้ด: ${code}\n\nกดรับสิทธิ์ก่อนหมดอายุ:\n${url}`,
};

type Summary = Record<`d${ReminderDay}_sent` | `d${ReminderDay}_skipped`, number> & {
  dm_sent: number;
  dm_skipped: number;
  activated: number;
  activate_skipped: number;
  expired_sent: number;
  expired_skipped: number;
  errors: number;
};

async function run(): Promise<Summary & { lineSkippedQuota?: boolean }> {
  const lineQuota = await checkLineQuota();
  const supabase = createAdminClient();
  const summary: Summary & { lineSkippedQuota?: boolean } = {
    d1_sent: 0,
    d1_skipped: 0,
    d3_sent: 0,
    d3_skipped: 0,
    d6_sent: 0,
    d6_skipped: 0,
    dm_sent: 0,
    dm_skipped: 0,
    activated: 0,
    activate_skipped: 0,
    expired_sent: 0,
    expired_skipped: 0,
    errors: 0,
  };

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  const now = new Date();
  const nowIso = now.toISOString();

  // ─── Auto-activate: lead already registered with the same LINE account ──
  // Runs first so an activated lead is excluded from today's reminders
  // (redeemCode marks the code redeemed and the lead stage `redeemed`).
  try {
    const { data: pendingRaw, error: pendingError } = await supabase
      .from("redeem_codes")
      .select("code, lead_id")
      .eq("campaign", TRIAL_CAMPAIGN)
      .is("redeemed_at", null)
      .gt("expires_at", nowIso)
      .not("lead_id", "is", null)
      .order("created_at", { ascending: false });
    if (pendingError) throw pendingError;

    const pending = (pendingRaw ?? []) as PendingCodeRow[];
    if (pending.length > 0) {
      const leadIds = [...new Set(pending.map((c) => c.lead_id))];
      const { data: leadsRaw, error: leadsError } = await supabase
        .from("leads")
        .select("id, line_user_id")
        .in("id", leadIds)
        .eq("stage", "code_issued")
        .not("line_user_id", "is", null);
      if (leadsError) throw leadsError;

      const leadById = new Map(
        ((leadsRaw ?? []) as LineLeadRow[]).map((l) => [l.id, l])
      );
      const lineIds = [...leadById.values()].map((l) => l.line_user_id);

      if (lineIds.length > 0) {
        const { data: profilesRaw, error: profilesError } = await supabase
          .from("profiles")
          .select("id, line_user_id, membership_type, membership_expires_at")
          .in("line_user_id", lineIds);
        if (profilesError) throw profilesError;

        const profileByLine = new Map(
          ((profilesRaw ?? []) as ProfileRow[]).map((p) => [p.line_user_id, p])
        );
        const handled = new Set<string>();

        for (const codeRow of pending) {
          if (handled.has(codeRow.lead_id)) continue; // newest code per lead only
          const lead = leadById.get(codeRow.lead_id);
          if (!lead) continue;
          const profile = profileByLine.get(lead.line_user_id);
          if (!profile) continue; // not registered yet → reminder legs handle it
          handled.add(codeRow.lead_id);

          // Already a paying member — don't stack a free month on top.
          if (hasActivePaidMembership(profile, now)) {
            summary.activate_skipped++;
            continue;
          }

          try {
            const result = await redeemCode(codeRow.code, profile.id);
            if (!result.ok) {
              summary.activate_skipped++;
              continue;
            }
            await sendLineMessage(lead.line_user_id, [
              { type: "text", text: ACTIVATED_MESSAGE },
            ]);
            const { error: insertError } = await supabase
              .from("lead_messages_sent")
              .insert({ lead_id: lead.id, day: DAY_ACTIVATED, channel: "line" });
            if (insertError && insertError.code !== "23505") {
              console.error("[lead-followup] activate audit insert failed:", insertError);
            }
            summary.activated++;
          } catch (e) {
            console.error("[lead-followup] auto-activate failed for lead", lead.id, e);
            summary.errors++;
          }
        }
      }
    }
  } catch (e) {
    console.error("[lead-followup] auto-activate query failed:", e);
    summary.errors++;
  }

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

  // ─── DM reminders (LINE / Messenger) ─────────────────────────────────────
  // Anchored on redeem_codes.created_at so timing is accurate regardless of
  // how many times the lead row's updated_at was touched by the chatbot.

  for (const day of REMINDER_DAYS) {
    const upper = new Date(Date.now() - day * 24 * 60 * 60 * 1000).toISOString();
    const lower = new Date(Date.now() - (day + 1) * 24 * 60 * 60 * 1000).toISOString();

    const { data: codes, error: codesError } = await supabase
      .from("redeem_codes")
      .select("code, reward_type, expires_at, lead_id")
      .eq("campaign", TRIAL_CAMPAIGN)
      .is("redeemed_at", null)
      .gt("expires_at", nowIso)
      .not("lead_id", "is", null)
      .gte("created_at", lower)
      .lt("created_at", upper);

    if (codesError) {
      console.error("[lead-followup] dm codes query failed:", codesError);
      summary.errors++;
      continue;
    }
    if (!codes?.length) continue;

    const leadIds = (codes as CodeDmRow[]).map((c) => c.lead_id!);

    const { data: leads, error: leadsError } = await supabase
      .from("leads")
      .select("id, fb_psid, line_user_id, name")
      .in("id", leadIds)
      .eq("stage", "code_issued");

    if (leadsError) {
      console.error("[lead-followup] dm leads query failed:", leadsError);
      summary.errors++;
      continue;
    }

    const leadMap = new Map(
      ((leads ?? []) as LeadDmRow[]).map((l) => [l.id, l])
    );

    for (const codeRow of codes as CodeDmRow[]) {
      const lead = leadMap.get(codeRow.lead_id!);
      if (!lead) continue;

      // Prefer LINE; fall back to Messenger.
      const channel: "line" | "messenger" = lead.line_user_id
        ? "line"
        : "messenger";
      const channelId = lead.line_user_id ?? lead.fb_psid;
      if (!channelId) continue;

      try {
        const { data: alreadySent } = await supabase
          .from("lead_messages_sent")
          .select("lead_id")
          .eq("lead_id", lead.id)
          .eq("day", day)
          .eq("channel", channel)
          .maybeSingle();

        if (alreadySent) {
          summary.dm_skipped++;
          continue;
        }

        const expiresAt = new Date(codeRow.expires_at);
        const daysRemaining = Math.max(
          0,
          Math.ceil((expiresAt.getTime() - Date.now()) / 86400_000)
        );
        const text = DM_MESSAGES[day](
          codeRow.code,
          daysRemaining,
          `${siteUrl}/redeem/${codeRow.code}`
        );

        if (channel === "line" && lineQuota.throttled) {
          summary.dm_skipped++;
          summary.lineSkippedQuota = true;
          continue;
        }

        if (channel === "line") {
          await sendLineMessage(channelId, [{ type: "text", text }]);
        } else {
          await sendFbMessage(channelId, text);
        }

        const { error: insertError } = await supabase
          .from("lead_messages_sent")
          .insert({ lead_id: lead.id, day, channel });
        if (insertError && insertError.code !== "23505") {
          console.error("[lead-followup] dm dedupe insert failed:", insertError);
        }

        summary.dm_sent++;
      } catch (e) {
        console.error("[lead-followup] dm failed for lead", lead.id, e);
        summary.errors++;
      }
    }
  }

  // ─── Expired nudge (D8): the day after the code lapsed ───────────────────
  try {
    const expiredLower = new Date(Date.now() - 86400_000).toISOString();
    const { data: expiredRaw, error: expiredError } = await supabase
      .from("redeem_codes")
      .select("code, lead_id")
      .eq("campaign", TRIAL_CAMPAIGN)
      .is("redeemed_at", null)
      .gte("expires_at", expiredLower)
      .lt("expires_at", nowIso)
      .not("lead_id", "is", null);
    if (expiredError) throw expiredError;

    const expired = (expiredRaw ?? []) as PendingCodeRow[];
    if (expired.length > 0) {
      const leadIds = [...new Set(expired.map((c) => c.lead_id))];
      const { data: leadsRaw, error: leadsError } = await supabase
        .from("leads")
        .select("id, fb_psid, line_user_id, name")
        .in("id", leadIds)
        .eq("stage", "code_issued");
      if (leadsError) throw leadsError;

      // A lead that already asked for (and got) a fresh code shouldn't be told
      // their code expired.
      const { data: stillActiveRaw } = await supabase
        .from("redeem_codes")
        .select("lead_id")
        .in("lead_id", leadIds)
        .is("redeemed_at", null)
        .gt("expires_at", nowIso);
      const hasActiveCode = new Set(
        ((stillActiveRaw ?? []) as { lead_id: string }[]).map((r) => r.lead_id)
      );

      for (const lead of (leadsRaw ?? []) as LeadDmRow[]) {
        if (hasActiveCode.has(lead.id)) {
          summary.expired_skipped++;
          continue;
        }
        const channel: "line" | "messenger" = lead.line_user_id ? "line" : "messenger";
        const channelId = lead.line_user_id ?? lead.fb_psid;
        if (!channelId) continue;

        try {
          const { data: alreadySent } = await supabase
            .from("lead_messages_sent")
            .select("lead_id")
            .eq("lead_id", lead.id)
            .eq("day", DAY_EXPIRED)
            .eq("channel", channel)
            .maybeSingle();
          if (alreadySent) {
            summary.expired_skipped++;
            continue;
          }

          if (channel === "line" && lineQuota.throttled) {
            summary.expired_skipped++;
            summary.lineSkippedQuota = true;
            continue;
          }

          if (channel === "line") {
            await sendLineMessage(channelId, [{ type: "text", text: EXPIRED_MESSAGE }]);
          } else {
            await sendFbMessage(channelId, EXPIRED_MESSAGE);
          }

          const { error: insertError } = await supabase
            .from("lead_messages_sent")
            .insert({ lead_id: lead.id, day: DAY_EXPIRED, channel });
          if (insertError && insertError.code !== "23505") {
            console.error("[lead-followup] expired dedupe insert failed:", insertError);
          }
          summary.expired_sent++;
        } catch (e) {
          console.error("[lead-followup] expired nudge failed for lead", lead.id, e);
          summary.errors++;
        }
      }
    }
  } catch (e) {
    console.error("[lead-followup] expired-nudge query failed:", e);
    summary.errors++;
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
