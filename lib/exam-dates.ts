// กำหนดการสอบของ ศรว. (CMA) — ใช้ขับ countdown banner หน้า pricing
//
// TODO(owner): เติมวันสอบจริงจากประกาศ ศรว. (https://cmathai.org/news)
// แล้ว banner จะแสดงเองอัตโนมัติ — รอบที่ผ่านไปแล้วจะถูกข้ามให้
// date เป็นเวลาไทย (ICT) เที่ยงคืนของวันสอบ
export interface ExamRound {
  /** ชื่อรอบที่แสดงบน banner เช่น "NL Step 2 (MCQ) รอบ 1/2569" */
  label: string;
  /** ISO date ของวันสอบ เช่น "2026-08-15" */
  date: string;
}

export const NL_EXAM_ROUNDS: ExamRound[] = [
  // ตัวอย่าง — ลบ comment แล้วแก้เป็นวันจริง:
  // { label: "NL Step 2 (MCQ) รอบ 1/2569", date: "2026-08-15" },
  // { label: "MEQ รอบ 2/2569", date: "2026-10-03" },
];

/** รอบสอบถัดไปที่ยังมาไม่ถึง (หรือ null ถ้าไม่มีข้อมูล) */
export function getNextExamRound(now: Date = new Date()): ExamRound | null {
  const upcoming = NL_EXAM_ROUNDS.filter(
    (r) => new Date(`${r.date}T00:00:00+07:00`).getTime() > now.getTime()
  ).sort((a, b) => a.date.localeCompare(b.date));
  return upcoming[0] ?? null;
}
