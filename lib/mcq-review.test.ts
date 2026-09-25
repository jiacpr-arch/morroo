import { describe, it, expect, vi } from "vitest";
import {
  bangkokDayEnd,
  isReviewDue,
  nextMcqReviewState,
  recordMcqReviewOutcome,
  GRADUATE_AFTER_DAYS,
  type McqReviewRow,
} from "./mcq-review";

const NOW = new Date("2026-09-25T03:00:00Z"); // 10:00 Asia/Bangkok
const DAY = 24 * 3600_000;

function daysFromNow(iso: string): number {
  return Math.round((new Date(iso).getTime() - NOW.getTime()) / DAY);
}

function row(overrides: Partial<McqReviewRow> = {}): McqReviewRow {
  return {
    ease_factor: 2.5,
    interval_days: 1,
    due_at: new Date(NOW.getTime() - 3600_000).toISOString(), // due an hour ago
    lapses: 0,
    review_count: 0,
    ...overrides,
  };
}

describe("bangkokDayEnd / isReviewDue", () => {
  it("returns the next Bangkok midnight as a UTC instant", () => {
    expect(bangkokDayEnd(NOW).toISOString()).toBe("2026-09-25T17:00:00.000Z");
    // 01:00 Bangkok on the 26th is already the next Bangkok day.
    expect(bangkokDayEnd(new Date("2026-09-25T18:00:00Z")).toISOString()).toBe(
      "2026-09-26T17:00:00.000Z"
    );
  });

  it("treats anything due before the end of today (Bangkok) as due", () => {
    expect(isReviewDue("2026-09-25T16:59:00Z", NOW)).toBe(true);
    expect(isReviewDue("2026-09-20T00:00:00Z", NOW)).toBe(true);
    expect(isReviewDue("2026-09-25T17:00:00Z", NOW)).toBe(false);
  });
});

describe("nextMcqReviewState", () => {
  it("queues a newly-missed question for tomorrow", () => {
    const u = nextMcqReviewState(null, false, NOW);
    expect(u.action).toBe("upsert");
    if (u.action !== "upsert") return;
    expect(u.row.interval_days).toBe(1);
    expect(u.row.ease_factor).toBe(2.5);
    expect(u.row.lapses).toBe(0);
    expect(daysFromNow(u.row.due_at)).toBe(1);
    // Tomorrow, not today — a fresh mistake isn't due again the same day.
    expect(isReviewDue(u.row.due_at, NOW)).toBe(false);
  });

  it("ignores a correct answer on a question that isn't queued", () => {
    expect(nextMcqReviewState(null, true, NOW)).toEqual({ action: "none" });
  });

  it("advances the interval on a correct answer when due", () => {
    const u = nextMcqReviewState(row({ interval_days: 3 }), true, NOW);
    expect(u.action).toBe("upsert");
    if (u.action !== "upsert") return;
    expect(u.row.interval_days).toBe(8); // ceil(3 × 2.5)
    expect(u.row.review_count).toBe(1);
    expect(u.row.lapses).toBe(0);
    expect(u.row.last_reviewed_at).toBe(NOW.toISOString());
    expect(daysFromNow(u.row.due_at)).toBe(8);
  });

  it("does not advance on a correct answer before the question is due", () => {
    const notDue = row({ due_at: new Date(NOW.getTime() + 3 * DAY).toISOString() });
    expect(nextMcqReviewState(notDue, true, NOW)).toEqual({ action: "none" });
  });

  it("resets the interval and lowers ease on a wrong answer, due or not", () => {
    const notDue = row({
      interval_days: 20,
      due_at: new Date(NOW.getTime() + 10 * DAY).toISOString(),
      lapses: 1,
      review_count: 4,
    });
    const u = nextMcqReviewState(notDue, false, NOW);
    expect(u.action).toBe("upsert");
    if (u.action !== "upsert") return;
    expect(u.row.interval_days).toBe(1);
    expect(u.row.ease_factor).toBeCloseTo(2.3);
    expect(u.row.lapses).toBe(2);
    expect(u.row.review_count).toBe(5);
    expect(daysFromNow(u.row.due_at)).toBe(1);
  });

  it("graduates the question once the next interval would pass the cap", () => {
    // 50 × 2.5 = 125 > GRADUATE_AFTER_DAYS
    expect(nextMcqReviewState(row({ interval_days: 50 }), true, NOW)).toEqual({
      action: "delete",
    });
    // 20 × 2.5 = 50 stays under the cap
    const u = nextMcqReviewState(row({ interval_days: 20 }), true, NOW);
    expect(u.action).toBe("upsert");
    if (u.action === "upsert") expect(u.row.interval_days).toBeLessThanOrEqual(GRADUATE_AFTER_DAYS);
  });

  it("walks a clean streak 1 → 3 → 8 → 20 → 50 → graduated", () => {
    let current: McqReviewRow | null = null;
    let now = NOW;
    const seen: number[] = [];
    let u = nextMcqReviewState(current, false, now);
    for (let i = 0; i < 10 && u.action === "upsert"; i++) {
      current = u.row;
      seen.push(current.interval_days);
      now = new Date(current.due_at);
      u = nextMcqReviewState(current, true, now);
    }
    expect(seen).toEqual([1, 3, 8, 20, 50]);
    expect(u.action).toBe("delete");
  });

  it("accepts ease_factor as a numeric string (Postgres numeric → PostgREST)", () => {
    const u = nextMcqReviewState(
      row({ ease_factor: "2.5" as unknown as number, interval_days: 3 }),
      true,
      NOW
    );
    expect(u.action === "upsert" && u.row.interval_days).toBe(8);
  });
});

describe("recordMcqReviewOutcome", () => {
  function mockClient(existing: McqReviewRow | null) {
    const upsert = vi.fn(() => Promise.resolve({ error: null }));
    const del = vi.fn();
    const client = {
      from: () => ({
        select: () => ({
          eq: () => ({
            eq: () => ({
              maybeSingle: () => Promise.resolve({ data: existing, error: null }),
            }),
          }),
        }),
        upsert,
        delete: () => {
          del();
          return { eq: () => ({ eq: () => Promise.resolve({ error: null }) }) };
        },
      }),
    };
    return { client, upsert, del };
  }

  it("upserts a new queue row for a wrong answer", async () => {
    const { client, upsert, del } = mockClient(null);
    await recordMcqReviewOutcome(client as never, "u1", "q1", false, NOW);
    expect(upsert).toHaveBeenCalledTimes(1);
    expect(upsert.mock.calls[0]).toMatchObject([
      { user_id: "u1", question_id: "q1", interval_days: 1 },
      { onConflict: "user_id,question_id" },
    ]);
    expect(del).not.toHaveBeenCalled();
  });

  it("writes nothing for a correct answer on an unqueued question", async () => {
    const { client, upsert, del } = mockClient(null);
    await recordMcqReviewOutcome(client as never, "u1", "q1", true, NOW);
    expect(upsert).not.toHaveBeenCalled();
    expect(del).not.toHaveBeenCalled();
  });

  it("deletes a graduated question", async () => {
    const { client, upsert, del } = mockClient(row({ interval_days: 50 }));
    await recordMcqReviewOutcome(client as never, "u1", "q1", true, NOW);
    expect(del).toHaveBeenCalledTimes(1);
    expect(upsert).not.toHaveBeenCalled();
  });

  it("swallows DB errors instead of throwing", async () => {
    const errSpy = vi.spyOn(console, "error").mockImplementation(() => {});
    const client = {
      from: () => ({
        select: () => ({
          eq: () => ({
            eq: () => ({
              maybeSingle: () => Promise.resolve({ data: null, error: { message: "boom" } }),
            }),
          }),
        }),
      }),
    };
    await expect(
      recordMcqReviewOutcome(client as never, "u1", "q1", false, NOW)
    ).resolves.toBeUndefined();
    errSpy.mockRestore();
  });
});
