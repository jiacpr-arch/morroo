/**
 * Unit tests for the DM-reminder leg of the lead follow-up cron.
 * We focus on the LINE / Messenger paths added in Phase 3 and the auth gate.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Channel mocks ────────────────────────────────────────────────────────────

const sendLineMessageMock = vi.fn(async () => true);
const sendFbMessageMock = vi.fn(async () => true);
const sendEmailMock = vi.fn(async () => {});

vi.mock("@/lib/line", () => ({ sendLineMessage: sendLineMessageMock }));
vi.mock("@/lib/facebook-messenger", () => ({ sendFbMessage: sendFbMessageMock }));
vi.mock("@/lib/email/send", () => ({ sendLeadFollowupEmail: sendEmailMock }));

// ─── Supabase mock ────────────────────────────────────────────────────────────
// Each supabase.from() call pops one result from the queue.
// We make the chain itself a thenable so ANY terminal method (lt, eq, in, …)
// correctly resolves to the queued result when awaited.

type QueueResult = { data: unknown; error: null };
const resultQueue: QueueResult[] = [];

function makeChain(result: QueueResult) {
  // The chain is a Proxy: every property access returns the chain itself, so
  // arbitrary method call sequences (eq/lt/in/not/…) all return the same
  // chainable object.  Awaiting it resolves to `result` via `.then`.
  const chain: Record<string, unknown> = {};
  const self = () => chain;

  // Terminal methods that return an explicit Promise (maybeSingle, single)
  chain.maybeSingle = vi.fn(() => Promise.resolve(result));
  chain.single = vi.fn(() => Promise.resolve(result));
  chain.insert = vi.fn(() => Promise.resolve({ error: null }));

  // Make `await chain` work (PromiseLike interface).
  chain.then = (
    onFulfilled: (v: QueueResult) => unknown,
    onRejected?: (e: unknown) => unknown
  ) => Promise.resolve(result).then(onFulfilled, onRejected);

  // All filter / ordering methods just return `chain` (chainable + thenable).
  for (const m of [
    "select", "eq", "neq", "not", "in", "is", "gt", "gte", "lt", "lte",
    "or", "order", "limit", "range", "single",
  ]) {
    if (!(m in chain)) chain[m] = vi.fn(self);
  }

  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: vi.fn(() => makeChain(resultQueue.shift() ?? { data: null, error: null })),
  }),
}));

// ─── Helpers ──────────────────────────────────────────────────────────────────

const NOW_MS = new Date("2026-05-10T12:00:00Z").getTime();

function makeRequest(secret = "test-secret") {
  return new Request(`http://localhost/api/cron/lead-followup?secret=${secret}`);
}

// ─── Tests ────────────────────────────────────────────────────────────────────

describe("lead-followup cron", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    resultQueue.length = 0;
    process.env.BLOG_GENERATE_SECRET = "test-secret";
    process.env.LINE_CHANNEL_ACCESS_TOKEN = "fake-line-token";
    process.env.FACEBOOK_PAGE_TOKEN = "fake-fb-token";
    vi.setSystemTime(NOW_MS);
  });

  it("returns 401 without a valid secret", async () => {
    const { GET } = await import("./route");
    const res = await GET(makeRequest("wrong-secret"));
    expect(res.status).toBe(401);
  });

  it("returns ok:true with dm_sent=0 when there are no leads", async () => {
    // Email loop: 3 days × 1 query → empty
    for (let i = 0; i < 3; i++) resultQueue.push({ data: [], error: null });
    // DM loop: 3 days × 1 codes query → empty
    for (let i = 0; i < 3; i++) resultQueue.push({ data: [], error: null });

    const { GET } = await import("./route");
    const res = await GET(makeRequest());
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json.ok).toBe(true);
    expect(json.dm_sent).toBe(0);
  });

  it("sends a LINE DM and records the dedupe row for a D1 lead", async () => {
    const D1_CODE = "MORROO-TEST-D1AB";
    const LEAD_ID = "lead-line-d1";
    const LINE_UID = "U-line-abc";

    // Email loop: 3 × empty
    for (let i = 0; i < 3; i++) resultQueue.push({ data: [], error: null });

    // DM D1: codes query → one code
    resultQueue.push({
      data: [{
        code: D1_CODE,
        reward_type: "monthly_1m",
        expires_at: new Date(NOW_MS + 6 * 86400_000).toISOString(),
        lead_id: LEAD_ID,
      }],
      error: null,
    });
    // DM D1: leads batch query → lead with LINE uid
    resultQueue.push({
      data: [{ id: LEAD_ID, fb_psid: null, line_user_id: LINE_UID, name: "Dr Test" }],
      error: null,
    });
    // DM D1: dedupe check → not sent yet
    resultQueue.push({ data: null, error: null });
    // DM D3 + D6: empty codes
    resultQueue.push({ data: [], error: null });
    resultQueue.push({ data: [], error: null });

    const { GET } = await import("./route");
    const res = await GET(makeRequest());
    const json = await res.json();

    expect(json.ok).toBe(true);
    expect(json.dm_sent).toBe(1);
    expect(json.dm_skipped).toBe(0);

    expect(sendLineMessageMock).toHaveBeenCalledOnce();
    const lineCall = sendLineMessageMock.mock.calls[0] as unknown as [string, Array<{ text: string }>];
    expect(lineCall[0]).toBe(LINE_UID);
    expect(lineCall[1][0].text).toContain(D1_CODE);
    expect(lineCall[1][0].text).toContain("morroo.com/register");
    expect(sendFbMessageMock).not.toHaveBeenCalled();
  });

  it("falls back to Messenger when the lead has no line_user_id", async () => {
    const D1_CODE = "MORROO-TEST-FBBB";
    const PSID = "psid-fb-d1";

    for (let i = 0; i < 3; i++) resultQueue.push({ data: [], error: null });
    resultQueue.push({
      data: [{
        code: D1_CODE,
        reward_type: "monthly_1m",
        expires_at: new Date(NOW_MS + 6 * 86400_000).toISOString(),
        lead_id: "lead-fb",
      }],
      error: null,
    });
    resultQueue.push({
      data: [{ id: "lead-fb", fb_psid: PSID, line_user_id: null, name: null }],
      error: null,
    });
    resultQueue.push({ data: null, error: null }); // dedupe → not sent
    resultQueue.push({ data: [], error: null });   // D3
    resultQueue.push({ data: [], error: null });   // D6

    const { GET } = await import("./route");
    const res = await GET(makeRequest());
    const json = await res.json();

    expect(json.dm_sent).toBe(1);
    expect(sendFbMessageMock).toHaveBeenCalledOnce();
    const fbCall = sendFbMessageMock.mock.calls[0] as unknown as [string, string];
    expect(fbCall[0]).toBe(PSID);
    expect(fbCall[1]).toContain(D1_CODE);
    expect(sendLineMessageMock).not.toHaveBeenCalled();
  });

  it("skips a lead that already received a DM for this day", async () => {
    for (let i = 0; i < 3; i++) resultQueue.push({ data: [], error: null });
    resultQueue.push({
      data: [{
        code: "MORROO-SKIP-THIS",
        reward_type: "monthly_1m",
        expires_at: new Date(NOW_MS + 6 * 86400_000).toISOString(),
        lead_id: "lead-skip",
      }],
      error: null,
    });
    resultQueue.push({
      data: [{ id: "lead-skip", fb_psid: null, line_user_id: "U-skip", name: null }],
      error: null,
    });
    // dedupe → already sent
    resultQueue.push({ data: { lead_id: "lead-skip" }, error: null });
    resultQueue.push({ data: [], error: null });
    resultQueue.push({ data: [], error: null });

    const { GET } = await import("./route");
    const res = await GET(makeRequest());
    const json = await res.json();

    expect(json.dm_sent).toBe(0);
    expect(json.dm_skipped).toBe(1);
    expect(sendLineMessageMock).not.toHaveBeenCalled();
  });
});
