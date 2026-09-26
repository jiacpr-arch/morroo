import { describe, it, expect, afterEach, vi } from "vitest";
import {
  adminUrl,
  formatActionItemValue,
  formatWaitAge,
  getAdminActionItems,
  sortActionItems,
  summarizeOpenCommentReports,
  totalActionCount,
  type AdminActionItem,
} from "./admin-action-items";
import { buildAdminAlertText, isAlertThrottled } from "./admin-alerts";

const NOW = new Date("2026-09-26T01:00:00Z");

const item = (over: Partial<AdminActionItem>): AdminActionItem => ({
  key: "k",
  label: "งาน",
  count: 1,
  path: "/admin",
  href: "https://www.morroo.com/admin",
  severity: "medium",
  ...over,
});

afterEach(() => {
  vi.unstubAllEnvs();
});

describe("adminUrl", () => {
  it("defaults to the production site", () => {
    vi.stubEnv("NEXT_PUBLIC_SITE_URL", "");
    expect(adminUrl("/admin/payments")).toBe("https://www.morroo.com/admin/payments");
  });

  it("trims whitespace and trailing slashes from the env value", () => {
    vi.stubEnv("NEXT_PUBLIC_SITE_URL", "  https://staging.morroo.com/ \n");
    expect(adminUrl("/admin/leads")).toBe("https://staging.morroo.com/admin/leads");
  });
});

describe("sortActionItems", () => {
  it("drops zero counts, keeps failed, orders by severity then count", () => {
    const sorted = sortActionItems([
      item({ key: "zero", count: 0 }),
      item({ key: "low-big", severity: "low", count: 75 }),
      item({ key: "med-small", severity: "medium", count: 2 }),
      item({ key: "med-big", severity: "medium", count: 9 }),
      item({ key: "high", severity: "high", count: 1 }),
      item({ key: "failed", severity: "medium", count: 0, failed: true }),
    ]);
    expect(sorted.map((i) => i.key)).toEqual(["high", "med-big", "med-small", "failed", "low-big"]);
  });

  it("totals only real counts", () => {
    expect(totalActionCount([item({ count: 3 }), item({ count: 4, failed: true }), item({ count: 2 })])).toBe(5);
  });
});

describe("formatWaitAge / formatActionItemValue", () => {
  it("formats minutes, hours, days", () => {
    expect(formatWaitAge("2026-09-26T00:50:00Z", NOW)).toBe("10 นาที");
    expect(formatWaitAge("2026-09-25T20:00:00Z", NOW)).toBe("5 ชม.");
    expect(formatWaitAge("2026-09-22T00:00:00Z", NOW)).toBe("4 วัน");
    expect(formatWaitAge(null, NOW)).toBeNull();
    expect(formatWaitAge("garbage", NOW)).toBeNull();
  });

  it("shows count plus age, or a failure marker", () => {
    expect(formatActionItemValue(item({ count: 3, oldestAt: "2026-09-24T00:00:00Z" }), NOW)).toBe("3 · ค้าง 2 วัน");
    expect(formatActionItemValue(item({ count: 7 }), NOW)).toBe("7");
    expect(formatActionItemValue(item({ failed: true }), NOW)).toBe("ตรวจไม่ได้");
  });
});

describe("summarizeOpenCommentReports", () => {
  it("counts comments with reports newer than the last review", () => {
    const comments = new Map([
      ["a", { status: "hidden", moderated_at: null }],
      ["b", { status: "visible", moderated_at: "2026-09-25T00:00:00Z" }],
      ["c", { status: "visible", moderated_at: null }],
    ]);
    const res = summarizeOpenCommentReports(
      [
        { comment_id: "a", created_at: "2026-09-25T10:00:00Z" },
        { comment_id: "a", created_at: "2026-09-25T09:00:00Z" },
        { comment_id: "b", created_at: "2026-09-24T00:00:00Z" }, // dismissed by review
        { comment_id: "c", created_at: "2026-09-25T12:00:00Z" },
        { comment_id: "gone", created_at: "2026-09-20T00:00:00Z" }, // deleted comment
      ],
      comments
    );
    expect(res.count).toBe(2);
    expect(res.oldestAt).toBe("2026-09-25T09:00:00Z");
    expect(res.severity).toBe("high"); // "a" was auto-hidden
  });

  it("is medium when nothing is hidden and zero when nothing is open", () => {
    const comments = new Map([["c", { status: "visible", moderated_at: null }]]);
    expect(summarizeOpenCommentReports([{ comment_id: "c", created_at: "2026-09-25T00:00:00Z" }], comments).severity).toBe(
      "medium"
    );
    expect(summarizeOpenCommentReports([], comments).count).toBe(0);
  });
});

describe("getAdminActionItems", () => {
  // Minimal chainable stand-in for the Supabase query builder.
  function fakeClient(resolve: (table: string) => unknown) {
    return {
      from(table: string) {
        const q: Record<string, unknown> = {};
        for (const m of ["select", "eq", "or", "gte", "lte", "lt", "in", "order", "limit"]) {
          q[m] = () => q;
        }
        q.then = (ok: (v: unknown) => unknown, fail: (e: unknown) => unknown) => {
          try {
            return Promise.resolve(resolve(table)).then(ok, fail);
          } catch (err) {
            return Promise.reject(err).then(ok, fail);
          }
        };
        return q;
      },
    } as never;
  }

  it("isolates a failing queue and keeps the rest", async () => {
    const errSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const client = fakeClient((table) => {
      if (table === "leads") throw new Error("boom");
      if (table === "payment_orders") return { data: [{ created_at: "2026-09-25T00:00:00Z" }], count: 2, error: null };
      if (table === "organizations") return { data: [], count: 0, error: { message: "nope" } };
      return { data: [], count: 0, error: null };
    });
    const items = await getAdminActionItems(client, NOW);
    const byKey = Object.fromEntries(items.map((i) => [i.key, i]));

    expect(byKey.leads_new_stale.failed).toBe(true);
    expect(byKey.orgs_expiring.failed).toBe(true);
    expect(byKey.payments_pending).toMatchObject({ count: 2, severity: "high", path: "/admin/payments" });
    expect(byKey.payments_pending.href).toMatch(/\/admin\/payments$/);
    expect(byKey.mcq_reports_pending.count).toBe(0);
    expect(byKey.mcq_reports_pending.failed).toBeUndefined();
    errSpy.mockRestore();
  });
});

describe("admin alerts", () => {
  it("throttles within the window only", () => {
    expect(isAlertThrottled(null, NOW)).toBe(false);
    expect(isAlertThrottled("2026-09-25T22:00:00Z", NOW)).toBe(true); // 3h ago
    expect(isAlertThrottled("2026-09-25T18:00:00Z", NOW)).toBe(false); // 7h ago
    expect(isAlertThrottled("bad", NOW)).toBe(false);
  });

  it("builds a text with the admin link and throttle note", () => {
    vi.stubEnv("NEXT_PUBLIC_SITE_URL", "");
    const text = buildAdminAlertText({ title: "หัวข้อ", detail: "a\n\nb", path: "/admin/mcq/comments" });
    expect(text).toContain("หัวข้อ\na b");
    expect(text).toContain("https://www.morroo.com/admin/mcq/comments");
    expect(text).toContain("6 ชม.");
  });
});
