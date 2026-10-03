import { describe, expect, it } from "vitest";
import {
  examStepsForTarget,
  examTargetLabel,
  isCurrentYear,
  isExamTarget,
  isMcqPool,
  mcqPoolForTarget,
  practiceExamType,
  suggestTargetFromYear,
} from "./exam-level";

describe("exam-level", () => {
  it("validates targets, pools and years", () => {
    expect(isExamTarget("NL3")).toBe(true);
    expect(isExamTarget("NL4")).toBe(false);
    expect(isExamTarget(null)).toBe(false);
    expect(isMcqPool("board")).toBe(true);
    expect(isMcqPool("both")).toBe(false);
    expect(isCurrentYear(6)).toBe(true);
    expect(isCurrentYear(7)).toBe(false);
    expect(isCurrentYear(2.5)).toBe(false);
    expect(isCurrentYear("3")).toBe(false);
  });

  it("suggests a target from the year", () => {
    expect(suggestTargetFromYear(1)).toBe("NL1");
    expect(suggestTargetFromYear(3)).toBe("NL1");
    expect(suggestTargetFromYear(4)).toBe("NL2");
    expect(suggestTargetFromYear(5)).toBe("NL2");
    expect(suggestTargetFromYear(6)).toBe("NL3");
    expect(suggestTargetFromYear(0)).toBeNull();
  });

  it("maps targets to MCQ pools", () => {
    expect(mcqPoolForTarget("NL1")).toBe("NL1");
    expect(mcqPoolForTarget("NL2")).toBe("NL2");
    expect(mcqPoolForTarget("NL3")).toBe("NL2");
    expect(mcqPoolForTarget("board")).toBeNull(); // board daily card needs a /board deep link first
    expect(mcqPoolForTarget("both")).toBeNull();
    expect(mcqPoolForTarget(null)).toBeNull();
  });

  it("maps targets to exam steps", () => {
    expect(examStepsForTarget("NL1")).toEqual([1]);
    expect(examStepsForTarget("NL3")).toEqual([3]);
    expect(examStepsForTarget("both")).toEqual([1, 2, 3]);
    expect(examStepsForTarget("board")).toEqual([]);
    expect(examStepsForTarget(null)).toEqual([]);
  });

  it("defaults practice to NL2", () => {
    expect(practiceExamType("NL1")).toBe("NL1");
    expect(practiceExamType("NL3")).toBe("NL2");
    expect(practiceExamType(null)).toBe("NL2");
  });

  it("labels targets", () => {
    expect(examTargetLabel("both")).toBe("ทุกขั้นตอน");
    expect(examTargetLabel("x")).toBeNull();
  });
});
