import { NextRequest, NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";

// Draft a detailed_explanation for one MCQ so an admin can review/edit it
// before publishing — speeds up authoring the เฉลย for bulk-imported questions.
// Admin-only; the human still verifies the correct answer + reasoning.

export const runtime = "nodejs";
export const maxDuration = 60;

interface Choice {
  label: string;
  text: string;
}

interface DraftRequest {
  scenario?: string;
  choices?: Choice[];
  correct_answer?: string;
  subject_th?: string;
  exam_type?: string;
}

function buildPrompt(
  scenario: string,
  choices: Choice[],
  correctAnswer: string,
  subjectTh: string,
  examType: string
): string {
  const choiceLines = choices
    .map((c) => `${c.label}. ${c.text}`)
    .join("\n");
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${subjectTh} ช่วยเขียน "เฉลยละเอียด" ของข้อสอบ MCQ สำหรับสอบใบประกอบวิชาชีพ (${examType})

โจทย์:
${scenario}

ตัวเลือก:
${choiceLines}

คำตอบที่ผู้ออกข้อสอบระบุไว้: ${correctAnswer}

งานของคุณ:
1. ตรวจว่าคำตอบ ${correctAnswer} ถูกต้องตามหลัก evidence-based medicine หรือไม่ — ถ้าคุณคิดว่าคำตอบที่ถูกควรเป็นตัวอื่น ให้ตั้ง is_correct=true ที่ตัวเลือกที่คุณเชื่อว่าถูก และอธิบายเหตุผลในช่อง reason
2. อธิบายทุกตัวเลือกว่าถูกหรือผิดเพราะอะไร
3. เขียนเป็นภาษาไทย กระชับ ตรงประเด็น อ้าง guideline/pathophysiology เมื่อทำได้

ตอบเป็น JSON object เท่านั้น ไม่ต้องมี markdown code block:
{
  "summary": "สรุปคำตอบที่ถูกต้อง 1-2 ประโยค",
  "reason": "อธิบายเหตุผลทางการแพทย์อย่างละเอียด (2-4 ประโยค)",
  "choices": [
    {"label":"A","text":"<ข้อความตัวเลือก A>","is_correct":false,"explanation":"ผิด เพราะ..."}
  ],
  "key_takeaway": "ข้อควรจำ/หลักสำคัญที่ควรนำไปใช้สอบ"
}
ใส่ choices ให้ครบทุกตัวเลือกตามที่ให้มา และคง label/text เดิมไว้`;
}

export async function POST(request: NextRequest) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  let body: DraftRequest;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const scenario = (body.scenario ?? "").trim();
  const choices = Array.isArray(body.choices) ? body.choices : [];
  const correctAnswer = (body.correct_answer ?? "").trim().toUpperCase();

  if (!scenario || choices.length < 2 || !correctAnswer) {
    return NextResponse.json(
      { error: "ต้องมี scenario, choices (อย่างน้อย 2) และ correct_answer" },
      { status: 400 }
    );
  }

  const prompt = buildPrompt(
    scenario,
    choices,
    correctAnswer,
    body.subject_th || "เวชศาสตร์",
    body.exam_type || "NL"
  );

  let res: Response;
  try {
    res = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: "claude-sonnet-4-6",
        max_tokens: 4000,
        messages: [{ role: "user", content: prompt }],
      }),
    });
  } catch (e) {
    return NextResponse.json(
      { error: `เรียก Claude ไม่สำเร็จ: ${String(e)}` },
      { status: 502 }
    );
  }

  if (!res.ok) {
    const err = await res.text();
    return NextResponse.json({ error: `Claude API error: ${err}` }, { status: 502 });
  }

  const data = await res.json();
  const rawContent: string = data.content?.[0]?.text ?? "";
  let cleaned = rawContent.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  }

  try {
    const detailed = JSON.parse(cleaned);
    return NextResponse.json({ detailed_explanation: detailed });
  } catch {
    return NextResponse.json(
      { error: "Claude ตอบกลับไม่ใช่ JSON ที่อ่านได้ ลองใหม่อีกครั้ง" },
      { status: 502 }
    );
  }
}
