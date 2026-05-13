import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  sendFbMessage,
  sendFbReadReceipt,
  sendFbTyping,
  takeThreadControl,
  verifyFbSignature,
} from "@/lib/facebook-messenger";
import {
  generateChatbotReply,
  trimHistory,
  type ChatMessage,
} from "@/lib/chatbot";
import { getOrCreateLeadFromChannel } from "@/lib/lead-channel";
import { handleBotIntent, handleEmailCapture } from "@/lib/bot-intent";

export const runtime = "nodejs";
export const maxDuration = 60;

const RATE_LIMIT_PER_HOUR = 30;

/**
 * GET = subscription verification handshake.
 * Meta calls this once when you click "Verify" on the webhook config.
 * Echoes hub.challenge if hub.verify_token matches our env var.
 */
export async function GET(request: NextRequest) {
  const url = new URL(request.url);
  const mode = url.searchParams.get("hub.mode");
  const token = url.searchParams.get("hub.verify_token");
  const challenge = url.searchParams.get("hub.challenge");

  const expected = process.env.FACEBOOK_VERIFY_TOKEN;
  if (!expected) {
    console.error("[fb-webhook] FACEBOOK_VERIFY_TOKEN not set");
    return NextResponse.json({ error: "Server not configured" }, { status: 500 });
  }

  if (mode === "subscribe" && token === expected && challenge) {
    return new NextResponse(challenge, { status: 200 });
  }

  return NextResponse.json({ error: "Forbidden" }, { status: 403 });
}

type FbReferral = {
  // ref param set on the ad (m.me link param). May be empty for some CTM ads.
  ref?: string;
  // ADS = clicked a Click-to-Messenger ad; SHORTLINK = m.me link; CUSTOMER_CHAT_PLUGIN; etc.
  source?: string;
  type?: string;
  ad_id?: string;
};

type FbMessagingEvent = {
  sender?: { id?: string };
  recipient?: { id?: string };
  timestamp?: number;
  message?: {
    mid?: string;
    text?: string;
    is_echo?: boolean; // true when the message is from the page itself — ignore
    quick_reply?: { payload?: string };
  };
  postback?: {
    mid?: string;
    title?: string;
    payload?: string;
    referral?: FbReferral;
  };
  referral?: FbReferral;
};

type FbEntry = {
  id?: string;
  time?: number;
  messaging?: FbMessagingEvent[];
  /** Mirrored events for apps that are NOT the primary thread receiver.
   *  Common for Click-to-Messenger ads when Page Inbox is the primary receiver. */
  standby?: FbMessagingEvent[];
};

type FbWebhookBody = {
  object?: string;
  entry?: FbEntry[];
};

/** Extract the best human-readable user input from a webhook event:
 *  - plain text message
 *  - postback title (button label the user saw)
 *  - postback payload (only if title is missing) */
function extractUserInput(event: FbMessagingEvent): string | null {
  const text = event.message?.text?.trim();
  if (text) return text;

  const postbackTitle = event.postback?.title?.trim();
  if (postbackTitle) return postbackTitle;

  // Fallback for postbacks without a title (rare — e.g. programmatic m.me links).
  // Skip payloads that look like internal IDs (UPPER_SNAKE_CASE).
  const payload = event.postback?.payload?.trim();
  if (payload && !/^[A-Z0-9_]+$/.test(payload)) return payload;

  return null;
}

/**
 * POST = message events from users. Verify signature, then for each text message
 * route to the shared chatbot brain and reply via Send API.
 */
export async function POST(request: NextRequest) {
  const rawBody = await request.text();
  const signature = request.headers.get("x-hub-signature-256");

  if (!verifyFbSignature(rawBody, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const body = JSON.parse(rawBody) as FbWebhookBody;
  if (body.object !== "page") {
    return NextResponse.json({ ok: true });
  }

  const supabase = createAdminClient();

  for (const entry of body.entry ?? []) {
    for (const event of entry.messaging ?? []) {
      await handleMessagingEvent(supabase, event);
    }

    // Standby channel — Page Inbox (or another app) is currently the primary
    // receiver. Common for CTM ads when handover routing isn't configured.
    // We only try to take control for ad-initiated threads to avoid hijacking
    // conversations a human agent is handling via Page Inbox.
    for (const event of entry.standby ?? []) {
      await handleStandbyEvent(supabase, event);
    }
  }

  // Always 200 so Meta doesn't retry.
  return NextResponse.json({ ok: true });
}

async function handleMessagingEvent(
  supabase: ReturnType<typeof createAdminClient>,
  event: FbMessagingEvent
): Promise<void> {
  const senderPsid = event.sender?.id;
  if (!senderPsid) return;

  // Echo of our own outbound message — ignore to avoid reply loops.
  if (event.message?.is_echo) return;

  // CTM ad click without an accompanying text/postback. Log it so we know the
  // ad fired; the user's first typed message will arrive as a separate event.
  if (event.referral && !event.message && !event.postback) {
    console.log(
      `[fb-webhook] ad referral psid=${senderPsid} source=${event.referral.source} ` +
        `ad_id=${event.referral.ad_id ?? "?"} ref=${event.referral.ref ?? "?"}`
    );
    return;
  }

  const userInput = extractUserInput(event);
  if (!userInput) return;

  await handleChatbotReply(supabase, senderPsid, userInput);
}

async function handleStandbyEvent(
  supabase: ReturnType<typeof createAdminClient>,
  event: FbMessagingEvent
): Promise<void> {
  const senderPsid = event.sender?.id;
  if (!senderPsid) return;

  // Only attempt to claim threads that originated from a Click-to-Messenger ad.
  // Other standby events are intentionally being handled by another receiver
  // (human agent via Page Inbox, another bot app) — don't hijack those.
  const referral = event.referral ?? event.postback?.referral;
  const isAdInitiated = referral?.source === "ADS";

  if (!isAdInitiated) {
    console.log(
      `[fb-webhook] standby ignored (not ad-initiated) psid=${senderPsid} ` +
        `hasMessage=${!!event.message} hasPostback=${!!event.postback} hasReferral=${!!referral}`
    );
    return;
  }

  console.log(
    `[fb-webhook] standby ad-initiated, taking thread control psid=${senderPsid} ` +
      `ad_id=${referral.ad_id ?? "?"}`
  );

  const claimed = await takeThreadControl(senderPsid);
  if (!claimed) {
    // Couldn't take control — the Page may not have configured handover protocol
    // with our app as a secondary receiver, or the primary receiver isn't releasing.
    // The customer won't get a bot reply for this conversation; surface that in logs.
    console.error(
      `[fb-webhook] take_thread_control failed psid=${senderPsid} — check App Dashboard → ` +
        `Messenger → Settings → Advanced Messaging Features → Handover Protocol`
    );
    return;
  }

  // Take effect is async on Meta's side — subsequent user messages should arrive
  // as regular `messaging` events. If the standby event itself included content,
  // try to respond now so the user isn't kept waiting for their next message.
  const userInput = extractUserInput(event);
  if (userInput) {
    await handleChatbotReply(supabase, senderPsid, userInput);
  }
}

async function handleChatbotReply(
  supabase: ReturnType<typeof createAdminClient>,
  psid: string,
  userMessage: string
): Promise<void> {
  // Show "seen" + typing while we generate so the user knows we got the message.
  await Promise.all([sendFbReadReceipt(psid), sendFbTyping(psid, true)]);

  // Resolve lead early — needed for email capture and intent handling.
  const leadId = await getOrCreateLeadFromChannel({
    channel: "facebook",
    channelUserId: psid,
  });

  // If the user sent a bare email address, save it and acknowledge.
  const emailAck = await handleEmailCapture(leadId, userMessage);
  if (emailAck) {
    await sendFbTyping(psid, false);
    await sendFbMessage(psid, emailAck);
    await supabase.from("chat_messages").insert([
      { channel: "facebook", channel_user_id: psid, lead_id: leadId, role: "user", content: userMessage },
      { channel: "facebook", channel_user_id: psid, lead_id: leadId, role: "assistant", content: emailAck },
    ]);
    return;
  }

  const sinceIso = new Date(Date.now() - 3600_000).toISOString();
  const { count: recentCount } = await supabase
    .from("chat_messages")
    .select("id", { count: "exact", head: true })
    .eq("channel", "facebook")
    .eq("channel_user_id", psid)
    .eq("role", "user")
    .gte("created_at", sinceIso);

  if ((recentCount ?? 0) >= RATE_LIMIT_PER_HOUR) {
    await sendFbTyping(psid, false);
    await sendFbMessage(
      psid,
      "ขอโทษครับ น้องส่งข้อความเยอะเกินไปในชั่วโมงนี้ 😅 ลองใหม่อีกที่หลังนะครับ"
    );
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

  // Issue a free trial code when the AI detected purchase intent.
  const intentMsg =
    result.ok && result.intent && leadId
      ? await handleBotIntent(leadId, result.intent, "facebook")
      : null;

  await sendFbTyping(psid, false);
  await sendFbMessage(psid, replyText);
  if (intentMsg) {
    await sendFbMessage(psid, intentMsg);
  }

  await supabase.from("chat_messages").insert([
    {
      channel: "facebook",
      channel_user_id: psid,
      lead_id: leadId,
      role: "user",
      content: userMessage,
    },
    {
      channel: "facebook",
      channel_user_id: psid,
      lead_id: leadId,
      role: "assistant",
      content: intentMsg ? `${replyText}\n\n${intentMsg}` : replyText,
    },
  ]);
}
