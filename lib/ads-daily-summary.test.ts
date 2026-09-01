import { describe, it, expect } from "vitest";
import { summarizeAdsDay } from "./ads-daily-summary";
import type { AdInsight } from "./ads-diagnostics";

function ad(overrides: Partial<AdInsight>): AdInsight {
  return {
    ad_id: "1",
    ad_name: "Ad",
    adset_id: "10",
    adset_name: "Adset",
    campaign_id: "100",
    campaign_name: "Campaign",
    status: "ACTIVE",
    effective_status: "ACTIVE",
    impressions: 0,
    clicks: 0,
    spend: 0,
    leads: 0,
    ctr: 0,
    cpl: null,
    frequency: 0,
    ...overrides,
  };
}

describe("summarizeAdsDay", () => {
  it("returns null when no rows", () => {
    expect(summarizeAdsDay([])).toBeNull();
  });

  it("returns null when nothing delivered (zero spend and impressions)", () => {
    expect(summarizeAdsDay([ad({}), ad({ ad_id: "2" })])).toBeNull();
  });

  it("aggregates spend, impressions and weighted CTR", () => {
    const summary = summarizeAdsDay([
      ad({ ad_id: "1", impressions: 1000, clicks: 10, spend: 100 }),
      ad({ ad_id: "2", impressions: 3000, clicks: 90, spend: 200 }),
    ]);
    expect(summary).not.toBeNull();
    expect(summary!.spendThb).toBe(300);
    expect(summary!.impressions).toBe(4000);
    // Weighted: 100 clicks / 4000 impressions = 2.5%
    expect(summary!.ctrPct).toBeCloseTo(2.5);
    expect(summary!.adsDelivered).toBe(2);
  });

  it("computes cost per signup and picks the top ad by signups", () => {
    const summary = summarizeAdsDay([
      ad({ ad_id: "1", ad_name: "A", impressions: 500, spend: 150, leads: 1, cpl: 150 }),
      ad({ ad_id: "2", ad_name: "B", impressions: 500, spend: 150, leads: 3, cpl: 50 }),
    ]);
    expect(summary!.signups).toBe(4);
    expect(summary!.costPerSignupThb).toBeCloseTo(75);
    expect(summary!.topAdName).toBe("B");
  });

  it("breaks signup ties by cheaper cost per signup", () => {
    const summary = summarizeAdsDay([
      ad({ ad_id: "1", ad_name: "expensive", impressions: 500, spend: 300, leads: 2, cpl: 150 }),
      ad({ ad_id: "2", ad_name: "cheap", impressions: 500, spend: 100, leads: 2, cpl: 50 }),
    ]);
    expect(summary!.topAdName).toBe("cheap");
  });

  it("omits top ad and cost per signup when there are no signups", () => {
    const summary = summarizeAdsDay([
      ad({ ad_id: "1", impressions: 2000, clicks: 20, spend: 250 }),
    ]);
    expect(summary!.signups).toBe(0);
    expect(summary!.costPerSignupThb).toBeNull();
    expect(summary!.topAdName).toBeNull();
  });

  it("ignores rows with no delivery when aggregating", () => {
    const summary = summarizeAdsDay([
      ad({ ad_id: "1", impressions: 1000, clicks: 10, spend: 100 }),
      ad({ ad_id: "2" }), // paused sibling, nothing delivered
    ]);
    expect(summary!.adsDelivered).toBe(1);
    expect(summary!.impressions).toBe(1000);
  });
});
