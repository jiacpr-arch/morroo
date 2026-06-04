import { NextRequest, NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";

// Answer a small batch of extracted MCQs + write a detailed (per-choice)
// explanation, using Sonnet for medical accuracy. The PDF importer calls this
// after extraction so imported questions arrive with a DRAFT เฉลย (status
// review) for the admin to verify before publishing. Admin-only; server key.

export const runtime = "nodejs";
export const maxDuration = 60;

interface InChoice { label: string; text: string }
interface InQuestion { scenario: string; choices: InChoice[] }

interface OutChoice {
  label: string;
  text: string;
  is_correct: boolean;
  explanation: string;
}
interface OutAnswer {
  index: number;
  correct: string;
  detailed_explanation: {
    summary: string;
    reason: string;
    choices: OutChoice[];
    key_takeaway: string;
  };
}

function buildPrompt(questions: InQuestion[], examType: string): string {
  const payload = questions.map((q, i) => ({
    index: i,
    scenario: q.scenario,
    choices: q.choices,
  }));
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญ ออกและเฉลยข้อสอบใบประกอบวิชาชีพ (${examType})
ด้านล่างเป็นข้อสอบ MCQ หลายข้อ (JSON) แต่ละข้อมี index, scenario, choices (label+text)

งานของคุณ: เฉลยแต่ละข้อ พร้อมเขียนคำอธิบายละเอียด อิง evidence-based medicine
กฎ:
1. เลือกคำตอบที่ถูกที่สุด 1 ตัว — ต้องเป็น label ที่มีอยู่ใน choices ของข้อนั้น
2. อธิบายเหตุผลของทุกตัวเลือกว่าถูก/ผิดเพราะอะไร (is_correct true/false)
3. ภาษาไทย กระชับ ตรงประเด็น คง label/text เดิมของตัวเลือก
4. ตอบให้ครบทุก index ตามที่ให้มา
5. ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown

รูปแบบผลลัพธ์:
[{"index":0,"correct":"C","detailed_explanation":{"summary":"คำตอบที่ถูกคือ C ...","reason":"เหตุผลทางการแพทย์ 2-4 ประโยค","choices":[{"label":"A","text":"...","is_correct":false,"explanation":"ผิดเพราะ..."}],"key_takeaway":"ข้อควรจำ"}}]

ข้อสอบ:
${JSON.stringify(payload, null, 0)}`;
}

function lenientArray(raw: string): OutAnswer[] {
  let s = raw.trim();
  if (s.startsWith("```")) s = s.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  try {
    const v = JSON.parse(s);
    if (Array.isArray(v)) return v as OutAnswer[];
  } catch {
    /* salvage below */
  }
  const out: OutAnswer[] = [];
  let depth = 0, start = -1, inStr = false, esc = false;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    if (inStr) {
      if (esc) esc = false;
      else if (c === "\\") esc = true;
      else if (c === '"') inStr = false;
      continue;
    }
    if (c === '"') inStr = true;
    else if (c === "{") { if (depth === 0) start = i; depth++; }
    else if (c === "}") {
      depth--;
      if (depth === 0 && start >= 0) {
        try { out.push(JSON.parse(s.slice(start, i + 1)) as OutAnswer); } catch { /* skip */ }
        start = -1;
      }
    }
  }
  return out;
}

export async function POST(request: NextRequest) {
  const auth = await requireAdmin();
  if (!auth.ok) return auth.response;

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  let body: { questions?: InQuestion[]; exam_type?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const questions = Array.isArray(body.questions) ? body.questions : [];
  const examType = body.exam_type === "NL1" ? "NL1" : "NL2";
  if (questions.length === 0) return NextResponse.json({ answers: [] });

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
        model: "claude-sonnet-4-6-20250514",
        max_tokens: 8000,
        messages: [{ role: "user", content: buildPrompt(questions, examType) }],
      }),
    });
  } catch (e) {
    return NextResponse.json({ error: `เรียก Claude ไม่สำเร็จ: ${String(e)}` }, { status: 502 });
  }

  if (!res.ok) {
    const err = await res.text();
    return NextResponse.json({ error: `Claude API error: ${err.slice(0, 300)}` }, { status: 502 });
  }

  const data = await res.json();
  const raw: string = data.content?.[0]?.text ?? "";
  return NextResponse.json({ answers: lenientArray(raw) });
}
