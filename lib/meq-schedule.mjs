// Shared helpers for the auto MEQ generator (scripts/generate-meq-weekly.mjs
// and app/api/exams/generate-weekly/route.ts). Plain .mjs so the Node script
// can import it without a TS build step.

export const MEQ_CATEGORIES = [
  "อายุรศาสตร์",
  "ศัลยศาสตร์",
  "กุมารเวชศาสตร์",
  "สูติศาสตร์-นรีเวชวิทยา",
  "ออร์โธปิดิกส์",
  "จิตเวชศาสตร์",
];

export const MEQ_DIFFICULTIES = ["easy", "medium", "hard"];

/**
 * Pick category + difficulty for a run (2 runs/week: Mon + Thu).
 * Difficulty advances once per full pass through the categories, so every
 * category cycles through easy → medium → hard. (The old formula tied each
 * category to one fixed difficulty, e.g. กุมารฯ was always "medium".)
 * @param {Date} now
 */
export function pickMeqSlot(now) {
  const weekOfYear = Math.floor(
    (now.getTime() - new Date(now.getFullYear(), 0, 1).getTime()) / (7 * 24 * 60 * 60 * 1000)
  );
  const dayOfWeek = now.getUTCDay(); // 0=Sun, 1=Mon, 4=Thu
  const slot = weekOfYear * 2 + (dayOfWeek >= 4 ? 1 : 0);
  return {
    weekOfYear,
    dayOfWeek,
    category: MEQ_CATEGORIES[slot % MEQ_CATEGORIES.length],
    difficulty: MEQ_DIFFICULTIES[Math.floor(slot / MEQ_CATEGORIES.length) % MEQ_DIFFICULTIES.length],
  };
}

/** Normalize a title for duplicate comparison (whitespace/punctuation-insensitive). */
export function normalizeMeqTitle(title) {
  return String(title ?? "")
    .toLowerCase()
    .replace(/[\s.,:;'"()\-–—]+/g, "");
}

/**
 * True when `title` matches an existing title, or one is a prefix of the
 * other (catches "…ผื่นขึ้น" vs "…ผื่นขึ้นตามตัว").
 * @param {string} title
 * @param {string[]} existingTitles
 */
export function isDuplicateMeqTitle(title, existingTitles) {
  const t = normalizeMeqTitle(title);
  if (!t) return false;
  return existingTitles.some((e) => {
    const n = normalizeMeqTitle(e);
    return n && (n === t || n.startsWith(t) || t.startsWith(n));
  });
}

/** Prompt block listing cases already in the category so the model avoids them. */
export function existingCasesPromptBlock(existingTitles) {
  if (!existingTitles.length) return "";
  return `\nเคสที่มีอยู่แล้วในสาขานี้ (ห้ามสร้างเคสที่มีอาการนำ/กลุ่มอายุ/โรคเดียวกันกับรายการนี้ ให้เลือกโรคและผู้ป่วยที่ต่างออกไปอย่างชัดเจน):\n${existingTitles
    .map((t) => `- ${t}`)
    .join("\n")}\n`;
}
