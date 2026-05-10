import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Supabase mock (queue-based) ──────────────────────────────────────────────
// Each test pushes the responses it expects in the exact order the function
// consumes them.  Terminal methods (maybeSingle / chain.then / update().eq /
// insert) all pop one response off the front of the queue.

const responseQueue: Array<unknown> = [];

function nextResponse(): unknown {
  return responseQueue.shift() ?? { data: null, error: null };
}

const insertCalls: Array<Record<string, unknown>> = [];

function makeBuilder() {
  const chain: Record<string, unknown> = {};
  for (const m of ["select", "eq", "is", "gt", "lt", "gte", "lte", "not", "in", "order", "limit"]) {
    chain[m] = vi.fn(() => chain);
  }
  chain.maybeSingle = vi.fn(() => Promise.resolve(nextResponse()));
  chain.single = vi.fn(() => Promise.resolve(nextResponse()));
  // Awaiting the chain itself (count queries that end with .eq()) consumes a response.
  chain.then = (resolve: (v: unknown) => unknown, reject?: (e: unknown) => unknown) =>
    Promise.resolve(nextResponse()).then(resolve, reject);
  chain.update = vi.fn(() => ({
    eq: vi.fn(() => Promise.resolve(nextResponse())),
  }));
  chain.insert = vi.fn((payload: Record<string, unknown>) => {
    insertCalls.push(payload);
    return chain;
  });
  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({ from: vi.fn(() => makeBuilder()) }),
}));

// ─── issueRedeemCode mock ─────────────────────────────────────────────────────

let issueResult: { code: string } | Error = { code: "MORROO-ABCD-1234" };

vi.mock("@/lib/redeem", () => ({
  issueRedeemCode: vi.fn(async () => {
    if (issueResult instanceof Error) throw issueResult;
    return issueResult;
  }),
}));

import { handleBotIntent, detectEmail, handleEmailCapture } from "./bot-intent";

beforeEach(() => {
  responseQueue.length = 0;
  insertCalls.length = 0;
  issueResult = { code: "MORROO-ABCD-1234" };
});

// Helpers to push a typical "issue new code" response sequence.
// Order consumed by handleBotIntent on the issuance happy path:
//   1. lead lookup (maybeSingle)
//   2. active code lookup (maybeSingle) — null = no active code
//   3. count query (chain.then) — current count of codes for this lead
//   4. stage update (update().eq)
function pushIssueFlow(opts: {
  leadStage?: string;
  leadEmail?: string | null;
  existingCount?: number;
  stageUpdateError?: { message: string } | null;
}) {
  responseQueue.push({
    data: { stage: opts.leadStage ?? "new", email: opts.leadEmail ?? null },
    error: null,
  });
  responseQueue.push({ data: null, error: null }); // no active code
  responseQueue.push({ count: opts.existingCount ?? 0, error: null });
  responseQueue.push({ error: opts.stageUpdateError ?? null });
}

// ─── handleBotIntent: first-time issuance ─────────────────────────────────────

describe("handleBotIntent — issue new code", () => {
  it("issues a code and returns the welcome message for a new lead", async () => {
    pushIssueFlow({});
    const msg = await handleBotIntent("lead-1", "trial", "facebook");

    expect(msg).not.toBeNull();
    expect(msg).toContain("MORROO-ABCD-1234");
    expect(msg).toContain("morroo.com/register");
  });

  it("uses fb_messenger source for facebook channel", async () => {
    pushIssueFlow({});
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "facebook");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ source: "fb_messenger" })
    );
  });

  it("uses line_oa source for line channel", async () => {
    pushIssueFlow({});
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "line");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ source: "line_oa" })
    );
  });

  it("passes existing email to issueRedeemCode", async () => {
    pushIssueFlow({ leadEmail: "doctor@example.com" });
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "line");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ issuedToEmail: "doctor@example.com" })
    );
  });

  it("issues a code for a lead already at code_issued stage when no active code", async () => {
    // The whole point of Phase 4: re-request after expiry should still work.
    pushIssueFlow({ leadStage: "code_issued", existingCount: 1 });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).not.toBeNull();
    expect(msg).toContain("MORROO-ABCD-1234");
    // Reissue framing for non-first-time users.
    expect(msg).toContain("ออกโค้ด");
  });

  it("returns null but does not throw if issueRedeemCode throws", async () => {
    // Push lead + active-code + count, then issueRedeemCode will throw.
    responseQueue.push({ data: { stage: "new", email: null }, error: null });
    responseQueue.push({ data: null, error: null });
    responseQueue.push({ count: 0, error: null });
    issueResult = new Error("collision");
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("still returns the code message even if stage update fails", async () => {
    pushIssueFlow({ stageUpdateError: { message: "update failed" } });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).not.toBeNull();
    expect(msg).toContain("MORROO-ABCD-1234");
  });
});

// ─── handleBotIntent: blocking ────────────────────────────────────────────────

describe("handleBotIntent — blocked paths", () => {
  it("returns null if lead is at redeemed stage", async () => {
    responseQueue.push({ data: { stage: "redeemed", email: null }, error: null });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("returns null if lead is at paid stage", async () => {
    responseQueue.push({ data: { stage: "paid", email: null }, error: null });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("returns null if lead lookup errors", async () => {
    responseQueue.push({ data: null, error: { message: "db error" } });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("returns null if lead does not exist", async () => {
    responseQueue.push({ data: null, error: null });
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });
});

// ─── handleBotIntent: resend active code ──────────────────────────────────────

describe("handleBotIntent — resend active code", () => {
  it("resends the existing active code instead of issuing a new one", async () => {
    const ACTIVE_CODE = "MORROO-OLD1-2222";
    const expiresAt = new Date(Date.now() + 5 * 86400_000).toISOString();

    responseQueue.push({ data: { stage: "code_issued", email: null }, error: null });
    responseQueue.push({ data: { code: ACTIVE_CODE, expires_at: expiresAt }, error: null });

    const { issueRedeemCode } = await import("@/lib/redeem");
    const callsBefore = (issueRedeemCode as ReturnType<typeof vi.fn>).mock.calls.length;

    const msg = await handleBotIntent("lead-1", "trial", "facebook");

    expect(msg).not.toBeNull();
    expect(msg).toContain(ACTIVE_CODE);
    expect(msg).toContain("ยังใช้ได้");
    // No new code should have been issued.
    expect((issueRedeemCode as ReturnType<typeof vi.fn>).mock.calls.length).toBe(callsBefore);
  });
});

// ─── handleBotIntent: abuse cap ───────────────────────────────────────────────

describe("handleBotIntent — abuse cap", () => {
  it("returns the limit message once MAX_CODES_PER_LEAD is reached", async () => {
    responseQueue.push({ data: { stage: "code_issued", email: null }, error: null });
    responseQueue.push({ data: null, error: null }); // no active code
    responseQueue.push({ count: 3, error: null });   // already 3 codes issued

    const { issueRedeemCode } = await import("@/lib/redeem");
    const callsBefore = (issueRedeemCode as ReturnType<typeof vi.fn>).mock.calls.length;

    const msg = await handleBotIntent("lead-1", "trial", "facebook");

    expect(msg).not.toBeNull();
    expect(msg).toContain("ครบโควตา");
    expect(msg).toContain("morroo.com/pricing");
    expect((issueRedeemCode as ReturnType<typeof vi.fn>).mock.calls.length).toBe(callsBefore);
  });
});

// ─── detectEmail ─────────────────────────────────────────────────────────────

describe("detectEmail", () => {
  it("detects a plain email address", () => {
    expect(detectEmail("user@example.com")).toBe("user@example.com");
  });

  it("lowercases the email", () => {
    expect(detectEmail("User@Example.COM")).toBe("user@example.com");
  });

  it("returns null for a message that contains an email plus other text", () => {
    expect(detectEmail("my email is user@example.com")).toBeNull();
  });

  it("returns null for a non-email message", () => {
    expect(detectEmail("hello world")).toBeNull();
  });

  it("returns null for an empty string", () => {
    expect(detectEmail("")).toBeNull();
  });
});

// ─── handleEmailCapture ───────────────────────────────────────────────────────

describe("handleEmailCapture", () => {
  it("returns an acknowledgement when message is an email", async () => {
    responseQueue.push({ error: null });
    const ack = await handleEmailCapture("lead-1", "doc@example.com");
    expect(ack).not.toBeNull();
    expect(ack).toContain("บันทึกอีเมล");
  });

  it("returns null when message is not an email", async () => {
    const ack = await handleEmailCapture("lead-1", "สวัสดีครับ");
    expect(ack).toBeNull();
  });

  it("returns null when leadId is null", async () => {
    const ack = await handleEmailCapture(null, "user@example.com");
    expect(ack).toBeNull();
  });
});
