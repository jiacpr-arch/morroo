// ลิงก์ LINE OA ท้ายเกมเคส (@901nmwcd) — แยกออกมาจาก DebriefSignupCta เพื่อ
// เทสต์ได้แบบ pure และกันไม่ให้แก้ข้อความแล้วพังการจับเจตนาของบอทโดยไม่รู้ตัว
//
// บรรทัดแรกของข้อความ "ขอโค้ดทดลอง Premium ฟรี" ต้อง**คงเดิมเป๊ะ** เพราะแมตช์
// กับ TRIAL_INTENT_PATTERNS ใน lib/bot-intent.ts (/ทดลอง/, /โค้ด/) — บอทถึงจะ
// ออกโค้ด monthly_1m ให้อัตโนมัติทันทีที่ผู้เล่นกดส่ง
//
// 2026-09-15: เพิ่มบรรทัดที่สองบอกที่มา (slug + เกรด) เพื่อให้ทีมเซลล์/แอดมิน
// ที่ตอบแชทเห็นว่าคนนี้มาจากเกมเคสตัวไหน — ไม่กระทบการจับเจตนาของบอทเพราะ
// TRIAL_INTENT_PATTERNS แค่ .test() หาคำในทั้งข้อความ ไม่สนใจว่ามีบรรทัดอื่นปน

export const CASEGAME_LINE_OA_ID = "@901nmwcd";

/** ต้องอยู่บรรทัดแรกเสมอ ห้ามแก้คำ — ดู lib/bot-intent.test.ts */
export const LINE_TRIAL_INTENT_LINE = "ขอโค้ดทดลอง Premium ฟรี";

export interface LineTrialSource {
  slug: string;
  grade?: string | null;
}

export function lineTrialMessage(src: LineTrialSource): string {
  const gradeSuffix = src.grade ? ` เกรด ${src.grade}` : "";
  return `${LINE_TRIAL_INTENT_LINE}\n(มาจากเกมเคส ${src.slug}${gradeSuffix})`;
}

export function lineOaTrialUrl(src: LineTrialSource): string {
  return `https://line.me/R/oaMessage/${CASEGAME_LINE_OA_ID}/?${encodeURIComponent(lineTrialMessage(src))}`;
}
