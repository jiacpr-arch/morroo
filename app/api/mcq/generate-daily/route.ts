import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Generate 10 MCQ questions per subject, rotating through subjects daily
// Easy+Medium → Haiku (fast, cheap), Hard → Sonnet (deep clinical reasoning)

const SUBJECTS_ROTATION = [
  { name: "cardio_med", name_th: "อายุรศาสตร์หัวใจ" },
  { name: "surgery", name_th: "ศัลยศาสตร์" },
  { name: "ped", name_th: "กุมารเวชศาสตร์" },
  { name: "ob_gyn", name_th: "สูติศาสตร์-นรีเวชวิทยา" },
  { name: "ortho", name_th: "ออร์โธปิดิกส์" },
  { name: "psychi", name_th: "จิตเวชศาสตร์" },
  { name: "infectious_med", name_th: "โรคติดเชื้อ" },
  { name: "gi_med", name_th: "อายุรศาสตร์ทางเดินอาหาร" },
  { name: "chest_med", name_th: "อายุรศาสตร์ทรวงอก" },
  { name: "endocrine", name_th: "ต่อมไร้ท่อ" },
  { name: "hemato_med", name_th: "โลหิตวิทยา" },
  { name: "nephro_med", name_th: "อายุรศาสตร์ไต" },
  { name: "neuro_med", name_th: "ประสาทวิทยา" },
  { name: "forensic", name_th: "นิติเวชศาสตร์" },
  { name: "ent", name_th: "โสต ศอ นาสิก" },
  { name: "epidemio", name_th: "ระบาดวิทยา" },
  // สาขาที่เพิ่มเข้ามา — ทุกสาขาหมุนเวียนเท่ากัน
  { name: "eye", name_th: "จักษุวิทยา" },
  { name: "uro_surgery", name_th: "ศัลยศาสตร์ระบบทางเดินปัสสาวะ" },
  { name: "gi_ped", name_th: "กุมารเวช ทางเดินอาหาร" },
  { name: "gd_ped", name_th: "กุมารเวช พัฒนาการ" },
  { name: "hemato_ped", name_th: "กุมารเวช โลหิตวิทยา" },
  { name: "infectious_ped", name_th: "กุมารเวช โรคติดเชื้อ" },
  { name: "chest_ped", name_th: "กุมารเวช ทรวงอก" },
  { name: "endocrine_ped", name_th: "กุมารเวช ต่อมไร้ท่อ" },
];

// 30 questions/day — 20% easy, 50% medium, 30% hard (เหมือนสอบจริง)
// Haiku: easy+medium (21 ข้อ), Sonnet: hard (9 ข้อ)
const BATCH_CONFIG = {
  easyMedium: { count: 21, model: "claude-haiku-4-5-20251001", maxTokens: 32000 },
  hard: { count: 9, model: "claude-sonnet-4-6-20250514", maxTokens: 24000 },
};

interface GeneratedQuestion {
  scenario: string;
  choices: Array<{ label: string; text: string }>;
  correct_answer: string;
  explanation: string;
  detailed_explanation?: {
    summary: string;
    reason: string;
    choices: Array<{ label: string; text: string; is_correct: boolean; explanation: string }>;
    key_takeaway: string;
  };
  difficulty: string;
}

function buildPrompt(
  subjectNameTh: string,
  count: number,
  difficultyInstruction: string,
  existingCount: number,
) {
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${subjectNameTh} สำหรับสอบใบประกอบวิชาชีพ (National License Exam - NL Step 2)

สร้างข้อสอบ MCQ จำนวน ${count} ข้อ สาขา ${subjectNameTh}

กฎ:
1. แต่ละข้อต้องมี scenario (โจทย์สถานการณ์) ที่มีรายละเอียดเพียงพอ เช่น อายุ เพศ อาการ ผลตรวจ
2. ตัวเลือก 5 ข้อ (A-E) ที่เป็น plausible ทั้งหมด ไม่มีตัวเลือกมั่วๆ
3. คำตอบถูกต้องต้องอิง evidence-based medicine
4. คำอธิบายเฉลยต้องละเอียด อธิบายว่าทำไมคำตอบนั้นถูก และทำไมตัวเลือกอื่นผิดทีละข้อ
5. ${difficultyInstruction}
6. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในระบบ)
7. เขียนเป็นภาษาไทยหรืออังกฤษก็ได้ตามความเหมาะสมของเนื้อหาทางการแพทย์
8. ทุกข้อต้องเหมาะสมกับระดับ NL Step 2

ตอบเป็น JSON array เท่านั้น ไม่ต้องมี markdown code block:
[
  {
    "scenario": "โจทย์...",
    "choices": [{"label": "A", "text": "..."}, {"label": "B", "text": "..."}, {"label": "C", "text": "..."}, {"label": "D", "text": "..."}, {"label": "E", "text": "..."}],
    "correct_answer": "A",
    "explanation": "สรุปสั้นๆ ว่าทำไมคำตอบนี้ถูก",
    "detailed_explanation": {
      "summary": "สรุปคำตอบที่ถูกต้อง 1-2 ประโยค",
      "reason": "อธิบายเหตุผลทางการแพทย์อย่างละเอียดว่าทำไมข้อนี้ถูก (2-4 ประโยค) อิง guideline หรือ pathophysiology",
      "choices": [
        {"label": "A", "text": "ตัวเลือก A...", "is_correct": true, "explanation": "ถูกต้อง เพราะ..."},
        {"label": "B", "text": "ตัวเลือก B...", "is_correct": false, "explanation": "ผิด เพราะ..."},
        {"label": "C", "text": "ตัวเลือก C...", "is_correct": false, "explanation": "ผิด เพราะ..."},
        {"label": "D", "text": "ตัวเลือก D...", "is_correct": false, "explanation": "ผิด เพราะ..."},
        {"label": "E", "text": "ตัวเลือก E...", "is_correct": false, "explanation": "ผิด เพราะ..."}
      ],
      "key_takeaway": "ข้อควรจำ/หลักสำคัญจากข้อนี้ที่ควรนำไปใช้สอบ"
    },
    "difficulty": "easy|medium|hard"
  }
]`;
}

async function callClaude(
  apiKey: string,
  model: string,
  maxTokens: number,
  prompt: string,
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

  // Parse JSON
  let cleaned = rawContent.trim();
  if (cleaned.startsWith("```")) {
    cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
  }

  try {
    const parsed = JSON.parse(cleaned);
    if (Array.isArray(parsed)) return parsed;
  } catch {
    const match = rawContent.match(/\[[\s\S]*\]/);
    if (match) {
      try {
        return JSON.parse(match[0]);
      } catch { /* fall through */ }
    }
  }

  throw new Error(`Failed to parse JSON from ${model}`);
}

export async function POST(request: Request) {
  // Verify secret
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  if (secret !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const anthropicApiKey = process.env.ANTHROPIC_API_KEY;
  if (!anthropicApiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  const supabase = await createClient();

  // Determine today's subject based on day-of-year rotation
  const now = new Date();
  const dayOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) / (1000 * 60 * 60 * 24)
  );
  const subjectIndex = dayOfYear % SUBJECTS_ROTATION.length;
  const todaySubject = SUBJECTS_ROTATION[subjectIndex];

  // Get subject ID from database
  const { data: subjectRow } = await supabase
    .from("mcq_subjects")
    .select("id, name_th")
    .eq("name", todaySubject.name)
    .single();

  if (!subjectRow) {
    return NextResponse.json({ error: `Subject ${todaySubject.name} not found` }, { status: 500 });
  }

  // Get count of existing questions for this subject to avoid duplicates
  const { count: existingCount } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  const existing = existingCount ?? 0;

  // Generate both batches in parallel:
  // - Haiku: 21 easy+medium questions (6 easy, 15 medium)
  // - Sonnet: 9 hard questions (deep clinical reasoning)
  const [easyMediumResult, hardResult] = await Promise.allSettled([
    callClaude(
      anthropicApiKey,
      BATCH_CONFIG.easyMedium.model,
      BATCH_CONFIG.easyMedium.maxTokens,
      buildPrompt(
        todaySubject.name_th,
        BATCH_CONFIG.easyMedium.count,
        "สร้างข้อง่าย (easy) 6 ข้อ และข้อปานกลาง (medium) 15 ข้อ — ข้อง่ายเน้น recall ความรู้พื้นฐาน definition, ข้อปานกลางเน้น first-line treatment, investigation of choice, การวินิจฉัยจาก presentation ทั่วไป",
        existing,
      ),
    ),
    callClaude(
      anthropicApiKey,
      BATCH_CONFIG.hard.model,
      BATCH_CONFIG.hard.maxTokens,
      buildPrompt(
        todaySubject.name_th,
        BATCH_CONFIG.hard.count,
        "สร้างเฉพาะข้อยาก (hard) 9 ข้อ — เน้น clinical reasoning ซับซ้อน, differential diagnosis ที่ต้องแยกโรคที่ใกล้เคียงกัน, management ของ case ซับซ้อนที่มี comorbidity, interpretation ของ lab/imaging ที่ต้องวิเคราะห์หลายขั้นตอน, ethical dilemma ทางการแพทย์ เหมือนข้อสอบจริงที่คนส่วนใหญ่ทำผิด",
        existing,
      ),
    ),
  ]);

  // Collect results — proceed even if one batch fails
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
    return NextResponse.json({ error: "All batches failed", details: errors }, { status: 500 });
  }

  // Validate and prepare for insert
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
      exam_source: "AI-generated-daily",
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation || null,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: ["easy", "medium", "hard"].includes(q.difficulty) ? q.difficulty : "medium",
      is_ai_enhanced: true,
      ai_notes: `Auto-generated on ${now.toISOString().split("T")[0]} | ${q.difficulty === "hard" ? "sonnet" : "haiku"}`,
      status: "active" as const,
    }));

  if (validQuestions.length === 0) {
    return NextResponse.json({ error: "No valid questions after validation" }, { status: 500 });
  }

  const { data: inserted, error } = await supabase
    .from("mcq_questions")
    .insert(validQuestions)
    .select("id");

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  // Update question_count for this subject
  const { count: newTotal } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  await supabase
    .from("mcq_subjects")
    .update({ question_count: newTotal ?? 0 })
    .eq("id", subjectRow.id);

  const easyCount = validQuestions.filter((q) => q.difficulty === "easy").length;
  const mediumCount = validQuestions.filter((q) => q.difficulty === "medium").length;
  const hardCount = validQuestions.filter((q) => q.difficulty === "hard").length;

  return NextResponse.json({
    success: true,
    subject: todaySubject.name_th,
    generated: {
      total: validQuestions.length,
      easy: easyCount,
      medium: mediumCount,
      hard: hardCount,
      haiku_batch: easyMediumResult.status === "fulfilled" ? easyMediumResult.value.length : 0,
      sonnet_batch: hardResult.status === "fulfilled" ? hardResult.value.length : 0,
    },
    inserted: inserted?.length ?? 0,
    total_in_subject: newTotal ?? 0,
    ...(errors.length > 0 ? { warnings: errors } : {}),
  });
}
