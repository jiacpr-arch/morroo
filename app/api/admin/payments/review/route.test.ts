/**
 * Route tests for POST /api/admin/payments/review — admin gate, approve
 * fulfillment, reject notifications, non-pending 409.
 */
import { describe, it, expect, vi, beforeEach } from "vitest";
import { NextResponse } from "next/server";

// ─── Mocks ────────────────────────────────────────────────────────────────────

const {
  afterCallbacks,
  requireAdminMock,
  fulfillSlipOrderMock,
  sendFulfillmentNotificationsMock,
  sendLineMessageMock,
  sendPaymentRejectedEmailMock,
  resultQueue,
} = vi.hoisted(() => ({
  afterCallbacks: [] as Array<() => unknown>,
  requireAdminMock: vi.fn(),
  fulfillSlipOrderMock: vi.fn(),
  sendFulfillmentNotificationsMock: vi.fn(async () => {}),
  sendLineMessageMock: vi.fn(async () => true),
  sendPaymentRejectedEmailMock: vi.fn(async () => ({ id: "email" })),
  resultQueue: [] as Array<{ data: unknown; error: unknown }>,
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

vi.mock("@/lib/admin-auth", () => ({ requireAdmin: requireAdminMock }));

vi.mock("@/lib/billing/fulfill-slip-order", () => ({
  fulfillSlipOrder: fulfillSlipOrderMock,
}));

vi.mock("@/lib/billing/send-fulfillment-notifications", () => ({
  sendFulfillmentNotifications: sendFulfillmentNotificationsMock,
}));

vi.mock("@/lib/line", () => ({ sendLineMessage: sendLineMessageMock }));

vi.mock("@/lib/email/send", () => ({
  sendPaymentRejectedEmail: sendPaymentRejectedEmailMock,
}));

type QueueResult = { data: unknown; error: unknown };

function makeChain(result: QueueResult) {
  const chain: Record<string, unknown> = {};
  const self = () => chain;
  chain.maybeSingle = vi.fn(() => Promise.resolve(result));
  chain.single = vi.fn(() => Promise.resolve(result));
  chain.then = (
    onFulfilled: (v: QueueResult) => unknown,
    onRejected?: (e: unknown) => unknown
  ) => Promise.resolve(result).then(onFulfilled, onRejected);
  for (const m of ["select", "eq", "update", "insert", "order", "limit"]) {
    if (!(m in chain)) chain[m] = vi.fn(self);
  }
  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: vi.fn(() => makeChain(resultQueue.shift() ?? { data: null, error: null })),
  }),
}));

import { POST } from "./route";

// ─── Helpers ──────────────────────────────────────────────────────────────────

const ADMIN_ID = "admin-user-id";
const PENDING_ORDER = {
  id: "order-1",
  user_id: "buyer-1",
  plan_type: "monthly",
  amount: 199,
  status: "pending",
};

function makeRequest(body: unknown) {
  return new Request("http://localhost/api/admin/payments/review", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  }) as unknown as import("next/server").NextRequest;
}

async function flushAfter() {
  for (const cb of afterCallbacks.splice(0)) await cb();
}

// ─── Tests ────────────────────────────────────────────────────────────────────

describe("POST /api/admin/payments/review", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    resultQueue.length = 0;
    afterCallbacks.length = 0;
    requireAdminMock.mockResolvedValue({ ok: true, userId: ADMIN_ID });
  });

  it("blocks non-admins with the guard's response", async () => {
    requireAdminMock.mockResolvedValue({
      ok: false,
      response: NextResponse.json({ error: "Admin only" }, { status: 403 }),
    });
    const res = await POST(makeRequest({ orderId: "order-1", action: "approve" }));
    expect(res.status).toBe(403);
  });

  it("returns 400 for a bad action", async () => {
    const res = await POST(makeRequest({ orderId: "order-1", action: "maybe" }));
    expect(res.status).toBe(400);
  });

  it("returns 404 when the order does not exist", async () => {
    resultQueue.push({ data: null, error: null });
    const res = await POST(makeRequest({ orderId: "missing", action: "approve" }));
    expect(res.status).toBe(404);
  });

  it("returns 409 when the order was already reviewed", async () => {
    resultQueue.push({ data: { ...PENDING_ORDER, status: "approved" }, error: null });
    const res = await POST(makeRequest({ orderId: "order-1", action: "approve" }));
    expect(res.status).toBe(409);
  });

  it("approve → fulfills with the admin as reviewer and fires notifications", async () => {
    resultQueue.push({ data: PENDING_ORDER, error: null }); // order lookup
    fulfillSlipOrderMock.mockResolvedValue({
      alreadyProcessed: false,
      notify: { expiresAt: new Date("2026-08-27"), buyerLineUserId: "U123" },
    });

    const res = await POST(makeRequest({ orderId: "order-1", action: "approve" }));
    const body = await res.json();

    expect(body.status).toBe("approved");
    expect(fulfillSlipOrderMock).toHaveBeenCalledWith({
      orderId: "order-1",
      reviewedBy: ADMIN_ID,
    });
    await flushAfter();
    expect(sendFulfillmentNotificationsMock).toHaveBeenCalled();
  });

  it("reject → records reason and notifies the buyer via LINE and email", async () => {
    resultQueue.push({ data: PENDING_ORDER, error: null }); // order lookup
    resultQueue.push({ data: [{ id: "order-1" }], error: null }); // reject update
    resultQueue.push({
      data: { name: "ณัฐภัทร", email: "buyer@test.com", line_user_id: "U999" },
      error: null,
    }); // buyer profile

    const res = await POST(
      makeRequest({ orderId: "order-1", action: "reject", note: "ยอดโอนไม่ตรง" })
    );
    const body = await res.json();

    expect(body.status).toBe("rejected");
    expect(fulfillSlipOrderMock).not.toHaveBeenCalled();

    await flushAfter();
    expect(sendLineMessageMock).toHaveBeenCalledWith(
      "U999",
      expect.arrayContaining([
        expect.objectContaining({ type: "text", text: expect.stringContaining("ยอดโอนไม่ตรง") }),
      ])
    );
    expect(sendPaymentRejectedEmailMock).toHaveBeenCalledWith(
      expect.objectContaining({ email: "buyer@test.com", reason: "ยอดโอนไม่ตรง" })
    );
  });

  it("reject skips LINE when the buyer has no line_user_id but still emails", async () => {
    resultQueue.push({ data: PENDING_ORDER, error: null });
    resultQueue.push({ data: [{ id: "order-1" }], error: null });
    resultQueue.push({
      data: { name: "ลูกค้า", email: "buyer@test.com", line_user_id: null },
      error: null,
    });

    const res = await POST(makeRequest({ orderId: "order-1", action: "reject" }));
    expect((await res.json()).status).toBe("rejected");

    await flushAfter();
    expect(sendLineMessageMock).not.toHaveBeenCalled();
    expect(sendPaymentRejectedEmailMock).toHaveBeenCalled();
  });
});
