/**
 * Weekly MEQ generator — runs on GitHub Actions (Mon + Thu)
 *
 * Generates 1 progressive case exam (6 parts) per run.
 * Rotates category and difficulty by week-of-year.
 *
 * Required env vars: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !ANTHROPIC_API_KEY) {
  console.error("Missing required env vars");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

const CATEGORIES = [
  "อายุรศาสตร์",
  "ศัลยศาสตร์",
  "กุมารเวชศาสตร์",
  "สูติศาสตร์-นรีเวชวิทยา",
  "ออร์โธปิดิกส์",
  "จิตเวชศาสตร์",
];

const DIFFICULTIES = ["easy", "medium", "hard"];

const EXAM_TOOL = {
  name: "submit_meq_exam",
  description: "Submit a generated MEQ progressive case exam",
  input_schema: {
    type: "object",
    properties: {
      title: { type: "string", description: "ชื่อ case เช่น 'ชาย 55 ปี อาเจียนเป็นเลือด'" },
      parts: {
        type: "array",
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
  const weekOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 1).getTime()) / (7 * 24 * 60 * 60 * 1000)
  );
  const dayOfWeek = now.getUTCDay(); // 0=Sun, 1=Mon, 4=Thu
  const categoryIndex = (weekOfYear * 2 + (dayOfWeek >= 4 ? 1 : 0)) % CATEGORIES.length;
  const category = CATEGORIES[categoryIndex];
  const difficulty = DIFFICULTIES[(weekOfYear + (dayOfWeek >= 4 ? 1 : 0)) % 3];

  console.log(`Week ${weekOfYear} day ${dayOfWeek} → category="${category}" difficulty="${difficulty}"`);

  const { count: existingCount } = await supabase
    .from("exams")
    .select("id", { count: "exact", head: true })
    .eq("category", category);

  console.log(`Existing exams in this category: ${existingCount ?? 0}`);

  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${category} สร้างข้อสอบ MEQ Progressive Case สำหรับสอบ NL Step 2

สร้าง 1 ข้อสอบ MEQ ที่มี 6 ตอน (parts) ต่อเนื่องกัน แล้วเรียก tool submit_meq_exam

กฎ:
1. สาขา: ${category}
2. ความยาก: ${difficulty === "easy" ? "ง่าย" : difficulty === "hard" ? "ยาก" : "ปานกลาง"}
3. เรื่องต้องไม่ซ้ำกับที่มี (มี ${existingCount ?? 0} ข้อในสาขานี้แล้ว)
4. ตอนที่ 1: ประวัติเบื้องต้น + vital signs → ถาม initial assessment
5. ตอนที่ 2: ผล lab/investigation → ถาม interpretation
6. ตอนที่ 3: เพิ่ม clinical progression → ถาม differential diagnosis
7. ตอนที่ 4: ผล imaging/special test → ถาม definitive diagnosis
8. ตอนที่ 5: ถาม management plan
9. ตอนที่ 6: complication หรือ follow-up → ถาม long-term management
10. แต่ละตอน: scenario, question, answer (ละเอียด evidence-based), key_points (3-5 จุดสำคัญ), time_minutes (default 10)
11. ภาษาไทย (medical term ภาษาอังกฤษได้)`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 8000,
      tools: [EXAM_TOOL],
      tool_choice: { type: "tool", name: "submit_meq_exam" },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    console.error(`Claude API error: ${await res.text()}`);
    process.exit(1);
  }

  const data = await res.json();
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input) {
    console.error("No tool_use in response");
    process.exit(1);
  }

  const exam = toolUse.input;
  if (!exam.title || !Array.isArray(exam.parts) || exam.parts.length < 4) {
    console.error("Invalid exam structure");
    process.exit(1);
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

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
