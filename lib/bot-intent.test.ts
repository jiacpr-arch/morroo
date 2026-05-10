import { describe, it, expect, vi, beforeEach } from "vitest";

// ─── Supabase mock ────────────────────────────────────────────────────────────

type QueryResult<T> = { data: T | null; error: { message: string; code?: string } | null };

let leadLookupResult: QueryResult<{ stage: string; email: string | null }> = {
  data: { stage: "new", email: null },
  error: null,
};
let stageUpdateError: { message: string } | null = null;
const insertCalls: Array<Record<string, unknown>> = [];

function makeBuilder() {
  const chain: Record<string, unknown> = {};
  chain.select = vi.fn(() => chain);
  chain.eq = vi.fn(() => chain);
  chain.maybeSingle = vi.fn(() => Promise.resolve(leadLookupResult));
  chain.update = vi.fn(() => ({
    eq: vi.fn(() => Promise.resolve({ error: stageUpdateError })),
  }));
  chain.insert = vi.fn((payload: Record<string, unknown>) => {
    insertCalls.push(payload);
    return { select: vi.fn(() => ({ single: vi.fn(() => Promise.resolve({ data: { id: "rc-1" }, error: null })) })) };
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
  leadLookupResult = { data: { stage: "new", email: null }, error: null };
  stageUpdateError = null;
  insertCalls.length = 0;
  issueResult = { code: "MORROO-ABCD-1234" };
});

// ─── handleBotIntent ──────────────────────────────────────────────────────────

describe("handleBotIntent", () => {
  it("issues a code and returns a message for a new lead", async () => {
    const msg = await handleBotIntent("lead-1", "trial", "facebook");

    expect(msg).not.toBeNull();
    expect(msg).toContain("MORROO-ABCD-1234");
    expect(msg).toContain("morroo.com/register");
  });

  it("uses fb_messenger source for facebook channel", async () => {
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "facebook");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ source: "fb_messenger" })
    );
  });

  it("uses line_oa source for line channel", async () => {
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "line");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ source: "line_oa" })
    );
  });

  it("passes existing email to issueRedeemCode", async () => {
    leadLookupResult = { data: { stage: "new", email: "doctor@example.com" }, error: null };
    const { issueRedeemCode } = await import("@/lib/redeem");
    await handleBotIntent("lead-1", "trial", "line");
    expect(issueRedeemCode).toHaveBeenCalledWith(
      expect.objectContaining({ issuedToEmail: "doctor@example.com" })
    );
  });

  it("returns null if lead is already beyond 'contacted' stage", async () => {
    leadLookupResult = { data: { stage: "code_issued", email: null }, error: null };
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("returns null if lead lookup errors", async () => {
    leadLookupResult = { data: null, error: { message: "db error" } };
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("returns null but does not throw if issueRedeemCode throws", async () => {
    issueResult = new Error("collision");
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).toBeNull();
  });

  it("still returns the code message even if stage update fails", async () => {
    stageUpdateError = { message: "update failed" };
    const msg = await handleBotIntent("lead-1", "trial", "facebook");
    expect(msg).not.toBeNull();
    expect(msg).toContain("MORROO-ABCD-1234");
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
