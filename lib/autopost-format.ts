export type AutopostFormat = "cover_caption" | "quote_card" | "link_only";

// link_only ใช้ /feed + link param ซึ่ง FB reject ด้วย "url invalid"
// (App Domains + fb:app_id meta ยังไม่ช่วย — น่าจะต้อง business verification)
// ตัดออกชั่วคราว เหลือ 2 format ที่ใช้ /photos endpoint (มีรูปแน่นอน)
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
