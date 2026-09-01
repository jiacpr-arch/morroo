// "link_only" stays in the type union for back-compat with rows that already
// recorded it before the format catalog was trimmed — picker no longer emits it.
export type AutopostFormat = "cover_caption" | "quote_card" | "link_only";

// All formats now post via /feed + `link` (see lib/facebook.ts) so every
// autopost renders as a clickable link card. The format only chooses which
// cover variant to use (designed cover with text vs. quote card from /api/og).
const FORMATS: AutopostFormat[] = ["cover_caption", "quote_card"];

/**
 * Deterministic format selection by slug hash — same slug always yields the
 * same format so retries post the same visual style as the original attempt.
 */
export function pickAutopostFormat(slug: string): AutopostFormat {
  let h = 0;
  for (let i = 0; i < slug.length; i++) {
    h = (h * 31 + slug.charCodeAt(i)) | 0;
  }
  return FORMATS[Math.abs(h) % FORMATS.length];
}

export function categoryHashtag(category: string): string {
  const map: Record<string, string> = {
    "ความรู้ทั่วไป": "ความรู้การแพทย์",
    "เตรียมสอบ": "เตรียมสอบแพทย์",
    "เทคนิคสอบ": "เทคนิคสอบแพทย์",
  };
  return map[category] ?? "แพทยศาสตร์";
}
