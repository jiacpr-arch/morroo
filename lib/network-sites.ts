export type NetworkSite = {
  href: string;
  label: string;
  tagline: string;
  emoji: string;
};

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
