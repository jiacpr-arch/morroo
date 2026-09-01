/**
 * Insert any board seed questions that are present in
 * scripts/board-seed-data/*.json but NOT in the database (rows where
 * `exam_source = 'AI-generated-board-seed'`).
 *
 * Use this AFTER apply-board-seed-updates.mjs — the apply script logs
 * each "missing" scenario; this script picks those up and inserts them.
 *
 * Idempotency: before inserting a question we look it up by exact
 * scenario AND by 80-char scenario prefix; if either matches an
 * existing row, we skip. So re-runs only add new rows.
 *
 * Usage:
 *   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… node scripts/apply-board-seed-inserts.mjs
 *   …optional positional arg to limit to one specialty:
 *   node scripts/apply-board-seed-inserts.mjs radiology
 *   DRY_RUN=1 node scripts/apply-board-seed-inserts.mjs   # report only
 */

import { createClient } from "@supabase/supabase-js";
import { readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(HERE, "board-seed-data");

const SUPABASE_URL = process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL;
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!SUPABASE_URL || !SERVICE_KEY) {
  console.error(
    "Missing env: set SUPABASE_URL (or NEXT_PUBLIC_SUPABASE_URL) and SUPABASE_SERVICE_ROLE_KEY."
  );
  process.exit(1);
}

const DRY_RUN = process.env.DRY_RUN === "1" || process.env.DRY_RUN === "true";
const onlySlug = process.argv[2] || null;

const SUBJECT_PREFIX = {
  emergency_medicine: "em",
  internal_medicine: "im",
  surgery: "surg",
  pediatrics: "peds",
  ob_gyn: "obg",
  orthopedics: "ortho",
  psychiatry: "psych",
  anesthesiology: "anes",
  radiology: "rad",
  family_medicine: "fammed",
  pathology: "path",
  rehab_medicine: "rehab",
};

function normalizeAgeGroup(g) {
  if (g === null || g === undefined) return null;
  const v = String(g).toLowerCase();
  if (["neonate", "infant", "child", "adolescent", "teen", "pediatric", "peds"].includes(v))
    return "peds";
  if (["adult", "elderly", "geriatric", "senior", "older"].includes(v)) return "adult";
  if (["mixed", "all", "lifespan"].includes(v)) return "mixed";
  return null;
}

function difficultyOrDefault(d) {
  return ["easy", "medium", "hard"].includes(d) ? d : "medium";
}

function escapeLike(s) {
  return s.replace(/[\\%_]/g, "\\$&");
}

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false },
});

async function fetchSubjectIds() {
  const { data, error } = await supabase
    .from("mcq_subjects")
    .select("id, name")
    .eq("audience", "board");
  if (error) throw new Error("fetch subjects failed: " + error.message);
  return new Map(data.map((r) => [r.name, r.id]));
}

async function existsInDb(slug, q) {
  // 1) Exact scenario match.
  const exact = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("exam_source", "AI-generated-board-seed")
    .eq("board_specialty", slug)
    .eq("scenario", q.scenario);
  if (exact.error) return { error: exact.error };
  if ((exact.count || 0) > 0) return { exists: true };

  // 2) 80-char prefix match (handles whitespace drift).
  const prefix = q.scenario.slice(0, 80).trim();
  if (prefix.length < 40) return { exists: false };
  const like = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("exam_source", "AI-generated-board-seed")
    .eq("board_specialty", slug)
    .like("scenario", escapeLike(prefix) + "%");
  if (like.error) return { error: like.error };
  return { exists: (like.count || 0) > 0 };
}

async function processSpecialty(slug, questions, subjectIds) {
  let inserted = 0;
  let skipped = 0;
  let errors = 0;
  const errorList = [];

  // Sequential — total volume is small (174 rows tops) and we want clean
  // error reporting.
  for (let i = 0; i < questions.length; i++) {
    const q = questions[i];
    const check = await existsInDb(slug, q);
    if (check.error) {
      errors++;
      errorList.push({ scenario: q.scenario.slice(0, 60), error: check.error.message });
      continue;
    }
    if (check.exists) {
      skipped++;
      continue;
    }

    if (DRY_RUN) {
      inserted++;
      continue;
    }

    const subjectName = `${SUBJECT_PREFIX[slug]}_${q.board_section}`;
    const subjectId = subjectIds.get(subjectName);
    if (!subjectId) {
      errors++;
      errorList.push({
        scenario: q.scenario.slice(0, 60),
        error: `no subject row for ${subjectName}`,
      });
      continue;
    }

    const payload = {
      subject_id: subjectId,
      audience: "board",
      exam_type: null,
      scenario: q.scenario,
      choices: q.choices,
      correct_answer: q.correct_answer,
      explanation: q.explanation,
      detailed_explanation: q.detailed_explanation || null,
      difficulty: difficultyOrDefault(q.difficulty),
      topic: q.board_topic || null,
      status: "review",
      board_specialty: slug,
      board_section: q.board_section,
      board_topic: q.board_topic || "general",
      board_age_group: normalizeAgeGroup(q.board_age_group),
      reference_source: q.reference_source,
      exam_source: "AI-generated-board-seed",
      is_ai_enhanced: true,
      ai_notes: "seeded via Claude Code session (no critique pass)",
    };

    const ins = await supabase.from("mcq_questions").insert(payload).select("id");
    if (ins.error) {
      errors++;
      errorList.push({ scenario: q.scenario.slice(0, 60), error: ins.error.message });
      continue;
    }
    inserted++;
    if ((inserted + skipped + errors) % 25 === 0) {
      process.stdout.write(
        `\r    ${slug}: ${inserted + skipped + errors}/${questions.length}`
      );
    }
  }
  process.stdout.write("\r");
  console.log(
    `  ${slug.padEnd(20)} inserted=${inserted.toString().padStart(4)} skipped=${skipped
      .toString()
      .padStart(4)} errors=${errors}`
  );
  if (errorList.length) {
    console.log("    first errors:");
    errorList.slice(0, 5).forEach((e) => console.log(`      - ${e.scenario}: ${e.error}`));
  }
  return { inserted, skipped, errors };
}

async function main() {
  console.log(`SUPABASE_URL: ${SUPABASE_URL}`);
  console.log(`DRY_RUN: ${DRY_RUN}`);
  console.log(`Target specialty: ${onlySlug || "ALL"}`);
  console.log("");

  const subjectIds = await fetchSubjectIds();
  console.log(`Loaded ${subjectIds.size} board subject rows.\n`);

  const files = readdirSync(SEED_DIR).filter((f) => f.endsWith(".json")).sort();
  const totals = { inserted: 0, skipped: 0, errors: 0 };
  for (const file of files) {
    const slug = file.replace(/\.json$/, "");
    if (!SUBJECT_PREFIX[slug]) continue;
    if (onlySlug && slug !== onlySlug) continue;
    const questions = JSON.parse(readFileSync(join(SEED_DIR, file), "utf8"));
    console.log(`▶ ${slug} (${questions.length} questions)`);
    const r = await processSpecialty(slug, questions, subjectIds);
    totals.inserted += r.inserted;
    totals.skipped += r.skipped;
    totals.errors += r.errors;
  }
  console.log("");
  console.log(
    `TOTAL: inserted=${totals.inserted} skipped=${totals.skipped} errors=${totals.errors}`
  );
  if (totals.errors > 0) process.exit(2);
}

main().catch((e) => {
  console.error("Fatal:", e);
  process.exit(1);
});
