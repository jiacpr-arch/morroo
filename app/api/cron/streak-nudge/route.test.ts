import { describe, it, expect } from "vitest";
import { bucketAttemptsByRecency } from "./route";

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
