#!/usr/bin/env node
/**
 * Seed MCQ questions into Supabase
 * Reads JSON files from mcq-output-ai/ and inserts into database
 *
 * Usage: node scripts/seed-mcq.js
 */

const { createClient } = require("@supabase/supabase-js");
const fs = require("fs");
const path = require("path");

// Load env
const envPath = path.join(__dirname, "..", ".env.local");
const envContent = fs.readFileSync(envPath, "utf-8");
const env = {};
envContent.split("\n").forEach((line) => {
  const [key, ...vals] = line.split("=");
  if (key && vals.length) env[key.trim()] = vals.join("=").trim();
});

const supabase = createClient(
  env.NEXT_PUBLIC_SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE_KEY // Use service role for seeding
);

const INPUT_DIR = path.join(__dirname, "mcq-output-ai");

// Subject name -> subject data mapping
const SUBJECT_DATA = {
  cardio_med: { name_th: "อายุรศาสตร์หัวใจ", icon: "❤️", exam_type: "NL2" },
  chest_med: { name_th: "อายุรศาสตร์ทรวงอก", icon: "🫁", exam_type: "NL2" },
  ent: { name_th: "โสต ศอ นาสิก", icon: "👂", exam_type: "NL2" },
  endocrine: { name_th: "ต่อมไร้ท่อ", icon: "🦋", exam_type: "NL2" },
  forensic: { name_th: "นิติเวชศาสตร์", icon: "🔍", exam_type: "NL2" },
  gi_med: { name_th: "อายุรศาสตร์ทางเดินอาหาร", icon: "🫄", exam_type: "NL2" },
  hemato_med: { name_th: "โลหิตวิทยา", icon: "🩸", exam_type: "NL2" },
  infectious_med: { name_th: "โรคติดเชื้อ", icon: "🦠", exam_type: "NL2" },
  nephro_med: { name_th: "อายุรศาสตร์ไต", icon: "🫘", exam_type: "NL2" },
  neuro_med: { name_th: "ประสาทวิทยา", icon: "🧠", exam_type: "NL2" },
  ob_gyn: { name_th: "สูติศาสตร์-นรีเวชวิทยา", icon: "🤰", exam_type: "NL2" },
  ortho: { name_th: "ออร์โธปิดิกส์", icon: "🦴", exam_type: "NL2" },
  ped: { name_th: "กุมารเวชศาสตร์", icon: "👶", exam_type: "NL2" },
  psychi: { name_th: "จิตเวชศาสตร์", icon: "🧘", exam_type: "NL2" },
  surgery: { name_th: "ศัลยศาสตร์", icon: "🔪", exam_type: "NL2" },
  epidemio: { name_th: "ระบาดวิทยา", icon: "📊", exam_type: "NL2" },
};

async function main() {
  console.log("🚀 Starting MCQ seed...\n");

  // Step 1: Create subjects and get their IDs
  console.log("📋 Creating subjects...");
  const subjectIds = {};

  for (const [name, data] of Object.entries(SUBJECT_DATA)) {
    const { data: existing } = await supabase
      .from("mcq_subjects")
      .select("id")
      .eq("name", name)
      .single();

    if (existing) {
      subjectIds[name] = existing.id;
      console.log(`   ✓ ${data.name_th} (exists: ${existing.id})`);
    } else {
      const { data: inserted, error } = await supabase
        .from("mcq_subjects")
        .insert({
          name,
          name_th: data.name_th,
          icon: data.icon,
          exam_type: data.exam_type,
          question_count: 0,
        })
        .select("id")
        .single();

      if (error) {
        console.error(`   ❌ Failed to create ${name}:`, error.message);
        continue;
      }
      subjectIds[name] = inserted.id;
      console.log(`   ✅ ${data.name_th} (created: ${inserted.id})`);
    }
  }

  // Step 2: Read and insert questions
  console.log("\n📝 Inserting questions...");
  let totalInserted = 0;
  let totalSkipped = 0;

  const files = fs
    .readdirSync(INPUT_DIR)
    .filter((f) => f.endsWith(".json") && !f.startsWith("_"));

  for (const file of files) {
    const subjectName = file.replace(".json", "");
    const subjectId = subjectIds[subjectName];

    if (!subjectId) {
      console.log(`   ⚠️ Skipping ${file} (no subject ID)`);
      continue;
    }

    const questions = JSON.parse(
      fs.readFileSync(path.join(INPUT_DIR, file), "utf-8")
    );

    console.log(`\n   📄 ${SUBJECT_DATA[subjectName]?.name_th || subjectName}: ${questions.length} ข้อ`);

    // Insert in batches of 20
    const batchSize = 20;
    for (let i = 0; i < questions.length; i += batchSize) {
      const batch = questions.slice(i, i + batchSize);

      const rows = batch
        .filter((q) => q.status !== "incomplete" && q.scenario && q.choices?.length >= 2)
        .map((q, idx) => ({
          subject_id: subjectId,
          exam_type: q.exam_type || "NL2",
          exam_source: q.exam_source || null,
          question_number: i + idx + 1,
          scenario: q.scenario,
          choices: q.choices,
          correct_answer: q.correct_answer || "A",
          explanation: q.explanation || q.ai_notes || null,
          difficulty: "medium",
          is_ai_enhanced: true,
          ai_notes: q.ai_notes || null,
          status: "active",
        }));

      if (rows.length === 0) {
        totalSkipped += batch.length;
        continue;
      }

      const { error } = await supabase.from("mcq_questions").insert(rows);

      if (error) {
        console.error(`     ❌ Batch error:`, error.message);
        totalSkipped += rows.length;
      } else {
        totalInserted += rows.length;
        process.stdout.write(`     ✅ ${totalInserted} inserted\r`);
      }
    }
  }

  // Step 3: Update question counts
  console.log("\n\n📊 Updating subject question counts...");
  for (const [name, subjectId] of Object.entries(subjectIds)) {
    const { count } = await supabase
      .from("mcq_questions")
      .select("id", { count: "exact", head: true })
      .eq("subject_id", subjectId)
      .eq("status", "active");

    await supabase
      .from("mcq_subjects")
      .update({ question_count: count || 0 })
      .eq("id", subjectId);

    console.log(`   ${SUBJECT_DATA[name]?.name_th}: ${count} ข้อ`);
  }

  console.log(`\n${"=".repeat(50)}`);
  console.log(`✅ Done! Inserted: ${totalInserted} | Skipped: ${totalSkipped}`);
}

main().catch(console.error);
