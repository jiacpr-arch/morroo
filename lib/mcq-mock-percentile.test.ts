import { describe, expect, it } from "vitest";
import {
  mockRankCohortLabel,
  mockRankHeadline,
  mockShareText,
  pickMockRank,
  type MockPercentileRow,
} from "./mcq-mock-percentile";

describe("pickMockRank", () => {
  it("prefers the same-size cohort when its sample meets the floor", () => {
    const rows: MockPercentileRow[] = [
      { scope: "size", sample: 40, below: 30, tie: 2 },
      { scope: "track", sample: 400, below: 100, tie: 10 },
    ];
    expect(pickMockRank(rows)).toEqual({ status: "ranked", scope: "size", sample: 40, percentile: 75 });
  });

  it("falls back to the whole track when the same-size sample is thin", () => {
    const rows: MockPercentileRow[] = [
      { scope: "size", sample: 4, below: null, tie: null },
      { scope: "track", sample: 25, below: 5, tie: 1 },
    ];
    expect(pickMockRank(rows)).toEqual({ status: "ranked", scope: "track", sample: 25, percentile: 20 });
  });

  it("reports insufficient with the largest sample when neither scope qualifies", () => {
    const rows: MockPercentileRow[] = [
      { scope: "size", sample: 3, below: null, tie: null },
      { scope: "track", sample: 7, below: null, tie: null },
    ];
    expect(pickMockRank(rows)).toEqual({ status: "insufficient", sample: 7 });
  });

  it("treats empty / missing data as insufficient with zero sample", () => {
    expect(pickMockRank([])).toEqual({ status: "insufficient", sample: 0 });
    expect(pickMockRank(null)).toEqual({ status: "insufficient", sample: 0 });
  });

  it("does not rank a scope whose below was withheld even if sample looks large", () => {
    const rows: MockPercentileRow[] = [{ scope: "size", sample: 50, below: null, tie: null }];
    expect(pickMockRank(rows)).toEqual({ status: "insufficient", sample: 50 });
  });

  it("floors so ties never round up to 100%", () => {
    const rows: MockPercentileRow[] = [{ scope: "size", sample: 200, below: 199, tie: 1 }];
    expect(pickMockRank(rows)).toMatchObject({ percentile: 99 });
  });

  it("gives 0% when nobody scored lower and 100% when everyone did", () => {
    expect(pickMockRank([{ scope: "size", sample: 10, below: 0, tie: 3 }])).toMatchObject({ percentile: 0 });
    expect(pickMockRank([{ scope: "size", sample: 10, below: 10, tie: 0 }])).toMatchObject({ percentile: 100 });
  });

  it("clamps a corrupt below > sample", () => {
    expect(pickMockRank([{ scope: "size", sample: 10, below: 12, tie: 0 }])).toMatchObject({ percentile: 100 });
  });

  it("honours a custom minSample", () => {
    const rows: MockPercentileRow[] = [{ scope: "size", sample: 5, below: 2, tie: 0 }];
    expect(pickMockRank(rows, { minSample: 5 })).toMatchObject({ status: "ranked", percentile: 40 });
  });
});

describe("mock rank copy", () => {
  it("renders the headline for ranked and small-sample cases", () => {
    expect(mockRankHeadline({ status: "ranked", scope: "size", sample: 20, percentile: 63 })).toBe(
      "คุณทำคะแนนได้ดีกว่า 63% ของผู้ที่ทำชุดนี้",
    );
    expect(mockRankHeadline({ status: "insufficient", sample: 4 })).toContain("อีก 4 คน");
    expect(mockRankHeadline({ status: "insufficient", sample: 0 })).toContain("กลุ่มแรก");
  });

  it("labels the cohort by scope", () => {
    const opts = { label: "Mock NL", totalQuestions: 50 };
    expect(mockRankCohortLabel({ status: "ranked", scope: "size", sample: 12, percentile: 50 }, opts)).toContain(
      "Mock NL 50 ข้อ 12 คน",
    );
    expect(mockRankCohortLabel({ status: "ranked", scope: "track", sample: 12, percentile: 50 }, opts)).toContain(
      "ทุกจำนวนข้อ",
    );
    expect(mockRankCohortLabel({ status: "insufficient", sample: 3 }, opts)).toBeNull();
  });

  it("builds share text with and without a rank", () => {
    const base = { label: "Mock NL", correct: 35, total: 50, url: "https://www.morroo.com/nl/mock" };
    const ranked = mockShareText({ ...base, rank: { status: "ranked", scope: "size", sample: 30, percentile: 81 } });
    expect(ranked).toContain("35/50 (70%)");
    expect(ranked).toContain("ดีกว่า 81%");
    expect(ranked).toContain("https://www.morroo.com/nl/mock");
    expect(mockShareText({ ...base, rank: null })).not.toContain("ดีกว่า");
  });
});
