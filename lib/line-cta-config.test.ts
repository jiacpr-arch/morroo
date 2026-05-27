import { describe, it, expect } from "vitest";
import {
  decideLineCtaLevel,
  LINE_CTA_AUTOPILOT,
  type LineCtaLevel,
} from "./line-cta-config";

function snap(visitors: number, lineClicks: number) {
  return { visitors, lineClicks };
}

describe("decideLineCtaLevel", () => {
  it("holds when there isn't enough traffic to trust the signal", () => {
    const d = decideLineCtaLevel(
      snap(LINE_CTA_AUTOPILOT.minVisitors - 1, 0),
      1 as LineCtaLevel
    );
    expect(d.changed).toBe(false);
    expect(d.level).toBe(1);
  });

  it("boosts to level 2 when click-through is low at level 1", () => {
    const d = decideLineCtaLevel(snap(100, 0), 1);
    expect(d.changed).toBe(true);
    expect(d.level).toBe(2);
  });

  it("does not boost past level 2 (idempotent when already boosted)", () => {
    const d = decideLineCtaLevel(snap(100, 0), 2);
    expect(d.changed).toBe(false);
    expect(d.level).toBe(2);
  });

  it("de-escalates to level 1 once click-through recovers", () => {
    // 5 clicks / 100 visitors = 5% >= recoverCtrPct
    const d = decideLineCtaLevel(snap(100, 5), 2);
    expect(d.changed).toBe(true);
    expect(d.level).toBe(1);
  });

  it("holds at level 2 while click-through is in the in-between band", () => {
    // 2% — above lowCtr, below recoverCtr: no flip-flopping
    const d = decideLineCtaLevel(snap(100, 2), 2);
    expect(d.changed).toBe(false);
    expect(d.level).toBe(2);
  });

  it("holds at level 1 in the in-between band too", () => {
    const d = decideLineCtaLevel(snap(100, 2), 1);
    expect(d.changed).toBe(false);
    expect(d.level).toBe(1);
  });
});
