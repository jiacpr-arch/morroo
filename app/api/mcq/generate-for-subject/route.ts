import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

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
  easyCount: number,
  mediumCount: number,
  hardCount: number,
  existingCount: number
): string {
  const total = easyCount + mediumCount + hardCount;
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${subjectNameTh} สำหรับสอบใบประกอบวิชาชีพ (National License Exam - NL Step 2)

สร้างข้อสอบ MCQ จำนวน ${total} ข้อ สาขา ${subjectNameTh}
แบ่งเป็น:
- Easy ${easyCount} ข้อ: เน้น recall ความรู้พื้นฐาน definition
- Medium ${mediumCount} ข้อ: first-line treatment, investigation of choice, การวินิจฉัยจาก typical presentation
- Hard ${hardCount} ข้อ: clinical reasoning ซับซ้อน, differential diagnosis, management ของ case ที่มี comorbidity

กฎ:
1. แต่ละข้อมี scenario ที่มีรายละเอียดเพียงพอ (อายุ เพศ อาการ ผลตรวจ)
2. ตัวเลือก 5 ข้อ (A-E) plausible ทั้งหมด
3. คำตอบถูกต้องอิง evidence-based medicine
4. คำอธิบายเฉลยละเอียด อธิบายทุกตัวเลือก
5. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในระบบ)
6. เขียนภาษาไทยหรืออังกฤษตามความเหมาะสมของเนื้อหาทางการแพทย์
7. ทุกข้อเหมาะสำหรับ NL Step 2

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

  try {
    const parsed = JSON.parse(cleaned);
    if (Array.isArray(parsed)) return parsed;
  } catch {
    const match = rawContent.match(/\[[\s\S]*\]/);
    if (match) {
      try {
        return JSON.parse(match[0]);
      } catch {
        /* fall through */
      }
    }
  }
  throw new Error(`Failed to parse JSON from ${model}`);
}

// POST /api/mcq/generate-for-subject
// Query: ?secret=xxx
// Body: { subject_name?: string, fill_empty?: boolean, count?: number }
//
// subject_name  — generate for one specific subject
// fill_empty    — generate for ALL subjects with 0 questions (ignores subject_name)
// count         — questions per subject (default 30)
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

  // Determine which subjects to process
  let targets: { name: string; name_th: string }[] = [];

  if (body.fill_empty) {
    // Find subjects with 0 active questions
    const { data: subjectRows } = await admin
      .from("mcq_subjects")
      .select("name, name_th, id");

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
        targets.push({ name: row.name, name_th: row.name_th });
      }
    }

    if (targets.length === 0) {
      return NextResponse.json({
        success: true,
        message: "ทุกสาขามีข้อสอบแล้ว ไม่มีสาขาว่าง",
      });
    }
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
    targets = [found];
  } else {
    return NextResponse.json(
      {
        error:
          'ต้องระบุ subject_name หรือ fill_empty:true ใน body',
      },
      { status: 400 }
    );
  }

  // Generate for each target subject sequentially (avoid rate-limit)
  const results: Record<
    string,
    { inserted: number; errors: string[] } | { error: string }
  > = {};

  for (const subject of targets) {
    // Get subject row
    const { data: subjectRow } = await admin
      .from("mcq_subjects")
      .select("id")
      .eq("name", subject.name)
      .single();

    if (!subjectRow) {
      results[subject.name] = { error: "Subject not found in DB" };
      continue;
    }

    const { count: existingCount } = await admin
      .from("mcq_questions")
      .select("id", { count: "exact", head: true })
      .eq("subject_id", subjectRow.id)
      .eq("status", "active");

    const existing = existingCount ?? 0;

    // Split: 20% easy, 50% medium, 30% hard
    const easyCount = Math.round(perSubjectCount * 0.2);
    const hardCount = Math.round(perSubjectCount * 0.3);
    const mediumCount = perSubjectCount - easyCount - hardCount;

    const errors: string[] = [];
    let questions: GeneratedQuestion[] = [];

    try {
      questions = await callClaude(
        apiKey,
        "claude-sonnet-4-6-20250514", // Use Sonnet for quality on initial fill
        32000,
        buildPrompt(subject.name_th, easyCount, mediumCount, hardCount, existing)
      );
    } catch (err) {
      errors.push(String(err));
      results[subject.name] = { error: String(err) };
      continue;
    }

    const now = new Date();
    const validQuestions = questions
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
        ai_notes: `Auto-fill on ${now.toISOString().split("T")[0]} | sonnet`,
        status: "active" as const,
      }));

    if (validQuestions.length === 0) {
      results[subject.name] = { error: "No valid questions after validation" };
      continue;
    }

    const { data: inserted, error: insertError } = await admin
      .from("mcq_questions")
      .insert(validQuestions)
      .select("id");

    if (insertError) {
      results[subject.name] = { error: insertError.message };
      continue;
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

    results[subject.name] = { inserted: inserted?.length ?? 0, errors };
  }

  return NextResponse.json({
    success: true,
    subjects_processed: targets.length,
    results,
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
