import { describe, expect, it } from "vitest";
import {
  BLS_FINAL_ID,
  BLS_STAGES,
  buildFinalExam,
  countPassedStages,
  getStageById,
  isBlsStageUnlocked,
  isFinalUnlocked,
} from "./blsGame";

describe("BLS_STAGES content", () => {
  it("has 8 sequential stages with unique ids", () => {
    expect(BLS_STAGES).toHaveLength(8);
    expect(new Set(BLS_STAGES.map((s) => s.id)).size).toBe(8);
    BLS_STAGES.forEach((s, i) => {
      expect(s.stageNumber).toBe(i + 1);
      expect(s.id.startsWith("bls-")).toBe(true);
      expect(s.passScore).toBeGreaterThan(0);
      expect(s.steps.length).toBeGreaterThanOrEqual(4);
    });
  });

  it("every step has exactly one correct option and feedback on all options", () => {
    for (const stage of BLS_STAGES) {
      for (const step of stage.steps) {
        const correct = step.options.filter((o) => o.correct === true);
        expect(correct, `${stage.id}: ${step.question}`).toHaveLength(1);
        for (const o of step.options) {
          expect(o.feedback.length).toBeGreaterThan(0);
        }
      }
    }
  });
});

describe("buildFinalExam", () => {
  it("samples 2 opening steps per stage without cprDrill", () => {
    const exam = buildFinalExam();
    expect(exam.id).toBe(BLS_FINAL_ID);
    expect(exam.steps).toHaveLength(BLS_STAGES.length * 2);
    expect(exam.steps.every((s) => s.cprDrill === false)).toBe(true);
    expect(exam.steps.every((s) => !!s.sourceStage)).toBe(true);
  });
});

describe("getStageById", () => {
  it("returns stage with shuffled options preserving members", () => {
    const original = BLS_STAGES[0];
    const loaded = getStageById(original.id);
    expect(loaded).not.toBeNull();
    loaded!.steps.forEach((step, i) => {
      const labels = step.options.map((o) => o.label).sort();
      const origLabels = original.steps[i].options.map((o) => o.label).sort();
      expect(labels).toEqual(origLabels);
    });
  });

  it("resolves the final exam and unknown ids", () => {
    expect(getStageById(BLS_FINAL_ID)?.title).toContain("ข้อสอบรวม");
    expect(getStageById("nope")).toBeNull();
  });
});

describe("unlock logic", () => {
  it("stage 1 is always unlocked; stage n needs stage n-1 passed", () => {
    const none = new Set<string>();
    expect(isBlsStageUnlocked(1, none)).toBe(true);
    expect(isBlsStageUnlocked(2, none)).toBe(false);
    const passed1 = new Set([BLS_STAGES[0].id]);
    expect(isBlsStageUnlocked(2, passed1)).toBe(true);
    expect(isBlsStageUnlocked(3, passed1)).toBe(false);
  });

  it("final unlocks only when all 8 passed", () => {
    const seven = new Set(BLS_STAGES.slice(0, 7).map((s) => s.id));
    expect(isFinalUnlocked(seven)).toBe(false);
    expect(countPassedStages(seven)).toBe(7);
    const all = new Set(BLS_STAGES.map((s) => s.id));
    expect(isFinalUnlocked(all)).toBe(true);
    expect(countPassedStages(all)).toBe(8);
  });
});
