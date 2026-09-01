#!/usr/bin/env node
/**
 * Generate Detailed Explanations for MCQ Questions
 *
 * 1. Connects to Supabase using SUPABASE_SERVICE_ROLE_KEY
 * 2. Fetches all mcq_questions where detailed_explanation IS NULL
 * 3. Calls Claude Haiku API to generate detailed explanations in Thai
 * 4. Updates the question's detailed_explanation column
 * 5. Processes with 1 second delay between API calls
 *
 * Usage: node scripts/generate-explanations.js
 */

const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");

// ============================================
// Config
// ============================================
const PROJECT_ROOT = path.join(__dirname, "..");

// Load .env.local
const envPath = path.join(PROJECT_ROOT, ".env.local");
const env = {};
fs.readFileSync(envPath, "utf-8")
  .split("\n")
  .forEach((line) => {
    const [key, ...vals] = line.split("=");
    if (key && vals.length) env[key.trim()] = vals.join("=").trim();
  });

const ANTHROPIC_API_KEY = env.ANTHROPIC_API_KEY;
const supabase = createClient(
  env.NEXT_PUBLIC_SUPABASE_URL,
  env.SUPABASE_SERVICE_ROLE_KEY
);

// ============================================
// Helpers
// ============================================

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

async function callClaude(prompt, maxTokens = 4000) {
  const body = JSON.stringify({
    model: "claude-haiku-4-5-20251001",
    max_tokens: maxTokens,
    messages: [{ role: "user", content: prompt }],
  });

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 15000); // 15s timeout

    const resp = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body,
      signal: controller.signal,
    });
    clearTimeout(timeout);

    if (!resp.ok) {
      const errText = await resp.text();
      console.error(`    API Error ${resp.status}: ${errText.slice(0, 300)}`);
      return null;
    }

    const result = await resp.json();
    return result.content[0].text;
  } catch (e) {
    console.error(`    SKIP (${e.name === 'AbortError' ? 'timeout' : e.message})`);
    return null;
  }
}

function buildPrompt(question) {
  const choices = question.choices || [];
  const choiceText = choices
    .map((c) => `${c.label}. ${c.text}`)
    .join("\n");

  const correctAnswer = question.correct_answer || "A";

  return `อธิบายเฉลยข้อสอบแพทย์เป็นภาษาไทย ตอบเป็น JSON เท่านั้น ห้ามใส่ markdown

โจทย์: ${question.scenario}
ตัวเลือก: ${choiceText}
เฉลย: ${correctAnswer}

ตอบ JSON:
{"summary":"คำตอบที่ถูกต้อง: ${correctAnswer}. [ชื่อ] ([อธิบายสั้น])","reason":"[อธิบาย 2-3 ย่อหน้า: วิเคราะห์โจทย์ + pathophysiology + เหตุผลทางคลินิก]","choices":[{"label":"A","text":"[ชื่อ]","is_correct":false,"explanation":"[2-3 ประโยค ทำไมผิด]"}],"key_takeaway":"[1-2 ประโยค สรุปจุดสำคัญ]"}`;
}

function parseResponse(text) {
  if (!text) return null;
  try {
    let cleaned = text.trim();
    if (cleaned.startsWith("```")) {
      cleaned = cleaned.replace(/^```\w*\n?/, "").replace(/\n?```$/, "");
    }
    return JSON.parse(cleaned);
  } catch {
    // Try to extract JSON object
    const match = text.match(/\{[\s\S]*\}/);
    if (match) {
      try {
        return JSON.parse(match[0]);
      } catch {}
    }
    return null;
  }
}

// ============================================
// Main
// ============================================

async function main() {
  console.log("=".repeat(60));
  console.log("  Generate Detailed Explanations for MCQ Questions");
  console.log("=".repeat(60));

  // Step 1: Fetch subject names for logging
  console.log("\n[Step 1] Fetching subjects...");
  const { data: subjects } = await supabase
    .from("mcq_subjects")
    .select("id, name");

  const subjectMap = {};
  for (const s of subjects || []) {
    subjectMap[s.id] = s.name;
  }
  console.log(`  Found ${Object.keys(subjectMap).length} subjects`);

  // Step 2: Fetch questions without detailed_explanation
  console.log("\n[Step 2] Fetching questions without detailed_explanation...");

  // Supabase doesn't support IS NULL directly in .eq(), use .is()
  const { data: questions, error: fetchErr } = await supabase
    .from("mcq_questions")
    .select("id, scenario, choices, correct_answer, subject_id")
    .is("detailed_explanation", null)
    .eq("status", "active")
    .order("subject_id")
    .order("id");

  if (fetchErr) {
    console.error(`  Error fetching questions: ${fetchErr.message}`);
    process.exit(1);
  }

  const total = questions.length;
  console.log(`  Found ${total} questions without detailed_explanation`);

  if (total === 0) {
    console.log("\n  Nothing to do. All questions already have explanations.");
    return;
  }

  // Step 3: Process questions
  console.log("\n[Step 3] Generating explanations...\n");

  let successCount = 0;
  let failCount = 0;
  let skipCount = 0;

  for (let i = 0; i < total; i++) {
    const q = questions[i];
    const subjectName = subjectMap[q.subject_id] || "unknown";
    const scenarioPreview = (q.scenario || "").slice(0, 50).replace(/\n/g, " ");

    process.stdout.write(
      `[${i + 1}/${total}] ${subjectName}: ${scenarioPreview}... `
    );

    // Skip if no scenario or choices
    if (!q.scenario || !q.choices || q.choices.length < 2) {
      console.log("SKIP (invalid)");
      skipCount++;
      continue;
    }

    // Build prompt and call Claude (with 1 retry)
    const prompt = buildPrompt(q);
    let responseText = await callClaude(prompt, 3000);
    let parsed = parseResponse(responseText);
    if (!parsed) {
      await sleep(1000);
      responseText = await callClaude(prompt, 3000);
      parsed = parseResponse(responseText);
    }

    if (
      parsed &&
      parsed.summary &&
      parsed.reason &&
      parsed.choices &&
      parsed.key_takeaway
    ) {
      // Update in Supabase
      const { error: updateErr } = await supabase
        .from("mcq_questions")
        .update({ detailed_explanation: parsed })
        .eq("id", q.id);

      if (updateErr) {
        console.log(`DB_ERROR: ${updateErr.message}`);
        failCount++;
      } else {
        console.log("OK");
        successCount++;
      }
    } else {
      console.log("PARSE_FAIL");
      failCount++;
    }

    // Rate limiting: 1 second delay between API calls
    if (i < total - 1) {
      await sleep(1000);
    }
  }

  // Summary
  console.log(`\n${"=".repeat(60)}`);
  console.log(`  SUMMARY`);
  console.log(`${"=".repeat(60)}`);
  console.log(`  Total questions:    ${total}`);
  console.log(`  Success:            ${successCount}`);
  console.log(`  Failed:             ${failCount}`);
  console.log(`  Skipped:            ${skipCount}`);
  console.log(`${"=".repeat(60)}`);
}

main().catch((e) => {
  console.error("Fatal error:", e);
  process.exit(1);
});
