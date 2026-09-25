import { NextRequest } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { isUuid } from "@/lib/school/ids";
import { ACTIVE_MOCK_BLOCK_MESSAGE, isQuestionInActiveMock } from "@/lib/mcq-active-mock";
import type { McqQuestion } from "@/lib/types-mcq";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import { createAnthropic, CHAT_MODELS, createWithFallback } from "@/lib/anthropic";
import { friendlyAIError, logAIError } from "@/lib/anthropic-error";

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user)
    return new Response(JSON.stringify({ error: "Unauthorized" }), {
      status: 401,
    });

  const rl = await checkRateLimit(supabase, user.id, "ai:mcq-chat", RATE_LIMITS.aiChat);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.aiChat);
  if (rlResp) return rlResp;

  // Body: { questionId, userMessage } — โจทย์และเฉลยโหลดฝั่ง server ด้วย service role
  // (browser ไม่มีเฉลยแล้ว ดู lib/mcq-public.ts) และไม่ตอบข้อที่อยู่ใน Mock ที่กำลังสอบ
  let body: { questionId?: unknown; userMessage?: unknown };
  try {
    body = await request.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON body" }), { status: 400 });
  }
  const { questionId } = body ?? {};
  const userMessage = typeof body?.userMessage === "string" ? body.userMessage : "";

  if (!isUuid(questionId) || !userMessage.trim()) {
    return new Response(
      JSON.stringify({ error: "Missing question or message" }),
      { status: 400 }
    );
  }

  const admin = createAdminClient();
  if (await isQuestionInActiveMock(admin, user.id, questionId)) {
    return new Response(JSON.stringify({ error: ACTIVE_MOCK_BLOCK_MESSAGE }), {
      status: 403,
      headers: { "Content-Type": "application/json" },
    });
  }

  const { data: questionRow } = await admin
    .from("mcq_questions")
    .select("scenario, choices, correct_answer, explanation, detailed_explanation")
    .eq("id", questionId)
    .eq("status", "active")
    .maybeSingle();
  const question = questionRow as Pick<
    McqQuestion,
    "scenario" | "choices" | "correct_answer" | "explanation" | "detailed_explanation"
  > | null;
  if (!question) {
    return new Response(JSON.stringify({ error: "ไม่พบข้อสอบนี้" }), { status: 404 });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey)
    return new Response(
      JSON.stringify({ error: "API key not configured" }),
      { status: 500 }
    );

  const client = createAnthropic();

  // Build context about the question
  const choicesText = question.choices
    .map((c) => `${c.label}. ${c.text}`)
    .join("\n");

  let explanationContext = "";
  if (question.detailed_explanation) {
    const de = question.detailed_explanation;
    explanationContext = `
เฉลย: ${de.summary}
เหตุผล: ${de.reason}
${de.choices.map((c) => `- ตัวเลือก ${c.label}: ${c.explanation}`).join("\n")}
สรุป: ${de.key_takeaway}`;
  } else if (question.explanation) {
    explanationContext = `คำอธิบาย: ${question.explanation}`;
  }

  const systemPrompt = `คุณเป็นอาจารย์สอนแพทย์ผู้เชี่ยวชาญ กำลังช่วยนักศึกษาแพทย์ทำความเข้าใจข้อสอบ MCQ

ข้อสอบที่กำลังพูดถึง:
${question.scenario}

ตัวเลือก:
${choicesText}

คำตอบที่ถูกต้อง: ${question.correct_answer}
${explanationContext}

คำแนะนำ:
- ตอบเป็นภาษาไทย กระชับ เข้าใจง่าย
- อธิบายเหตุผลทางการแพทย์ให้ชัดเจน
- ถ้านักเรียนถามว่าทำไมตัวเลือกอื่นผิด ให้อธิบายเปรียบเทียบกับคำตอบที่ถูก
- ใช้ความรู้ทางคลินิกประกอบการอธิบาย
- ตอบสั้นกระชับ ไม่เกิน 3-4 ย่อหน้า`;

  try {
    const response = await createWithFallback(
      client,
      CHAT_MODELS,
      {
        max_tokens: 1024,
        system: systemPrompt,
        messages: [{ role: "user", content: userMessage }],
      },
      "mcq-chat",
    );

    const text =
      response.content[0].type === "text" ? response.content[0].text : "";

    return new Response(JSON.stringify({ reply: text }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    logAIError("mcq-chat", err);
    return new Response(JSON.stringify({ error: friendlyAIError(err) }), {
      status: 503,
      headers: { "Content-Type": "application/json" },
    });
  }
}
