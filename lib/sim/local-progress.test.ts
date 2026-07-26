import { describe, it, expect } from "vitest";
import {
  MAX_LOCAL_RUNS,
  parseLocalRuns,
  summarizeLocal,
  type LocalRun,
} from "./local-progress";

function run(overrides: Partial<LocalRun> = {}): LocalRun {
  return {
    slug: "lc-demo",
    won: true,
    grade: "S",
    score: 100,
    specialty: "อายุรศาสตร์",
    difficulty: "normal",
    xp: 150,
    at: 1_700_000_000_000,
    ...overrides,
  };
}

describe("summarizeLocal", () => {
  it("returns zeroes for no runs", () => {
    expect(summarizeLocal([])).toMatchObject({ xp: 0, wins: 0, played: 0 });
  });

  it("adds up XP and counts wins separately from plays", () => {
    const out = summarizeLocal([run(), run({ won: false, xp: 10 }), run({ xp: 60 })]);
    expect(out).toMatchObject({ xp: 220, wins: 2, played: 3 });
  });

  it("ignores negative or non-finite XP instead of corrupting the total", () => {
    const out = summarizeLocal([run({ xp: -500 }), run({ xp: Number.NaN }), run({ xp: 60 })]);
    expect(out.xp).toBe(60);
  });

  it("copies the run list so callers cannot mutate the input", () => {
    const runs = [run()];
    const out = summarizeLocal(runs);
    out.runs.push(run());
    expect(runs).toHaveLength(1);
  });
});

describe("parseLocalRuns", () => {
  it("treats missing storage as no runs", () => {
    expect(parseLocalRuns(null)).toEqual([]);
    expect(parseLocalRuns("")).toEqual([]);
  });

  it("survives malformed JSON", () => {
    expect(parseLocalRuns("{not json")).toEqual([]);
  });

  it("rejects a non-array payload", () => {
    expect(parseLocalRuns(JSON.stringify({ slug: "x" }))).toEqual([]);
  });

  it("drops entries that do not look like runs", () => {
    const raw = JSON.stringify([
      run(),
      { slug: "no-fields" },
      null,
      "string",
      run({ slug: "" }),
      run({ xp: "150" as unknown as number }),
    ]);
    const out = parseLocalRuns(raw);
    expect(out).toHaveLength(1);
    expect(out[0].slug).toBe("lc-demo");
  });

  it("accepts a run with no specialty", () => {
    expect(parseLocalRuns(JSON.stringify([run({ specialty: null })]))).toHaveLength(1);
  });

  it("rejects runs missing a NOT NULL column so the claim insert cannot fail", () => {
    for (const bad of [
      run({ difficulty: undefined as unknown as string }),
      run({ difficulty: "" }),
      run({ grade: "" as unknown as LocalRun["grade"] }),
    ]) {
      expect(parseLocalRuns(JSON.stringify([bad]))).toEqual([]);
    }
  });

  it("keeps only the most recent runs when over the cap", () => {
    const many = Array.from({ length: MAX_LOCAL_RUNS + 25 }, (_, i) =>
      run({ slug: `lc-${i}` }),
    );
    const out = parseLocalRuns(JSON.stringify(many));
    expect(out).toHaveLength(MAX_LOCAL_RUNS);
    // เก็บท้ายรายการ = รอบล่าสุด
    expect(out[out.length - 1].slug).toBe(`lc-${MAX_LOCAL_RUNS + 24}`);
  });
});
