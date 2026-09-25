import { describe, expect, it } from "vitest";
import {
  getMockSigningSecret,
  isMockSubmitTooFast,
  MOCK_MIN_SECONDS_PER_QUESTION,
  MOCK_TOKEN_GRACE_MS,
  mockTokenExpiresAt,
  mockTokenHash,
  newMockNonce,
  signMockToken,
  verifyMockToken,
  type MockTokenPayload,
} from "./mcq-mock-token";

const SECRET = "test-secret";
const T0 = Date.UTC(2026, 8, 26, 3, 0, 0);

function payload(over: Partial<MockTokenPayload> = {}): MockTokenPayload {
  return {
    v: 1,
    uid: "user-1",
    qids: ["q1", "q2", "q3"],
    cohort: { audience: "student", examType: "NL2", boardSpecialty: null },
    tl: 20,
    iat: T0,
    nonce: "nonce-abcdefgh",
    ...over,
  };
}

function b64(obj: unknown): string {
  return Buffer.from(JSON.stringify(obj), "utf8").toString("base64url");
}

describe("signMockToken / verifyMockToken", () => {
  it("round-trips a valid token for its owner", () => {
    const token = signMockToken(payload(), SECRET);
    const res = verifyMockToken(token, SECRET, { userId: "user-1", now: T0 + 60_000 });
    expect(res).toEqual({ ok: true, payload: payload() });
  });

  it("round-trips a board cohort", () => {
    const p = payload({ cohort: { audience: "board", examType: null, boardSpecialty: "em" } });
    const res = verifyMockToken(signMockToken(p, SECRET), SECRET, { userId: "user-1", now: T0 });
    expect(res.ok).toBe(true);
  });

  it("rejects a tampered payload (e.g. swapping in other question ids)", () => {
    const token = signMockToken(payload(), SECRET);
    const [, sig] = token.split(".");
    const forged = `${b64(payload({ qids: ["easy1", "easy2", "easy3"] }))}.${sig}`;
    expect(verifyMockToken(forged, SECRET, { userId: "user-1", now: T0 })).toEqual({
      ok: false,
      error: "bad_signature",
    });
  });

  it("rejects a tampered signature and a token signed with another secret", () => {
    const token = signMockToken(payload(), SECRET);
    const flipped = token.slice(0, -2) + (token.endsWith("AA") ? "BB" : "AA");
    expect(verifyMockToken(flipped, SECRET, { userId: "user-1", now: T0 })).toMatchObject({
      ok: false,
      error: "bad_signature",
    });
    const other = signMockToken(payload(), "other-secret");
    expect(verifyMockToken(other, SECRET, { userId: "user-1", now: T0 })).toMatchObject({
      ok: false,
      error: "bad_signature",
    });
  });

  it("rejects malformed tokens", () => {
    for (const t of [undefined, null, 42, "", "abc", "a.b.c", ".sig", "body."]) {
      const res = verifyMockToken(t, SECRET, { userId: "user-1", now: T0 });
      expect(res.ok).toBe(false);
      if (!res.ok) expect(["malformed", "bad_signature"]).toContain(res.error);
    }
  });

  it("rejects a correctly signed payload with an invalid shape", () => {
    const bad = [
      { ...payload(), qids: [] },
      { ...payload(), qids: ["q1", "q1"] },
      { ...payload(), cohort: { audience: "student", examType: null, boardSpecialty: null } },
      { ...payload(), cohort: { audience: "board", examType: null, boardSpecialty: "" } },
      { ...payload(), tl: 0 },
      { ...payload(), v: 2 },
    ];
    for (const p of bad) {
      const token = signMockToken(p as MockTokenPayload, SECRET);
      expect(verifyMockToken(token, SECRET, { userId: "user-1", now: T0 })).toEqual({
        ok: false,
        error: "malformed",
      });
    }
  });

  it("rejects another user's token", () => {
    const token = signMockToken(payload(), SECRET);
    expect(verifyMockToken(token, SECRET, { userId: "user-2", now: T0 })).toEqual({
      ok: false,
      error: "wrong_user",
    });
  });

  it("expires after the time limit plus grace, but still hands back the payload", () => {
    const p = payload();
    const token = signMockToken(p, SECRET);
    const exp = mockTokenExpiresAt(p);
    expect(exp).toBe(T0 + 20 * 60_000 + MOCK_TOKEN_GRACE_MS);
    expect(verifyMockToken(token, SECRET, { userId: "user-1", now: exp }).ok).toBe(true);
    expect(verifyMockToken(token, SECRET, { userId: "user-1", now: exp + 1 })).toEqual({
      ok: false,
      error: "expired",
      payload: p,
    });
  });

  it("rejects a token issued in the future beyond clock skew", () => {
    const token = signMockToken(payload({ iat: T0 + 10 * 60_000 }), SECRET);
    expect(verifyMockToken(token, SECRET, { userId: "user-1", now: T0 })).toEqual({
      ok: false,
      error: "not_yet_valid",
    });
  });
});

describe("isMockSubmitTooFast", () => {
  it("flags submissions faster than the per-question floor", () => {
    const p = payload(); // 3 questions
    const floorMs = 3 * MOCK_MIN_SECONDS_PER_QUESTION * 1000;
    expect(isMockSubmitTooFast(p, T0 + floorMs - 1)).toBe(true);
    expect(isMockSubmitTooFast(p, T0 + floorMs)).toBe(false);
    expect(isMockSubmitTooFast(p, T0 + 20 * 60_000)).toBe(false);
  });
});

describe("mockTokenHash / newMockNonce", () => {
  it("hashes deterministically and differs per token", () => {
    const a = signMockToken(payload(), SECRET);
    const b = signMockToken(payload({ nonce: newMockNonce() }), SECRET);
    expect(mockTokenHash(a)).toBe(mockTokenHash(a));
    expect(mockTokenHash(a)).toMatch(/^[0-9a-f]{64}$/);
    expect(mockTokenHash(a)).not.toBe(mockTokenHash(b));
  });

  it("generates distinct nonces", () => {
    expect(newMockNonce()).not.toBe(newMockNonce());
    expect(newMockNonce().length).toBeGreaterThanOrEqual(16);
  });
});

describe("getMockSigningSecret", () => {
  it("prefers MOCK_SIGNING_SECRET", () => {
    expect(getMockSigningSecret({ MOCK_SIGNING_SECRET: "s", SUPABASE_SERVICE_ROLE_KEY: "k" })).toBe("s");
  });

  it("derives a distinct key from the service role key when unset", () => {
    const derived = getMockSigningSecret({ SUPABASE_SERVICE_ROLE_KEY: "service-key" });
    expect(derived).toMatch(/^[0-9a-f]{64}$/);
    expect(derived).not.toBe("service-key");
    expect(getMockSigningSecret({ SUPABASE_SERVICE_ROLE_KEY: "service-key" })).toBe(derived);
  });

  it("returns null when no server secret is configured", () => {
    expect(getMockSigningSecret({})).toBeNull();
    expect(getMockSigningSecret({ MOCK_SIGNING_SECRET: "  " })).toBeNull();
  });
});
