import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// Vercel Hobby caps serverless functions at 60s.
// Without this export the route silently times out — which is why large
// Sonnet-only fills used to leave the tail subjects empty.
export const runtime = "nodejs";
export const maxDuration = 60;

// All known subjects — keep in sync with mcq_schema.sql
const ALL_SUBJECTS: { name: string; name_th: string }[] = [
  { name: "cardio_med", name_th: "อายุรศาสตร์หัวใจ" },
  { name: "chest_med", name_th: "อายุรศาสตร์ทรวงอก" },
  { name: "ent", name_th: "โสต ศอ นาสิก" },
  { name: "endocrine", name_th: "ต่อมไร้ท่อ" },
  { name: "eye", name_th: "จักษุวิทยา" },
  { name: "forensic", name_th: "นิติเวชศาสตร์" },
  { name: "gi_med", name_th: "อายุรศาสตร์ทางเดินอาหาร" },
  { name: "gi_ped", name_th: "กุมารเวช ทางเดินอาหาร" },
  { name: "gd_ped", name_th: "กุมารเวช พัฒนาการ" },
  { name: "hemato_med", name_th: "โลหิตวิทยา" },
  { name: "hemato_ped", name_th: "กุมารเวช โลหิตวิทยา" },
  { name: "infectious_med", name_th: "โรคติดเชื้อ" },
  { name: "infectious_ped", name_th: "กุมารเวช โรคติดเชื้อ" },
  { name: "nephro_med", name_th: "อายุรศาสตร์ไต" },
  { name: "neuro_med", name_th: "ประสาทวิทยา" },
  { name: "ob_gyn", name_th: "สูติศาสตร์-นรีเวชวิทยา" },
  { name: "ortho", name_th: "ออร์โธปิดิกส์" },
  { name: "ped", name_th: "กุมารเวชศาสตร์" },
  { name: "psychi", name_th: "จิตเวชศาสตร์" },
  { name: "surgery", name_th: "ศัลยศาสตร์" },
  { name: "uro_surgery", name_th: "ศัลยศาสตร์ระบบทางเดินปัสสาวะ" },
  { name: "epidemio", name_th: "ระบาดวิทยา" },
  { name: "chest_ped", name_th: "กุมารเวช ทรวงอก" },
  { name: "endocrine_ped", name_th: "กุมารเวช ต่อมไร้ท่อ" },
];

interface GeneratedQuestion {
  scenario: string;
  choices: Array<{ label: string; text: string }>;
  correct_answer: string;
  explanation: string;
  detailed_explanation?: {
    summary: string;
    reason: string;
    choices: Array<{
      label: string;
      text: string;
      is_correct: boolean;
      explanation: string;
    }>;
    key_takeaway: string;
  };
  difficulty: string;
}

function buildPrompt(
  subjectNameTh: string,
  count: number,
  difficultyInstruction: string,
  existingCount: number
): string {
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${subjectNameTh} สำหรับสอบใบประกอบวิชาชีพ (National License Exam - NL Step 2)

สร้างข้อสอบ MCQ จำนวน ${count} ข้อ สาขา ${subjectNameTh}

กฎ:
1. แต่ละข้อมี scenario ที่มีรายละเอียดเพียงพอ (อายุ เพศ อาการ ผลตรวจ)
2. ตัวเลือก 5 ข้อ (A-E) plausible ทั้งหมด
3. คำตอบถูกต้องอิง evidence-based medicine
4. คำอธิบายเฉลยละเอียด อธิบายทุกตัวเลือก
5. ${difficultyInstruction}
6. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในระบบ)
7. เขียนภาษาไทยหรืออังกฤษตามความเหมาะสมของเนื้อหาทางการแพทย์
8. ทุกข้อเหมาะสำหรับ NL Step 2

ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown code block:
[
  {
    "scenario": "โจทย์...",
    "choices": [{"label":"A","text":"..."},{"label":"B","text":"..."},{"label":"C","text":"..."},{"label":"D","text":"..."},{"label":"E","text":"..."}],
    "correct_answer": "A",
    "explanation": "สรุปสั้นๆ ว่าทำไมคำตอบนี้ถูก",
    "detailed_explanation": {
      "summary": "สรุปคำตอบที่ถูกต้อง 1-2 ประโยค",
      "reason": "อธิบายเหตุผลทางการแพทย์อย่างละเอียด (2-4 ประโยค) อิง guideline หรือ pathophysiology",
      "choices": [
        {"label":"A","text":"ตัวเลือก A...","is_correct":true,"explanation":"ถูกต้อง เพราะ..."},
        {"label":"B","text":"ตัวเลือก B...","is_correct":false,"explanation":"ผิด เพราะ..."},
        {"label":"C","text":"ตัวเลือก C...","is_correct":false,"explanation":"ผิด เพราะ..."},
        {"label":"D","text":"ตัวเลือก D...","is_correct":false,"explanation":"ผิด เพราะ..."},
        {"label":"E","text":"ตัวเลือก E...","is_correct":false,"explanation":"ผิด เพราะ..."}
      ],
      "key_takeaway": "ข้อควรจำ/หลักสำคัญที่ควรนำไปใช้สอบ"
    },
    "difficulty": "easy|medium|hard"
  }
]`;
}

// Extract as many complete top-level objects as possible from a JSON array
// response — tolerating truncation at max_tokens, trailing commas, or a missing
// closing bracket. Used as a fallback when strict JSON.parse fails.
function extractQuestionsLenient(raw: string): GeneratedQuestion[] {
  const results: GeneratedQuestion[] = [];
  const start = raw.indexOf("[");
  if (start < 0) return results;

  let i = start + 1;
  const len = raw.length;

  while (i < len) {
    // Skip whitespace + commas between objects
    while (i < len && /[\s,]/.test(raw[i])) i++;
    if (i >= len || raw[i] === "]") break;
    if (raw[i] !== "{") {
      i++;
      continue;
    }

    // Scan a balanced JSON object starting at `{`.
    const objStart = i;
    let depth = 0;
    let inStr = false;
    let esc = false;
    let objEnd = -1;
    for (let j = i; j < len; j++) {
      const ch = raw[j];
      if (inStr) {
        if (esc) esc = false;
        else if (ch === "\\") esc = true;
        else if (ch === '"') inStr = false;
        continue;
      }
      if (ch === '"') inStr = true;
      else if (ch === "{") depth++;
      else if (ch === "}") {
        depth--;
        if (depth === 0) {
          objEnd = j;
          break;
        }
      }
    }

    if (objEnd < 0) break; // truncated mid-object — stop

    const slice = raw.slice(objStart, objEnd + 1);
    try {
      results.push(JSON.parse(slice) as GeneratedQuestion);
    } catch {
      /* skip unparseable object */
    }
    i = objEnd + 1;
  }

  return results;
}

async function callClaude(
  apiKey: string,
  model: string,
  maxTokens: number,
  prompt: string
): Promise<GeneratedQuestion[]> {
  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": apiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude API error (${model}): ${err}`);
  }

  const data = await res.json();
  const rawContent: string = data.content?.[0]?.text ?? "";
  if (!rawContent) throw new Error(`Empty response from ${model}`);

  let cleaned = rawContent.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  }

  // Strict parse first.
  try {
    const parsed = JSON.parse(cleaned);
    if (Array.isArray(parsed)) return parsed;
  } catch {
    /* fall through */
  }

  // Lenient fallback — salvages complete questions from a truncated response.
  const salvaged = extractQuestionsLenient(cleaned);
  if (salvaged.length > 0) return salvaged;

  throw new Error(`Failed to parse JSON from ${model}`);
}

// POST /api/mcq/generate-for-subject
// Query: ?secret=xxx
// Body: { subject_name?: string, fill_empty?: boolean, count?: number }
//
// subject_name  — generate for one specific subject
// fill_empty    — generate for the FIRST empty subject (one per invocation so
//                 the whole run stays within the 60s Vercel Hobby budget).
//                 Response includes `remaining` so the caller can loop.
// count         — total questions for the subject (default 30)
export async function POST(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  let body: {
    subject_name?: string;
    fill_empty?: boolean;
    count?: number;
  } = {};
  try {
    body = await request.json();
  } catch {
    /* body is optional */
  }

  const perSubjectCount = Math.min(
    Math.max(body.count ?? 30, 5),
    50 // cap at 50 per call
  );

  const admin = createAdminClient();

  // Pick target subject(s). For fill_empty we only handle ONE subject per
  // invocation; callers should re-hit the endpoint until `remaining` is 0.
  let target: { name: string; name_th: string } | null = null;
  const emptyRemaining: { name: string; name_th: string }[] = [];

  if (body.fill_empty) {
    const { data: subjectRows } = await admin
      .from("mcq_subjects")
      .select("name, name_th, id")
      .order("name");

    if (!subjectRows) {
      return NextResponse.json({ error: "Cannot fetch subjects" }, { status: 500 });
    }

    for (const row of subjectRows) {
      const { count } = await admin
        .from("mcq_questions")
        .select("id", { count: "exact", head: true })
        .eq("subject_id", row.id)
        .eq("status", "active");
      if ((count ?? 0) === 0) {
        emptyRemaining.push({ name: row.name, name_th: row.name_th });
      }
    }

    if (emptyRemaining.length === 0) {
      return NextResponse.json({
        success: true,
        message: "ทุกสาขามีข้อสอบแล้ว ไม่มีสาขาว่าง",
        remaining: 0,
      });
    }

    target = emptyRemaining.shift() ?? null;
  } else if (body.subject_name) {
    const found = ALL_SUBJECTS.find((s) => s.name === body.subject_name);
    if (!found) {
      return NextResponse.json(
        {
          error: `ไม่พบสาขา "${body.subject_name}"`,
          valid_subjects: ALL_SUBJECTS.map((s) => s.name),
        },
        { status: 400 }
      );
    }
    target = found;
  } else {
    return NextResponse.json(
      {
        error: 'ต้องระบุ subject_name หรือ fill_empty:true ใน body',
      },
      { status: 400 }
    );
  }

  if (!target) {
    return NextResponse.json({ error: "No target subject resolved" }, { status: 500 });
  }

  // Get subject row
  const { data: subjectRow } = await admin
    .from("mcq_subjects")
    .select("id")
    .eq("name", target.name)
    .single();

  if (!subjectRow) {
    return NextResponse.json(
      { error: `Subject "${target.name}" not found in DB` },
      { status: 500 }
    );
  }

  const { count: existingCountRaw } = await admin
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  const existing = existingCountRaw ?? 0;

  // Split: 20% easy, 50% medium, 30% hard.
  // Haiku handles easy+medium (fast, fits comfortably in 60s).
  // Sonnet handles hard only (9-ish questions is the sweet spot it can finish
  // in parallel with Haiku within the budget).
  const easyCount = Math.round(perSubjectCount * 0.2);
  const hardCount = Math.round(perSubjectCount * 0.3);
  const mediumCount = perSubjectCount - easyCount - hardCount;
  const easyMediumCount = easyCount + mediumCount;

  const [easyMediumResult, hardResult] = await Promise.allSettled([
    callClaude(
      apiKey,
      "claude-haiku-4-5-20251001",
      32000,
      buildPrompt(
        target.name_th,
        easyMediumCount,
        `สร้างข้อง่าย (easy) ${easyCount} ข้อ และข้อปานกลาง (medium) ${mediumCount} ข้อ — ข้อง่ายเน้น recall ความรู้พื้นฐาน definition, ข้อปานกลางเน้น first-line treatment, investigation of choice, การวินิจฉัยจาก typical presentation`,
        existing
      )
    ),
    callClaude(
      apiKey,
      "claude-sonnet-4-6-20250514",
      24000,
      buildPrompt(
        target.name_th,
        hardCount,
        `สร้างเฉพาะข้อยาก (hard) ${hardCount} ข้อ — เน้น clinical reasoning ซับซ้อน, differential diagnosis, management ของ case ที่มี comorbidity, interpretation ของ lab/imaging ที่ต้องวิเคราะห์หลายขั้นตอน`,
        existing
      )
    ),
  ]);

  const allQuestions: GeneratedQuestion[] = [];
  const errors: string[] = [];

  if (easyMediumResult.status === "fulfilled") {
    allQuestions.push(...easyMediumResult.value);
  } else {
    errors.push(`Haiku batch failed: ${easyMediumResult.reason}`);
  }

  if (hardResult.status === "fulfilled") {
    allQuestions.push(...hardResult.value);
  } else {
    errors.push(`Sonnet batch failed: ${hardResult.reason}`);
  }

  if (allQuestions.length === 0) {
    return NextResponse.json(
      {
        error: "All batches failed",
        subject: target.name,
        details: errors,
        remaining: emptyRemaining.length + 1, // this one still empty
      },
      { status: 500 }
    );
  }

  const now = new Date();
  const validQuestions = allQuestions
    .filter(
      (q) =>
        q.scenario &&
        Array.isArray(q.choices) &&
        q.choices.length >= 4 &&
        q.correct_answer &&
        ["A", "B", "C", "D", "E"].includes(q.correct_answer)
    )
    .map((q) => ({
      subject_id: subjectRow.id,
      exam_type: "NL2" as const,
      exam_source: "AI-generated-fill",
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation || null,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: ["easy", "medium", "hard"].includes(q.difficulty)
        ? q.difficulty
        : "medium",
      is_ai_enhanced: true,
      ai_notes: `Auto-fill on ${now.toISOString().split("T")[0]} | ${q.difficulty === "hard" ? "sonnet" : "haiku"}`,
      status: "active" as const,
    }));

  if (validQuestions.length === 0) {
    return NextResponse.json(
      {
        error: "No valid questions after validation",
        subject: target.name,
        details: errors,
        remaining: emptyRemaining.length + 1,
      },
      { status: 500 }
    );
  }

  const { data: inserted, error: insertError } = await admin
    .from("mcq_questions")
    .insert(validQuestions)
    .select("id");

  if (insertError) {
    return NextResponse.json(
      {
        error: insertError.message,
        subject: target.name,
        remaining: emptyRemaining.length + 1,
      },
      { status: 500 }
    );
  }

  // Update question_count
  const { count: newTotal } = await admin
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  await admin
    .from("mcq_subjects")
    .update({ question_count: newTotal ?? 0 })
    .eq("id", subjectRow.id);

  return NextResponse.json({
    success: true,
    subject: target.name,
    subject_th: target.name_th,
    inserted: inserted?.length ?? 0,
    total_in_subject: newTotal ?? 0,
    batches: {
      haiku: easyMediumResult.status === "fulfilled" ? easyMediumResult.value.length : 0,
      sonnet: hardResult.status === "fulfilled" ? hardResult.value.length : 0,
    },
    ...(errors.length > 0 ? { warnings: errors } : {}),
    ...(body.fill_empty ? { remaining: emptyRemaining.length } : {}),
  });
}

// GET /api/mcq/generate-for-subject?secret=xxx
// Returns subjects with their current question counts
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const admin = createAdminClient();
  const { data: subjectRows } = await admin
    .from("mcq_subjects")
    .select("id, name, name_th, icon, question_count")
    .order("name_th");

  if (!subjectRows) {
    return NextResponse.json({ error: "Cannot fetch subjects" }, { status: 500 });
  }

  // Get real counts (question_count may be stale)
  const counts: {
    name: string;
    name_th: string;
    icon: string;
    question_count: number;
    needs_fill: boolean;
  }[] = [];

  for (const row of subjectRows) {
    const { count } = await admin
      .from("mcq_questions")
      .select("id", { count: "exact", head: true })
      .eq("subject_id", row.id)
      .eq("status", "active");
    counts.push({
      name: row.name,
      name_th: row.name_th,
      icon: row.icon,
      question_count: count ?? 0,
      needs_fill: (count ?? 0) === 0,
    });
  }

  counts.sort((a, b) => a.question_count - b.question_count);

  return NextResponse.json({
    subjects: counts,
    empty_count: counts.filter((c) => c.needs_fill).length,
  });
}
