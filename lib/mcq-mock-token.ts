// Token ชุดข้อสอบ Mock ที่เซ็นด้วย HMAC ฝั่ง server — ใช้ฝั่ง server เท่านั้น (node:crypto)
//
// หน้า mock (/nl/mock, /board/[specialty]/mock) สุ่มข้อแล้วออก token ผูก
// {ผู้ใช้, id ข้อสอบตามลำดับ, cohort, เวลาที่ให้, เวลาออก, nonce} ส่งไปกับข้อสอบ
// ที่ตัดเฉลยออกแล้ว ตอนส่งข้อสอบ app/api/mcq/mock/submit/route.ts ตรวจ token
// ตรวจคำตอบกับ mcq_questions เอง แล้วบันทึก mcq_sessions ด้วย service role —
// browser กำหนดจำนวนข้อ/คะแนน/cohort เองไม่ได้อีกต่อไป
//
// รูปแบบ token: base64url(JSON payload) + "." + base64url(HMAC-SHA256(payload))

import { createHash, createHmac, randomBytes, timingSafeEqual } from "node:crypto";
import { MOCK_MAX_QUESTIONS } from "./mcq-mock-percentile";

export interface MockTokenCohort {
  audience: "student" | "board";
  examType: "NL1" | "NL2" | null;
  boardSpecialty: string | null;
}

export interface MockTokenPayload {
  v: 1;
  /** auth.users.id ของคนที่ได้ชุดนี้ */
  uid: string;
  /** id ข้อสอบตามลำดับที่แสดง */
  qids: string[];
  cohort: MockTokenCohort;
  /** เวลาที่ให้ทำ (นาที) — ใช้คำนวณวันหมดอายุ และบันทึกเป็น time_limit_minutes */
  tl: number;
  /** เวลาออก token (ms since epoch) */
  iat: number;
  nonce: string;
}

/** ส่งช้ากว่าเวลาที่ให้ได้อีกเท่านี้ (โหลดหน้า / เน็ตช้า / timer ฝั่ง browser คลาดเคลื่อน) */
export const MOCK_TOKEN_GRACE_MS = 10 * 60 * 1000;
/** เผื่อนาฬิกาเครื่อง server คนละเครื่องไม่ตรงกัน */
export const MOCK_TOKEN_CLOCK_SKEW_MS = 60 * 1000;
/** ส่งเร็วกว่า (จำนวนข้อ × ค่านี้) วินาที = ไม่ได้อ่านจริง → ตรวจให้แต่ไม่นับอันดับ */
export const MOCK_MIN_SECONDS_PER_QUESTION = 3;

export type MockTokenError =
  | "malformed"
  | "bad_signature"
  | "wrong_user"
  | "expired"
  | "not_yet_valid";

export type MockTokenVerifyResult =
  | { ok: true; payload: MockTokenPayload }
  | { ok: false; error: Exclude<MockTokenError, "expired"> }
  /** ลายเซ็น/เจ้าของถูกต้องแต่หมดเวลาแล้ว — route ยังตรวจให้ดูเฉลยได้ แต่ไม่นับอันดับ */
  | { ok: false; error: "expired"; payload: MockTokenPayload };

/**
 * กุญแจเซ็น token: MOCK_SIGNING_SECRET ถ้าตั้งไว้ ไม่งั้น derive จาก
 * SUPABASE_SERVICE_ROLE_KEY (ความลับฝั่ง server ที่มีทุก deploy อยู่แล้ว — แยก
 * domain ด้วย prefix จึงไม่ใช่ค่าเดียวกับ key) ถ้าไม่มีทั้งคู่คืน null → หน้า mock
 * ไม่ออก token (สอบได้ แต่ไม่บันทึก/ไม่จัดอันดับ)
 */
export function getMockSigningSecret(env: Record<string, string | undefined> = process.env): string | null {
  const explicit = env.MOCK_SIGNING_SECRET?.trim();
  if (explicit) return explicit;
  const serviceKey = env.SUPABASE_SERVICE_ROLE_KEY?.trim();
  if (serviceKey) {
    return createHmac("sha256", serviceKey).update("morroo:mock-token:v1").digest("hex");
  }
  return null;
}

function hmac(body: string, secret: string): Buffer {
  return createHmac("sha256", secret).update(body).digest();
}

export function newMockNonce(): string {
  return randomBytes(16).toString("base64url");
}

export function signMockToken(payload: MockTokenPayload, secret: string): string {
  const body = Buffer.from(JSON.stringify(payload), "utf8").toString("base64url");
  return `${body}.${hmac(body, secret).toString("base64url")}`;
}

/** hash ของ token ทั้งก้อน — เก็บใน mcq_sessions.mock_token_hash (unique) กันส่งซ้ำ */
export function mockTokenHash(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

/** เวลาหมดอายุ (ms) = ออก + เวลาที่ให้ + grace */
export function mockTokenExpiresAt(payload: Pick<MockTokenPayload, "iat" | "tl">): number {
  return payload.iat + payload.tl * 60_000 + MOCK_TOKEN_GRACE_MS;
}

function isCohort(x: unknown): x is MockTokenCohort {
  if (!x || typeof x !== "object") return false;
  const c = x as Record<string, unknown>;
  if (c.audience === "student") {
    return (c.examType === "NL1" || c.examType === "NL2") && c.boardSpecialty === null;
  }
  if (c.audience === "board") {
    return c.examType === null && typeof c.boardSpecialty === "string" && c.boardSpecialty.length > 0;
  }
  return false;
}

function isPayload(x: unknown): x is MockTokenPayload {
  if (!x || typeof x !== "object") return false;
  const p = x as Record<string, unknown>;
  return (
    p.v === 1 &&
    typeof p.uid === "string" &&
    p.uid.length > 0 &&
    Array.isArray(p.qids) &&
    p.qids.length >= 1 &&
    p.qids.length <= MOCK_MAX_QUESTIONS &&
    p.qids.every((id) => typeof id === "string" && id.length > 0) &&
    new Set(p.qids).size === p.qids.length &&
    isCohort(p.cohort) &&
    typeof p.tl === "number" &&
    Number.isFinite(p.tl) &&
    p.tl > 0 &&
    p.tl <= 24 * 60 &&
    typeof p.iat === "number" &&
    Number.isFinite(p.iat) &&
    typeof p.nonce === "string" &&
    p.nonce.length >= 8
  );
}

/**
 * ตรวจลายเซ็น (constant-time) → รูปแบบ payload → เจ้าของ → อายุ
 * ลายเซ็นตรวจก่อนอย่างอื่นเสมอ token ปลอมจึงได้แค่ bad_signature/malformed
 */
export function verifyMockToken(
  token: unknown,
  secret: string,
  opts: { userId: string; now?: number },
): MockTokenVerifyResult {
  if (typeof token !== "string" || token.length > 64_000) return { ok: false, error: "malformed" };
  const parts = token.split(".");
  if (parts.length !== 2 || !parts[0] || !parts[1]) return { ok: false, error: "malformed" };
  const [body, sig] = parts;

  const expected = hmac(body, secret);
  let given: Buffer;
  try {
    given = Buffer.from(sig, "base64url");
  } catch {
    return { ok: false, error: "malformed" };
  }
  if (given.length !== expected.length || !timingSafeEqual(given, expected)) {
    return { ok: false, error: "bad_signature" };
  }

  let payload: unknown;
  try {
    payload = JSON.parse(Buffer.from(body, "base64url").toString("utf8"));
  } catch {
    return { ok: false, error: "malformed" };
  }
  if (!isPayload(payload)) return { ok: false, error: "malformed" };

  if (payload.uid !== opts.userId) return { ok: false, error: "wrong_user" };

  const now = opts.now ?? Date.now();
  if (payload.iat > now + MOCK_TOKEN_CLOCK_SKEW_MS) return { ok: false, error: "not_yet_valid" };
  if (now > mockTokenExpiresAt(payload)) return { ok: false, error: "expired", payload };

  return { ok: true, payload };
}

/** ส่งเร็วเกินกว่าจะอ่านข้อสอบจริงหรือไม่ (นับจากเวลาออก token ฝั่ง server) */
export function isMockSubmitTooFast(payload: Pick<MockTokenPayload, "iat" | "qids">, now: number = Date.now()): boolean {
  return now - payload.iat < payload.qids.length * MOCK_MIN_SECONDS_PER_QUESTION * 1000;
}
