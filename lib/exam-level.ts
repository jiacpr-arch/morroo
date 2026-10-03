/**
 * ระดับการสอบของนักศึกษาแพทย์ — ใช้ตามนักเรียนให้ตรงระดับ (ข้อสอบรายวัน LINE,
 * เตือนนับถอยหลัง, หน้าฝึก). เก็บที่ profiles.target_exam (+ current_year).
 *
 * Pure module (ไม่ import server code) เพื่อให้ client component ใช้ได้
 */

export type ExamTarget = "NL1" | "NL2" | "NL3" | "both" | "board";
/** กลุ่มข้อสอบที่ get_daily_mcq(p_pool) รับ */
export type McqPool = "NL1" | "NL2" | "board";
export type ExamStep = 1 | 2 | 3;

export interface ExamTargetOption {
  id: ExamTarget;
  label: string;
  desc: string;
  icon: string;
}

export const EXAM_TARGETS: readonly ExamTargetOption[] = [
  { id: "NL1", label: "NL1", desc: "ขั้นตอนที่ 1 — วิทยาศาสตร์การแพทย์พื้นฐาน", icon: "📝" },
  { id: "NL2", label: "NL2", desc: "ขั้นตอนที่ 2 — วิทยาศาสตร์คลินิก", icon: "🩺" },
  { id: "NL3", label: "NL3", desc: "ขั้นตอนที่ 3 — ทักษะทางคลินิก (OSCE)", icon: "🧑‍⚕️" },
  { id: "both", label: "ทุกขั้นตอน", desc: "เตรียม NL1 + NL2 + NL3 พร้อมกัน", icon: "🎯" },
  { id: "board", label: "Board เฉพาะทาง", desc: "สอบวุฒิบัตรราชวิทยาลัยฯ", icon: "🎓" },
];

export const CURRENT_YEARS = [1, 2, 3, 4, 5, 6] as const;

const TARGET_IDS = new Set<string>(EXAM_TARGETS.map((t) => t.id));
const POOLS = new Set<string>(["NL1", "NL2", "board"]);

export function isExamTarget(v: unknown): v is ExamTarget {
  return typeof v === "string" && TARGET_IDS.has(v);
}

export function isMcqPool(v: unknown): v is McqPool {
  return typeof v === "string" && POOLS.has(v);
}

export function isCurrentYear(v: unknown): v is number {
  return typeof v === "number" && Number.isInteger(v) && v >= 1 && v <= 6;
}

export function examTargetLabel(t: string | null | undefined): string | null {
  return EXAM_TARGETS.find((o) => o.id === t)?.label ?? null;
}

/** ค่าแนะนำจากชั้นปี: ปี 1-3 → NL1, ปี 4-5 → NL2, ปี 6 → NL3 (ผู้ใช้แก้ได้) */
export function suggestTargetFromYear(year: number): ExamTarget | null {
  if (!isCurrentYear(year)) return null;
  if (year <= 3) return "NL1";
  if (year <= 5) return "NL2";
  return "NL3";
}

/**
 * คลังข้อสอบ MCQ ที่ใช้กับระดับนี้ — NL3 (OSCE) ไม่มีคลัง MCQ จึงใช้ข้อคลินิก NL2.
 * null = ไม่กรอง (ผสม NL1+NL2 เหมือนเดิม). board ยังเป็น null โดยตั้งใจ: ลิงก์
 * "ทำในเว็บ" ของการ์ดรายวัน (/nl/practice?q=) รองรับเฉพาะข้อ audience=student
 * ถ้าจะส่งข้อ board ใน LINE ต้องทำลิงก์ฝั่ง /board ก่อน (get_daily_mcq รองรับ 'board' แล้ว)
 */
export function mcqPoolForTarget(t: string | null | undefined): McqPool | null {
  switch (t) {
    case "NL1":
      return "NL1";
    case "NL2":
    case "NL3":
      return "NL2";
    default:
      return null;
  }
}

/** ขั้นสอบ (ExamRound.step) ที่เกี่ยวกับระดับนี้ — ใช้กรอง countdown/เตือน */
export function examStepsForTarget(t: string | null | undefined): ExamStep[] {
  switch (t) {
    case "NL1":
      return [1];
    case "NL2":
      return [2];
    case "NL3":
      return [3];
    case "both":
      return [1, 2, 3];
    default:
      return [];
  }
}

/** exam_type ของหน้า /nl/practice (default เดิมคือ NL2) */
export function practiceExamType(t: string | null | undefined): "NL1" | "NL2" {
  return t === "NL1" ? "NL1" : "NL2";
}
