import { describe, it, expect } from "vitest";
import { splitLessonParts } from "./lesson-parts";

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
});
