/**
 * Insert pre-generated board MCQ seed data into mcq_questions.
 *
 * Reads scripts/board-seed-data/<specialty_slug>.json files (each an array of
 * question objects in the shape produced by runBoardGenAgent) and inserts them
 * with status='review'. NO Anthropic API call — the questions were generated
 * by the Claude Code session and saved as JSON.
 *
 * Idempotency: per specialty, if the existing count of (audience='board',
 * board_specialty=slug, status in active/review) is already ≥ MIN_SKIP_AT,
 * the whole file is skipped. Within a run, exam_source='AI-generated-board-seed'
 * is used so re-runs against an empty DB will duplicate — call once.
 *
 * Usage:
 *   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… npx tsx scripts/insert-board-seed.ts
 *
 * Optional env:
 *   ONLY_SPECIALTY=slug1,slug2     (limit to these slugs)
 *   MIN_SKIP_AT=30                  (skip specialty if existing count ≥ this)
 *   DRY_RUN=1                       (parse + report only, no insert)
 */

import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import { readdirSync, readFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { BOARD_SECTIONS } from "../lib/types-board";

const SUPABASE_URL = process.env.SUPABASE_URL ?? process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const MIN_SKIP_AT = Number(process.env.MIN_SKIP_AT ?? 30);
const DRY_RUN = process.env.DRY_RUN === "1";
const ONLY = (process.env.ONLY_SPECIALTY ?? "")
  .split(",")
  .map((s) => s.trim())
  .filter(Boolean);

const SCRIPT_DIR = (() => {
  try {
    return dirname(fileURLToPath(import.meta.url));
  } catch {
    return resolve(process.cwd(), "scripts");
  }
})();
const SEED_DIR = join(SCRIPT_DIR, "board-seed-data");

interface SeedQuestion {
  scenario: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string;
  detailed_explanation?: unknown;
  difficulty: "easy" | "medium" | "hard";
  board_section: string;
  board_topic: string;
  board_age_group?: "peds" | "adult" | "mixed" | null;
  reference_source?: string | null;
}

function isValidQuestion(q: SeedQuestion): boolean {
  return Boolean(
    q.scenario &&
      Array.isArray(q.choices) &&
      q.choices.length >= 4 &&
      q.choices.every((c) => c.label && c.text) &&
      q.correct_answer &&
      ["A", "B", "C", "D", "E"].includes(q.correct_answer) &&
      q.board_section &&
      q.board_topic
  );
}

async function existingCount(admin: SupabaseClient, slug: string): Promise<number> {
  const { count } = await admin
    .from("mcq_questions")
    .select("id", { count: "exact", head: true })
    .eq("audience", "board")
    .eq("board_specialty", slug)
    .in("status", ["active", "review"]);
  return count ?? 0;
}

const SUBJECT_PREFIX: Record<string, string> = {
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

const SECTION_ICON: Record<string, string> = {
  clinical_decision: "🩺",
  basic_science: "🧬",
  ems_mgmt: "🚨",
  integrative: "🧩",
};

async function loadSubjectMap(
  admin: SupabaseClient,
  slug: string,
  specialtyNameTh: string
): Promise<{ bySection: Map<string, string>; fallback: string | null }> {
  const { data: rows } = await admin
    .from("mcq_subjects")
    .select("id, name")
    .eq("audience", "board")
    .eq("board_specialty", slug);

  const bySection = new Map<string, string>();
  for (const r of rows ?? []) {
    for (const sec of BOARD_SECTIONS) {
      if ((r.name as string).endsWith(sec.code)) {
        bySection.set(sec.code, r.id as string);
      }
    }
  }

  const prefix = SUBJECT_PREFIX[slug] ?? slug;
  const missing = BOARD_SECTIONS.filter((s) => !bySection.has(s.code));
  if (missing.length > 0 && !DRY_RUN) {
    const toInsert = missing.map((s) => ({
      name: `${prefix}_${s.code}`,
      name_th: `${specialtyNameTh} · ${s.label_th}`,
      icon: SECTION_ICON[s.code] ?? "🩺",
      audience: "board" as const,
      board_specialty: slug,
      exam_type: null,
      question_count: 0,
    }));
    const { data: inserted, error } = await admin
      .from("mcq_subjects")
      .insert(toInsert)
      .select("id, name");
    if (error) {
      console.warn(`  [${slug}] failed to create missing subjects: ${error.message}`);
    } else {
      for (const r of inserted ?? []) {
        for (const sec of BOARD_SECTIONS) {
          if ((r.name as string).endsWith(sec.code)) {
            bySection.set(sec.code, r.id as string);
          }
        }
      }
    }
  }

  const fallback = bySection.size > 0 ? Array.from(bySection.values())[0] : rows?.[0]?.id ?? null;
  return { bySection, fallback };
}

interface SpecialtyReport {
  slug: string;
  file_count: number;
  invalid: number;
  skipped_reason: string | null;
  inserted: number;
}

async function loadSpecialtyNameTh(admin: SupabaseClient, slug: string): Promise<string> {
  const { data } = await admin
    .from("board_specialties")
    .select("name_th")
    .eq("slug", slug)
    .maybeSingle();
  return (data?.name_th as string) ?? slug;
}

async function processSpecialty(
  admin: SupabaseClient,
  slug: string,
  filePath: string
): Promise<SpecialtyReport> {
  const report: SpecialtyReport = {
    slug,
    file_count: 0,
    invalid: 0,
    skipped_reason: null,
    inserted: 0,
  };

  let rawQuestions: SeedQuestion[];
  try {
    rawQuestions = JSON.parse(readFileSync(filePath, "utf8"));
  } catch (err) {
    report.skipped_reason = `parse error: ${(err as Error).message}`;
    return report;
  }
  if (!Array.isArray(rawQuestions)) {
    report.skipped_reason = "JSON is not an array";
    return report;
  }
  report.file_count = rawQuestions.length;

  const valid = rawQuestions.filter(isValidQuestion);
  report.invalid = rawQuestions.length - valid.length;

  const existing = await existingCount(admin, slug);
  if (existing >= MIN_SKIP_AT) {
    report.skipped_reason = `existing ${existing} ≥ MIN_SKIP_AT ${MIN_SKIP_AT}`;
    return report;
  }

  if (valid.length === 0) {
    report.skipped_reason = "no valid questions in file";
    return report;
  }

  const specialtyNameTh = await loadSpecialtyNameTh(admin, slug);
  const { bySection, fallback } = await loadSubjectMap(admin, slug, specialtyNameTh);
  if (!fallback) {
    report.skipped_reason = "no mcq_subjects row available and auto-create failed";
    return report;
  }

  const rows = valid.map((q) => ({
    subject_id: bySection.get(q.board_section) ?? fallback,
    audience: "board" as const,
    exam_type: null,
    scenario: q.scenario,
    choices: q.choices,
    correct_answer: q.correct_answer,
    explanation: q.explanation || null,
    detailed_explanation: q.detailed_explanation ?? null,
    difficulty: (["easy", "medium", "hard"] as const).includes(q.difficulty as "easy")
      ? q.difficulty
      : "medium",
    topic: q.board_topic || null,
    status: "review" as const,
    board_specialty: slug,
    board_section: q.board_section,
    board_topic: q.board_topic || "general",
    board_age_group: q.board_age_group ?? null,
    reference_source: q.reference_source ?? null,
    exam_source: "AI-generated-board-seed",
    is_ai_enhanced: true,
    ai_notes: "seeded via Claude Code session (no critique pass)",
  }));

  if (DRY_RUN) {
    report.inserted = rows.length;
    return report;
  }

  const BATCH = 50;
  for (let i = 0; i < rows.length; i += BATCH) {
    const slice = rows.slice(i, i + BATCH);
    const { data, error } = await admin
      .from("mcq_questions")
      .insert(slice)
      .select("id");
    if (error) {
      report.skipped_reason = `insert failed at offset ${i}: ${error.message}`;
      return report;
    }
    report.inserted += data?.length ?? 0;
  }
  return report;
}

async function main() {
  const admin = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  let files: string[];
  try {
    files = readdirSync(SEED_DIR).filter((f) => f.endsWith(".json"));
  } catch (err) {
    console.error(`Cannot read ${SEED_DIR}: ${(err as Error).message}`);
    process.exit(1);
  }

  if (files.length === 0) {
    console.error(`No .json files in ${SEED_DIR}`);
    process.exit(1);
  }

  const targets = ONLY.length > 0 ? files.filter((f) => ONLY.includes(f.replace(/\.json$/, ""))) : files;
  console.log(
    `${DRY_RUN ? "[DRY RUN] " : ""}Inserting ${targets.length} specialty file(s) — MIN_SKIP_AT=${MIN_SKIP_AT}`
  );

  const reports: SpecialtyReport[] = [];
  for (const f of targets) {
    const slug = f.replace(/\.json$/, "");
    const r = await processSpecialty(admin, slug, join(SEED_DIR, f));
    reports.push(r);
    const status = r.skipped_reason
      ? `SKIPPED (${r.skipped_reason})`
      : `inserted ${r.inserted}/${r.file_count}${r.invalid ? ` (${r.invalid} invalid)` : ""}`;
    console.log(`  ${slug.padEnd(20)} ${status}`);
  }

  console.log("\n========== SUMMARY ==========");
  console.table(
    reports.map((r) => ({
      slug: r.slug,
      file: r.file_count,
      invalid: r.invalid,
      inserted: r.inserted,
      skipped: r.skipped_reason ?? "",
    }))
  );

  const failed = reports.filter((r) => r.skipped_reason && !r.skipped_reason.startsWith("existing "));
  if (failed.length > 0) process.exit(2);
}

main().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
