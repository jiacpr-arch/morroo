import { createAdminClient } from "@/lib/supabase/admin";
import { issueRedeemCode } from "@/lib/redeem";
import type { ChatChannelKey } from "@/lib/lead-channel";
import type { BotIntent } from "@/lib/chatbot";

const ELIGIBLE_STAGES = new Set(["new", "contacted"]);

/**
 * When the AI signals [INTENT:trial], issue a free monthly redeem code for the
 * lead and advance their stage to 'code_issued'. Returns the follow-up message
 * text to send, or null if no action was taken (duplicate, DB error, etc.).
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

  // Skip leads that already received a code or are further along the funnel.
  if (!lead || !ELIGIBLE_STAGES.has(lead.stage)) return null;

  const source = channel === "facebook" ? "fb_messenger" : "line_oa";

  let code: string;
  try {
    const issued = await issueRedeemCode({
      rewardType: "monthly_1m",
      source,
      campaign: "bot_intent_trial",
      leadId,
      issuedToEmail: lead.email ?? undefined,
    });
    code = issued.code;
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

  return [
    "🎁 พี่มีโค้ดทดลองใช้ MorRoo รายเดือนฟรี 1 เดือนสำหรับน้องเลย!",
    "",
    `โค้ด: ${code}`,
    "",
    "นำโค้ดไปกรอกที่ morroo.com/register แล้วเริ่มเรียนได้เลยครับ 🩺",
    "(โค้ดหมดอายุใน 7 วัน)",
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
