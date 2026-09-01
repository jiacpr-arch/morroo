import { describe, it, expect } from "vitest";
import {
  preferredDifficulty,
  recommendNextCases,
  weakSpecialties,
  type CaseCandidate,
  type PlayedCase,
} from "./recommend";

function c(slug: string, specialty: string, difficulty: CaseCandidate["difficulty"]): CaseCandidate {
  return { slug, title: `เคส ${slug}`, specialty, difficulty };
}

const CATALOG: CaseCandidate[] = [
  c("med-easy", "อายุรศาสตร์", "ง่าย"),
  c("med-hard", "อายุรศาสตร์", "ยาก"),
  c("surg-mid", "ศัลยศาสตร์", "ปานกลาง"),
  c("peds-easy", "กุมารเวชศาสตร์", "ง่าย"),
  c("acls", "", "ปานกลาง"),
];

describe("weakSpecialties", () => {
  it("is empty with no history", () => {
    expect(weakSpecialties([]).size).toBe(0);
  });

  it("counts a specialty the player lost in", () => {
    const weak = weakSpecialties([{ slug: "a", specialty: "อายุรศาสตร์", won: false }]);
    expect([...weak]).toEqual(["อายุรศาสตร์"]);
  });

  it("clears a specialty once the player wins there", () => {
    const weak = weakSpecialties([
      { slug: "a", specialty: "อายุรศาสตร์", won: false },
      { slug: "b", specialty: "อายุรศาสตร์", won: true },
    ]);
    expect(weak.size).toBe(0);
  });

  it("ignores runs with no specialty instead of grouping them", () => {
    expect(weakSpecialties([{ slug: "a", specialty: null, won: false }]).size).toBe(0);
    expect(weakSpecialties([{ slug: "a", specialty: "  ", won: false }]).size).toBe(0);
  });
});

describe("preferredDifficulty", () => {
  it("steps down after a loss", () => {
    expect(preferredDifficulty(false)).toBe("ง่าย");
  });

  it("steps up only after a perfect win", () => {
    expect(preferredDifficulty(true, "S")).toBe("ยาก");
    expect(preferredDifficulty(true, "B")).toBeNull();
  });

  it("has no preference when the last result is unknown", () => {
    expect(preferredDifficulty(undefined)).toBeNull();
  });
});

describe("recommendNextCases", () => {
  it("never suggests the case just played", () => {
    const out = recommendNextCases(CATALOG, [], { excludeSlug: "med-easy", limit: 99 });
    expect(out.map((r) => r.slug)).not.toContain("med-easy");
  });

  it("puts another case from the weak specialty first and says why", () => {
    // แพ้ med-easy → เคสอายุรศาสตร์ที่เหลือ (med-hard) ควรมาเป็นอันดับแรก
    const history: PlayedCase[] = [{ slug: "med-easy", specialty: "อายุรศาสตร์", won: false }];
    const [top] = recommendNextCases(CATALOG, history, { excludeSlug: "med-easy" });
    expect(top.slug).toBe("med-hard");
    expect(top.reason).toContain("อายุรศาสตร์");
  });

  it("pushes already-won cases to the bottom", () => {
    const history: PlayedCase[] = [{ slug: "peds-easy", specialty: "กุมารเวชศาสตร์", won: true }];
    const out = recommendNextCases(CATALOG, history, { limit: 99 });
    expect(out[out.length - 1].slug).toBe("peds-easy");
  });

  it("still returns something when every case is already won", () => {
    const history: PlayedCase[] = CATALOG.map((x) => ({
      slug: x.slug,
      specialty: x.specialty || null,
      won: true,
    }));
    expect(recommendNextCases(CATALOG, history, { limit: 2 })).toHaveLength(2);
  });

  it("prefers an easier case right after a loss", () => {
    const out = recommendNextCases(CATALOG, [], { lastWon: false, limit: 1 });
    expect(out[0].difficulty).toBe("ง่าย");
  });

  it("prefers a harder case after a grade S win", () => {
    const out = recommendNextCases(CATALOG, [], { lastWon: true, lastGrade: "S", limit: 1 });
    expect(out[0].difficulty).toBe("ยาก");
  });

  it("offers a rematch on a case that was lost", () => {
    const history: PlayedCase[] = [{ slug: "med-hard", specialty: "อายุรศาสตร์", won: false }];
    const out = recommendNextCases(CATALOG, history, { limit: 99 });
    const medHard = out.find((r) => r.slug === "med-hard");
    expect(medHard?.reason).toContain("แก้มือ");
  });

  it("is deterministic — same input, same order", () => {
    const history: PlayedCase[] = [{ slug: "surg-mid", specialty: "ศัลยศาสตร์", won: false }];
    const a = recommendNextCases(CATALOG, history, { limit: 3 });
    const b = recommendNextCases(CATALOG, history, { limit: 3 });
    expect(a.map((r) => r.slug)).toEqual(b.map((r) => r.slug));
  });

  it("respects the limit and handles an empty catalog", () => {
    expect(recommendNextCases(CATALOG, [], { limit: 2 })).toHaveLength(2);
    expect(recommendNextCases([], [], { limit: 3 })).toEqual([]);
    expect(recommendNextCases(CATALOG, [], { limit: 0 })).toEqual([]);
  });

  it("gives every recommendation a non-empty reason", () => {
    const out = recommendNextCases(CATALOG, [], { limit: 99 });
    expect(out.every((r) => r.reason.length > 0)).toBe(true);
  });
});
