#!/usr/bin/env node
/**
 * Seed NL1 MCQ questions into Supabase
 * Reads NL_*.json files from Desktop, transforms format, and inserts
 *
 * Usage: node scripts/seed-nl1.js
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
  env.SUPABASE_SERVICE_ROLE_KEY
);

const DESKTOP = "/Users/apple/Desktop";

// Files grouped by subject (use _correct versions for forensic)
const FILE_MAP = {
  forensic: [
    "NL_forensic_Q41_Q50_correct.json",
    "NL_forensic_Q51_Q60_correct.json",
    "NL_forensic_Q61_Q70_correct.json",
    "NL_forensic_Q71_Q84_correct.json",
  ],
  hemato_med: [
    "NL_hemato_Q01_Q20.json",
    "NL_hemato_Q21_Q40.json",
    "NL_hemato_Q41_Q60.json",
    "NL_hemato_Q61_Q83.json",
  ],
  chest_med: [
    "NL_chest_Q01_Q30.json",
    "NL_chest_Q31_Q59.json",
  ],
  ent: [
    "NL_ent_Q01_Q35.json",
    "NL_ent_Q36_Q69.json",
  ],
  endocrine: [
    "NL_endo_Q01_Q30.json",
    "NL_endo_Q31_Q51.json",
  ],
  cardio_med: ["NL_cardio_Q01_Q45.json"],
  neuro_med: ["NL_neuro_Q01_Q41.json"],
  psychi: ["NL_psychi_Q01_Q40.json"],
  gi_med: ["NL_gi_Q01_Q27.json"],
  nephro_med: ["NL_nephro_Q01_Q26.json"],
  epidemio: ["NL_epidemio_Q01_Q21.json"],
};

const SUBJECT_DATA = {
  cardio_med: { name_th: "อายุรศาสตร์หัวใจ", icon: "❤️" },
  chest_med: { name_th: "อายุรศาสตร์ทรวงอก", icon: "🫁" },
  ent: { name_th: "โสต ศอ นาสิก", icon: "👂" },
  endocrine: { name_th: "ต่อมไร้ท่อ", icon: "🦋" },
  forensic: { name_th: "นิติเวชศาสตร์", icon: "🔍" },
  gi_med: { name_th: "อายุรศาสตร์ทางเดินอาหาร", icon: "🫄" },
  hemato_med: { name_th: "โลหิตวิทยา", icon: "🩸" },
  nephro_med: { name_th: "อายุรศาสตร์ไต", icon: "🫘" },
  neuro_med: { name_th: "ประสาทวิทยา", icon: "🧠" },
  psychi: { name_th: "จิตเวชศาสตร์", icon: "🧘" },
  epidemio: { name_th: "ระบาดวิทยา", icon: "📊" },
};

/**
 * Transform choices from { "A": "text" } to [{ label: "A", text: "text" }]
 */
function transformChoices(choices) {
  if (Array.isArray(choices)) return choices; // already correct format
  return Object.entries(choices).map(([label, text]) => ({ label, text }));
}

/**
 * Transform detailed_explanation to DB format
 */
function transformDetailedExplanation(de, choices, correctAnswer) {
  if (!de) return null;

  const perChoice = de.per_choice_explanations || {};
  const choicesArr = transformChoices(choices);

  return {
    summary: de.summary || "",
    reason: de.reason || "",
    choices: choicesArr.map((c) => ({
      label: c.label,
      text: c.text,
      is_correct: c.label === correctAnswer,
      explanation: perChoice[c.label] || "",
    })),
    key_takeaway: de.key_takeaway || "",
  };
}

async function main() {
  console.log("🚀 Starting NL1 seed...\n");

  // Step 1: Get/create subject IDs
  console.log("📋 Resolving subjects...");
  const subjectIds = {};

  for (const [name, data] of Object.entries(SUBJECT_DATA)) {
    const { data: existing } = await supabase
      .from("mcq_subjects")
      .select("id")
      .eq("name", name)
      .single();

    if (existing) {
      subjectIds[name] = existing.id;
      console.log(`   ✓ ${data.name_th} (${existing.id})`);
    } else {
      const { data: inserted, error } = await supabase
        .from("mcq_subjects")
        .insert({
          name,
          name_th: data.name_th,
          icon: data.icon,
          exam_type: "NL1",
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

  // Step 2: Read, transform, and insert questions
  console.log("\n📝 Inserting NL1 questions...");
  let totalInserted = 0;
  let totalSkipped = 0;

  for (const [subject, files] of Object.entries(FILE_MAP)) {
    const subjectId = subjectIds[subject];
    if (!subjectId) {
      console.log(`   ⚠️ Skipping ${subject} (no subject ID)`);
      continue;
    }

    // Collect all questions from multiple files
    let allQuestions = [];
    for (const file of files) {
      const filePath = path.join(DESKTOP, file);
      if (!fs.existsSync(filePath)) {
        console.log(`   ⚠️ File not found: ${file}`);
        continue;
      }
      const data = JSON.parse(fs.readFileSync(filePath, "utf-8"));
      allQuestions = allQuestions.concat(data);
    }

    console.log(`\n   📄 ${SUBJECT_DATA[subject].name_th}: ${allQuestions.length} ข้อ`);

    // Re-number sequentially
    const batchSize = 20;
    for (let i = 0; i < allQuestions.length; i += batchSize) {
      const batch = allQuestions.slice(i, i + batchSize);

      const rows = batch.map((q, idx) => ({
        subject_id: subjectId,
        exam_type: "NL1",
        exam_source: null,
        question_number: i + idx + 1,
        scenario: q.scenario,
        choices: transformChoices(q.choices),
        correct_answer: q.correct_answer || "A",
        explanation: q.explanation || null,
        detailed_explanation: transformDetailedExplanation(
          q.detailed_explanation,
          q.choices,
          q.correct_answer || "A"
        ),
        difficulty: q.difficulty || "medium",
        is_ai_enhanced: true,
        ai_notes: null,
        status: "active",
      }));

      const { error } = await supabase.from("mcq_questions").insert(rows);

      if (error) {
        console.error(`     ❌ Batch error (${subject} Q${i + 1}-${i + batch.length}):`, error.message);
        totalSkipped += rows.length;
      } else {
        totalInserted += rows.length;
        process.stdout.write(`     ✅ ${totalInserted} inserted total\r`);
      }
    }
  }

  // Step 3: Update question counts for NL1
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
