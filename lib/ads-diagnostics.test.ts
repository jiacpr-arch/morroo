import { describe, it, expect } from "vitest";
import {
  diagnoseAds,
  diagnosePages,
  THRESHOLDS,
  type AdInsight,
  type PageStats,
} from "./ads-diagnostics";

function makePage(overrides: Partial<PageStats>): PageStats {
  return {
    path: "/lp/test",
    sessions: 300,
    pageViews: 350,
    singleEventSessions: 60,
    signups: 5,
    examStarts: 10,
    checkouts: 2,
    lineClicks: 4,
    ...overrides,
  };
}

function makeAd(overrides: Partial<AdInsight>): AdInsight {
  return {
    ad_id: "100",
    ad_name: "Test Ad",
    adset_id: "200",
    adset_name: "Set",
    campaign_id: "300",
    campaign_name: "Campaign",
    status: "ACTIVE",
    effective_status: "ACTIVE",
    impressions: 5000,
    clicks: 50,
    spend: 400,
    leads: 5,
    ctr: 1.0,
    cpl: 80,
    frequency: 2.0,
    ...overrides,
  };
}

describe("diagnosePages", () => {
  it("skips pages below the minimum session threshold", () => {
    const f = diagnosePages([
      makePage({ sessions: THRESHOLDS.pageMinSessions - 1, signups: 0 }),
    ]);
    expect(f).toHaveLength(0);
  });

  it("flags page_no_conversion when zero conversions despite traffic", () => {
    const f = diagnosePages([
      makePage({
        sessions: THRESHOLDS.pageNoConversionMinSessions + 50,
        signups: 0,
        checkouts: 0,
      }),
    ]);
    expect(f).toHaveLength(1);
    expect(f[0].category).toBe("page_no_conversion");
    expect(f[0].severity).toBe("critical");
  });

  it("flags page_low_signup but not page_no_conversion when there's some signal", () => {
    const f = diagnosePages([
      makePage({ sessions: 500, signups: 1, checkouts: 0 }),
    ]);
    expect(f.some((x) => x.category === "page_low_signup")).toBe(true);
    expect(f.some((x) => x.category === "page_no_conversion")).toBe(false);
  });

  it("flags page_low_line_cta when a trafficked page gets zero LINE clicks", () => {
    const f = diagnosePages([
      makePage({
        sessions: THRESHOLDS.pageLineCtaMinSessions + 50,
        lineClicks: 0,
      }),
    ]);
    expect(f.some((x) => x.category === "page_low_line_cta")).toBe(true);
  });

  it("does not flag page_low_line_cta when LINE clicks exist", () => {
    const f = diagnosePages([
      makePage({ sessions: THRESHOLDS.pageLineCtaMinSessions + 50, lineClicks: 3 }),
    ]);
    expect(f.some((x) => x.category === "page_low_line_cta")).toBe(false);
  });

  it("flags page_low_checkout when there are signups but zero checkouts", () => {
    const f = diagnosePages([
      makePage({ sessions: 300, signups: 4, checkouts: 0 }),
    ]);
    expect(f.some((x) => x.category === "page_low_checkout")).toBe(true);
  });

  it("does not flag page_low_checkout when checkouts exist", () => {
    const f = diagnosePages([
      makePage({ sessions: 300, signups: 4, checkouts: 2 }),
    ]);
    expect(f.some((x) => x.category === "page_low_checkout")).toBe(false);
  });

  it("does not flag page_low_line_cta on a zero-conversion page (short-circuits)", () => {
    // page_no_conversion fires and continues, so we don't double-report.
    const f = diagnosePages([
      makePage({
        sessions: THRESHOLDS.pageNoConversionMinSessions + 50,
        signups: 0,
        checkouts: 0,
        lineClicks: 0,
      }),
    ]);
    expect(f).toHaveLength(1);
    expect(f[0].category).toBe("page_no_conversion");
  });
});

describe("diagnoseAds", () => {
  it("ignores ads still under the min spend (learning phase)", () => {
    const f = diagnoseAds([
      makeAd({ spend: THRESHOLDS.adMinSpendThb - 1, leads: 0, ctr: 0.1 }),
    ]);
    expect(f).toHaveLength(0);
  });

  it("auto-pauses ads with high spend and zero leads", () => {
    const f = diagnoseAds([
      makeAd({
        spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
        leads: 0,
        cpl: null,
      }),
    ]);
    expect(f).toHaveLength(1);
    expect(f[0].category).toBe("ad_no_lead_high_spend");
    expect(f[0].autoAction?.action).toBe("pause_ad");
  });

  it("does not auto-act on ads that are already paused", () => {
    const f = diagnoseAds([
      makeAd({
        spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
        leads: 0,
        cpl: null,
        status: "PAUSED",
        effective_status: "PAUSED",
      }),
    ]);
    expect(f).toHaveLength(1);
    expect(f[0].autoAction).toBeUndefined();
  });

  it("does not auto-pause a traffic-objective ad with zero leads", () => {
    const f = diagnoseAds([
      makeAd({
        spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
        leads: 0,
        cpl: null,
        objective: "OUTCOME_TRAFFIC",
        impressions: 5000,
        ctr: 1.0,
      }),
    ]);
    expect(f.some((x) => x.category === "ad_no_lead_high_spend")).toBe(false);
  });

  it("still auto-pauses a lead-objective ad with zero leads", () => {
    const f = diagnoseAds([
      makeAd({
        spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
        leads: 0,
        cpl: null,
        objective: "OUTCOME_LEADS",
      }),
    ]);
    const finding = f.find((x) => x.category === "ad_no_lead_high_spend");
    expect(finding?.autoAction?.action).toBe("pause_ad");
  });

  it("auto-pauses ad with CPL above ceiling", () => {
    const f = diagnoseAds([
      makeAd({ spend: 1000, leads: 1, cpl: THRESHOLDS.adHighCplThb + 50 }),
    ]);
    expect(f.find((x) => x.category === "ad_high_cpl")).toBeDefined();
    expect(f[0].autoAction?.action).toBe("pause_ad");
  });

  it("warns (not auto-pause) on low-CTR ad with moderate impressions", () => {
    const f = diagnoseAds([
      makeAd({
        impressions: THRESHOLDS.adLowCtrMinImpressions + 100,
        ctr: THRESHOLDS.adLowCtrPct - 0.1,
        spend: 200,
        leads: 1,
        cpl: 200,
      }),
    ]);
    const lowCtr = f.find((x) => x.category === "ad_low_ctr");
    expect(lowCtr).toBeDefined();
    expect(lowCtr?.severity).toBe("warn");
    expect(lowCtr?.autoAction).toBeUndefined();
  });

  it("auto-pauses very low-CTR ad with high impressions", () => {
    const f = diagnoseAds([
      makeAd({
        impressions: THRESHOLDS.adAutoPauseMinImpressions + 100,
        ctr: THRESHOLDS.adAutoPauseCtrPct - 0.05,
        spend: 200,
        leads: 1,
        cpl: 200,
      }),
    ]);
    const lowCtr = f.find((x) => x.category === "ad_low_ctr");
    expect(lowCtr?.severity).toBe("critical");
    expect(lowCtr?.autoAction?.action).toBe("pause_ad");
  });

  it("flags high frequency as warn without auto-action", () => {
    const f = diagnoseAds([
      makeAd({ frequency: THRESHOLDS.adHighFrequency + 0.5 }),
    ]);
    const fatigue = f.find((x) => x.category === "ad_high_frequency");
    expect(fatigue?.severity).toBe("warn");
    expect(fatigue?.autoAction).toBeUndefined();
  });
});
