/**
 * Daily MCQ generator — runs on GitHub Actions
 *
 * Generates 30 MCQ questions/day for a rotating subject:
 * - Haiku (cheap, fast): 21 easy + medium
 * - Sonnet (deep reasoning): 9 hard
 *
 * Required env vars:
 *   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !ANTHROPIC_API_KEY) {
  console.error("Missing required env vars (SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY)");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

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
  { name: "eye", name_th: "จักษุวิทยา" },
  { name: "uro_surgery", name_th: "ศัลยศาสตร์ระบบทางเดินปัสสาวะ" },
  { name: "gi_ped", name_th: "กุมารเวช ทางเดินอาหาร" },
  { name: "gd_ped", name_th: "กุมารเวช พัฒนาการ" },
  { name: "hemato_ped", name_th: "กุมารเวช โลหิตวิทยา" },
  { name: "infectious_ped", name_th: "กุมารเวช โรคติดเชื้อ" },
  { name: "chest_ped", name_th: "กุมารเวช ทรวงอก" },
  { name: "endocrine_ped", name_th: "กุมารเวช ต่อมไร้ท่อ" },
];

const QUESTION_TOOL = {
  name: "submit_mcq_questions",
  description: "Submit a batch of generated MCQ questions",
  input_schema: {
    type: "object",
    properties: {
      questions: {
        type: "array",
        items: {
          type: "object",
          properties: {
            scenario: { type: "string", description: "โจทย์สถานการณ์" },
            choices: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  label: { type: "string", enum: ["A", "B", "C", "D", "E"] },
                  text: { type: "string" },
                },
                required: ["label", "text"],
              },
            },
            correct_answer: { type: "string", enum: ["A", "B", "C", "D", "E"] },
            explanation: { type: "string", description: "สรุปสั้นๆ ว่าทำไมคำตอบนี้ถูก" },
            detailed_explanation: {
              type: "object",
              properties: {
                summary: { type: "string" },
                reason: { type: "string" },
                choices: {
                  type: "array",
                  items: {
                    type: "object",
                    properties: {
                      label: { type: "string" },
                      text: { type: "string" },
                      is_correct: { type: "boolean" },
                      explanation: { type: "string" },
                    },
                    required: ["label", "text", "is_correct", "explanation"],
                  },
                },
                key_takeaway: { type: "string" },
              },
              required: ["summary", "reason", "choices", "key_takeaway"],
            },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: ["scenario", "choices", "correct_answer", "explanation", "difficulty"],
        },
      },
    },
    required: ["questions"],
  },
};

function buildPrompt(subjectNameTh, count, difficultyInstruction, existingCount) {
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน ${subjectNameTh} สำหรับสอบใบประกอบวิชาชีพ (NL Step 2)

สร้างข้อสอบ MCQ จำนวน ${count} ข้อ สาขา ${subjectNameTh} แล้วเรียก tool submit_mcq_questions

กฎ:
1. แต่ละข้อต้องมี scenario ที่มีรายละเอียดเพียงพอ เช่น อายุ เพศ อาการ ผลตรวจ
2. ตัวเลือก 5 ข้อ (A-E) plausible ทั้งหมด
3. คำตอบถูกอิง evidence-based medicine
4. detailed_explanation ต้องอธิบายแต่ละตัวเลือกว่าทำไมถูกหรือผิด
5. ${difficultyInstruction}
6. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในสาขานี้)
7. ภาษาไทยหรืออังกฤษตามความเหมาะสมของเนื้อหาทางการแพทย์
8. ทุกข้อต้องเหมาะสมกับระดับ NL Step 2`;
}

async function callClaude(model, maxTokens, prompt) {
  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model,
      max_tokens: maxTokens,
      tools: [QUESTION_TOOL],
      tool_choice: { type: "tool", name: "submit_mcq_questions" },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude API error (${model}): ${err}`);
  }

  const data = await res.json();
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input?.questions) {
    const blockTypes = (data.content ?? []).map((b) => b.type).join(",") || "(empty)";
    throw new Error(
      `No tool_use questions in response (${model}) — stop_reason=${data.stop_reason} blocks=[${blockTypes}] usage=${JSON.stringify(data.usage)}`
    );
  }
  if (data.stop_reason === "max_tokens") {
    console.warn(`[${model}] hit max_tokens (${maxTokens}); got ${toolUse.input.questions.length} questions, may be truncated`);
  }
  return toolUse.input.questions;
}

async function callClaudeWithRetry(label, model, maxTokens, prompt) {
  for (let attempt = 1; attempt <= 2; attempt++) {
    try {
      return await callClaude(model, maxTokens, prompt);
    } catch (err) {
      const msg = err?.message ?? String(err);
      if (attempt === 2) {
        console.error(`[${label}] failed after retry: ${msg}`);
        throw err;
      }
      console.warn(`[${label}] attempt ${attempt} failed, retrying: ${msg}`);
      await new Promise((r) => setTimeout(r, 2000));
    }
  }
}

async function run() {
  const now = new Date();
  const dayOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) / (1000 * 60 * 60 * 24)
  );
  const todaySubject = SUBJECTS_ROTATION[dayOfYear % SUBJECTS_ROTATION.length];
  console.log(`Today's subject (day ${dayOfYear}): ${todaySubject.name_th} (${todaySubject.name})`);

  const { data: subjectRow, error: subjectErr } = await supabase
    .from("mcq_subjects")
    .select("id, name_th")
    .eq("name", todaySubject.name)
    .single();

  if (subjectErr || !subjectRow) {
    console.error(`Subject ${todaySubject.name} not found in mcq_subjects table`);
    process.exit(1);
  }

  const { count: existingCount } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  const existing = existingCount ?? 0;
  console.log(`Existing questions in this subject: ${existing}`);

  const haikuEasyPrompt = buildPrompt(
    todaySubject.name_th,
    6,
    "สร้างเฉพาะข้อง่าย (easy) 6 ข้อ — เน้น recall ความรู้พื้นฐาน, definition, classic presentation",
    existing,
  );
  const haikuMediumPrompt = buildPrompt(
    todaySubject.name_th,
    15,
    "สร้างเฉพาะข้อปานกลาง (medium) 15 ข้อ — เน้น first-line treatment, investigation of choice, differential ระดับกลาง",
    existing,
  );
  const sonnetPrompt = buildPrompt(
    todaySubject.name_th,
    9,
    "สร้างเฉพาะข้อยาก (hard) 9 ข้อ — เน้น clinical reasoning ซับซ้อน, differential diagnosis, management ของ case ซับซ้อน",
    existing,
  );

  console.log("Calling Haiku-easy (6q) + Haiku-medium (15q) + Sonnet-hard (9q) in parallel...");
  const [haikuEasyResult, haikuMediumResult, sonnetResult] = await Promise.allSettled([
    callClaudeWithRetry("haiku-easy", "claude-haiku-4-5-20251001", 16000, haikuEasyPrompt),
    callClaudeWithRetry("haiku-medium", "claude-haiku-4-5-20251001", 32000, haikuMediumPrompt),
    callClaudeWithRetry("sonnet-hard", "claude-sonnet-4-6", 24000, sonnetPrompt),
  ]);

  const allQuestions = [];
  for (const [label, result] of [
    ["haiku-easy", haikuEasyResult],
    ["haiku-medium", haikuMediumResult],
    ["sonnet-hard", sonnetResult],
  ]) {
    if (result.status === "fulfilled") {
      console.log(`${label}: ${result.value.length} questions`);
      allQuestions.push(...result.value);
    } else {
      console.error(`${label} batch failed: ${result.reason?.message ?? result.reason}`);
    }
  }

  if (allQuestions.length === 0) {
    console.error("All batches failed — nothing to insert");
    process.exit(1);
  }

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
      exam_type: "NL2",
      exam_source: "AI-generated-daily",
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation || null,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: ["easy", "medium", "hard"].includes(q.difficulty) ? q.difficulty : "medium",
      is_ai_enhanced: true,
      ai_notes: `Auto-generated on ${now.toISOString().split("T")[0]} | ${q.difficulty === "hard" ? "sonnet" : "haiku"}`,
      status: "active",
    }));

  console.log(`Valid questions after filter: ${validQuestions.length}/${allQuestions.length}`);

  if (validQuestions.length === 0) {
    console.error("No valid questions after validation");
    process.exit(1);
  }

  const { data: inserted, error: insertErr } = await supabase
    .from("mcq_questions")
    .insert(validQuestions)
    .select("id");

  if (insertErr) {
    console.error(`Insert failed: ${insertErr.message}`);
    process.exit(1);
  }

  // Update question_count on subjects table
  const { count: newTotal } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("subject_id", subjectRow.id)
    .eq("status", "active");

  await supabase
    .from("mcq_subjects")
    .update({ question_count: newTotal ?? 0 })
    .eq("id", subjectRow.id);

  const easy = validQuestions.filter((q) => q.difficulty === "easy").length;
  const medium = validQuestions.filter((q) => q.difficulty === "medium").length;
  const hard = validQuestions.filter((q) => q.difficulty === "hard").length;

  console.log(`Inserted ${inserted?.length ?? 0} questions: easy=${easy} medium=${medium} hard=${hard}`);
  console.log(`Total in subject "${todaySubject.name_th}": ${newTotal ?? 0}`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
