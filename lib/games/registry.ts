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
  /** ภาพอธิบายสิ่งที่จะได้ฝึกบนการ์ดหลัก */
  image?: {
    src: string;
    alt: string;
  };
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
    desc: "17 เหตุฉุกเฉินใกล้ตัว — เลือกทำทีละขั้นเหมือนอยู่ในเหตุการณ์จริง แล้วดูว่าคุณช่วยเขาทันไหม",
    // สุ่มเคสแล้วเข้าเล่นทันที ข้ามหน้าเลือกฉาก — ใช้เกม FIRST AID HERO
    // (engine เดียวกับ Code Blue Sim, ?random=play ดูรายละเอียดที่ firstaid_game ด้านล่าง)
    // 17 เคส ไม่มีใบประกาศ — เกมนี้เป็นโหมดโบนัส แยกจาก progress/post-test/ใบเซอร์
    // ของคอร์สหลัก (firstaid/src/pages/FirstAidGame.jsx:33-34)
    href: "https://firstaid.morroo.com/game?random=play",
    tags: ["17 เคส", "ไม่ต้องมีพื้นฐาน"],
    icon: "Bandage",
    accent: "emerald",
    audience: "public",
    image: {
      src: "/images/games/courses/firstaid-simulation.jpg",
      alt: "ชุดปฐมพยาบาลและตัวอย่างสถานการณ์แผลไหม้ ข้อเท้าพลิก และผู้ที่ต้องการความช่วยเหลือ",
    },
  },
  {
    id: "cpr_hero",
    title: "CPR Hero",
    desc: "เกมกู้ชีพในคอร์ส CPR & AED ออนไลน์ — เคสสำลัก หัวใจหยุดเต้น จนถึงด่านสุดท้าย Final Rescue",
    // เล่นฟรีทุกเคส ไม่ได้ล็อกหลัง paywall จริง (ล็อกเฉพาะด่านสุดท้าย
    // Final Rescue ที่ต้องผ่านข้อสอบจบคอร์สก่อน) — ?game=random คือลิงก์
    // เดียวกับปุ่มแบนเนอร์ "ท้าดวลกู้ชีพ" ในแอป (src/App.jsx ของ jia-online)
    // สุ่มเคสแล้วเข้าเล่นทันที ข้ามหน้า landing/เลือกเคส
    href: "https://cpr.morroo.com/?game=random",
    badge: "ในคอร์ส CPR & AED",
    tags: ["เรียนจบใน 1 วัน", "ใบเซอร์ + ส่วนลดคอร์สปฏิบัติ"],
    icon: "Heart",
    accent: "rose",
    audience: "public",
    image: {
      src: "/images/games/courses/cpr-hero.jpg",
      alt: "ฝึกกดหน้าอกและใช้เครื่อง AED กับหุ่นฝึก CPR",
    },
  },
  {
    id: "firstaid_game",
    title: "FIRST AID HERO",
    desc: "คุณคือผู้ช่วยเหลือคนแรกในที่เกิดเหตุ — ตัดสินใจไว ผิดพลาดแล้วผู้ป่วยแย่ลงจริง เวลาไม่เคยรอใคร",
    // เกมโบนัสของ firstaid.morroo.com — คนละระบบกับ firstaid_sim (/simulation,
    // เกม decision-tree ทีละขั้น) อันนี้เป็น engine เดียวกับ Code Blue Sim
    // ?random=play สุ่มเคสแล้วข้ามจอเลือกเคส/title เข้าเกมทันที (PR #86 ของ
    // repo firstaid — คนละค่ากับ ?random=1 เดิมที่ใช้ในลิงก์ LINE OA/QR บูธ
    // ซึ่งข้ามแค่ไปจอ title)
    //
    // compact ชั่วคราว — ยังไม่มีรูปประกอบ (registry.test.ts บังคับให้การ์ด
    // featured ทุกใบต้องมีรูปสอนจริงในเครื่อง) พอมีรูปแล้วเปลี่ยนกลับเป็น
    // featured + เพิ่ม image ให้เหมือนการ์ดอื่น
    href: "https://firstaid.morroo.com/game?random=play",
    tags: [],
    icon: "Siren",
    accent: "violet",
    audience: "public",
    compact: true,
  },

  // ---- บุคลากร / ผู้เรียนคอร์ส -----------------------------------------
  {
    id: "bls_hub",
    title: "BLS — Code Blue Sim + เกมผู้บันทึก",
    desc: "ฝึกกู้ชีพขั้นพื้นฐานสำหรับบุคลากร: จำลองทีมกู้ชีพ เกมผู้บันทึก และ EMR drill ครบในเว็บเดียว",
    // root ของ subdomain เป็นหน้า landing (NewCase) ไม่ใช่เกม — ต้องชี้ตรงไป
    // /sim พร้อม ?autostart=1 (CodeBlueSim.jsx อ่านแล้วข้ามจอเลือกเคส/title
    // ไปเข้าเกมทันที, PR #385 ของ repo acls-emr) ถึงจะเข้าเล่นได้ทันทีจริง
    href: "https://bls.morroo.com/sim?autostart=1",
    tags: ["BLS", "ILCOR 2025", "เล่นฟรีไม่ต้องล็อกอิน"],
    icon: "HeartPulse",
    accent: "sky",
    audience: "provider",
    image: {
      src: "/images/games/courses/bls-team.jpg",
      alt: "ทีมกู้ชีพฝึกแบ่งบทบาทกดหน้าอก ช่วยหายใจ และบันทึกเวลาในสถานการณ์ BLS",
    },
  },
  {
    id: "acls_hub",
    title: "ACLS — Code Blue Sim + เกมผู้บันทึก",
    desc: "คุมทีมกู้ชีพขั้นสูง อ่าน rhythm สั่งยา ช็อกไฟฟ้า — พร้อมเกมผู้บันทึกและ EMR drill",
    href: "https://acls.morroo.com/sim?autostart=1",
    tags: ["ACLS", "ILCOR 2025", "เล่นฟรีไม่ต้องล็อกอิน"],
    icon: "Activity",
    accent: "red",
    audience: "provider",
    image: {
      src: "/images/games/courses/acls-leader.jpg",
      alt: "ทีม ACLS ฝึกอ่านคลื่นไฟฟ้าหัวใจ ใช้เครื่องช็อกไฟฟ้า และตัดสินใจให้ยา",
    },
  },
  {
    id: "skill_airway",
    title: "เกมเคส Airway",
    desc: "ทางเดินหายใจและการใส่ท่อ",
    href: "https://airway.morroo.com/sim?autostart=1",
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
    href: "https://defib.morroo.com/sim?autostart=1",
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
    href: "https://iv.morroo.com/sim?autostart=1",
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
    // เข้าเคสเรือธง (VF arrest) พร้อม autostart=1 (lib/sim/…/[slug]/page.tsx
    // อ่าน ?start=1 แล้วสั่ง SimRunner เริ่มเกมทันทีไม่ต้องกดซ้ำ) แทนหน้ารวมเคส
    href: "https://www.morroo.com/sim/vf-arrest-01?start=1",
    tags: ["เก็บ XP + Badge", "Leaderboard"],
    icon: "Siren",
    accent: "rose",
    audience: "doctor",
    image: {
      src: "/images/games/courses/code-blue-sim.jpg",
      alt: "แพทย์ฝึกเป็นผู้นำทีม Code Blue และเลือกคำสั่งในสถานการณ์จำลอง",
    },
  },
  {
    id: "morroo_casegame",
    title: "เกมเคส (Long Case + MEQ)",
    desc: "ไล่เคสจริงตั้งแต่ซักประวัติ ตรวจร่างกาย สั่ง investigation จนถึงวางแผนรักษา — จากคลังข้อสอบจริง",
    // /casegame/random เลือกเคสให้ (สุ่ม หรือแนะนำตามประวัติถ้าล็อกอิน) แล้ว
    // redirect ต่อไป /sim/{slug}?start=1 ให้เข้าเล่นทันที (route.ts มีอยู่แล้ว)
    href: "https://www.morroo.com/casegame/random?start=1",
    tags: ["เคสใหม่ทุกสัปดาห์", "อาจารย์ซักถามท้ายเคส"],
    icon: "Stethoscope",
    accent: "teal",
    audience: "doctor",
    image: {
      src: "/images/games/courses/long-case-meq.jpg",
      alt: "ฝึกคิดวิเคราะห์เคสตั้งแต่ซักประวัติ ตรวจร่างกาย ส่งตรวจ จนถึงวางแผนรักษา",
    },
  },
  {
    id: "morroo_resus",
    title: "Resus Hero",
    desc: "เกมกู้ชีพภาคปฏิบัติ — ลงมือทำหัตถการเองทีละขั้น ไม่ใช่แค่เลือกคำตอบ",
    // เข้าเคสเรือธง (VF arrest, ด่าน 1) พร้อม ?start=1 (app/(morroo)/resus/[slug]/page.tsx
    // อ่านแล้วสั่ง ResusRunner autostart) แทนหน้ารวมด่าน
    href: "https://www.morroo.com/resus/vf-arrest-01?start=1",
    tags: ["หัตถการกู้ชีพ"],
    icon: "Ambulance",
    accent: "amber",
    audience: "doctor",
    image: {
      src: "/images/games/courses/resus-procedures.jpg",
      alt: "สถานีฝึกช่วยหายใจ เปิดเส้นทางกระดูก และติดแผ่นช็อกไฟฟ้ากับหุ่นฝึก",
    },
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
