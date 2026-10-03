// กำหนดการสอบของ ศรว. (CMA) — ใช้ขับ countdown banner (หน้าแรก + pricing)
// และหน้าปฏิทินสอบ /nl/calendar
//
// confirmed: true = วันจากประกาศทางการ ศรว. (https://cmathai.org/news)
// confirmed: false = คาดการณ์จาก pattern ปีก่อน — UI จะติดป้าย "รอประกาศ ศรว." ให้เอง
// รอบที่ผ่านไปแล้วยังเก็บไว้เพื่อแสดงบนหน้าปฏิทิน (banner ข้ามให้อัตโนมัติ)
//
// แหล่งอัพเดท: cron /api/cron/exam-watch เฝ้าเว็บ ศรว. ทุกวัน เจอประกาศใหม่
// จะแจ้ง LINE admin → มาแก้วันที่ + confirmed ที่ไฟล์นี้ไฟล์เดียว
// date เป็นเวลาไทย (ICT) เที่ยงคืนของวันสอบ
export type { ExamKind } from "@/lib/exam-level";
import type { ExamKind } from "@/lib/exam-level";

export interface ExamRound {
  /**
   * ชนิดรอบสอบ:
   *   nl1   = NL ขั้นตอนที่ 1 เดิม (วิทยาศาสตร์การแพทย์พื้นฐาน) — ครั้งสุดท้าย ม.ค. 2569
   *   nl2   = NL ขั้นตอนที่ 2 เดิม (คลินิก) — เปิดให้คนที่ผ่าน NL1 เดิมถึง ต.ค. 2570
   *   part1 = ส่วนที่ 1 ระบบใหม่ (พื้นฐาน + คลินิก รวมข้อสอบเดียว) — เริ่ม 2570
   *   osce  = ทักษะทางคลินิก (OSCE) — ขั้นตอนที่ 3 เดิม / ส่วนที่ 2 ระบบใหม่
   */
  kind: ExamKind;
  /** ชื่อรอบที่แสดงบน banner เช่น "NL ขั้นตอนที่ 2 รอบ 4/2569" */
  label: string;
  /** ISO date ของวันสอบ เช่น "2026-10-10" */
  date: string;
  /** true = วันจากประกาศทางการของ ศรว. แล้ว, false = คาดการณ์ */
  confirmed: boolean;
}

// ระบบใหม่ตามข้อบังคับแพทยสภาว่าด้วยหลักเกณฑ์การประเมินฯ พ.ศ. 2568 (ราชกิจจาฯ 12 พ.ย. 2568):
// 2569 เป็นปีสุดท้ายที่สอบแยก NL1/NL2 — ตั้งแต่ 2570 เป็น ส่วนที่ 1 (MCQ รวม) + ส่วนที่ 2 (OSCE)
// รอบ 2570 ยัง confirmed: false จนกว่าจะเห็นประกาศ ศรว. ตัวจริง (cron exam-watch เฝ้าอยู่)
export const NL_EXAM_ROUNDS: ExamRound[] = [
  // NL ขั้นตอนที่ 1 เดิม — รอบนี้เป็นครั้งสุดท้าย
  { kind: "nl1", label: "NL ขั้นตอนที่ 1 รอบ 1/2569", date: "2026-01-24", confirmed: true },
  // NL ขั้นตอนที่ 2 เดิม
  { kind: "nl2", label: "NL ขั้นตอนที่ 2 รอบ 1/2569", date: "2026-01-25", confirmed: true },
  { kind: "nl2", label: "NL ขั้นตอนที่ 2 รอบ 2/2569", date: "2026-04-19", confirmed: true },
  { kind: "nl2", label: "NL ขั้นตอนที่ 2 รอบ 3/2569", date: "2026-07-19", confirmed: true },
  { kind: "nl2", label: "NL ขั้นตอนที่ 2 รอบ 4/2569", date: "2026-10-11", confirmed: false },
  // ส่วนที่ 1 ระบบใหม่ — วันจากตารางติวเตอร์ (บางแหล่งเขียน "เมษายน 2570") รอยืนยันกับ ศรว.
  { kind: "part1", label: "ส่วนที่ 1 รอบ 1/2570", date: "2027-05-01", confirmed: false },
  { kind: "part1", label: "ส่วนที่ 1 รอบ 2/2570", date: "2027-10-09", confirmed: false },
  // ทักษะทางคลินิก (OSCE)
  { kind: "osce", label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 1/2569", date: "2026-01-11", confirmed: true },
  { kind: "osce", label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 2/2569", date: "2026-02-08", confirmed: true },
  { kind: "osce", label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 3/2569", date: "2026-03-08", confirmed: true },
  { kind: "osce", label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 4/2569", date: "2026-03-29", confirmed: true },
  { kind: "osce", label: "NL ขั้นตอนที่ 3 (OSCE) รอบพิเศษ/2569", date: "2026-06-07", confirmed: true },
  // ประกาศ ศรว. ที่ 17/2569 (รับสมัครสอบทักษะทางคลินิก ปี 2570) — ยืนยันวันกับเอกสารจริงก่อนตั้ง confirmed
  { kind: "osce", label: "OSCE รอบ 1/2570", date: "2027-01-10", confirmed: false },
];

/** รอบที่ใช้ข้อสอบ MCQ — default ของ banner ที่ชี้ไปคลังข้อสอบ */
export const MCQ_EXAM_KINDS: readonly ExamKind[] = ["nl1", "nl2", "part1"];

export function examDateTime(round: Pick<ExamRound, "date">): number {
  return new Date(`${round.date}T00:00:00+07:00`).getTime();
}

/**
 * รอบสอบถัดไปที่ยังมาไม่ถึง (หรือ null ถ้าไม่มีข้อมูล)
 * default เฉพาะรอบ MCQ เพราะ banner ชี้ไปคลังข้อสอบ MCQ —
 * OSCE มีไว้สำหรับหน้าปฏิทิน
 */
export function getNextExamRound(
  now: Date = new Date(),
  kinds: ReadonlyArray<ExamKind> = MCQ_EXAM_KINDS
): ExamRound | null {
  const upcoming = NL_EXAM_ROUNDS.filter(
    (r) => kinds.includes(r.kind) && examDateTime(r) > now.getTime()
  ).sort((a, b) => a.date.localeCompare(b.date));
  return upcoming[0] ?? null;
}

const THAI_DAYS = ["อาทิตย์", "จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์"];
const THAI_MONTHS = [
  "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน",
  "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม",
];

/** "2026-07-19" → "อาทิตย์ 19 กรกฎาคม 2569" (วันสอบเป็นเวลาไทยเสมอ) */
export function formatThaiExamDate(isoDate: string): string {
  const [y, m, d] = isoDate.split("-").map(Number);
  // ใช้ UTC constructor กับ component ตรงๆ — วันในสัปดาห์ของ date ล้วนไม่ขึ้นกับ timezone
  const day = new Date(Date.UTC(y, m - 1, d)).getUTCDay();
  return `${THAI_DAYS[day]} ${d} ${THAI_MONTHS[m - 1]} ${y + 543}`;
}
