#!/usr/bin/env node
/**
 * Import Missing MCQ Questions
 *
 * 1. Reads ALL raw-parsed questions from mcq-output/*.json (1,319 questions)
 * 2. Reads ALL AI-parsed questions from mcq-output-ai/*.json (461 questions)
 * 3. Recovers questions from mcq-output-ai/_debug_*.txt files
 * 4. Finds questions from raw output NOT in AI output (fuzzy match first 50 chars)
 * 5. For missing questions with valid scenario but bad choices -> send to Claude Haiku
 * 6. For missing questions with good choices (>=4) -> format them
 * 7. Saves to mcq-output-ai-v2/ as JSON per subject
 * 8. Inserts into Supabase mcq_questions table (dedup by scenario)
 *
 * Usage: node scripts/import-missing-mcq.js
 */

const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");

// ============================================
// Config
// ============================================
const PROJECT_ROOT = path.join(__dirname, "..");
const RAW_DIR = path.join(__dirname, "mcq-output");
const AI_DIR = path.join(__dirname, "mcq-output-ai");
const OUTPUT_DIR = path.join(__dirname, "mcq-output-ai-v2");

// Load .env.local
const envPath = path.join(PROJECT_ROOT, ".env.local");
const env = {};
fs.readFileSync(envPath, "utf-8").split("\n").forEach((line) => {
  const [key, ...vals] = line.split("=");
  if (key && vals.length) env[key.trim()] = vals.join("=").trim();
});

const ANTHROPIC_API_KEY = env.ANTHROPIC_API_KEY;
const supabase = createClient(
  env.NEXT_PUBLIC_SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE_KEY
);

// Debug file -> subject mapping (from import-mcq-ai.py SUBJECT_MAP)
const DEBUG_FILE_SUBJECT_MAP = {
  "Cardio med": "cardio_med",
  "Chest med": "chest_med",
  "ENT": "ent",
  "Endocrine": "endocrine",
  "Forensic": "forensic",
  "GYN": "ob_gyn",
  "HEMATO": "hemato_med",
  "INFECTIOUS": "infectious_med",
  "OB": "ob_gyn",
  "ORTHO": "ortho",
  "Ped": "ped",
  "Psychi": "psychi",
  "Surgery": "surgery",
  "epidemio": "epidemio",
  "gi med": "gi_med",
  "nephro": "nephro_med",
  "neuro med1": "neuro_med",
  "neuro med1_2": "neuro_med",
};

const SUBJECT_DATA = {
  cardio_med: { name_th: "อายุรศาสตร์หัวใจ", icon: "❤️" },
  chest_med: { name_th: "อายุรศาสตร์ทรวงอก", icon: "🫁" },
  ent: { name_th: "โสต ศอ นาสิก", icon: "👂" },
  endocrine: { name_th: "ต่อมไร้ท่อ", icon: "🦋" },
  forensic: { name_th: "นิติเวชศาสตร์", icon: "🔍" },
  gi_med: { name_th: "อายุรศาสตร์ทางเดินอาหาร", icon: "🫄" },
  hemato_med: { name_th: "โลหิตวิทยา", icon: "🩸" },
  infectious_med: { name_th: "โรคติดเชื้อ", icon: "🦠" },
  nephro_med: { name_th: "อายุรศาสตร์ไต", icon: "🫘" },
  neuro_med: { name_th: "ประสาทวิทยา", icon: "🧠" },
  ob_gyn: { name_th: "สูติศาสตร์-นรีเวชวิทยา", icon: "🤰" },
  ortho: { name_th: "ออร์โธปิดิกส์", icon: "🦴" },
  ped: { name_th: "กุมารเวชศาสตร์", icon: "👶" },
  psychi: { name_th: "จิตเวชศาสตร์", icon: "🧘" },
  surgery: { name_th: "ศัลยศาสตร์", icon: "🔪" },
  epidemio: { name_th: "ระบาดวิทยา", icon: "📊" },
};

// ============================================
// Helpers
// ============================================

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

function normalize(text) {
  if (!text) return "";
  return text
    .replace(/\s+/g, " ")
    .replace(/[,.\-:;!?()（）]/g, "")
    .trim()
    .toLowerCase()
    .slice(0, 50);
}

function fuzzyMatch(a, b) {
  const na = normalize(a);
  const nb = normalize(b);
  if (!na || !nb || na.length < 10 || nb.length < 10) return false;
  // Check if one contains the other or high overlap
  if (na === nb) return true;
  if (na.includes(nb) || nb.includes(na)) return true;
  // Character-level similarity
  const shorter = na.length < nb.length ? na : nb;
  const longer = na.length < nb.length ? nb : na;
  let matches = 0;
  for (let i = 0; i < shorter.length; i++) {
    if (shorter[i] === longer[i]) matches++;
  }
  return matches / shorter.length > 0.7;
}

async function callClaude(prompt, maxTokens = 4000) {
  const body = JSON.stringify({
    model: "claude-haiku-4-5-20251001",
    max_tokens: maxTokens,
    messages: [{ role: "user", content: prompt }],
  });

  try {
    const resp = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body,
    });

    if (!resp.ok) {
      const errText = await resp.text();
      console.error(`    API Error ${resp.status}: ${errText.slice(0, 200)}`);
      return null;
    }

    const result = await resp.json();
    return result.content[0].text;
  } catch (e) {
    console.error(`    API Error: ${e.message}`);
    return null;
  }
}

async function enhanceQuestion(q, subjectName) {
  const choiceText = q.choices?.length
    ? q.choices.map((c) => `${c.label}. ${c.text}`).join("\n")
    : "(ไม่มีตัวเลือก)";

  const prompt = `คุณเป็นผู้เชี่ยวชาญด้านข้อสอบแพทย์ไทย (National License Exam)
สาขา: ${subjectName}

กรุณาปรับปรุงข้อสอบ MCQ นี้ให้สมบูรณ์:

โจทย์: ${q.scenario}
ตัวเลือกเดิม:
${choiceText}
${q.exam_source ? `แหล่งที่มา: ${q.exam_source}` : ""}

กรุณา:
1. ถ้าตัวเลือกน้อยกว่า 5 ข้อ เพิ่มให้ครบ 5 ข้อ (ตัวเลือกต้อง plausible)
2. ระบุคำตอบที่ถูกต้อง
3. เขียน explanation สั้นๆ (2-3 ประโยค) อธิบายว่าทำไมถึงเป็นคำตอบนั้น
4. ถ้าโจทย์ไม่สมบูรณ์ให้เติมให้สมบูรณ์

ตอบเป็น JSON object เดียว (ไม่ต้อง markdown code block):
{
  "scenario": "โจทย์ (ปรับปรุงแล้ว)",
  "choices": [{"label": "A", "text": "..."}, ...],
  "correct_answer": "A/B/C/D/E",
  "explanation": "คำอธิบาย",
  "status": "complete"
}`;

  const result = await callClaude(prompt, 2000);
  if (!result) return null;

  try {
    let text = result.trim();
    if (text.startsWith("```")) {
      text = text.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
    }
    const parsed = JSON.parse(text);
    return parsed;
  } catch {
    // Try to extract JSON object
    const match = result.match(/\{[\s\S]*\}/);
    if (match) {
      try {
        return JSON.parse(match[0]);
      } catch {}
    }
    console.error("    Could not parse AI response");
    return null;
  }
}

// ============================================
// Main
// ============================================

async function main() {
  console.log("=".repeat(60));
  console.log("  Import Missing MCQ Questions");
  console.log("=".repeat(60));

  // Step 1: Read all raw questions
  console.log("\n[Step 1] Reading raw-parsed questions...");
  const rawBySubject = {}; // subject -> questions[]
  let rawTotal = 0;

  const rawFiles = fs
    .readdirSync(RAW_DIR)
    .filter((f) => f.endsWith(".json") && !f.startsWith("_"));

  for (const file of rawFiles) {
    const data = JSON.parse(fs.readFileSync(path.join(RAW_DIR, file), "utf-8"));
    const subject = data.subject || file.replace(".json", "");
    const questions = data.questions || [];
    if (!rawBySubject[subject]) rawBySubject[subject] = [];
    rawBySubject[subject].push(...questions);
    rawTotal += questions.length;
    console.log(`  ${file}: ${questions.length} questions (subject: ${subject})`);
  }
  console.log(`  Total raw: ${rawTotal}`);

  // Step 2: Read all AI-parsed questions
  console.log("\n[Step 2] Reading AI-parsed questions...");
  const aiBySubject = {}; // subject -> questions[]
  let aiTotal = 0;

  const aiFiles = fs
    .readdirSync(AI_DIR)
    .filter((f) => f.endsWith(".json") && !f.startsWith("_"));

  for (const file of aiFiles) {
    const data = JSON.parse(fs.readFileSync(path.join(AI_DIR, file), "utf-8"));
    const subject = file.replace(".json", "");
    if (!Array.isArray(data)) continue;
    if (!aiBySubject[subject]) aiBySubject[subject] = [];
    aiBySubject[subject].push(...data);
    aiTotal += data.length;
    console.log(`  ${file}: ${data.length} questions`);
  }
  console.log(`  Total AI: ${aiTotal}`);

  // Step 3: Recover from debug files
  console.log("\n[Step 3] Recovering from _debug_*.txt files...");
  let debugRecovered = 0;

  const debugFiles = fs
    .readdirSync(AI_DIR)
    .filter((f) => f.startsWith("_debug_") && f.endsWith(".txt"));

  for (const file of debugFiles) {
    const content = fs.readFileSync(path.join(AI_DIR, file), "utf-8").trim();

    // Extract subject from filename: _debug_Cardio med_0.txt -> "Cardio med"
    const match = file.match(/^_debug_(.+?)_\d+\.txt$/);
    if (!match) continue;
    const rawName = match[1];
    const subject = DEBUG_FILE_SUBJECT_MAP[rawName];
    if (!subject) {
      console.log(`  Skip ${file} (unknown subject: ${rawName})`);
      continue;
    }

    // Try to parse as JSON array
    let questions = [];
    try {
      let text = content;
      if (text.startsWith("```")) {
        text = text.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
      }
      const parsed = JSON.parse(text);
      if (Array.isArray(parsed)) {
        questions = parsed;
      }
    } catch {
      // Try to find JSON array in content
      const arrMatch = content.match(/\[[\s\S]*\]/);
      if (arrMatch) {
        try {
          questions = JSON.parse(arrMatch[0]);
        } catch {}
      }
    }

    if (questions.length > 0) {
      if (!aiBySubject[subject]) aiBySubject[subject] = [];
      // Add subject field
      for (const q of questions) {
        q.subject = subject;
        q.exam_type = q.exam_type || "NL2";
      }
      aiBySubject[subject].push(...questions);
      debugRecovered += questions.length;
      console.log(`  ${file} -> ${subject}: ${questions.length} questions recovered`);
    } else {
      console.log(`  ${file}: could not parse`);
    }
  }
  console.log(`  Total recovered from debug: ${debugRecovered}`);
  aiTotal += debugRecovered;
  console.log(`  Updated AI total: ${aiTotal}`);

  // Step 4: Find missing questions
  console.log("\n[Step 4] Finding missing questions (not in AI output)...");

  // Build a set of normalized AI scenarios for fast lookup
  const aiScenarioSet = new Set();
  for (const [, questions] of Object.entries(aiBySubject)) {
    for (const q of questions) {
      if (q.scenario) {
        aiScenarioSet.add(normalize(q.scenario));
      }
    }
  }

  const missingBySubject = {}; // subject -> questions[]
  let missingTotal = 0;
  let skippedShort = 0;

  for (const [subject, rawQuestions] of Object.entries(rawBySubject)) {
    const missing = [];
    for (const q of rawQuestions) {
      if (!q.scenario) continue;

      // Check if scenario is too short to be useful
      if (q.scenario.length <= 20) {
        skippedShort++;
        continue;
      }

      const norm = normalize(q.scenario);

      // Check exact normalized match
      if (aiScenarioSet.has(norm)) continue;

      // Check fuzzy match against all AI questions for this subject
      const aiQuestions = aiBySubject[subject] || [];
      let found = false;
      for (const aq of aiQuestions) {
        if (fuzzyMatch(q.scenario, aq.scenario)) {
          found = true;
          break;
        }
      }

      if (!found) {
        missing.push({
          ...q,
          subject,
          exam_type: q.exam_type || "NL2",
        });
      }
    }

    if (missing.length > 0) {
      missingBySubject[subject] = missing;
      missingTotal += missing.length;
      console.log(`  ${subject}: ${missing.length} missing`);
    }
  }
  console.log(`  Total missing: ${missingTotal}`);
  console.log(`  Skipped (scenario <= 20 chars): ${skippedShort}`);

  // Step 5 & 6: Enhance or format missing questions
  console.log("\n[Step 5/6] Processing missing questions...");
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  const newBySubject = {}; // subject -> enhanced questions[]
  let enhancedCount = 0;
  let formattedCount = 0;
  let failedCount = 0;
  let apiCallCount = 0;

  for (const [subject, questions] of Object.entries(missingBySubject)) {
    const subjectName = SUBJECT_DATA[subject]?.name_th || subject;
    console.log(`\n  Processing ${subject} (${subjectName}): ${questions.length} questions`);
    newBySubject[subject] = [];

    for (let i = 0; i < questions.length; i++) {
      const q = questions[i];
      process.stdout.write(
        `    [${i + 1}/${questions.length}] "${q.scenario.slice(0, 40)}..." `
      );

      // Check if question already has good choices
      if (q.choices && q.choices.length >= 4) {
        // Format it properly
        const formatted = {
          scenario: q.scenario,
          choices: q.choices,
          correct_answer: q.correct_answer || q.choices[0]?.label || "A",
          exam_source: q.exam_source || null,
          explanation: null,
          status: "complete",
          ai_notes: "Formatted from raw output (had good choices)",
          subject,
          exam_type: "NL2",
          is_ai_enhanced: false,
        };
        newBySubject[subject].push(formatted);
        formattedCount++;
        console.log("-> formatted (good choices)");
        continue;
      }

      // Need AI enhancement
      apiCallCount++;
      const enhanced = await enhanceQuestion(q, subjectName);

      if (enhanced && enhanced.scenario && enhanced.choices?.length >= 4) {
        newBySubject[subject].push({
          scenario: enhanced.scenario,
          choices: enhanced.choices,
          correct_answer: enhanced.correct_answer || "A",
          exam_source: q.exam_source || enhanced.exam_source || null,
          explanation: enhanced.explanation || null,
          status: enhanced.status || "complete",
          ai_notes: "AI-enhanced from raw output",
          subject,
          exam_type: "NL2",
          is_ai_enhanced: true,
        });
        enhancedCount++;
        console.log("-> enhanced OK");
      } else {
        failedCount++;
        console.log("-> FAILED");
      }

      // Rate limiting: 1 second between API calls
      if (i < questions.length - 1) {
        await sleep(1000);
      }
    }
  }

  console.log(`\n  Summary:`);
  console.log(`    Formatted (good choices): ${formattedCount}`);
  console.log(`    AI-enhanced: ${enhancedCount}`);
  console.log(`    Failed: ${failedCount}`);
  console.log(`    API calls made: ${apiCallCount}`);

  // Step 7: Save to mcq-output-ai-v2/
  console.log("\n[Step 7] Saving to mcq-output-ai-v2/...");
  let savedTotal = 0;

  // First, copy existing AI questions
  for (const [subject, questions] of Object.entries(aiBySubject)) {
    const outputFile = path.join(OUTPUT_DIR, `${subject}.json`);
    const newQuestions = newBySubject[subject] || [];
    const combined = [...questions, ...newQuestions];

    fs.writeFileSync(outputFile, JSON.stringify(combined, null, 2), "utf-8");
    savedTotal += combined.length;
    console.log(
      `  ${subject}.json: ${questions.length} existing + ${newQuestions.length} new = ${combined.length}`
    );
  }

  // Handle subjects that only have new questions (not in AI output)
  for (const [subject, questions] of Object.entries(newBySubject)) {
    if (aiBySubject[subject]) continue; // Already handled above
    const outputFile = path.join(OUTPUT_DIR, `${subject}.json`);
    fs.writeFileSync(outputFile, JSON.stringify(questions, null, 2), "utf-8");
    savedTotal += questions.length;
    console.log(`  ${subject}.json: ${questions.length} new`);
  }

  // Save summary
  const summary = {
    timestamp: new Date().toISOString(),
    original_raw: rawTotal,
    original_ai: aiTotal - debugRecovered,
    debug_recovered: debugRecovered,
    missing_found: missingTotal,
    skipped_short: skippedShort,
    formatted: formattedCount,
    ai_enhanced: enhancedCount,
    failed: failedCount,
    total_saved: savedTotal,
  };
  fs.writeFileSync(
    path.join(OUTPUT_DIR, "_summary.json"),
    JSON.stringify(summary, null, 2),
    "utf-8"
  );
  console.log(`\n  Total saved: ${savedTotal}`);

  // Step 8: Insert into Supabase
  console.log("\n[Step 8] Inserting into Supabase...");

  // Get subject IDs
  const subjectIds = {};
  for (const name of Object.keys(SUBJECT_DATA)) {
    const { data: existing } = await supabase
      .from("mcq_subjects")
      .select("id")
      .eq("name", name)
      .single();

    if (existing) {
      subjectIds[name] = existing.id;
    }
  }
  console.log(`  Found ${Object.keys(subjectIds).length} subjects in DB`);

  // Get existing scenarios for dedup
  console.log("  Loading existing scenarios for dedup...");
  const { data: existingRows, error: fetchErr } = await supabase
    .from("mcq_questions")
    .select("scenario")
    .eq("status", "active");

  if (fetchErr) {
    console.error(`  Error fetching existing: ${fetchErr.message}`);
    return;
  }

  const existingScenarios = new Set(
    (existingRows || []).map((r) => normalize(r.scenario))
  );
  console.log(`  Existing questions in DB: ${existingScenarios.size}`);

  let insertedTotal = 0;
  let dupSkipped = 0;

  // Only insert the NEW questions (not the existing AI ones)
  for (const [subject, questions] of Object.entries(newBySubject)) {
    const subjectId = subjectIds[subject];
    if (!subjectId) {
      console.log(`  Skip ${subject} (no subject ID in DB)`);
      continue;
    }

    const toInsert = [];
    for (const q of questions) {
      if (!q.scenario || q.status === "incomplete") continue;
      if (!q.choices || q.choices.length < 2) continue;

      const norm = normalize(q.scenario);
      if (existingScenarios.has(norm)) {
        dupSkipped++;
        continue;
      }

      // Also fuzzy check
      let isDup = false;
      for (const existing of existingScenarios) {
        if (fuzzyMatch(q.scenario, existing)) {
          isDup = true;
          break;
        }
      }
      if (isDup) {
        dupSkipped++;
        continue;
      }

      existingScenarios.add(norm); // Prevent self-dups

      toInsert.push({
        subject_id: subjectId,
        exam_type: q.exam_type || "NL2",
        exam_source: q.exam_source || null,
        scenario: q.scenario,
        choices: q.choices,
        correct_answer: q.correct_answer || "A",
        explanation: q.explanation || q.ai_notes || null,
        difficulty: "medium",
        is_ai_enhanced: q.is_ai_enhanced !== false,
        ai_notes: q.ai_notes || null,
        status: "active",
      });
    }

    if (toInsert.length === 0) {
      console.log(`  ${subject}: 0 to insert (all dups or invalid)`);
      continue;
    }

    // Insert in batches of 20
    for (let i = 0; i < toInsert.length; i += 20) {
      const batch = toInsert.slice(i, i + 20);
      const { error } = await supabase.from("mcq_questions").insert(batch);

      if (error) {
        console.error(`  ${subject} batch error: ${error.message}`);
      } else {
        insertedTotal += batch.length;
      }
    }
    console.log(`  ${subject}: inserted ${toInsert.length}`);
  }

  // Update question counts
  console.log("\n  Updating subject question counts...");
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
  }

  console.log(`\n${"=".repeat(60)}`);
  console.log(`  FINAL SUMMARY`);
  console.log(`${"=".repeat(60)}`);
  console.log(`  Raw questions:        ${rawTotal}`);
  console.log(`  AI questions:         ${aiTotal - debugRecovered}`);
  console.log(`  Debug recovered:      ${debugRecovered}`);
  console.log(`  Missing found:        ${missingTotal}`);
  console.log(`  Formatted (good):     ${formattedCount}`);
  console.log(`  AI-enhanced:          ${enhancedCount}`);
  console.log(`  Failed:               ${failedCount}`);
  console.log(`  Inserted to DB:       ${insertedTotal}`);
  console.log(`  Duplicates skipped:   ${dupSkipped}`);
  console.log(`  Output: ${OUTPUT_DIR}`);
  console.log(`${"=".repeat(60)}`);
}

main().catch((e) => {
  console.error("Fatal error:", e);
  process.exit(1);
});
