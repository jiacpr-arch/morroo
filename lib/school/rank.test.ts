import { describe, it, expect } from "vitest";
import {
  DOCTOR_RANKS,
  MAX_RANK_TIER,
  didRankUp,
  fullTitle,
  xpToRank,
} from "./rank";

describe("DOCTOR_RANKS", () => {
  it("starts at 0 XP so a brand-new player always has a rank", () => {
    expect(DOCTOR_RANKS[0].minXp).toBe(0);
  });

  it("has strictly increasing thresholds and tiers", () => {
    for (let i = 1; i < DOCTOR_RANKS.length; i++) {
      expect(DOCTOR_RANKS[i].minXp).toBeGreaterThan(DOCTOR_RANKS[i - 1].minXp);
      expect(DOCTOR_RANKS[i].tier).toBe(DOCTOR_RANKS[i - 1].tier + 1);
    }
  });

  it("runs from med student to professor", () => {
    expect(DOCTOR_RANKS[0].title).toContain("นักศึกษาแพทย์");
    expect(DOCTOR_RANKS[DOCTOR_RANKS.length - 1].title).toBe("ศาสตราจารย์");
  });
});

describe("xpToRank", () => {
  it("puts a new player at the first rank", () => {
    const { rank, next, progress } = xpToRank(0);
    expect(rank.tier).toBe(1);
    expect(next?.tier).toBe(2);
    expect(progress).toBe(0);
  });

  it("clamps negative and non-finite XP to the first rank", () => {
    expect(xpToRank(-500).rank.tier).toBe(1);
    expect(xpToRank(Number.NaN).rank.tier).toBe(1);
    expect(xpToRank(Number.POSITIVE_INFINITY).rank.tier).toBe(1);
  });

  it("promotes exactly at the threshold, not one XP early", () => {
    const second = DOCTOR_RANKS[1];
    expect(xpToRank(second.minXp - 1).rank.tier).toBe(1);
    expect(xpToRank(second.minXp).rank.tier).toBe(2);
  });

  it("reports progress within the current rank", () => {
    const first = DOCTOR_RANKS[0];
    const second = DOCTOR_RANKS[1];
    const halfway = Math.round((first.minXp + second.minXp) / 2);
    const p = xpToRank(halfway);
    expect(p.rank.tier).toBe(1);
    expect(p.xpForNext).toBe(second.minXp - first.minXp);
    expect(p.progress).toBeGreaterThan(40);
    expect(p.progress).toBeLessThan(60);
  });

  it("caps at the top rank with no next step", () => {
    const top = DOCTOR_RANKS[DOCTOR_RANKS.length - 1];
    const p = xpToRank(top.minXp * 10);
    expect(p.rank.tier).toBe(MAX_RANK_TIER);
    expect(p.next).toBeNull();
    expect(p.progress).toBe(100);
    expect(p.xpForNext).toBe(0);
  });

  it("never reports progress above 100", () => {
    for (const rank of DOCTOR_RANKS) {
      expect(xpToRank(rank.minXp).progress).toBeLessThanOrEqual(100);
    }
  });
});

describe("didRankUp", () => {
  it("is true only when the tier actually changes", () => {
    const second = DOCTOR_RANKS[1];
    expect(didRankUp(second.minXp - 10, second.minXp)).toBe(true);
    expect(didRankUp(second.minXp, second.minXp + 10)).toBe(false);
    expect(didRankUp(0, 0)).toBe(false);
  });
});

describe("fullTitle", () => {
  it("returns the bare rank when no specialty is mastered", () => {
    expect(fullTitle(0)).toBe(DOCTOR_RANKS[0].title);
    expect(fullTitle(0, null)).toBe(DOCTOR_RANKS[0].title);
  });

  it("reads as a natural Thai title once a specialty is mastered", () => {
    const top = DOCTOR_RANKS[DOCTOR_RANKS.length - 1];
    expect(fullTitle(top.minXp, "อายุรศาสตร์")).toBe("ศาสตราจารย์ผู้เชี่ยวชาญอายุรศาสตร์");
  });
});
