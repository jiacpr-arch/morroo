import { describe, it, expect } from "vitest";
import {
  toBoardMetrics,
  buildBoardMetricsMap,
  sumBoardMetrics,
  EMPTY_BOARD_METRICS,
  type BoardMetricRow,
} from "./types-board";

describe("toBoardMetrics", () => {
  it("derives pending and projected totals from counts", () => {
    const m = toBoardMetrics({
      active_count: 120,
      review_count: 30,
      generating_count: 50,
    });
    expect(m).toEqual({
      active: 120,
      review: 30,
      generating: 50,
      pending: 80, // review + generating
      projectedTotal: 200, // active + pending
    });
  });

  it("coerces Postgres bigint strings to numbers", () => {
    const m = toBoardMetrics({
      active_count: "12",
      review_count: "3",
      generating_count: "0",
    });
    expect(m.active).toBe(12);
    expect(m.pending).toBe(3);
    expect(m.projectedTotal).toBe(15);
  });

  it("treats null/garbage as zero", () => {
    const m = toBoardMetrics({
      active_count: null as unknown as number,
      review_count: undefined as unknown as number,
      generating_count: "oops",
    });
    expect(m).toEqual(EMPTY_BOARD_METRICS);
  });
});

describe("buildBoardMetricsMap", () => {
  it("keys metrics by specialty slug", () => {
    const rows: BoardMetricRow[] = [
      { specialty_slug: "emergency_medicine", active_count: 100, review_count: 0, generating_count: 20 },
      { specialty_slug: "pediatrics", active_count: 5, review_count: 5, generating_count: 0 },
    ];
    const map = buildBoardMetricsMap(rows);
    expect(map.emergency_medicine.active).toBe(100);
    expect(map.emergency_medicine.pending).toBe(20);
    expect(map.pediatrics.projectedTotal).toBe(10);
    expect(Object.keys(map)).toHaveLength(2);
  });

  it("returns an empty map for no rows", () => {
    expect(buildBoardMetricsMap([])).toEqual({});
  });
});

describe("sumBoardMetrics", () => {
  it("rolls every specialty up into one platform-wide total", () => {
    const map = buildBoardMetricsMap([
      { specialty_slug: "a", active_count: 100, review_count: 10, generating_count: 5 },
      { specialty_slug: "b", active_count: 200, review_count: 0, generating_count: 25 },
    ]);
    const total = sumBoardMetrics(map);
    expect(total.active).toBe(300);
    expect(total.review).toBe(10);
    expect(total.generating).toBe(30);
    expect(total.pending).toBe(40);
    expect(total.projectedTotal).toBe(340);
  });

  it("returns zeros for an empty map", () => {
    expect(sumBoardMetrics({})).toEqual(EMPTY_BOARD_METRICS);
  });
});
