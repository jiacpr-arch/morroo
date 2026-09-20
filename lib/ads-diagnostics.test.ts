import { describe, it, expect } from "vitest";
import {
  aggregatePageStats,
  diagnoseAds,
  diagnosePages,
  paidSourceOf,
  reconcileFindings,
  THRESHOLDS,
  type AdInsight,
  type ExistingFindingRow,
  type Finding,
  type PageStats,
} from "./ads-diagnostics";

function makePage(overrides: Partial<PageStats>): PageStats {
  return {
    path: "/lp/test",
    sessions: 300,
    pageViews: 350,
    singleEventSessions: 60,
    shortSessions: 40,
    adSessions: 0,
    adShortSessions: 0,
    adTopSource: null,
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

describe("diagnosePages — ad landing mismatch", () => {
  it("flags ad_landing_mismatch (not page_no_conversion) when paid visitors bounce in seconds", () => {
    const f = diagnosePages([
      makePage({
        sessions: 800,
        adSessions: 778,
        adShortSessions: 663,
        adTopSource: "fb / 52588558588397",
        signups: 0,
        checkouts: 0,
      }),
    ]);
    expect(f).toHaveLength(1);
    expect(f[0].category).toBe("ad_landing_mismatch");
    expect(f[0].severity).toBe("critical");
    expect(f[0].entityLabel).toBe("fb / 52588558588397");
    expect(f[0].recommendation).toContain("ฝั่งโฆษณา");
  });

  it("does not flag ad_landing_mismatch when paid visitors stay", () => {
    const f = diagnosePages([
      makePage({ sessions: 800, adSessions: 743, adShortSessions: 299, signups: 3 }),
    ]);
    expect(f.some((x) => x.category === "ad_landing_mismatch")).toBe(false);
  });

  it("needs enough paid sessions before judging the ad", () => {
    const f = diagnosePages([
      makePage({
        sessions: 400,
        adSessions: THRESHOLDS.pageAdLandingMinSessions - 1,
        adShortSessions: THRESHOLDS.pageAdLandingMinSessions - 1,
        signups: 3,
      }),
    ]);
    expect(f.some((x) => x.category === "ad_landing_mismatch")).toBe(false);
  });
});

describe("paidSourceOf", () => {
  it("tags Meta ad landings by source + campaign", () => {
    expect(
      paidSourceOf("/?fbclid=abc&utm_medium=paid&utm_source=fb&utm_campaign=525")
    ).toBe("fb / 525");
  });
  it("treats a bare fbclid as a Facebook paid landing", () => {
    expect(paidSourceOf("/?fbclid=abc")).toBe("fb");
  });
  it("returns null for organic / direct", () => {
    expect(paidSourceOf("/")).toBeNull();
    expect(paidSourceOf("/?utm_source=line&utm_medium=social")).toBeNull();
  });
});

describe("aggregatePageStats — landing-session attribution", () => {
  const t = (s: number) => new Date(1_700_000_000_000 + s * 1000).toISOString();
  const rows = [
    // Session A lands on "/", goes to /register, signs up 40s later.
    { event_name: "pageview", session_id: "A", path: "/", properties: null, created_at: t(0) },
    { event_name: "hero_variant_view", session_id: "A", path: "/", properties: { variant: "A" }, created_at: t(1) },
    { event_name: "pageview", session_id: "A", path: "/register", properties: null, created_at: t(30) },
    { event_name: "signup_submit", session_id: "A", path: "/register", properties: { method: "email" }, created_at: t(40) },
    // Session B: paid Story tap on "/", auto view ping, gone in 1s.
    { event_name: "pageview", session_id: "B", path: "/?fbclid=x&utm_medium=paid&utm_source=fb&utm_campaign=c1", properties: null, created_at: t(100) },
    { event_name: "hero_variant_view", session_id: "B", path: "/?fbclid=x&utm_medium=paid&utm_source=fb&utm_campaign=c1", properties: { variant: "B" }, created_at: t(100.4) },
    // Session C: paid landing on the case game, plays for a minute.
    { event_name: "pageview", session_id: "C", path: "/sim/lc-01?utm_medium=paid&utm_source=fb&utm_campaign=c1", properties: null, created_at: t(200) },
    { event_name: "casegame_start", session_id: "C", path: "/sim/lc-01", properties: null, created_at: t(203) },
    { event_name: "casegame_complete", session_id: "C", path: "/sim/lc-01", properties: null, created_at: t(260) },
  ];

  it("credits the signup to the landing page, not to /register", () => {
    const stats = aggregatePageStats(rows);
    const home = stats.find((s) => s.path === "/")!;
    const register = stats.find((s) => s.path === "/register")!;
    expect(home.sessions).toBe(2);
    expect(home.signups).toBe(1);
    expect(register.sessions).toBe(0);
    expect(register.signups).toBe(0);
    expect(register.pageViews).toBe(1);
  });

  it("separates paid short sessions from engaged ones and ignores auto-fired pings", () => {
    const stats = aggregatePageStats(rows);
    const home = stats.find((s) => s.path === "/")!;
    expect(home.adSessions).toBe(1);
    expect(home.adShortSessions).toBe(1);
    expect(home.singleEventSessions).toBe(1); // B: one pageview, hero ping doesn't count
    expect(home.adTopSource).toBe("fb / c1");
    const sim = stats.find((s) => s.path === "/sim/lc-01")!;
    expect(sim.adSessions).toBe(1);
    expect(sim.adShortSessions).toBe(0);
    expect(sim.singleEventSessions).toBe(0);
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

  describe("pause exemptions", () => {
    const EXEMPT = new Set(["100"]);

    it("still reports an exempt ad, but never carries an autoAction", () => {
      const f = diagnoseAds(
        [
          makeAd({
            ad_id: "100",
            spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
            leads: 0,
            cpl: null,
          }),
        ],
        EXEMPT
      );
      // Visibility is the point: the admin keeps the numbers, loses only the
      // automatic switch-flip.
      expect(f).toHaveLength(1);
      expect(f[0].category).toBe("ad_no_lead_high_spend");
      expect(f[0].severity).toBe("critical");
      expect(f[0].autoAction).toBeUndefined();
      expect(f[0].recommendation).toContain("ยกเว้น auto-pause");
    });

    it("covers the high-CPL rule too", () => {
      const f = diagnoseAds(
        [makeAd({ ad_id: "100", cpl: THRESHOLDS.adHighCplThb + 50, leads: 2 })],
        EXEMPT
      );
      expect(f[0].category).toBe("ad_high_cpl");
      expect(f[0].autoAction).toBeUndefined();
    });

    it("covers the egregious-CTR rule too", () => {
      const f = diagnoseAds(
        [
          makeAd({
            ad_id: "100",
            impressions: THRESHOLDS.adAutoPauseMinImpressions + 1000,
            ctr: THRESHOLDS.adAutoPauseCtrPct - 0.1,
            cpl: 10,
            leads: 5,
          }),
        ],
        EXEMPT
      );
      expect(f[0].category).toBe("ad_low_ctr");
      expect(f[0].autoAction).toBeUndefined();
    });

    it("leaves non-exempt ads in the same batch fully automatic", () => {
      const f = diagnoseAds(
        [
          makeAd({
            ad_id: "100",
            spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
            leads: 0,
            cpl: null,
          }),
          makeAd({
            ad_id: "999",
            spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
            leads: 0,
            cpl: null,
          }),
        ],
        EXEMPT
      );
      const byId = Object.fromEntries(f.map((x) => [x.entityId, x]));
      expect(byId["100"].autoAction).toBeUndefined();
      expect(byId["999"].autoAction?.action).toBe("pause_ad");
      expect(byId["999"].recommendation).not.toContain("ยกเว้น");
    });

    it("an empty exemption set changes nothing", () => {
      const ad = makeAd({
        ad_id: "100",
        spend: THRESHOLDS.adNoLeadSpendCeilingThb + 100,
        leads: 0,
        cpl: null,
      });
      expect(diagnoseAds([ad], new Set())[0].autoAction?.action).toBe(
        "pause_ad"
      );
    });
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

function makeRow(overrides: Partial<ExistingFindingRow>): ExistingFindingRow {
  return {
    id: 1,
    entity_type: "page",
    entity_id: "/lp/a",
    category: "page_low_signup",
    resolved: false,
    resolved_at: null,
    ...overrides,
  };
}

function makeFinding(overrides: Partial<Finding>): Finding {
  return {
    severity: "warn",
    category: "page_low_signup",
    entityType: "page",
    entityId: "/lp/a",
    metricSnapshot: {},
    recommendation: "test",
    ...overrides,
  };
}

describe("reconcileFindings", () => {
  it("supersedes older open rows with the same key when a fresh finding repeats the issue", () => {
    const fresh = [makeFinding({ category: "page_no_conversion", entityId: "/lp/a" })];
    const existing = [
      makeRow({ id: 1, category: "page_no_conversion", entity_id: "/lp/a" }),
      makeRow({ id: 2, category: "page_no_conversion", entity_id: "/lp/a" }),
    ];
    const rec = reconcileFindings({ fresh, existing, pages: [], ads: [], now: new Date() });
    expect(rec.supersededIds.sort()).toEqual([1, 2]);
    expect(rec.toInsert).toEqual(fresh);
  });

  it("clears an open row when its entity was evaluated but the category no longer fires", () => {
    const existing = [makeRow({ id: 5, category: "page_low_signup", entity_id: "/lp/a" })];
    const rec = reconcileFindings({
      fresh: [],
      existing,
      pages: [makePage({ path: "/lp/a", sessions: 300 })],
      ads: [],
      now: new Date(),
    });
    expect(rec.clearedIds).toEqual([5]);
  });

  it("does not clear when the entity is present but below the evaluation threshold", () => {
    const existing = [makeRow({ id: 6, category: "page_low_signup", entity_id: "/lp/a" })];
    const rec = reconcileFindings({
      fresh: [],
      existing,
      pages: [makePage({ path: "/lp/a", sessions: THRESHOLDS.pageMinSessions - 1 })],
      ads: [],
      now: new Date(),
    });
    expect(rec.clearedIds).toEqual([]);
  });

  it("leaves a row open when its entity is absent from this run's stats entirely", () => {
    const existing = [makeRow({ id: 7, category: "page_low_signup", entity_id: "/lp/a" })];
    const rec = reconcileFindings({ fresh: [], existing, pages: [], ads: [], now: new Date() });
    expect(rec.clearedIds).toEqual([]);
  });

  it("does not clear a warn category masked by a higher-priority finding on the same entity", () => {
    const existing = [makeRow({ id: 8, category: "page_low_signup", entity_id: "/lp/a" })];
    const fresh = [
      makeFinding({ category: "ad_landing_mismatch", entityId: "/lp/a", severity: "critical" }),
    ];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [makePage({ path: "/lp/a", sessions: 900, adSessions: 800, adShortSessions: 700 })],
      ads: [],
      now: new Date(),
    });
    expect(rec.clearedIds).toEqual([]);
    expect(rec.toInsert).toEqual(fresh);
  });

  it("does not clear an ad warn category masked by ad_high_cpl on the same ad", () => {
    const existing = [makeRow({ id: 9, entity_type: "ad", category: "ad_low_ctr", entity_id: "100" })];
    const fresh = [
      makeFinding({ category: "ad_high_cpl", entityType: "ad", entityId: "100", severity: "critical" }),
    ];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000 })],
      now: new Date(),
    });
    expect(rec.clearedIds).toEqual([]);
  });

  it("skips re-inserting a paused ad's finding when an open row already records it", () => {
    const fresh = [
      makeFinding({ category: "ad_high_cpl", entityType: "ad", entityId: "100", severity: "critical" }),
    ];
    const existing = [makeRow({ id: 10, entity_type: "ad", category: "ad_high_cpl", entity_id: "100" })];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000, status: "PAUSED", effective_status: "PAUSED" })],
      now: new Date(),
    });
    expect(rec.toInsert).toEqual([]);
    expect(rec.skippedAlreadyHandled).toEqual(fresh);
    expect(rec.supersededIds).toEqual([]);
    expect(rec.clearedIds).toEqual([]);
  });

  it("also skips when the matching row was resolved recently (within the ad window)", () => {
    const fresh = [
      makeFinding({ category: "ad_high_cpl", entityType: "ad", entityId: "100", severity: "critical" }),
    ];
    const oneDayAgo = new Date(Date.now() - 86_400_000).toISOString();
    const existing = [
      makeRow({
        id: 11,
        entity_type: "ad",
        category: "ad_high_cpl",
        entity_id: "100",
        resolved: true,
        resolved_at: oneDayAgo,
      }),
    ];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000, status: "PAUSED", effective_status: "PAUSED" })],
      now: new Date(),
    });
    expect(rec.toInsert).toEqual([]);
    expect(rec.skippedAlreadyHandled).toEqual(fresh);
  });

  it("re-inserts a paused ad's finding when the matching row was resolved outside the ad window", () => {
    const fresh = [
      makeFinding({ category: "ad_high_cpl", entityType: "ad", entityId: "100", severity: "critical" }),
    ];
    const longAgo = new Date(
      Date.now() - (THRESHOLDS.adWindowDays + 2) * 86_400_000
    ).toISOString();
    const existing = [
      makeRow({
        id: 12,
        entity_type: "ad",
        category: "ad_high_cpl",
        entity_id: "100",
        resolved: true,
        resolved_at: longAgo,
      }),
    ];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000, status: "PAUSED", effective_status: "PAUSED" })],
      now: new Date(),
    });
    expect(rec.toInsert).toEqual(fresh);
    expect(rec.skippedAlreadyHandled).toEqual([]);
  });

  it("supersedes and inserts a fresh finding for an active (non-paused) ad even with an existing open row", () => {
    const fresh = [
      makeFinding({
        category: "ad_high_cpl",
        entityType: "ad",
        entityId: "100",
        severity: "critical",
        autoAction: { action: "pause_ad", entityType: "ad", entityId: "100", reason: "CPL" },
      }),
    ];
    const existing = [makeRow({ id: 13, entity_type: "ad", category: "ad_high_cpl", entity_id: "100" })];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000, status: "ACTIVE", effective_status: "ACTIVE" })],
      now: new Date(),
    });
    expect(rec.toInsert).toEqual(fresh);
    expect(rec.supersededIds).toEqual([13]);
  });

  it("a skipped paused-ad refire still masks its lower-priority category, leaving both rows open", () => {
    const fresh = [
      makeFinding({ category: "ad_high_cpl", entityType: "ad", entityId: "100", severity: "critical" }),
    ];
    const existing = [
      makeRow({ id: 14, entity_type: "ad", category: "ad_high_cpl", entity_id: "100" }),
      makeRow({ id: 15, entity_type: "ad", category: "ad_low_ctr", entity_id: "100" }),
    ];
    const rec = reconcileFindings({
      fresh,
      existing,
      pages: [],
      ads: [makeAd({ ad_id: "100", spend: 1000, status: "PAUSED", effective_status: "PAUSED" })],
      now: new Date(),
    });
    expect(rec.toInsert).toEqual([]);
    expect(rec.skippedAlreadyHandled).toEqual(fresh);
    // Neither row closes: the high-CPL row wasn't re-inserted (just skipped,
    // not cleared) and it still masks ad_low_ctr underneath it.
    expect(rec.supersededIds).toEqual([]);
    expect(rec.clearedIds).toEqual([]);
  });
});
