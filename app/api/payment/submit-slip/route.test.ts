/**
 * Route tests for POST /api/payment/submit-slip — auth, ownership, dedupe,
 * auto-approve vs manual-review branching.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Mocks ────────────────────────────────────────────────────────────────────

const {
  afterCallbacks,
  getUserMock,
  verifySlipMock,
  fulfillSlipOrderMock,
  sendFulfillmentNotificationsMock,
  notifyAdminPendingSlipMock,
  resultQueue,
  insertMock,
  downloadMock,
} = vi.hoisted(() => ({
  afterCallbacks: [] as Array<() => unknown>,
  getUserMock: vi.fn(),
  verifySlipMock: vi.fn(),
  fulfillSlipOrderMock: vi.fn(),
  sendFulfillmentNotificationsMock: vi.fn(async () => {}),
  notifyAdminPendingSlipMock: vi.fn(async () => {}),
  resultQueue: [] as Array<{ data: unknown; error: unknown }>,
  insertMock: vi.fn(),
  downloadMock: vi.fn(),
}));

vi.mock("next/server", async (importOriginal) => {
  const actual = await importOriginal<typeof import("next/server")>();
  return {
    ...actual,
    after: (fn: () => unknown) => {
      afterCallbacks.push(fn);
    },
  };
});

vi.mock("@/lib/supabase/server", () => ({
  createClient: async () => ({ auth: { getUser: getUserMock } }),
}));

vi.mock("@/lib/slip-verify", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/slip-verify")>();
  return { ...actual, verifySlip: verifySlipMock };
});

vi.mock("@/lib/billing/fulfill-slip-order", () => ({
  fulfillSlipOrder: fulfillSlipOrderMock,
}));

vi.mock("@/lib/billing/send-fulfillment-notifications", () => ({
  sendFulfillmentNotifications: sendFulfillmentNotificationsMock,
}));

vi.mock("@/lib/notifications", () => ({
  notifyAdminPendingSlip: notifyAdminPendingSlipMock,
}));

vi.mock("@/lib/rate-limit", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/rate-limit")>();
  return {
    ...actual,
    checkRateLimit: vi.fn(async () => ({
      allowed: true,
      count: 1,
      remaining: 4,
      reset_at: new Date().toISOString(),
    })),
  };
});

// Admin supabase mock: from() pops one result per call from a queue; storage
// download is configurable per test.
type QueueResult = { data: unknown; error: unknown };

function makeChain(result: QueueResult) {
  const chain: Record<string, unknown> = {};
  const self = () => chain;
  chain.maybeSingle = vi.fn(() => Promise.resolve(result));
  chain.single = vi.fn(() => Promise.resolve(result));
  chain.insert = insertMock.mockImplementation(() => {
    // insert(...).select(...).single() resolves to the queued result too
    const sub: Record<string, unknown> = {};
    sub.select = vi.fn(() => sub);
    sub.single = vi.fn(() => Promise.resolve(result));
    sub.then = (
      onFulfilled: (v: QueueResult) => unknown,
      onRejected?: (e: unknown) => unknown
    ) => Promise.resolve(result).then(onFulfilled, onRejected);
    return sub;
  });
  chain.then = (
    onFulfilled: (v: QueueResult) => unknown,
    onRejected?: (e: unknown) => unknown
  ) => Promise.resolve(result).then(onFulfilled, onRejected);
  for (const m of ["select", "eq", "neq", "in", "order", "limit"]) {
    if (!(m in chain)) chain[m] = vi.fn(self);
  }
  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: vi.fn(() => makeChain(resultQueue.shift() ?? { data: null, error: null })),
    storage: { from: vi.fn(() => ({ download: downloadMock })) },
  }),
}));

import { POST } from "./route";

// ─── Helpers ──────────────────────────────────────────────────────────────────

const USER_ID = "11111111-2222-3333-4444-555555555555";

function makeRequest(body: unknown) {
  return new Request("http://localhost/api/payment/submit-slip", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
    // NextRequest is assignable from Request for our purposes in tests
  }) as unknown as import("next/server").NextRequest;
}

function loginAs(userId: string | null) {
  getUserMock.mockResolvedValue({
    data: { user: userId ? { id: userId, email: "user@test.com" } : null },
  });
}

const VERIFIED_SLIP = {
  ok: true as const,
  provider: "easyslip",
  slip: {
    transRef: "TXREF001",
    transTimestamp: new Date().toISOString(),
    amount: 199,
    receiverBankCode: "004",
    receiverAccountMasked: "xxx-x-x6394-x",
    receiverNameTh: "บจก. เจี่ยรักษา",
    senderNameTh: "ผู้โอน",
    raw: {},
  },
};

async function flushAfter() {
  for (const cb of afterCallbacks.splice(0)) await cb();
}

// ─── Tests ────────────────────────────────────────────────────────────────────

describe("POST /api/payment/submit-slip", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    resultQueue.length = 0;
    afterCallbacks.length = 0;
    downloadMock.mockResolvedValue({
      data: new Blob([Buffer.from("img")], { type: "image/jpeg" }),
      error: null,
    });
    process.env.SLIP_RECEIVER_BANK_CODE = "004";
    process.env.SLIP_RECEIVER_ACCOUNT_ID = "4392763940";
  });

  it("returns 401 when unauthenticated", async () => {
    loginAs(null);
    const res = await POST(makeRequest({ plan: "monthly", storagePath: "x/y.jpg" }));
    expect(res.status).toBe(401);
  });

  it("returns 400 for an unknown plan", async () => {
    loginAs(USER_ID);
    const res = await POST(
      makeRequest({ plan: "diamond", storagePath: `${USER_ID}/1.jpg` })
    );
    expect(res.status).toBe(400);
  });

  it("returns 403 when the storage path belongs to someone else", async () => {
    loginAs(USER_ID);
    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: "someone-else/1.jpg" })
    );
    expect(res.status).toBe(403);
  });

  it("short-circuits when a pending order for the same plan exists", async () => {
    loginAs(USER_ID);
    resultQueue.push({ data: { id: "existing-order" }, error: null }); // pending pre-check
    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );
    const body = await res.json();
    expect(body).toEqual({ status: "pending_review", duplicate: true });
    expect(verifySlipMock).not.toHaveBeenCalled();
  });

  it("auto-approves a verified slip that passes validation", async () => {
    loginAs(USER_ID);
    verifySlipMock.mockResolvedValue(VERIFIED_SLIP);
    fulfillSlipOrderMock.mockResolvedValue({
      alreadyProcessed: false,
      notify: { expiresAt: new Date("2026-08-27"), buyerLineUserId: null },
    });
    resultQueue.push({ data: null, error: null }); // pending pre-check: none
    resultQueue.push({ data: { name: "ลูกค้า", email: "user@test.com" }, error: null }); // profile
    resultQueue.push({ data: { id: "new-order-id" }, error: null }); // insert

    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );
    const body = await res.json();

    expect(body.status).toBe("approved");
    expect(fulfillSlipOrderMock).toHaveBeenCalledWith({
      orderId: "new-order-id",
      reviewedBy: null,
    });
    await flushAfter();
    expect(sendFulfillmentNotificationsMock).toHaveBeenCalled();
    expect(notifyAdminPendingSlipMock).not.toHaveBeenCalled();
  });

  it("keeps the order pending and notifies admin when validation fails", async () => {
    loginAs(USER_ID);
    verifySlipMock.mockResolvedValue({
      ...VERIFIED_SLIP,
      slip: { ...VERIFIED_SLIP.slip, amount: 50 }, // underpaid
    });
    resultQueue.push({ data: null, error: null }); // pending pre-check
    resultQueue.push({ data: { name: "ลูกค้า", email: "user@test.com" }, error: null }); // profile
    resultQueue.push({ data: { id: "new-order-id" }, error: null }); // insert

    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );
    const body = await res.json();

    expect(body).toMatchObject({ status: "pending_review", reason: "amount_mismatch" });
    expect(fulfillSlipOrderMock).not.toHaveBeenCalled();
    await flushAfter();
    expect(notifyAdminPendingSlipMock).toHaveBeenCalled();
  });

  it("returns 409 duplicate_slip on a trans_ref unique violation", async () => {
    loginAs(USER_ID);
    verifySlipMock.mockResolvedValue(VERIFIED_SLIP);
    resultQueue.push({ data: null, error: null }); // pending pre-check
    resultQueue.push({ data: { name: "ลูกค้า", email: "user@test.com" }, error: null }); // profile
    resultQueue.push({ data: null, error: { code: "23505", message: "duplicate" } }); // insert

    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );

    expect(res.status).toBe(409);
    const body = await res.json();
    expect(body.error).toBe("duplicate_slip");
    expect(fulfillSlipOrderMock).not.toHaveBeenCalled();
  });

  it("falls back to manual review when the provider is not configured", async () => {
    loginAs(USER_ID);
    verifySlipMock.mockResolvedValue({ ok: false, reason: "not_configured" });
    resultQueue.push({ data: null, error: null }); // pending pre-check
    resultQueue.push({ data: { name: "ลูกค้า", email: "user@test.com" }, error: null }); // profile
    resultQueue.push({ data: null, error: null }); // insert (no select)

    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );
    const body = await res.json();

    expect(body).toMatchObject({ status: "pending_review", reason: "not_configured" });
    expect(fulfillSlipOrderMock).not.toHaveBeenCalled();
    await flushAfter();
    expect(notifyAdminPendingSlipMock).toHaveBeenCalled();
  });

  it("returns 400 when the slip is missing from storage", async () => {
    loginAs(USER_ID);
    downloadMock.mockResolvedValue({ data: null, error: { message: "not found" } });
    resultQueue.push({ data: null, error: null }); // pending pre-check

    const res = await POST(
      makeRequest({ plan: "monthly", storagePath: `${USER_ID}/1.jpg` })
    );
    expect(res.status).toBe(400);
  });
});
