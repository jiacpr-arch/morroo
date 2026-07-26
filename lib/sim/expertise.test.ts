import { describe, it, expect } from "vitest";
import {
  EXPERTISE_TIERS,
  EXPERT_LEVEL,
  expertSpecialty,
  expertiseFor,
  summarizeExpertise,
  type ExpertiseRun,
} from "./expertise";

function wins(specialty: string, n: number): ExpertiseRun[] {
  return Array.from({ length: n }, () => ({ specialty, won: true }));
}

describe("EXPERTISE_TIERS", () => {
  it("has increasing thresholds starting at zero", () => {
    expect(EXPERTISE_TIERS[0].minWins).toBe(0);
    for (let i = 1; i < EXPERTISE_TIERS.length; i++) {
      expect(EXPERTISE_TIERS[i].minWins).toBeGreaterThan(EXPERTISE_TIERS[i - 1].minWins);
      expect(EXPERTISE_TIERS[i].level).toBe(EXPERTISE_TIERS[i - 1].level + 1);
    }
  });
});

describe("expertiseFor", () => {
  it("starts everyone at level 0", () => {
    expect(expertiseFor(0).level).toBe(0);
  });

  it("clamps negative and non-finite win counts", () => {
    expect(expertiseFor(-3).level).toBe(0);
    expect(expertiseFor(Number.NaN).level).toBe(0);
  });

  it("promotes exactly at each threshold", () => {
    for (const tier of EXPERTISE_TIERS) {
      expect(expertiseFor(tier.minWins).level).toBe(tier.level);
      if (tier.minWins > 0) {
        expect(expertiseFor(tier.minWins - 1).level).toBe(tier.level - 1);
      }
    }
  });

  it("stays at the top tier beyond the last threshold", () => {
    const top = EXPERTISE_TIERS[EXPERTISE_TIERS.length - 1];
    expect(expertiseFor(top.minWins + 100).level).toBe(top.level);
  });
});

describe("summarizeExpertise", () => {
  it("counts wins and plays per specialty", () => {
    const out = summarizeExpertise([
      { specialty: "อายุรศาสตร์", won: true },
      { specialty: "อายุรศาสตร์", won: false },
      { specialty: "ศัลยศาสตร์", won: true },
    ]);
    const medicine = out.find((s) => s.specialty === "อายุรศาสตร์");
    expect(medicine).toMatchObject({ wins: 1, played: 2 });
    expect(out.find((s) => s.specialty === "ศัลยศาสตร์")).toMatchObject({ wins: 1, played: 1 });
  });

  it("skips runs with no specialty instead of bucketing them together", () => {
    const out = summarizeExpertise([
      { specialty: null, won: true },
      { specialty: "   ", won: true },
      { specialty: "กุมารเวชศาสตร์", won: true },
    ]);
    expect(out).toHaveLength(1);
    expect(out[0].specialty).toBe("กุมารเวชศาสตร์");
  });

  it("sorts strongest specialty first", () => {
    const out = summarizeExpertise([...wins("ศัลยศาสตร์", 2), ...wins("อายุรศาสตร์", 5)]);
    expect(out.map((s) => s.specialty)).toEqual(["อายุรศาสตร์", "ศัลยศาสตร์"]);
  });

  it("reports how many more wins the next tier needs", () => {
    const [only] = summarizeExpertise(wins("ออร์โธปิดิกส์", 1));
    const nextTier = EXPERTISE_TIERS[only.tier.level + 1];
    expect(only.winsToNext).toBe(nextTier.minWins - 1);
  });

  it("reports null winsToNext once the top tier is reached", () => {
    const top = EXPERTISE_TIERS[EXPERTISE_TIERS.length - 1];
    const [only] = summarizeExpertise(wins("อายุรศาสตร์", top.minWins));
    expect(only.winsToNext).toBeNull();
  });

  it("returns an empty list for no runs", () => {
    expect(summarizeExpertise([])).toEqual([]);
  });
});

describe("expertSpecialty", () => {
  const expertTier = EXPERTISE_TIERS.find((t) => t.level === EXPERT_LEVEL)!;

  it("is null until a specialty reaches the expert tier", () => {
    expect(expertSpecialty(wins("อายุรศาสตร์", expertTier.minWins - 1))).toBeNull();
  });

  it("names the specialty once it reaches the expert tier", () => {
    expect(expertSpecialty(wins("อายุรศาสตร์", expertTier.minWins))).toBe("อายุรศาสตร์");
  });

  it("picks the strongest specialty when several qualify", () => {
    const runs = [
      ...wins("อายุรศาสตร์", expertTier.minWins),
      ...wins("ศัลยศาสตร์", expertTier.minWins + 5),
    ];
    expect(expertSpecialty(runs)).toBe("ศัลยศาสตร์");
  });

  it("ignores losses when deciding mastery", () => {
    const runs = [
      ...wins("อายุรศาสตร์", expertTier.minWins - 1),
      ...Array.from({ length: 20 }, () => ({ specialty: "อายุรศาสตร์", won: false })),
    ];
    expect(expertSpecialty(runs)).toBeNull();
  });
});
