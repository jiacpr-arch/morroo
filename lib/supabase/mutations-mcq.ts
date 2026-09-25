import { createClient } from "./client";
import type { McqAttempt, McqSession } from "../types-mcq";
import type { MockPercentileRow } from "../mcq-mock-percentile";
import type { McqMockAnswers, MockSubmitResponse } from "../mcq-mock-grade";
import { recordMcqReviewOutcome } from "../mcq-review";

// --- Client-side save functions (called from browser components) ---

export async function saveMcqAttempt(attempt: {
  user_id: string;
  question_id: string;
  selected_answer: string;
  is_correct: boolean;
  time_spent_seconds?: number | null;
  mode: "practice" | "mock";
  session_id?: string | null;
  via_recommendation?: boolean;
}): Promise<McqAttempt | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_attempts")
    .insert({
      user_id: attempt.user_id,
      question_id: attempt.question_id,
      selected_answer: attempt.selected_answer,
      is_correct: attempt.is_correct,
      time_spent_seconds: attempt.time_spent_seconds ?? null,
      mode: attempt.mode,
      session_id: attempt.session_id ?? null,
      via_recommendation: attempt.via_recommendation ?? false,
    })
    .select()
    .single();

  if (error) {
    console.error("Error saving MCQ attempt:", error);
    return null;
  }
  return data as McqAttempt;
}

/** Feed one answer into the "ทบทวนข้อที่ผิด" SRS queue (see lib/mcq-review.ts). Never throws. */
export async function recordMcqReview(
  userId: string,
  questionId: string,
  isCorrect: boolean
): Promise<void> {
  await recordMcqReviewOutcome(createClient(), userId, questionId, isCorrect);
}

export async function createMcqSession(session: {
  user_id: string;
  mode: "practice" | "mock";
  exam_type?: "NL1" | "NL2" | null;
  subject_id?: string | null;
  total_questions: number;
  time_limit_minutes?: number | null;
  audience?: "student" | "board";
  board_specialty?: string | null;
  board_section?: string | null;
}): Promise<McqSession | null> {
  const supabase = createClient();
  const audience = session.audience ?? "student";
  const { data, error } = await supabase
    .from("mcq_sessions")
    .insert({
      user_id: session.user_id,
      mode: session.mode,
      exam_type: audience === "student" ? session.exam_type ?? "NL2" : null,
      subject_id: session.subject_id ?? null,
      audience,
      board_specialty: session.board_specialty ?? null,
      board_section: session.board_section ?? null,
      total_questions: session.total_questions,
      correct_count: 0,
      time_limit_minutes: session.time_limit_minutes ?? null,
    })
    .select()
    .single();

  if (error) {
    console.error("Error creating MCQ session:", error);
    return null;
  }
  return data as McqSession;
}

export async function updateMcqSession(
  id: string,
  updates: {
    correct_count?: number;
    completed_at?: string;
  }
): Promise<McqSession | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_sessions")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Error updating MCQ session:", error);
    return null;
  }
  return data as McqSession;
}

// --- Mock exam: ส่งให้ server ตรวจ/บันทึก + ดึง percentile เทียบคนอื่น ---

/**
 * ส่งคำตอบ mock ให้ /api/mcq/mock/submit ตรวจกับ mcq_questions แล้วบันทึก
 * mcq_sessions ด้วย service role (graded_by_server) — browser ไม่ insert แถว mock
 * เองอีกต่อไป คะแนน/จำนวนข้อ/cohort มาจาก token ที่ server เซ็นเท่านั้น
 * คืนคะแนน + เฉลยทุกข้อไว้ใช้บนหน้าผล/ทบทวน
 */
export async function submitMockExam(
  token: string,
  answers: McqMockAnswers
): Promise<{ ok: true; data: MockSubmitResponse } | { ok: false; error: string }> {
  try {
    const res = await fetch("/api/mcq/mock/submit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token, answers }),
    });
    const json = (await res.json().catch(() => null)) as
      | (MockSubmitResponse & { error?: string })
      | null;
    if (!res.ok || !json || !Array.isArray(json.perQuestion)) {
      return { ok: false, error: json?.error || "เชื่อมต่อไม่สำเร็จ ลองใหม่อีกครั้ง" };
    }
    return { ok: true, data: json };
  } catch {
    return { ok: false, error: "เชื่อมต่อไม่สำเร็จ ลองใหม่อีกครั้ง" };
  }
}

/** RPC get_mock_percentile — คืน null ถ้า RPC ยังไม่ deploy/พลาด ให้ UI ซ่อนการ์ดเฉยๆ */
export async function fetchMockPercentile(sessionId: string): Promise<MockPercentileRow[] | null> {
  const supabase = createClient();
  const { data, error } = await supabase.rpc("get_mock_percentile", {
    p_session_id: sessionId,
  });
  if (error || !Array.isArray(data)) return null;
  return data as MockPercentileRow[];
}
