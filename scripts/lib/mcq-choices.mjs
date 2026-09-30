/**
 * Clean up the choices array the model returns for a 5-option MCQ.
 *
 * The model regularly appends a 6th choice — a copy of an earlier one, an
 * empty string or the literal "placeholder" — which trips the DB quality
 * gate (mcq_quality_gate: "จำนวนตัวเลือกผิดปกติ (6)") and parks an otherwise
 * good question in review. Drop blank/placeholder entries and repeated
 * labels/texts, keeping the first occurrence.
 *
 * Returns the cleaned A-E choices only when that yields exactly one choice per
 * label A-E; otherwise returns the input unchanged so the DB gate still flags
 * genuinely malformed questions.
 */

const LABELS = ["A", "B", "C", "D", "E"];

/** @param {unknown} text */
function isBlank(text) {
  const t = typeof text === "string" ? text.trim() : "";
  return t === "" || t.toLowerCase() === "placeholder";
}

/**
 * @template {{ label?: unknown, text?: unknown }} C
 * @param {C[]} choices
 * @returns {C[]}
 */
export function normalizeMcqChoices(choices) {
  if (!Array.isArray(choices)) return choices;
  const seenLabels = new Set();
  const seenTexts = new Set();
  const kept = [];
  for (const c of choices) {
    if (!c || typeof c !== "object" || isBlank(c.text)) continue;
    const label = typeof c.label === "string" ? c.label.trim() : "";
    const text = String(c.text).trim();
    if (seenLabels.has(label) || seenTexts.has(text)) continue;
    seenLabels.add(label);
    seenTexts.add(text);
    kept.push(c);
  }
  const ok =
    kept.length === LABELS.length &&
    LABELS.every((l) => kept.some((c) => String(c.label).trim() === l));
  if (!ok) return choices;
  return LABELS.map((l) => kept.find((c) => String(c.label).trim() === l));
}
