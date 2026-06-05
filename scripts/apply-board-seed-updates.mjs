/**
 * Apply the bloated-choice fix directly to the production Supabase DB.
 *
 * Reads scripts/board-seed-data/*.json and, for each question, updates
 * the matching row in `mcq_questions` (exam_source = 'AI-generated-board-seed'
 * + board_specialty + scenario) with the cleaned `choices` array and the
 * rewritten `explanation`.
 *
 * Why not SQL Editor? The combined UPDATE file is too large for the
 * Supabase SQL Editor's request size limit. Driving updates over PostgREST
 * via supabase-js avoids that limit and gives per-row error reporting.
 *
 * Usage:
 *   node scripts/apply-board-seed-updates.mjs            # all specialties
 *   node scripts/apply-board-seed-updates.mjs surgery    # one specialty
 *   DRY_RUN=1 node scripts/apply-board-seed-updates.mjs  # parse + match only
 *
 * Credentials: read from SUPABASE_URL + SUPABASE_SERVICE_ROLE_KEY env if set,
 * otherwise falls back to the hardcoded service-role values used by
 * scripts/seed-remote.mjs.
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

const supabase = createClient(SUPABASE_URL, SERVICE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false },
});

function logResult(slug, updated, missing, errors) {
  console.log(
    `  ${slug.padEnd(20)} updated=${updated.toString().padStart(4)} missing=${missing
      .toString()
      .padStart(4)} errors=${errors.toString().padStart(2)}`
  );
}

async function applySpecialty(slug, questions) {
  let updated = 0;
  let missing = 0;
  let errors = 0;
  const missingList = [];
  const errorList = [];

  // Concurrency: process N rows in parallel for throughput.
  const CONCURRENCY = 8;
  let idx = 0;

  async function worker() {
    while (true) {
      const i = idx++;
      if (i >= questions.length) return;
      const q = questions[i];
      if (DRY_RUN) {
        updated++;
        continue;
      }
      const { data, error, count } = await supabase
        .from("mcq_questions")
        .update({ choices: q.choices, explanation: q.explanation }, { count: "exact" })
        .eq("exam_source", "AI-generated-board-seed")
        .eq("board_specialty", slug)
        .eq("scenario", q.scenario)
        .select("id");
      if (error) {
        errors++;
        errorList.push({ scenario: q.scenario.slice(0, 80), error: error.message });
        continue;
      }
      if (!data || data.length === 0) {
        missing++;
        missingList.push(q.scenario.slice(0, 80));
        continue;
      }
      updated++;
      if ((updated + missing + errors) % 50 === 0) {
        process.stdout.write(
          `\r    ${slug}: ${updated + missing + errors}/${questions.length}`
        );
      }
    }
  }

  await Promise.all(Array.from({ length: CONCURRENCY }, worker));
  process.stdout.write("\r");
  logResult(slug, updated, missing, errors);
  if (errorList.length) {
    console.log("    first errors:");
    errorList.slice(0, 3).forEach((e) => console.log(`      - ${e.scenario}: ${e.error}`));
  }
  if (missingList.length) {
    console.log("    first missing (not in DB — skipped):");
    missingList.slice(0, 3).forEach((s) => console.log(`      - ${s}`));
  }
  return { updated, missing, errors };
}

async function main() {
  const files = readdirSync(SEED_DIR)
    .filter((f) => f.endsWith(".json"))
    .sort();

  console.log(`SUPABASE_URL: ${SUPABASE_URL}`);
  console.log(`DRY_RUN: ${DRY_RUN}`);
  console.log(`Target specialty: ${onlySlug || "ALL"}`);
  console.log("");

  // Quick connectivity probe.
  const { error: probeErr, count } = await supabase
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("exam_source", "AI-generated-board-seed");
  if (probeErr) {
    console.error("Connectivity probe failed:", probeErr.message);
    process.exit(1);
  }
  console.log(`Existing AI-generated-board-seed rows in DB: ${count ?? "?"}\n`);

  let totals = { updated: 0, missing: 0, errors: 0 };
  for (const file of files) {
    const slug = file.replace(/\.json$/, "");
    if (onlySlug && slug !== onlySlug) continue;
    const questions = JSON.parse(readFileSync(join(SEED_DIR, file), "utf8"));
    console.log(`▶ ${slug} (${questions.length} questions)`);
    const r = await applySpecialty(slug, questions);
    totals.updated += r.updated;
    totals.missing += r.missing;
    totals.errors += r.errors;
  }

  console.log("");
  console.log(
    `TOTAL: updated=${totals.updated} missing=${totals.missing} errors=${totals.errors}`
  );
  if (totals.errors > 0) process.exit(2);
}

main().catch((e) => {
  console.error("Fatal:", e);
  process.exit(1);
});
