import { describe, it, expect } from "vitest";
import { difficultyRank, sortByDifficultyAsc } from "./difficulty";

describe("difficultyRank", () => {
  it("orders easy < medium < hard", () => {
    expect(difficultyRank("easy")).toBeLessThan(difficultyRank("medium"));
    expect(difficultyRank("medium")).toBeLessThan(difficultyRank("hard"));
  });

  it("treats null/undefined as medium", () => {
    expect(difficultyRank(null)).toBe(difficultyRank("medium"));
    expect(difficultyRank(undefined)).toBe(difficultyRank("medium"));
  });
});

describe("sortByDifficultyAsc", () => {
  it("ramps from easy to hard", () => {
    const items = [
      { id: 1, d: "hard" as const },
      { id: 2, d: "easy" as const },
      { id: 3, d: "medium" as const },
    ];
    const out = sortByDifficultyAsc(items, (x) => x.d);
    expect(out.map((x) => x.id)).toEqual([2, 3, 1]);
  });

  it("is stable within a tier (preserves prior order)", () => {
    const items = [
      { id: 1, d: "easy" as const },
      { id: 2, d: "easy" as const },
      { id: 3, d: "hard" as const },
      { id: 4, d: "easy" as const },
    ];
    const out = sortByDifficultyAsc(items, (x) => x.d);
    expect(out.map((x) => x.id)).toEqual([1, 2, 4, 3]);
  });
});
