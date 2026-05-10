import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  sendFbMessage,
  sendFbReadReceipt,
  sendFbTyping,
  verifyFbSignature,
} from "@/lib/facebook-messenger";
import {
  generateChatbotReply,
  trimHistory,
  type ChatMessage,
} from "@/lib/chatbot";
import { getOrCreateLeadFromChannel } from "@/lib/lead-channel";

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

type FbMessagingEvent = {
  sender?: { id?: string };
  recipient?: { id?: string };
  message?: {
    mid?: string;
    text?: string;
    is_echo?: boolean; // true when the message is from the page itself — ignore
  };
};

type FbEntry = {
  id?: string;
  time?: number;
  messaging?: FbMessagingEvent[];
};

type FbWebhookBody = {
  object?: string;
  entry?: FbEntry[];
};

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
      const senderPsid = event.sender?.id;
      const text = event.message?.text?.trim();

      // Ignore: messages without text (stickers/attachments), echoes from our own page,
      // delivery/read receipts that arrive without a `message` field.
      if (!senderPsid || !text || event.message?.is_echo) continue;

      await handleChatbotReply(supabase, senderPsid, text);
    }
  }

  // Always 200 so Meta doesn't retry.
  return NextResponse.json({ ok: true });
}

async function handleChatbotReply(
  supabase: ReturnType<typeof createAdminClient>,
  psid: string,
  userMessage: string
): Promise<void> {
  // Show "seen" + typing while we generate so the user knows we got the message.
  await Promise.all([sendFbReadReceipt(psid), sendFbTyping(psid, true)]);

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

  await sendFbTyping(psid, false);
  await sendFbMessage(psid, replyText);

  const leadId = await getOrCreateLeadFromChannel({
    channel: "facebook",
    channelUserId: psid,
  });

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
      content: replyText,
    },
  ]);
}
