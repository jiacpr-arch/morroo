import { createClient } from "./client";
import type { McqAttempt, McqSession } from "../types-mcq";
import type { MockPercentileRow } from "../mcq-mock-percentile";

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

// --- Mock exam: บันทึกผลตอนส่ง + ดึง percentile เทียบคนอื่น ---

/**
 * บันทึก mock ที่ส่งแล้วเป็น mcq_sessions แถวเดียว (mode='mock', completed_at
 * ตั้งเลย) — สร้างตอนส่งแทนตอนเริ่ม เพราะคนที่เปิดแล้วทิ้งกลางทางไม่ควรมีแถว
 * ค้างไม่มีคะแนนไปถ่วง cohort ของ get_mock_percentile
 */
export async function saveCompletedMockSession(session: {
  user_id: string;
  audience: "student" | "board";
  exam_type?: "NL1" | "NL2" | null;
  board_specialty?: string | null;
  total_questions: number;
  correct_count: number;
  time_limit_minutes?: number | null;
}): Promise<McqSession | null> {
  const supabase = createClient();
  const { data, error } = await supabase
    .from("mcq_sessions")
    .insert({
      user_id: session.user_id,
      mode: "mock",
      audience: session.audience,
      exam_type: session.audience === "student" ? session.exam_type ?? "NL2" : null,
      board_specialty: session.audience === "board" ? session.board_specialty ?? null : null,
      subject_id: null,
      total_questions: session.total_questions,
      correct_count: session.correct_count,
      time_limit_minutes: session.time_limit_minutes ?? null,
      completed_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (error) {
    console.error("Error saving mock session:", error);
    return null;
  }
  return data as McqSession;
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
