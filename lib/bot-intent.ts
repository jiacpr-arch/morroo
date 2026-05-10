import { createAdminClient } from "@/lib/supabase/admin";
import { issueRedeemCode } from "@/lib/redeem";
import type { ChatChannelKey } from "@/lib/lead-channel";
import type { BotIntent } from "@/lib/chatbot";

// Stages where the lead has already converted — no point re-issuing a trial.
const CONVERTED_STAGES = new Set(["redeemed", "paid"]);

// Cap how many bot-issued codes one lead can ever request — prevents the same
// user from spamming "ขอโค้ดใหม่" indefinitely after each one expires.
const MAX_CODES_PER_LEAD = 3;

const TRIAL_CAMPAIGN = "bot_intent_trial";

/**
 * When the AI signals [INTENT:trial], either:
 * 1. Resend the lead's currently-active code (if any), so a forgetful user
 *    doesn't burn a fresh code each time they ask;
 * 2. Issue a brand-new code if their previous one(s) have expired or been
 *    redeemed and they're still under the per-lead issuance cap;
 * 3. Politely decline if the lead has already converted (`redeemed`/`paid`)
 *    or has hit the cap.
 *
 * Returns the message text to send to the user, or null if no action.
 */
export async function handleBotIntent(
  leadId: string,
  intent: BotIntent,
  channel: ChatChannelKey
): Promise<string | null> {
  if (intent !== "trial") return null;

  const supabase = createAdminClient();

  const { data: lead, error: lookupError } = await supabase
    .from("leads")
    .select("stage, email")
    .eq("id", leadId)
    .maybeSingle();

  if (lookupError) {
    console.error("[bot-intent] lead lookup failed:", lookupError);
    return null;
  }
  if (!lead) return null;

  // Already converted — silently skip (the bot can still chat normally).
  if (CONVERTED_STAGES.has(lead.stage)) return null;

  // 1. Look for an active (unredeemed, unexpired) trial code already on file.
  const nowIso = new Date().toISOString();
  const { data: activeCode } = await supabase
    .from("redeem_codes")
    .select("code, expires_at")
    .eq("lead_id", leadId)
    .eq("campaign", TRIAL_CAMPAIGN)
    .is("redeemed_at", null)
    .gt("expires_at", nowIso)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (activeCode) {
    return buildResendMessage(activeCode.code as string, activeCode.expires_at as string);
  }

  // 2. No active code — check the abuse cap before issuing a new one.
  const { count: totalIssued } = await supabase
    .from("redeem_codes")
    .select("code", { count: "exact", head: true })
    .eq("lead_id", leadId)
    .eq("campaign", TRIAL_CAMPAIGN);

  if ((totalIssued ?? 0) >= MAX_CODES_PER_LEAD) {
    return buildLimitMessage();
  }

  // 3. Issue a fresh code.
  const source = channel === "facebook" ? "fb_messenger" : "line_oa";
  let newCode: string;
  try {
    const issued = await issueRedeemCode({
      rewardType: "monthly_1m",
      source,
      campaign: TRIAL_CAMPAIGN,
      leadId,
      issuedToEmail: lead.email ?? undefined,
    });
    newCode = issued.code;
  } catch (err) {
    console.error("[bot-intent] issueRedeemCode failed:", err);
    return null;
  }

  const { error: stageError } = await supabase
    .from("leads")
    .update({ stage: "code_issued", updated_at: new Date().toISOString() })
    .eq("id", leadId);

  if (stageError) {
    console.error("[bot-intent] stage update failed:", stageError);
    // Code is already issued — still send it to the user.
  }

  // First-issue vs reissue copy: if this is at least their second code, frame
  // it as "ออกโค้ดใหม่ให้".
  const isReissue = (totalIssued ?? 0) > 0;
  return buildIssueMessage(newCode, isReissue);
}

function buildIssueMessage(code: string, isReissue: boolean): string {
  const intro = isReissue
    ? "พี่ออกโค้ดทดลองใช้รายเดือนฟรี 1 เดือนใหม่ให้น้องเลยครับ 🎁"
    : "🎁 พี่มีโค้ดทดลองใช้ MorRoo รายเดือนฟรี 1 เดือนสำหรับน้องเลย!";
  return [
    intro,
    "",
    `โค้ด: ${code}`,
    "",
    "นำโค้ดไปกรอกที่ morroo.com/register แล้วเริ่มเรียนได้เลยครับ 🩺",
    "(โค้ดหมดอายุใน 7 วัน)",
  ].join("\n");
}

function buildResendMessage(code: string, expiresAtIso: string): string {
  const daysLeft = Math.max(
    0,
    Math.ceil((new Date(expiresAtIso).getTime() - Date.now()) / 86400_000)
  );
  return [
    "โค้ดทดลองใช้ของน้องยังใช้ได้อยู่นะครับ 🩺",
    "",
    `โค้ด: ${code}`,
    "",
    `กรอกที่ morroo.com/register ได้เลย (เหลือ ${daysLeft} วัน)`,
  ].join("\n");
}

function buildLimitMessage(): string {
  return [
    "ขอโทษครับ น้องได้รับโค้ดทดลองใช้ครบโควตาแล้วนะครับ 😅",
    "",
    "ถ้าสนใจสมัครรายเดือน ฿199 หรือรายปี ฿1,490 ดูได้ที่ morroo.com/pricing",
    "หรือทักหา support สำหรับความช่วยเหลือเพิ่มเติมครับ",
  ].join("\n");
}

/**
 * Detect a bare email address in a chat message.
 * Returns the normalised email string, or null if the message is not an email.
 */
export function detectEmail(message: string): string | null {
  const trimmed = message.trim();
  // Only treat the message as an email when the WHOLE thing is an email address.
  if (/^[\w.+%-]+@[\w.-]+\.[a-z]{2,}$/i.test(trimmed)) {
    return trimmed.toLowerCase();
  }
  return null;
}

/**
 * If the user sent a bare email address, persist it on their lead row and
 * return a brief acknowledgement to send back. Returns null if not an email.
 */
export async function handleEmailCapture(
  leadId: string | null,
  message: string
): Promise<string | null> {
  const email = detectEmail(message);
  if (!email || !leadId) return null;

  const supabase = createAdminClient();
  const { error } = await supabase
    .from("leads")
    .update({ email, updated_at: new Date().toISOString() })
    .eq("id", leadId);

  if (error) {
    console.error("[bot-intent] email capture failed:", error);
    return null;
  }

  return "บันทึกอีเมลแล้วนะครับ 📧 จะส่งข้อมูลและโปรโมชั่นให้น้องทางอีเมลด้วยครับ!";
}
