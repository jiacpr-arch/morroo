#!/usr/bin/env node
/**
 * Split scripts/board-seed-data/internal_medicine.json into N SQL chunks
 * to bypass the Supabase SQL Editor query-size limit.
 *
 * Output: supabase/board_seed_questions_split/04_internal_medicine_partN.sql
 *
 * Each chunk:
 *  - Starts with `begin;` + mcq_subjects insert (idempotent)
 *  - Inserts a slice of questions
 *  - Ends with `commit;`
 *  - Idempotent: existing rows skipped via `not exists` guard
 *  - Safe to paste each part separately in order
 */

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const DATA = join(HERE, "board-seed-data", "internal_medicine.json");
const OUT_DIR = join(HERE, "..", "supabase", "board_seed_questions_split");
const CHUNK_SIZE = 50;
const SLUG = "internal_medicine";
const PREFIX = "im";
const NAME_TH = "อายุรศาสตร์";

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

const questions = JSON.parse(readFileSync(DATA, "utf8"));
mkdirSync(OUT_DIR, { recursive: true });

const totalChunks = Math.ceil(questions.length / CHUNK_SIZE);
console.log(`Splitting ${questions.length} questions into ${totalChunks} chunk(s) of ${CHUNK_SIZE}`);

for (let i = 0; i < totalChunks; i++) {
  const start = i * CHUNK_SIZE;
  const end = Math.min(start + CHUNK_SIZE, questions.length);
  const slice = questions.slice(start, end);
  const partNum = i + 1;

  const lines = [];
  lines.push("-- ===============================================================");
  lines.push(
    `-- หมอรู้ — Board seed: ${NAME_TH} (${SLUG}) — Part ${partNum}/${totalChunks} (Q${start + 1}-${end})`
  );
  lines.push("-- Safe to paste into Supabase SQL Editor. Re-runnable.");
  lines.push("-- Apply parts in order: 1, 2, 3, 4");
  lines.push("-- ===============================================================");
  lines.push("");
  lines.push("begin;");
  lines.push("");

  // Always include subject inserts (idempotent on conflict).
  lines.push("-- 1/2 ─── mcq_subjects for this specialty (idempotent) ────────");
  lines.push("insert into public.mcq_subjects");
  lines.push("  (name, name_th, icon, audience, board_specialty, exam_type, question_count)");
  lines.push("values");
  const subjRows = [];
  for (const section of Object.keys(SECTION_LABEL_TH)) {
    subjRows.push(
      `  (${sqlString(`${PREFIX}_${section}`)}, ` +
        `${sqlString(`${NAME_TH} · ${SECTION_LABEL_TH[section]}`)}, ` +
        `${sqlString(SECTION_ICON[section])}, ` +
        `'board', ${sqlString(SLUG)}, NULL, 0)`
    );
  }
  lines.push(subjRows.join(",\n"));
  lines.push("on conflict (name) do nothing;");
  lines.push("");

  lines.push(`-- 2/2 ─── ${slice.length} mcq_questions (Q${start + 1}-${end}) ──────────────`);
  lines.push("");

  for (const q of slice) {
    if (
      !q.scenario ||
      !Array.isArray(q.choices) ||
      q.choices.length !== 5 ||
      !["A", "B", "C", "D", "E"].includes(q.correct_answer)
    ) {
      lines.push("-- INVALID question skipped");
      continue;
    }
    const subjectName = `${PREFIX}_${q.board_section}`;
    lines.push("insert into public.mcq_questions (");
    lines.push("  subject_id, audience, exam_type, scenario, choices, correct_answer,");
    lines.push("  explanation, detailed_explanation, difficulty, topic, status,");
    lines.push("  board_specialty, board_section, board_topic, board_age_group,");
    lines.push("  reference_source, exam_source, is_ai_enhanced, ai_notes");
    lines.push(")");
    lines.push("select");
    lines.push(
      `  s.id, 'board', NULL, ${sqlString(q.scenario)}, ${sqlJsonb(q.choices)},`
    );
    lines.push(
      `  ${sqlString(q.correct_answer)}, ${sqlString(q.explanation)}, ${sqlJsonb(q.detailed_explanation)},`
    );
    lines.push(
      `  ${sqlString(difficultyOrDefault(q.difficulty))}, ${sqlString(q.board_topic || null)}, 'review',`
    );
    lines.push(
      `  ${sqlString(SLUG)}, ${sqlString(q.board_section)}, ${sqlString(q.board_topic || "general")}, ${sqlString(q.board_age_group)},`
    );
    lines.push(
      `  ${sqlString(q.reference_source)}, 'AI-generated-board-seed', true, 'seeded via Claude Code session (no critique pass)'`
    );
    lines.push(`from public.mcq_subjects s`);
    lines.push(`where s.name = ${sqlString(subjectName)}`);
    lines.push("  and s.audience = 'board'");
    lines.push("  and not exists (");
    lines.push("    select 1 from public.mcq_questions q");
    lines.push("    where q.exam_source = 'AI-generated-board-seed'");
    lines.push(`      and q.board_specialty = ${sqlString(SLUG)}`);
    lines.push(`      and q.scenario = ${sqlString(q.scenario)}`);
    lines.push("  );");
    lines.push("");
  }

  lines.push("commit;");
  lines.push("");
  lines.push("-- verify partial progress");
  lines.push("select board_section, count(*) from public.mcq_questions");
  lines.push(
    `where board_specialty = ${sqlString(SLUG)} and exam_source = 'AI-generated-board-seed'`
  );
  lines.push("group by 1 order by 1;");

  const outName = join(
    OUT_DIR,
    `04_internal_medicine_part${partNum}of${totalChunks}.sql`
  );
  writeFileSync(outName, lines.join("\n") + "\n", "utf8");
  console.log(`Wrote ${outName} (${slice.length} questions)`);
}
