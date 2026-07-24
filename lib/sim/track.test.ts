import { describe, expect, it } from "vitest";
import {
  buildCompleteProps,
  buildCtaClickProps,
  buildFirstDecisionProps,
  buildStartProps,
  capiContentName,
  capiEventId,
  caseGameCategory,
  durationSeconds,
} from "./track";
import { createInitialState } from "./engine";

describe("caseGameCategory", () => {
  it("maps longcase through and everything else to acls", () => {
    expect(caseGameCategory("longcase")).toBe("longcase");
    expect(caseGameCategory("acls")).toBe("acls");
    // built-in scenarios ไม่ระบุ category — ต้องไม่กลายเป็น undefined ใน payload
    expect(caseGameCategory(undefined)).toBe("acls");
    expect(caseGameCategory("something-else")).toBe("acls");
  });
});

describe("buildStartProps", () => {
  it("carries slug, category, difficulty and replay flag", () => {
    const props = buildStartProps({
      slug: "lc-123",
      category: "longcase",
      difficulty: "hard",
      isReplay: true,
      sourceCaseId: "case-abc",
    });
    expect(props).toEqual({
      slug: "lc-123",
      category: "longcase",
      difficulty: "hard",
      is_replay: true,
      source_case_id: "case-abc",
    });
  });

  it("normalises a missing sourceCaseId to null, never undefined", () => {
    const props = buildStartProps({
      slug: "vf-arrest-01",
      difficulty: "normal",
      isReplay: false,
    });
    expect(props.source_case_id).toBeNull();
    expect(props.category).toBe("acls");
    // undefined จะถูก JSON.stringify ตัดทิ้งเงียบๆ — prop ต้องมีอยู่จริง
    expect(Object.keys(props)).toContain("source_case_id");
  });
});

describe("buildFirstDecisionProps", () => {
  it("keeps the payload minimal", () => {
    expect(buildFirstDecisionProps({ slug: "a", category: "longcase" })).toEqual({
      slug: "a",
      category: "longcase",
    });
  });
});

describe("buildCompleteProps", () => {
  const state = { ...createInitialState("normal"), wrong: 2, simTime: 480 };

  it("reports both the sim clock and real elapsed time", () => {
    const props = buildCompleteProps({
      slug: "lc-9",
      category: "longcase",
      state,
      won: true,
      grade: "A",
      score: 820,
      isHiscore: true,
      durationMs: 95_400,
    });
    expect(props).toEqual({
      slug: "lc-9",
      category: "longcase",
      difficulty: "normal",
      won: true,
      grade: "A",
      score: 820,
      wrong: 2,
      sim_time: 480,
      duration_sec: 95,
      is_hiscore: true,
    });
  });

  it("emits only primitives so the analytics route accepts it", () => {
    const props = buildCompleteProps({
      slug: "lc-9",
      state,
      won: false,
      grade: "C",
      score: 0,
      isHiscore: false,
      durationMs: 1_000,
    });
    for (const value of Object.values(props)) {
      expect(["string", "number", "boolean"]).toContain(typeof value);
    }
  });
});

describe("durationSeconds", () => {
  it("rounds to the nearest second", () => {
    expect(durationSeconds(1_400)).toBe(1);
    expect(durationSeconds(1_600)).toBe(2);
  });

  it("clamps nonsense to zero rather than emitting a wild number", () => {
    expect(durationSeconds(0)).toBe(0);
    expect(durationSeconds(-5_000)).toBe(0);
    expect(durationSeconds(Number.NaN)).toBe(0);
    expect(durationSeconds(Number.POSITIVE_INFINITY)).toBe(0);
  });
});

describe("buildCtaClickProps", () => {
  it("allows a null grade for a click before any result exists", () => {
    expect(buildCtaClickProps({ slug: "a", grade: null, target: "lead_form" })).toEqual({
      slug: "a",
      category: "acls",
      grade: null,
      target: "lead_form",
    });
  });
});

describe("Meta CAPI helpers", () => {
  it("builds a content_name the Custom Conversion rule can prefix-match", () => {
    expect(capiContentName("start", "lc-1")).toBe("casegame_start:lc-1");
    expect(capiContentName("complete", "lc-1")).toBe("casegame_complete:lc-1");
    expect(capiContentName("start", "lc-1").startsWith("casegame_start")).toBe(true);
  });

  it("scopes the dedup id to one play-through", () => {
    expect(capiEventId("start", "run-1")).toBe("casegame:start:run-1");
    // คนละรอบเล่น = คนละ conversion; รอบเดียวกันยิงซ้ำ = ตัวเดียวกัน
    expect(capiEventId("start", "run-1")).not.toBe(capiEventId("start", "run-2"));
    expect(capiEventId("start", "run-1")).not.toBe(capiEventId("complete", "run-1"));
  });
});
