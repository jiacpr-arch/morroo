import { describe, it, expect, vi, beforeEach } from "vitest";

// `mcq_questions.id` is a uuid column. A junk `?q=` deep link (LINE daily
// quiz / dashboard card) must be rejected before it reaches Postgres,
// because a non-uuid value raises 22P02 (logged as "Error fetching MCQ
// question") instead of the intended silent fallback to the normal pool.

const from = vi.fn();

function makeBuilder(result: unknown) {
  const chain: Record<string, unknown> = {};
  for (const m of ["select", "eq"]) {
    chain[m] = vi.fn(() => chain);
  }
  chain.single = vi.fn(() => Promise.resolve(result));
  return chain;
}

vi.mock("./server", () => ({
  createClient: vi.fn(async () => ({ from })),
}));
vi.mock("./admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const { getMcqQuestion } = await import("./queries-mcq");

const REAL_ID = "6f1c3f6a-1b2c-4d5e-8f90-1a2b3c4d5e6f";

beforeEach(() => {
  from.mockReset();
});

describe("getMcqQuestion", () => {
  it("returns null without querying when the id is not a uuid", async () => {
    for (const junk of ["tel:0885588078", "abc-123", "undefined", ""]) {
      expect(await getMcqQuestion(junk)).toBeNull();
    }
    expect(from).not.toHaveBeenCalled();
  });

  it("queries mcq_questions for a real uuid", async () => {
    from.mockReturnValue(
      makeBuilder({ data: { id: REAL_ID, subject_id: "s1" }, error: null })
    );
    const question = await getMcqQuestion(REAL_ID);
    expect(from).toHaveBeenCalledWith("mcq_questions");
    expect(question).toMatchObject({ id: REAL_ID });
  });
});
