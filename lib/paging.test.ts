import { describe, it, expect } from "vitest";
import { chunk, fetchAllPages, mapLimit } from "./paging";

describe("chunk", () => {
  it("splits into fixed-size pieces with a short tail", () => {
    expect(chunk([1, 2, 3, 4, 5], 2)).toEqual([[1, 2], [3, 4], [5]]);
    expect(chunk([], 100)).toEqual([]);
  });
  it("rejects a size below 1", () => {
    expect(() => chunk([1], 0)).toThrow();
  });
});

describe("mapLimit", () => {
  it("keeps input order and never exceeds the concurrency limit", async () => {
    let inFlight = 0;
    let peak = 0;
    const out = await mapLimit([5, 1, 4, 2, 3], 2, async (n) => {
      inFlight++;
      peak = Math.max(peak, inFlight);
      await new Promise((r) => setTimeout(r, n));
      inFlight--;
      return n * 10;
    });
    expect(out).toEqual([50, 10, 40, 20, 30]);
    expect(peak).toBeLessThanOrEqual(2);
  });
  it("handles an empty list", async () => {
    expect(await mapLimit([], 4, async (x) => x)).toEqual([]);
  });
});

describe("fetchAllPages", () => {
  const table = Array.from({ length: 2500 }, (_, i) => i);
  const pager = (from: number, to: number) =>
    Promise.resolve({ data: table.slice(from, to + 1), error: null });

  it("reads past the 1000-row cap until a short page", async () => {
    const r = await fetchAllPages(pager);
    expect(r.rows).toHaveLength(2500);
    expect(r.error).toBeNull();
    expect(r.truncated).toBe(false);
  });

  it("stops at maxRows and reports truncation", async () => {
    const r = await fetchAllPages(pager, { maxRows: 2000 });
    expect(r.rows).toHaveLength(2000);
    expect(r.truncated).toBe(true);
  });

  it("surfaces an error instead of treating it as the end of data", async () => {
    const r = await fetchAllPages((from) =>
      Promise.resolve(
        from === 0
          ? { data: table.slice(0, 1000), error: null }
          : { data: null, error: { message: "URI too long" } }
      )
    );
    expect(r.rows).toHaveLength(1000);
    expect(r.error).toBe("URI too long");
  });

  it("requests exactly one extra page when the total is a multiple of the page size", async () => {
    let calls = 0;
    const r = await fetchAllPages((from, to) => {
      calls++;
      return Promise.resolve({ data: table.slice(0, 2000).slice(from, to + 1), error: null });
    });
    expect(r.rows).toHaveLength(2000);
    expect(calls).toBe(3);
  });
});
