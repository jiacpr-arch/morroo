#!/usr/bin/env node
// Delta-sync of ACLS/BLS teaching data from the old emr-ai-clinic Supabase
// project into morroo's main project. Idempotent (upsert on primary key) —
// re-run as often as needed while the old apps (acls/bls.morroo.com) are
// still live and writing to the old DB. One-way old -> new only.
//
// Usage:
//   OLD_ACLS_SUPABASE_URL=https://elyyijlcjfvhxbpzscnv.supabase.co \
//   OLD_ACLS_SERVICE_ROLE_KEY=... \
//   NEW_SUPABASE_URL=https://knxidnzexqehusndquqg.supabase.co \
//   NEW_SUPABASE_SERVICE_ROLE_KEY=... \
//   node scripts/migrate-acls-data.mjs
//
// The initial full copy (schema + data + storage, 2026-07-12) was done
// server-side; this script covers subsequent drift.

import { createClient } from "@supabase/supabase-js";

const OLD_URL = process.env.OLD_ACLS_SUPABASE_URL;
const OLD_KEY = process.env.OLD_ACLS_SERVICE_ROLE_KEY;
const NEW_URL = process.env.NEW_SUPABASE_URL;
const NEW_KEY = process.env.NEW_SUPABASE_SERVICE_ROLE_KEY;
if (!OLD_URL || !OLD_KEY || !NEW_URL || !NEW_KEY) {
  console.error(
    "Missing env: OLD_ACLS_SUPABASE_URL, OLD_ACLS_SERVICE_ROLE_KEY, NEW_SUPABASE_URL, NEW_SUPABASE_SERVICE_ROLE_KEY",
  );
  process.exit(1);
}

const OLD_HOST = new URL(OLD_URL).host;
const NEW_HOST = new URL(NEW_URL).host;

const oldDb = createClient(OLD_URL, OLD_KEY, { auth: { persistSession: false } });
const newDb = createClient(NEW_URL, NEW_KEY, { auth: { persistSession: false } });

// [old table, new table, mode]
// mode "append": on-conflict-ignore (immutable rows: attempts, progress)
// mode "upsert": overwrite on conflict (content edited in the old admin)
const TABLES = [
  ["acls_chapters", "acls_chapters", "upsert"],
  ["acls_sections", "acls_sections", "upsert"],
  ["acls_qa_items", "acls_qa_items", "upsert"],
  ["acls_images", "acls_images", "upsert"],
  ["acls_qa_deep_page", "acls_qa_deep_page", "upsert"],
  ["acls_qa_deep_items", "acls_qa_deep_items", "upsert"],
  ["acls_qa_deep_images", "acls_qa_deep_images", "upsert"],
  ["acls_student_questions", "acls_student_questions", "upsert"],
  ["acls_assessment_banks", "acls_assessment_banks", "upsert"],
  ["acls_assessment_sets", "acls_assessment_sets", "upsert"],
  ["acls_assessment_questions", "acls_assessment_questions", "upsert"],
  ["acls_assessment_attempts", "acls_assessment_attempts", "append"],
  ["cohort_classes", "cohort_classes", "upsert"],
  ["cohort_students", "cohort_students", "upsert"],
  ["cohort_lesson_progress", "cohort_lesson_progress", "append"],
  ["cohort_quiz_attempts", "cohort_quiz_attempts", "append"],
  ["certificates", "acls_certificates", "append"],
  ["news", "acls_news", "upsert"],
  ["push_subscriptions", "acls_push_subscriptions", "upsert"],
  ["video_lessons", "video_lessons", "upsert"],
];

// Columns that may embed old-project storage URLs.
const URL_COLUMNS = {
  acls_images: ["src"],
  acls_qa_deep_images: ["src"],
  acls_qa_deep_page: ["cover_image_url"],
  acls_student_questions: ["generated_image_url"],
  acls_sections: ["body"],
  acls_qa_deep_items: ["answer"],
  acls_news: ["summary"],
};

function rewriteUrls(table, row) {
  const cols = URL_COLUMNS[table];
  if (!cols) return row;
  const out = { ...row };
  for (const col of cols) {
    if (typeof out[col] === "string" && out[col].includes(OLD_HOST)) {
      out[col] = out[col].split(OLD_HOST).join(NEW_HOST);
    }
  }
  return out;
}

const BATCH = 500;

async function syncTable(oldTable, newTable, mode) {
  let offset = 0;
  let total = 0;
  for (;;) {
    const { data, error } = await oldDb
      .from(oldTable)
      .select("*")
      .order("id", { ascending: true })
      .range(offset, offset + BATCH - 1);
    if (error) throw new Error(`${oldTable} select: ${error.message}`);
    if (!data?.length) break;

    const rows = data.map((r) => rewriteUrls(newTable, r));
    const { error: upErr } = await newDb
      .from(newTable)
      .upsert(rows, { onConflict: "id", ignoreDuplicates: mode === "append" });
    if (upErr) throw new Error(`${newTable} upsert: ${upErr.message}`);

    total += rows.length;
    if (data.length < BATCH) break;
    offset += BATCH;
  }
  return total;
}

async function syncStorage() {
  // Recursively list old bucket, copy any object missing in the new bucket.
  async function listAll(client, prefix = "") {
    const out = [];
    const { data, error } = await client.storage
      .from("acls-images")
      .list(prefix, { limit: 1000 });
    if (error) throw new Error(`storage list ${prefix}: ${error.message}`);
    for (const entry of data ?? []) {
      const path = prefix ? `${prefix}/${entry.name}` : entry.name;
      if (entry.id === null) out.push(...(await listAll(client, path)));
      else out.push(path);
    }
    return out;
  }
  const oldFiles = await listAll(oldDb);
  const newFiles = new Set(await listAll(newDb));
  const missing = oldFiles.filter((p) => !newFiles.has(p));
  for (const path of missing) {
    const { data, error } = await oldDb.storage.from("acls-images").download(path);
    if (error) throw new Error(`download ${path}: ${error.message}`);
    const { error: upErr } = await newDb.storage
      .from("acls-images")
      .upload(path, data, { upsert: true });
    if (upErr) throw new Error(`upload ${path}: ${upErr.message}`);
    console.log(`  storage: copied ${path}`);
  }
  return { total: oldFiles.length, copied: missing.length };
}

async function parityReport() {
  console.log("\n--- row-count parity (old -> new) ---");
  for (const [oldTable, newTable] of TABLES) {
    const [{ count: oldCount }, { count: newCount }] = await Promise.all([
      oldDb.from(oldTable).select("*", { count: "exact", head: true }),
      newDb.from(newTable).select("*", { count: "exact", head: true }),
    ]);
    const flag = (newCount ?? 0) >= (oldCount ?? 0) ? "ok" : "MISSING ROWS";
    console.log(`${oldTable} -> ${newTable}: ${oldCount} -> ${newCount} [${flag}]`);
  }
}

async function auditOldUrls() {
  console.log("\n--- audit: old-domain URLs remaining in new DB ---");
  let dirty = 0;
  for (const [table, cols] of Object.entries(URL_COLUMNS)) {
    for (const col of cols) {
      const { count, error } = await newDb
        .from(table)
        .select("*", { count: "exact", head: true })
        .ilike(col, `%${OLD_HOST}%`);
      if (error) continue; // column may be non-text filterable; skip
      if ((count ?? 0) > 0) {
        dirty += count;
        console.log(`  ${table}.${col}: ${count} rows still reference ${OLD_HOST}`);
      }
    }
  }
  if (dirty === 0) console.log("  clean — no old-domain URLs found");
}

for (const [oldTable, newTable, mode] of TABLES) {
  const n = await syncTable(oldTable, newTable, mode);
  console.log(`${oldTable} -> ${newTable}: synced ${n} rows (${mode})`);
}
const storage = await syncStorage();
console.log(`storage acls-images: ${storage.total} objects, ${storage.copied} newly copied`);
await parityReport();
await auditOldUrls();
console.log("\ndone.");
