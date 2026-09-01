#!/usr/bin/env node
/**
 * Generate AI explanations for NL1 questions that don't have them
 * Uses Claude API to create detailed Thai explanations
 * Then updates Supabase
 */

const { createClient } = require("@supabase/supabase-js");
const Anthropic = require("@anthropic-ai/sdk").default;
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

const anthropic = new Anthropic({
  apiKey: env.ANTHROPIC_API_KEY,
});

const BATCH_SIZE = 5; // questions per API call

function buildPrompt(questions) {
  const qList = questions
    .map((q, i) => {
      const choicesText = q.choices
        .map((c) => `${c.label}. ${c.text}`)
        .join("\n");
      return `---
Q${i + 1} (ID: ${q.id})
วิชา: ${q.mcq_subjects?.name_th || ""}
โจทย์: ${q.scenario}
${choicesText}
คำตอบถูก: ${q.correct_answer}
---`;
    })
    .join("\n\n");

  return `คุณเป็นอาจารย์แพทย์ผู้เชี่ยวชาญ ช่วยสร้างเฉลยละเอียดสำหรับข้อสอบ NL1 (National License Step 1) ที่เป็น preclinical science

สำหรับแต่ละข้อ ให้ตอบเป็น JSON array โดยแต่ละ element มี format:
{
  "id": "uuid ของข้อ",
  "explanation": "คำอธิบายสั้น 1-2 ประโยค ว่าทำไมข้อนี้ถึงตอบถูก",
  "detailed_explanation": {
    "summary": "สรุปสั้นๆ ว่าข้อนี้ถามอะไร + คำตอบคืออะไร",
    "reason": "อธิบายเหตุผลว่าทำไมคำตอบนี้ถูก (2-3 ประโยค) ใช้ความรู้ทางการแพทย์",
    "choices": [
      {"label": "A", "text": "ข้อความ choice A", "is_correct": true/false, "explanation": "อธิบายว่าทำไมข้อนี้ถูก/ผิด"},
      ...ทำทุก choice
    ],
    "key_takeaway": "ข้อคิดสำคัญที่ควรจำ 1 ประโยค"
  }
}

ตอบเป็น JSON array เท่านั้น ไม่ต้องมีคำอธิบายอื่น

ข้อสอบ:
${qList}`;
}

async function generateExplanations(questions) {
  const prompt = buildPrompt(questions);

  const response = await anthropic.messages.create({
    model: "claude-sonnet-4-20250514",
    max_tokens: 8000,
    messages: [{ role: "user", content: prompt }],
  });

  const text = response.content[0].text;

  // Extract JSON from response
  const jsonMatch = text.match(/\[[\s\S]*\]/);
  if (!jsonMatch) {
    throw new Error("No JSON array found in response");
  }

  return JSON.parse(jsonMatch[0]);
}

async function main() {
  console.log("🚀 Generating explanations for NL1 questions...\n");

  // Load questions needing explanation
  const questionsData = JSON.parse(
    fs.readFileSync(
      "/Users/apple/Desktop/NL1_parsed/needs_explanation.json",
      "utf-8"
    )
  );

  console.log(`📝 Total questions needing explanation: ${questionsData.length}\n`);

  let totalUpdated = 0;
  let totalFailed = 0;

  for (let i = 0; i < questionsData.length; i += BATCH_SIZE) {
    const batch = questionsData.slice(i, i + BATCH_SIZE);
    const batchNum = Math.floor(i / BATCH_SIZE) + 1;
    const totalBatches = Math.ceil(questionsData.length / BATCH_SIZE);

    process.stdout.write(
      `\r   🔄 Batch ${batchNum}/${totalBatches} (${totalUpdated} updated, ${totalFailed} failed)...`
    );

    try {
      const explanations = await generateExplanations(batch);

      // Update each question in Supabase
      for (const expl of explanations) {
        if (!expl.id) continue;

        const updateData = {
          explanation: expl.explanation || null,
          detailed_explanation: expl.detailed_explanation || null,
          is_ai_enhanced: true,
        };

        const { error } = await supabase
          .from("mcq_questions")
          .update(updateData)
          .eq("id", expl.id);

        if (error) {
          console.error(`\n     ❌ Update error for ${expl.id}:`, error.message);
          totalFailed++;
        } else {
          totalUpdated++;
        }
      }
    } catch (err) {
      console.error(`\n     ❌ Batch ${batchNum} error:`, err.message);
      totalFailed += batch.length;

      // If rate limited, wait and retry
      if (err.status === 429) {
        console.log("     ⏳ Rate limited, waiting 30s...");
        await new Promise((r) => setTimeout(r, 30000));
        i -= BATCH_SIZE; // retry this batch
      }
    }

    // Small delay between batches to avoid rate limiting
    if (i + BATCH_SIZE < questionsData.length) {
      await new Promise((r) => setTimeout(r, 1000));
    }
  }

  console.log(`\n\n${"=".repeat(50)}`);
  console.log(`✅ Done! Updated: ${totalUpdated} | Failed: ${totalFailed}`);
}

main().catch(console.error);
