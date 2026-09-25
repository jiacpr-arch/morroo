import { beforeEach, describe, expect, it, vi } from "vitest";
import { NextRequest } from "next/server";
import { signMockToken, type MockTokenPayload } from "@/lib/mcq-mock-token";

// --- mocks -----------------------------------------------------------------

const state: {
  user: { id: string } | null;
  questions: { id: string; correct_answer: string; explanation: string | null; detailed_explanation: null }[];
  insertError: { code: string } | null;
  existing: Record<string, unknown> | null;
  inserted: Record<string, unknown>[];
  released: Record<string, string>[];
} = { user: null, questions: [], insertError: null, existing: null, inserted: [], released: [] };

vi.mock("@/lib/supabase/server", () => ({
  createClient: async () => ({
    auth: { getUser: async () => ({ data: { user: state.user } }) },
  }),
}));

vi.mock("@/lib/rate-limit", () => ({
  RATE_LIMITS: { mcqMockSubmit: { max: 30, windowSeconds: 3600 } },
  checkRateLimit: async () => ({ allowed: true }),
  rateLimitResponse: () => null,
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: () => ({
    from: (table: string) => {
      if (table === "mock_active_sets") {
        return {
          delete: () => ({
            eq: (c1: string, v1: string) => ({
              eq: async (c2: string, v2: string) => {
                state.released.push({ [c1]: v1, [c2]: v2 });
                return { error: null };
              },
            }),
          }),
        };
      }
      if (table === "mcq_questions") {
        return {
          select: () => ({
            in: async (_col: string, ids: string[]) => ({
              data: state.questions.filter((q) => ids.includes(q.id)),
              error: null,
            }),
          }),
        };
      }
      // mcq_sessions
      return {
        insert: (row: Record<string, unknown>) => ({
          select: () => ({
            single: async () => {
              if (state.insertError) return { data: null, error: state.insertError };
              state.inserted.push(row);
              return { data: { id: "sess-1", graded_by_server: row.graded_by_server }, error: null };
            },
          }),
        }),
        select: () => ({
          eq: () => ({ eq: () => ({ maybeSingle: async () => ({ data: state.existing, error: null }) }) }),
        }),
      };
    },
  }),
}));

import { POST } from "./route";

// --- helpers ---------------------------------------------------------------

const SECRET = "route-test-secret";

function token(over: Partial<MockTokenPayload> = {}): string {
  return signMockToken(
    {
      v: 1,
      uid: "user-1",
      qids: ["q1", "q2"],
      cohort: { audience: "student", examType: "NL2", boardSpecialty: null },
      tl: 20,
      iat: Date.now() - 5 * 60_000,
      nonce: "nonce-abcdefgh",
      ...over,
    },
    SECRET,
  );
}

function req(body: unknown): NextRequest {
  return new NextRequest("http://localhost/api/mcq/mock/submit", {
    method: "POST",
    body: JSON.stringify(body),
    headers: { "Content-Type": "application/json" },
  });
}

beforeEach(() => {
  process.env.MOCK_SIGNING_SECRET = SECRET;
  state.user = { id: "user-1" };
  state.questions = [
    { id: "q1", correct_answer: "A", explanation: "e1", detailed_explanation: null },
    { id: "q2", correct_answer: "B", explanation: "e2", detailed_explanation: null },
  ];
  state.insertError = null;
  state.existing = null;
  state.inserted = [];
  state.released = [];
});

describe("POST /api/mcq/mock/submit", () => {
  it("requires a signed-in user", async () => {
    state.user = null;
    const res = await POST(req({ token: token(), answers: {} }));
    expect(res.status).toBe(401);
  });

  it("rejects another user's token", async () => {
    state.user = { id: "user-2" };
    const res = await POST(req({ token: token(), answers: {} }));
    expect(res.status).toBe(403);
    expect(state.inserted).toHaveLength(0);
  });

  it("rejects a forged token", async () => {
    const forged = signMockToken(
      {
        v: 1,
        uid: "user-1",
        qids: ["q1"],
        cohort: { audience: "student", examType: "NL2", boardSpecialty: null },
        tl: 20,
        iat: Date.now() - 60_000,
        nonce: "nonce-abcdefgh",
      },
      "attacker-secret",
    );
    const res = await POST(req({ token: forged, answers: { q1: "A" } }));
    expect(res.status).toBe(400);
    expect(state.inserted).toHaveLength(0);
  });

  it("grades on the server, saves a ranked row and returns the answer key", async () => {
    const res = await POST(req({ token: token(), answers: { q1: "A", q2: "C", bogus: "A" } }));
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json).toMatchObject({ sessionId: "sess-1", ranked: true, unrankedReason: null, correctCount: 1, total: 2 });
    expect(json.perQuestion).toEqual([
      { id: "q1", correct_answer: "A", explanation: "e1", detailed_explanation: null, selected: "A", isCorrect: true },
      { id: "q2", correct_answer: "B", explanation: "e2", detailed_explanation: null, selected: "C", isCorrect: false },
    ]);
    expect(state.inserted[0]).toMatchObject({
      user_id: "user-1",
      mode: "mock",
      audience: "student",
      exam_type: "NL2",
      board_specialty: null,
      total_questions: 2,
      correct_count: 1,
      time_limit_minutes: 20,
      graded_by_server: true,
    });
    expect(state.inserted[0].mock_token_hash).toMatch(/^[0-9a-f]{64}$/);
    // ส่งแล้ว → ปลดชุดนี้ออกจาก mock_active_sets ให้ /api/mcq/reveal ใช้ได้
    expect(state.released).toEqual([
      { user_id: "user-1", token_hash: state.inserted[0].mock_token_hash },
    ]);
  });

  it("does not release the active set for a rejected token", async () => {
    state.user = { id: "user-2" };
    await POST(req({ token: token(), answers: {} }));
    expect(state.released).toHaveLength(0);
  });

  it("ignores client-supplied score fields", async () => {
    const res = await POST(
      req({ token: token(), answers: {}, correct_count: 2, total_questions: 2 }),
    );
    const json = await res.json();
    expect(json.correctCount).toBe(0);
    expect(state.inserted[0]).toMatchObject({ correct_count: 0, total_questions: 2 });
  });

  it("saves a too-fast submission unranked (still burns the token)", async () => {
    const res = await POST(req({ token: token({ iat: Date.now() - 1000 }), answers: { q1: "A", q2: "B" } }));
    const json = await res.json();
    expect(json).toMatchObject({ ranked: false, unrankedReason: "too_fast", correctCount: 2 });
    expect(state.inserted[0]).toMatchObject({ graded_by_server: false });
    expect(state.inserted[0].mock_token_hash).toBeTruthy();
  });

  it("saves an expired submission unranked but still returns the review", async () => {
    const res = await POST(req({ token: token({ iat: Date.now() - 3 * 3600_000 }), answers: { q1: "A" } }));
    expect(res.status).toBe(200);
    const json = await res.json();
    expect(json).toMatchObject({ ranked: false, unrankedReason: "expired", correctCount: 1 });
    expect(json.perQuestion).toHaveLength(2);
    expect(state.inserted[0]).toMatchObject({ graded_by_server: false });
  });

  it("returns the first submission's stored score when the token was already used", async () => {
    state.insertError = { code: "23505" };
    state.existing = { id: "sess-0", correct_count: 1, total_questions: 2, graded_by_server: true };
    const res = await POST(req({ token: token(), answers: { q1: "A", q2: "B" } }));
    const json = await res.json();
    expect(json).toMatchObject({ sessionId: "sess-0", ranked: true, correctCount: 1, total: 2 });
  });

  it("still returns the grade when saving fails for another reason", async () => {
    state.insertError = { code: "42703" };
    const res = await POST(req({ token: token(), answers: { q1: "A" } }));
    const json = await res.json();
    expect(json).toMatchObject({ sessionId: null, ranked: false, unrankedReason: "save_failed", correctCount: 1 });
  });
});
