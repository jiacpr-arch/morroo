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

/** A line that is purely a section label, e.g. "ประโยชน์ที่พบ:" */
const HEADING_COLON = /^(.{2,90}):$/;
/** A leading "Label: rest of sentence" inline definition. */
const LABEL_INLINE = /^([^:]{2,40}):\s+(\S.*)$/;
const UL_ITEM = /^\s*[-*•]\s+/;
const OL_ITEM = /^\s*\d+[.)]\s+/;
const HR_LINE = /^\s*[-–—_]{3,}\s*$/;

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
  const lines = raw
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((l) => l.trimEnd());

  const blocks: Block[] = [];

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) continue;

    if (HR_LINE.test(trimmed)) {
      blocks.push({ kind: "hr" });
      continue;
    }

    if (UL_ITEM.test(trimmed)) {
      const item = trimmed.replace(UL_ITEM, "");
      const last = blocks[blocks.length - 1];
      if (last?.kind === "ul") last.items.push(item);
      else blocks.push({ kind: "ul", items: [item] });
      continue;
    }

    if (OL_ITEM.test(trimmed)) {
      const item = trimmed.replace(OL_ITEM, "");
      const last = blocks[blocks.length - 1];
      if (last?.kind === "ol") last.items.push(item);
      else blocks.push({ kind: "ol", items: [item] });
      continue;
    }

    // Already-bold lines pass through untouched (keeps us idempotent).
    if (!trimmed.includes("**")) {
      const colon = HEADING_COLON.exec(trimmed);
      if (colon) {
        blocks.push({ kind: "heading", text: colon[1].trim() });
        continue;
      }

      const label = LABEL_INLINE.exec(trimmed);
      // Skip URLs and other "scheme://" shapes that aren't real labels.
      if (label && !/^https?$/i.test(label[1].trim()) && !label[2].startsWith("//")) {
        blocks.push({ kind: "para", text: `**${label[1].trim()}:** ${label[2].trim()}` });
        continue;
      }
    }

    blocks.push({ kind: "para", text: trimmed });
  }

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
