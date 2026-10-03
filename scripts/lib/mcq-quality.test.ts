import { describe, it, expect } from "vitest";
import {
  findStructuralProblems,
  mismatchedChoiceExplanations,
  applyReview,
  REVIEW_TOOL,
} from "./mcq-quality.mjs";
import { normalizeMcqChoices } from "./mcq-choices.mjs";

const LABELS = ["A", "B", "C", "D", "E"];

function makeQuestion(key = "C", scenario = "ชาย 50 ปี เจ็บหน้าอก ข้อใดเหมาะสมที่สุด") {
  const choices = LABELS.map((label) => ({ label, text: `option ${label}` }));
  return {
    scenario,
    choices,
    correct_answer: key,
    explanation: `คำตอบที่ถูกต้อง: ${key}`,
    detailed_explanation: {
      summary: "s",
      reason: "r",
      key_takeaway: "k",
      choices: choices.map((c) => ({
        ...c,
        is_correct: c.label === key,
        explanation: c.label === key ? "ถูกต้อง เพราะ..." : `ผิด เพราะ ${c.label}`,
      })),
    },
  };
}

describe("findStructuralProblems", () => {
  it("accepts a well-formed question", () => {
    expect(findStructuralProblems(makeQuestion())).toEqual([]);
  });

  it("flags missing or extra choices", () => {
    const q = makeQuestion();
    q.choices = q.choices.slice(0, 4);
    expect(findStructuralProblems(q).join()).toMatch(/not exactly A-E/);
  });

  it("flags detailed_explanation choices out of sync with choices", () => {
    const q = makeQuestion();
    q.detailed_explanation.choices[1].text = "something else";
    expect(findStructuralProblems(q).join()).toMatch(/text doesn't match/);
  });

  it("flags is_correct on the wrong option", () => {
    const q = makeQuestion("C");
    q.correct_answer = "D";
    expect(findStructuralProblems(q).join()).toMatch(/don't match key D/);
  });

  it("flags per-choice explanations shifted by one position", () => {
    // Real Oct 2026 case: C (keyed) carried D's text, D said "ถูกต้อง".
    const q = makeQuestion("C");
    const dc = q.detailed_explanation.choices;
    [dc[2].explanation, dc[3].explanation] = [dc[3].explanation, dc[2].explanation];
    expect(mismatchedChoiceExplanations(q)).toEqual(["C", "D"]);
    expect(findStructuralProblems(q).join()).toMatch(/shifted/);
  });

  it("allows inverted polarity on NOT/EXCEPT questions", () => {
    const q = makeQuestion("E", "เด็ก 5 ขวบ อะดีนอยด์โต ข้อใดไม่ใช่ภาวะแทรกซ้อน");
    for (const c of q.detailed_explanation.choices) {
      c.explanation = c.is_correct ? "ไม่ใช่ภาวะแทรกซ้อน (คำตอบ)" : "ถูกต้อง เป็นภาวะแทรกซ้อนจริง";
    }
    expect(findStructuralProblems(q)).toEqual([]);
  });

  it("only treats the question tail as negative, not the whole history", () => {
    const history = "ผู้ป่วยบอกว่าไม่ใช่ครั้งแรกที่มีอาการ ".repeat(10);
    const q = makeQuestion("C", `${history}ข้อใดเหมาะสมที่สุด`);
    const dc = q.detailed_explanation.choices;
    [dc[2].explanation, dc[3].explanation] = [dc[3].explanation, dc[2].explanation];
    expect(mismatchedChoiceExplanations(q)).toEqual(["C", "D"]);
  });
});

describe("applyReview", () => {
  const review = (verdict: string, fixed = "") => ({
    index: 0,
    verdict,
    issues: verdict === "ok" ? [] : ["key_wrong"],
    notes: "KEY CHANGED C->B",
    fixed_question: fixed,
  });

  it("keeps ok questions unchanged", () => {
    const q = makeQuestion();
    expect(applyReview(q, review("ok"), normalizeMcqChoices).question).toBe(q);
  });

  it("drops rejected and unreviewed questions", () => {
    expect(applyReview(makeQuestion(), review("reject"), normalizeMcqChoices).question).toBeNull();
    expect(applyReview(makeQuestion(), undefined, normalizeMcqChoices).question).toBeNull();
  });

  it("applies a well-formed fix and keeps generator metadata", () => {
    const q = { ...makeQuestion("C"), difficulty: "hard", gen_tag: "anthropic:x" };
    const fixed = makeQuestion("B");
    const res = applyReview(q, review("fix", JSON.stringify(fixed)), normalizeMcqChoices);
    expect(res.question?.correct_answer).toBe("B");
    expect(res.question?.difficulty).toBe("hard");
    expect(res.question?.gen_tag).toBe("anthropic:x");
    expect(res.note).toMatch(/KEY CHANGED C->B/);
  });

  it("drops a fix that is unparseable or malformed", () => {
    expect(applyReview(makeQuestion(), review("fix", "{not json"), normalizeMcqChoices).question).toBeNull();
    const bad = makeQuestion("B");
    bad.correct_answer = "A";
    const res = applyReview(makeQuestion(), review("fix", JSON.stringify(bad)), normalizeMcqChoices);
    expect(res.question).toBeNull();
    expect(res.note).toMatch(/malformed/);
  });
});

describe("REVIEW_TOOL", () => {
  it("is strict and lists every property as required at every level", () => {
    expect(REVIEW_TOOL.strict).toBe(true);
    type Schema = {
      type?: string;
      properties?: Record<string, Schema>;
      required?: readonly string[];
      additionalProperties?: boolean;
      items?: Schema;
    };
    const check = (schema: Schema) => {
      if (schema?.type === "object") {
        expect(schema.additionalProperties).toBe(false);
        expect([...(schema.required ?? [])].sort()).toEqual(Object.keys(schema.properties ?? {}).sort());
        Object.values(schema.properties ?? {}).forEach(check);
      }
      if (schema?.type === "array" && schema.items) check(schema.items);
    };
    check(REVIEW_TOOL.input_schema as Schema);
  });
});
