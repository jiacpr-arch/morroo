import { afterEach, describe, expect, it, vi } from "vitest";
import { NL_EXAM_ROUNDS } from "./exam-dates";
import { loadExamRounds, rowsToRounds } from "./exam-rounds";

function fakeDb(result: { data?: unknown; error?: unknown } | "throw") {
  return {
    from: () => ({
      select: () => ({
        eq: () => ({
          order: () => (result === "throw" ? Promise.reject(new Error("net")) : Promise.resolve(result)),
        }),
      }),
    }),
  } as never;
}

afterEach(() => vi.restoreAllMocks());

describe("rowsToRounds", () => {
  it("maps rows, drops unknown kinds / bad dates and sorts by date", () => {
    const rounds = rowsToRounds([
      { kind: "osce", label: "B", exam_date: "2027-01-10", confirmed: false },
      { kind: "part1", label: "A", exam_date: "2026-12-01", confirmed: true },
      { kind: "bogus", label: "X", exam_date: "2026-12-02", confirmed: true },
      { kind: "nl2", label: "Y", exam_date: "not-a-date", confirmed: true },
    ]);
    expect(rounds).toEqual([
      { kind: "part1", label: "A", date: "2026-12-01", confirmed: true },
      { kind: "osce", label: "B", date: "2027-01-10", confirmed: false },
    ]);
  });
});

describe("loadExamRounds", () => {
  it("returns the database rounds", async () => {
    const rounds = await loadExamRounds(
      fakeDb({ data: [{ kind: "part1", label: "A", exam_date: "2027-05-01", confirmed: true }], error: null })
    );
    expect(rounds).toEqual([{ kind: "part1", label: "A", date: "2027-05-01", confirmed: true }]);
  });

  it("falls back to the static rounds when the table is empty, errors or throws", async () => {
    vi.spyOn(console, "error").mockImplementation(() => {});
    expect(await loadExamRounds(fakeDb({ data: [], error: null }))).toBe(NL_EXAM_ROUNDS);
    expect(await loadExamRounds(fakeDb({ data: null, error: { message: "missing table" } }))).toBe(NL_EXAM_ROUNDS);
    expect(await loadExamRounds(fakeDb("throw"))).toBe(NL_EXAM_ROUNDS);
  });
});
