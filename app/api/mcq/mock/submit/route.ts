import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { checkRateLimit, rateLimitResponse, RATE_LIMITS } from "@/lib/rate-limit";
import {
  getMockSigningSecret,
  isMockSubmitTooFast,
  mockTokenHash,
  verifyMockToken,
  type MockTokenPayload,
} from "@/lib/mcq-mock-token";
import {
  gradeMockAnswers,
  sanitizeMockAnswers,
  toMockReviewItem,
  type MockSubmitResponse,
  type MockUnrankedReason,
} from "@/lib/mcq-mock-grade";
import type { McqQuestion } from "@/lib/types-mcq";

type ReviewRow = Pick<McqQuestion, "id" | "correct_answer" | "explanation" | "detailed_explanation">;

// POST /api/mcq/mock/submit
// Body: { token, answers: Record<questionId, choice | null> }
//
// ตรวจ token (HMAC + เจ้าของ + อายุ) → ดึงเฉลยด้วย service role → ตรวจคำตอบ →
// บันทึก mcq_sessions ด้วย service role (graded_by_server) — token ใช้ได้ครั้งเดียว
// (unique mcq_sessions.mock_token_hash) ส่งเร็วเกิน/หมดเวลาก็ยังตรวจให้และเผา
// token ทิ้ง แต่ไม่นับอันดับ ไม่งั้นส่งเร็วๆ เพื่อดูเฉลยแล้วส่งซ้ำด้วยคำตอบถูกหมดได้
export async function POST(request: NextRequest) {
  let body: { token?: unknown; answers?: unknown };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "ต้องเข้าสู่ระบบก่อนจึงจะบันทึกผลสอบได้" }, { status: 401 });
  }

  const secret = getMockSigningSecret();
  if (!secret) {
    console.error("[mock/submit] MOCK_SIGNING_SECRET / SUPABASE_SERVICE_ROLE_KEY not configured");
    return NextResponse.json({ error: "ระบบตรวจข้อสอบยังไม่พร้อม" }, { status: 503 });
  }

  const verified = verifyMockToken(body.token, secret, { userId: user.id });
  let payload: MockTokenPayload;
  let expired = false;
  if (verified.ok) {
    payload = verified.payload;
  } else if (verified.error === "expired") {
    payload = verified.payload;
    expired = true;
  } else if (verified.error === "wrong_user") {
    return NextResponse.json({ error: "ชุดข้อสอบนี้ไม่ใช่ของบัญชีนี้" }, { status: 403 });
  } else {
    return NextResponse.json({ error: "ชุดข้อสอบไม่ถูกต้อง" }, { status: 400 });
  }

  const rl = await checkRateLimit(supabase, user.id, "mcq:mock-submit", RATE_LIMITS.mcqMockSubmit);
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.mcqMockSubmit);
  if (rlResp) return rlResp;

  const admin = createAdminClient();

  // ไม่กรอง status — ข้อที่ถูกปิดระหว่างสอบยังตรวจได้ ข้อที่หายไปจริงๆ นับเป็นผิด
  const { data: rows, error: qErr } = await admin
    .from("mcq_questions")
    .select("id, correct_answer, explanation, detailed_explanation")
    .in("id", payload.qids);
  if (qErr) {
    console.error("[mock/submit] question fetch failed:", qErr);
    return NextResponse.json({ error: "ตรวจข้อสอบไม่สำเร็จ ลองใหม่อีกครั้ง" }, { status: 500 });
  }
  const byId = new Map<string, ReviewRow>(((rows as ReviewRow[] | null) ?? []).map((r) => [r.id, r]));

  const answers = sanitizeMockAnswers(body.answers, payload.qids);
  const graded = gradeMockAnswers(
    payload.qids,
    new Map(payload.qids.map((id) => [id, byId.get(id)?.correct_answer ?? null])),
    answers,
  );
  const perQuestion: MockSubmitResponse["perQuestion"] = graded.perQuestion.map((g) => {
    const row = byId.get(g.id);
    const review = row
      ? toMockReviewItem(row)
      : { id: g.id, correct_answer: null, explanation: null, detailed_explanation: null };
    return { ...review, selected: g.selected, isCorrect: g.isCorrect };
  });

  const tooFast = isMockSubmitTooFast(payload);
  const unrankedReason: MockUnrankedReason | null = expired ? "expired" : tooFast ? "too_fast" : null;
  const tokenHash = mockTokenHash(body.token as string);
  const { cohort } = payload;

  const { data: inserted, error: insErr } = await admin
    .from("mcq_sessions")
    .insert({
      user_id: user.id,
      mode: "mock",
      audience: cohort.audience,
      exam_type: cohort.audience === "student" ? cohort.examType : null,
      board_specialty: cohort.audience === "board" ? cohort.boardSpecialty : null,
      subject_id: null,
      total_questions: graded.total,
      correct_count: graded.correctCount,
      time_limit_minutes: Math.round(payload.tl),
      completed_at: new Date().toISOString(),
      graded_by_server: unrankedReason === null,
      mock_token_hash: tokenHash,
    })
    .select("id, graded_by_server")
    .single();

  let result: MockSubmitResponse;
  if (!insErr && inserted) {
    const row = inserted as { id: string; graded_by_server: boolean };
    result = {
      sessionId: row.id,
      ranked: row.graded_by_server === true,
      unrankedReason: row.graded_by_server === true ? null : unrankedReason ?? "save_failed",
      correctCount: graded.correctCount,
      total: graded.total,
      perQuestion,
    };
  } else if (insErr?.code === "23505") {
    // token นี้ถูกส่งไปแล้ว (กดซ้ำ / retry หลังเน็ตหลุด) — คืนผลที่บันทึกไว้ครั้งแรก
    // คะแนนที่ใช้จัดอันดับคือของครั้งแรกเสมอ ส่งซ้ำด้วยคำตอบใหม่ไม่เปลี่ยนอะไร
    const { data: existing } = await admin
      .from("mcq_sessions")
      .select("id, correct_count, total_questions, graded_by_server")
      .eq("mock_token_hash", tokenHash)
      .eq("user_id", user.id)
      .maybeSingle();
    const prev = existing as
      | { id: string; correct_count: number; total_questions: number; graded_by_server: boolean }
      | null;
    result = {
      sessionId: prev?.id ?? null,
      ranked: prev?.graded_by_server === true,
      unrankedReason: prev?.graded_by_server === true ? null : "already_submitted",
      correctCount: prev?.correct_count ?? graded.correctCount,
      total: prev?.total_questions ?? graded.total,
      perQuestion,
    };
  } else {
    console.error("[mock/submit] session insert failed:", insErr);
    result = {
      sessionId: null,
      ranked: false,
      unrankedReason: "save_failed",
      correctCount: graded.correctCount,
      total: graded.total,
      perQuestion,
    };
  }

  return NextResponse.json(result, { headers: { "Cache-Control": "no-store" } });
}
