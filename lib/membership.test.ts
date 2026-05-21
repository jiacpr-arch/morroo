import { describe, it, expect } from "vitest";
import { hasBoardAccess, hasFullStudentAccess, isPremium } from "./membership";

const future = new Date(Date.now() + 86400_000 * 30).toISOString();
const past = new Date(Date.now() - 86400_000).toISOString();

describe("hasBoardAccess", () => {
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

describe("hasFullStudentAccess", () => {
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

describe("isPremium", () => {
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
