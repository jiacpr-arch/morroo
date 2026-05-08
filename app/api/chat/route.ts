import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import {
  streamChatbotReply,
  trimHistory,
  type ChatMessage,
} from "@/lib/chatbot";

export const runtime = "nodejs";
export const maxDuration = 60;

const RATE_LIMIT_PER_HOUR = 30;
const MAX_USER_MESSAGE_LEN = 2000;
// Regex to strip any trailing [CARD:*] markers (LINE-only; not shown on web)
const CARD_MARKER_RE = /\[CARD:(pricing|register|longcase|meq)\]\s*$/i;

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

  const ssrClient = await createClient();
  const { data: { user } } = await ssrClient.auth.getUser();

  const channelUserId = user?.id ?? body.sessionId;
  if (!channelUserId) {
    return NextResponse.json({ error: "Missing session" }, { status: 400 });
  }

  const admin = createAdminClient();

  // Rate limit: count user messages in the last hour
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

  // Load recent history (chronological)
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

  const encoder = new TextEncoder();
  let fullReply = "";

  const stream = new ReadableStream({
    async start(controller) {
      try {
        for await (const chunk of streamChatbotReply(trimHistory(history), "web")) {
          fullReply += chunk;
          controller.enqueue(encoder.encode(chunk));
        }
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        console.error("[api/chat] stream error:", msg);
        // Send a fallback message so the widget shows something
        const fallback = "ขอโทษครับ ขณะนี้ระบบมีปัญหาชั่วคราว ลองใหม่อีกครั้งนะครับ";
        controller.enqueue(encoder.encode(fallback));
        fullReply = fallback;
      } finally {
        controller.close();

        // Strip any LINE-only card markers that leaked into the web reply
        const cleanReply = fullReply.replace(CARD_MARKER_RE, "").trimEnd();

        // Persist both turns after stream ends (best-effort)
        admin.from("chat_messages").insert([
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
            content: cleanReply || fullReply,
          },
        ]).then(({ error }) => {
          if (error) console.error("[api/chat] persist failed:", error.message);
        });
      }
    },
  });

  return new Response(stream, {
    headers: {
      "Content-Type": "text/plain; charset=utf-8",
      "X-Content-Type-Options": "nosniff",
      // Prevent buffering on some proxies/CDNs
      "Cache-Control": "no-cache",
      "Transfer-Encoding": "chunked",
    },
  });
}
