import { createClient } from "./server";
import type { LongCase, LongCaseFull, LongCaseSession } from "../types";

// Get all published Long Cases (list view — no sensitive data)
export async function getLongCases(): Promise<LongCase[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_cases")
    .select("id,title,specialty,difficulty,week_number,is_weekly,is_published,published_at,patient_info,correct_diagnosis,created_at")
    .eq("is_published", true)
    .order("is_weekly", { ascending: false })
    .order("created_at", { ascending: false });

  if (error) {
    console.error("getLongCases error:", error);
    return [];
  }
  return (data as LongCase[]) || [];
}

// Get full case data (for AI patient/examiner — server-side only)
export async function getLongCaseFull(id: string): Promise<LongCaseFull | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_cases")
    .select("*")
    .eq("id", id)
    .eq("is_published", true)
    .single();

  if (error || !data) return null;
  return data as LongCaseFull;
}

// Start or resume a session for this case + user
export async function startLongCaseSession(caseId: string, userId: string): Promise<LongCaseSession | null> {
  const supabase = await createClient();

  // Check if session exists already
  const { data: existing } = await supabase
    .from("long_case_sessions")
    .select("*")
    .eq("case_id", caseId)
    .eq("user_id", userId)
    .single();

  if (existing) return existing as LongCaseSession;

  // Create new session
  const { data, error } = await supabase
    .from("long_case_sessions")
    .insert({ case_id: caseId, user_id: userId, phase: "history" })
    .select()
    .single();

  if (error) {
    console.error("startLongCaseSession error:", error);
    return null;
  }
  return data as LongCaseSession;
}

// Get session by id (with case data)
export async function getLongCaseSession(sessionId: string): Promise<(LongCaseSession & { long_case: LongCaseFull }) | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_case_sessions")
    .select("*, long_case:long_cases(*)")
    .eq("id", sessionId)
    .single();

  if (error || !data) return null;
  return data as LongCaseSession & { long_case: LongCaseFull };
}

// Update session fields
export async function updateLongCaseSession(
  sessionId: string,
  updates: Partial<{
    phase: LongCaseSession["phase"];
    history_chat: LongCaseSession["history_chat"];
    pe_selected: LongCaseSession["pe_selected"];
    lab_ordered: LongCaseSession["lab_ordered"];
    student_ddx: string;
    student_mgmt: string;
    examiner_chat: LongCaseSession["examiner_chat"];
    score_history: number;
    score_pe: number;
    score_lab: number;
    score_ddx: number;
    score_management: number;
    score_examiner: number;
    score_total_pct: number;
    feedback: string;
    completed_at: string;
  }>
): Promise<boolean> {
  const supabase = await createClient();
  const { error } = await supabase
    .from("long_case_sessions")
    .update(updates)
    .eq("id", sessionId);

  if (error) {
    console.error("updateLongCaseSession error:", error);
    return false;
  }
  return true;
}

// Get user's session history
export async function getUserLongCaseSessions(userId: string): Promise<LongCaseSession[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_case_sessions")
    .select("*, long_case:long_cases(id,title,specialty,difficulty)")
    .eq("user_id", userId)
    .order("started_at", { ascending: false });

  if (error) return [];
  return (data as LongCaseSession[]) || [];
}
