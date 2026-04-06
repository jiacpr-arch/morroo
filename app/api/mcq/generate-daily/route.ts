import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

// Generate 10 MCQ questions per subject, rotating through subjects daily
// Each day picks a different subject so all subjects get covered over time

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
];

const QUESTIONS_PER_BATCH = 10;

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

  // Generate MCQ questions with Claude — includes detailed_explanation
  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${todaySubject.name_th} สำหรับสอบใบประกอบวิชาชีพ (National License Exam - NL Step 2)

สร้างข้อสอบ MCQ จำนวน ${QUESTIONS_PER_BATCH} ข้อ สาขา ${todaySubject.name_th}

กฎ:
1. แต่ละข้อต้องมี scenario (โจทย์สถานการณ์) ที่มีรายละเอียดเพียงพอ เช่น อายุ เพศ อาการ ผลตรวจ
2. ตัวเลือก 5 ข้อ (A-E) ที่เป็น plausible ทั้งหมด ไม่มีตัวเลือกมั่วๆ
3. คำตอบถูกต้องต้องอิง evidence-based medicine
4. คำอธิบายเฉลยต้องละเอียด อธิบายว่าทำไมคำตอบนั้นถูก และทำไมตัวเลือกอื่นผิดทีละข้อ
5. ความยากคละกัน: 3 ข้อง่าย, 4 ข้อปานกลาง, 3 ข้อยาก
6. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount ?? 0} ข้อในระบบ)
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

  const claudeRes = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": anthropicApiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 16000,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!claudeRes.ok) {
    const err = await claudeRes.text();
    return NextResponse.json({ error: "Claude API error", details: err }, { status: 500 });
  }

  const claudeData = await claudeRes.json();
  const rawContent: string = claudeData.content?.[0]?.text ?? "";

  if (!rawContent) {
    return NextResponse.json({ error: "Empty content from Claude" }, { status: 500 });
  }

  // Parse JSON from response
  let questions: Array<{
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
  }>;

  try {
    let cleaned = rawContent.trim();
    if (cleaned.startsWith("```")) {
      cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
    }
    questions = JSON.parse(cleaned);
  } catch {
    // Try to extract JSON array
    const match = rawContent.match(/\[[\s\S]*\]/);
    if (match) {
      try {
        questions = JSON.parse(match[0]);
      } catch {
        return NextResponse.json({ error: "Failed to parse AI response", raw: rawContent.slice(0, 500) }, { status: 500 });
      }
    } else {
      return NextResponse.json({ error: "No JSON array in AI response" }, { status: 500 });
    }
  }

  if (!Array.isArray(questions) || questions.length === 0) {
    return NextResponse.json({ error: "No questions generated" }, { status: 500 });
  }

  // Validate and insert questions
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
      exam_source: "AI-generated-daily",
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation || null,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: ["easy", "medium", "hard"].includes(q.difficulty) ? q.difficulty : "medium",
      is_ai_enhanced: true,
      ai_notes: `Auto-generated on ${now.toISOString().split("T")[0]}`,
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

  return NextResponse.json({
    success: true,
    subject: todaySubject.name_th,
    generated: validQuestions.length,
    inserted: inserted?.length ?? 0,
    total_in_subject: newTotal ?? 0,
  });
}
