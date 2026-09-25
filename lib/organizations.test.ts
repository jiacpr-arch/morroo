import { describe, it, expect } from "vitest";
import {
  deriveLegacyMembership,
  hasFullStudentAccess,
  hasMcqAccess,
  isPremium,
  resolveAccess,
  type EntitlementLike,
} from "./membership";
import {
  bangkokDay,
  checkJoin,
  generateJoinCode,
  normalizeJoinCode,
  orgEntitlementRows,
  seatsRemaining,
  streakFromDays,
  summarizeMemberProgress,
  toCsv,
  validateSeats,
  type OrgMembershipRow,
} from "./organizations";

// Access tests use the real clock (isPremium / hasMcqAccess take no `now`);
// progress tests pin FIXED so the hard-coded attempt dates stay meaningful.
const NOW = new Date();
const FIXED = new Date("2026-09-25T05:00:00Z"); // 12:00 Bangkok
const future = new Date(NOW.getTime() + 86400_000 * 30).toISOString();
const later = new Date(NOW.getTime() + 86400_000 * 90).toISOString();
const past = new Date(NOW.getTime() - 86400_000).toISOString();

function membership(
  orgId: string,
  plan: string,
  expires_at: string,
  role: "owner" | "member" = "member"
): OrgMembershipRow {
  return {
    org_id: orgId,
    role,
    joined_at: "2026-09-01T00:00:00Z",
    organizations: { id: orgId, name: `Org ${orgId}`, plan, expires_at },
  };
}

// ---------------------------------------------------------------------------
// Entitlement merge
// ---------------------------------------------------------------------------

describe("orgEntitlementRows", () => {
  it("emits one whole-product org row per plan product, expiring with the org", () => {
    const rows = orgEntitlementRows("u1", [membership("o1", "yearly", future)]);
    expect(rows.map((r) => r.product).sort()).toEqual(["longcase", "mcq", "meq", "school"]);
    for (const r of rows) {
      expect(r).toMatchObject({ user_id: "u1", scope: "*", source: "org", reference: "o1", expires_at: future });
    }
  });

  it("falls back to the student pack for an unknown plan", () => {
    const rows = orgEntitlementRows("u1", [membership("o1", "nonsense", future)]);
    expect(rows).toHaveLength(4);
  });

  it("keeps the later expiry when two orgs grant the same product", () => {
    const rows = orgEntitlementRows("u1", [
      membership("a", "mcq_yearly", future),
      membership("b", "yearly", later),
    ]);
    const mcq = rows.filter((r) => r.product === "mcq");
    expect(mcq).toHaveLength(1);
    expect(mcq[0]).toMatchObject({ expires_at: later, reference: "b" });
  });

  it("skips memberships whose org could not be read", () => {
    expect(orgEntitlementRows("u1", [{ ...membership("o1", "yearly", future), organizations: null }])).toEqual([]);
    expect(orgEntitlementRows("u1", null)).toEqual([]);
  });
});

describe("resolveAccess with org rows", () => {
  const orgRows = (exp: string, plan = "yearly") => orgEntitlementRows("u1", [membership("o1", plan, exp)]);

  it("an active org grants the same access as the individual plan", () => {
    const viaOrg = resolveAccess({ membership_type: "free" }, orgRows(future), NOW);
    const viaPlan = resolveAccess({ membership_type: "yearly", membership_expires_at: future }, [], NOW);
    expect(viaOrg).toEqual(viaPlan);
    expect(isPremium({ membership_type: "free" }, orgRows(future))).toBe(true);
    expect(hasFullStudentAccess({ membership_type: "free" }, orgRows(future))).toBe(true);
  });

  it("ends at org expiry", () => {
    expect(resolveAccess({ membership_type: "free" }, orgRows(past), NOW).anyPaid).toBe(false);
  });

  it("ends when the member is removed (no org rows)", () => {
    expect(resolveAccess({ membership_type: "free" }, [], NOW).anyPaid).toBe(false);
  });

  it("is additive to personal entitlement rows", () => {
    const personal: EntitlementLike[] = [{ product: "board", expires_at: future, scope: "*" }];
    const a = resolveAccess(null, [...personal, ...orgRows(future, "mcq_monthly")], NOW);
    expect(a.board).toBe(true);
    expect(a.mcq).toBe(true);
    expect(a.meq).toBe(false);
  });

  it("does not switch off the legacy fallback (org rows are not 'personal rows')", () => {
    const profile = { membership_type: "board_yearly", membership_expires_at: future };
    const a = resolveAccess(profile, orgRows(future, "mcq_yearly"), NOW);
    expect(a.board).toBe(true); // from legacy columns
    expect(a.mcq).toBe(true); // from the org
  });

  it("an expired org row never re-opens or blocks anything", () => {
    const profile = { membership_type: "yearly", membership_expires_at: future };
    expect(hasMcqAccess(profile, orgRows(past))).toBe(true);
    // Personal revoke (expired personal row) still wins over legacy columns.
    const revoked: EntitlementLike[] = [{ product: "mcq", expires_at: past, scope: "*" }];
    expect(resolveAccess(profile, [...revoked, ...orgRows(past)], NOW).mcq).toBe(false);
  });

  it("is never written into the legacy summary", () => {
    expect(deriveLegacyMembership(orgRows(future), "free", NOW)).toEqual({
      membership_type: "free",
      membership_expires_at: null,
    });
  });
});

// ---------------------------------------------------------------------------
// Seats & join codes
// ---------------------------------------------------------------------------

describe("checkJoin (seat limit)", () => {
  const org = { seats: 3, expires_at: future };

  it("allows joining while seats remain", () => {
    expect(checkJoin(org, 2, false, NOW)).toBe("joined");
  });

  it("rejects when all seats are taken", () => {
    expect(checkJoin(org, 3, false, NOW)).toBe("full");
    expect(checkJoin(org, 5, false, NOW)).toBe("full");
  });

  it("an existing member is not blocked by a full org", () => {
    expect(checkJoin(org, 3, true, NOW)).toBe("already_member");
  });

  it("rejects expired and unknown orgs", () => {
    expect(checkJoin({ seats: 3, expires_at: past }, 0, false, NOW)).toBe("expired");
    expect(checkJoin(null, 0, false, NOW)).toBe("not_found");
  });

  it("seatsRemaining never goes negative", () => {
    expect(seatsRemaining(10, 4)).toBe(6);
    expect(seatsRemaining(3, 5)).toBe(0);
  });
});

describe("validateSeats", () => {
  it("accepts positive integers (also numeric strings)", () => {
    expect(validateSeats(30)).toEqual({ ok: true, seats: 30 });
    expect(validateSeats("12")).toEqual({ ok: true, seats: 12 });
  });

  it("rejects zero, fractions and garbage", () => {
    expect(validateSeats(0).ok).toBe(false);
    expect(validateSeats(2.5).ok).toBe(false);
    expect(validateSeats("abc").ok).toBe(false);
    expect(validateSeats(undefined).ok).toBe(false);
  });

  it("cannot go below the current member count", () => {
    expect(validateSeats(4, 5).ok).toBe(false);
    expect(validateSeats(5, 5)).toEqual({ ok: true, seats: 5 });
  });
});

describe("join codes", () => {
  it("generates 8 unambiguous characters", () => {
    for (let i = 0; i < 50; i++) {
      const code = generateJoinCode();
      expect(code).toMatch(/^[A-HJ-NP-Z2-9]{8}$/);
    }
  });

  it("is deterministic given the random source", () => {
    expect(generateJoinCode(() => new Uint8Array(8))).toBe("AAAAAAAA");
  });

  it("normalizes user input", () => {
    expect(normalizeJoinCode(" ab7k-2qxm ")).toBe("AB7K2QXM");
    expect(normalizeJoinCode("abc")).toBeNull();
    expect(normalizeJoinCode(null)).toBeNull();
  });
});

// ---------------------------------------------------------------------------
// Member progress
// ---------------------------------------------------------------------------

describe("streakFromDays", () => {
  const today = bangkokDay(FIXED);

  it("counts consecutive days ending today", () => {
    expect(streakFromDays([today, today - 1, today - 2, today - 4], today)).toBe(3);
  });

  it("still counts a run that ended yesterday", () => {
    expect(streakFromDays([today - 1, today - 2], today)).toBe(2);
  });

  it("is 0 when the last activity was 2+ days ago", () => {
    expect(streakFromDays([today - 2, today - 3], today)).toBe(0);
    expect(streakFromDays([], today)).toBe(0);
  });
});

describe("bangkokDay", () => {
  it("rolls over at midnight Bangkok, not UTC", () => {
    // 16:59Z = 23:59 BKK, 17:00Z = 00:00 BKK next day
    expect(bangkokDay("2026-09-24T17:00:00Z") - bangkokDay("2026-09-24T16:59:00Z")).toBe(1);
    expect(bangkokDay("2026-09-24T01:00:00Z")).toBe(bangkokDay("2026-09-24T16:59:00Z"));
  });
});

describe("summarizeMemberProgress", () => {
  it("aggregates attempts, accuracy, last active and streak per member", () => {
    const out = summarizeMemberProgress(
      ["u1", "u2"],
      [
        { user_id: "u1", is_correct: true, created_at: "2026-09-25T03:00:00Z" },
        { user_id: "u1", is_correct: false, created_at: "2026-09-24T03:00:00Z" },
        { user_id: "u1", is_correct: true, created_at: "2026-09-23T03:00:00Z" },
        { user_id: "stranger", is_correct: true, created_at: "2026-09-25T03:00:00Z" },
      ],
      FIXED
    );
    expect(out.u1).toEqual({
      attempts: 3,
      correct: 2,
      accuracy: 66.7,
      lastActive: "2026-09-25T03:00:00.000Z",
      streak: 3,
    });
    expect(out.u2).toEqual({ attempts: 0, correct: 0, accuracy: 0, lastActive: null, streak: 0 });
    expect(out.stranger).toBeUndefined();
  });
});

describe("toCsv", () => {
  it("quotes commas / quotes / newlines and neutralises formulas", () => {
    const csv = toCsv(["a", "b"], [["x,y", 'say "hi"'], ["=SUM(A1)", null]]);
    expect(csv).toBe('a,b\r\n"x,y","say ""hi"""\r\n\'=SUM(A1),');
  });
});
