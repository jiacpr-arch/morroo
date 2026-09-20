/**
 * Lesson figures (รูปประกอบบทเรียน).
 *
 * A figure is authored in `body_md` as a plain markdown image whose *title*
 * carries the caption, so no custom syntax is needed and `splitLessonParts`
 * keeps working untouched:
 *
 *   ![alt สั้น ๆ](https://…/figure.svg "คำบรรยายใต้รูป 1 ประโยค")
 *
 * `LessonFigure` (components/school/LessonFigure.tsx) renders that image as a
 * figure with the title as its caption. The helpers here build and inspect
 * that markdown so the admin panel, the generation script and the lesson list
 * all agree on the format.
 */

export interface FigureMeta {
  /** Short description for screen readers / when the image fails to load. */
  alt?: string;
  /** One-sentence caption shown under the figure. */
  caption?: string;
}

/** Straight double quotes would terminate the markdown title — swap for curly ones. */
function safeTitle(caption: string): string {
  return caption.replace(/"/g, "”").trim();
}

/** Square brackets inside alt text would break the image syntax. */
function safeAlt(alt: string): string {
  return alt.replace(/[[\]]/g, "").trim();
}

/** Build the markdown for one figure. Caption is optional; alt defaults to empty. */
export function figureMarkdown(url: string, meta: FigureMeta = {}): string {
  const alt = meta.alt ? safeAlt(meta.alt) : "";
  const caption = meta.caption ? safeTitle(meta.caption) : "";
  return caption ? `![${alt}](${url} "${caption}")` : `![${alt}](${url})`;
}

const IMAGE_RE = /!\[[^\]]*\]\(\s*(<[^>]+>|[^\s)]+)/;

/** URL of the first image in a markdown body (used as the lesson thumbnail), or null. */
export function firstImageUrl(md: string | null | undefined): string | null {
  if (!md) return null;
  const m = md.match(IMAGE_RE);
  if (!m) return null;
  const raw = m[1];
  return raw.startsWith("<") ? raw.slice(1, -1) : raw;
}

/** True when the body contains at least one markdown image. */
export function hasFigures(md: string | null | undefined): boolean {
  return firstImageUrl(md) !== null;
}

/**
 * Caption text from a markdown image title. Authors sometimes prefix the
 * title with "caption:" (as the plan's examples did) — strip it so it never
 * shows up under the figure.
 */
export function captionFromTitle(title: string | null | undefined): string | null {
  if (!title) return null;
  const t = title.replace(/^\s*caption\s*:\s*/i, "").trim();
  return t || null;
}
