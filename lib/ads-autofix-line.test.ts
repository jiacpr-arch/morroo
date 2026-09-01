import { describe, it, expect, vi, beforeEach } from "vitest";
import { handleAdsAutofixPostback } from "./ads-autofix-line";

const ADMIN = "U_admin";
const NON_ADMIN = "U_someone_else";

// Mock the GitHub helper module so the tests don't hit the network.
vi.mock("./github-api", () => ({
  getGhConfig: () => ({ token: "t", owner: "jiacpr-arch", repo: "morroo" }),
  getPull: vi.fn(),
  getCombinedStatus: vi.fn(),
  mergePullRequest: vi.fn(),
  closePullRequest: vi.fn(),
}));

import * as gh from "./github-api";

beforeEach(() => {
  vi.clearAllMocks();
  process.env.ADMIN_LINE_USER_ID = ADMIN;
});

function fakeSupabase(suggestRow: Record<string, unknown> | null) {
  // Minimal stub — only the calls the handler makes.
  const findingRow = { entity_id: "/lp/test", category: "page_low_signup" };
  return {
    from(table: string) {
      if (table === "ad_suggest_prs") {
        return {
          select: () => ({
            eq: () => ({ maybeSingle: () => Promise.resolve({ data: suggestRow }) }),
          }),
          update: () => ({ eq: () => Promise.resolve({}) }),
        };
      }
      if (table === "ad_diagnostics_findings") {
        return {
          select: () => ({
            eq: () => ({ maybeSingle: () => Promise.resolve({ data: findingRow }) }),
          }),
        };
      }
      if (table === "ad_finding_snooze") {
        return { upsert: () => Promise.resolve({}) };
      }
      throw new Error(`unexpected table: ${table}`);
    },
  } as unknown as Parameters<typeof handleAdsAutofixPostback>[0];
}

const confirmFlex = vi.fn((a: { prNumber: number }) => ({
  type: "flex" as const,
  altText: `confirm ${a.prNumber}`,
  contents: {},
}));

describe("handleAdsAutofixPostback — auth", () => {
  it("rejects non-admin LINE users", async () => {
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 1, page_path: "/lp/x", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      NON_ADMIN,
      "action=merge_pr&pr=1",
      confirmFlex
    );
    expect(reply?.[0].type).toBe("text");
    expect((reply?.[0] as { text: string }).text).toContain("แอดมินเท่านั้น");
  });

  it("returns null for non-ads actions", async () => {
    const reply = await handleAdsAutofixPostback(
      fakeSupabase(null),
      ADMIN,
      "action=some_other_thing&pr=1",
      confirmFlex
    );
    expect(reply).toBeNull();
  });
});

describe("handleAdsAutofixPostback — merge flow", () => {
  it("step 1: merge_pr returns confirm flex", async () => {
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 7, page_path: "/lp/a", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      ADMIN,
      "action=merge_pr&pr=7",
      confirmFlex
    );
    expect(confirmFlex).toHaveBeenCalledWith({ prNumber: 7, prUrl: "u", pagePath: "/lp/a" });
    expect(reply?.[0].type).toBe("flex");
  });

  it("step 2: refuses to merge a PR missing the suggest label", async () => {
    vi.mocked(gh.getPull).mockResolvedValue({
      state: "open",
      merged: false,
      head: { ref: "b", sha: "abc" },
      labels: [{ name: "some-other-label" }],
    });
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 7, page_path: "/lp/a", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      ADMIN,
      "action=merge_pr_confirm&pr=7",
      confirmFlex
    );
    expect((reply?.[0] as { text: string }).text).toContain("refusing to merge");
  });

  it("step 2: refuses when CI is failing", async () => {
    vi.mocked(gh.getPull).mockResolvedValue({
      state: "open",
      merged: false,
      head: { ref: "b", sha: "abc" },
      labels: [{ name: "ads-autofix-suggest" }],
    });
    vi.mocked(gh.getCombinedStatus).mockResolvedValue({ state: "failure", total_count: 1 });
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 7, page_path: "/lp/a", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      ADMIN,
      "action=merge_pr_confirm&pr=7",
      confirmFlex
    );
    expect((reply?.[0] as { text: string }).text).toContain("CI fail");
    expect(gh.mergePullRequest).not.toHaveBeenCalled();
  });

  it("step 2: merges when CI is green and label is present", async () => {
    vi.mocked(gh.getPull).mockResolvedValue({
      state: "open",
      merged: false,
      head: { ref: "b", sha: "abc" },
      labels: [{ name: "ads-autofix-suggest" }],
    });
    vi.mocked(gh.getCombinedStatus).mockResolvedValue({ state: "success", total_count: 1 });
    vi.mocked(gh.mergePullRequest).mockResolvedValue({ ok: true, sha: "merged_sha" });
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 7, page_path: "/lp/a", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      ADMIN,
      "action=merge_pr_confirm&pr=7",
      confirmFlex
    );
    expect(gh.mergePullRequest).toHaveBeenCalled();
    expect((reply?.[0] as { text: string }).text).toContain("Merged PR #7");
  });
});

describe("handleAdsAutofixPostback — dismiss", () => {
  it("closes PR and replies snooze", async () => {
    vi.mocked(gh.getPull).mockResolvedValue({
      state: "open",
      merged: false,
      head: { ref: "b", sha: "abc" },
      labels: [{ name: "ads-autofix-suggest" }],
    });
    vi.mocked(gh.closePullRequest).mockResolvedValue(true);
    const reply = await handleAdsAutofixPostback(
      fakeSupabase({ pr_number: 7, page_path: "/lp/a", pr_url: "u", branch: "b", finding_id: 1, status: "open" }),
      ADMIN,
      "action=dismiss_pr&pr=7",
      confirmFlex
    );
    expect(gh.closePullRequest).toHaveBeenCalledWith(expect.anything(), 7);
    expect((reply?.[0] as { text: string }).text).toContain("Dismissed");
  });
});
