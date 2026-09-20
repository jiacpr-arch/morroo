import { describe, it, expect } from "vitest";
import {
  splitLessonParts,
  splitLessonPartsRaw,
  joinLessonParts,
  buildLessonBody,
  hasTrailingGate,
} from "./lesson-parts";

const QUIZ = {
  stem: "prokaryote มีลักษณะใด?",
  choices: [
    { label: "A", text: "มีนิวเคลียส" },
    { label: "B", text: "ไรโบโซม 80S" },
    { label: "C", text: "ไม่มีนิวเคลียส" },
    { label: "D", text: "มี mitochondria" },
  ],
  correct_answer: "C",
  explanation: "prokaryote ไม่มีนิวเคลียส",
  difficulty: null,
};

describe("splitLessonParts", () => {
  it("splits parts and attaches the inline quiz that follows each marker", () => {
    const md = [
      "Part one body.",
      "## ⏸ Mini Quiz",
      "```quiz",
      JSON.stringify(QUIZ),
      "```",
      "",
      "Part two body.",
    ].join("\n");

    const { parts, gateQuizzes } = splitLessonParts(md);
    expect(parts).toEqual(["Part one body.", "Part two body."]);
    expect(gateQuizzes).toHaveLength(1);
    expect(gateQuizzes[0]).toEqual(QUIZ);
  });

  it("strips the quiz block out of the rendered part text", () => {
    const md = `A.\n\n## ⏸ Mini Quiz\n\`\`\`quiz\n${JSON.stringify(QUIZ)}\n\`\`\`\n\nB.`;
    const { parts } = splitLessonParts(md);
    expect(parts[1]).toBe("B.");
    expect(parts[1]).not.toContain("```");
  });

  it("returns a null gate quiz when a marker has no inline block (legacy lessons)", () => {
    const md = "First part.\n\n## ⏸ Mini Quiz\n\nSecond part.";
    const { parts, gateQuizzes } = splitLessonParts(md);
    expect(parts).toEqual(["First part.", "Second part."]);
    expect(gateQuizzes).toEqual([null]);
  });

  it("handles multiple gates", () => {
    const md = [
      "P1",
      "## ⏸ Mini Quiz",
      "```quiz",
      JSON.stringify(QUIZ),
      "```",
      "P2",
      "## ⏸ Mini Quiz",
      "```quiz",
      JSON.stringify({ ...QUIZ, stem: "Q2" }),
      "```",
      "P3",
    ].join("\n");
    const { parts, gateQuizzes } = splitLessonParts(md);
    expect(parts).toEqual(["P1", "P2", "P3"]);
    expect(gateQuizzes).toHaveLength(2);
    expect(gateQuizzes[0]?.stem).toBe("prokaryote มีลักษณะใด?");
    expect(gateQuizzes[1]?.stem).toBe("Q2");
  });

  it("treats a malformed quiz block as no inline quiz", () => {
    const md = "P1\n\n## ⏸ Mini Quiz\n```quiz\n{ not valid json }\n```\nP2";
    const { gateQuizzes } = splitLessonParts(md);
    expect(gateQuizzes[0]).toBeNull();
  });

  it("returns a single empty part for empty input", () => {
    expect(splitLessonParts("")).toEqual({ parts: [""], gateQuizzes: [] });
  });

  it("parses an authored difficulty and ignores invalid values", () => {
    const hard = JSON.stringify({ ...QUIZ, difficulty: "hard" });
    const bogus = JSON.stringify({ ...QUIZ, stem: "Q2", difficulty: "spicy" });
    const md = [
      "P1",
      "## ⏸ Mini Quiz",
      "```quiz",
      hard,
      "```",
      "P2",
      "## ⏸ Mini Quiz",
      "```quiz",
      bogus,
      "```",
      "P3",
    ].join("\n");
    const { gateQuizzes } = splitLessonParts(md);
    expect(gateQuizzes[0]?.difficulty).toBe("hard");
    expect(gateQuizzes[1]?.difficulty).toBeNull();
  });

  describe("trailing gate (mini-class: a quiz after the last section too)", () => {
    it("drops the empty part after a trailing marker so gateQuizzes.length === parts.length", () => {
      const md = [
        "P1",
        "## ⏸ Mini Quiz",
        "```quiz",
        JSON.stringify(QUIZ),
        "```",
      ].join("\n");
      const { parts, gateQuizzes } = splitLessonParts(md);
      expect(parts).toEqual(["P1"]);
      expect(gateQuizzes).toHaveLength(1);
      expect(hasTrailingGate(md)).toBe(true);
    });

    it("keeps the legacy shape (last part has no quiz) unaffected", () => {
      const md = "P1\n\n## ⏸ Mini Quiz\n```quiz\n" + JSON.stringify(QUIZ) + "\n```\n\nP2";
      const { parts, gateQuizzes } = splitLessonParts(md);
      expect(parts).toEqual(["P1", "P2"]);
      expect(gateQuizzes).toHaveLength(1);
      expect(hasTrailingGate(md)).toBe(false);
    });

    it("does not treat a body with zero gates as trailing", () => {
      expect(hasTrailingGate("Just one part, no marker at all.")).toBe(false);
    });

    it("supports a trailing gate with a legacy (quiz-less) marker", () => {
      const md = "P1\n\n## ⏸ Mini Quiz";
      const { parts, gateQuizzes } = splitLessonParts(md);
      expect(parts).toEqual(["P1"]);
      expect(gateQuizzes).toEqual([null]);
      expect(hasTrailingGate(md)).toBe(true);
    });
  });

  describe("joinLessonParts", () => {
    it("round-trips a trailing-gate split", () => {
      const md = [
        "P1",
        "## ⏸ Mini Quiz",
        "```quiz",
        JSON.stringify(QUIZ),
        "```",
        "P2",
        "## ⏸ Mini Quiz",
        "```quiz",
        JSON.stringify({ ...QUIZ, stem: "Q2" }),
        "```",
      ].join("\n");
      const { parts, gateRaw } = splitLessonPartsRaw(md);
      const rebuilt = joinLessonParts(parts, gateRaw);
      expect(splitLessonPartsRaw(rebuilt)).toEqual(splitLessonPartsRaw(md));
    });

    it("round-trips the legacy (non-trailing) split", () => {
      const md = "P1\n\n## ⏸ Mini Quiz\n```quiz\n" + JSON.stringify(QUIZ) + "\n```\n\nP2";
      const { parts, gateRaw } = splitLessonPartsRaw(md);
      const rebuilt = joinLessonParts(parts, gateRaw);
      expect(splitLessonPartsRaw(rebuilt)).toEqual(splitLessonPartsRaw(md));
    });

    it("round-trips a body with no gates at all", () => {
      const md = "Just prose, no marker.";
      const { parts, gateRaw } = splitLessonPartsRaw(md);
      expect(joinLessonParts(parts, gateRaw)).toBe(md);
    });
  });

  describe("buildLessonBody", () => {
    it("builds a trailing-gate body that splitLessonParts reads back correctly", () => {
      const sections = [
        { body: "Section one.", quiz: QUIZ },
        { body: "Section two.", quiz: { ...QUIZ, stem: "Q2", difficulty: "hard" as const } },
      ];
      const body = buildLessonBody(sections);
      const { parts, gateQuizzes } = splitLessonParts(body);
      expect(parts).toEqual(["Section one.", "Section two."]);
      expect(gateQuizzes).toHaveLength(2);
      expect(gateQuizzes[0]?.stem).toBe(QUIZ.stem);
      expect(gateQuizzes[1]?.stem).toBe("Q2");
      expect(gateQuizzes[1]?.difficulty).toBe("hard");
      expect(hasTrailingGate(body)).toBe(true);
    });

    it("builds a single-section body", () => {
      const body = buildLessonBody([{ body: "Only section.", quiz: QUIZ }]);
      const { parts, gateQuizzes } = splitLessonParts(body);
      expect(parts).toEqual(["Only section."]);
      expect(gateQuizzes).toHaveLength(1);
    });
  });
});
