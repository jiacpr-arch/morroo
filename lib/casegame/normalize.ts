// Normalize สำหรับหน้ารวมเกมเคส /casegame
//
// ข้อมูลต้นทางไม่สม่ำเสมอ:
//  - long_cases.specialty ปนไทย/อังกฤษ + ซ้ำ (Surgery/ศัลยศาสตร์, Medicine/
//    Internal medicine/Cardiology = อายุรศาสตร์ ฯลฯ)
//  - ความยากคนละ scale: exams/long_cases ใช้ easy|medium|hard,
//    SimScenario.difficultyTag ใช้ basic|megacode
// → รวมเป็นชุดสาขาไทยมาตรฐาน + ระดับความยาก 3 ระดับ ตอนแสดงผล (ไม่แตะ DB)

export type Difficulty = "ง่าย" | "ปานกลาง" | "ยาก";

export const DIFFICULTY_ORDER: Difficulty[] = ["ง่าย", "ปานกลาง", "ยาก"];

export const DIFFICULTY_STYLE: Record<Difficulty, string> = {
  ง่าย: "bg-emerald-100 text-emerald-700",
  ปานกลาง: "bg-amber-100 text-amber-700",
  ยาก: "bg-rose-100 text-rose-700",
};

export function normalizeDifficulty(raw?: string | null): Difficulty {
  const s = (raw ?? "").trim().toLowerCase();
  if (s === "easy" || s === "basic" || s === "ง่าย") return "ง่าย";
  if (s === "hard" || s === "megacode" || s === "ยาก") return "ยาก";
  return "ปานกลาง";
}

// ป้ายอังกฤษ (และ subspecialty) → สาขาไทยมาตรฐาน; สาขาไทยที่ canonical อยู่แล้ว
// ปล่อยผ่านไม่ต้อง map
const SPECIALTY_CANON: Record<string, string> = {
  medicine: "อายุรศาสตร์",
  "internal medicine": "อายุรศาสตร์",
  cardiology: "อายุรศาสตร์",
  neurology: "อายุรศาสตร์",
  pulmonology: "อายุรศาสตร์",
  gastroenterology: "อายุรศาสตร์",
  endocrinology: "อายุรศาสตร์",
  rheumatology: "อายุรศาสตร์",
  "infectious disease": "อายุรศาสตร์",
  surgery: "ศัลยศาสตร์",
  pediatrics: "กุมารเวชศาสตร์",
  obstetrics: "สูติศาสตร์-นรีเวชวิทยา",
  gynecology: "สูติศาสตร์-นรีเวชวิทยา",
  "ob-gyn": "สูติศาสตร์-นรีเวชวิทยา",
  orthopedics: "ออร์โธปิดิกส์",
  emergency: "เวชศาสตร์ฉุกเฉิน",
  psychiatry: "จิตเวชศาสตร์",
  radiology: "รังสีวิทยา",
  anesthesiology: "วิสัญญีวิทยา",
  pathology: "พยาธิวิทยา",
  "rehabilitation medicine": "เวชศาสตร์ฟื้นฟู",
  "family medicine": "เวชศาสตร์ครอบครัว",
};

export const OTHER_SPECIALTY = "อื่น ๆ";

export function normalizeSpecialty(raw?: string | null): string {
  const s = (raw ?? "").trim();
  if (!s) return OTHER_SPECIALTY;
  return SPECIALTY_CANON[s.toLowerCase()] ?? s;
}

const SPECIALTY_COLOR: Record<string, string> = {
  อายุรศาสตร์: "bg-blue-100 text-blue-700",
  ศัลยศาสตร์: "bg-red-100 text-red-700",
  "สูติศาสตร์-นรีเวชวิทยา": "bg-pink-100 text-pink-700",
  กุมารเวชศาสตร์: "bg-green-100 text-green-700",
  ออร์โธปิดิกส์: "bg-amber-100 text-amber-700",
  เวชศาสตร์ฉุกเฉิน: "bg-orange-100 text-orange-700",
  จิตเวชศาสตร์: "bg-violet-100 text-violet-700",
  รังสีวิทยา: "bg-slate-100 text-slate-700",
  วิสัญญีวิทยา: "bg-cyan-100 text-cyan-700",
  พยาธิวิทยา: "bg-lime-100 text-lime-700",
  เวชศาสตร์ฟื้นฟู: "bg-teal-100 text-teal-700",
  เวชศาสตร์ครอบครัว: "bg-emerald-100 text-emerald-700",
  จักษุวิทยา: "bg-indigo-100 text-indigo-700",
};

export function specialtyColor(specialty: string): string {
  return SPECIALTY_COLOR[specialty] ?? "bg-gray-100 text-gray-700";
}

/** ลำดับสาขาที่อยากให้ chip เรียง (ที่เหลือต่อท้ายตามจำนวน) */
export const SPECIALTY_SORT_HINT: string[] = [
  "อายุรศาสตร์",
  "ศัลยศาสตร์",
  "กุมารเวชศาสตร์",
  "สูติศาสตร์-นรีเวชวิทยา",
  "ออร์โธปิดิกส์",
  "เวชศาสตร์ฉุกเฉิน",
  "จิตเวชศาสตร์",
];

export type CaseCardType = "featured" | "longcase" | "meq";

export interface CaseCard {
  slug: string;
  title: string;
  subtitle?: string;
  specialty: string; // canonical ไทย หรือ "อื่น ๆ"
  difficulty: Difficulty;
  type: CaseCardType;
  audience?: string;
}

/** ตัด prefix "LONG CASE:" / "MEQ:" ออกจากชื่อเพื่อแสดงผล */
export function cleanTitle(title: string): string {
  return title.replace(/^(LONG CASE|MEQ):\s*/i, "");
}
