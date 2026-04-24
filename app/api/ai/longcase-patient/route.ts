import { NextRequest } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { getLongCaseSession, updateLongCaseSession } from "@/lib/supabase/queries-longcase";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";

export const runtime = "nodejs";
export const maxDuration = 60;

const SONNET_MODEL = "claude-sonnet-4-6";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
  }

  const rl = await checkRateLimit(supabase, user.id, "ai:longcase-patient", RATE_LIMITS.aiChat);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.aiChat);
  if (rlResp) return rlResp;

  const { sessionId, messages = [] }: {
    sessionId: string;
    messages: { role: "user" | "assistant"; content: string }[];
  } = await request.json();

  const session = await getLongCaseSession(sessionId);
  if (!session || session.user_id !== user.id) {
    return new Response(JSON.stringify({ error: "Session not found" }), { status: 404 });
  }

  const lc = session.long_case;
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return new Response(JSON.stringify({ error: "API key not configured" }), { status: 500 });
  }

  // Build patient system prompt from historyScript
  const hs = lc.history_script as Record<string, string>;
  const pi = lc.patient_info as { name?: string; age?: number; gender?: string; underlying?: string[]; vitals?: Record<string, unknown> };

  const systemPrompt = `คุณรับบทเป็น ${pi.name || "ผู้ป่วย"} อายุ ${pi.age || "-"} ปี เพศ${pi.gender || "-"}

สถานการณ์: ${hs.cc || ""}
ประวัติจริง (ที่คุณรู้แต่จะเปิดเผยเฉพาะเมื่อถูกถาม):
- อาการหลัก: ${hs.pi || ""}
- ลักษณะอาการ: ${hs.onset || ""}
- ประวัติโรคเดิม: ${hs.pmh || "ไม่มี"}
- ประวัติครอบครัว: ${hs.fh || "ไม่มี"}
- ประวัติสังคม: ${hs.sh || ""}
- ระบบอื่น (ROS): ${hs.ros || ""}

กฎการตอบ:
1. ตอบเป็นภาษาผู้ป่วย (ไทยชาวบ้าน) ไม่ใช้ศัพท์แพทย์
2. เปิดเผยข้อมูลเฉพาะที่ถูกถาม ไม่บอกเกิน
3. ถ้าถามเรื่องที่ไม่รู้ ให้ตอบว่า "ไม่แน่ใจครับ/ค่ะ" หรือ "ไม่ทราบ"
4. แสดงความเจ็บปวด/ความกังวลตามความเหมาะสม
5. ตอบสั้นๆ เป็นธรรมชาติ ไม่เกิน 3 ประโยค
6. อย่าบอก diagnosis เองโดยตรง`;

  const client = new Anthropic({ apiKey });

  // Merge existing history + new message
  const allMessages = [
    ...(Array.isArray(session.history_chat) ? session.history_chat : []),
    ...messages,
  ];

  const stream = client.messages.stream({
    model: SONNET_MODEL,
    max_tokens: 512,
    system: systemPrompt,
    messages: allMessages,
  });

  const encoder = new TextEncoder();
  let fullResponse = "";

  const readable = new ReadableStream({
    async start(controller) {
      try {
        for await (const event of stream) {
          if (event.type === "content_block_delta" && event.delta.type === "text_delta") {
            fullResponse += event.delta.text;
            controller.enqueue(encoder.encode(`data: ${JSON.stringify({ text: event.delta.text })}\n\n`));
          }
        }
        controller.enqueue(encoder.encode(`data: ${JSON.stringify({ done: true })}\n\n`));
        controller.close();

        // Save updated chat to DB
        const updatedChat = [
          ...allMessages,
          { role: "assistant" as const, content: fullResponse },
        ];
        await updateLongCaseSession(sessionId, { history_chat: updatedChat });
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        controller.enqueue(encoder.encode(`data: ${JSON.stringify({ error: msg })}\n\n`));
        controller.close();
      }
    },
  });

  return new Response(readable, {
    headers: { "Content-Type": "text/event-stream", "Cache-Control": "no-cache", Connection: "keep-alive" },
  });
}
