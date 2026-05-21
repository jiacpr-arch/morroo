/**
 * Daily Board Oral (Long Case) generator — runs on GitHub Actions
 *
 * Generates 1 board oral exam case/day, rotating through every active
 * board_specialty (12 specialties → ~12-day cycle per specialty).
 *
 * Uses Sonnet because oral cases need structured reasoning + multi-section
 * coherence (history → PE → labs → DDx → management → examiner Qs).
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

// Mirrors lib/board-references.ts — keep in sync
const SPECIALTY_REFERENCE = {
  emergency_medicine: "Tintinalli's Emergency Medicine 9e + AHA/ACEP guidelines",
  internal_medicine: "Harrison's Principles of Internal Medicine 21e + relevant society guidelines (AHA, ADA, KDIGO)",
  surgery: "Schwartz's Principles of Surgery 11e / Sabiston 21e + NCCN guidelines",
  pediatrics: "Nelson Textbook of Pediatrics 22e + AAP guidelines + แนวทางราชวิทยาลัยกุมารฯ",
  ob_gyn: "Williams Obstetrics 26e / Williams Gynecology 4e + ACOG / RCOG guidelines",
  orthopedics: "Campbell's Operative Orthopedics 14e / Rockwood and Green's 9e + AAOS guidelines",
  psychiatry: "Kaplan & Sadock's Synopsis of Psychiatry 12e + DSM-5-TR + APA guidelines",
  anesthesiology: "Miller's Anesthesia 9e + Stoelting's 8e + ASA guidelines",
  radiology: "Brant and Helms' Fundamentals of Diagnostic Radiology 5e + ACR appropriateness criteria",
  family_medicine: "Williams Manual of Family Medicine + USPSTF + AAFP guidelines",
  pathology: "Robbins and Cotran 10e + Rosai and Ackerman's 11e + WHO classifications",
  rehab_medicine: "DeLisa's PM&R 6e + Braddom's PM&R 6e",
};

const ORAL_CASE_TOOL = {
  name: "submit_board_oral_case",
  description: "Submit a fully-structured board oral exam (long case) for the rotation",
  input_schema: {
    type: "object",
    properties: {
      title: {
        type: "string",
        description: "Thai title in pattern: '<age><gender> <chief complaint>' เช่น 'ชาย 45 ปี เจ็บอกร้าวหลัง'",
      },
      difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
      patient_info: {
        type: "object",
        properties: {
          name: { type: "string" },
          age: { type: "number" },
          gender: { type: "string", enum: ["ชาย", "หญิง"] },
          underlying: { type: "array", items: { type: "string" } },
          allergies: { type: "array", items: { type: "string" } },
          vitals: {
            type: "object",
            properties: {
              bp: { type: "string" },
              hr: { type: "number" },
              rr: { type: "number" },
              temp: { type: "number" },
              o2sat: { type: "number" },
            },
            required: ["bp", "hr", "rr", "temp", "o2sat"],
          },
        },
        required: ["name", "age", "gender", "vitals"],
      },
      history_script: {
        type: "object",
        properties: {
          cc: { type: "string", description: "chief complaint Thai" },
          onset: { type: "string" },
          pi: { type: "string", description: "present illness รายละเอียดที่ AI ผู้ป่วยจะใช้ตอบ" },
          pmh: { type: "string" },
          sh: { type: "string" },
        },
        required: ["cc", "onset", "pi", "pmh", "sh"],
      },
      pe_findings: {
        type: "object",
        description: "Key-value: ระบบ -> finding. รวม GA, ระบบหลักที่เกี่ยวกับเคส",
      },
      lab_results: {
        type: "object",
        description: "Key-value: lab name -> { value, isAbnormal }",
      },
      imaging_results: {
        type: "object",
        description: "Optional. Key-value: imaging name -> { value, isAbnormal }",
      },
      correct_diagnosis: { type: "string" },
      accepted_ddx: { type: "array", items: { type: "string" }, minItems: 3 },
      management_plan: { type: "string" },
      teaching_points: { type: "array", items: { type: "string" }, minItems: 4 },
      examiner_questions: {
        type: "array",
        minItems: 5,
        items: {
          type: "object",
          properties: {
            question: { type: "string", description: "คำถามระดับ board ที่ challenge candidate" },
            modelAnswer: { type: "string", description: "เฉลย รายละเอียดพร้อม evidence" },
            points: { type: "number" },
          },
          required: ["question", "modelAnswer", "points"],
        },
      },
      scoring_rubric: {
        type: "object",
        description: "weights ที่รวมกัน = 100. ตัวอย่าง: history:20, pe:20, lab:15, ddx:20, management:25",
        properties: {
          history: { type: "number" },
          pe: { type: "number" },
          lab: { type: "number" },
          ddx: { type: "number" },
          management: { type: "number" },
        },
        required: ["history", "pe", "lab", "ddx", "management"],
      },
    },
    required: [
      "title", "difficulty", "patient_info", "history_script",
      "pe_findings", "lab_results", "correct_diagnosis", "accepted_ddx",
      "management_plan", "teaching_points", "examiner_questions",
      "scoring_rubric",
    ],
  },
};

function buildPrompt({ specialtyNameTh, specialtySlug, existingTitles, difficulty }) {
  const reference =
    SPECIALTY_REFERENCE[specialtySlug] ??
    "ตำราหลักของสาขาและ guideline ปัจจุบัน";
  const recent =
    existingTitles.length > 0
      ? `ห้ามซ้ำกับเคสที่มีอยู่แล้ว:\n${existingTitles.map((t) => `- ${t}`).join("\n")}`
      : "(ยังไม่มีเคสในสาขานี้)";

  return `คุณเป็นอาจารย์แพทย์ผู้สอบบอร์ดสาขา${specialtyNameTh} (วุฒิบัตร / Diplomate of Thai Board)

สร้าง **1 oral exam (long case)** ใหม่สำหรับสอบบอร์ดสาขา${specialtyNameTh}
ระดับความยาก: ${difficulty}
แหล่งอ้างอิงหลัก: ${reference}

แล้วเรียก tool submit_board_oral_case

กฎ:
1. เลือก clinical scenario ที่ board exam ของสาขานี้ "ต้องสอบ" หรือ "เป็น must-know" — อิงตำราหลักด้านบน
2. patient_info ครบ vitals; ใช้ชื่อไทยปลอม (ไม่ใช่บุคคลจริง)
3. history_script.pi ต้องมีข้อมูลให้ AI ผู้ป่วยตอบได้เมื่อ candidate ซักประวัติเพิ่ม
4. pe_findings ต้องครอบคลุม system ที่เกี่ยวกับเคส (อย่างน้อย 4-6 ระบบ) และมี classic finding
5. lab_results: ตั้ง 4-7 รายการที่ candidate น่าสั่ง — มีทั้ง abnormal และ normal (เพื่อ test การ interpret)
6. imaging_results: เพิ่มถ้าจำเป็นต่อ diagnosis (US, CT, MRI, ECG ฯลฯ) พร้อม specific finding
7. correct_diagnosis: เฉพาะ ICD ที่ถูกต้อง 1 ข้อ
8. accepted_ddx: 3-5 ข้อ รวม correct_diagnosis + plausible alternatives
9. teaching_points: 4-6 pearls ระดับ board (clinical decision, evidence, common pitfall)
10. examiner_questions: 5-7 ข้อ ระดับ board exam จริง:
    - ถาม pathophysiology / mechanism
    - ถาม evidence-based management (เฉพาะเจาะจง trial หรือ guideline)
    - ถาม edge case / contraindication
    - ถาม "ถ้าเปลี่ยน X จะเป็นอย่างไร"
    - points รวมไม่เกิน 100 (กระจายตามความสำคัญ)
11. scoring_rubric: weights รวม = 100
12. ${difficulty === "hard" ? "Hard = atypical presentation หรือ multi-system / critically ill / ต้องตัดสินใจเร็ว" : difficulty === "medium" ? "Medium = classic presentation แต่ต้องระวัง mimic" : "Easy = textbook classic, suitable for early-board prep"}
13. ภาษาไทยเป็นหลัก ใช้ศัพท์แพทย์ภาษาอังกฤษเสริม

${recent}`;
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
      tools: [ORAL_CASE_TOOL],
      tool_choice: { type: "tool", name: "submit_board_oral_case" },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude API error (${model}): ${err}`);
  }
  const data = await res.json();
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input) {
    const blockTypes = (data.content ?? []).map((b) => b.type).join(",") || "(empty)";
    throw new Error(
      `No tool_use in response (${model}) — stop_reason=${data.stop_reason} blocks=[${blockTypes}]`
    );
  }
  if (data.stop_reason === "max_tokens") {
    console.warn(`[${model}] hit max_tokens (${maxTokens}); case may be truncated`);
  }
  return toolUse.input;
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

async function loadActiveSpecialties() {
  const { data, error } = await supabase
    .from("board_specialties")
    .select("slug, name_th")
    .eq("is_active", true)
    .order("slug");
  if (error) throw new Error(`Failed to load specialties: ${error.message}`);
  return data ?? [];
}

async function loadExistingTitles(specialtySlug) {
  const { data } = await supabase
    .from("long_cases")
    .select("title")
    .eq("audience", "board")
    .eq("board_specialty", specialtySlug)
    .order("created_at", { ascending: false })
    .limit(30);
  return (data ?? []).map((r) => r.title);
}

function isValidCase(c) {
  return (
    c &&
    typeof c.title === "string" &&
    c.title.length > 0 &&
    c.patient_info?.vitals?.bp &&
    c.history_script?.cc &&
    c.correct_diagnosis &&
    Array.isArray(c.accepted_ddx) &&
    c.accepted_ddx.length >= 3 &&
    Array.isArray(c.examiner_questions) &&
    c.examiner_questions.length >= 5 &&
    c.scoring_rubric?.management
  );
}

async function run() {
  const specialties = await loadActiveSpecialties();
  if (specialties.length === 0) {
    console.log("No active specialties — nothing to do");
    return;
  }

  const now = new Date();
  const dayOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) /
      (1000 * 60 * 60 * 24)
  );
  const today = specialties[dayOfYear % specialties.length];
  console.log(
    `Day ${dayOfYear}: generating oral case for ${today.name_th} (${today.slug})`
  );

  // Difficulty rotation: 50% medium, 33% hard, 17% easy
  const mod3 = dayOfYear % 6;
  const difficulty = mod3 === 0 ? "easy" : mod3 < 4 ? "medium" : "hard";

  const existingTitles = await loadExistingTitles(today.slug);
  console.log(`Existing cases in ${today.slug}: ${existingTitles.length}`);

  const prompt = buildPrompt({
    specialtyNameTh: today.name_th,
    specialtySlug: today.slug,
    existingTitles,
    difficulty,
  });

  console.log(`Calling Sonnet for ${difficulty} oral case...`);
  const caseData = await callClaudeWithRetry(
    "sonnet-oral",
    "claude-sonnet-4-6",
    16000,
    prompt
  );

  if (!isValidCase(caseData)) {
    console.error("Generated case failed validation:", JSON.stringify(caseData).slice(0, 500));
    process.exit(1);
  }

  const insert = {
    title: caseData.title,
    specialty: today.name_th,
    difficulty: caseData.difficulty,
    is_weekly: false,
    is_published: true,
    audience: "board",
    board_specialty: today.slug,
    patient_info: caseData.patient_info,
    history_script: caseData.history_script,
    pe_findings: caseData.pe_findings,
    lab_results: caseData.lab_results,
    imaging_results: caseData.imaging_results ?? null,
    correct_diagnosis: caseData.correct_diagnosis,
    accepted_ddx: caseData.accepted_ddx,
    management_plan: caseData.management_plan,
    teaching_points: caseData.teaching_points,
    examiner_questions: caseData.examiner_questions,
    scoring_rubric: caseData.scoring_rubric,
  };

  const { data: inserted, error: insertErr } = await supabase
    .from("long_cases")
    .insert(insert)
    .select("id, title");

  if (insertErr) {
    console.error(`Insert failed: ${insertErr.message}`);
    process.exit(1);
  }

  console.log(
    `Inserted oral case ${inserted?.[0]?.id}: "${inserted?.[0]?.title}" (${today.slug}/${difficulty})`
  );
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
