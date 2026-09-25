import { describe, expect, it } from "vitest";
import {
  gradeMockAnswers,
  sanitizeMockAnswers,
  toMockPublicQuestion,
  toMockReviewItem,
} from "./mcq-mock-grade";
import type { McqQuestion } from "./types-mcq";

const question: McqQuestion = {
  id: "q1",
  subject_id: "s1",
  exam_type: "NL2",
  exam_source: "NL2 2568",
  question_number: 1,
  scenario: "ผู้ป่วยชาย 60 ปี ...",
  choices: [
    { label: "A", text: "a" },
    { label: "B", text: "b" },
  ],
  correct_answer: "B",
  explanation: "เพราะ ...",
  detailed_explanation: {
    summary: "sum",
    reason: "reason",
    choices: [{ label: "B", text: "b", is_correct: true, explanation: "ถูก" }],
    key_takeaway: "key",
  },
  difficulty: "medium",
  is_ai_enhanced: true,
  ai_notes: "internal",
  status: "active",
  audience: "student",
  board_specialty: null,
  board_subspecialty: null,
  board_section: null,
  board_topic: null,
  board_age_group: null,
  board_level: null,
  reference_source: null,
  created_at: "2026-01-01",
};

describe("toMockPublicQuestion", () => {
  it("keeps only what the exam screen renders — no answer or teaching fields", () => {
    const pub = toMockPublicQuestion(question);
    expect(Object.keys(pub).sort()).toEqual(
      ["choices", "exam_source", "id", "mcq_subjects", "scenario", "subject_id"].sort(),
    );
    const json = JSON.stringify(pub);
    expect(json).not.toContain("correct_answer");
    expect(json).not.toContain("explanation");
    expect(json).not.toContain("is_correct");
    expect(json).not.toContain("internal");
  });

  it("strips unexpected extra keys from choices", () => {
    const q = { ...question, choices: [{ label: "A", text: "a", is_correct: true } as never] };
    expect(toMockPublicQuestion(q).choices).toEqual([{ label: "A", text: "a" }]);
  });
});

describe("toMockReviewItem", () => {
  it("carries the answer and explanations for the review screen", () => {
    expect(toMockReviewItem(question)).toEqual({
      id: "q1",
      correct_answer: "B",
      explanation: "เพราะ ...",
      detailed_explanation: question.detailed_explanation,
    });
  });
});

describe("sanitizeMockAnswers", () => {
  it("keeps only issued question ids with single-letter choices", () => {
    const out = sanitizeMockAnswers(
      { q1: "A", q2: "b", q3: "AB", q4: 1, extra: "A", __proto__: "A" },
      ["q1", "q2", "q3", "q4", "q5"],
    );
    expect(out).toEqual({ q1: "A", q2: null, q3: null, q4: null, q5: null });
  });

  it("treats non-object input as all unanswered", () => {
    expect(sanitizeMockAnswers(null, ["q1"])).toEqual({ q1: null });
    expect(sanitizeMockAnswers(["A"], ["q1"])).toEqual({ q1: null });
    expect(sanitizeMockAnswers("A", ["q1"])).toEqual({ q1: null });
  });
});

describe("gradeMockAnswers", () => {
  const key = new Map<string, string | null>([
    ["q1", "A"],
    ["q2", "B"],
    ["q3", "C"],
  ]);

  it("counts correct answers in token order", () => {
    const res = gradeMockAnswers(["q1", "q2", "q3"], key, { q1: "A", q2: "C", q3: null });
    expect(res).toEqual({
      correctCount: 1,
      total: 3,
      perQuestion: [
        { id: "q1", selected: "A", isCorrect: true },
        { id: "q2", selected: "C", isCorrect: false },
        { id: "q3", selected: null, isCorrect: false },
      ],
    });
  });

  it("counts a question missing from the answer key as wrong but keeps it in the total", () => {
    const res = gradeMockAnswers(["q1", "gone"], key, { q1: "A", gone: "A" });
    expect(res.correctCount).toBe(1);
    expect(res.total).toBe(2);
    expect(res.perQuestion[1]).toEqual({ id: "gone", selected: "A", isCorrect: false });
  });

  it("never lets an unanswered question match a null key", () => {
    const res = gradeMockAnswers(["x"], new Map([["x", null]]), { x: null });
    expect(res.correctCount).toBe(0);
  });
});
