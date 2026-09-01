/**
 * Repair bloated choice text in board-seed-data/*.json.
 *
 * Problem: many AI-generated seed questions have the full bulleted
 * explanation crammed into the correct-answer choice (often 500-2000
 * chars), making the MCQ visually unbalanced and the answer obvious.
 *
 * Fix: for each choice whose text is disproportionately long compared
 * to the other choices in the same question, extract a short clean
 * answer and prepend the original long text to the question's
 * `explanation` so no clinical content is lost.
 *
 * Heuristic for the short answer (tried in order):
 *  1) "Topic header (1) **First item** ..." — the prefix before the
 *     first " (1) **" bullet is the topic. Use that.
 *  2) "**Topic** ..." — the first **bold** phrase. Skip if it looks
 *     like a sub-heading (1-2 words like "Pathophysiology",
 *     "Definition", "Mechanism").
 *  3) The first clause before a heavy separator (— → ; : (1)).
 *  4) Truncate at ~180 chars.
 *
 * Re-runnable: detects its own marker in explanation to avoid
 * duplicating content.
 */

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(HERE, "board-seed-data");

const ABS_LEN_THRESHOLD = 250; // chars
const RATIO_THRESHOLD = 3;     // bloated if > 3x median of other choices
const MAX_ANSWER_LEN = 220;
const MIN_ANSWER_LEN = 4;
const FIX_MARKER = "<!-- choice-detail -->";

// Sub-heading words that on their own are too generic to be an answer.
const GENERIC_HEADINGS = new Set([
  "pathophysiology", "definition", "mechanism", "epidemiology",
  "etiology", "clinical", "clinical features", "diagnosis", "workup",
  "investigation", "investigations", "management", "treatment",
  "prevention", "prognosis", "background", "overview", "introduction",
  "history", "physical exam", "examination", "labs", "imaging",
  "assessment", "evaluation", "approach", "principles", "types",
  "classification", "screening", "follow-up", "complications",
  "risk factors", "comprehensive evaluation", "safety assessment first",
]);

function median(arr) {
  const s = [...arr].sort((a, b) => a - b);
  const m = Math.floor(s.length / 2);
  return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2;
}

function cleanAnswerText(s) {
  return s
    .trim()
    .replace(/\*\*/g, "") // strip ALL bold markers
    .replace(/^[:：\-—]+\s*|\s*[:：]+\s*$/g, "")
    .replace(/^\(?\s*\d+\s*\)?\s*[.)\-]?\s*/, "") // leading "(1) " or "1. "
    .trim();
}

function looksGeneric(s) {
  const lower = s.toLowerCase().replace(/[*:]/g, "").trim();
  if (GENERIC_HEADINGS.has(lower)) return true;
  // 1-2 word headings without medical specifics → likely generic.
  if (lower.split(/\s+/).length <= 2 && lower.length < 25) {
    // allow if it contains numbers or abbreviations (e.g. "PNH", "T2DM")
    if (/[A-Z]{2,}|\d/.test(s)) return false;
    return true;
  }
  return false;
}

/**
 * Extract a clean short answer from a bloated choice text.
 */
function extractCleanAnswer(text) {
  const stripped = text.trim();

  // Strategy A: text starts with "**Topic** ..." — the first bold IS the topic.
  if (stripped.startsWith("**")) {
    const m = stripped.match(/^\*\*([^*]{4,300})\*\*/);
    if (m) {
      const b = cleanAnswerText(m[1]);
      if (b.length >= MIN_ANSWER_LEN && b.length <= MAX_ANSWER_LEN && !looksGeneric(b)) {
        return b;
      }
    }
  }

  // Strategy B: "Topic ... (1) **first item** ..." — prefix before " (1) **" is topic.
  const bulletIdx = stripped.search(/[\s:：]\(1\)\s+\*\*/);
  if (bulletIdx > 4) {
    const prefix = cleanAnswerText(stripped.slice(0, bulletIdx));
    if (
      prefix.length >= MIN_ANSWER_LEN &&
      prefix.length <= 200 &&
      !looksGeneric(prefix)
    ) {
      return prefix;
    }
  }

  // Strategy C: first **bold** anywhere, skipping generic sub-headings.
  const boldRe = /\*\*([^*]{2,300})\*\*/g;
  let m;
  while ((m = boldRe.exec(stripped)) !== null) {
    const b = cleanAnswerText(m[1]);
    if (b.length < MIN_ANSWER_LEN) continue;
    if (looksGeneric(b)) continue;
    return b.length > MAX_ANSWER_LEN ? b.slice(0, MAX_ANSWER_LEN - 3) + "..." : b;
  }

  // Strategy D: first clause before a heavy separator.
  const cut = stripped.split(/\s—\s|\s→\s|\s\(\d\)\s|[:：]\s/)[0].trim();
  const cleaned = cleanAnswerText(cut);
  if (cleaned.length >= MIN_ANSWER_LEN && cleaned.length <= MAX_ANSWER_LEN) {
    return cleaned;
  }

  // Strategy E: truncate.
  return cleanAnswerText(stripped).slice(0, MAX_ANSWER_LEN - 3).trim() + "...";
}

function prependDetailToExplanation(explanation, label, originalText) {
  const detailBlock = `${FIX_MARKER} **ตัวเลือก ${label} (รายละเอียด):** ${originalText}`;
  const existing = (explanation || "").trim();
  if (existing.startsWith(FIX_MARKER) && existing.includes(originalText.slice(0, 80))) {
    return existing;
  }
  return existing ? `${detailBlock}\n\n---\n\n${existing}` : detailBlock;
}

function fixQuestion(q) {
  const lens = q.choices.map((c) => c.text.length);
  const sortedLens = [...lens].sort((a, b) => a - b);
  const medOthers = median(sortedLens.slice(0, Math.max(2, sortedLens.length - 1)));

  let changed = false;
  for (const choice of q.choices) {
    const len = choice.text.length;
    const isBloated =
      len > ABS_LEN_THRESHOLD && len > RATIO_THRESHOLD * Math.max(medOthers, 20);
    if (!isBloated) continue;

    const original = choice.text;
    const clean = extractCleanAnswer(original);
    if (!clean || clean.length >= original.length * 0.8) continue;

    q.explanation = prependDetailToExplanation(q.explanation, choice.label, original);
    choice.text = clean;
    changed = true;
  }
  return changed;
}

function main() {
  const files = readdirSync(SEED_DIR).filter((f) => f.endsWith(".json")).sort();
  let totalQ = 0;
  let totalChanged = 0;

  for (const file of files) {
    const path = join(SEED_DIR, file);
    const data = JSON.parse(readFileSync(path, "utf8"));
    let fileChanged = 0;
    for (const q of data) {
      totalQ++;
      if (fixQuestion(q)) {
        fileChanged++;
        totalChanged++;
      }
    }
    writeFileSync(path, JSON.stringify(data, null, 2) + "\n", "utf8");
    console.log(`${file}: fixed ${fileChanged}/${data.length}`);
  }
  console.log(`\nTotal: fixed ${totalChanged}/${totalQ} questions`);
}

main();
