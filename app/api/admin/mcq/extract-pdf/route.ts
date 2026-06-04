import { NextRequest, NextResponse } from "next/server";
import { requireAdmin } from "@/lib/admin-auth";
import { broadSubjectsFor } from "@/lib/nl-subjects";

// Extract structured MCQs from one chunk of PDF exam text using Claude.
// The browser splits the PDF into chunks and calls this once per chunk so each
// request stays within the serverless time budget. Admin-only; uses the server
// ANTHROPIC_API_KEY so the user never handles a key.

export const runtime = "nodejs";
export const maxDuration = 60;

interface ExtractedChoice {
  label: string;
  text: string;
}
interface ExtractedQuestion {
  subject?: string;
  scenario?: string;
  choices?: ExtractedChoice[];
  correct?: string | null;
}

function buildPrompt(chunk: string, examType: "NL1" | "NL2"): string {
  const subjects = broadSubjectsFor(examType)
    .map((s) => `  - ${s.name}: ${s.name_th}`)
    .join("\n");
  return `คุณคือผู้ช่วยจัดรูปแบบข้อสอบแพทย์ (National License Exam ${examType})
ด้านล่างเป็นข้อความดิบที่ดึงจาก PDF ข้อสอบ (อาจมีอักขระเพี้ยน ไทย/อังกฤษปนกัน
เลขข้อรีเซ็ตตามสาขา และอาจไม่มีเฉลย)

งานของคุณ: ดึง "ข้อสอบ MCQ" ออกมาเป็น JSON เท่านั้น
กฎ:
1. แต่ละข้อต้องมี scenario (โจทย์) และตัวเลือกอย่างน้อย 2 ตัว
2. เก็บข้อความตามต้นฉบับ (ไทย/อังกฤษ) ไม่ต้องแปล ไม่ต้องแก้เนื้อหา
3. ตัวเลือกใช้ label A,B,C,D,E (ถ้าต้นฉบับเป็น ก/ข/ค/ง/จ ให้แปลงเป็น A-E ตามลำดับ)
4. ถ้ามีเฉลย ใส่ "correct" เป็น label (A-E); ถ้าไม่มี ใส่ null
5. ระบุ "subject" โดยเลือก slug ที่เหมาะที่สุดจากรายการนี้:
${subjects}
   (อิงจากหัวข้อสาขาในข้อความ เช่น "Internal medicine"→internal_med, "Surgery"→surgery)
6. ข้อที่ถูกตัดครึ่ง/ไม่สมบูรณ์ที่ขอบ chunk ให้ "ข้าม" ไป อย่าเดาต่อ
7. อย่าใส่ข้อความอธิบายใดๆ นอก JSON

ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown:
[{"subject":"internal_med","scenario":"...","choices":[{"label":"A","text":"..."},{"label":"B","text":"..."}],"correct":"A"}]

ข้อความดิบ:
"""
${chunk}
"""`;
}

// Salvage complete top-level {...} objects from a JSON array, tolerating
// truncation / markdown fences (mirrors generate-for-subject route).
function lenientObjects(raw: string): ExtractedQuestion[] {
  const out: ExtractedQuestion[] = [];
  let depth = 0;
  let start = -1;
  let inStr = false;
  let esc = false;
  for (let i = 0; i < raw.length; i++) {
    const c = raw[i];
    if (inStr) {
      if (esc) esc = false;
      else if (c === "\\") esc = true;
      else if (c === '"') inStr = false;
      continue;
    }
    if (c === '"') inStr = true;
    else if (c === "{") {
      if (depth === 0) start = i;
      depth++;
    } else if (c === "}") {
      depth--;
      if (depth === 0 && start >= 0) {
        try {
          out.push(JSON.parse(raw.slice(start, i + 1)) as ExtractedQuestion);
        } catch {
          /* skip */
        }
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

  let body: { text?: string; exam_type?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const text = (body.text ?? "").trim();
  const examType = body.exam_type === "NL1" ? "NL1" : "NL2";
  if (text.length < 20) {
    return NextResponse.json({ questions: [] });
  }

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
        model: "claude-haiku-4-5-20251001",
        max_tokens: 8000,
        messages: [{ role: "user", content: buildPrompt(text, examType) }],
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
  let raw: string = data.content?.[0]?.text ?? "";
  raw = raw.trim();
  if (raw.startsWith("```")) {
    raw = raw.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  }

  let questions: ExtractedQuestion[];
  try {
    const parsed = JSON.parse(raw);
    questions = Array.isArray(parsed) ? parsed : [];
  } catch {
    questions = lenientObjects(raw);
  }

  return NextResponse.json({ questions });
}
