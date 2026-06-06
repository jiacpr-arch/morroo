/**
 * Reformat the `explanation` field in board-seed-data/*.json so it
 * renders cleanly in the UI (which does NOT process markdown).
 *
 * Cleanup:
 *  - Remove the `<!-- choice-detail -->` HTML comment marker.
 *  - Strip all `**bold**` markdown markers — they show as literal `**`.
 *  - Replace the `---` separator with a visually clearer break.
 *  - Insert paragraph breaks before "(N) " enumerated bullets so the
 *    detailed walkthrough is readable instead of one giant paragraph.
 *  - Trim whitespace.
 *
 * Idempotent: detects already-reformatted explanations by absence of
 * the HTML comment marker AND the `**` markdown markers.
 */

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(HERE, "board-seed-data");

function reformat(text) {
  if (!text) return text;
  let t = text;

  // 1) Drop the HTML comment marker.
  t = t.replace(/<!--\s*choice-detail\s*-->\s*/g, "");

  // 2) Strip all bold markdown markers.
  t = t.replace(/\*\*/g, "");

  // 3) Normalize the "---" separator → a clearer Unicode break.
  t = t.replace(/^\s*---\s*$/gm, "————————————————");

  // 4) Paragraph break before "(N) " bullets so the walkthrough is
  //    readable. Only insert when preceded by sentence/clause punctuation
  //    (";", ".", ":") to avoid breaking inline mentions like "(2 hours)".
  t = t.replace(/([;.:])\s+\((\d{1,2})\)\s+/g, "$1\n\n($2) ");

  // 5) Collapse 3+ blank lines to 2.
  t = t.replace(/\n{3,}/g, "\n\n");

  return t.trim();
}

function main() {
  const files = readdirSync(SEED_DIR).filter((f) => f.endsWith(".json")).sort();
  let totalQ = 0;
  let changed = 0;
  for (const file of files) {
    const path = join(SEED_DIR, file);
    const data = JSON.parse(readFileSync(path, "utf8"));
    let fileChanged = 0;
    for (const q of data) {
      totalQ++;
      const before = q.explanation || "";
      const after = reformat(before);
      if (after !== before) {
        q.explanation = after;
        fileChanged++;
        changed++;
      }
    }
    writeFileSync(path, JSON.stringify(data, null, 2) + "\n", "utf8");
    console.log(`${file}: reformatted ${fileChanged}/${data.length}`);
  }
  console.log(`\nTotal reformatted: ${changed}/${totalQ}`);
}

main();
