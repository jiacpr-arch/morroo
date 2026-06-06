/**
 * Build the `detailed_explanation` jsonb for every board seed question
 * so the UI renders the same structured layout it uses for student MCQ
 * (summary card + reason card + per-choice cards + key takeaway).
 *
 * Source material: the (already reformatted) `explanation` field, which
 * is laid out as:
 *
 *   ตัวเลือก X (รายละเอียด)
 *
 *   [short answer / summary]
 *   ————————————————
 *   [detailed reasoning with bullets]
 *   [optional: "A ผิด — …  C ผิด — …" per-choice tail]
 *
 * Output schema (matches what components/McqPractice.tsx consumes):
 *
 *   {
 *     summary: string,
 *     reason:  string,
 *     choices: [
 *       { label, text, is_correct, explanation }
 *     ],
 *     key_takeaway?: string,
 *   }
 *
 * Re-runnable: simply overwrites the field on each run.
 */

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(HERE, "board-seed-data");

const SEPARATOR_RE = /\n[——]{8,}\n/;
const CHOICE_HEADER_RE = /^ตัวเลือก\s+[A-E]\s*\(รายละเอียด\)\s*[\n:]*\s*/;

const VERDICT = "ผิด(?:อย่างยิ่ง)?|ถูก(?:ต้อง|ตามมาตรฐาน|ตาม[\\u0E00-\\u0E7F]+)?|wrong|right|correct|incorrect|comprehensive|preferred|best|ไม่[\\u0E00-\\u0E7F]+";

function splitSummaryAndReason(explanation) {
  const expl = (explanation || "").trim();
  if (!expl) return { summary: "", reason: "" };

  const sepIdx = expl.search(SEPARATOR_RE);
  let summaryPart = "";
  let reasonPart = "";
  if (sepIdx >= 0) {
    summaryPart = expl.slice(0, sepIdx).trim();
    const afterSep = expl.slice(sepIdx).replace(SEPARATOR_RE, "").trim();
    reasonPart = afterSep;
  } else {
    // No separator → take first paragraph as summary, rest as reason.
    const paras = expl.split(/\n\n+/);
    if (paras.length > 1) {
      summaryPart = paras[0].trim();
      reasonPart = paras.slice(1).join("\n\n").trim();
    } else {
      summaryPart = expl.split(/[.;]\s/)[0].trim();
      reasonPart = expl;
    }
  }

  // Drop the "ตัวเลือก X (รายละเอียด)" header from summary.
  summaryPart = summaryPart.replace(CHOICE_HEADER_RE, "").trim();

  // Hard-cap summary so it doesn't duplicate the entire reason.
  if (summaryPart.length > 400) {
    const firstSentence = summaryPart.split(/[.;]\s/)[0];
    summaryPart =
      firstSentence.length > 0 && firstSentence.length <= 400
        ? firstSentence.trim()
        : summaryPart.slice(0, 397).trim() + "...";
  }

  return { summary: summaryPart, reason: reasonPart };
}

/**
 * Extract per-choice analysis (A ผิด — ..., B ถูก — ..., A wrong — ..., etc.)
 * from the tail of the explanation. Returns a map { A: text, B: text, ... }.
 */
function extractPerChoiceAnalysis(text) {
  const result = {};
  if (!text) return result;
  const tail = text.slice(-3500);

  // Split on candidate boundaries (start of "<L> <verdict>") to find segments.
  // Pattern: leading boundary (start, punctuation, em-dash, newline) + label A-E
  // + space + a verdict-ish word, then capture up to next boundary or end.
  const boundaryRe = new RegExp(
    `(?:^|[\\s.;!?]|[—\\u2014])([A-E])\\s+(${VERDICT})`,
    "gu"
  );

  const matches = [];
  let m;
  while ((m = boundaryRe.exec(tail)) !== null) {
    matches.push({ idx: m.index + m[0].indexOf(m[1]), label: m[1], verdictStart: m.index });
  }
  if (matches.length === 0) return result;

  for (let i = 0; i < matches.length; i++) {
    const cur = matches[i];
    const next = matches[i + 1];
    let segment = tail.slice(cur.idx, next ? next.idx : tail.length).trim();

    // Strip the leading "<L> " label
    segment = segment.replace(new RegExp(`^${cur.label}\\s+`, "u"), "");
    // Strip leading verdict word ("ผิด", "ถูก", "wrong", ...) + optional separator.
    segment = segment
      .replace(new RegExp(`^(?:${VERDICT})\\s*[—\\u2014\\-:]?\\s*`, "u"), "")
      .trim();
    // Drop trailing period if it's the only one.
    segment = segment.replace(/[.;\s]+$/u, "").trim();

    if (segment.length >= 5 && segment.length <= 350 && !result[cur.label]) {
      result[cur.label] = segment;
    }
  }
  return result;
}

function buildDetailed(q) {
  const { summary, reason } = splitSummaryAndReason(q.explanation);
  const sourceForChoices = reason || q.explanation || "";
  const perChoice = extractPerChoiceAnalysis(sourceForChoices);

  const correct = q.correct_answer;
  const choices = (q.choices || []).map((c) => {
    const fromTail = perChoice[c.label];
    const fallback =
      c.label === correct
        ? "เป็นคำตอบที่ถูกต้องตามแนวทางการรักษา — ดูเหตุผลโดยละเอียดด้านบน"
        : "ไม่ใช่คำตอบที่ดีที่สุดในสถานการณ์นี้ — ดูเหตุผลโดยละเอียดด้านบน";
    return {
      label: c.label,
      text: c.text,
      is_correct: c.label === correct,
      explanation: fromTail || fallback,
    };
  });

  return {
    summary: summary || `คำตอบที่ถูกต้องคือ ${correct}`,
    reason: reason || q.explanation || "",
    choices,
  };
}

function main() {
  const files = readdirSync(SEED_DIR).filter((f) => f.endsWith(".json")).sort();
  let total = 0;
  let built = 0;
  let withPerChoice = 0;
  for (const file of files) {
    const path = join(SEED_DIR, file);
    const data = JSON.parse(readFileSync(path, "utf8"));
    let fileBuilt = 0;
    let filePerChoice = 0;
    for (const q of data) {
      total++;
      const de = buildDetailed(q);
      if (de) {
        q.detailed_explanation = de;
        built++;
        fileBuilt++;
        const real = de.choices.filter(
          (c) => !c.explanation.includes("ดูเหตุผลโดยละเอียดด้านบน")
        ).length;
        if (real > 0) {
          withPerChoice++;
          filePerChoice++;
        }
      }
    }
    writeFileSync(path, JSON.stringify(data, null, 2) + "\n", "utf8");
    console.log(
      `${file}: built ${fileBuilt}/${data.length}, real per-choice on ${filePerChoice}`
    );
  }
  console.log(
    `\nTotal: built ${built}/${total} (real per-choice extracted on ${withPerChoice})`
  );
}

main();
