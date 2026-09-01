/**
 * Pure logic ของ cron เฝ้าประกาศ ศรว. (/api/cron/exam-watch)
 *
 * หลักการ: ดึง HTML หน้าข่าว cmathai.org → สกัดเฉพาะบรรทัดที่เกี่ยวกับ
 * กำหนดการสอบ → เทียบกับ snapshot ครั้งก่อนใน app_settings → บรรทัดใหม่
 * = มีประกาศใหม่ → แจ้ง LINE admin ให้มาอัพเดท lib/exam-dates.ts
 *
 * แยกเป็น pure function เพื่อให้เทสได้โดยไม่ต้องยิงเว็บจริง
 */

/** key ใน app_settings ที่เก็บ snapshot บรรทัดล่าสุด (JSON string[]) */
export const EXAM_WATCH_SETTINGS_KEY = "exam_watch_lines";

const KEYWORD =
  /(ขั้นตอนที่|Step ?[123]|OSCE|MEQ|กำหนดการ|ตารางสอบ|วันสอบ|รับสมัคร|สมัครสอบ|ประกาศ)/i;

/**
 * สกัดบรรทัดข้อความที่น่าจะเป็นหัวข้อประกาศ/กำหนดการสอบจาก HTML
 * คืนลิสต์ unique ตามลำดับที่พบ (จำกัดจำนวนกันหน้าเว็บเปลี่ยน layout ใหญ่)
 */
export function extractAnnouncementLines(html: string): string[] {
  const text = html
    .replace(/<script[\s\S]*?<\/script>/gi, " ")
    .replace(/<style[\s\S]*?<\/style>/gi, " ")
    .replace(/<!--[\s\S]*?-->/g, " ")
    .replace(/<[^>]+>/g, "\n")
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/&quot;/gi, '"')
    .replace(/&#0?39;/g, "'");

  const lines = text
    .split("\n")
    .map((l) => l.replace(/\s+/g, " ").trim())
    // สั้นเกิน = เมนู/ปุ่ม, ยาวเกิน = ย่อหน้าเนื้อหา — เอาเฉพาะระดับหัวข้อ
    .filter((l) => l.length >= 10 && l.length <= 250 && KEYWORD.test(l));

  return [...new Set(lines)].slice(0, 100);
}

/** บรรทัดที่เพิ่งโผล่ใหม่เทียบกับ snapshot ก่อนหน้า */
export function diffNewLines(prev: string[], current: string[]): string[] {
  const prevSet = new Set(prev);
  return current.filter((l) => !prevSet.has(l));
}

/** ข้อความ LINE แจ้ง admin เมื่อเจอประกาศใหม่ */
export function buildAdminAlert(newLines: string[]): string {
  const shown = newLines.slice(0, 6);
  const more = newLines.length - shown.length;
  return [
    "📢 เว็บ ศรว. (cmathai.org) มีประกาศ/เนื้อหาใหม่",
    "",
    ...shown.map((l) => `• ${l}`),
    ...(more > 0 ? [`…และอีก ${more} รายการ`] : []),
    "",
    "ดูประกาศ: https://cmathai.org/news",
    "ถ้าเป็นกำหนดการสอบใหม่ → อัพเดท lib/exam-dates.ts (วันที่ + confirmed: true) แล้ว deploy — ปฏิทิน /nl/calendar กับแบนเนอร์นับถอยหลังจะอัพเดทเอง",
  ].join("\n");
}
