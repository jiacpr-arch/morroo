import { describe, expect, it } from "vitest";
import { ctaTitle, rankCopy, weakSpecialtiesFromLocal, weakestPoint } from "./debrief-summary";
import type { TimelineItem } from "./types";
import type { LocalRun } from "./local-progress";

function run(overrides: Partial<LocalRun> = {}): LocalRun {
  return {
    slug: "vf-arrest-01",
    won: true,
    grade: "A",
    score: 85,
    specialty: null,
    difficulty: "normal",
    xp: 100,
    at: Date.now(),
    ...overrides,
  };
}

describe("weakestPoint", () => {
  it("returns null when nothing was wrong", () => {
    const timeline: TimelineItem[] = [{ t: 5, ok: true, text: "กด CPR" }];
    expect(weakestPoint(timeline)).toBeNull();
  });

  it("prefers the first wrong item that has a note (more useful than a bare miss)", () => {
    const timeline: TimelineItem[] = [
      { t: 5, ok: false, text: "สั่งยาเร็วไป" },
      { t: 12, ok: false, text: "ลืม defibrillate", note: "ควร shock ก่อนให้ epi" },
    ];
    const w = weakestPoint(timeline);
    expect(w?.text).toBe("ลืม defibrillate");
    expect(w?.note).toBe("ควร shock ก่อนให้ epi");
  });

  it("falls back to the first wrong item when none has a note", () => {
    const timeline: TimelineItem[] = [
      { t: 5, ok: false, text: "สั่งยาเร็วไป" },
      { t: 12, ok: false, text: "ลืม defibrillate" },
    ];
    expect(weakestPoint(timeline)?.text).toBe("สั่งยาเร็วไป");
  });

  it("counts the remaining errors, excluding the chosen one", () => {
    const timeline: TimelineItem[] = [
      { t: 1, ok: false, text: "a" },
      { t: 2, ok: false, text: "b" },
      { t: 3, ok: false, text: "c" },
    ];
    expect(weakestPoint(timeline)?.moreErrors).toBe(2);
  });
});

describe("weakSpecialtiesFromLocal", () => {
  it("returns specialties lost and never won, from guest local history", () => {
    const history: LocalRun[] = [
      run({ specialty: "อายุรศาสตร์", won: false }),
      run({ specialty: "ศัลยศาสตร์", won: true }),
    ];
    expect(weakSpecialtiesFromLocal(history)).toEqual(["อายุรศาสตร์"]);
  });

  it("drops a specialty once it has been won at least once", () => {
    const history: LocalRun[] = [
      run({ specialty: "อายุรศาสตร์", won: false }),
      run({ specialty: "อายุรศาสตร์", won: true }),
    ];
    expect(weakSpecialtiesFromLocal(history)).toEqual([]);
  });
});

describe("rankCopy", () => {
  it("returns null when there is no sample at all", () => {
    expect(rankCopy({ won: true, scope: null, sample: 0, below: 0, tie: 0 })).toBeNull();
  });

  it("phrases a win with a reliable slug-scope sample as a beat-percentage", () => {
    const copy = rankCopy({ won: true, scope: "slug", sample: 120, below: 90, tie: 10 });
    expect(copy).toContain("75%");
    expect(copy).toContain("เคสนี้");
  });

  it("phrases a win with a category-scope sample using the category wording", () => {
    const copy = rankCopy({ won: true, scope: "category", sample: 200, below: 100, tie: 0 });
    expect(copy).toContain("หมวดนี้");
  });

  it("never says 'beat 0%' on a loss — reframes as shared failure instead", () => {
    const copy = rankCopy({ won: false, scope: "slug", sample: 40, below: 0, tie: 8 });
    expect(copy).not.toContain("ดีกว่า 0%");
    expect(copy).toContain("ยังไม่ผ่านเหมือนกัน");
  });

  it("falls back to an ordinal when the sample is too thin for a percentage", () => {
    const copy = rankCopy({ won: true, scope: null, sample: 4, below: 3, tie: 0 });
    expect(copy).toContain("คนที่ 5");
  });
});

describe("ctaTitle", () => {
  it("names the rank and case count when both are known (repeat guest)", () => {
    const title = ctaTitle({ localRuns: 5, rankTitle: "นักศึกษาแพทย์ชั้นปีที่ 4" });
    expect(title).toContain("นักศึกษาแพทย์ชั้นปีที่ 4");
    expect(title).toContain("5 เคส");
  });

  it("falls back to a generic honest title for a first-time guest", () => {
    const title = ctaTitle({ localRuns: 1, rankTitle: null });
    expect(title).toBe("สมัครฟรี — เก็บผลเคสนี้ไว้ในบัญชีของคุณ");
  });
});
