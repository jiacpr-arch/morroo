/**
 * Weekly Long Case generator — runs on GitHub Actions (Sunday)
 *
 * Generates 1 long case exam per run, rotating specialty by week.
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

const SPECIALTIES = [
  "Medicine", "Surgery", "Pediatrics", "Obstetrics",
  "Orthopedics", "Psychiatry", "Emergency", "Cardiology",
];

const LONG_CASE_TOOL = {
  name: "submit_long_case",
  description: "Submit a generated long case exam",
  input_schema: {
    type: "object",
    properties: {
      title: { type: "string" },
      difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
      patient_info: {
        type: "object",
        properties: {
          age: { type: "integer" },
          gender: { type: "string" },
          setting: { type: "string" },
          appearance: { type: "string" },
        },
        required: ["age", "gender", "setting", "appearance"],
      },
      history_script: {
        type: "object",
        properties: {
          chief_complaint: { type: "string" },
          hpi: { type: "string" },
          past_medical: { type: "string" },
          medications: { type: "string" },
          allergies: { type: "string" },
          family_history: { type: "string" },
          social_history: { type: "string" },
          review_of_systems: { type: "string" },
        },
        required: ["chief_complaint", "hpi"],
      },
      pe_findings: { type: "object", description: "Map of system → findings text" },
      lab_results: { type: "object", description: "Map of test name → results" },
      imaging_results: { type: "object", description: "Map of imaging type → result", nullable: true },
      correct_diagnosis: { type: "string" },
      accepted_ddx: { type: "array", items: { type: "string" } },
      management_plan: { type: "string" },
      teaching_points: { type: "array", items: { type: "string" } },
      examiner_questions: { type: "array", items: { type: "string" } },
      scoring_rubric: {
        type: "object",
        properties: {
          history: { type: "integer" },
          pe: { type: "integer" },
          lab: { type: "integer" },
          ddx: { type: "integer" },
          management: { type: "integer" },
        },
      },
    },
    required: [
      "title", "patient_info", "history_script", "pe_findings", "lab_results",
      "correct_diagnosis", "accepted_ddx", "management_plan", "teaching_points",
      "examiner_questions",
    ],
  },
};

async function run() {
  const now = new Date();
  const weekOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 1).getTime()) / (7 * 24 * 60 * 60 * 1000)
  );
  const specialty = SPECIALTIES[weekOfYear % SPECIALTIES.length];

  console.log(`Week ${weekOfYear} → specialty="${specialty}"`);

  const { count: existingCount } = await supabase
    .from("long_cases")
    .select("id", { count: "exact", head: true })
    .eq("specialty", specialty);

  console.log(`Existing long cases in this specialty: ${existingCount ?? 0}`);

  const prompt = `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญสาขา ${specialty} สร้าง Long Case Exam สำหรับสอบใบประกอบวิชาชีพ

สร้าง 1 Long Case จำลองผู้ป่วยจริง ให้นักศึกษาฝึกซักประวัติ ตรวจร่างกาย สั่ง Lab/Imaging วินิจฉัยแยกโรค วางแผนการรักษา ตอบ Examiner แล้วเรียก tool submit_long_case

กฎ:
1. สาขา: ${specialty}
2. ความยาก: medium หรือ hard
3. ห้ามซ้ำกับที่มี (มี ${existingCount ?? 0} cases แล้ว)
4. สมจริง รายละเอียดทางคลินิกครบถ้วน
5. patient_info: ข้อมูลก่อนเริ่ม (อายุ เพศ สถานที่ ลักษณะ — ไม่บอก chief complaint)
6. history_script: ประวัติทั้งหมดที่ AI Patient จะตอบ
7. pe_findings: object map ระบบ → ผลตรวจ (General, Cardiovascular, Respiratory, Abdomen, Neurological, Extremities, HEENT)
8. lab_results: object map ชื่อ test → ผล
9. ภาษาไทย (medical terms อังกฤษได้)
10. teaching_points: 3-5 จุด, examiner_questions: 3-5 ข้อ
11. scoring_rubric: history 25, pe 20, lab 15, ddx 20, management 20`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6-20250514",
      max_tokens: 8000,
      tools: [LONG_CASE_TOOL],
      tool_choice: { type: "tool", name: "submit_long_case" },
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

  const longCase = toolUse.input;
  if (!longCase.title || !longCase.patient_info || !longCase.history_script) {
    console.error("Invalid long case structure");
    process.exit(1);
  }

  console.log(`Generated: "${longCase.title}"`);

  // Get next week_number
  const { data: maxWeek } = await supabase
    .from("long_cases")
    .select("week_number")
    .order("week_number", { ascending: false })
    .limit(1)
    .maybeSingle();

  const nextWeek = ((maxWeek?.week_number ?? 0)) + 1;

  const { data: inserted, error } = await supabase
    .from("long_cases")
    .insert({
      title: longCase.title,
      specialty,
      difficulty: longCase.difficulty || "medium",
      week_number: nextWeek,
      is_weekly: true,
      is_published: true,
      patient_info: longCase.patient_info,
      history_script: longCase.history_script,
      pe_findings: longCase.pe_findings || {},
      lab_results: longCase.lab_results || {},
      imaging_results: longCase.imaging_results || null,
      correct_diagnosis: longCase.correct_diagnosis || "",
      accepted_ddx: longCase.accepted_ddx || [],
      management_plan: longCase.management_plan || "",
      teaching_points: longCase.teaching_points || [],
      examiner_questions: longCase.examiner_questions || [],
      scoring_rubric: longCase.scoring_rubric || { history: 25, pe: 20, lab: 15, ddx: 20, management: 20 },
    })
    .select("id")
    .single();

  if (error || !inserted) {
    console.error(`Insert failed: ${error?.message ?? "unknown"}`);
    process.exit(1);
  }

  console.log(`Saved long case id=${inserted.id} week=${nextWeek}`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
