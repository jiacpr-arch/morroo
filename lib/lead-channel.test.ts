import { describe, it, expect, vi, beforeEach } from "vitest";

type QueryResult<T> = { data: T | null; error: { message: string } | null };

let lookupResult: QueryResult<{ id: string }> = { data: null, error: null };
let insertResult: QueryResult<{ id: string }> = { data: null, error: null };
const updateCalls: Array<Record<string, unknown>> = [];
const insertCalls: Array<Record<string, unknown>> = [];
const lookupFilters: Array<{ column: string; value: unknown }> = [];

function makeBuilder() {
  // Chain that captures the eq()/select()/maybeSingle() it was called with
  // and resolves to whichever result was set up by the test.
  const chain: Record<string, unknown> = {};
  chain.select = vi.fn(() => chain);
  chain.eq = vi.fn((col: string, val: unknown) => {
    lookupFilters.push({ column: col, value: val });
    return chain;
  });
  chain.order = vi.fn(() => chain);
  chain.limit = vi.fn(() => chain);
  chain.maybeSingle = vi.fn(() => Promise.resolve(lookupResult));
  chain.single = vi.fn(() => Promise.resolve(insertResult));
  chain.insert = vi.fn((payload: Record<string, unknown>) => {
    insertCalls.push(payload);
    return chain;
  });
  chain.update = vi.fn((payload: Record<string, unknown>) => {
    updateCalls.push(payload);
    return {
      eq: vi.fn(() => ({
        then: (resolve: (v: { error: null }) => unknown) =>
          Promise.resolve(resolve({ error: null })),
      })),
    };
  });
  return chain;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({ from: vi.fn(() => makeBuilder()) }),
}));

import { getOrCreateLeadFromChannel } from "./lead-channel";

beforeEach(() => {
  lookupResult = { data: null, error: null };
  insertResult = { data: null, error: null };
  updateCalls.length = 0;
  insertCalls.length = 0;
  lookupFilters.length = 0;
});

describe("getOrCreateLeadFromChannel", () => {
  it("returns the existing lead id when one already exists for the PSID", async () => {
    lookupResult = { data: { id: "lead-existing" }, error: null };

    const id = await getOrCreateLeadFromChannel({
      channel: "facebook",
      channelUserId: "psid-123",
    });

    expect(id).toBe("lead-existing");
    expect(insertCalls).toHaveLength(0);
    expect(lookupFilters).toContainEqual({ column: "fb_psid", value: "psid-123" });
  });

  it("creates a new lead with source=fb_messenger when no PSID match", async () => {
    insertResult = { data: { id: "lead-new" }, error: null };

    const id = await getOrCreateLeadFromChannel({
      channel: "facebook",
      channelUserId: "psid-new",
    });

    expect(id).toBe("lead-new");
    expect(insertCalls[0]).toMatchObject({
      source: "fb_messenger",
      stage: "new",
      consent_pdpa: false,
      fb_psid: "psid-new",
    });
  });

  it("creates a new lead with source=line_oa for LINE channel", async () => {
    insertResult = { data: { id: "lead-line" }, error: null };

    const id = await getOrCreateLeadFromChannel({
      channel: "line",
      channelUserId: "U-line-abc",
    });

    expect(id).toBe("lead-line");
    expect(insertCalls[0]).toMatchObject({
      source: "line_oa",
      line_user_id: "U-line-abc",
    });
    expect(lookupFilters).toContainEqual({
      column: "line_user_id",
      value: "U-line-abc",
    });
  });

  it("returns null (does not throw) when the database lookup errors", async () => {
    lookupResult = { data: null, error: { message: "boom" } };

    const id = await getOrCreateLeadFromChannel({
      channel: "facebook",
      channelUserId: "psid-err",
    });

    expect(id).toBeNull();
    expect(insertCalls).toHaveLength(0);
  });

  it("returns null when the insert errors", async () => {
    insertResult = { data: null, error: { message: "constraint violated" } };

    const id = await getOrCreateLeadFromChannel({
      channel: "facebook",
      channelUserId: "psid-bad",
    });

    expect(id).toBeNull();
  });
});
