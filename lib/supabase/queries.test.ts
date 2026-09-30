import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Supabase mock ────────────────────────────────────────────────────────────
// `from` is a spy so each test can assert whether a query was issued at all.
// A junk `/exams/[id]` segment must be rejected before it reaches Postgres,
// because `exams.id` / `exam_parts.exam_id` are uuid columns and a non-uuid
// value raises 22P02 (logged as "Error fetching exam") instead of a clean 404.

const from = vi.fn();

function makeBuilder(result: unknown) {
  const chain: Record<string, unknown> = {};
  for (const m of ["select", "eq", "order"]) {
    chain[m] = vi.fn(() => chain);
  }
  chain.single = vi.fn(() => Promise.resolve(result));
  chain.maybeSingle = vi.fn(() => Promise.resolve(result));
  chain.then = (resolve: (v: unknown) => unknown) =>
    Promise.resolve(resolve(result));
  return chain;
}

vi.mock("./server", () => ({
  createClient: vi.fn(async () => ({ from })),
}));

const { getExam, getExamParts } = await import("./queries");

const REAL_ID = "6f1c3f6a-1b2c-4d5e-8f90-1a2b3c4d5e6f";

beforeEach(() => {
  from.mockReset();
});

describe("getExam", () => {
  it("returns null without querying when the id is not a uuid", async () => {
    for (const junk of [
      "tel:0885588078",
      "tel%3A021211669",
      "undefined",
      "",
    ]) {
      expect(await getExam(junk)).toBeNull();
    }
    expect(from).not.toHaveBeenCalled();
  });

  it("queries exams for a real uuid", async () => {
    from.mockReturnValue(
      makeBuilder({ data: { id: REAL_ID, title: "x" }, error: null })
    );
    const exam = await getExam(REAL_ID);
    expect(from).toHaveBeenCalledWith("exams");
    expect(exam).toMatchObject({ id: REAL_ID });
  });

  it("treats a missing published exam as a normal not-found result", async () => {
    const builder = makeBuilder({ data: null, error: null });
    builder.single = vi.fn(async () => ({
      data: null,
      error: { code: "PGRST116", details: "The result contains 0 rows" },
    }));
    from.mockReturnValue(builder);
    const log = vi.spyOn(console, "error").mockImplementation(() => {});
    try {
      expect(await getExam(REAL_ID)).toBeNull();
      expect(log).not.toHaveBeenCalled();
    } finally {
      log.mockRestore();
    }
  });

  it("still logs database failures", async () => {
    const error = { code: "42501", message: "permission denied" };
    from.mockReturnValue(makeBuilder({ data: null, error }));
    const log = vi.spyOn(console, "error").mockImplementation(() => {});
    try {
      expect(await getExam(REAL_ID)).toBeNull();
      expect(log).toHaveBeenCalledWith("Error fetching exam:", error);
    } finally {
      log.mockRestore();
    }
  });
});

describe("getExamParts", () => {
  it("returns [] without querying when the exam id is not a uuid", async () => {
    expect(await getExamParts("tel:0885588078")).toEqual([]);
    expect(from).not.toHaveBeenCalled();
  });

  it("queries exam_parts for a real uuid", async () => {
    from.mockReturnValue(makeBuilder({ data: [{ part_number: 1 }], error: null }));
    const parts = await getExamParts(REAL_ID);
    expect(from).toHaveBeenCalledWith("exam_parts");
    expect(parts).toHaveLength(1);
  });
});
