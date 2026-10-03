/**
 * อ่านวันที่ภาษาไทยในประกาศ เช่น "วันเสาร์ที่ 10 ตุลาคม 2569" → 2026-10-10
 *
 * ใช้เป็นตัวตรวจ "อิสระจาก AI" ตอนอ่านวันสอบอัตโนมัติ (lib/exam-round-extract.ts):
 * AI ต้องส่งทั้งวันที่ ISO และข้อความวันที่ตามประกาศ แล้วโค้ดนี้แปลงข้อความเองมาเทียบ —
 * จับความผิดพลาดที่เกิดบ่อยสุดคือแปลงปี พ.ศ. → ค.ศ. คลาดเคลื่อนหนึ่งปี
 */

export const THAI_WEEKDAYS = [
  "อาทิตย์",
  "จันทร์",
  "อังคาร",
  "พุธ",
  "พฤหัสบดี",
  "ศุกร์",
  "เสาร์",
] as const;

// [ชื่อเต็ม, ชื่อย่อ(ไม่มีจุดท้าย)] ตามลำดับเดือน 1-12
const MONTHS: ReadonlyArray<readonly [string, string]> = [
  ["มกราคม", "ม.ค"],
  ["กุมภาพันธ์", "ก.พ"],
  ["มีนาคม", "มี.ค"],
  ["เมษายน", "เม.ย"],
  ["พฤษภาคม", "พ.ค"],
  ["มิถุนายน", "มิ.ย"],
  ["กรกฎาคม", "ก.ค"],
  ["สิงหาคม", "ส.ค"],
  ["กันยายน", "ก.ย"],
  ["ตุลาคม", "ต.ค"],
  ["พฤศจิกายน", "พ.ย"],
  ["ธันวาคม", "ธ.ค"],
];

const esc = (s: string) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

// ชื่อเต็มก่อนชื่อย่อ เพื่อให้ regex จับชื่อยาวสุดก่อน
const MONTH_ALTERNATION = [...MONTHS.map(([full]) => full), ...MONTHS.map(([, abbr]) => abbr)]
  .sort((a, b) => b.length - a.length)
  .map(esc)
  .join("|");

const DATE_RE = new RegExp(
  `(?:วัน\\s*(${THAI_WEEKDAYS.join("|")})\\s*(?:ที่)?\\s*)?` +
    `(\\d{1,2})\\s*(${MONTH_ALTERNATION})\\.?\\s*(?:พ\\.ศ\\.\\s*|ค\\.ศ\\.\\s*)?(\\d{4})`
);

/** เลขไทย ๐-๙ → 0-9 และตัดช่องว่างซ้ำ — ใช้ก่อนเทียบข้อความ */
export function normalizeThaiText(s: string): string {
  return s
    .replace(/[๐-๙]/g, (d) => String("๐๑๒๓๔๕๖๗๘๙".indexOf(d)))
    .replace(/\s+/g, " ")
    .trim();
}

function monthNumber(name: string): number | null {
  const bare = name.replace(/\.$/, "");
  const i = MONTHS.findIndex(([full, abbr]) => full === bare || abbr === bare);
  return i < 0 ? null : i + 1;
}

export interface ParsedThaiDate {
  /** YYYY-MM-DD (ค.ศ.) */
  iso: string;
  /** วันในสัปดาห์ที่เขียนไว้ในข้อความ (0 = อาทิตย์) หรือ null ถ้าไม่ได้เขียน */
  weekday: number | null;
}

/** วันในสัปดาห์จริงของวันที่ ISO (0 = อาทิตย์) — ไม่ขึ้นกับ timezone */
export function weekdayOfIso(iso: string): number {
  const [y, m, d] = iso.split("-").map(Number);
  return new Date(Date.UTC(y, m - 1, d)).getUTCDay();
}

export function isRealIsoDate(iso: string): boolean {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(iso)) return false;
  const [y, m, d] = iso.split("-").map(Number);
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
}

/** อ่านวันที่แรกที่พบในข้อความ; ปี พ.ศ. (≥ 2400) แปลงเป็น ค.ศ.; ไม่ใช่วันที่จริง → null */
export function parseThaiDate(text: string): ParsedThaiDate | null {
  const m = normalizeThaiText(text).match(DATE_RE);
  if (!m) return null;
  const day = Number(m[2]);
  const month = monthNumber(m[3]);
  let year = Number(m[4]);
  if (month === null) return null;
  if (year >= 2400) year -= 543;
  const iso = `${String(year).padStart(4, "0")}-${String(month).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
  if (!isRealIsoDate(iso)) return null;
  return { iso, weekday: m[1] ? THAI_WEEKDAYS.indexOf(m[1] as (typeof THAI_WEEKDAYS)[number]) : null };
}
