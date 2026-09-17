/**
 * Backfill `detailed_explanation` (summary / reason / per-choice / takeaway)
 * for active student MCQs that only have a short `explanation` — 1,112 rows
 * as of 2026-09-18, mostly the June batch activated from the review queue on
 * 2026-08-30. Students see the detailed block on /nl/practice whenever it
 * exists, so this brings the whole bank to the same standard as the daily
 * generator's output.
 *
 * Uses the Message Batches API (50% price, results within 24h, usually
 * minutes) in two steps — each a separate CI run (JOB=backfill-mcq-explanations):
 *
 *   MODE=submit   pick rows still missing detailed_explanation (oldest
 *                 review-queue rows first), submit one batch, remember its id
 *                 in app_settings. LIMIT caps the row count (default: all).
 *   MODE=collect  fetch the remembered batch; if ended, write results back
 *                 (only where detailed_explanation is still null), log usage
 *                 + cost + 3 samples, forget the batch id. If still running,
 *                 print progress and exit 0 — just run again later.
 *   MODE=auto     (default) collect when a batch id is remembered, else submit.
 *
 * The correct answer is never changed. If the model disagrees with the stored
 * answer it says so in `answer_concern`, which is appended to ai_notes for
 * an admin to review.
 *
 * Env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY,
 *      MODE, LIMIT, MODEL (default claude-sonnet-5)
 */

import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const MODE = (process.env.MODE || "auto").toLowerCase();
const LIMIT = process.env.LIMIT ? Math.max(1, parseInt(process.env.LIMIT, 10)) : null;
const MODEL = process.env.MODEL || "claude-sonnet-5";
const BATCH_KEY = "mcq_explanation_backfill_batch";

// Batch API rates for claude-sonnet-5 (50% of $2 / $10 per MTok).
const BATCH_INPUT_USD_PER_MTOK = 1.0;
const BATCH_OUTPUT_USD_PER_MTOK = 5.0;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY || !process.env.ANTHROPIC_API_KEY) {
  console.error("Missing SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY / ANTHROPIC_API_KEY");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
const anthropic = new Anthropic();

// strict: true (+ additionalProperties: false on every object level, and
// every property listed in `required`) makes the API validate tool_use.input
// against this schema before returning it — the live batch run below found
// stop_reason="tool_use" is not enough on its own: 238/1000 calls completed
// "successfully" but silently omitted a required field (usually
// key_takeaway or one choice's explanation), with no error to catch. Strict
// mode turns that into a guarantee instead of a probability.
const TOOL = {
  name: "write_detailed_explanation",
  description: "เขียนเฉลยละเอียดสำหรับข้อสอบ MCQ หนึ่งข้อ",
  strict: true,
  input_schema: {
    type: "object",
    additionalProperties: false,
    properties: {
      explanation: {
        type: "string",
        description:
          "เฉลยหลัก 2-3 ประโยค: บอกว่าคำตอบที่ถูกคืออะไร และเหตุผลสำคัญที่สุดที่ทำให้ถูก (ไม่ใช่สรุปสั้นบรรทัดเดียว)",
      },
      detailed_explanation: {
        type: "object",
        additionalProperties: false,
        properties: {
          summary: { type: "string", description: "1 ประโยค: คำตอบที่ถูกคืออะไร" },
          reason: {
            type: "string",
            description:
              "เหตุผลโดยละเอียดอย่างน้อย 3 ประโยค: ดึง key finding จากโจทย์ → พยาธิสรีรวิทยา/หลักการ → ทำไมจึงนำไปสู่คำตอบนี้",
          },
          choices: {
            type: "array",
            description: "ครบทุกตัวเลือกตามลำดับ A-E",
            items: {
              type: "object",
              additionalProperties: false,
              properties: {
                label: { type: "string" },
                text: { type: "string" },
                is_correct: { type: "boolean" },
                explanation: {
                  type: "string",
                  description:
                    "อย่างน้อย 2 ประโยค: ตัวเลือกนี้คืออะไร และทำไมถูก/ผิดสำหรับผู้ป่วยรายนี้โดยเฉพาะ",
                },
              },
              required: ["label", "text", "is_correct", "explanation"],
            },
          },
          key_takeaway: {
            type: "string",
            description: "1-2 ประโยคที่ควรจำไปสอบ (high-yield pearl)",
          },
        },
        required: ["summary", "reason", "choices", "key_takeaway"],
      },
      // strict:true requires every property to be listed in `required`, but
      // a field that's genuinely optional still needs a clean "nothing to
      // say" value: nullable + required, not a plain optional string. Tested
      // the plain-string version live on 30 rows — forced to always emit
      // *something*, the model didn't reliably use "" for "no concern" and
      // instead wrote the same ~18-character garbage placeholder (an XML
      // closing-tag-shaped string, unrelated to any real question content)
      // on 29 of them. Nullable removes the pressure to invent a value.
      answer_concern: {
        type: ["string", "null"],
        description:
          "null ถ้าเห็นด้วยกับคำตอบที่ให้มา ถ้าไม่เห็นด้วยให้อธิบายสั้นๆ ว่าคิดว่าคำตอบควรเป็นข้อใดเพราะอะไร (ห้ามเปลี่ยนคำตอบเอง)",
      },
    },
    required: ["explanation", "detailed_explanation", "answer_concern"],
  },
};

const SYSTEM = `คุณเป็นอาจารย์แพทย์ที่เขียนเฉลยข้อสอบใบประกอบวิชาชีพเวชกรรม (NL Step 1-2) ให้นักศึกษาแพทย์
มาตรฐานเฉลย:
- ยึดคำตอบที่ให้มาเป็นคำตอบที่ถูก อธิบายให้เห็นเส้นทางการคิดจาก key finding ในโจทย์ไปถึงคำตอบ
- อธิบาย "ทุก" ตัวเลือก ตัวเลือกที่ผิดต้องบอกว่าผิดเพราะอะไรในบริบทผู้ป่วยรายนี้ (ไม่ใช่แค่ "ไม่ใช่")
- ภาษาไทยทางคลินิกที่อ่านลื่น ศัพท์แพทย์ใช้ภาษาอังกฤษในวงเล็บเมื่อจำเป็น ไม่แปลศัพท์เทคนิคแบบแข็งๆ
- อิง evidence-based medicine และแนวทางที่ใช้ในประเทศไทย
- ถ้าโจทย์เป็นภาษาอังกฤษ ให้เฉลยเป็นภาษาไทยเช่นกัน`;

function buildPrompt(q) {
  const choices = (q.choices ?? [])
    .map((c) => `${c.label}. ${c.text}`)
    .join("\n");
  return `วิชา: ${q.subject_th ?? "-"} | ระดับ: ${q.exam_type ?? "NL2"} | ความยาก: ${q.difficulty ?? "-"}

โจทย์:
${q.scenario}

ตัวเลือก:
${choices}

คำตอบที่ถูก (ยึดตามนี้): ${q.correct_answer}

เฉลยสั้นเดิม (ใช้เป็นข้อมูลอ้างอิงได้ แต่เขียนใหม่ให้ละเอียดกว่า):
${q.explanation ?? "(ไม่มี)"}

เขียนเฉลยละเอียดแล้วเรียก tool write_detailed_explanation`;
}

async function loadTargets() {
  let query = supabase
    .from("mcq_questions")
    .select("id, difficulty, exam_type, scenario, choices, correct_answer, explanation, ai_notes, mcq_subjects(name_th)")
    .eq("status", "active")
    .eq("audience", "student")
    .is("detailed_explanation", null)
    .order("created_at", { ascending: true });
  const { data, error } = await query;
  if (error) throw new Error(`load targets: ${error.message}`);
  const rows = (data ?? []).map((r) => ({ ...r, subject_th: r.mcq_subjects?.name_th ?? null }));
  // Review-queue rows (activated 2026-08-30) are what students hit most — first.
  rows.sort((a, b) => {
    const ra = /ตรวจทานจากคิว review/.test(a.ai_notes ?? "") ? 0 : 1;
    const rb = /ตรวจทานจากคิว review/.test(b.ai_notes ?? "") ? 0 : 1;
    return ra - rb;
  });
  return LIMIT ? rows.slice(0, LIMIT) : rows;
}

async function rememberedBatchId() {
  const { data } = await supabase.from("app_settings").select("value").eq("key", BATCH_KEY).maybeSingle();
  return data?.value || null;
}

async function submit() {
  const targets = await loadTargets();
  if (targets.length === 0) {
    console.log("Nothing to backfill — every active student question already has detailed_explanation.");
    return;
  }
  console.log(`Submitting ${targets.length} questions to the Batch API (${MODEL})...`);

  const batch = await anthropic.messages.batches.create({
    requests: targets.map((q) => ({
      custom_id: q.id,
      params: {
        model: MODEL,
        max_tokens: 4000,
        // Leave thinking at its default (adaptive) — forced tool_choice with
        // thinking explicitly disabled is a known combination where the model
        // occasionally writes the tool call into visible text instead of a
        // real tool_use block (silently fails validation below, no error).
        system: SYSTEM,
        messages: [{ role: "user", content: buildPrompt(q) }],
        tools: [TOOL],
        tool_choice: { type: "tool", name: TOOL.name },
      },
    })),
  });

  await supabase
    .from("app_settings")
    .upsert({ key: BATCH_KEY, value: batch.id, updated_at: new Date().toISOString() });
  console.log(`Batch ${batch.id} created (status: ${batch.processing_status}). Run again with MODE=collect once it ends.`);
}

async function collect() {
  const batchId = await rememberedBatchId();
  if (!batchId) {
    console.log("No batch remembered — run MODE=submit first.");
    return;
  }
  const batch = await anthropic.messages.batches.retrieve(batchId);
  const c = batch.request_counts;
  console.log(
    `Batch ${batchId}: ${batch.processing_status} — processing ${c.processing}, succeeded ${c.succeeded}, errored ${c.errored}, expired ${c.expired}, canceled ${c.canceled}`
  );
  if (batch.processing_status !== "ended") {
    console.log("Still running — run again later.");
    return;
  }

  const stamp = new Date().toISOString().slice(0, 10);
  let written = 0;
  let skipped = 0;
  let failed = 0;
  let concerns = 0;
  let inputTokens = 0;
  let outputTokens = 0;
  const samples = [];

  for await (const result of await anthropic.messages.batches.results(batchId)) {
    const id = result.custom_id;
    if (result.result.type !== "succeeded") {
      failed += 1;
      console.warn(`[${id}] ${result.result.type}: ${JSON.stringify(result.result.error ?? {}).slice(0, 200)}`);
      continue;
    }
    const msg = result.result.message;
    inputTokens += msg.usage?.input_tokens ?? 0;
    outputTokens += msg.usage?.output_tokens ?? 0;

    const toolUse = msg.content.find((b) => b.type === "tool_use");
    const out = toolUse?.input;
    const detailed = out?.detailed_explanation;
    if (!detailed?.summary || !detailed?.reason || !Array.isArray(detailed?.choices) || !detailed?.key_takeaway) {
      failed += 1;
      console.warn(`[${id}] incomplete tool output (stop_reason=${msg.stop_reason})`);
      continue;
    }

    const { data: row } = await supabase
      .from("mcq_questions")
      .select("ai_notes, detailed_explanation")
      .eq("id", id)
      .maybeSingle();
    if (!row || row.detailed_explanation) {
      skipped += 1; // filled by someone else in the meantime — leave it
      continue;
    }

    const concern = (out.answer_concern ?? "").trim();
    if (concern) concerns += 1;
    const note =
      `[${stamp}] เติมเฉลยละเอียดด้วย ${MODEL} (batch)` + (concern ? ` ⚠️ AI ไม่แน่ใจคำตอบ: ${concern}` : "");
    const patch = {
      detailed_explanation: detailed,
      explanation: out.explanation || undefined,
      ai_notes: row.ai_notes ? `${row.ai_notes}\n${note}` : note,
    };
    const { error } = await supabase.from("mcq_questions").update(patch).eq("id", id).is("detailed_explanation", null);
    if (error) {
      failed += 1;
      console.warn(`[${id}] update failed: ${error.message}`);
      continue;
    }
    written += 1;
    if (samples.length < 3) samples.push({ id, explanation: out.explanation, detailed, concern });
  }

  const usd = (inputTokens / 1e6) * BATCH_INPUT_USD_PER_MTOK + (outputTokens / 1e6) * BATCH_OUTPUT_USD_PER_MTOK;
  console.log(`\nWritten ${written}, skipped ${skipped}, failed ${failed}, answer concerns ${concerns}`);
  console.log(`Tokens: input ${inputTokens}, output ${outputTokens} → ~$${usd.toFixed(2)} at batch rates` +
    (written ? ` (~$${(usd / written).toFixed(4)} per question)` : ""));
  for (const s of samples) {
    console.log(`\n=== sample ${s.id} ===`);
    console.log(JSON.stringify({ explanation: s.explanation, ...s.detailed, answer_concern: s.concern }, null, 2));
  }

  await supabase.from("app_settings").delete().eq("key", BATCH_KEY);
  console.log("\nBatch id cleared. Run MODE=submit again to backfill any remaining rows.");
}

async function run() {
  if (MODE === "submit") return submit();
  if (MODE === "collect") return collect();
  if (MODE === "auto") return (await rememberedBatchId()) ? collect() : submit();
  throw new Error(`Unknown MODE "${MODE}" — use submit | collect | auto`);
}

run().catch((err) => {
  console.error("Fatal:", err);
  process.exit(1);
});
