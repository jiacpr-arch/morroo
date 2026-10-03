/**
 * ระดับการสอบของนักศึกษาแพทย์ — ใช้ตามนักเรียนให้ตรงระดับ (ข้อสอบรายวัน LINE,
 * เตือนนับถอยหลัง, หน้าฝึก). เก็บที่ profiles.target_exam (+ current_year).
 *
 * ระบบ ศรว. ใหม่ (ข้อบังคับแพทยสภา พ.ศ. 2568, เริ่ม 2570):
 *   ส่วนที่ 1 = วิทยาศาสตร์การแพทย์ + การประกอบวิชาชีพเวชกรรม (รวม NL1+NL2 เดิม, MCQ)
 *   ส่วนที่ 2 = ทักษะตรวจร่างกาย + หัตถการทางคลินิก (OSCE)
 * ช่วงเปลี่ยนผ่าน: คนที่ผ่าน NL1 เดิมแล้วสอบ NL2 เดิมต่อได้ถึง ต.ค. 2570
 * MEQ + Long case: การสอบทักษะทางคลินิกของผู้จบจากต่างประเทศ (และรูปแบบที่ใช้ใน Board หลายสาขา)
 * (NL1 เดิมสอบครั้งสุดท้าย 24 ม.ค. 2569 — จึงไม่มีให้เลือกแล้ว)
 *
 * Pure module (ไม่ import server code) เพื่อให้ client component ใช้ได้
 */

export type ExamTarget = "part1" | "NL2" | "part2" | "meq" | "board";
/** กลุ่มข้อสอบที่ get_daily_mcq(p_pool) รับ */
export type McqPool = "NL1" | "NL2" | "board";
/** ชนิดรอบสอบใน lib/exam-dates.ts */
export type ExamKind = "nl1" | "nl2" | "part1" | "osce" | "meq";
/** exam_type ของหน้า /nl/practice — "all" = ผสม NL1+NL2 (ส่วนที่ 1) */
export type PracticeExam = "all" | "NL1" | "NL2";

export interface ExamTargetOption {
  id: ExamTarget;
  label: string;
  /** สั้นสำหรับปุ่ม quick reply ของ LINE (≤ 20 ตัวอักษร) */
  shortLabel: string;
  desc: string;
  icon: string;
}

export const EXAM_TARGETS: readonly ExamTargetOption[] = [
  {
    id: "part1",
    label: "ส่วนที่ 1 (ข้อสอบรวม)",
    shortLabel: "ส่วนที่ 1",
    desc: "วิทยาศาสตร์พื้นฐาน + คลินิก ในข้อสอบเดียว (แทน NL1+NL2 ตั้งแต่ปี 2570)",
    icon: "📝",
  },
  {
    id: "part2",
    label: "ส่วนที่ 2 (ทักษะคลินิก)",
    shortLabel: "ส่วนที่ 2 (OSCE)",
    desc: "ตรวจร่างกาย + หัตถการทางคลินิก (OSCE)",
    icon: "🩺",
  },
  {
    id: "NL2",
    label: "NL2 เดิม",
    shortLabel: "NL2 เดิม",
    desc: "สำหรับคนที่ผ่าน NL1 เดิมแล้ว — สอบได้ถึงรอบ ต.ค. 2570",
    icon: "📘",
  },
  {
    id: "meq",
    label: "MEQ + Long case",
    shortLabel: "MEQ + Long case",
    desc: "สอบอัตนัยประยุกต์ + Long case (ผู้จบจากต่างประเทศ / เตรียม Board)",
    icon: "✍️",
  },
  {
    id: "board",
    label: "Board เฉพาะทาง",
    shortLabel: "Board",
    desc: "สอบวุฒิบัตร / หนังสืออนุมัติ ราชวิทยาลัยฯ",
    icon: "🎓",
  },
];

export const CURRENT_YEARS = [1, 2, 3, 4, 5, 6] as const;

const TARGET_IDS = new Set<string>(EXAM_TARGETS.map((t) => t.id));
const POOLS = new Set<string>(["NL1", "NL2", "board"]);

/** ค่าเก่าใน profiles.target_exam ก่อนระบบใหม่ → ระดับปัจจุบัน */
const LEGACY_TARGETS: Record<string, ExamTarget> = {
  NL1: "part1",
  both: "part1",
  NL3: "part2",
};

export function isExamTarget(v: unknown): v is ExamTarget {
  return typeof v === "string" && TARGET_IDS.has(v);
}

/** อ่านค่า target_exam (รวมค่าเก่า) เป็นระดับปัจจุบัน หรือ null */
export function normalizeTarget(v: unknown): ExamTarget | null {
  if (isExamTarget(v)) return v;
  return typeof v === "string" ? (LEGACY_TARGETS[v] ?? null) : null;
}

export function isMcqPool(v: unknown): v is McqPool {
  return typeof v === "string" && POOLS.has(v);
}

/** slug ของ board_specialties (เช่น internal_medicine) — เช็กรูปแบบเท่านั้น; ตัวตนจริงเช็กกับ DB/FK */
export function isBoardSpecialtySlug(v: unknown): v is string {
  return typeof v === "string" && /^[a-z0-9][a-z0-9_-]{0,48}$/.test(v);
}

export function isCurrentYear(v: unknown): v is number {
  return typeof v === "number" && Number.isInteger(v) && v >= 1 && v <= 6;
}

export function examTargetLabel(t: string | null | undefined): string | null {
  const id = normalizeTarget(t);
  return EXAM_TARGETS.find((o) => o.id === id)?.label ?? null;
}

/** ค่าแนะนำจากชั้นปี: ปี 1-5 → ส่วนที่ 1, ปี 6 → ส่วนที่ 2 (ผู้ใช้แก้ได้) */
export function suggestTargetFromYear(year: number): ExamTarget | null {
  if (!isCurrentYear(year)) return null;
  return year <= 5 ? "part1" : "part2";
}

/**
 * คลังข้อสอบรายวันของระดับนี้. null = ผสม NL1+NL2 (ตรงกับส่วนที่ 1 พอดี).
 * ส่วนที่ 2 (OSCE) ไม่มีคลัง MCQ จึงใช้ข้อคลินิก NL2.
 * board ใช้คลัง "board" เฉพาะเมื่อเลือกสาขาแล้ว (ลิงก์ทำในเว็บไป /board/<สาขา>/practice);
 * ยังไม่เลือกสาขา = null (ผสม NL) เพราะ board คลังรวมทุกสาขาไม่ตรงกับสาขาของผู้ใช้
 */
export function mcqPoolForTarget(
  t: string | null | undefined,
  boardSpecialty?: string | null
): McqPool | null {
  switch (normalizeTarget(t)) {
    case "board":
      return isBoardSpecialtySlug(boardSpecialty) ? "board" : null;
    case "NL2":
    case "part2":
    case "meq":
      return "NL2";
    default:
      return null;
  }
}

/** ชนิดรอบสอบที่เกี่ยวกับระดับนี้ — ใช้กรอง countdown/เตือน */
export function examKindsForTarget(t: string | null | undefined): ExamKind[] {
  switch (normalizeTarget(t)) {
    case "part1":
      return ["part1"];
    case "NL2":
      return ["nl2"];
    case "part2":
      return ["osce"];
    case "meq":
      return ["meq"];
    default:
      return [];
  }
}

/** หน้าฝึกหลักของระดับนี้ — MEQ → /exams, Board → สาขาที่เลือก (หรือ /board), อื่นๆ → คลัง MCQ */
export function practicePathForTarget(
  t: string | null | undefined,
  boardSpecialty?: string | null
): string {
  switch (normalizeTarget(t)) {
    case "meq":
      return "/exams";
    case "board":
      return isBoardSpecialtySlug(boardSpecialty) ? `/board/${boardSpecialty}/practice` : "/board";
    default:
      return "/nl/practice";
  }
}

/** exam ของหน้า /nl/practice (ไม่ได้ตั้งระดับ = NL2 เหมือนเดิม) */
export function practiceExamForTarget(t: string | null | undefined): PracticeExam {
  return normalizeTarget(t) === "part1" ? "all" : "NL2";
}
