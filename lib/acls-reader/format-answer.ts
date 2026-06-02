// Render-time content normalizer for the ACLS reader.
//
// Daily-generated answers land in Supabase as flat plain text: each thought on
// its own single-newline line, "หัวข้อ:" labels, and "1." numbered points —
// but no Markdown structure. Rendered as-is that collapses into one gray wall
// of text. This turns that plain text into structured Markdown (headings, bold
// labels, real lists, separated paragraphs) so every upload reads like the
// hand-formatted "previous days" content, automatically.
//
// Design goals:
//   * Conservative — content that is ALREADY structured (Markdown headings,
//     tables, fenced code) is left alone apart from blank-line tidying.
//   * Idempotent — running it on its own output is a no-op.
//   * Outline-aware — a standalone "N. Title" line that owns the sub-content
//     beneath it becomes a numbered section heading (keeping N), while a tight
//     run of numbered lines stays a real ordered list. This avoids the
//     confusing "1. … 1. … 1." that a naive per-item reset produces.

// A line that is purely a SHORT section label, e.g. "ประโยชน์ที่พบ:". The cap
// keeps it to title-length phrases so long lead-in sentences that merely end
// with a colon ("…โดยใช้กลไก:") stay paragraphs instead of becoming headings.
const HEADING_COLON = /^(.{2,48}):$/;
/** A leading "Label: rest of sentence" inline definition (label up to ~60). */
const LABEL_INLINE = /^([^:]{2,60}):\s+(\S.*)$/;
const UL_ITEM = /^\s*[-*•]\s+/;
const OL_ITEM = /^\s*\d+[.)]\s+/;
const HR_LINE = /^\s*[-–—_]{3,}\s*$/;
// Thai "for example / as follows / namely" cues that introduce a list. When a
// line ends with one of these, the short lines that follow are list items.
const LIST_CUE = /(?:เช่น|ได้แก่|ดังนี้|ต่อไปนี้|อาทิ)\s*[:：]?\s*$/;
/** A list item may be fairly long (a phrase with parentheticals) … */
const ITEM_MAX = 90;
/** … but a line this long is body prose / a section that owns what follows. */
const PARAGRAPH_LEN = 80;

/**
 * True when the source already carries block-level Markdown structure
 * (headings, tables, fenced code). Such content is author-formatted — we
 * must not re-flow it, only tidy spacing.
 */
function alreadyStructured(text: string): boolean {
  return (
    /^\s*#{1,6}\s+\S/m.test(text) || // ATX heading
    /^\s*\|.*\|\s*$/m.test(text) || // table row
    /```/.test(text) // fenced code
  );
}

function collapseBlankRuns(text: string): string {
  return text.replace(/\r\n?/g, "\n").replace(/\n{3,}/g, "\n\n").trim();
}

type Block =
  | { kind: "heading"; text: string }
  | { kind: "para"; text: string }
  | { kind: "hr" }
  | { kind: "ul"; items: string[] }
  | { kind: "ol"; items: string[] };

function classify(raw: string): string {
  // Work on non-empty, trimmed lines; paragraph spacing is re-derived on output.
  const lines = raw
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.length > 0);

  // A numbered line is a real list item only when it sits next to another
  // numbered line (a contiguous run). A numbered line that stands alone —
  // followed by its own sub-content, like "1. กลไก…\nรายละเอียด…" — is really a
  // section header, so we promote it to a heading and KEEP its number (1, 2, 3…)
  // instead of resetting every isolated item back to "1.".
  const numbered = lines.map((l) => OL_ITEM.test(l));
  const inRun = numbered.map(
    (n, i) => n && (!!numbered[i - 1] || !!numbered[i + 1])
  );

  const blocks: Block[] = [];
  // Turns on right after a line ending in a list cue ("…เช่น:"); while on, the
  // short lines that follow are gathered into a bullet list. Kept narrow on
  // purpose so it never touches table-like runs (which have no cue before them).
  let bulletMode = false;

  const isItemish = (s: string) =>
    s.length <= ITEM_MAX && !s.includes(":") && !s.includes("：");
  // A short line that owns a long following paragraph is a heading, not an
  // item — this is how the list terminates before a wrap-up section.
  const ownsParagraph = (i: number) => (lines[i + 1]?.length ?? 0) >= PARAGRAPH_LEN;

  lines.forEach((trimmed, i) => {
    if (HR_LINE.test(trimmed)) {
      bulletMode = false;
      blocks.push({ kind: "hr" });
      return;
    }

    if (UL_ITEM.test(trimmed)) {
      const item = trimmed.replace(UL_ITEM, "");
      const last = blocks[blocks.length - 1];
      if (last?.kind === "ul") last.items.push(item);
      else blocks.push({ kind: "ul", items: [item] });
      return;
    }

    if (numbered[i]) {
      bulletMode = false;
      if (inRun[i]) {
        const item = trimmed.replace(OL_ITEM, "");
        const last = blocks[blocks.length - 1];
        if (last?.kind === "ol") last.items.push(item);
        else blocks.push({ kind: "ol", items: [item] });
      } else {
        // Standalone numbered item → numbered section heading, number kept.
        const m = /^(\d+)[.)]\s+(.*)$/.exec(trimmed);
        blocks.push({ kind: "heading", text: m ? `${m[1]}. ${m[2]}` : trimmed });
      }
      return;
    }

    // Inside a cued list: short, label-free lines become bullets. A line that
    // is long or owns a following paragraph ends the list and falls through.
    if (bulletMode && isItemish(trimmed) && !ownsParagraph(i)) {
      const last = blocks[blocks.length - 1];
      if (last?.kind === "ul") last.items.push(trimmed);
      else blocks.push({ kind: "ul", items: [trimmed] });
      return;
    }
    bulletMode = false;

    // Already-bold lines pass through untouched (keeps us idempotent).
    if (!trimmed.includes("**")) {
      const colon = HEADING_COLON.exec(trimmed);
      if (colon) {
        blocks.push({ kind: "heading", text: colon[1].trim() });
        bulletMode = LIST_CUE.test(trimmed);
        return;
      }

      const label = LABEL_INLINE.exec(trimmed);
      // Skip URLs and other "scheme://" shapes that aren't real labels.
      if (label && !/^https?$/i.test(label[1].trim()) && !label[2].startsWith("//")) {
        blocks.push({ kind: "para", text: `**${label[1].trim()}:** ${label[2].trim()}` });
        return;
      }
    }

    blocks.push({ kind: "para", text: trimmed });
    bulletMode = LIST_CUE.test(trimmed);
  });

  const out = blocks.map((b) => {
    switch (b.kind) {
      case "heading":
        return `## ${b.text}`;
      case "hr":
        return "---";
      case "ul":
        return b.items.map((i) => `- ${i}`).join("\n");
      case "ol":
        return b.items.map((i, idx) => `${idx + 1}. ${i}`).join("\n");
      case "para":
        return b.text;
    }
  });

  return out.join("\n\n");
}

/**
 * Normalize a raw answer/body string into readable, sectioned Markdown.
 * Safe to call on already-formatted content and on its own output.
 */
export function normalizeAnswer(raw: string | null | undefined): string {
  if (!raw || !raw.trim()) return "";
  const text = collapseBlankRuns(raw);
  if (alreadyStructured(text)) return text;
  return classify(text);
}
