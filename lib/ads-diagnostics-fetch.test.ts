/**
 * fetchAdInsights' three outcomes.
 *
 * Kept apart from ads-diagnostics.test.ts because this file mocks the Meta
 * token lookup and global fetch, while that one exercises pure functions.
 *
 * The distinction under test is the one that failed in production: an empty
 * ad list and an unread ad account are not the same answer.
 */
import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

vi.mock("./facebook", () => ({
  getLatestUserToken: vi.fn(),
}));

import { fetchAdInsights } from "./ads-diagnostics";
import { getLatestUserToken } from "./facebook";

const mockToken = vi.mocked(getLatestUserToken);
const SINCE = "2026-09-18T00:00:00.000Z";
const UNTIL = "2026-09-21T00:00:00.000Z";

interface FakeResponse {
  ok: boolean;
  status?: number;
  json: () => Promise<unknown>;
  text: () => Promise<string>;
}

function metaOk(body: unknown): FakeResponse {
  return { ok: true, json: async () => body, text: async () => "" };
}

function metaFail(status: number, body = ""): FakeResponse {
  return { ok: false, status, json: async () => ({}), text: async () => body };
}

beforeEach(() => {
  vi.clearAllMocks();
  process.env.META_AD_ACCOUNT_ID = "act_123456";
  mockToken.mockResolvedValue("tok_live");
});

afterEach(() => {
  vi.unstubAllGlobals();
  delete process.env.META_AD_ACCOUNT_ID;
});

describe("not configured → ok:false, and never calls Meta", () => {
  it("reports a missing account id", async () => {
    delete process.env.META_AD_ACCOUNT_ID;
    const fetchSpy = vi.fn();
    vi.stubGlobal("fetch", fetchSpy);

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(false);
    if (!r.ok) expect(r.reason).toContain("META_AD_ACCOUNT_ID");
    expect(fetchSpy).not.toHaveBeenCalled();
  });

  it("reports a missing token", async () => {
    mockToken.mockResolvedValue(null);
    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(false);
    if (!r.ok) {
      expect(r.reason).toContain("Meta token");
      expect(r.reason).not.toContain("META_AD_ACCOUNT_ID");
    }
  });

  it("names both when both are gone", async () => {
    delete process.env.META_AD_ACCOUNT_ID;
    mockToken.mockResolvedValue(null);
    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(false);
    if (!r.ok) {
      expect(r.reason).toContain("META_AD_ACCOUNT_ID");
      expect(r.reason).toContain("Meta token");
    }
  });
});

describe("empty insights → probe how many ads are actually live", () => {
  /** insights returns nothing; the /ads probe answers with `probe`. */
  function stubEmptyInsights(probe: unknown, probeOk = true) {
    const spy = vi.fn(async (url: string) =>
      url.includes("/insights")
        ? metaOk({ data: [] })
        : probeOk
          ? metaOk(probe)
          : metaFail(400)
    );
    vi.stubGlobal("fetch", spy);
    return spy;
  }

  it("a quiet account reports activeAds: 0", async () => {
    const spy = stubEmptyInsights({ data: [], summary: { total_count: 0 } });

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    if (r.ok) {
      expect(r.ads).toEqual([]);
      expect(r.activeAds).toBe(0);
    }
    // probe asks only for live ads, and only needs one row back
    const probeUrl = spy.mock.calls.map((c) => c[0]).find((u) => !u.includes("/insights"))!;
    expect(probeUrl).toContain("effective_status=");
    expect(decodeURIComponent(probeUrl)).toContain('["ACTIVE"]');
    expect(probeUrl).toContain("summary=total_count");
  });

  it("live ads with no insights reports the count", async () => {
    stubEmptyInsights({ data: [{ id: "1" }], summary: { total_count: 7 } });

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    if (r.ok) expect(r.activeAds).toBe(7);
  });

  it("falls back to counting rows when summary is absent", async () => {
    stubEmptyInsights({ data: [{ id: "1" }] });

    const r = await fetchAdInsights(SINCE, UNTIL);
    if (r.ok) expect(r.activeAds).toBe(1);
  });

  it("a failed probe is null, never 0", async () => {
    stubEmptyInsights(null, false);

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    // null means "could not check" — collapsing it to 0 would resurrect the
    // exact false all-clear this whole change exists to remove.
    if (r.ok) expect(r.activeAds).toBeNull();
  });

  it("a throwing probe is null too, and does not fail the scan", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn(async (url: string) => {
        if (url.includes("/insights")) return metaOk({ data: [] });
        throw new Error("socket hang up");
      })
    );

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    if (r.ok) expect(r.activeAds).toBeNull();
  });
});

describe("configured", () => {
  it("maps real rows through", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn(async (url: string) =>
        url.includes("/insights")
          ? metaOk({
              data: [
                {
                  ad_id: "52605554394197",
                  ad_name: "P3",
                  spend: "600",
                  impressions: "10000",
                  clicks: "20",
                  ctr: "0.2",
                  frequency: "3",
                  actions: [],
                },
              ],
            })
          : metaOk({
              "52605554394197": {
                id: "52605554394197",
                status: "ACTIVE",
                effective_status: "ACTIVE",
              },
            })
      )
    );

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    if (r.ok) {
      expect(r.ads).toHaveLength(1);
      expect(r.ads[0].ad_id).toBe("52605554394197");
      expect(r.ads[0].spend).toBe(600);
      expect(r.ads[0].status).toBe("ACTIVE");
      expect(r.ads[0].leads).toBe(0);
      expect(r.ads[0].cpl).toBeNull();
      // rows came back, so there was nothing to disambiguate
      expect(r.activeAds).toBeNull();
    }
  });

  it("does not spend a probe call when insights returned rows", async () => {
    const spy = vi.fn(async (url: string) =>
      url.includes("/insights")
        ? metaOk({ data: [{ ad_id: "1", spend: "10" }] })
        : metaOk({ "1": { id: "1", status: "ACTIVE" } })
    );
    vi.stubGlobal("fetch", spy);

    await fetchAdInsights(SINCE, UNTIL);

    expect(spy.mock.calls.filter((c) => c[0].includes("/ads?"))).toHaveLength(0);
  });

  it("still throws on an API failure so the caller records the message", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn(async () =>
        metaFail(
          403,
          '{"error":{"message":"(#200) Ad account owner has NOT grant ads_management or ads_read permission","code":200}}'
        )
      )
    );

    await expect(fetchAdInsights(SINCE, UNTIL)).rejects.toThrow(
      /Meta insights failed 403/
    );
  });
});
