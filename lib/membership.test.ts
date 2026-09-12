import { describe, it, expect } from "vitest";
import {
  PLAN_CATALOG,
  PLAN_TYPES,
  deriveLegacyMembership,
  hasBoardAccess,
  hasFullStudentAccess,
  hasLongcaseAccess,
  hasMcqAccess,
  hasMeqAccess,
  hasSchoolAccess,
  isPremium,
  planDurationDays,
  planExpiry,
  planProducts,
  resolveAccess,
} from "./membership";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();

// ---------------------------------------------------------------------------
// Legacy profile columns only (no entitlement rows) — behaviour must be
// unchanged for users the backfill migration has not touched.
// ---------------------------------------------------------------------------

describe("hasBoardAccess (legacy)", () => {
  it("returns true for board_monthly within expiry", () => {
    expect(hasBoardAccess({ membership_type: "board_monthly", membership_expires_at: future })).toBe(true);
  });
  it("returns true for board_yearly within expiry", () => {
    expect(hasBoardAccess({ membership_type: "board_yearly", membership_expires_at: future })).toBe(true);
  });
  it("returns false for expired board_monthly", () => {
    expect(hasBoardAccess({ membership_type: "board_monthly", membership_expires_at: past })).toBe(false);
  });
  it("returns false for student tier (monthly does not include board)", () => {
    expect(hasBoardAccess({ membership_type: "monthly", membership_expires_at: future })).toBe(false);
  });
  it("returns false for free / null / undefined", () => {
    expect(hasBoardAccess(null)).toBe(false);
    expect(hasBoardAccess({})).toBe(false);
    expect(hasBoardAccess({ membership_type: "free", membership_expires_at: null })).toBe(false);
  });
});

describe("hasFullStudentAccess (legacy)", () => {
  it("returns true for monthly/yearly/bundle", () => {
    expect(hasFullStudentAccess({ membership_type: "monthly", membership_expires_at: future })).toBe(true);
    expect(hasFullStudentAccess({ membership_type: "yearly", membership_expires_at: future })).toBe(true);
    expect(hasFullStudentAccess({ membership_type: "bundle", membership_expires_at: future })).toBe(true);
  });
  it("returns false for board tier", () => {
    expect(hasFullStudentAccess({ membership_type: "board_monthly", membership_expires_at: future })).toBe(false);
  });
  it("returns false for expired", () => {
    expect(hasFullStudentAccess({ membership_type: "monthly", membership_expires_at: past })).toBe(false);
  });
});

describe("isPremium (legacy)", () => {
  it("returns true for any paid tier", () => {
    expect(isPremium({ membership_type: "monthly", membership_expires_at: future })).toBe(true);
    expect(isPremium({ membership_type: "board_yearly", membership_expires_at: future })).toBe(true);
    expect(isPremium({ membership_type: "mcq_monthly", membership_expires_at: future })).toBe(true);
  });
  it("returns false for free", () => {
    expect(isPremium({ membership_type: "free", membership_expires_at: null })).toBe(false);
  });
  it("treats missing membership_expires_at as never-expiring", () => {
    expect(isPremium({ membership_type: "bundle", membership_expires_at: null })).toBe(true);
  });
});

describe("per-product legacy plans", () => {
  it("mcq_monthly unlocks only MCQ", () => {
    const p = { membership_type: "mcq_monthly", membership_expires_at: future };
    expect(hasMcqAccess(p)).toBe(true);
    expect(hasMeqAccess(p)).toBe(false);
    expect(hasLongcaseAccess(p)).toBe(false);
    expect(hasSchoolAccess(p)).toBe(false);
    expect(hasBoardAccess(p)).toBe(false);
  });
  it("school_yearly unlocks only school", () => {
    const p = { membership_type: "school_yearly", membership_expires_at: future };
    expect(hasSchoolAccess(p)).toBe(true);
    expect(hasMcqAccess(p)).toBe(false);
  });
  it("student pack unlocks mcq + meq + longcase + school but not board", () => {
    const p = { membership_type: "yearly", membership_expires_at: future };
    expect(resolveAccess(p)).toMatchObject({
      mcq: true, meq: true, longcase: true, school: true, board: false, anyPaid: true,
    });
  });
});

// ---------------------------------------------------------------------------
// Entitlement rows — authoritative once present.
// ---------------------------------------------------------------------------

describe("resolveAccess with entitlements", () => {
  it("lets a user hold board and mcq at the same time", () => {
    const rows = [
      { product: "board", expires_at: future },
      { product: "mcq", expires_at: future },
    ];
    const a = resolveAccess({ membership_type: "mcq_monthly", membership_expires_at: future }, rows);
    expect(a.board).toBe(true);
    expect(a.mcq).toBe(true);
    expect(a.meq).toBe(false);
    expect(a.products.sort()).toEqual(["board", "mcq"]);
  });

  it("ignores expired rows", () => {
    const rows = [{ product: "meq", expires_at: past }];
    expect(hasMeqAccess({ membership_type: "free", membership_expires_at: null }, rows)).toBe(false);
  });

  it("treats null expires_at as lifetime", () => {
    const rows = [{ product: "mcq", expires_at: null }];
    expect(hasMcqAccess(null, rows)).toBe(true);
  });

  it("does NOT fall back to legacy columns once any row exists (admin revoke sticks)", () => {
    const legacyMonthly = { membership_type: "monthly", membership_expires_at: future };
    const revoked = [{ product: "school", expires_at: past }];
    expect(hasSchoolAccess(legacyMonthly, revoked)).toBe(false);
    expect(hasMcqAccess(legacyMonthly, revoked)).toBe(false);
  });

  it("falls back to legacy columns when there are no rows at all", () => {
    const legacyMonthly = { membership_type: "monthly", membership_expires_at: future };
    expect(hasSchoolAccess(legacyMonthly, [])).toBe(true);
    expect(hasSchoolAccess(legacyMonthly, undefined)).toBe(true);
  });

  it("hasFullStudentAccess needs mcq + meq + longcase", () => {
    const two = [
      { product: "mcq", expires_at: future },
      { product: "meq", expires_at: future },
    ];
    expect(hasFullStudentAccess(null, two)).toBe(false);
    expect(hasFullStudentAccess(null, [...two, { product: "longcase", expires_at: future }])).toBe(true);
  });

  it("ignores unknown products", () => {
    expect(resolveAccess(null, [{ product: "pharmacy", expires_at: future }]).anyPaid).toBe(false);
  });
});

describe("PLAN_CATALOG", () => {
  it("every plan grants at least one product and has a positive price", () => {
    for (const plan of PLAN_TYPES) {
      expect(PLAN_CATALOG[plan].products.length).toBeGreaterThan(0);
      expect(PLAN_CATALOG[plan].amount).toBeGreaterThan(0);
    }
  });
  it("planProducts returns [] for free / unknown", () => {
    expect(planProducts("free")).toEqual([]);
    expect(planProducts("nope")).toEqual([]);
    expect(planProducts(null)).toEqual([]);
  });
  it("durations: month=30d, year=365d, bundle=lifetime", () => {
    expect(planDurationDays("monthly")).toBe(30);
    expect(planDurationDays("board_yearly")).toBe(365);
    expect(planDurationDays("bundle")).toBeNull();
  });
  it("planExpiry adds a calendar month / year / 99 years", () => {
    const from = new Date("2026-01-31T00:00:00Z");
    expect(planExpiry("mcq_monthly", from).getTime()).toBeGreaterThan(from.getTime());
    expect(planExpiry("yearly", from).getUTCFullYear()).toBe(2027);
    expect(planExpiry("bundle", from).getUTCFullYear()).toBe(2125);
  });
});

describe("deriveLegacyMembership", () => {
  it("returns free when nothing is active", () => {
    expect(deriveLegacyMembership([{ product: "mcq", expires_at: past }], "monthly")).toEqual({
      membership_type: "free",
      membership_expires_at: null,
    });
  });
  it("keeps the current plan when all its products are still active", () => {
    const rows = ["mcq", "meq", "longcase", "school"].map((product) => ({ product, expires_at: future }));
    expect(deriveLegacyMembership(rows, "yearly").membership_type).toBe("yearly");
  });
  it("drops to a single-product plan after a partial revoke", () => {
    const rows = [
      { product: "mcq", expires_at: future },
      { product: "meq", expires_at: past },
    ];
    expect(deriveLegacyMembership(rows, "monthly").membership_type).toBe("mcq_monthly");
  });
  it("prefers the board plan when only board is active", () => {
    const rows = [{ product: "board", expires_at: future }];
    expect(deriveLegacyMembership(rows, "monthly").membership_type).toBe("board_monthly");
    expect(deriveLegacyMembership(rows, "board_yearly").membership_type).toBe("board_yearly");
  });
  it("uses the latest expiry among the plan's products, null for lifetime", () => {
    const later = new Date(Date.now() + 86400_000 * 90).toISOString();
    const rows = [
      { product: "mcq", expires_at: future },
      { product: "meq", expires_at: later },
      { product: "longcase", expires_at: future },
      { product: "school", expires_at: future },
    ];
    expect(deriveLegacyMembership(rows, "monthly").membership_expires_at).toBe(later);
    expect(deriveLegacyMembership([{ product: "mcq", expires_at: null }], "bundle")).toEqual({
      membership_type: "bundle",
      membership_expires_at: null,
    });
  });
});
