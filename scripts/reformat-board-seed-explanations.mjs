/**
 * Reformat the `explanation` field in board-seed-data/*.json so it
 * renders cleanly + readably in the UI (which renders plain text only,
 * no markdown).
 *
 * The source AI output is one giant run-on paragraph with semicolons,
 * em-dashes, and inline `-` bullets. We:
 *
 *  1) Drop the legacy `<!-- choice-detail -->` marker.
 *  2) Strip all `**bold**` markers.
 *  3) Promote `ตัวเลือก X (รายละเอียด):` to its own heading line.
 *  4) Replace `---` separator with a clear Unicode horizontal break.
 *  5) Break paragraphs before `(N) `, `N. Title`, and `A. Title`/`B. Title`
 *     enumerated sections.
 *  6) Convert inline ` - X` micro-bullets to indented `  • X` lines so
 *     each list item gets its own row.
 *  7) Collapse 3+ blank lines down to 2.
 *
 * Idempotent: re-running produces no further changes.
 */

import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED_DIR = join(HERE, "board-seed-data");

function reformat(text) {
  if (!text) return text;
  let t = text;

  // 1) Drop the legacy HTML comment marker.
  t = t.replace(/<!--\s*choice-detail\s*-->\s*/g, "");

  // 2) Strip all bold markdown markers — they show as literal `**`.
  t = t.replace(/\*\*/g, "");

  // 3) Promote "ตัวเลือก X (รายละเอียด):" to its own header line.
  t = t.replace(
    /^\s*ตัวเลือก\s*([A-E])\s*\(รายละเอียด\)\s*:\s*/m,
    "ตัวเลือก $1 (รายละเอียด)\n\n"
  );

  // 4) Visible Unicode break for the `---` separator.
  t = t.replace(/^\s*-{3,}\s*$/gm, "————————————————");

  // 5a) Paragraph break before "(N) " enumerated bullets.
  t = t.replace(/\s+\((\d{1,2})\)\s+/g, "\n\n($1) ");

  // 5b) Paragraph break before "N. Word" numbered sections — break on any
  //     " N. CapitalLetter", even mid-clause. The source often runs
  //     "1. Foo 2. Bar 3. Baz" without separators.
  //     Uses a negative lookbehind to avoid splitting decimals like "1.2"
  //     (which never have a space anyway, but belt + suspenders).
  t = t.replace(/(?<!\d)\s+(\d{1,2})\.\s+(?=[A-Z0-9])/g, "\n\n$1. ");

  // 5c) Paragraph break before lettered sections "A. ", "B. ", "C. "...
  //     Only at clause boundary to avoid breaking initials in names.
  t = t.replace(/([;:.])\s+([A-F])\.\s+(?=[A-Z])/g, "$1\n\n$2. ");

  // 6) Inline " - X" sub-bullets → indented bullet on a new line.
  //    Only convert when the next char is alphanumeric (so we don't break
  //    inline math like "10 - 5"). Em-dashes "—" are untouched.
  t = t.replace(/\s+-\s+(?=[A-Za-z0-9])/g, "\n  • ");

  // 7) Collapse 3+ consecutive newlines down to 2.
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
