// ทะเบียนเกมของหน้า Games Hub (game.morroo.com) — data ล้วน ไม่มี component
// เพื่อให้ import ได้ทั้งจาก server page และ client card โดยไม่ติดปัญหา
// serialize ข้าม RSC boundary (ไอคอนเก็บเป็นชื่อ string แล้วไป map เป็น
// lucide component ในฝั่ง client ที่ components/games/GameHubCard.tsx)
//
// เกมกระจายอยู่หลายเว็บใต้ *.morroo.com — hub นี้เป็นแค่ "ป้ายบอกทาง"
// ลิงก์ออกไปเล่นที่เว็บต้นทาง จึงเก็บ href เป็น absolute URL ทั้งหมด
// (รวมเกมของ morroo เองด้วย เพราะ hub เสิร์ฟบน subdomain แยก)

/** ชื่อไอคอนที่การ์ดรองรับ — GameHubCard ต้องมี map ครบทุกตัว (คุมด้วย type) */
export const HUB_ICON_NAMES = [
  "Bandage",
  "Heart",
  "HeartPulse",
  "Activity",
  "Wind",
  "Zap",
  "Syringe",
  "Siren",
  "Stethoscope",
  "Ambulance",
] as const;
export type HubIconName = (typeof HUB_ICON_NAMES)[number];

/** สีประจำการ์ด — จับคู่กับแบรนด์จริงของเว็บปลายทาง (BLS = ฟ้า Sky, firstaid =
 * เขียว, CPR = แดงหัวใจ ฯลฯ) เพื่อให้การ์ดไม่กลืนกันและจำเว็บต้นทางได้
 * GameHubCard ต้องมี style map ครบทุกสี (คุมด้วย type) */
export type HubAccent =
  | "emerald"
  | "rose"
  | "sky"
  | "red"
  | "cyan"
  | "amber"
  | "violet"
  | "teal";

/** กลุ่มผู้เล่น — เรียงจากพื้นฐานสุด → เฉพาะทางสุด ตามลำดับที่แสดงบนหน้า */
export type GameAudience = "public" | "provider" | "doctor";

export interface HubGame {
  /** ใช้เป็น target ใน analytics event `games_hub_click` และ utm_content */
  id: string;
  title: string;
  desc: string;
  /** absolute URL ใต้ *.morroo.com เท่านั้น (มีเทสคุม) */
  href: string;
  /** ป้ายพิเศษ เช่น เกมที่อยู่ในคอร์ส — ไม่ใส่ = เล่นฟรี */
  badge?: string;
  tags: string[];
  icon: HubIconName;
  accent: HubAccent;
  audience: GameAudience;
  /** การ์ดกะทัดรัด (แถวเว็บคอร์สทักษะ 3 ใบ) */
  compact?: boolean;
}

export const AUDIENCE_GROUPS: {
  id: GameAudience;
  title: string;
  desc: string;
}[] = [
  {
    id: "public",
    title: "ประชาชนทั่วไป",
    desc: "ไม่ต้องมีพื้นฐานการแพทย์ — ฝึกช่วยชีวิตคนตรงหน้าให้เป็น",
  },
  {
    id: "provider",
    title: "บุคลากรทางการแพทย์ / ผู้เรียนคอร์ส",
    desc: "ฝึกทีมกู้ชีพ BLS · ACLS และทักษะหัตถการตามแนวทางล่าสุด",
  },
  {
    id: "doctor",
    title: "นักศึกษาแพทย์ / แพทย์",
    desc: "เกมเคสจากข้อสอบจริง เก็บ XP ขึ้น Leaderboard บนหมอรู้",
  },
];

export const HUB_GAMES: HubGame[] = [
  // ---- ประชาชนทั่วไป --------------------------------------------------
  {
    id: "firstaid_sim",
    title: "สถานการณ์จำลองปฐมพยาบาล",
    desc: "40 เหตุฉุกเฉินใกล้ตัว — เลือกทำทีละขั้นเหมือนอยู่ในเหตุการณ์จริง แล้วดูว่าคุณช่วยเขาทันไหม",
    href: "https://firstaid.morroo.com/simulation",
    tags: ["40 เคส", "ไม่ต้องมีพื้นฐาน", "มีใบประกาศ"],
    icon: "Bandage",
    accent: "emerald",
    audience: "public",
  },
  {
    id: "cpr_hero",
    title: "CPR Hero",
    desc: "เกมกู้ชีพในคอร์ส CPR & AED ออนไลน์ — เคสสำลัก หัวใจหยุดเต้น จนถึงด่านสุดท้าย Final Rescue",
    href: "https://cpr.morroo.com",
    badge: "ในคอร์ส CPR & AED",
    tags: ["เรียนจบใน 1 วัน", "ใบเซอร์ + ส่วนลดคอร์สปฏิบัติ"],
    icon: "Heart",
    accent: "rose",
    audience: "public",
  },

  // ---- บุคลากร / ผู้เรียนคอร์ส -----------------------------------------
  {
    id: "bls_hub",
    title: "BLS — Code Blue Sim + เกมผู้บันทึก",
    desc: "ฝึกกู้ชีพขั้นพื้นฐานสำหรับบุคลากร: จำลองทีมกู้ชีพ เกมผู้บันทึก และ EMR drill ครบในเว็บเดียว",
    href: "https://bls.morroo.com",
    tags: ["BLS", "ILCOR 2025", "เล่นฟรีไม่ต้องล็อกอิน"],
    icon: "HeartPulse",
    accent: "sky",
    audience: "provider",
  },
  {
    id: "acls_hub",
    title: "ACLS — Code Blue Sim + เกมผู้บันทึก",
    desc: "คุมทีมกู้ชีพขั้นสูง อ่าน rhythm สั่งยา ช็อกไฟฟ้า — พร้อมเกมผู้บันทึกและ EMR drill",
    href: "https://acls.morroo.com",
    tags: ["ACLS", "ILCOR 2025", "เล่นฟรีไม่ต้องล็อกอิน"],
    icon: "Activity",
    accent: "red",
    audience: "provider",
  },
  {
    id: "skill_airway",
    title: "เกมเคส Airway",
    desc: "ทางเดินหายใจและการใส่ท่อ",
    href: "https://airway.morroo.com",
    tags: [],
    icon: "Wind",
    accent: "cyan",
    audience: "provider",
    compact: true,
  },
  {
    id: "skill_defib",
    title: "เกมเคส Defib",
    desc: "เครื่องช็อกไฟฟ้าหัวใจ",
    href: "https://defib.morroo.com",
    tags: [],
    icon: "Zap",
    accent: "amber",
    audience: "provider",
    compact: true,
  },
  {
    id: "skill_iv",
    title: "เกมเคส IV",
    desc: "การเปิดเส้นให้สารน้ำ",
    href: "https://iv.morroo.com",
    tags: [],
    icon: "Syringe",
    accent: "violet",
    audience: "provider",
    compact: true,
  },

  // ---- นักศึกษาแพทย์ / แพทย์ -------------------------------------------
  {
    id: "morroo_sim",
    title: "Code Blue Sim",
    desc: "คุณคือ Team Leader — ทีมทั้งห้องรอฟังคำสั่ง ตัดสินใจผิดผู้ป่วยแย่ลงจริง เวลาไม่เคยรอใคร",
    href: "https://www.morroo.com/sim",
    tags: ["เก็บ XP + Badge", "Leaderboard"],
    icon: "Siren",
    accent: "rose",
    audience: "doctor",
  },
  {
    id: "morroo_casegame",
    title: "เกมเคส (Long Case + MEQ)",
    desc: "ไล่เคสจริงตั้งแต่ซักประวัติ ตรวจร่างกาย สั่ง investigation จนถึงวางแผนรักษา — จากคลังข้อสอบจริง",
    href: "https://www.morroo.com/casegame",
    tags: ["เคสใหม่ทุกสัปดาห์", "อาจารย์ซักถามท้ายเคส"],
    icon: "Stethoscope",
    accent: "teal",
    audience: "doctor",
  },
  {
    id: "morroo_resus",
    title: "Resus Hero",
    desc: "เกมกู้ชีพภาคปฏิบัติ — ลงมือทำหัตถการเองทีละขั้น ไม่ใช่แค่เลือกคำตอบ",
    href: "https://www.morroo.com/resus",
    tags: ["หัตถการกู้ชีพ"],
    icon: "Ambulance",
    accent: "amber",
    audience: "doctor",
  },
];

/** เกมในกลุ่ม แยกการ์ดปกติ/กะทัดรัด ตามลำดับใน HUB_GAMES */
export function gamesForAudience(audience: GameAudience): {
  featured: HubGame[];
  compact: HubGame[];
} {
  const games = HUB_GAMES.filter((g) => g.audience === audience);
  return {
    featured: games.filter((g) => !g.compact),
    compact: games.filter((g) => g.compact),
  };
}
