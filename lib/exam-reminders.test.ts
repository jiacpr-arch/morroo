import { describe, expect, it } from "vitest";
import type { ExamRound } from "./exam-dates";
import {
  bangkokDateString,
  countdownBody,
  countdownTitle,
  daysUntilExam,
  dueReminders,
  roundKeyFor,
} from "./exam-reminders";

const rounds: ExamRound[] = [
  { step: 1, label: "NL ขั้นตอนที่ 1 รอบ A", date: "2026-10-10", confirmed: true },
  { step: 2, label: "NL ขั้นตอนที่ 2 รอบ B", date: "2026-10-10", confirmed: false },
  { step: 3, label: "NL ขั้นตอนที่ 3 รอบ C", date: "2026-11-09", confirmed: true },
];

describe("exam-reminders", () => {
  it("uses the Bangkok calendar day", () => {
    // 2026-10-02T18:00Z is already 2026-10-03 in ICT
    expect(bangkokDateString(new Date("2026-10-02T18:00:00Z"))).toBe("2026-10-03");
    expect(bangkokDateString(new Date("2026-10-02T16:59:00Z"))).toBe("2026-10-02");
  });

  it("counts whole days to the exam in ICT", () => {
    expect(daysUntilExam("2026-10-10", new Date("2026-10-02T18:00:00Z"))).toBe(7);
    expect(daysUntilExam("2026-10-10", new Date("2026-10-10T01:00:00Z"))).toBe(0);
    expect(daysUntilExam("2026-10-10", new Date("2026-10-12T01:00:00Z"))).toBe(-2);
  });

  it("returns confirmed rounds at 30 / 7 / 1 days only", () => {
    const d7 = dueReminders(new Date("2026-10-03T02:00:00Z"), rounds);
    expect(d7).toHaveLength(1);
    expect(d7[0]).toMatchObject({ daysBefore: 7, roundKey: "2026-10-10:1" });

    const d30 = dueReminders(new Date("2026-10-10T02:00:00Z"), rounds);
    expect(d30.map((r) => r.round.step)).toEqual([3]);
    expect(d30[0].daysBefore).toBe(30);

    expect(dueReminders(new Date("2026-10-05T02:00:00Z"), rounds)).toEqual([]);
  });

  it("skips unconfirmed rounds", () => {
    const due = dueReminders(new Date("2026-10-09T02:00:00Z"), rounds);
    expect(due.map((r) => r.round.step)).toEqual([1]); // step 2 is unconfirmed
    expect(due[0].daysBefore).toBe(1);
  });

  it("builds keys and copy", () => {
    expect(roundKeyFor(rounds[2])).toBe("2026-11-09:3");
    expect(countdownTitle(rounds[0], 1)).toContain("พรุ่งนี้");
    expect(countdownTitle(rounds[0], 7)).toContain("อีก 7 วัน");
    expect(countdownBody(rounds[0], 30)).toContain("2569");
  });
});
