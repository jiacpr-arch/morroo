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

function metaOk(body: unknown) {
  return { ok: true, json: async () => body, text: async () => "" };
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

describe("configured", () => {
  it("an empty window is ok:true with zero ads — not a failure", async () => {
    vi.stubGlobal("fetch", vi.fn(async () => metaOk({ data: [] })));

    const r = await fetchAdInsights(SINCE, UNTIL);

    expect(r.ok).toBe(true);
    if (r.ok) expect(r.ads).toEqual([]);
  });

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
    }
  });

  it("still throws on an API failure so the caller records the message", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn(async () => ({
        ok: false,
        status: 403,
        text: async () =>
          '{"error":{"message":"(#200) Ad account owner has NOT grant ads_management or ads_read permission","code":200}}',
      }))
    );

    await expect(fetchAdInsights(SINCE, UNTIL)).rejects.toThrow(
      /Meta insights failed 403/
    );
  });
});
