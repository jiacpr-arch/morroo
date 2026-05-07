import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import {
  generateChatbotReply,
  trimHistory,
  type ChatMessage,
} from "@/lib/chatbot";

export const runtime = "nodejs";
export const maxDuration = 60;

const RATE_LIMIT_PER_HOUR = 30;
const MAX_USER_MESSAGE_LEN = 2000;

export async function POST(request: NextRequest) {
  const body = (await request.json().catch(() => null)) as {
    message?: string;
    sessionId?: string;
  } | null;

  if (!body || typeof body.message !== "string" || typeof body.sessionId !== "string") {
    return NextResponse.json({ error: "Invalid body" }, { status: 400 });
  }

  const message = body.message.trim();
  if (!message) {
    return NextResponse.json({ error: "Empty message" }, { status: 400 });
  }
  if (message.length > MAX_USER_MESSAGE_LEN) {
    return NextResponse.json({ error: "Message too long" }, { status: 400 });
  }

  // sessionId is a client-generated uuid stored in localStorage. We pair it with
  // the auth user id when available so logged-in users get continuity across devices.
  const ssrClient = await createClient();
  const { data: { user } } = await ssrClient.auth.getUser();

  const channelUserId = user?.id ?? body.sessionId;
  if (!channelUserId) {
    return NextResponse.json({ error: "Missing session" }, { status: 400 });
  }

  const admin = createAdminClient();

  // Cheap per-conversation rate limit: count user messages in last hour.
  const sinceIso = new Date(Date.now() - 3600_000).toISOString();
  const { count: recentCount } = await admin
    .from("chat_messages")
    .select("id", { count: "exact", head: true })
    .eq("channel", "web")
    .eq("channel_user_id", channelUserId)
    .eq("role", "user")
    .gte("created_at", sinceIso);

  if ((recentCount ?? 0) >= RATE_LIMIT_PER_HOUR) {
    return NextResponse.json(
      { error: "ส่งข้อความเยอะเกินไปแล้วในชั่วโมงนี้ ลองใหม่อีกครั้งในอีกสักครู่" },
      { status: 429 }
    );
  }

  // Load recent history for this conversation (chronological).
  const { data: rows } = await admin
    .from("chat_messages")
    .select("role, content")
    .eq("channel", "web")
    .eq("channel_user_id", channelUserId)
    .order("created_at", { ascending: false })
    .limit(20);

  const history: ChatMessage[] = (rows ?? [])
    .reverse()
    .map((r) => ({ role: r.role as "user" | "assistant", content: r.content }));

  history.push({ role: "user", content: message });

  const result = await generateChatbotReply(trimHistory(history), "web");

  if (!result.ok) {
    console.error("[api/chat] chatbot failed:", result.error);
    return NextResponse.json(
      { error: "ขอโทษครับ ขณะนี้ระบบมีปัญหาชั่วคราว ลองใหม่อีกครั้งนะครับ" },
      { status: 500 }
    );
  }

  // Persist both turns. Use service role; RLS is locked down.
  await admin.from("chat_messages").insert([
    {
      channel: "web",
      channel_user_id: channelUserId,
      user_id: user?.id ?? null,
      role: "user",
      content: message,
    },
    {
      channel: "web",
      channel_user_id: channelUserId,
      user_id: user?.id ?? null,
      role: "assistant",
      content: result.reply,
    },
  ]);

  return NextResponse.json({ reply: result.reply });
}
