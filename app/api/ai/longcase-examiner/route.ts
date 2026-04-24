import { NextRequest } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { getLongCaseSession, updateLongCaseSession } from "@/lib/supabase/queries-longcase";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";

export const runtime = "nodejs";
export const maxDuration = 60;

const SONNET_MODEL = "claude-sonnet-4-6";
const OPUS_MODEL = "claude-opus-4-7";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });

  const rl = await checkRateLimit(supabase, user.id, "ai:longcase-examiner", RATE_LIMITS.aiChat);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.aiChat);
  if (rlResp) return rlResp;

  const { sessionId, messages = [], action = "chat" }: {
    sessionId: string;
    messages: { role: "user" | "assistant"; content: string }[];
    action: "start" | "chat" | "score";
  } = await request.json();

  const session = await getLongCaseSession(sessionId);
  if (!session || session.user_id !== user.id) {
    return new Response(JSON.stringify({ error: "Session not found" }), { status: 404 });
  }

  const lc = session.long_case;
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return new Response(JSON.stringify({ error: "API key not configured" }), { status: 500 });

  const client = new Anthropic({ apiKey });
  const useOpus = action === "score";
  const model = useOpus ? OPUS_MODEL : SONNET_MODEL;

  // Parse case data
  const peFindings = lc.pe_findings as Record<string, string>;
  const labResults = lc.lab_results as Record<string, { value: string; isAbnormal: boolean }>;
  const examinerQs = lc.examiner_questions as { question: string; modelAnswer: string; points: number }[];
  const rubric = lc.scoring_rubric as Record<string, number>;
  const historyChat = Array.isArray(session.history_chat) ? session.history_chat : [];
  const examinerChat = Array.isArray(session.examiner_chat) ? session.examiner_chat : [];

  // PE selected by student
  const peSelected = Array.isArray(session.pe_selected) ? session.pe_selected : [];
  const peRevealedText = peSelected.map((sys: string) =>
    `${sys}: ${peFindings[sys] || "ปกติ"}`
  ).join("\n");

  // Labs ordered by student
  const labOrdered = Array.isArray(session.lab_ordered) ? session.lab_ordered : [];
  const labRevealedText = labOrdered.map((name: string) => {
    const res = labResults[name];
    return res ? `${name}: ${res.value}${res.isAbnormal ? " [ผิดปกติ]" : ""}` : `${name}: ไม่มีผล`;
  }).join("\n");

  const caseContext = `
**เคส:** ${lc.title} (${lc.specialty}, ${lc.difficulty})
**การวินิจฉัยที่ถูกต้อง:** ${lc.correct_diagnosis}
**การรักษาที่ถูก:** ${lc.management_plan}

**ประวัติที่นักศึกษาซัก:**
${historyChat.filter(m => m.role === "user").map(m => `ถาม: ${m.content}`).join("\n")}

**PE ที่ตรวจ:**
${peRevealedText || "ไม่ได้ตรวจ"}

**Lab/Imaging ที่สั่ง:**
${labRevealedText || "ไม่ได้สั่ง"}

**DDx ของนักศึกษา:**
${session.student_ddx || "ไม่ได้เขียน"}

**การรักษาที่นักศึกษาเสนอ:**
${session.student_mgmt || "ไม่ได้เขียน"}

**เกณฑ์คะแนน:**
${Object.entries(rubric).map(([k, v]) => `- ${k}: ${v} คะแนน`).join("\n")}
`;

  if (action === "score") {
    // Opus scores the student
    const scorePrompt = `${caseContext}

**คำถามที่ถามและคำตอบต้นฉบับ:**
${examinerQs.map((q, i) => `Q${i + 1}: ${q.question}\nModel Answer: ${q.modelAnswer}`).join("\n\n")}

**การสัมภาษณ์ที่เกิดขึ้น:**
${examinerChat.map(m => `${m.role === "user" ? "นักศึกษา" : "Examiner"}: ${m.content}`).join("\n")}

ให้คะแนนนักศึกษาและตอบเป็น JSON เท่านั้น:
{
  "score_history": <0-${rubric.history || 25}>,
  "score_pe": <0-${rubric.pe || 20}>,
  "score_lab": <0-${rubric.lab || 15}>,
  "score_ddx": <0-${rubric.ddx || 20}>,
  "score_management": <0-${rubric.management || 20}>,
  "score_examiner": <0-10>,
  "feedback": "<คำติชมโดยรวม 3-4 ประโยค>",
  "teaching_points": ["<สิ่งที่ทำดี>", "<สิ่งที่ต้องปรับปรุง>", "<pearl ที่ควรจำ>"]
}`;

    try {
      const response = await client.messages.create({
        model,
        max_tokens: 1024,
        messages: [{ role: "user", content: scorePrompt }],
      });
      const rawText = response.content[0].type === "text" ? response.content[0].text : "";
      const jsonMatch = rawText.match(/\{[\s\S]*\}/);
      if (!jsonMatch) throw new Error("No JSON in response");

      const scores = JSON.parse(jsonMatch[0]);
      const total = (scores.score_history || 0) + (scores.score_pe || 0) +
        (scores.score_lab || 0) + (scores.score_ddx || 0) +
        (scores.score_management || 0) + (scores.score_examiner || 0);
      const maxTotal = (rubric.history || 25) + (rubric.pe || 20) + (rubric.lab || 15) +
        (rubric.ddx || 20) + (rubric.management || 20) + 10;
      const pct = Math.round((total / maxTotal) * 100);

      await updateLongCaseSession(sessionId, {
        score_history: scores.score_history,
        score_pe: scores.score_pe,
        score_lab: scores.score_lab,
        score_ddx: scores.score_ddx,
        score_management: scores.score_management,
        score_examiner: scores.score_examiner,
        score_total_pct: pct,
        feedback: scores.feedback,
        phase: "done",
        completed_at: new Date().toISOString(),
      });

      // Coins awarded by DB trigger — surface the breakdown to the UI
      const coin_base = 20;
      const coin_bonus = pct >= 70 ? 10 : 0;
      const { data: profile } = await supabase
        .from("profiles")
        .select("meq_coins")
        .eq("id", user.id)
        .single();

      return new Response(JSON.stringify({
        ...scores,
        score_total_pct: pct,
        teaching_points: scores.teaching_points,
        coins: {
          base: coin_base,
          bonus: coin_bonus,
          total_awarded: coin_base + coin_bonus,
          balance: profile?.meq_coins ?? null,
        },
      }), {
        headers: { "Content-Type": "application/json" },
      });
    } catch (err) {
      return new Response(JSON.stringify({ error: String(err) }), { status: 500 });
    }
  }

  // Chat mode (start or continue)
  const systemPrompt = action === "start"
    ? `คุณเป็น Examiner (อาจารย์ผู้ตรวจข้อสอบ Long Case) ที่มีประสบการณ์
${caseContext}

เริ่มต้นด้วยการให้นักศึกษา Present Case และถามคำถามตาม examiner_questions ทีละข้อ
ทักทายสั้นๆ และขอให้นักศึกษา Present the case

คำถามที่ต้องถาม:
${examinerQs.map((q, i) => `${i + 1}. ${q.question}`).join("\n")}`
    : `คุณเป็น Examiner ที่กำลังสัมภาษณ์นักศึกษา ถามคำถามต่อจากที่ค้างอยู่
${caseContext}

คำถามที่ต้องถาม:
${examinerQs.map((q, i) => `${i + 1}. ${q.question}`).join("\n")}

ตอบสนองต่อคำตอบของนักศึกษาอย่างมืออาชีพ และถามคำถามถัดไป`;

  const allMessages = [
    ...examinerChat,
    ...messages,
  ];

  const stream = client.messages.stream({
    model,
    max_tokens: 1024,
    system: systemPrompt,
    messages: allMessages.length > 0 ? allMessages : [{ role: "user", content: "เริ่มต้นการสัมภาษณ์" }],
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

        // Save examiner chat
        const updatedChat = [
          ...allMessages,
          { role: "assistant" as const, content: fullResponse },
        ];
        await updateLongCaseSession(sessionId, {
          examiner_chat: updatedChat,
          phase: "examiner",
        });
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
