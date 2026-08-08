/**
 * เส้นแบ่งฟรี/จ่ายของโหมด School — ตรรกะล้วน ไม่แตะ DB (ทดสอบได้)
 *
 * หลักคิด: ตัดที่ "หัวข้อ" ไม่ใช่ "จำนวนใบ"
 *   - ผู้ใช้ฟรีได้หัวข้อตัวอย่าง (`school_topics.is_preview`) แบบเต็มรูปแบบ
 *     อ่านครบทุกบท ทำควิซครบทุกข้อ เห็นเฉลยเต็ม
 *   - หัวข้อที่เหลือทั้งหัวข้อเป็นของผู้จ่ายเงิน
 *
 * ทำไมไม่ตัดที่จำนวน: คลังบางหัวข้อมีของแค่ 12 ใบ การตัดที่ 10 ใบทำให้คนจ่ายเงิน
 * ได้ของเพิ่มแค่ 2 ใบ และต้องกลับมาจูนเลขใหม่ทุกครั้งที่คลังโตขึ้น
 */

import { hasSchoolAccess } from "@/lib/membership";

/** คอลัมน์ที่ต้อง select จาก profiles เพื่อตัดสินสิทธิ์ School */
export const SCHOOL_ACCESS_FIELDS = "membership_type, membership_expires_at";

/** เพดานจำนวน bookmark/note ของผู้ใช้ฟรี (บังคับจริงที่ trigger ใน DB ด้วย) */
export const SCHOOL_FREE_SAVE_LIMIT = 20;

/** จำนวนคำถาม AI ต่อวัน — soft cap ของฝั่งจ่ายเงินไว้กัน abuse ไม่ใช่กันคนใช้ */
export const SCHOOL_AI_DAILY_LIMIT = { free: 5, premium: 100 } as const;

export interface SchoolAccess {
  /** จ่ายเงินแล้ว — เข้าถึงทุกหัวข้อ + SRS + mixed */
  isPremium: boolean;
  /** true = ต้องกรองเนื้อหาให้เหลือเฉพาะหัวข้อตัวอย่าง */
  previewOnly: boolean;
  /** quota คำถาม AI ต่อวันของผู้ใช้คนนี้ */
  aiDailyLimit: number;
}

interface MembershipLike {
  membership_type?: string | null;
  membership_expires_at?: string | null;
}

export function schoolAccessFor(
  profile: MembershipLike | null | undefined
): SchoolAccess {
  const isPremium = hasSchoolAccess(profile);
  return {
    isPremium,
    previewOnly: !isPremium,
    aiDailyLimit: isPremium
      ? SCHOOL_AI_DAILY_LIMIT.premium
      : SCHOOL_AI_DAILY_LIMIT.free,
  };
}

/** สิทธิ์ของผู้ที่ยังไม่ล็อกอิน — เท่ากับผู้ใช้ฟรี */
export const ANONYMOUS_SCHOOL_ACCESS: SchoolAccess = {
  isPremium: false,
  previewOnly: true,
  aiDailyLimit: SCHOOL_AI_DAILY_LIMIT.free,
};

/** เปิดหัวข้อนี้ได้ไหม — ผู้ใช้ฟรีเปิดได้เฉพาะหัวข้อตัวอย่าง */
export function canOpenTopic(
  access: Pick<SchoolAccess, "isPremium">,
  topic: { is_preview?: boolean | null } | null | undefined
): boolean {
  if (access.isPremium) return true;
  return Boolean(topic?.is_preview);
}
