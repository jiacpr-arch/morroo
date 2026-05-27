/**
 * Daily Board Exam MCQ generator — runs on GitHub Actions
 *
 * Generates 30 board MCQ questions/day for a rotating (specialty, section, topic)
 * triple drawn from `board_topic_categories` joined with `board_exam_blueprints`.
 * Only specialties with `is_published=true` are included.
 *
 * Distribution per day:
 *   - Haiku (cheap): 6 easy + 15 medium
 *   - Sonnet (deep reasoning): 9 hard
 *
 * Age stratification follows the topic's peds_count/adult_count ratio so that
 * the generated set matches the blueprint's expected case mix.
 *
 * Required env vars:
 *   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 */

import { createClient } from "@supabase/supabase-js";
import { notifyCronFailure, notifyCronSuccess } from "./cron-notify.mjs";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !ANTHROPIC_API_KEY) {
  console.error(
    "Missing required env vars (SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY)"
  );
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Subject name pattern: each section of each specialty has its own mcq_subject row.
// e.g. emergency_medicine + clinical_decision → "em_clinical_decision"
// Prefix used as the mcq_subjects.name prefix (must match the seed migrations).
const SUBJECT_NAME_PREFIX = {
  emergency_medicine: "em",
  internal_medicine: "im",
  surgery: "surg",
  pediatrics: "peds",
  ob_gyn: "obgyn",
  orthopedics: "ortho",
  psychiatry: "psych",
  anesthesiology: "anes",
  radiology: "rad",
  family_medicine: "fm",
  pathology: "path",
  rehab_medicine: "rehab",
};

// Per-specialty reference textbook + Thai context — fed into the prompt so
// Claude grounds questions in the right primary source instead of defaulting
// to whatever it knows best (which is usually Tintinalli for everything).
const SPECIALTY_REFERENCE = {
  emergency_medicine:
    "Tintinalli's Emergency Medicine 9e + AHA/ACEP guidelines ปัจจุบัน",
  internal_medicine:
    "Harrison's Principles of Internal Medicine 21e + guideline ของสมาคมที่เกี่ยวข้อง (AHA, ADA, KDIGO ฯลฯ)",
  surgery:
    "Schwartz's Principles of Surgery 11e / Sabiston Textbook of Surgery 21e + NCCN guidelines",
  pediatrics:
    "Nelson Textbook of Pediatrics 22e + AAP guidelines + แนวทางราชวิทยาลัยกุมารแพทย์ฯ",
  ob_gyn:
    "Williams Obstetrics 26e / Williams Gynecology 4e + ACOG / RCOG guidelines",
  orthopedics:
    "Campbell's Operative Orthopedics 14e / Rockwood and Green's Fractures 9e + AAOS guidelines",
  psychiatry:
    "Kaplan & Sadock's Synopsis of Psychiatry 12e + DSM-5-TR + APA practice guidelines",
  anesthesiology:
    "Miller's Anesthesia 9e + Stoelting's Anesthesia and Co-Existing Disease 8e + ASA guidelines",
  radiology:
    "Brant and Helms' Fundamentals of Diagnostic Radiology 5e / Radiology Review Manual 9e + ACR appropriateness criteria",
  family_medicine:
    "Williams Manual of Family Medicine + USPSTF recommendations + AAFP guidelines",
  pathology:
    "Robbins and Cotran Pathologic Basis of Disease 10e + Rosai and Ackerman's Surgical Pathology 11e + WHO classifications",
  rehab_medicine:
    "DeLisa's Physical Medicine and Rehabilitation 6e + Braddom's Physical Medicine and Rehabilitation 6e",
};

const QUESTION_TOOL = {
  name: "submit_board_questions",
  description: "Submit a batch of generated board exam MCQ questions",
  input_schema: {
    type: "object",
    properties: {
      questions: {
        type: "array",
        items: {
          type: "object",
          properties: {
            scenario: { type: "string", description: "โจทย์สถานการณ์ระดับ board" },
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
            explanation: { type: "string" },
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
            age_group: {
              type: "string",
              enum: ["peds", "adult", "mixed"],
              description: "ช่วงอายุของเคส peds=เด็ก, adult=ผู้ใหญ่, mixed=ผสม",
            },
            reference: {
              type: "string",
              description: "อ้างอิงตำราหรือ guideline เช่น 'Tintinalli 9e Ch.34' หรือ 'AHA STEMI 2023'",
            },
          },
          required: [
            "scenario",
            "choices",
            "correct_answer",
            "explanation",
            "difficulty",
            "age_group",
          ],
        },
      },
    },
    required: ["questions"],
  },
};

function buildPrompt({
  specialtyNameTh,
  specialtySlug,
  sectionLabelTh,
  topicNameTh,
  topicSlug,
  pedsRatio,
  adultRatio,
  count,
  difficultyInstruction,
  existingCount,
}) {
  const peds = Math.round(count * pedsRatio);
  const adult = count - peds;
  const reference =
    SPECIALTY_REFERENCE[specialtySlug] ??
    "ตำราหลักของสาขา + guideline ปัจจุบันที่เกี่ยวข้อง";
  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญด้าน${specialtyNameTh} ระดับ board (วุฒิบัตร / Diplomate of Thai Board)

สร้างข้อสอบ MCQ จำนวน ${count} ข้อ ระดับ board สำหรับสาขา${specialtyNameTh}
หมวด: ${sectionLabelTh}
หัวข้อ: ${topicNameTh} (${topicSlug})
อายุของเคส: เด็ก ~${peds} ข้อ / ผู้ใหญ่ ~${adult} ข้อ (ตาม blueprint จริง)
แหล่งอ้างอิงหลัก: ${reference}

แล้วเรียก tool submit_board_questions

กฎ:
1. แต่ละข้อต้องเป็นโจทย์ระดับ board — ซับซ้อนกว่า NL Step 2 มาก เน้น clinical decision making จริงๆ ที่อาจารย์อาวุโสจะถามในห้องสอบ
2. Scenario มีรายละเอียดครบ: vitals, exam findings, lab/imaging values ที่ specific
3. ตัวเลือก 5 ข้อ (A-E) plausible — distractor ที่ดีมาจาก guideline หรือ pitfall ทางคลินิก
4. คำตอบถูกต้องอิงตำราหลักด้านบน หรือ landmark trial / guideline ปัจจุบัน
5. detailed_explanation: อธิบายทุกตัวเลือก ใส่ pathophysiology + clinical pearl + reference
6. age_group ใส่ตามเคส (peds=≤18 ปี, adult=>18 ปี, mixed=ครอบครัวหรือไม่ระบุชัด)
7. reference ใส่ตำรา/ guideline ที่อ้างอิงได้จริง (อ้างอิง chapter หรือ section ในตำราหลักด้านบนถ้าทำได้)
8. ${difficultyInstruction}
9. ห้ามซ้ำกับข้อสอบเดิม (ปัจจุบันมี ${existingCount} ข้อในหัวข้อนี้)
10. ภาษาไทยหรืออังกฤษตามความเหมาะสม — case scenario ภาษาไทย, ศัพท์ทางการแพทย์ภาษาอังกฤษ`;
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
      tool_choice: { type: "tool", name: "submit_board_questions" },
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
    console.warn(
      `[${model}] hit max_tokens (${maxTokens}); got ${toolUse.input.questions.length} questions, may be truncated`
    );
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

async function loadRotation() {
  // Fetch all topic categories joined with their blueprint + specialty.
  // We use `is_active=true` (not `is_published`) so that scaffolded specialties
  // accumulate content in the background while still hidden from /board.
  // Public visibility is gated separately by the `is_published` flag.
  const { data, error } = await supabase
    .from("board_topic_categories")
    .select(
      "slug, name_th, peds_count, adult_count, other_count, display_order, board_exam_blueprints!inner(specialty_slug, exam_year, section_code, section_label_th, board_specialties!inner(name_th, is_active))"
    )
    .order("display_order", { ascending: true });

  if (error) {
    throw new Error(`Failed to load board topics: ${error.message}`);
  }

  const rotation = [];
  for (const row of data ?? []) {
    const bp = Array.isArray(row.board_exam_blueprints)
      ? row.board_exam_blueprints[0]
      : row.board_exam_blueprints;
    if (!bp) continue;
    const sp = Array.isArray(bp.board_specialties)
      ? bp.board_specialties[0]
      : bp.board_specialties;
    if (!sp?.is_active) continue;

    rotation.push({
      specialty_slug: bp.specialty_slug,
      specialty_name_th: sp.name_th,
      exam_year: bp.exam_year,
      section_code: bp.section_code,
      section_label_th: bp.section_label_th,
      topic_slug: row.slug,
      topic_name_th: row.name_th,
      peds_count: row.peds_count,
      adult_count: row.adult_count,
      other_count: row.other_count,
    });
  }
  // Stable sort: specialty → section → topic display_order (already)
  rotation.sort((a, b) => {
    if (a.specialty_slug !== b.specialty_slug)
      return a.specialty_slug.localeCompare(b.specialty_slug);
    if (a.section_code !== b.section_code)
      return a.section_code.localeCompare(b.section_code);
    return 0;
  });
  return rotation;
}

async function findSubjectForSection(specialtySlug, sectionCode) {
  const prefix = SUBJECT_NAME_PREFIX[specialtySlug];
  if (!prefix) return null;
  // Convention: subject name = "<prefix>_<section>" (e.g. em_clinical_decision)
  const subjectName = `${prefix}_${sectionCode}`;
  const { data } = await supabase
    .from("mcq_subjects")
    .select("id, name_th")
    .eq("name", subjectName)
    .eq("audience", "board")
    .single();
  return data;
}

async function run() {
  const now = new Date();
  const dayOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) /
      (1000 * 60 * 60 * 24)
  );

  const rotation = await loadRotation();
  if (rotation.length === 0) {
    console.log("No published board topics in rotation — nothing to do");
    return;
  }

  // Deficit-aware pick: load active MCQ count per (specialty, section, topic)
  // and weight rotation toward topics with the least existing content. Goal is
  // to flatten content across all 12 specialties faster than pure round-robin
  // would, especially during early bootstrap when most specialties have 0 q.
  //
  // Algorithm:
  //   1. Bucket topics by content count
  //   2. Pick from the lowest-count bucket
  //   3. Within bucket, use day-of-year as deterministic tiebreaker (so two
  //      runs on the same day pick the same topic — idempotency)
  const { data: counts } = await supabase
    .from("mcq_questions")
    .select("board_specialty, board_section, board_topic")
    .eq("audience", "board")
    .eq("status", "active");

  const countByKey = new Map();
  for (const r of counts ?? []) {
    const key = `${r.board_specialty}::${r.board_section}::${r.board_topic}`;
    countByKey.set(key, (countByKey.get(key) ?? 0) + 1);
  }

  const withCounts = rotation.map((t) => ({
    ...t,
    existing: countByKey.get(`${t.specialty_slug}::${t.section_code}::${t.topic_slug}`) ?? 0,
  }));

  const minCount = Math.min(...withCounts.map((t) => t.existing));
  const candidates = withCounts.filter((t) => t.existing === minCount);
  const today = candidates[dayOfYear % candidates.length];
  console.log(
    `Today (day ${dayOfYear}): ${today.specialty_name_th} · ${today.section_label_th} · ${today.topic_name_th} (${today.topic_slug}) — picked from ${candidates.length} topics tied at ${minCount} existing q`
  );

  const subjectRow = await findSubjectForSection(
    today.specialty_slug,
    today.section_code
  );
  if (!subjectRow) {
    console.error(
      `No mcq_subject found for ${today.specialty_slug}/${today.section_code} — skipping`
    );
    return;
  }

  // Already computed by the deficit-aware picker above
  const existing = today.existing;

  const totalCount = today.peds_count + today.adult_count + today.other_count;
  const pedsRatio = totalCount > 0 ? today.peds_count / totalCount : 0.2;
  const adultRatio = totalCount > 0 ? today.adult_count / totalCount : 0.8;

  const easyPrompt = buildPrompt({
    specialtyNameTh: today.specialty_name_th,
    specialtySlug: today.specialty_slug,
    sectionLabelTh: today.section_label_th,
    topicNameTh: today.topic_name_th,
    topicSlug: today.topic_slug,
    pedsRatio,
    adultRatio,
    count: 6,
    difficultyInstruction:
      "สร้างเฉพาะข้อง่าย (easy) 6 ข้อ — เน้น recall ข้อเท็จจริงพื้นฐาน, drug dose, ECG/imaging classic finding, definition ที่ board ควรรู้",
    existingCount: existing,
  });
  const mediumPrompt = buildPrompt({
    specialtyNameTh: today.specialty_name_th,
    specialtySlug: today.specialty_slug,
    sectionLabelTh: today.section_label_th,
    topicNameTh: today.topic_name_th,
    topicSlug: today.topic_slug,
    pedsRatio,
    adultRatio,
    count: 15,
    difficultyInstruction:
      "สร้างเฉพาะข้อปานกลาง (medium) 15 ข้อ — เน้น first-line management, indication ของ procedure, การเลือก investigation ที่เหมาะสมตาม guideline",
    existingCount: existing,
  });
  const hardPrompt = buildPrompt({
    specialtyNameTh: today.specialty_name_th,
    specialtySlug: today.specialty_slug,
    sectionLabelTh: today.section_label_th,
    topicNameTh: today.topic_name_th,
    topicSlug: today.topic_slug,
    pedsRatio,
    adultRatio,
    count: 9,
    difficultyInstruction:
      "สร้างเฉพาะข้อยาก (hard) 9 ข้อ — เน้น clinical reasoning ระดับ board: complex differential, atypical presentation, การจัดการเคส critical, ethical/system-based question ที่ board test จริงๆ",
    existingCount: existing,
  });

  console.log(
    "Calling Haiku-easy (6q) + Haiku-medium (15q) + Sonnet-hard (9q) in parallel..."
  );
  // Board questions carry richer detail (guideline refs, age stratification,
  // 5-choice deep explanation) than NL Step 2, so the medium batch needs
  // more headroom — 32k truncates ~12 questions in; 48k clears 15.
  const [easyResult, mediumResult, hardResult] = await Promise.allSettled([
    callClaudeWithRetry("haiku-easy", "claude-haiku-4-5-20251001", 16000, easyPrompt),
    callClaudeWithRetry("haiku-medium", "claude-haiku-4-5-20251001", 48000, mediumPrompt),
    callClaudeWithRetry("sonnet-hard", "claude-sonnet-4-6", 24000, hardPrompt),
  ]);

  const allQuestions = [];
  for (const [label, result] of [
    ["haiku-easy", easyResult],
    ["haiku-medium", mediumResult],
    ["sonnet-hard", hardResult],
  ]) {
    if (result.status === "fulfilled") {
      console.log(`${label}: ${result.value.length} questions`);
      allQuestions.push(...result.value);
    } else {
      console.error(
        `${label} batch failed: ${result.reason?.message ?? result.reason}`
      );
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
      audience: "board",
      exam_type: null,
      board_specialty: today.specialty_slug,
      board_section: today.section_code,
      board_topic: today.topic_slug,
      board_age_group: ["peds", "adult", "mixed"].includes(q.age_group)
        ? q.age_group
        : null,
      reference_source: q.reference || null,
      exam_source: "AI-generated-board-daily",
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation || null,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: ["easy", "medium", "hard"].includes(q.difficulty)
        ? q.difficulty
        : "medium",
      is_ai_enhanced: true,
      ai_notes: `Auto-generated board ${now.toISOString().split("T")[0]} | ${
        q.difficulty === "hard" ? "sonnet" : "haiku"
      } | topic=${today.topic_slug}`,
      status: "active",
    }));

  console.log(
    `Valid questions after filter: ${validQuestions.length}/${allQuestions.length}`
  );

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

  // Update question_count for this section's subject
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

  const summaryLine = `${today.specialty_slug}/${today.section_code}/${today.topic_slug} — inserted ${
    inserted?.length ?? 0
  } (easy=${easy} medium=${medium} hard=${hard}); subject total ${newTotal ?? 0}`;
  console.log(`Inserted ${inserted?.length ?? 0} board questions: easy=${easy} medium=${medium} hard=${hard}`);
  console.log(`Total in subject "${subjectRow.name_th}": ${newTotal ?? 0}`);
  await notifyCronSuccess("generate-board-daily", summaryLine);
}

run().catch(async (err) => {
  console.error("Fatal:", err);
  await notifyCronFailure("generate-board-daily", err);
  process.exit(1);
});
