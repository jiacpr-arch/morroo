import { describe, expect, it } from "vitest";
import {
  MEQ_CATEGORIES,
  MEQ_DIFFICULTIES,
  pickMeqSlot,
  isDuplicateMeqTitle,
  existingCasesPromptBlock,
} from "./meq-schedule.mjs";

describe("pickMeqSlot", () => {
  it("cycles every category through every difficulty over a year", () => {
    const seen = new Map<string, Set<string>>();
    // Mondays and Thursdays of 2026
    for (let d = new Date(Date.UTC(2026, 0, 1)); d.getUTCFullYear() === 2026; d.setUTCDate(d.getUTCDate() + 1)) {
      if (d.getUTCDay() !== 1 && d.getUTCDay() !== 4) continue;
      const { category, difficulty } = pickMeqSlot(new Date(d));
      if (!seen.has(category)) seen.set(category, new Set());
      seen.get(category)!.add(difficulty);
    }
    for (const c of MEQ_CATEGORIES) {
      expect([...(seen.get(c) ?? [])].sort()).toEqual([...MEQ_DIFFICULTIES].sort());
    }
  });
});

describe("isDuplicateMeqTitle", () => {
  const existing = ["เด็กชาย 8 ปี ไข้สูง ปวดข้อ และผื่นขึ้นตามตัว", "หญิง 62 ปี บวมขาทั้งสองข้างและหอบเหนื่อย"];

  it("flags exact and whitespace-variant titles", () => {
    expect(isDuplicateMeqTitle("เด็กชาย 8 ปี ไข้สูง ปวดข้อ และผื่นขึ้นตามตัว", existing)).toBe(true);
    expect(isDuplicateMeqTitle("เด็กชาย 8 ปี  ไข้สูง, ปวดข้อ และผื่นขึ้นตามตัว", existing)).toBe(true);
  });

  it("flags a title that is a prefix of an existing one", () => {
    expect(isDuplicateMeqTitle("เด็กชาย 8 ปี ไข้สูง ปวดข้อ และผื่นขึ้น", existing)).toBe(true);
  });

  it("allows a different case", () => {
    expect(isDuplicateMeqTitle("เด็กหญิง 5 ปี ปัสสาวะสีโค้ก", existing)).toBe(false);
    expect(isDuplicateMeqTitle("", existing)).toBe(false);
  });
});

describe("existingCasesPromptBlock", () => {
  it("lists titles, or is empty when there are none", () => {
    expect(existingCasesPromptBlock([])).toBe("");
    expect(existingCasesPromptBlock(["A", "B"])).toContain("- A\n- B");
  });
});
