/**
 * The full-text books store their section headings as plain inline text:
 * a short label followed by an em dash, e.g.
 *
 *   "FUNCTIONS OF ORGANELLES — cell compartmentalisation makes ..."
 *   "Golgi apparatus — receives proteins from ER, modifies ..."
 *
 * Markdown has no idea these are headings, so every block renders as an
 * identical paragraph — one dense, uniform wall of text with no hierarchy.
 *
 * `formatChapterBody` recovers that lost structure. It promotes each label into
 * a real markdown `### heading` and breaks the explanation that follows into its
 * own paragraph, so the reader can scan sections and tell headings apart from
 * body text. Two complementary rules cover the conventions seen in the content:
 *
 *  1. A short label that *starts a block* (the dominant convention) — whether
 *     ALL-CAPS or Title-case — becomes that block's heading.
 *  2. An ALL-CAPS label that appears *mid-paragraph* at a sentence boundary
 *     (e.g. a sub-topic introduced part-way through a block) is split out into
 *     its own heading too.
 */

// An ALL-CAPS label: an uppercase run plus a few connectors (space, +, /,
// parentheses, &, ', -, .) ending in a letter, digit, or ")". Excluding
// lowercase letters keeps ordinary sentences from matching.
const CAPS_LABEL = "[A-Z][A-Z0-9 '\"&+/().-]{1,58}[A-Z0-9)]";

// Mid-paragraph ALL-CAPS sub-label: only at the start of the text or right after
// a sentence boundary (`.`, `)`, `:`, `]` + whitespace), so mid-sentence
// acronyms like "(cyclic AMP) —" are not mistaken for headings.
const MID_CAPS_RE = new RegExp(`(^|[.):\\]]\\s+)(${CAPS_LABEL})\\s+—\\s+`, "g");

// A block-leading label: short, no sentence/list punctuation (no `.`, `:`, `;`,
// `—`, or newline), immediately followed by a spaced em dash. This accepts both
// ALL-CAPS ("CELLS —") and Title-case ("Golgi apparatus —") headings.
const LEAD_RE = /^([^\n.:;—]{2,55}?)\s+—\s+([\s\S]+)$/;

function isLabelLike(label: string): boolean {
  // Must contain a letter, and must not look like a numbered list item such as
  // "(1) colchicine" — those are body text, not headings.
  return /[A-Za-z]/.test(label) && !/\(\d/.test(label);
}

// Split ALL-CAPS sub-labels in a block's body onto their own heading lines.
function promoteMidLabels(text: string): string {
  return text.replace(
    MID_CAPS_RE,
    (_match, boundary: string, label: string) =>
      `${boundary.trimEnd()}\n\n### ${label.trim()}\n\n`
  );
}

export function formatChapterBody(md: string): string {
  if (!md) return "";

  const out: string[] = [];
  for (const raw of md.split(/\n{2,}/)) {
    const block = raw.trim();
    if (!block) continue;

    const lead = block.match(LEAD_RE);
    if (lead && isLabelLike(lead[1])) {
      // The em dash was only a label separator — drop it, keep the label as a
      // heading and the explanation as the paragraph that follows.
      out.push(`### ${lead[1].trim()}`);
      out.push(promoteMidLabels(lead[2]));
    } else {
      out.push(promoteMidLabels(block));
    }
  }

  return out.join("\n\n").replace(/\n{3,}/g, "\n\n").trim();
}
