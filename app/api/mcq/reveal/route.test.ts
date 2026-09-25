import { beforeEach, describe, expect, it, vi } from "vitest";
import { NextRequest } from "next/server";

// --- mocks -----------------------------------------------------------------

const QID = "11111111-2222-4333-8444-555555555555";

const state: {
  user: { id: string } | null;
  rateAllowed: boolean;
  rateCalls: { userId: string; key: string }[];
  activeSets: { user_id: string; question_ids: string[]; expires_at: string }[];
  activeLookupError: boolean;
  question: Record<string, unknown> | null;
  questionFilters: [string, unknown][];
} = {
  user: null,
  rateAllowed: true,
  rateCalls: [],
  activeSets: [],
  activeLookupError: false,
  question: null,
  questionFilters: [],
};

vi.mock("@/lib/supabase/server", () => ({
  createClient: async () => ({
    auth: { getUser: async () => ({ data: { user: state.user } }) },
  }),
}));

vi.mock("@/lib/rate-limit", () => ({
  RATE_LIMITS: { mcqReveal: { max: 300, windowSeconds: 3600 } },
  checkRateLimit: async (_sb: unknown, userId: string, key: string) => {
    state.rateCalls.push({ userId, key });
    return { allowed: state.rateAllowed };
  },
  rateLimitResponse: (r: { allowed: boolean }) =>
    r.allowed ? null : new Response(JSON.stringify({ error: "rate" }), { status: 429 }),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: (table: string) => {
      if (table === "mock_active_sets") {
        const f: { user?: string; qid?: string; after?: string } = {};
        const chain = {
          select: () => chain,
          eq: (_c: string, v: string) => ((f.user = v), chain),
          contains: (_c: string, v: string[]) => ((f.qid = v[0]), chain),
          gt: (_c: string, v: string) => ((f.after = v), chain),
          limit: async () => {
            if (state.activeLookupError) return { data: null, error: { code: "42P01" } };
            return {
              data: state.activeSets.filter(
                (s) =>
                  s.user_id === f.user &&
                  s.question_ids.includes(f.qid!) &&
                  s.expires_at > (f.after ?? ""),
              ),
              error: null,
            };
          },
        };
        return chain;
      }
      // mcq_questions
      const chain = {
        select: () => chain,
        eq: (c: string, v: unknown) => (state.questionFilters.push([c, v]), chain),
        maybeSingle: async () => ({ data: state.question, error: null }),
      };
      return chain;
    },
  }),
}));

import { POST } from "./route";

function req(body: unknown): NextRequest {
  return new NextRequest("http://localhost/api/mcq/reveal", {
    method: "POST",
    body: typeof body === "string" ? body : JSON.stringify(body),
    headers: { "Content-Type": "application/json" },
  });
}

beforeEach(() => {
  state.user = { id: "user-1" };
  state.rateAllowed = true;
  state.rateCalls = [];
  state.activeSets = [];
  state.activeLookupError = false;
  state.questionFilters = [];
  state.question = {
    id: QID,
    choices: [
      { label: "A", text: "a" },
      { label: "B", text: "b" },
    ],
    correct_answer: "B",
    explanation: "because",
    detailed_explanation: null,
  };
});

describe("POST /api/mcq/reveal", () => {
  it("rejects bad input before touching auth", async () => {
    expect((await POST(req("{not json"))).status).toBe(400);
    expect((await POST(req({ questionId: "nope", selected: "A" }))).status).toBe(400);
    expect((await POST(req({ questionId: QID, selected: "AB" }))).status).toBe(400);
    expect(state.rateCalls).toHaveLength(0);
  });

  it("requires a signed-in user", async () => {
    state.user = null;
    const res = await POST(req({ questionId: QID, selected: "A" }));
    expect(res.status).toBe(401);
    expect((await res.json()).error).toMatch(/เข้าสู่ระบบ/);
  });

  it("is rate limited per user", async () => {
    state.rateAllowed = false;
    const res = await POST(req({ questionId: QID, selected: "A" }));
    expect(res.status).toBe(429);
    expect(state.rateCalls).toEqual([{ userId: "user-1", key: "mcq:reveal" }]);
  });

  it("returns the answer key and grades the selection", async () => {
    const res = await POST(req({ questionId: QID, selected: "A" }));
    expect(res.status).toBe(200);
    expect(res.headers.get("Cache-Control")).toBe("no-store");
    expect(await res.json()).toEqual({
      correct_answer: "B",
      explanation: "because",
      detailed_explanation: null,
      isCorrect: false,
    });
    // only active questions are revealed
    expect(state.questionFilters).toContainEqual(["status", "active"]);

    const ok = await POST(req({ questionId: QID, selected: "B" }));
    expect((await ok.json()).isCorrect).toBe(true);
  });

  it("404s for a missing / inactive question", async () => {
    state.question = null;
    expect((await POST(req({ questionId: QID, selected: "A" }))).status).toBe(404);
  });

  it("rejects a label that is not one of the question's choices", async () => {
    const res = await POST(req({ questionId: QID, selected: "E" }));
    expect(res.status).toBe(400);
  });

  it("refuses questions in the caller's active mock set", async () => {
    state.activeSets = [
      {
        user_id: "user-1",
        question_ids: [QID],
        expires_at: new Date(Date.now() + 60_000).toISOString(),
      },
    ];
    const res = await POST(req({ questionId: QID, selected: "A" }));
    expect(res.status).toBe(403);
    const json = await res.json();
    expect(json.error).toMatch(/Mock/);
    expect(json.correct_answer).toBeUndefined();
  });

  it("ignores expired mock sets and other users' sets", async () => {
    state.activeSets = [
      { user_id: "user-1", question_ids: [QID], expires_at: new Date(Date.now() - 1000).toISOString() },
      { user_id: "user-2", question_ids: [QID], expires_at: new Date(Date.now() + 60_000).toISOString() },
    ];
    expect((await POST(req({ questionId: QID, selected: "A" }))).status).toBe(200);
  });

  it("fails open when the active-set lookup errors (e.g. table not migrated yet)", async () => {
    state.activeLookupError = true;
    expect((await POST(req({ questionId: QID, selected: "B" }))).status).toBe(200);
  });
});
