#!/usr/bin/env node
/**
 * Split scripts/board-seed-data/pediatrics.json into N chunks of CHUNK_SIZE
 * questions and write self-contained SQL files for paste into Supabase
 * SQL Editor.
 *
 * Each chunk is independently re-runnable (NOT EXISTS guard by scenario).
 * Run any/all in any order. Already-imported chunks become no-ops.
 *
 * Usage: node scripts/split-peds-sql.mjs
 * Output: supabase/board_seed_peds_chunks/peds_chunk_01.sql ... NN.sql
 */
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SRC = join(HERE, "board-seed-data", "pediatrics.json");
const OUT_DIR = join(HERE, "..", "supabase", "board_seed_peds_chunks");

const SLUG = "pediatrics";
const PREFIX = "peds";
const NAME_TH = "กุมารเวชศาสตร์";
const CHUNK_SIZE = 20;

const SECTION_ICON = {
  clinical_decision: "🩺",
  basic_science: "🧬",
  ems_mgmt: "🚨",
  integrative: "🧩",
};
const SECTION_LABEL_TH = {
  clinical_decision: "การตัดสินใจทางเวชกรรม",
  basic_science: "วิทยาศาสตร์การแพทย์พื้นฐาน",
  ems_mgmt: "การจัดการระบบบริการการแพทย์ฉุกเฉิน",
  integrative: "ข้อสอบบูรณาการ",
};

function sqlString(s) {
  if (s === null || s === undefined) return "NULL";
  return "'" + String(s).replace(/'/g, "''") + "'";
}
function sqlJsonb(obj) {
  if (obj === null || obj === undefined) return "NULL";
  return sqlString(JSON.stringify(obj)) + "::jsonb";
}
function difficultyOrDefault(d) {
  return ["easy", "medium", "hard"].includes(d) ? d : "medium";
}

function buildSubjectsBlock() {
  const rows = [];
  for (const section of Object.keys(SECTION_LABEL_TH)) {
    rows.push(
      `  (${sqlString(`${PREFIX}_${section}`)}, ` +
        `${sqlString(`${NAME_TH} · ${SECTION_LABEL_TH[section]}`)}, ` +
        `${sqlString(SECTION_ICON[section])}, ` +
        `'board', ${sqlString(SLUG)}, NULL, 0)`
    );
  }
  return [
    "insert into public.mcq_subjects",
    "  (name, name_th, icon, audience, board_specialty, exam_type, question_count)",
    "values",
    rows.join(",\n"),
    "on conflict (name) do nothing;",
  ].join("\n");
}

function buildQuestionInsert(q) {
  const subjectName = `${PREFIX}_${q.board_section}`;
  return [
    "insert into public.mcq_questions (",
    "  subject_id, audience, exam_type, scenario, choices, correct_answer,",
    "  explanation, detailed_explanation, difficulty, topic, status,",
    "  board_specialty, board_section, board_topic, board_age_group,",
    "  reference_source, exam_source, is_ai_enhanced, ai_notes",
    ")",
    "select",
    `  s.id, 'board', NULL, ${sqlString(q.scenario)}, ${sqlJsonb(q.choices)},`,
    `  ${sqlString(q.correct_answer)}, ${sqlString(q.explanation)}, ${sqlJsonb(q.detailed_explanation)},`,
    `  ${sqlString(difficultyOrDefault(q.difficulty))}, ${sqlString(q.board_topic || null)}, 'review',`,
    `  ${sqlString(SLUG)}, ${sqlString(q.board_section)}, ${sqlString(q.board_topic || "general")}, ${sqlString(q.board_age_group)},`,
    `  ${sqlString(q.reference_source)}, 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'`,
    "from public.mcq_subjects s",
    `where s.name = ${sqlString(subjectName)}`,
    "  and s.audience = 'board'",
    "  and not exists (",
    "    select 1 from public.mcq_questions q",
    "    where q.exam_source = 'AI-generated-board-seed'",
    `      and q.board_specialty = ${sqlString(SLUG)}`,
    `      and q.scenario = ${sqlString(q.scenario)}`,
    "  );",
    "",
  ].join("\n");
}

const all = JSON.parse(readFileSync(SRC, "utf8"));
const valid = all.filter(
  (q) =>
    q.scenario &&
    Array.isArray(q.choices) &&
    q.choices.length === 5 &&
    ["A", "B", "C", "D", "E"].includes(q.correct_answer)
);

mkdirSync(OUT_DIR, { recursive: true });

const totalChunks = Math.ceil(valid.length / CHUNK_SIZE);
const subjectsSQL = buildSubjectsBlock();

for (let i = 0; i < totalChunks; i++) {
  const start = i * CHUNK_SIZE;
  const end = Math.min(start + CHUNK_SIZE, valid.length);
  const chunk = valid.slice(start, end);
  const num = String(i + 1).padStart(2, "0");

  const lines = [];
  lines.push("-- ===============================================================");
  lines.push(`-- หมอรู้ — Pediatrics seed: chunk ${i + 1}/${totalChunks}`);
  lines.push(`-- Questions ${start + 1}-${end} of ${valid.length}`);
  lines.push("-- Safe to paste into Supabase SQL Editor. Re-runnable.");
  lines.push("-- Can run chunks in ANY order. Dedup by scenario.");
  lines.push("-- ===============================================================");
  lines.push("");
  lines.push("begin;");
  lines.push("");
  lines.push("-- subjects (idempotent, same on every chunk)");
  lines.push(subjectsSQL);
  lines.push("");
  for (const q of chunk) lines.push(buildQuestionInsert(q));
  lines.push("commit;");
  lines.push("");
  lines.push("-- verify after this chunk:");
  lines.push("select board_section, count(*) from public.mcq_questions");
  lines.push(
    `where board_specialty = 'pediatrics' and exam_source = 'AI-generated-board-seed'`
  );
  lines.push("group by 1 order by 1;");

  const outPath = join(OUT_DIR, `peds_chunk_${num}.sql`);
  writeFileSync(outPath, lines.join("\n") + "\n", "utf8");
  const sizeKB = (Buffer.byteLength(lines.join("\n"), "utf8") / 1024).toFixed(1);
  console.log(`  peds_chunk_${num}.sql — Q${start + 1}-${end} (${sizeKB} KB)`);
}

console.log(`\nWrote ${totalChunks} chunks to ${OUT_DIR}`);
console.log(`Total valid questions: ${valid.length}/${all.length}`);
