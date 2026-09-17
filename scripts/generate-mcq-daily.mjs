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
import { generateWithTool, resolveEasyMediumProvider, CLAUDE_DEFAULT_MODEL } from "./lib/llm.mjs";

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
            scenario: {
              type: "string",
              description:
                "โจทย์สถานการณ์ผู้ป่วย เขียนด้วยภาษาไทยทางคลินิกที่อ่านลื่นเหมือนข้อสอบจริง (อายุ เพศ อาการสำคัญ ประวัติ ตรวจร่างกาย ผลตรวจที่จำเป็น) ปิดท้ายด้วยคำถามที่ชัดเจน",
            },
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
            explanation: {
              type: "string",
              description:
                "เฉลยหลัก 2-3 ประโยค: คำตอบที่ถูกคืออะไร และเหตุผลสำคัญที่สุด (ไม่ใช่สรุปสั้นบรรทัดเดียว)",
            },
            detailed_explanation: {
              type: "object",
              properties: {
                summary: { type: "string", description: "1 ประโยค: คำตอบที่ถูกคืออะไร" },
                reason: {
                  type: "string",
                  description:
                    "เหตุผลโดยละเอียดอย่างน้อย 3 ประโยค: key finding ในโจทย์ → พยาธิสรีรวิทยา/หลักการ → ทำไมนำไปสู่คำตอบนี้",
                },
                choices: {
                  type: "array",
                  description: "ครบทุกตัวเลือก A-E",
                  items: {
                    type: "object",
                    properties: {
                      label: { type: "string" },
                      text: { type: "string" },
                      is_correct: { type: "boolean" },
                      explanation: {
                        type: "string",
                        description:
                          "อย่างน้อย 2 ประโยค: ตัวเลือกนี้คืออะไร และทำไมถูก/ผิดสำหรับผู้ป่วยรายนี้โดยเฉพาะ",
                      },
                    },
                    required: ["label", "text", "is_correct", "explanation"],
                  },
                },
                key_takeaway: { type: "string", description: "1-2 ประโยค high-yield ที่ควรจำไปสอบ" },
              },
              required: ["summary", "reason", "choices", "key_takeaway"],
            },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: [
            "scenario",
            "choices",
            "correct_answer",
            "explanation",
            "detailed_explanation",
            "difficulty",
          ],
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
3. คำตอบถูกอิง evidence-based medicine และแนวทางที่ใช้ในประเทศไทย
4. detailed_explanation ต้องมีครบทุกข้อ: reason อย่างน้อย 3 ประโยค, อธิบายทุกตัวเลือกอย่างน้อย 2 ประโยคว่าทำไมถูก/ผิดในบริบทผู้ป่วยรายนี้, key_takeaway ที่ควรจำไปสอบ
5. ${difficultyInstruction}
6. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในสาขานี้)
7. ภาษา: โจทย์และเฉลยเป็นภาษาไทยทางคลินิกที่อ่านลื่นเหมือนข้อสอบจริง ศัพท์แพทย์ใช้ภาษาอังกฤษในวงเล็บ (เช่น จุดเลือดออกใต้ผิวหนัง (petechiae)) ห้ามแปลศัพท์เทคนิคแบบแข็งๆ หรือประโยคที่คนไทยไม่พูด
8. ทุกข้อต้องเหมาะสมกับระดับ NL Step 2`;
}

async function generateQuestions(label, target, maxTokens, prompt) {
  const res = await generateWithTool({
    ...target,
    maxTokens,
    prompt,
    tool: QUESTION_TOOL,
    label,
  });
  const questions = res.data?.questions;
  if (!Array.isArray(questions) || questions.length === 0) {
    throw new Error(`[${label}] response missing questions array (${res.provider}:${res.model})`);
  }
  return { questions, tag: `${res.provider}:${res.model}` };
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

  const easyMediumTarget = resolveEasyMediumProvider();
  const hardTarget = { provider: "anthropic", model: CLAUDE_DEFAULT_MODEL };
  console.log(
    `easy/medium → ${easyMediumTarget.provider}:${easyMediumTarget.model}, hard → ${hardTarget.provider}:${hardTarget.model}`
  );
  console.log("Calling easy (6q) + medium (15q) + hard (9q) in parallel...");
  const [easyResult, mediumResult, hardResult] = await Promise.allSettled([
    // Sonnet 5 runs adaptive thinking by default, which shares the same
    // max_tokens budget as the visible output — a live test run showed 15q
    // at 32000 and 9q at 24000 both hitting the limit mid-tool-call (now
    // that required detailed_explanation makes each question much larger,
    // thinking + JSON output together need more headroom than Haiku/Sonnet
    // 4.6 ever did). Streaming (see llm.mjs) means a bigger ceiling costs
    // nothing but avoided truncation — billing is by tokens actually used.
    generateQuestions("easy", easyMediumTarget, 24000, haikuEasyPrompt),
    generateQuestions("medium", easyMediumTarget, 64000, haikuMediumPrompt),
    generateQuestions("hard", hardTarget, 48000, sonnetPrompt),
  ]);

  const allQuestions = [];
  for (const [label, result] of [
    ["easy", easyResult],
    ["medium", mediumResult],
    ["hard", hardResult],
  ]) {
    if (result.status === "fulfilled") {
      console.log(`${label}: ${result.value.questions.length} questions (${result.value.tag})`);
      for (const q of result.value.questions) {
        allQuestions.push({ ...q, gen_tag: result.value.tag });
      }
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
      ai_notes: `Auto-generated on ${now.toISOString().split("T")[0]} | ${q.gen_tag}`,
      status: "active",
    }));

  console.log(`Valid questions after filter: ${validQuestions.length}/${allQuestions.length}`);

  if (validQuestions.length === 0) {
    console.error("No valid questions after validation");
    process.exit(1);
  }

  if (process.env.DRY_RUN) {
    // Print enough to judge quality from the CI log: every stem, plus the
    // first question of each difficulty in full.
    console.log(`[dry-run] would insert ${validQuestions.length} questions (nothing written).`);
    const missingDetailed = validQuestions.filter((q) => !q.detailed_explanation).length;
    console.log(`[dry-run] missing detailed_explanation: ${missingDetailed}`);
    for (const q of validQuestions) {
      const choiceExpl = q.detailed_explanation?.choices?.map((c) => c.explanation?.length ?? 0) ?? [];
      console.log(
        `[dry-run] ${q.difficulty.padEnd(6)} | expl ${String(q.explanation?.length ?? 0).padStart(4)} ch | reason ${String(q.detailed_explanation?.reason?.length ?? 0).padStart(4)} ch | choices ${choiceExpl.join("/")} ch | ${q.scenario.replace(/\s+/g, " ").slice(0, 140)}`
      );
    }
    for (const level of ["easy", "medium", "hard"]) {
      const sample = validQuestions.find((q) => q.difficulty === level);
      if (!sample) continue;
      console.log(`\n[dry-run] ===== full sample: ${level} =====`);
      console.log(JSON.stringify(sample, null, 2));
    }
    return;
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
