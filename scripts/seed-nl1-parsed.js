#!/usr/bin/env node
/**
 * Import parsed NL1 preclinic MCQ questions into Supabase
 * Reads from /Users/apple/Desktop/NL1_parsed/
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

const INPUT_DIR = "/Users/apple/Desktop/NL1_parsed";

// NL1 preclinic subjects
const SUBJECT_DATA = {
  biochemistry: { name_th: "ชีวเคมีและอณูชีววิทยา", icon: "🧬" },
  cell_biology: { name_th: "ชีววิทยาของเซลล์", icon: "🔬" },
  genetics: { name_th: "พัฒนาการมนุษย์และพันธุศาสตร์", icon: "🧬" },
  immunology: { name_th: "วิทยาภูมิคุ้มกัน", icon: "🛡️" },
  microbiology: { name_th: "จุลชีววิทยา", icon: "🦠" },
  parasitology: { name_th: "ปรสิตวิทยา", icon: "🪱" },
  pharmacology: { name_th: "เภสัชวิทยาพื้นฐาน", icon: "💊" },
  biostatistics: { name_th: "ชีวสถิติและระเบียบวิธีวิจัย", icon: "📊" },
  pathology: { name_th: "พยาธิวิทยา", icon: "🔎" },
  multisystem: { name_th: "กระบวนการหลายระบบ", icon: "🔄" },
  lab_principles: { name_th: "หลักการตรวจทางห้องปฏิบัติการ", icon: "🧪" },
  hemato_preclinic: { name_th: "ระบบเลือด (preclinic)", icon: "🩸" },
  cardiovascular: { name_th: "ระบบหัวใจและหลอดเลือด (preclinic)", icon: "❤️" },
  skin: { name_th: "ระบบผิวหนัง", icon: "🧴" },
  musculoskeletal: { name_th: "ระบบกล้ามเนื้อและกระดูก", icon: "🦴" },
  respiratory: { name_th: "ระบบทางเดินหายใจ (preclinic)", icon: "🫁" },
  neuro_preclinic: { name_th: "ระบบประสาท (preclinic)", icon: "🧠" },
  gi_preclinic: { name_th: "ระบบทางเดินอาหาร (preclinic)", icon: "🫄" },
  renal_preclinic: { name_th: "ระบบไต (preclinic)", icon: "🫘" },
  reproductive: { name_th: "ระบบสืบพันธุ์", icon: "🤰" },
  endocrine_preclinic: { name_th: "ระบบต่อมไร้ท่อ (preclinic)", icon: "🦋" },
};

async function main() {
  console.log("🚀 Starting NL1 preclinic import...\n");

  // Step 1: Create/get subjects
  console.log("📋 Creating NL1 preclinic subjects...");
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

  // Step 2: Read and insert questions
  console.log("\n📝 Inserting NL1 preclinic questions...");
  let totalInserted = 0;
  let totalSkipped = 0;

  const files = fs
    .readdirSync(INPUT_DIR)
    .filter((f) => f.endsWith(".json") && f.startsWith("NL1_"));

  for (const file of files) {
    const subjectName = file.replace("NL1_", "").replace(".json", "");
    const subjectId = subjectIds[subjectName];

    if (!subjectId) {
      console.log(`   ⚠️ Skipping ${file} (no subject ID for ${subjectName})`);
      continue;
    }

    const questions = JSON.parse(
      fs.readFileSync(path.join(INPUT_DIR, file), "utf-8")
    );

    if (questions.length === 0) continue;

    console.log(
      `\n   📄 ${SUBJECT_DATA[subjectName]?.name_th || subjectName}: ${questions.length} ข้อ`
    );

    // Insert in batches of 20
    const batchSize = 20;
    for (let i = 0; i < questions.length; i += batchSize) {
      const batch = questions.slice(i, i + batchSize);

      const rows = batch
        .filter((q) => q.scenario && q.choices?.length >= 2)
        .map((q) => ({
          subject_id: subjectId,
          exam_type: "NL1",
          exam_source: "NL1_exam_collection",
          question_number: q.question_number,
          scenario: q.scenario,
          choices: q.choices,
          correct_answer: q.correct_answer || "A",
          explanation: q.explanation || null,
          detailed_explanation: q.detailed_explanation || null,
          difficulty: q.difficulty || "medium",
          is_ai_enhanced: false,
          ai_notes: null,
          status: "active",
        }));

      if (rows.length === 0) {
        totalSkipped += batch.length;
        continue;
      }

      const { error } = await supabase.from("mcq_questions").insert(rows);

      if (error) {
        console.error(
          `     ❌ Batch error (${subjectName} Q${i + 1}-${i + batch.length}):`,
          error.message
        );
        totalSkipped += rows.length;
      } else {
        totalInserted += rows.length;
        process.stdout.write(`     ✅ ${totalInserted} inserted total\r`);
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

    if (count > 0) {
      console.log(`   ${SUBJECT_DATA[name]?.name_th}: ${count} ข้อ`);
    }
  }

  console.log(`\n${"=".repeat(50)}`);
  console.log(`✅ Done! Inserted: ${totalInserted} | Skipped: ${totalSkipped}`);
}

main().catch(console.error);
