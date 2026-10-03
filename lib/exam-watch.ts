/**
 * Pure logic ของ cron เฝ้าประกาศ ศรว. (/api/cron/exam-watch)
 *
 * หลักการ: ดึง HTML หน้าข่าว cmathai.org → สกัดเฉพาะบรรทัดที่เกี่ยวกับ
 * กำหนดการสอบ → เทียบกับ snapshot ครั้งก่อนใน app_settings → บรรทัดใหม่
 * = มีประกาศใหม่ → แจ้ง LINE admin (และอ่านวันสอบอัปเดตปฏิทินอัตโนมัติ — lib/exam-round-scan.ts)
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
    "ระบบอ่านประกาศแล้วอัปเดตปฏิทินสอบให้เองอัตโนมัติ (ถ้าอ่านวันสอบได้ชัดเจน จะมีข้อความแจ้งแยกอีกฉบับ) — ตรวจ/แก้ได้ที่หน้า /admin/exam-dates",
  ].join("\n");
}

// ─── ลิงก์ประกาศ + เนื้อหา (ใช้อ่านวันสอบอัตโนมัติ — lib/exam-round-scan.ts) ───────

export const CMA_NEWS_URL = "https://cmathai.org/news";
const CMA_HOSTS = new Set(["cmathai.org", "www.cmathai.org"]);
const DETAIL_PATH = /^\/news\/detail\/\d+\/?$/;
const PDF_PATH = /^\/news_attach\/[^?#]+\.pdf$/i;

/**
 * URL ที่อนุญาตให้ดึง: https + host ของ ศรว. เท่านั้น (กัน SSRF/ลิงก์แปลกจากหน้าเว็บที่ untrusted)
 * kind = "detail" (หน้ารายละเอียดประกาศ) หรือ "pdf" (ไฟล์แนบ); อย่างอื่นคืน null
 */
export function classifyCmaUrl(href: string, base: string = CMA_NEWS_URL): { url: string; kind: "detail" | "pdf" } | null {
  let u: URL;
  try {
    u = new URL(href, base);
  } catch {
    return null;
  }
  if (u.protocol !== "https:" || !CMA_HOSTS.has(u.hostname) || u.username || u.password) return null;
  u.hash = "";
  if (DETAIL_PATH.test(u.pathname)) return { url: u.toString(), kind: "detail" };
  if (PDF_PATH.test(u.pathname)) return { url: u.toString(), kind: "pdf" };
  return null;
}

/** ตรวจ URL ปลายทางหลัง redirect ว่ายังอยู่ใน host ที่อนุญาต */
export function isCmaHost(url: string): boolean {
  try {
    const u = new URL(url);
    return u.protocol === "https:" && CMA_HOSTS.has(u.hostname);
  } catch {
    return false;
  }
}

const ANCHOR_RE = /<a\s[^>]*?href\s*=\s*["']([^"']+)["'][^>]*>([\s\S]*?)<\/a>/gi;

function anchorText(inner: string): string {
  return inner
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/\s+/g, " ")
    .trim();
}

/** ลิงก์หน้ารายละเอียดประกาศที่หัวข้อเกี่ยวกับการสอบ (ตามลำดับในหน้า — ใหม่สุดก่อน) */
export function extractAnnouncementLinks(html: string, base: string = CMA_NEWS_URL, limit = 8): { url: string; text: string }[] {
  const out: { url: string; text: string }[] = [];
  const seen = new Set<string>();
  for (const m of html.matchAll(ANCHOR_RE)) {
    const c = classifyCmaUrl(m[1], base);
    if (!c || c.kind !== "detail" || seen.has(c.url)) continue;
    const text = anchorText(m[2]);
    if (!KEYWORD.test(text)) continue;
    seen.add(c.url);
    out.push({ url: c.url, text });
    if (out.length >= limit) break;
  }
  return out;
}

/** ไฟล์ PDF แนบในหน้ารายละเอียดประกาศ */
export function extractPdfLinks(html: string, base: string = CMA_NEWS_URL, limit = 2): string[] {
  const out: string[] = [];
  for (const m of html.matchAll(ANCHOR_RE)) {
    const c = classifyCmaUrl(m[1], base);
    if (c && c.kind === "pdf" && !out.includes(c.url)) out.push(c.url);
    if (out.length >= limit) break;
  }
  return out;
}

/** HTML → ข้อความล้วน (ตัด script/style/comment/tag) สำหรับส่งให้ AI อ่าน */
export function htmlToText(html: string): string {
  return html
    .replace(/<script[\s\S]*?<\/script>/gi, " ")
    .replace(/<style[\s\S]*?<\/style>/gi, " ")
    .replace(/<!--[\s\S]*?-->/g, " ")
    .replace(/<(br|\/p|\/div|\/li|\/h\d|\/tr)\s*\/?>/gi, "\n")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/&quot;/gi, '"')
    .replace(/&#0?39;/g, "'")
    .replace(/[ \t\f\v]+/g, " ")
    .replace(/\n\s*\n+/g, "\n")
    .trim();
}
