import { describe, it, expect } from "vitest";
import { decideHeroWinner, type HeroABStats } from "./site-config";

function hero(
  aViews: number,
  aConv: number,
  bViews: number,
  bConv: number
): HeroABStats {
  return {
    a: { views: aViews, converts: aConv, rate: aViews ? (aConv / aViews) * 100 : null },
    b: { views: bViews, converts: bConv, rate: bViews ? (bConv / bViews) * 100 : null },
  };
}

describe("decideHeroWinner", () => {
  it("holds when either variant has too few views (low-traffic guard)", () => {
    const d = decideHeroWinner(hero(5, 0, 8, 0), null);
    expect(d.changed).toBe(false);
    expect(d.forced).toBeNull();
  });

  it("holds when total conversions are too few even with enough views", () => {
    const d = decideHeroWinner(hero(200, 1, 200, 1), null);
    expect(d.changed).toBe(false);
  });

  it("holds when the margin between variants is too small", () => {
    // 5.5% vs 5.0% — below the 20% relative margin
    const d = decideHeroWinner(hero(200, 11, 200, 10), null);
    expect(d.changed).toBe(false);
  });

  it("locks in a clear winner once there's enough data and margin", () => {
    // A 10% vs B 4%
    const d = decideHeroWinner(hero(200, 20, 200, 8), null);
    expect(d.changed).toBe(true);
    expect(d.forced).toBe("A");
  });

  it("does not re-fire when already locked to the winner", () => {
    const d = decideHeroWinner(hero(200, 20, 200, 8), "A");
    expect(d.changed).toBe(false);
    expect(d.forced).toBe("A");
  });
});
