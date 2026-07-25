// ยศแพทย์ — "ตัวละคร" ของผู้เล่น คิดจาก XP สะสม (profiles.school_xp)
//
// ต่างจาก xpToLevel() ที่ให้ตัวเลขล้วน ๆ: ยศเป็นเส้นทางอาชีพจริงที่ผู้เรียน
// มองเห็นตัวเองอยู่ในนั้น ตั้งแต่ นศพ. ชั้นคลินิก ไปจนถึงศาสตราจารย์
//
// pure ทั้งไฟล์ (ไม่มี I/O) — ใช้ได้ทั้ง server component, client component
// และเทสต์

export interface DoctorRank {
  /** ลำดับขั้น เริ่มที่ 1 */
  tier: number;
  /** ชื่อเต็มที่ใช้แสดงเป็นหลัก */
  title: string;
  /** ชื่อย่อสำหรับป้ายแคบ ๆ เช่นในแถวตาราง */
  short: string;
  /** XP ต่ำสุดที่ได้ยศนี้ */
  minXp: number;
  /** ลักษณะพิเศษของยศ — บอกว่าตัวละคร "ทำอะไรเป็น" แล้ว */
  trait: string;
  icon: string;
}

/**
 * บันไดยศ 12 ขั้น ตามเส้นทางอาชีพแพทย์ไทยจริง
 *
 * ระยะห่างตั้งจากอัตราจริงของเกม (ชนะเคสได้ 30–150 XP ตาม `SIM_XP`) บวกกับ
 * XP จากฝั่ง school: ขั้นแรก ๆ ไต่ได้ในไม่กี่เคสเพื่อให้เห็นความคืบหน้าเร็ว
 * แล้วค่อยถ่างออกให้ปลายทางเป็นเป้าระยะยาว
 */
export const DOCTOR_RANKS: readonly DoctorRank[] = [
  {
    tier: 1,
    title: "นักศึกษาแพทย์ชั้นปีที่ 4",
    short: "นศพ. ปี 4",
    minXp: 0,
    trait: "เพิ่งขึ้นวอร์ด — ได้จับเคสจริงเป็นครั้งแรก",
    icon: "🩺",
  },
  {
    tier: 2,
    title: "นักศึกษาแพทย์ชั้นปีที่ 5",
    short: "นศพ. ปี 5",
    minXp: 250,
    trait: "ซักประวัติได้เป็นระบบ ไม่ตกประเด็นสำคัญ",
    icon: "📋",
  },
  {
    tier: 3,
    title: "นักศึกษาแพทย์ชั้นปีที่ 6",
    short: "เอกซ์เทิร์น",
    minXp: 700,
    trait: "ตรวจร่างกายครบระบบ และแปลผล lab เบื้องต้นได้เอง",
    icon: "🔬",
  },
  {
    tier: 4,
    title: "แพทย์ใช้ทุน",
    short: "อินเทิร์น",
    minXp: 1500,
    trait: "รับผิดชอบผู้ป่วยได้เอง ตัดสินใจหน้างานเป็น",
    icon: "🚑",
  },
  {
    tier: 5,
    title: "แพทย์ประจำบ้าน ปีที่ 1",
    short: "เรสิเดนต์ 1",
    minXp: 2800,
    trait: "วางแผนรักษาได้ครบ ตั้งแต่รับเคสจนจำหน่าย",
    icon: "🏥",
  },
  {
    tier: 6,
    title: "แพทย์ประจำบ้าน ปีที่ 2",
    short: "เรสิเดนต์ 2",
    minXp: 4500,
    trait: "จับสัญญาณอันตรายได้ไว แยกเคสหนักออกจากเคสทั่วไป",
    icon: "💉",
  },
  {
    tier: 7,
    title: "แพทย์ประจำบ้าน ปีที่ 3",
    short: "เรสิเดนต์ 3",
    minXp: 7000,
    trait: "คุมทีมในเคสฉุกเฉิน และสอนรุ่นน้องข้างเตียงได้",
    icon: "🧠",
  },
  {
    tier: 8,
    title: "แพทย์เฉพาะทาง",
    short: "เฟลโลว์",
    minXp: 10000,
    trait: "เจาะลึกสาขาของตัวเอง รับเคสที่ซับซ้อนกว่าเดิม",
    icon: "🎯",
  },
  {
    tier: 9,
    title: "อาจารย์แพทย์",
    short: "อาจารย์",
    minXp: 14000,
    trait: "ตัดสินเคสที่ตำราไม่ได้เขียนไว้ และสอนได้ทั้งวอร์ด",
    icon: "🎓",
  },
  {
    tier: 10,
    title: "ผู้ช่วยศาสตราจารย์",
    short: "ผศ.",
    minXp: 19000,
    trait: "วางแนวทางรักษาให้ทั้งหน่วยงานยึดเป็นมาตรฐาน",
    icon: "📚",
  },
  {
    tier: 11,
    title: "รองศาสตราจารย์",
    short: "รศ.",
    minXp: 25000,
    trait: "เป็นที่ปรึกษาเคสยากที่หน่วยอื่นส่งต่อมา",
    icon: "🏅",
  },
  {
    tier: 12,
    title: "ศาสตราจารย์",
    short: "ศ.",
    minXp: 32000,
    trait: "สูงสุดของสายวิชาการ — เคสไหนเข้ามาก็เอาอยู่",
    icon: "👑",
  },
] as const;

export const MAX_RANK_TIER = DOCTOR_RANKS[DOCTOR_RANKS.length - 1].tier;

export interface RankProgress {
  rank: DoctorRank;
  /** ยศขั้นถัดไป — null เมื่อถึงขั้นสูงสุดแล้ว */
  next: DoctorRank | null;
  /** XP ที่สะสมมาแล้วภายในยศปัจจุบัน */
  xpIntoRank: number;
  /** XP ที่ยศนี้ต้องใช้ทั้งหมดเพื่อขึ้นขั้นถัดไป (0 เมื่อขั้นสูงสุด) */
  xpForNext: number;
  /** ความคืบหน้าไปยังขั้นถัดไป 0–100 (ขั้นสูงสุด = 100) */
  progress: number;
}

/** แปลง XP สะสม → ยศปัจจุบัน + ความคืบหน้าไปขั้นถัดไป */
export function xpToRank(xp: number): RankProgress {
  const safeXp = Number.isFinite(xp) && xp > 0 ? Math.floor(xp) : 0;

  let index = 0;
  for (let i = DOCTOR_RANKS.length - 1; i >= 0; i--) {
    if (safeXp >= DOCTOR_RANKS[i].minXp) {
      index = i;
      break;
    }
  }

  const rank = DOCTOR_RANKS[index];
  const next = DOCTOR_RANKS[index + 1] ?? null;
  if (!next) {
    return { rank, next: null, xpIntoRank: safeXp - rank.minXp, xpForNext: 0, progress: 100 };
  }

  const xpForNext = next.minXp - rank.minXp;
  const xpIntoRank = safeXp - rank.minXp;
  return {
    rank,
    next,
    xpIntoRank,
    xpForNext,
    progress: Math.min(100, Math.round((xpIntoRank / xpForNext) * 100)),
  };
}

/** ขึ้นยศหรือยัง เมื่อ XP ขยับจาก before → after */
export function didRankUp(xpBefore: number, xpAfter: number): boolean {
  return xpToRank(xpAfter).rank.tier > xpToRank(xpBefore).rank.tier;
}

/**
 * ชื่อเรียกเต็มของตัวละคร = ยศ + สาขาที่เชี่ยวชาญ
 *
 * เช่น "ศาสตราจารย์ผู้เชี่ยวชาญอายุรศาสตร์" เมื่อไต่ถึงขั้นสูงสุดและสะสม
 * เคสสาขาเดียวมากพอ — ไม่มีสาขาถนัดก็คืนชื่อยศเปล่า ๆ
 */
export function fullTitle(xp: number, expertSpecialty?: string | null): string {
  const { rank } = xpToRank(xp);
  if (!expertSpecialty) return rank.title;
  return `${rank.title}ผู้เชี่ยวชาญ${expertSpecialty}`;
}
