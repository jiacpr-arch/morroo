/**
 * Webhook retry cron — reprocesses LINE/FB events that failed on first attempt.
 *
 * Schedule: every 10 minutes (see vercel.json)
 * Auth: Vercel Cron Authorization header or ?secret= query param
 */

import { NextResponse } from "next/server";
import { claimPendingWebhooks, markWebhookDone, markWebhookFailed } from "@/lib/webhook-queue";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, type LineMessage } from "@/lib/line";
import { generateChatbotReply, trimHistory, type ChatMessage } from "@/lib/chatbot";
import { buildChatbotCard } from "@/lib/line-flex-templates";
import { getOrCreateLeadFromChannel } from "@/lib/lead-channel";
import { handleBotIntent, handleEmailCapture } from "@/lib/bot-intent";
import { sendFbMessage, sendFbTyping } from "@/lib/facebook-messenger";
import type { WebhookEvent } from "@/lib/webhook-queue";

export const runtime = "nodejs";
export const maxDuration = 60;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return auth === `Bearer ${process.env.CRON_SECRET}`;
}

export async function POST(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const events = await claimPendingWebhooks(20);
  const summary = { processed: 0, done: 0, failed: 0 };

  for (const event of events) {
    summary.processed++;
    try {
      if (event.channel === "line") {
        await retryLineEvent(event);
      } else if (event.channel === "facebook") {
        await retryFacebookEvent(event);
      }
      await markWebhookDone(event.id);
      summary.done++;
    } catch (err) {
      console.error(`[webhook-retry] ${event.channel} event ${event.id} failed:`, err);
      await markWebhookFailed(event.id, String(err));
      summary.failed++;
    }
  }

  return NextResponse.json({ ok: true, ...summary });
}

// ─── LINE retry ──────────────────────────────────────────────────────────────

type LineEventPayload = {
  type: string;
  source?: { userId?: string };
  message?: { type: string; text?: string };
};

async function retryLineEvent(event: WebhookEvent): Promise<void> {
  const payload = event.payload as { events?: LineEventPayload[] };
  const supabase = createAdminClient();

  for (const lineEvent of payload.events ?? []) {
    const lineUserId = lineEvent.source?.userId;
    if (!lineUserId) continue;
    if (lineEvent.type !== "message" || lineEvent.message?.type !== "text") continue;

    const rawText = (lineEvent.message.text ?? "").trim();
    if (!rawText || rawText.toUpperCase().startsWith("MORROO-")) continue;

    await handleLineChatbot(supabase, lineUserId, rawText);
  }
}

async function handleLineChatbot(
  supabase: ReturnType<typeof createAdminClient>,
  lineUserId: string,
  userMessage: string
): Promise<void> {
  const leadId = await getOrCreateLeadFromChannel({ channel: "line", channelUserId: lineUserId });

  const emailAck = await handleEmailCapture(leadId, userMessage);
  if (emailAck) {
    await sendLineMessage(lineUserId, [{ type: "text", text: emailAck }]);
    return;
  }

  const { data: rows } = await supabase
    .from("chat_messages")
    .select("role, content")
    .eq("channel", "line")
    .eq("channel_user_id", lineUserId)
    .order("created_at", { ascending: false })
    .limit(20);

  const history: ChatMessage[] = (rows ?? [])
    .reverse()
    .map((r) => ({ role: r.role as "user" | "assistant", content: r.content }));
  history.push({ role: "user", content: userMessage });

  const result = await generateChatbotReply(trimHistory(history), "line");
  const replyText = result.ok
    ? result.reply
    : "ขอโทษครับ ขณะนี้ระบบมีปัญหาชั่วคราว ลองใหม่อีกครั้งนะครับ 🙏";

  const messages: LineMessage[] = [{ type: "text", text: replyText }];
  if (result.ok && result.card) messages.push(buildChatbotCard(result.card));

  const intentMsg =
    result.ok && result.intent && leadId
      ? await handleBotIntent(leadId, result.intent, "line")
      : null;
  if (intentMsg) messages.push({ type: "text", text: intentMsg });

  await sendLineMessage(lineUserId, messages);
}

// ─── Facebook retry ───────────────────────────────────────────────────────────

type FbMessagingEvent = {
  sender?: { id?: string };
  message?: { text?: string; is_echo?: boolean };
};

async function retryFacebookEvent(event: WebhookEvent): Promise<void> {
  const payload = event.payload as { entry?: Array<{ messaging?: FbMessagingEvent[] }> };
  const supabase = createAdminClient();

  for (const entry of payload.entry ?? []) {
    for (const msg of entry.messaging ?? []) {
      const psid = msg.sender?.id;
      const text = msg.message?.text?.trim();
      if (!psid || !text || msg.message?.is_echo) continue;
      await handleFbChatbot(supabase, psid, text);
    }
  }
}

async function handleFbChatbot(
  supabase: ReturnType<typeof createAdminClient>,
  psid: string,
  userMessage: string
): Promise<void> {
  const leadId = await getOrCreateLeadFromChannel({ channel: "facebook", channelUserId: psid });

  const emailAck = await handleEmailCapture(leadId, userMessage);
  if (emailAck) {
    await sendFbTyping(psid, false);
    await sendFbMessage(psid, emailAck);
    return;
  }

  const { data: rows } = await supabase
    .from("chat_messages")
    .select("role, content")
    .eq("channel", "facebook")
    .eq("channel_user_id", psid)
    .order("created_at", { ascending: false })
    .limit(20);

  const history: ChatMessage[] = (rows ?? [])
    .reverse()
    .map((r) => ({ role: r.role as "user" | "assistant", content: r.content }));
  history.push({ role: "user", content: userMessage });

  const result = await generateChatbotReply(trimHistory(history), "facebook");
  const replyText = result.ok
    ? result.reply
    : "ขอโทษครับ ขณะนี้ระบบมีปัญหาชั่วคราว ลองใหม่อีกครั้งนะครับ 🙏";

  const intentMsg =
    result.ok && result.intent && leadId
      ? await handleBotIntent(leadId, result.intent, "facebook")
      : null;

  await sendFbTyping(psid, false);
  await sendFbMessage(psid, intentMsg ? `${replyText}\n\n${intentMsg}` : replyText);
}
