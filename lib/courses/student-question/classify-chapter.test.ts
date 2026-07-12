import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { classifyChapter } from "./classify-chapter";

const CHAPTERS = [
  { id: "ch1", title: "Cardiac arrest" },
  { id: "ch2", title: "Bradycardia" },
  { id: "ch3", title: "Tachycardia" },
];

function mockFetch(body: unknown) {
  return vi.fn().mockResolvedValue({
    ok: true,
    json: async () => ({
      choices: [{ message: { content: JSON.stringify(body) } }],
    }),
  });
}

function mockFetchError(status: number) {
  return vi.fn().mockResolvedValue({
    ok: false,
    status,
    text: async () => "boom",
    json: async () => ({}),
  });
}

describe("classifyChapter", () => {
  let prevKey: string | undefined;
  let prevFetch: typeof fetch;

  beforeEach(() => {
    prevKey = process.env.DEEPSEEK_API_KEY;
    prevFetch = globalThis.fetch;
    process.env.DEEPSEEK_API_KEY = "test-key";
  });

  afterEach(() => {
    globalThis.fetch = prevFetch;
    if (prevKey === undefined) delete process.env.DEEPSEEK_API_KEY;
    else process.env.DEEPSEEK_API_KEY = prevKey;
  });

  it("returns matched chapterId when AI picks a valid id", async () => {
    globalThis.fetch = mockFetch({ chapterId: "ch1", reason: "cardiac arrest topic" }) as never;
    const r = await classifyChapter({ question: "CPR ทำกี่ครั้ง", answer: "30:2 cycles", chapters: CHAPTERS });
    expect(r.chapterId).toBe("ch1");
    expect(r.reason).toBe("cardiac arrest topic");
    expect(r.suggestedNewChapter).toBe("");
  });

  it("returns null chapterId when AI returns an unknown id", async () => {
    globalThis.fetch = mockFetch({ chapterId: "ch999", reason: "made up" }) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS });
    expect(r.chapterId).toBeNull();
  });

  it("returns suggestedNewChapter when no fit and AI proposes one", async () => {
    globalThis.fetch = mockFetch({ chapterId: "", reason: "no fit", suggestedNewChapter: "Pediatric ALS" }) as never;
    const r = await classifyChapter({ question: "pediatric dose", answer: "kid stuff", chapters: CHAPTERS });
    expect(r.chapterId).toBeNull();
    expect(r.suggestedNewChapter).toBe("Pediatric ALS");
  });

  it("ignores suggestedNewChapter when chapterId is valid", async () => {
    globalThis.fetch = mockFetch({ chapterId: "ch2", suggestedNewChapter: "Should be ignored" }) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS });
    expect(r.chapterId).toBe("ch2");
    expect(r.suggestedNewChapter).toBe("");
  });

  it("truncates overly long suggestedNewChapter", async () => {
    globalThis.fetch = mockFetch({ chapterId: "", suggestedNewChapter: "x".repeat(200) }) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS });
    expect(r.suggestedNewChapter.length).toBe(40);
  });

  it("returns null on non-2xx response without throwing", async () => {
    globalThis.fetch = mockFetchError(500) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS });
    expect(r.chapterId).toBeNull();
    expect(r.reason).toMatch(/classify failed: 500/);
  });

  it("returns null on malformed JSON without throwing", async () => {
    globalThis.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ choices: [{ message: { content: "not json" } }] }),
    }) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS });
    expect(r.chapterId).toBeNull();
    expect(r.reason).toMatch(/parse failed/);
  });

  it("returns null chapterId when chapter list is empty (no API call)", async () => {
    let called = false;
    globalThis.fetch = vi.fn(async () => {
      called = true;
      return { ok: true, json: async () => ({}) };
    }) as never;
    const r = await classifyChapter({ question: "q", answer: "a", chapters: [] });
    expect(r.chapterId).toBeNull();
    expect(called).toBe(false);
  });

  it("throws when DEEPSEEK_API_KEY is missing", async () => {
    delete process.env.DEEPSEEK_API_KEY;
    await expect(
      classifyChapter({ question: "q", answer: "a", chapters: CHAPTERS }),
    ).rejects.toThrow(/DEEPSEEK_API_KEY/);
  });
});
