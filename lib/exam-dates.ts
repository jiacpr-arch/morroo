// กำหนดการสอบของ ศรว. (CMA) — ใช้ขับ countdown banner หน้า pricing + หน้าแรก
//
// confirmed: false = วันคาดการณ์จาก pattern ปีก่อน (รอบ 2 สอบ เสาร์-อาทิตย์ ราวกลาง ต.ค.
// เช่น ปี 2566 สอบ 7-8 ต.ค.) — UI จะติดป้าย "รอประกาศ ศรว." ให้เอง
// TODO(owner): เมื่อ ศรว. ประกาศวันจริง (https://cmathai.org/news) แก้ date
// แล้วเปลี่ยน confirmed เป็น true — รอบที่ผ่านไปแล้วจะถูกข้ามให้อัตโนมัติ
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
  { label: "NL ขั้นตอนที่ 1 รอบ 2/2569", date: "2026-10-10", confirmed: false },
  { label: "NL ขั้นตอนที่ 2 รอบ 2/2569", date: "2026-10-11", confirmed: false },
];

/** รอบสอบถัดไปที่ยังมาไม่ถึง (หรือ null ถ้าไม่มีข้อมูล) */
export function getNextExamRound(now: Date = new Date()): ExamRound | null {
  const upcoming = NL_EXAM_ROUNDS.filter(
    (r) => new Date(`${r.date}T00:00:00+07:00`).getTime() > now.getTime()
  ).sort((a, b) => a.date.localeCompare(b.date));
  return upcoming[0] ?? null;
}
