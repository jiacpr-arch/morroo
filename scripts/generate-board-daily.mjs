/**
 * Daily Board Exam MCQ generator — runs on GitHub Actions
 *
 * Adds ONE new board MCQ to EVERY active specialty per run — a steady
 * "1 question / specialty / day" drip that grows the bank indefinitely
 * (no cap). Within each specialty the least-covered (section, topic) from
 * `board_topic_categories` is chosen so coverage stays flat across the
 * blueprint over time.
 *
 * Difficulty rotates over a 10-day cycle (~2 easy / 5 medium / 3 hard, the
 * board mix) and is offset per specialty so the specialties don't all land on
 * the same difficulty the same day. Hard → Sonnet, easy/medium → Haiku.
 *
 * Age stratification follows the topic's peds_count/adult_count ratio so that
 * the generated question matches the blueprint's expected case mix.
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

// Module-scoped so the top-level catch can flip any still-running audit rows
// to 'error' even when failures happen after rows are created but before the
// explicit try/catch. One row per specialty (see run()).
let auditJobIds = [];

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

// Difficulty rotation over a 10-day cycle: ~2 easy / 5 medium / 3 hard, the
// same mix the board exam favours (easy 20% / medium 50% / hard 30%). The
// index is offset by the specialty's position so the 12 specialties don't all
// generate the same difficulty on the same day.
const DIFFICULTY_CYCLE = [
  "easy", "medium", "medium", "hard", "medium",
  "easy", "hard", "medium", "medium", "hard",
];

const DIFFICULTY_INSTRUCTION = {
  easy:
    "สร้างข้อง่าย (easy) 1 ข้อ — เน้น recall ข้อเท็จจริงพื้นฐาน, drug dose, ECG/imaging classic finding, definition ที่ board ควรรู้",
  medium:
    "สร้างข้อปานกลาง (medium) 1 ข้อ — เน้น first-line management, indication ของ procedure, การเลือก investigation ที่เหมาะสมตาม guideline",
  hard:
    "สร้างข้อยาก (hard) 1 ข้อ — เน้น clinical reasoning ระดับ board: complex differential, atypical presentation, การจัดการเคส critical ที่ board test จริงๆ",
};

// Generate exactly ONE question for a single specialty. Picks the
// least-covered (section, topic) within that specialty so the daily +1 spreads
// evenly across the blueprint over time. Returns a descriptor the caller uses
// to bulk-insert + close the audit row.
async function generateForSpecialty({
  slug,
  nameTh,
  topics,
  countByKey,
  dayOfYear,
  specialtyIndex,
}) {
  const withCounts = topics.map((t) => ({
    ...t,
    existing:
      countByKey.get(`${t.specialty_slug}::${t.section_code}::${t.topic_slug}`) ?? 0,
  }));
  const minCount = Math.min(...withCounts.map((t) => t.existing));
  const candidates = withCounts.filter((t) => t.existing === minCount);
  // Deterministic tiebreak by day-of-year → same topic if the job re-runs today.
  const chosen = candidates[dayOfYear % candidates.length];

  const difficulty =
    DIFFICULTY_CYCLE[(dayOfYear + specialtyIndex) % DIFFICULTY_CYCLE.length];
  const model =
    difficulty === "hard" ? "claude-sonnet-4-6" : "claude-haiku-4-5-20251001";

  const subjectRow = await findSubjectForSection(
    chosen.specialty_slug,
    chosen.section_code
  );
  if (!subjectRow) {
    return {
      slug,
      chosen,
      error: `No mcq_subject for ${chosen.specialty_slug}/${chosen.section_code}`,
    };
  }

  const totalCount = chosen.peds_count + chosen.adult_count + chosen.other_count;
  const pedsRatio = totalCount > 0 ? chosen.peds_count / totalCount : 0.2;
  const adultRatio = totalCount > 0 ? chosen.adult_count / totalCount : 0.8;

  const prompt = buildPrompt({
    specialtyNameTh: nameTh,
    specialtySlug: chosen.specialty_slug,
    sectionLabelTh: chosen.section_label_th,
    topicNameTh: chosen.topic_name_th,
    topicSlug: chosen.topic_slug,
    pedsRatio,
    adultRatio,
    count: 1,
    difficultyInstruction: DIFFICULTY_INSTRUCTION[difficulty],
    existingCount: chosen.existing,
  });

  let questions;
  try {
    questions = await callClaudeWithRetry(`${slug}-${difficulty}`, model, 8000, prompt);
  } catch (err) {
    return { slug, chosen, subjectRow, error: err?.message ?? String(err) };
  }

  const valid = (questions ?? []).filter(
    (q) =>
      q.scenario &&
      Array.isArray(q.choices) &&
      q.choices.length >= 4 &&
      q.correct_answer &&
      ["A", "B", "C", "D", "E"].includes(q.correct_answer)
  );
  if (valid.length === 0) {
    return { slug, chosen, subjectRow, error: "no valid question generated" };
  }

  // 1-per-specialty daily drip — keep exactly one even if the model returned more.
  const q = valid[0];
  const row = {
    subject_id: subjectRow.id,
    audience: "board",
    exam_type: null,
    board_specialty: chosen.specialty_slug,
    board_section: chosen.section_code,
    board_topic: chosen.topic_slug,
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
      : difficulty,
    is_ai_enhanced: true,
    ai_notes: `Auto-generated board daily ${new Date().toISOString().split("T")[0]} | ${
      model.includes("sonnet") ? "sonnet" : "haiku"
    } | topic=${chosen.topic_slug}`,
    status: "active",
  };
  return { slug, chosen, subjectRow, row };
}

async function run() {
  const now = new Date();
  const dayOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 0).getTime()) /
      (1000 * 60 * 60 * 24)
  );

  const rotation = await loadRotation();
  if (rotation.length === 0) {
    console.log("No active board topics in rotation — nothing to do");
    return;
  }

  // Count existing active MCQs per (specialty, section, topic) so each
  // specialty can target its own least-covered topic.
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

  // Group topics by specialty — every active specialty gets exactly one
  // question this run (a steady +1/specialty/day drip, no cap).
  const bySpecialty = new Map();
  for (const t of rotation) {
    if (!bySpecialty.has(t.specialty_slug)) {
      bySpecialty.set(t.specialty_slug, {
        nameTh: t.specialty_name_th,
        topics: [],
      });
    }
    bySpecialty.get(t.specialty_slug).topics.push(t);
  }

  const specialties = [...bySpecialty.entries()]
    .map(([slug, v]) => ({ slug, nameTh: v.nameTh, topics: v.topics }))
    .sort((a, b) => a.slug.localeCompare(b.slug));

  console.log(
    `Daily drip (day ${dayOfYear}): +1 question for each of ${specialties.length} active specialties`
  );

  // Open one audit row per specialty BEFORE the expensive work so a crash
  // mid-run leaves a tombstone explaining what was attempted.
  auditJobIds = [];
  for (const sp of specialties) {
    const { data: jobRow, error: jobErr } = await supabase
      .from("board_gen_jobs")
      .insert({
        trigger: "daily",
        specialty_slug: sp.slug,
        target_count: 1,
        status: "running",
        started_at: new Date().toISOString(),
        attempts: 1,
      })
      .select("id")
      .single();
    if (jobErr) {
      console.error(`Could not open audit row for ${sp.slug}: ${jobErr.message}`);
    }
    auditJobIds.push({ slug: sp.slug, id: jobRow?.id ?? null });
  }
  const jobIdBySlug = new Map(auditJobIds.map((j) => [j.slug, j.id]));

  // Generate all specialties in parallel — each issues its own Claude call.
  const settled = await Promise.allSettled(
    specialties.map((sp, idx) =>
      generateForSpecialty({
        slug: sp.slug,
        nameTh: sp.nameTh,
        topics: sp.topics,
        countByKey,
        dayOfYear,
        specialtyIndex: idx,
      })
    )
  );

  const perSpecialty = [];
  const rowsToInsert = [];
  settled.forEach((r, idx) => {
    if (r.status === "fulfilled") {
      perSpecialty.push(r.value);
      if (r.value.row) rowsToInsert.push(r.value);
    } else {
      perSpecialty.push({
        slug: specialties[idx].slug,
        error: r.reason?.message ?? String(r.reason),
      });
    }
  });

  // Bulk-insert every generated question in one shot.
  if (rowsToInsert.length > 0) {
    const { error: insertErr } = await supabase
      .from("mcq_questions")
      .insert(rowsToInsert.map((x) => x.row));
    if (insertErr) {
      const msg = `Insert failed: ${insertErr.message}`;
      console.error(msg);
      for (const j of auditJobIds) {
        if (j.id) {
          await supabase
            .from("board_gen_jobs")
            .update({
              status: "error",
              error: msg.slice(0, 500),
              completed_at: new Date().toISOString(),
            })
            .eq("id", j.id);
        }
      }
      await notifyCronFailure("generate-board-daily", new Error(msg));
      process.exit(1);
    }
  }

  // Refresh question_count for every subject that received a question.
  const subjectIds = [...new Set(rowsToInsert.map((x) => x.subjectRow.id))];
  for (const sid of subjectIds) {
    const { count: newTotal } = await supabase
      .from("mcq_questions")
      .select("id", { count: "exact", head: true })
      .eq("subject_id", sid)
      .eq("status", "active");
    await supabase
      .from("mcq_subjects")
      .update({ question_count: newTotal ?? 0 })
      .eq("id", sid);
  }

  // Close audit rows + build the summary.
  const summaryParts = [];
  for (const res of perSpecialty) {
    const jobId = jobIdBySlug.get(res.slug);
    if (res.row) {
      if (jobId) {
        await supabase
          .from("board_gen_jobs")
          .update({
            status: "done",
            generated_count: 1,
            drafted_count: 0,
            completed_at: new Date().toISOString(),
          })
          .eq("id", jobId);
      }
      summaryParts.push(
        `${res.slug}: +1 (${res.chosen.section_code}/${res.chosen.topic_slug})`
      );
    } else {
      if (jobId) {
        await supabase
          .from("board_gen_jobs")
          .update({
            status: "error",
            error: (res.error ?? "unknown").slice(0, 500),
            completed_at: new Date().toISOString(),
          })
          .eq("id", jobId);
      }
      summaryParts.push(`${res.slug}: FAIL (${res.error ?? "unknown"})`);
    }
  }

  const okCount = perSpecialty.filter((r) => r.row).length;
  const summary =
    `Daily board drip: ${okCount}/${specialties.length} specialties +1 question\n` +
    summaryParts.join("\n");
  console.log(summary);

  if (okCount === 0) {
    await notifyCronFailure(
      "generate-board-daily",
      new Error("All specialties failed to generate")
    );
    process.exit(1);
  }

  await notifyCronSuccess("generate-board-daily", summary);
}

run().catch(async (err) => {
  console.error("Fatal:", err);
  // Flip any audit rows still in 'running' (the ones whose specialty never got
  // closed) to 'error'. Rows already 'done' are guarded by the status filter.
  for (const j of auditJobIds) {
    if (!j.id) continue;
    try {
      await supabase
        .from("board_gen_jobs")
        .update({
          status: "error",
          error: (err?.message ?? String(err)).slice(0, 500),
          completed_at: new Date().toISOString(),
        })
        .eq("id", j.id)
        .eq("status", "running");
    } catch (updateErr) {
      console.error("Could not flip audit row to error:", updateErr);
    }
  }
  await notifyCronFailure("generate-board-daily", err);
  process.exit(1);
});
