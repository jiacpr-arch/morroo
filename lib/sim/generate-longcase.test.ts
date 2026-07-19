import { describe, expect, it } from "vitest";
import {
  LONGCASE_CASE_COLUMNS,
  SCENARIO_TOOL,
  longcaseSystemPrompt,
} from "./generate-longcase";
import { lcTorsion } from "./scenarios";

describe("longcase generation prompt (shared)", () => {
  const caseRow = {
    title: "ชาย 40 ปี ไข้สูงหนาวสั่น",
    correct_diagnosis: "Acute pyelonephritis",
    examiner_questions: [{ question: "why?", modelAnswer: "because", points: 10 }],
  };

  it("column list pulls examiner_questions (needed for the Q&A phase)", () => {
    expect(LONGCASE_CASE_COLUMNS).toContain("examiner_questions");
    expect(LONGCASE_CASE_COLUMNS).toContain("history_script");
    expect(LONGCASE_CASE_COLUMNS).toContain("accepted_ddx");
  });

  it("embeds the case data and the torsion worked example", () => {
    const p = longcaseSystemPrompt([], caseRow);
    expect(p).toContain("Acute pyelonephritis");
    expect(p).toContain(JSON.stringify(caseRow));
    // ใช้ torsion เป็นแม่แบบ (มี slug เฉพาะของมันอยู่ใน example)
    expect(p).toContain(lcTorsion.slug);
    expect(p).toContain(JSON.stringify(lcTorsion));
  });

  it("instructs the examiner Q&A phase and case-specific distractors (the quality levers)", () => {
    const p = longcaseSystemPrompt([], caseRow);
    expect(p).toContain("อาจารย์ซักถาม");
    expect(p).toContain("examiner_questions");
    expect(p).toContain("กับดักคลินิก");
    expect(p).toContain("ห้ามใช้ fx");
  });

  it("lists extra characters when provided", () => {
    const p = longcaseSystemPrompt(
      [{ slug: "resident_joe", name: "เรสซิเดนต์โจ", role: "Resident", personality: "ใจเย็น" }],
      caseRow,
    );
    expect(p).toContain("resident_joe");
    expect(p).toContain("เรสซิเดนต์โจ");
  });

  it("tool schema requires the scenario fields", () => {
    expect(SCENARIO_TOOL.name).toBe("create_sim_scenario");
    expect(SCENARIO_TOOL.input_schema.required).toEqual(
      expect.arrayContaining(["slug", "title", "story"]),
    );
  });
});
