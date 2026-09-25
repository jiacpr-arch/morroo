import { describe, it, expect } from "vitest";
import { bucketAttemptsByRecency, pickNudgeChannel, buildStreakNudgePush } from "./route";

const HOUR = 3600_000;

describe("bucketAttemptsByRecency", () => {
  it("puts an attempt at or after the cutoff in activeRecent", () => {
    const now = Date.now();
    const cutoff = now - 20 * HOUR;
    const { activeRecent, activeYesterday } = bucketAttemptsByRecency(
      [{ user_id: "u1", created_at: new Date(cutoff).toISOString() }],
      cutoff
    );
    expect(activeRecent.has("u1")).toBe(true);
    expect(activeYesterday.has("u1")).toBe(false);
  });

  it("puts an attempt just before the cutoff in activeYesterday", () => {
    const cutoff = Date.now() - 20 * HOUR;
    const { activeRecent, activeYesterday } = bucketAttemptsByRecency(
      [{ user_id: "u1", created_at: new Date(cutoff - 1000).toISOString() }],
      cutoff
    );
    expect(activeYesterday.has("u1")).toBe(true);
    expect(activeRecent.has("u1")).toBe(false);
  });

  it("a user with attempts in both windows lands in activeRecent (still on track today) and activeYesterday", () => {
    const cutoff = Date.now() - 20 * HOUR;
    const { activeRecent, activeYesterday } = bucketAttemptsByRecency(
      [
        { user_id: "u1", created_at: new Date(cutoff - 1000).toISOString() },
        { user_id: "u1", created_at: new Date(cutoff + 1000).toISOString() },
      ],
      cutoff
    );
    expect(activeRecent.has("u1")).toBe(true);
    expect(activeYesterday.has("u1")).toBe(true);
  });

  it("keeps users separate — no cross-contamination between buckets", () => {
    const cutoff = Date.now() - 20 * HOUR;
    const { activeRecent, activeYesterday } = bucketAttemptsByRecency(
      [
        { user_id: "recent-only", created_at: new Date(cutoff + 1000).toISOString() },
        { user_id: "yesterday-only", created_at: new Date(cutoff - 1000).toISOString() },
      ],
      cutoff
    );
    expect(activeRecent.has("recent-only")).toBe(true);
    expect(activeRecent.has("yesterday-only")).toBe(false);
    expect(activeYesterday.has("yesterday-only")).toBe(true);
    expect(activeYesterday.has("recent-only")).toBe(false);
  });

  it("returns empty sets for an empty attempts list", () => {
    const { activeRecent, activeYesterday } = bucketAttemptsByRecency([], Date.now());
    expect(activeRecent.size).toBe(0);
    expect(activeYesterday.size).toBe(0);
  });
});

describe("pickNudgeChannel", () => {
  it("prefers LINE for linked users when quota allows — never both", () => {
    expect(pickNudgeChannel({ hasLine: true, lineAvailable: true, hasPush: true })).toBe("line");
    expect(pickNudgeChannel({ hasLine: true, lineAvailable: true, hasPush: false })).toBe("line");
  });

  it("falls back to push when the user has no LINE link", () => {
    expect(pickNudgeChannel({ hasLine: false, lineAvailable: true, hasPush: true })).toBe("push");
  });

  it("falls back to push for linked users while LINE quota is throttled", () => {
    expect(pickNudgeChannel({ hasLine: true, lineAvailable: false, hasPush: true })).toBe("push");
  });

  it("skips users with no reachable channel", () => {
    expect(pickNudgeChannel({ hasLine: false, lineAvailable: true, hasPush: false })).toBeNull();
    expect(pickNudgeChannel({ hasLine: true, lineAvailable: false, hasPush: false })).toBeNull();
  });
});

describe("buildStreakNudgePush", () => {
  it("uses a same-origin relative practice URL and a replaceable tag", () => {
    const p = buildStreakNudgePush(1);
    expect(p.url?.startsWith("/nl/practice?")).toBe(true);
    expect(p.url).toContain("utm_campaign=streak_nudge");
    expect(p.tag).toBe("streak-nudge");
  });

  it("mentions the streak once it is 3+ days", () => {
    expect(buildStreakNudgePush(5).title).toContain("5");
    expect(buildStreakNudgePush(1).title).not.toContain("1");
  });
});
