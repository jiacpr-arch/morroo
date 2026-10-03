/**
 * เตือนนับถอยหลังวันสอบ ศรว. ตามระดับของผู้ใช้ — pure helpers (cron อยู่ที่
 * app/api/cron/exam-countdown). ส่งเฉพาะรอบที่ ศรว. ประกาศวันแล้ว (confirmed)
 * เพื่อไม่เตือนวันที่เป็นแค่การคาดการณ์
 */

import { NL_EXAM_ROUNDS, formatThaiExamDate, type ExamRound } from "@/lib/exam-dates";

export const COUNTDOWN_MILESTONES = [30, 7, 1] as const;

export interface DueReminder {
  round: ExamRound;
  daysBefore: number;
  /** คีย์กันส่งซ้ำ: "<วันสอบ>:<step>" */
  roundKey: string;
}

/** วันที่ปฏิทินไทย (YYYY-MM-DD) ของ instant */
export function bangkokDateString(now: Date): string {
  return new Date(now.getTime() + 7 * 3600_000).toISOString().slice(0, 10);
}

/** จำนวนวันเต็มจากวันนี้ (ICT) ถึงวันสอบ */
export function daysUntilExam(isoDate: string, now: Date): number {
  const today = Date.parse(`${bangkokDateString(now)}T00:00:00Z`);
  const exam = Date.parse(`${isoDate}T00:00:00Z`);
  return Math.round((exam - today) / 86400_000);
}

export function roundKeyFor(round: Pick<ExamRound, "date" | "step">): string {
  return `${round.date}:${round.step}`;
}

/** รอบสอบที่ confirmed และห่างจากวันนี้ 30/7/1 วันพอดี */
export function dueReminders(
  now: Date,
  rounds: readonly ExamRound[] = NL_EXAM_ROUNDS
): DueReminder[] {
  const out: DueReminder[] = [];
  for (const round of rounds) {
    if (!round.confirmed) continue;
    const days = daysUntilExam(round.date, now);
    if ((COUNTDOWN_MILESTONES as readonly number[]).includes(days)) {
      out.push({ round, daysBefore: days, roundKey: roundKeyFor(round) });
    }
  }
  return out;
}

export function countdownTitle(round: ExamRound, daysBefore: number): string {
  return daysBefore === 1
    ? `⏰ พรุ่งนี้สอบแล้ว! ${round.label}`
    : `📅 อีก ${daysBefore} วัน ${round.label}`;
}

export function countdownBody(round: ExamRound, daysBefore: number): string {
  const date = formatThaiExamDate(round.date);
  if (daysBefore === 1) return `${date} — ทบทวนเบาๆ นอนให้เต็มอิ่ม แล้วลุยเลย 💪`;
  if (daysBefore <= 7) return `${date} — ช่วงทบทวนสุดท้าย ทำข้อสอบทุกวันกันนะ`;
  return `${date} — วางแผนอ่านให้ทัน ทำข้อสอบวันละนิดเพื่อไม่ให้หลุดฟอร์ม`;
}
