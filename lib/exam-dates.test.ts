import { describe, it, expect } from "vitest";
import {
  NL_EXAM_ROUNDS,
  getNextExamRound,
  formatThaiExamDate,
} from "./exam-dates";

describe("getNextExamRound", () => {
  it("ข้ามรอบที่ผ่านไปแล้ว และคืนรอบที่ใกล้สุด", () => {
    // 12 มิ.ย. 2569 — รอบถัดไปของ Step 1-2 คือ Step 2 รอบ 3 (19 ก.ค.)
    const next = getNextExamRound(new Date("2026-06-12T00:00:00+07:00"));
    expect(next?.date).toBe("2026-07-19");
    expect(next?.confirmed).toBe(true);
  });

  it("default ไม่นับรอบ OSCE (step 3)", () => {
    // 1 มิ.ย. 2569 — OSCE รอบพิเศษ 7 มิ.ย. ใกล้กว่า แต่ banner ขาย MCQ
    const next = getNextExamRound(new Date("2026-06-01T00:00:00+07:00"));
    expect(next?.date).toBe("2026-07-19");
    expect(next?.step).toBe(2);
  });

  it("ระบุ steps เองได้", () => {
    const next = getNextExamRound(new Date("2026-06-01T00:00:00+07:00"), [3]);
    expect(next?.date).toBe("2026-06-07");
  });

  it("วันสอบพอดีเที่ยงคืน ICT ถือว่าเริ่มแล้ว — เลื่อนไปรอบถัดไป", () => {
    const next = getNextExamRound(new Date("2026-07-19T00:00:00+07:00"));
    expect(next?.date).toBe("2026-10-10");
  });

  it("ไม่มีรอบเหลือ → null", () => {
    expect(getNextExamRound(new Date("2027-01-01T00:00:00+07:00"))).toBeNull();
  });
});

describe("NL_EXAM_ROUNDS data", () => {
  it("วันที่เป็น ISO ทั้งหมดและ label ไม่ซ้ำ", () => {
    const labels = new Set<string>();
    for (const r of NL_EXAM_ROUNDS) {
      expect(r.date).toMatch(/^\d{4}-\d{2}-\d{2}$/);
      expect(labels.has(r.label)).toBe(false);
      labels.add(r.label);
    }
  });
});

describe("formatThaiExamDate", () => {
  it("แปลงเป็นวัน+เดือนไทย+ปี พ.ศ.", () => {
    expect(formatThaiExamDate("2026-07-19")).toBe("อาทิตย์ 19 กรกฎาคม 2569");
    expect(formatThaiExamDate("2026-01-24")).toBe("เสาร์ 24 มกราคม 2569");
    expect(formatThaiExamDate("2026-10-10")).toBe("เสาร์ 10 ตุลาคม 2569");
  });
});
