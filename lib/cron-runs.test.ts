import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Supabase mock ────────────────────────────────────────────────────────────
// Every from() call builds a chain that records its method calls; awaiting it
// (or calling single/maybeSingle) asks `respond` for the result.

interface Call {
  table: string;
  ops: { method: string; args: unknown[] }[];
}
type Result = { data?: unknown; error?: unknown };

const calls: Call[] = [];
let respond: (call: Call) => Result | Promise<Result> = () => ({ data: null, error: null });
let createClientThrows = false;

function makeChain(table: string) {
  const call: Call = { table, ops: [] };
  calls.push(call);
  const resolve = () => Promise.resolve().then(() => respond(call));
  const chain: Record<string, unknown> = {};
  for (const m of ["select", "insert", "update", "upsert", "delete", "eq", "neq", "lt", "gte", "order", "limit"]) {
    chain[m] = (...args: unknown[]) => {
      call.ops.push({ method: m, args });
      return chain;
    };
  }
  for (const m of ["single", "maybeSingle"]) {
    chain[m] = () => {
      call.ops.push({ method: m, args: [] });
      return resolve();
    };
  }
  chain.then = (ok: (v: Result) => unknown, fail?: (e: unknown) => unknown) => resolve().then(ok, fail);
  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => {
    if (createClientThrows) throw new Error("no supabase env");
    return { from: (table: string) => makeChain(table) };
  },
}));

const { sendLineMessageMock } = vi.hoisted(() => ({
  sendLineMessageMock: vi.fn(async (..._args: unknown[]) => true),
}));
vi.mock("@/lib/line", () => ({ sendLineMessage: sendLineMessageMock }));

import {
  withCronRun,
  summarizeCronHealth,
  effectiveStatus,
  ALERT_THROTTLE_MS,
  RUN_ABANDONED_AFTER_MS,
  type CronRunRow,
} from "./cron-runs";

// ─── Helpers ──────────────────────────────────────────────────────────────────

const has = (c: Call, method: string) => c.ops.some((o) => o.method === method);
const arg = (c: Call, method: string) => c.ops.find((o) => o.method === method)?.args[0];

/** The finish write: the update of the run row by id (or the fallback insert). */
function finishCall(): Record<string, unknown> {
  const c = calls.find(
    (c) =>
      c.table === "cron_runs" &&
      ((has(c, "update") && c.ops.some((o) => o.method === "eq" && o.args[0] === "id")) ||
        (has(c, "insert") && !has(c, "single")))
  );
  expect(c, "finish write").toBeDefined();
  return arg(c!, has(c!, "update") ? "update" : "insert") as Record<string, unknown>;
}

const alertsSent = () => sendLineMessageMock.mock.calls.length;

function defaultRespond(call: Call): Result {
  if (call.table === "cron_runs" && has(call, "insert") && has(call, "single")) {
    return { data: { id: 42 }, error: null };
  }
  if (call.table === "cron_runs" && has(call, "update") && has(call, "lt")) {
    return { data: [], error: null }; // no abandoned runs
  }
  return { data: null, error: null };
}

beforeEach(() => {
  calls.length = 0;
  respond = defaultRespond;
  createClientThrows = false;
  sendLineMessageMock.mockClear();
  process.env.ADMIN_LINE_USER_ID = "Uadmin";
  vi.spyOn(console, "error").mockImplementation(() => {});
});

const req = () => new Request("http://localhost/api/cron/x");
const allow = () => true;

// ─── withCronRun ──────────────────────────────────────────────────────────────

describe("withCronRun", () => {
  it("records a running row, then ok with duration/http status/meta on 2xx", async () => {
    const handler = vi.fn(async () => Response.json({ ok: true, sent: 3 }));
    const res = await withCronRun<[Request]>("streak-nudge", handler, { authorize: allow })(req());

    expect(res.status).toBe(200);
    expect(await res.json()).toEqual({ ok: true, sent: 3 }); // body still readable
    expect(handler).toHaveBeenCalledOnce();

    const start = calls.find((c) => c.table === "cron_runs" && has(c, "single"))!;
    expect(arg(start, "insert")).toMatchObject({ job: "streak-nudge", status: "running" });

    const finish = finishCall();
    expect(finish).toMatchObject({ status: "ok", http_status: 200, error: null, meta: { ok: true, sent: 3 } });
    expect(typeof finish.duration_ms).toBe("number");
    expect(alertsSent()).toBe(0);
  });

  it("marks non-2xx responses as errors, returns the original response and alerts", async () => {
    const original = Response.json({ error: "boom" }, { status: 500 });
    const res = await withCronRun<[Request]>("exam-watch", async () => original, { authorize: allow })(req());

    expect(res).toBe(original);
    expect(finishCall()).toMatchObject({ status: "error", http_status: 500, error: "boom" });
    expect(alertsSent()).toBe(1);
    const [to, messages] = sendLineMessageMock.mock.calls[0] as unknown as [string, { text: string }[]];
    expect(to).toBe("Uadmin");
    expect(messages[0].text).toContain("exam-watch");
  });

  it("records thrown errors and rethrows the original error", async () => {
    const boom = new Error("kaboom");
    const wrapped = withCronRun<[Request]>("ads-autofix", async () => { throw boom; }, { authorize: allow });

    await expect(wrapped(req())).rejects.toBe(boom);
    expect(finishCall()).toMatchObject({ status: "error", http_status: null, error: "kaboom" });
    expect(alertsSent()).toBe(1);
  });

  it("does not log a run when authorize fails", async () => {
    const handler = vi.fn(async () => Response.json({ ok: true }));
    const res = await withCronRun<[Request]>("exam-watch", handler, { authorize: () => false })(req());

    expect(res.status).toBe(401);
    expect(handler).not.toHaveBeenCalled();
    expect(calls).toHaveLength(0);
    expect(alertsSent()).toBe(0);
  });

  it("never breaks the cron when logging fails", async () => {
    respond = (call) => {
      if (call.table === "cron_runs") throw new Error("db down");
      return { data: null, error: null };
    };
    const res = await withCronRun<[Request]>("board-gen", async () => Response.json({ ok: true }), { authorize: allow })(req());
    expect(res.status).toBe(200);
    expect(console.error).toHaveBeenCalled();
  });

  it("never breaks the cron when the admin client can't be created", async () => {
    createClientThrows = true;
    const res = await withCronRun<[Request]>("board-gen", async () => Response.json({ ok: true }))(req());
    expect(res.status).toBe(200);
  });

  it("returns supabase error objects as swallowed failures too", async () => {
    respond = (call) =>
      call.table === "cron_runs" ? { data: null, error: { message: "relation does not exist" } } : { data: null, error: null };
    const res = await withCronRun<[Request]>("board-gen", async () => Response.json({ ok: true }))(req());
    expect(res.status).toBe(200);
    // Start insert failed → finish falls back to inserting a complete row.
    expect(finishCall()).toMatchObject({ job: "board-gen", status: "ok" });
  });

  it("throttles alerts per job", async () => {
    respond = (call) => {
      if (call.table === "app_settings" && has(call, "maybeSingle")) {
        return { data: { value: new Date(Date.now() - ALERT_THROTTLE_MS / 2).toISOString() }, error: null };
      }
      return defaultRespond(call);
    };
    await withCronRun<[Request]>("board-gen", async () => new Response("x", { status: 502 }), { authorize: allow })(req());
    expect(finishCall()).toMatchObject({ status: "error", error: "HTTP 502" });
    expect(alertsSent()).toBe(0);
  });

  it("alerts again once the throttle window has passed", async () => {
    respond = (call) => {
      if (call.table === "app_settings" && has(call, "maybeSingle")) {
        return { data: { value: new Date(Date.now() - ALERT_THROTTLE_MS - 1000).toISOString() }, error: null };
      }
      return defaultRespond(call);
    };
    await withCronRun<[Request]>("board-gen", async () => new Response("x", { status: 502 }), { authorize: allow })(req());
    expect(alertsSent()).toBe(1);
    const upsert = calls.find((c) => c.table === "app_settings" && has(c, "upsert"))!;
    expect(arg(upsert, "upsert")).toMatchObject({ key: "cron_alert_sent_at:board-gen" });
  });

  it("sweeps abandoned (timed-out) runs of the same job and alerts", async () => {
    respond = (call) => {
      if (call.table === "cron_runs" && has(call, "update") && has(call, "lt")) {
        return { data: [{ id: 7, started_at: "2026-09-24T12:00:00Z" }], error: null };
      }
      return defaultRespond(call);
    };
    const res = await withCronRun<[Request]>("streak-nudge", async () => Response.json({ ok: true }), { authorize: allow })(req());
    expect(res.status).toBe(200);
    const sweep = calls.find((c) => c.table === "cron_runs" && has(c, "lt"))!;
    expect(arg(sweep, "update")).toMatchObject({ status: "error" });
    expect(sweep.ops.filter((o) => o.method === "eq").map((o) => o.args)).toEqual([
      ["job", "streak-nudge"],
      ["status", "running"],
    ]);
    expect(alertsSent()).toBe(1);
  });

  it("skips the LINE alert when ADMIN_LINE_USER_ID is unset", async () => {
    delete process.env.ADMIN_LINE_USER_ID;
    await withCronRun<[Request]>("exam-watch", async () => new Response(null, { status: 500 }))(req());
    expect(alertsSent()).toBe(0);
  });
});

// ─── Health summary ───────────────────────────────────────────────────────────

const NOW = new Date("2026-09-25T06:00:00Z");
const minsAgo = (m: number) => new Date(NOW.getTime() - m * 60_000).toISOString();

function row(p: Partial<CronRunRow> & Pick<CronRunRow, "job" | "started_at">): CronRunRow {
  return {
    id: 1,
    finished_at: null,
    duration_ms: null,
    status: "ok",
    http_status: 200,
    error: null,
    ...p,
  };
}

describe("effectiveStatus", () => {
  it("treats long-running rows as timeouts", () => {
    expect(effectiveStatus({ status: "running", started_at: minsAgo(1) }, NOW)).toBe("running");
    const old = new Date(NOW.getTime() - RUN_ABANDONED_AFTER_MS - 1000).toISOString();
    expect(effectiveStatus({ status: "running", started_at: old }, NOW)).toBe("timeout");
    expect(effectiveStatus({ status: "error", started_at: old }, NOW)).toBe("error");
  });
});

describe("summarizeCronHealth", () => {
  const jobs = [
    { job: "daily", path: "/api/cron/daily", schedule: "0 12 * * *" },
    { job: "quarter", path: "/api/cron/quarter", schedule: "*/15 * * * *" },
    { job: "never", path: "/api/cron/never", schedule: "0 1 * * 1" },
  ];

  it("flags stale jobs, counts 24h failures incl. timeouts, and leaves never-run jobs unflagged", () => {
    const latest = new Map<string, CronRunRow>([
      ["daily", row({ job: "daily", started_at: minsAgo(60 * 20), status: "error", error: "HTTP 500" })],
      ["quarter", row({ job: "quarter", started_at: minsAgo(40) })],
    ]);
    const recent = [
      row({ job: "daily", started_at: minsAgo(60 * 20), status: "error", error: "HTTP 500" }),
      row({ job: "daily", started_at: minsAgo(60 * 22), status: "running" }), // killed → timeout
      row({ job: "quarter", started_at: minsAgo(2), status: "running" }), // in flight, not a failure
    ];
    const [daily, quarter, never] = summarizeCronHealth(latest, recent, NOW, jobs);

    expect(daily).toMatchObject({ stale: false, failures24h: 2, lastError: "HTTP 500", lastStatus: "error" });
    expect(quarter).toMatchObject({ stale: true, failures24h: 0, lastStatus: "ok", staleAfterMinutes: 25 });
    expect(never).toMatchObject({ stale: false, lastRun: null, lastStatus: null, failures24h: 0 });
  });

  it("marks a daily job stale after ~30h", () => {
    const latest = new Map([["daily", row({ job: "daily", started_at: minsAgo(60 * 31) })]]);
    const [daily] = summarizeCronHealth(latest, [], NOW, jobs);
    expect(daily.stale).toBe(true);
    expect(daily.staleAfterMinutes).toBe(1440 + 360);
  });
});
