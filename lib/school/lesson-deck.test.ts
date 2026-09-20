import { describe, it, expect } from "vitest";
import {
  buildDeck,
  canAdvance,
  nextIndex,
  prevIndex,
  isLastIndex,
  progressPct,
  finalRetrievalPool,
} from "./lesson-deck";
import type { InlineQuiz } from "./lesson-parts";

const quiz = (stem: string): InlineQuiz => ({
  stem,
  choices: [{ label: "A", text: "x" }],
  correct_answer: "A",
  explanation: null,
  difficulty: null,
});

describe("buildDeck", () => {
  it("marks the last section and prefers the inline gate quiz", () => {
    const deck = buildDeck(["P1", "P2", "P3"], [quiz("Q1"), null, quiz("Q3")]);
    expect(deck).toHaveLength(3);
    expect(deck[0]).toMatchObject({ index: 0, body: "P1", isLast: false });
    expect(deck[0].quiz?.stem).toBe("Q1");
    expect(deck[2]).toMatchObject({ index: 2, body: "P3", isLast: true });
  });

  it("falls back to the topic-pool quiz when a section has no inline quiz", () => {
    const deck = buildDeck(["P1", "P2"], [null, null], [quiz("pool-0"), quiz("pool-1")]);
    expect(deck[0].quiz?.stem).toBe("pool-0");
    expect(deck[1].quiz?.stem).toBe("pool-1");
  });

  it("leaves quiz null when neither inline nor pool has one", () => {
    const deck = buildDeck(["P1"], [null]);
    expect(deck[0].quiz).toBeNull();
  });

  it("handles a single section", () => {
    const deck = buildDeck(["Only"], [quiz("Q")]);
    expect(deck).toHaveLength(1);
    expect(deck[0].isLast).toBe(true);
  });
});

describe("canAdvance", () => {
  it("never blocks a section with no quiz", () => {
    expect(canAdvance(null, null, { gating: true })).toBe(true);
  });

  it("never blocks when not gating (read mode — question optional)", () => {
    expect(canAdvance(quiz("Q"), null, { gating: false })).toBe(true);
  });

  it("blocks a gated quiz until any answer is picked", () => {
    expect(canAdvance(quiz("Q"), null, { gating: true })).toBe(false);
    expect(canAdvance(quiz("Q"), "A", { gating: true })).toBe(true);
  });

  it("unlocks on any pick, not just the correct one", () => {
    expect(canAdvance(quiz("Q"), "wrong-but-picked", { gating: true })).toBe(true);
  });
});

describe("nextIndex / prevIndex / isLastIndex", () => {
  it("clamps nextIndex at the last section", () => {
    expect(nextIndex(0, 3)).toBe(1);
    expect(nextIndex(2, 3)).toBe(2);
  });

  it("clamps prevIndex at 0", () => {
    expect(prevIndex(0)).toBe(0);
    expect(prevIndex(2)).toBe(1);
  });

  it("identifies the last index", () => {
    expect(isLastIndex(2, 3)).toBe(true);
    expect(isLastIndex(1, 3)).toBe(false);
    expect(isLastIndex(0, 0)).toBe(false);
  });

  it("nextIndex on an empty deck stays at 0", () => {
    expect(nextIndex(0, 0)).toBe(0);
  });
});

describe("progressPct", () => {
  it("computes 1-based progress", () => {
    expect(progressPct(0, 4)).toBe(25);
    expect(progressPct(3, 4)).toBe(100);
  });

  it("returns 0 for an empty deck", () => {
    expect(progressPct(0, 0)).toBe(0);
  });
});

describe("finalRetrievalPool", () => {
  it("returns the pool tail after the gates consumed from the front", () => {
    const pool = [1, 2, 3, 4, 5];
    expect(finalRetrievalPool(pool, 2)).toEqual([3, 4, 5]);
  });

  it("returns empty once gates cover or exceed the pool", () => {
    expect(finalRetrievalPool([1, 2], 2)).toEqual([]);
    expect(finalRetrievalPool([1, 2], 5)).toEqual([]);
  });

  it("returns the whole pool when no gates were used", () => {
    expect(finalRetrievalPool([1, 2, 3], 0)).toEqual([1, 2, 3]);
  });
});
