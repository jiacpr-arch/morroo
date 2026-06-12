// กำหนดการสอบของ ศรว. (CMA) — ใช้ขับ countdown banner หน้า pricing + หน้าแรก
//
// confirmed: true = วันจากประกาศทางการ ศรว. (https://cmathai.org/news)
// confirmed: false = คาดการณ์จาก pattern ปีก่อน — UI จะติดป้าย "รอประกาศ ศรว." ให้เอง
// รอบที่ผ่านไปแล้วจะถูกข้ามให้อัตโนมัติ จึงเก็บเฉพาะรอบที่ยังมาไม่ถึง
// TODO(owner): เมื่อ ศรว. ประกาศ Step 1 รอบ 2 / Step 2 รอบ 4 ปี 2569 (คาดราว ต.ค.)
// แก้ date เป็นวันจริงแล้วเปลี่ยน confirmed เป็น true
// date เป็นเวลาไทย (ICT) เที่ยงคืนของวันสอบ
export interface ExamRound {
  /** ชื่อรอบที่แสดงบน banner เช่น "NL ขั้นตอนที่ 1 รอบ 2/2569" */
  label: string;
  /** ISO date ของวันสอบ เช่น "2026-10-10" */
  date: string;
  /** true = วันจากประกาศทางการของ ศรว. แล้ว, false = คาดการณ์ */
  confirmed: boolean;
}

export const NL_EXAM_ROUNDS: ExamRound[] = [
  { label: "NL ขั้นตอนที่ 2 รอบ 3/2569", date: "2026-07-19", confirmed: true },
  { label: "NL ขั้นตอนที่ 1 รอบ 2/2569", date: "2026-10-10", confirmed: false },
  { label: "NL ขั้นตอนที่ 2 รอบ 4/2569", date: "2026-10-11", confirmed: false },
];

/** รอบสอบถัดไปที่ยังมาไม่ถึง (หรือ null ถ้าไม่มีข้อมูล) */
export function getNextExamRound(now: Date = new Date()): ExamRound | null {
  const upcoming = NL_EXAM_ROUNDS.filter(
    (r) => new Date(`${r.date}T00:00:00+07:00`).getTime() > now.getTime()
  ).sort((a, b) => a.date.localeCompare(b.date));
  return upcoming[0] ?? null;
}
