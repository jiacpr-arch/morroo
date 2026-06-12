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
export interface ExamRound {
  /** ขั้นตอนการสอบ: 1 = วิทยาศาสตร์การแพทย์พื้นฐาน, 2 = คลินิก, 3 = ทักษะทางคลินิก (OSCE) */
  step: 1 | 2 | 3;
  /** ชื่อรอบที่แสดงบน banner เช่น "NL ขั้นตอนที่ 1 รอบ 2/2569" */
  label: string;
  /** ISO date ของวันสอบ เช่น "2026-10-10" */
  date: string;
  /** true = วันจากประกาศทางการของ ศรว. แล้ว, false = คาดการณ์ */
  confirmed: boolean;
}

// กำหนดการสอบปี 2569 ตามประกาศ ศรว. (ณ 12 มิ.ย. 2569)
// ยังไม่ประกาศ: Step 1 รอบ 2 + Step 2 รอบ 4 (คาดราว ต.ค. ตาม pattern ปีก่อน)
export const NL_EXAM_ROUNDS: ExamRound[] = [
  // ขั้นตอนที่ 1 — Basic Medical Sciences
  { step: 1, label: "NL ขั้นตอนที่ 1 รอบ 1/2569", date: "2026-01-24", confirmed: true },
  { step: 1, label: "NL ขั้นตอนที่ 1 รอบ 2/2569", date: "2026-10-10", confirmed: false },
  // ขั้นตอนที่ 2 — Clinical Sciences
  { step: 2, label: "NL ขั้นตอนที่ 2 รอบ 1/2569", date: "2026-01-25", confirmed: true },
  { step: 2, label: "NL ขั้นตอนที่ 2 รอบ 2/2569", date: "2026-04-19", confirmed: true },
  { step: 2, label: "NL ขั้นตอนที่ 2 รอบ 3/2569", date: "2026-07-19", confirmed: true },
  { step: 2, label: "NL ขั้นตอนที่ 2 รอบ 4/2569", date: "2026-10-11", confirmed: false },
  // ขั้นตอนที่ 3 — ทักษะทางคลินิก (OSCE)
  { step: 3, label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 1/2569", date: "2026-01-11", confirmed: true },
  { step: 3, label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 2/2569", date: "2026-02-08", confirmed: true },
  { step: 3, label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 3/2569", date: "2026-03-08", confirmed: true },
  { step: 3, label: "NL ขั้นตอนที่ 3 (OSCE) รอบ 4/2569", date: "2026-03-29", confirmed: true },
  { step: 3, label: "NL ขั้นตอนที่ 3 (OSCE) รอบพิเศษ/2569", date: "2026-06-07", confirmed: true },
];

export function examDateTime(round: Pick<ExamRound, "date">): number {
  return new Date(`${round.date}T00:00:00+07:00`).getTime();
}

/**
 * รอบสอบถัดไปที่ยังมาไม่ถึง (หรือ null ถ้าไม่มีข้อมูล)
 * default เฉพาะ Step 1-2 (MCQ) เพราะ banner ชี้ไปคลังข้อสอบ MCQ —
 * OSCE มีไว้สำหรับหน้าปฏิทิน
 */
export function getNextExamRound(
  now: Date = new Date(),
  steps: ReadonlyArray<ExamRound["step"]> = [1, 2]
): ExamRound | null {
  const upcoming = NL_EXAM_ROUNDS.filter(
    (r) => steps.includes(r.step) && examDateTime(r) > now.getTime()
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
