import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendLineMessage, verifyLineSignature, type LineMessage } from "@/lib/line";
import {
  generateChatbotReply,
  trimHistory,
  type ChatMessage,
} from "@/lib/chatbot";
import {
  buildChatbotCard,
  buildAdsMergeConfirmFlex,
} from "@/lib/line-flex-templates";
import { getOrCreateLeadFromChannel } from "@/lib/lead-channel";
import { handleBotIntent, handleEmailCapture } from "@/lib/bot-intent";
import { handleAdsAutofixPostback } from "@/lib/ads-autofix-line";

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(request: NextRequest) {
  const body = await request.text();
  const signature = request.headers.get("x-line-signature") ?? "";

  if (!verifyLineSignature(body, signature)) {
    return NextResponse.json({ error: "Invalid signature" }, { status: 401 });
  }

  const { events } = JSON.parse(body) as {
    events: Array<{
      type: string;
      source?: { userId?: string };
      message?: { type: string; text?: string };
      postback?: { data?: string };
    }>;
  };

  const supabase = createAdminClient();

  for (const event of events) {
    const lineUserId = event.source?.userId;
    if (!lineUserId) continue;
    console.log(`[line/webhook] event=${event.type} userId=${lineUserId}`);

    // Postback: ads-autofix merge / dismiss buttons (admin only)
    if (event.type === "postback" && event.postback?.data) {
      const reply = await handleAdsAutofixPostback(
        supabase,
        lineUserId,
        event.postback.data,
        buildAdsMergeConfirmFlex
      );
      if (reply) await sendLineMessage(lineUserId, reply);
      continue;
    }

    // User added the OA
    if (event.type === "follow") {
      await sendLineMessage(lineUserId, [
        {
          type: "text",
          text: "ยินดีต้อนรับสู่ MorRoo! 🎉\n\nเชื่อมต่อบัญชีเพื่อรับการแจ้งเตือน:\n1. เปิดแอป MorRoo → Profile\n2. กด \"เชื่อมต่อ LINE\"\n3. Copy รหัส แล้วส่งมาที่นี่",
        },
      ]);
    }

    // User sent a text message
    if (event.type === "message" && event.message?.type === "text") {
      const rawText = (event.message.text ?? "").trim();
      if (!rawText) continue;

      const text = rawText.toUpperCase();

      // Non-link-code messages → fall through to the chatbot.
      if (!text.startsWith("MORROO-")) {
        await handleChatbotReply(supabase, lineUserId, rawText);
        continue;
      }

      const { data: linkCode, error: codeError } = await supabase
        .from("line_link_codes")
        .select("user_id, expires_at")
        .eq("code", text)
        .maybeSingle();

      if (codeError) {
        console.error("LINE link code lookup failed:", codeError);
        continue;
      }

      if (!linkCode) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ ไม่พบรหัสนี้ หรือรหัสหมดอายุแล้ว\n\nสร้างรหัสใหม่ได้ที่ Profile ในแอป MorRoo",
          },
        ]);
        continue;
      }

      if (new Date(linkCode.expires_at) < new Date()) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ รหัสหมดอายุแล้ว กรุณาสร้างรหัสใหม่ที่แอป MorRoo",
          },
        ]);
        continue;
      }

      // Check this LINE user isn't already linked to another account
      const { data: existing, error: existingError } = await supabase
        .from("profiles")
        .select("id")
        .eq("line_user_id", lineUserId)
        .maybeSingle();

      if (existingError) {
        console.error("LINE existing-link lookup failed:", existingError);
        continue;
      }

      if (existing && existing.id !== linkCode.user_id) {
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ LINE นี้เชื่อมต่อกับบัญชีอื่นอยู่แล้ว หากต้องการเปลี่ยน ติดต่อ support",
          },
        ]);
        continue;
      }

      // Link LINE user to profile
      const { error: linkError } = await supabase
        .from("profiles")
        .update({
          line_user_id: lineUserId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", linkCode.user_id);

      if (linkError) {
        console.error("Failed to link LINE user to profile:", linkError);
        await sendLineMessage(lineUserId, [
          {
            type: "text",
            text: "❌ เกิดข้อผิดพลาดระหว่างเชื่อมต่อ กรุณาลองใหม่อีกครั้ง",
          },
        ]);
        continue;
      }

      // Delete used code
      const { error: deleteError } = await supabase
        .from("line_link_codes")
        .delete()
        .eq("code", text);

      if (deleteError) {
        // Linking succeeded — log but don't fail the flow.
        console.error("Failed to delete used LINE link code:", deleteError);
      }

      await sendLineMessage(lineUserId, [
        {
          type: "text",
          text: "✅ เชื่อมต่อ LINE สำเร็จ!\n\nคุณจะได้รับการแจ้งเตือนจาก MorRoo ผ่าน LINE แล้ว 🎉",
        },
      ]);
    }
  }

  return NextResponse.json({ ok: true });
}

/** Cap user messages per LINE user per hour to keep AI cost predictable. */
const LINE_RATE_LIMIT_PER_HOUR = 30;

async function handleChatbotReply(
  supabase: ReturnType<typeof createAdminClient>,
  lineUserId: string,
  userMessage: string
): Promise<void> {
  // Resolve lead early — needed for email capture and intent handling.
  const leadId = await getOrCreateLeadFromChannel({
    channel: "line",
    channelUserId: lineUserId,
  });

  // If the user sent a bare email address, save it and acknowledge.
  const emailAck = await handleEmailCapture(leadId, userMessage);
  if (emailAck) {
    await sendLineMessage(lineUserId, [{ type: "text", text: emailAck }]);
    await supabase.from("chat_messages").insert([
      { channel: "line", channel_user_id: lineUserId, lead_id: leadId, role: "user", content: userMessage },
      { channel: "line", channel_user_id: lineUserId, lead_id: leadId, role: "assistant", content: emailAck },
    ]);
    return;
  }

  const sinceIso = new Date(Date.now() - 3600_000).toISOString();
  const { count: recentCount } = await supabase
    .from("chat_messages")
    .select("id", { count: "exact", head: true })
    .eq("channel", "line")
    .eq("channel_user_id", lineUserId)
    .eq("role", "user")
    .gte("created_at", sinceIso);

  if ((recentCount ?? 0) >= LINE_RATE_LIMIT_PER_HOUR) {
    await sendLineMessage(lineUserId, [
      {
        type: "text",
        text: "ขอโทษครับ น้องส่งข้อความเยอะเกินไปในชั่วโมงนี้ 😅 ลองใหม่อีกที่หลังนะครับ",
      },
    ]);
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
  if (result.ok && result.card) {
    messages.push(buildChatbotCard(result.card));
  }

  // Issue a free trial code when the AI detected purchase intent.
  const intentMsg =
    result.ok && result.intent && leadId
      ? await handleBotIntent(leadId, result.intent, "line")
      : null;
  if (intentMsg) {
    messages.push({ type: "text", text: intentMsg });
  }

  await sendLineMessage(lineUserId, messages);

  await supabase.from("chat_messages").insert([
    {
      channel: "line",
      channel_user_id: lineUserId,
      lead_id: leadId,
      role: "user",
      content: userMessage,
    },
    {
      channel: "line",
      channel_user_id: lineUserId,
      lead_id: leadId,
      role: "assistant",
      content: intentMsg ? `${replyText}\n\n${intentMsg}` : replyText,
    },
  ]);
}
