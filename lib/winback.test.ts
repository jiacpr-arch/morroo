import { describe, it, expect } from "vitest";
import {
  LAPSE_REASONS,
  canIssueWinback,
  computeTrialConversion,
  isLapseEligible,
  isLapseReason,
  parseLapseSource,
  sanitizeReasonDetail,
  selectWinbackOffer,
  summarizeFeedback,
  winbackPlanFor,
  WINBACK_COOLDOWN_DAYS,
} from "./winback";

const NOW = new Date("2026-09-25T00:00:00Z");
const DAY = 86_400_000;
const daysAgo = (n: number) => new Date(NOW.getTime() - n * DAY).toISOString();

describe("selectWinbackOffer", () => {
  const paid = { wasTrial: false, lastPlan: "monthly" };
  const trial = { wasTrial: true, lastPlan: "monthly" };

  it("gives every reason an offer", () => {
    for (const r of LAPSE_REASONS) {
      expect(selectWinbackOffer(r, paid).headline).toBeTruthy();
    }
  });

  it("offers the biggest discount for price objections, smaller for trial users", () => {
    const p = selectWinbackOffer("too_expensive", paid);
    const t = selectWinbackOffer("too_expensive", trial);
    expect(p).toMatchObject({ kind: "discount", percent: 30, validDays: 7 });
    expect(t).toMatchObject({ kind: "discount", percent: 20 });
  });

  it("keeps a long-lived coupon for exam_done (pause until next exam)", () => {
    const o = selectWinbackOffer("exam_done", paid);
    expect(o.kind).toBe("discount");
    if (o.kind === "discount") expect(o.validDays).toBeGreaterThanOrEqual(90);
  });

  it("doesn't throw a discount at a content mismatch", () => {
    const o = selectWinbackOffer("content_mismatch", paid);
    expect(o.kind).toBe("none");
    if (o.kind === "none") expect(o.ctaHref).toBe("/pricing");
  });

  it("restricts the coupon to the plan being renewed", () => {
    const o = selectWinbackOffer("other", { wasTrial: false, lastPlan: "board_yearly" });
    expect(o).toMatchObject({ kind: "discount", plan: "board_yearly" });
  });

  it("no percent is outside 1–100", () => {
    for (const r of LAPSE_REASONS) {
      for (const ctx of [paid, trial]) {
        const o = selectWinbackOffer(r, ctx);
        if (o.kind === "discount") {
          expect(o.percent).toBeGreaterThan(0);
          expect(o.percent).toBeLessThanOrEqual(100);
        }
      }
    }
  });
});

describe("winbackPlanFor", () => {
  it("keeps renewable plans", () => {
    expect(winbackPlanFor("yearly")).toBe("yearly");
    expect(winbackPlanFor("mcq_monthly")).toBe("mcq_monthly");
  });
  it("falls back to monthly for lifetime / unknown / empty", () => {
    expect(winbackPlanFor("bundle")).toBe("monthly");
    expect(winbackPlanFor("free")).toBe("monthly");
    expect(winbackPlanFor("item:mcq_subject:x")).toBe("monthly");
    expect(winbackPlanFor(null)).toBe("monthly");
  });
});

describe("input parsing", () => {
  it("validates reasons", () => {
    expect(isLapseReason("too_expensive")).toBe(true);
    expect(isLapseReason("nope")).toBe(false);
    expect(isLapseReason(3)).toBe(false);
  });
  it("defaults unknown sources to direct", () => {
    expect(parseLapseSource("profile")).toBe("profile");
    expect(parseLapseSource("evil")).toBe("direct");
    expect(parseLapseSource(undefined)).toBe("direct");
  });
  it("trims and caps free text", () => {
    expect(sanitizeReasonDetail("  ")).toBeNull();
    expect(sanitizeReasonDetail(42)).toBeNull();
    expect(sanitizeReasonDetail(" ok ")).toBe("ok");
    expect(sanitizeReasonDetail("x".repeat(5000))).toHaveLength(1000);
  });
});

describe("canIssueWinback", () => {
  it("allows the first offer", () => {
    expect(canIssueWinback(null, NOW)).toBe(true);
  });
  it("blocks a second coupon inside the cooldown", () => {
    expect(canIssueWinback(daysAgo(3), NOW)).toBe(false);
  });
  it("allows again after the cooldown", () => {
    expect(canIssueWinback(daysAgo(WINBACK_COOLDOWN_DAYS), NOW)).toBe(true);
  });
});

describe("isLapseEligible", () => {
  it("needs a time-limited plan", () => {
    expect(isLapseEligible("free", daysAgo(1), NOW)).toBe(false);
    expect(isLapseEligible("bundle", daysAgo(1), NOW)).toBe(false);
    expect(isLapseEligible(null, daysAgo(1), NOW)).toBe(false);
  });
  it("is open once expired or within the last 3 days", () => {
    expect(isLapseEligible("monthly", daysAgo(30), NOW)).toBe(true);
    expect(isLapseEligible("monthly", daysAgo(-3), NOW)).toBe(true);
  });
  it("is closed for a plan with months left", () => {
    expect(isLapseEligible("yearly", daysAgo(-200), NOW)).toBe(false);
  });
});

describe("summarizeFeedback", () => {
  it("breaks down reasons and offer acceptance", () => {
    const s = summarizeFeedback([
      { reason: "too_expensive", offer_kind: "discount", offer_response: "accepted", was_trial: true, source: "profile", redeemed: true },
      { reason: "too_expensive", offer_kind: "discount", offer_response: "declined", was_trial: false, source: "expiry_line" },
      { reason: "content_mismatch", offer_kind: "none", offer_response: null, was_trial: false, source: "profile" },
      { reason: "weird", offer_kind: "discount", offer_response: null, was_trial: null, source: null },
    ]);
    expect(s.total).toBe(4);
    expect(s.reasons[0]).toMatchObject({ reason: "too_expensive", count: 2, pct: 50 });
    expect(s.reasons.find((r) => r.reason === "other")?.count).toBe(1);
    expect(s.offersShown).toBe(3);
    expect(s.offersAccepted).toBe(1);
    expect(s.offersRedeemed).toBe(1);
    expect(s.acceptanceRate).toBe(33.3);
    expect(s.trialShare).toBe(25);
    expect(s.bySource).toEqual({ profile: 2, expiry_line: 1, direct: 1 });
  });

  it("handles no data", () => {
    const s = summarizeFeedback([]);
    expect(s.total).toBe(0);
    expect(s.acceptanceRate).toBe(0);
  });
});

describe("computeTrialConversion", () => {
  it("counts ended trials and first payment after start", () => {
    const r = computeTrialConversion(
      [
        { userId: "a", startedAt: daysAgo(20) }, // paid day 5 → early
        { userId: "b", startedAt: daysAgo(40) }, // paid day 30 → late
        { userId: "c", startedAt: daysAgo(15) }, // never paid
        { userId: "d", startedAt: daysAgo(2) }, // still running
        { userId: "e", startedAt: daysAgo(3) }, // running but already paid
      ],
      [
        { userId: "a", paidAt: daysAgo(15) },
        { userId: "b", paidAt: daysAgo(10) },
        { userId: "b", paidAt: daysAgo(60) }, // before trial — ignored
        { userId: "e", paidAt: daysAgo(1) },
      ],
      7,
      NOW
    );
    expect(r.started).toBe(5);
    expect(r.running).toBe(1);
    expect(r.ended).toBe(4);
    expect(r.converted).toBe(3);
    expect(r.convertedEarly).toBe(2);
    expect(r.rate).toBe(75);
    expect(r.medianDaysToPay).toBe(5);
  });

  it("dedupes a user with multiple trial rows", () => {
    const r = computeTrialConversion(
      [
        { userId: "a", startedAt: daysAgo(30) },
        { userId: "a", startedAt: daysAgo(20) },
      ],
      [],
      7,
      NOW
    );
    expect(r.started).toBe(1);
    expect(r.rate).toBe(0);
    expect(r.medianDaysToPay).toBeNull();
  });
});
