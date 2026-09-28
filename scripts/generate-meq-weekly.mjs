/**
 * Weekly MEQ generator — runs on GitHub Actions (Mon + Thu)
 *
 * Generates 1 progressive case exam (6 parts) per run.
 * Rotates category and difficulty by week-of-year.
 *
 * Required env vars: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import { createClient } from "@supabase/supabase-js";
import { notifyCronFailure } from "./cron-notify.mjs";
import {
  pickMeqSlot,
  isDuplicateMeqTitle,
  existingCasesPromptBlock,
} from "../lib/meq-schedule.mjs";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !ANTHROPIC_API_KEY) {
  console.error("Missing required env vars");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

const EXAM_TOOL = {
  name: "submit_meq_exam",
  description: "Submit a generated MEQ progressive case exam",
  input_schema: {
    type: "object",
    properties: {
      title: {
        type: "string",
        description:
          "ชื่อ case จากอาการนำ เช่น 'ชาย 55 ปี อาเจียนเป็นเลือด' — ห้ามมีชื่อโรค การวินิจฉัย หรือตัวย่อโรคในชื่อ (เช่น ห้ามใช้คำว่า 'DKA', 'Upper GI Bleeding', 'ไส้ติ่งอักเสบ') เพราะข้อสอบให้ผู้เรียนวินิจฉัยเอง",
      },
      parts: {
        type: "array",
        minItems: 6,
        maxItems: 6,
        items: {
          type: "object",
          properties: {
            part_number: { type: "integer", minimum: 1, maximum: 6 },
            title: { type: "string" },
            scenario: { type: "string" },
            question: { type: "string" },
            answer: { type: "string", description: "เฉลยละเอียด evidence-based" },
            key_points: { type: "array", items: { type: "string" } },
            time_minutes: { type: "integer" },
          },
          required: ["part_number", "title", "scenario", "question", "answer", "key_points"],
        },
      },
    },
    required: ["title", "parts"],
  },
};

async function run() {
  const now = new Date();
  const { weekOfYear, dayOfWeek, category, difficulty } = pickMeqSlot(now);

  console.log(`Week ${weekOfYear} day ${dayOfWeek} → category="${category}" difficulty="${difficulty}"`);

  // Pass existing titles to the model (a bare count wasn't enough — it kept
  // regenerating the same few cases) and reject exact/near-duplicate titles.
  const { data: existingRows, error: existingError } = await supabase
    .from("exams")
    .select("title")
    .eq("category", category)
    .order("created_at", { ascending: false })
    .limit(300);
  if (existingError) {
    throw new Error(`Failed to load existing exams: ${existingError.message}`);
  }
  const existingTitles = (existingRows ?? []).map((r) => r.title).filter(Boolean);
  console.log(`Existing exams in this category: ${existingTitles.length}`);

  const MAX_ATTEMPTS = 3;
  const rejected = [];
  let exam = null;
  for (let attempt = 1; attempt <= MAX_ATTEMPTS && !exam; attempt++) {
    const candidate = await generateExam(category, difficulty, [...existingTitles, ...rejected]);
    if (isDuplicateMeqTitle(candidate.title, existingTitles)) {
      console.warn(`Attempt ${attempt}: duplicate title "${candidate.title}" — retrying`);
      rejected.push(candidate.title);
      continue;
    }
    exam = candidate;
  }
  if (!exam) {
    throw new Error(`Model kept generating duplicate cases: ${rejected.join(" | ")}`);
  }

  console.log(`Generated: "${exam.title}" with ${exam.parts.length} parts`);

  const publishDate = now.toISOString().split("T")[0];

  const { data: examRow, error: examError } = await supabase
    .from("exams")
    .insert({
      title: exam.title,
      category,
      difficulty,
      status: "published",
      is_free: false,
      publish_date: publishDate,
      created_by: "ai-auto",
    })
    .select("id")
    .single();

  if (examError || !examRow) {
    console.error(`Exam insert failed: ${examError?.message ?? "unknown"}`);
    process.exit(1);
  }

  const parts = exam.parts.map((p) => ({
    exam_id: examRow.id,
    part_number: p.part_number,
    title: p.title,
    scenario: p.scenario,
    question: p.question,
    answer: p.answer,
    key_points: p.key_points || [],
    time_minutes: p.time_minutes || 10,
  }));

  const { error: partsError } = await supabase.from("exam_parts").insert(parts);
  if (partsError) {
    // Rollback the exam row to avoid orphaned exam without parts
    await supabase.from("exams").delete().eq("id", examRow.id);
    console.error(`Parts insert failed: ${partsError.message} (rolled back exam)`);
    process.exit(1);
  }

  console.log(`Saved exam id=${examRow.id} with ${parts.length} parts`);
}

async function generateExam(category, difficulty, existingTitles) {
  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${category} สร้างข้อสอบ MEQ Progressive Case สำหรับสอบ NL Step 2

สร้าง 1 ข้อสอบ MEQ ที่มี 6 ตอน (parts) ต่อเนื่องกัน แล้วเรียก tool submit_meq_exam

กฎ:
1. สาขา: ${category}
2. ความยาก: ${difficulty === "easy" ? "ง่าย" : difficulty === "hard" ? "ยาก" : "ปานกลาง"}
3. เรื่องต้องไม่ซ้ำกับเคสที่มีอยู่แล้ว (ดูรายการด้านล่าง)
4. ตอนที่ 1: ประวัติเบื้องต้น + vital signs → ถาม initial assessment
5. ตอนที่ 2: ผล lab/investigation → ถาม interpretation
6. ตอนที่ 3: เพิ่ม clinical progression → ถาม differential diagnosis
7. ตอนที่ 4: ผล imaging/special test → ถาม definitive diagnosis
8. ตอนที่ 5: ถาม management plan
9. ตอนที่ 6: complication หรือ follow-up → ถาม long-term management
10. แต่ละตอน: scenario, question, answer (ละเอียด evidence-based), key_points (3-5 จุดสำคัญ), time_minutes (default 10)
11. ภาษาไทย (medical term ภาษาอังกฤษได้)
12. ห้ามเฉลยการวินิจฉัยในชื่อข้อสอบ (title) เด็ดขาด — ตั้งชื่อจากอาการนำ/สถานการณ์ผู้ป่วยเท่านั้น (เช่น "ชาย 55 ปี อาเจียนเป็นเลือด") ห้ามมีชื่อโรค คำวินิจฉัย หรือตัวย่อโรคปรากฏในชื่อ เพราะจะสปอยล์คำตอบก่อนผู้เรียนเริ่มทำข้อสอบ
${existingCasesPromptBlock(existingTitles)}`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      // 6 parts × (scenario + question + detailed answer + key_points) blows
      // through 8k tokens; we hit max_tokens mid-output and only "title"
      // came back. 32k matches the MCQ Sonnet batch.
      max_tokens: 32000,
      tools: [EXAM_TOOL],
      tool_choice: { type: "tool", name: "submit_meq_exam" },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    throw new Error(`Claude API error: ${await res.text()}`);
  }

  const data = await res.json();
  console.log(`Claude stop_reason: ${data.stop_reason} (usage: in=${data.usage?.input_tokens} out=${data.usage?.output_tokens})`);
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input) {
    throw new Error("No tool_use in response");
  }

  const exam = toolUse.input;
  if (!exam.title || !Array.isArray(exam.parts) || exam.parts.length < 4) {
    console.error("Invalid exam structure:");
    console.error(`  title: ${exam.title ?? "(missing)"}`);
    console.error(`  parts: ${Array.isArray(exam.parts) ? `${exam.parts.length} items` : typeof exam.parts}`);
    console.error(`  raw input keys: ${Object.keys(exam).join(", ")}`);
    throw new Error("Invalid exam structure");
  }

  return exam;
}

run().catch(async (err) => {
  console.error("Fatal:", err);
  await notifyCronFailure("generate-meq-weekly", err);
  process.exit(1);
});
