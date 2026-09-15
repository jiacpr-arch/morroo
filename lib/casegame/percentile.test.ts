import { describe, expect, it } from "vitest";
import { pickRankScope, type PercentileRow } from "./percentile";

describe("pickRankScope", () => {
  it("prefers the slug scope when its sample meets the floor", () => {
    const rows: PercentileRow[] = [
      { scope: "slug", sample: 30, below: 20, tie: 2 },
      { scope: "category", sample: 500, below: 300, tie: 10 },
    ];
    expect(pickRankScope(rows)).toEqual({ scope: "slug", sample: 30, below: 20, tie: 2 });
  });

  it("falls back to category when the slug sample is too thin", () => {
    const rows: PercentileRow[] = [
      { scope: "slug", sample: 4, below: 2, tie: 0 },
      { scope: "category", sample: 200, below: 150, tie: 5 },
    ];
    expect(pickRankScope(rows)).toEqual({ scope: "category", sample: 200, below: 150, tie: 5 });
  });

  it("returns a null scope but keeps the slug sample when neither meets the floor", () => {
    const rows: PercentileRow[] = [
      { scope: "slug", sample: 4, below: 2, tie: 0 },
      { scope: "category", sample: 10, below: 5, tie: 0 },
    ];
    expect(pickRankScope(rows)).toEqual({ scope: null, sample: 4, below: 2, tie: 0 });
  });

  it("handles a missing category row (no category passed to the RPC)", () => {
    const rows: PercentileRow[] = [{ scope: "slug", sample: 3, below: 1, tie: 0 }];
    expect(pickRankScope(rows).scope).toBeNull();
    expect(pickRankScope(rows).sample).toBe(3);
  });

  it("handles a completely empty result set", () => {
    expect(pickRankScope([])).toEqual({ scope: null, sample: 0, below: 0, tie: 0 });
  });

  it("respects a custom minSample", () => {
    const rows: PercentileRow[] = [{ scope: "slug", sample: 10, below: 5, tie: 0 }];
    expect(pickRankScope(rows, { minSample: 5 }).scope).toBe("slug");
    expect(pickRankScope(rows, { minSample: 20 }).scope).toBeNull();
  });
});
