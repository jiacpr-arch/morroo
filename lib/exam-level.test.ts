import { describe, expect, it } from "vitest";
import {
  EXAM_TARGETS,
  examKindsForTarget,
  examTargetLabel,
  isBoardSpecialtySlug,
  isCurrentYear,
  isExamTarget,
  isMcqPool,
  mcqPoolForTarget,
  normalizeTarget,
  practiceExamForTarget,
  practicePathForTarget,
  suggestTargetFromYear,
} from "./exam-level";

describe("exam-level", () => {
  it("validates targets, pools and years", () => {
    expect(isExamTarget("part1")).toBe(true);
    expect(isExamTarget("NL1")).toBe(false); // retired — last NL1 sitting was Jan 2569
    expect(isExamTarget(null)).toBe(false);
    expect(isMcqPool("board")).toBe(true);
    expect(isMcqPool("part1")).toBe(false);
    expect(isCurrentYear(6)).toBe(true);
    expect(isCurrentYear(7)).toBe(false);
    expect(isCurrentYear(2.5)).toBe(false);
    expect(isCurrentYear("3")).toBe(false);
  });

  it("maps legacy target_exam values onto the new levels", () => {
    expect(normalizeTarget("NL1")).toBe("part1");
    expect(normalizeTarget("both")).toBe("part1");
    expect(normalizeTarget("NL3")).toBe("part2");
    expect(normalizeTarget("NL2")).toBe("NL2");
    expect(normalizeTarget("board")).toBe("board");
    expect(normalizeTarget("x")).toBeNull();
    expect(normalizeTarget(null)).toBeNull();
  });

  it("suggests a target from the year", () => {
    expect(suggestTargetFromYear(1)).toBe("part1");
    expect(suggestTargetFromYear(5)).toBe("part1");
    expect(suggestTargetFromYear(6)).toBe("part2");
    expect(suggestTargetFromYear(0)).toBeNull();
  });

  it("maps targets to MCQ pools", () => {
    expect(mcqPoolForTarget("part1")).toBeNull(); // mixed NL1+NL2 = ส่วนที่ 1
    expect(mcqPoolForTarget("NL2")).toBe("NL2");
    expect(mcqPoolForTarget("part2")).toBe("NL2");
    expect(mcqPoolForTarget("meq")).toBe("NL2"); // MEQ has no daily MCQ — clinical NL2 card
    expect(mcqPoolForTarget("board")).toBeNull(); // no specialty yet → mixed NL card
    expect(mcqPoolForTarget("board", "internal_medicine")).toBe("board");
    expect(mcqPoolForTarget("board", "Bad Slug!")).toBeNull();
    expect(mcqPoolForTarget("part1", "internal_medicine")).toBeNull(); // specialty only matters for board
    expect(mcqPoolForTarget("NL1")).toBeNull(); // legacy → part1
    expect(mcqPoolForTarget(null)).toBeNull();
  });

  it("maps targets to exam kinds", () => {
    expect(examKindsForTarget("part1")).toEqual(["part1"]);
    expect(examKindsForTarget("NL2")).toEqual(["nl2"]);
    expect(examKindsForTarget("part2")).toEqual(["osce"]);
    expect(examKindsForTarget("meq")).toEqual(["meq"]);
    expect(examKindsForTarget("both")).toEqual(["part1"]);
    expect(examKindsForTarget("board")).toEqual([]);
    expect(examKindsForTarget(null)).toEqual([]);
  });

  it("sends MEQ users to the MEQ bank", () => {
    expect(practicePathForTarget("meq")).toBe("/exams");
    expect(practicePathForTarget("part1")).toBe("/nl/practice");
    expect(practicePathForTarget("board", "ob_gyn")).toBe("/board/ob_gyn/practice");
    expect(practicePathForTarget("board")).toBe("/board");
    expect(practicePathForTarget("board", "../etc")).toBe("/board");
    expect(practicePathForTarget(null)).toBe("/nl/practice");
  });

  it("picks the practice exam", () => {
    expect(practiceExamForTarget("part1")).toBe("all");
    expect(practiceExamForTarget("NL1")).toBe("all");
    expect(practiceExamForTarget("NL2")).toBe("NL2");
    expect(practiceExamForTarget(null)).toBe("NL2");
  });

  it("accepts board specialty slugs only in slug shape", () => {
    expect(isBoardSpecialtySlug("emergency_medicine")).toBe(true);
    expect(isBoardSpecialtySlug("emergency-medicine")).toBe(true);
    expect(isBoardSpecialtySlug("")).toBe(false);
    expect(isBoardSpecialtySlug("a b")).toBe(false);
    expect(isBoardSpecialtySlug("Upper")).toBe(false);
    expect(isBoardSpecialtySlug(null)).toBe(false);
  });

  it("labels targets and keeps LINE quick-reply labels short", () => {
    expect(examTargetLabel("both")).toBe("ส่วนที่ 1 (ข้อสอบรวม)");
    expect(examTargetLabel("x")).toBeNull();
    for (const t of EXAM_TARGETS) expect(t.shortLabel.length).toBeLessThanOrEqual(20);
  });
});
