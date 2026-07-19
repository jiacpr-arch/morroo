export type NetworkSite = {
  href: string;
  label: string;
  tagline: string;
  emoji: string;
};

/**
 * คอร์สอบรม + ใบเซอร์ในเครือ — แสดงเป็นการ์ดบนหน้าแรก www.morroo.com
 * แต่ละคอร์สมีสี accent ประจำตัว (sub-brand ภายใต้ design system เดียว)
 * ช่วงก่อน migration เสร็จ การ์ดลิงก์ไป subdomain เดิม แล้วค่อยสลับเป็น
 * internal route เมื่อคอร์สนั้นย้ายเข้ามาอยู่ในแอพนี้แล้ว
 */
export type TrainingCourse = NetworkSite & {
  /** สีประจำคอร์ส (hex) ใช้กับขอบ/ไอคอน/ปุ่มบนการ์ด */
  accent: string;
  /** กลุ่มเป้าหมายสั้นๆ ไว้โชว์บนการ์ด */
  audience: string;
  /** จุดขายสั้นๆ 2-3 ข้อ */
  highlights: string[];
};

export const TRAINING_COURSES: TrainingCourse[] = [
  {
    href: "https://firstaid.morroo.com",
    label: "First Aid",
    tagline: "ปฐมพยาบาลเบื้องต้นที่ทุกคนควรรู้",
    emoji: "🩹",
    accent: "#16A34A",
    audience: "บุคคลทั่วไป",
    highlights: ["10 บทเรียน ~1 ชม.", "สถานการณ์จำลอง", "สอบ + ใบเซอร์ฟรี"],
  },
  {
    href: "https://cpr.morroo.com",
    label: "CPR & AED",
    tagline: "ช่วยฟื้นคืนชีพขั้นพื้นฐาน ครบใน 1 คอร์ส",
    emoji: "🫀",
    accent: "#DC2626",
    audience: "บุคคลทั่วไป",
    highlights: ["วิดีโอ 5 บทเรียน", "สอบออนไลน์", "ใบเซอร์ + ส่วนลดคอร์สปฏิบัติ"],
  },
  {
    href: "https://bls.morroo.com",
    label: "BLS Provider",
    tagline: "Basic Life Support สำหรับผู้ให้การช่วยเหลือ",
    emoji: "⛑️",
    accent: "#0284C7",
    audience: "บุคลากรสุขภาพ",
    highlights: ["แนวทางล่าสุด", "เกมจำลองสถานการณ์", "สอบ + ใบเซอร์"],
  },
  {
    href: "https://acls.morroo.com",
    label: "ACLS",
    tagline: "Advanced Cardiovascular Life Support",
    emoji: "💓",
    accent: "#1D4ED8",
    audience: "แพทย์ / พยาบาล",
    highlights: ["Code Blue Sim", "คลังความรู้ + ยา ACLS", "สอบ + ใบเซอร์"],
  },
];

/**
 * เว็บในเครือทั้งหมด — single source of truth
 * ใช้ทั้งใน InternalAdsBanner (โฆษณาหมุน) และ Footer (เว็บในเครือเรา)
 */
export const NETWORK_SITES: NetworkSite[] = [
  {
    href: "https://cpr.morroo.com",
    label: "MorRoo CPR",
    tagline: "เรียนรู้การช่วยฟื้นคืนชีพ (CPR)",
    emoji: "🫀",
  },
  {
    href: "https://bls.morroo.com",
    label: "MorRoo BLS",
    tagline: "หลักสูตร Basic Life Support",
    emoji: "⛑️",
  },
  {
    href: "https://acls.morroo.com",
    label: "MorRoo ACLS",
    tagline: "หลักสูตร ACLS สำหรับบุคลากรการแพทย์",
    emoji: "💓",
  },
  {
    href: "https://emr.morroo.com",
    label: "MorRoo EMR",
    tagline: "หลักสูตรผู้ปฏิบัติการฉุกเฉินการแพทย์",
    emoji: "🚨",
  },
  {
    href: "https://firstaid.morroo.com",
    label: "MorRoo First Aid",
    tagline: "ปฐมพยาบาลเบื้องต้นที่ทุกคนควรรู้",
    emoji: "🩹",
  },
  {
    href: "https://drug.morroo.com",
    label: "MorRoo Drug",
    tagline: "ข้อมูลยาและการใช้ยา",
    emoji: "💊",
  },
  {
    href: "https://lab.morroo.com",
    label: "MorRoo Lab",
    tagline: "แปลผลตรวจทางห้องปฏิบัติการ",
    emoji: "🧪",
  },
  {
    href: "https://pharma.morroo.com",
    label: "MorRoo Pharma",
    tagline: "ความรู้เภสัชวิทยา",
    emoji: "⚗️",
  },
  {
    href: "https://icd10.morroo.com",
    label: "ICD-10",
    tagline: "ค้นหารหัสโรค ICD-10 ภาษาไทยแบบเร็ว",
    emoji: "🔎",
  },
  {
    href: "https://pocket.morroo.com",
    label: "Pocket MorRoo",
    tagline: "คู่มือพกพาสำหรับแพทย์",
    emoji: "📒",
  },
  {
    href: "https://advice.morroo.com",
    label: "MorRoo Advice",
    tagline: "ผู้ช่วย AI ให้คำแนะนำทางคลินิก",
    emoji: "💬",
  },
  {
    href: "https://jiacpr.com",
    label: "JiaCPR",
    tagline: "ศูนย์อบรมการช่วยฟื้นคืนชีพและสื่อการแพทย์",
    emoji: "✍️",
  },
  {
    href: "https://jiaaed.com",
    label: "JiaAED",
    tagline: "เครื่องกระตุกหัวใจไฟฟ้าอัตโนมัติ (AED)",
    emoji: "⚡",
  },
  {
    href: "https://jia1669.com",
    label: "Jia 1669",
    tagline: "เครื่องมือฉุกเฉินทางการแพทย์",
    emoji: "🚑",
  },
  {
    href: "https://roodee.me",
    label: "RooDee",
    tagline: "เครื่องมือช่วยอ่านหนังสือสอบ",
    emoji: "📚",
  },
  {
    href: "https://pharmru.com",
    label: "PharmRu",
    tagline: "คู่มือยาออนไลน์",
    emoji: "📖",
  },
];
