import { describe, it, expect } from "vitest";
import { pickExpiryChannel, expiryWindow, lapsedWindow, dedupeSince, WINBACK_DAY } from "./route";

describe("pickExpiryChannel", () => {
  it("prefers LINE whenever it's linked, on every reminder day", () => {
    const profile = { lineUserId: "U123", email: "doctor@example.com" };
    expect(pickExpiryChannel(profile, 7)).toBe("line");
    expect(pickExpiryChannel(profile, 3)).toBe("line");
    expect(pickExpiryChannel(profile, 1)).toBe("line");
  });

  it("falls back to email on D-3/D-1 when LINE isn't linked", () => {
    const profile = { lineUserId: null, email: "doctor@example.com" };
    expect(pickExpiryChannel(profile, 3)).toBe("email");
    expect(pickExpiryChannel(profile, 1)).toBe("email");
  });

  it("never sends an email-only D-7 (no early-reminder email copy exists)", () => {
    const profile = { lineUserId: null, email: "doctor@example.com" };
    expect(pickExpiryChannel(profile, 7)).toBeNull();
  });

  it("skips a profile with neither channel", () => {
    const profile = { lineUserId: null, email: null };
    expect(pickExpiryChannel(profile, 3)).toBeNull();
  });

  it("treats a LINE-login placeholder email as no real email", () => {
    const profile = { lineUserId: null, email: "u123abc@line.morroo.com" };
    expect(pickExpiryChannel(profile, 3)).toBeNull();
    expect(pickExpiryChannel(profile, 1)).toBeNull();
  });

  it("never returns both channels for the same profile/day", () => {
    // LINE wins outright — this is what prevents the old double-send on D-3.
    const profile = { lineUserId: "U123", email: "doctor@example.com" };
    const channel = pickExpiryChannel(profile, 3);
    expect(channel).toBe("line");
    expect(channel).not.toBe("email");
  });
});

describe("expiryWindow", () => {
  it("produces a 24h window ending `days` days from now", () => {
    const now = Date.UTC(2026, 8, 18, 2, 0, 0); // 2026-09-18T02:00:00Z
    const win = expiryWindow(now, 3);
    expect(win.from).toBe(new Date(now + 2 * 86400_000).toISOString());
    expect(win.to).toBe(new Date(now + 3 * 86400_000).toISOString());
  });

  it("produces disjoint, adjacent windows for D-7/D-3/D-1 so a profile lands in at most one", () => {
    const now = Date.UTC(2026, 8, 18, 2, 0, 0);
    const d7 = expiryWindow(now, 7);
    const d3 = expiryWindow(now, 3);
    const d1 = expiryWindow(now, 1);
    // Chronological order is D-1 (closest to now) < D-3 < D-7 (furthest out).
    // Gaps for days 2 and 4-6 are expected — those days simply have no reminder.
    expect(new Date(d1.to).getTime()).toBeLessThanOrEqual(new Date(d3.from).getTime());
    expect(new Date(d3.to).getTime()).toBeLessThanOrEqual(new Date(d7.from).getTime());
  });
});

describe("lapsedWindow (D+1 win-back)", () => {
  it("covers the 24h before now, adjacent to the D-1 window", () => {
    const now = Date.UTC(2026, 8, 25, 2, 0, 0);
    const lapsed = lapsedWindow(now);
    expect(lapsed.from).toBe(new Date(now - 86400_000).toISOString());
    expect(lapsed.to).toBe(new Date(now).toISOString());
    expect(lapsed.to).toBe(expiryWindow(now, 1).from);
  });
});

describe("dedupeSince (once per lapse, not once per account)", () => {
  const DAY = 86400_000;
  const expiry = "2026-09-24T12:00:00.000Z";
  const t = (iso: string) => new Date(iso).getTime();

  it("D+1: a send for this lapse counts, one for an earlier lapse doesn't", () => {
    const since = t(dedupeSince(expiry, WINBACK_DAY));
    // Sent by the cron the day after this expiry → dedupes a rerun.
    expect(t(expiry) + 0.5 * DAY).toBeGreaterThanOrEqual(since);
    // Sent after the previous plan lapsed (before they bought again).
    expect(t("2026-06-25T02:00:00Z")).toBeLessThan(since);
  });

  it("D-N: the send window for this expiry is inside the dedupe range", () => {
    for (const days of [7, 3, 1] as const) {
      const since = t(dedupeSince(expiry, days));
      const earliestSend = t(expiry) - days * DAY;
      expect(earliestSend).toBeGreaterThanOrEqual(since);
      // A reminder for an expiry ≥ 2 days earlier is outside it.
      expect(t(expiry) - 2 * DAY - days * DAY).toBeLessThan(since);
    }
  });
});
