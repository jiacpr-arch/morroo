import { createClient } from "./server";
import { createAdminClient } from "./admin";
import type { LongCase, LongCaseFull, LongCaseSession } from "../types";

// Get all published student Long Cases (list view — no sensitive data)
export async function getLongCases(): Promise<LongCase[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_cases")
    .select("id,title,specialty,difficulty,week_number,is_weekly,is_published,published_at,patient_info,correct_diagnosis,created_at,audience,board_specialty")
    .eq("is_published", true)
    .eq("audience", "student")
    .order("is_weekly", { ascending: false })
    .order("week_number", { ascending: false });

  if (error) {
    console.error("getLongCases error:", error);
    return [];
  }
  return (data as LongCase[]) || [];
}

// Count of published student Long Cases — cheap HEAD count for homepage stats.
export async function getLongCaseCount(): Promise<number> {
  const supabase = createAdminClient();
  const { count, error } = await supabase
    .from("long_cases")
    .select("id", { count: "exact", head: true })
    .eq("is_published", true)
    .eq("audience", "student");

  if (error) {
    console.error("getLongCaseCount error:", error);
    return 0;
  }
  return count ?? 0;
}

// Get published Board Oral cases for a specialty
export async function getBoardOralCases(specialty: string): Promise<LongCase[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_cases")
    .select("id,title,specialty,difficulty,week_number,is_weekly,is_published,published_at,patient_info,correct_diagnosis,created_at,audience,board_specialty")
    .eq("is_published", true)
    .eq("audience", "board")
    .eq("board_specialty", specialty)
    .order("published_at", { ascending: false });

  if (error) {
    console.error("getBoardOralCases error:", error);
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

// Latest attempt for this case + user, or null if none exists.
// Throws on a real query error so callers never mistake a failure for "no session".
export async function getLatestLongCaseAttempt(caseId: string, userId: string): Promise<LongCaseSession | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_case_sessions")
    .select("*")
    .eq("case_id", caseId)
    .eq("user_id", userId)
    .order("attempt_number", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) throw new Error(`getLatestLongCaseAttempt failed: ${error.message}`);
  return (data as LongCaseSession) ?? null;
}

// Start or resume the latest attempt for this case + user
export async function startLongCaseSession(caseId: string, userId: string): Promise<LongCaseSession | null> {
  try {
    const existing = await getLatestLongCaseAttempt(caseId, userId);
    if (existing) return existing;
  } catch (err) {
    console.error("startLongCaseSession lookup error:", err);
    return null;
  }

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("long_case_sessions")
    .insert({ case_id: caseId, user_id: userId, phase: "history", attempt_number: 1 })
    .select()
    .single();

  if (error) {
    console.error("startLongCaseSession error:", error);
    return null;
  }
  return data as LongCaseSession;
}

export type RetryLongCaseResult =
  | { ok: true; session: LongCaseSession; resumed: boolean }
  | { ok: false; reason: "no_prior_attempt" | "error" };

// Start a fresh attempt; previous attempts are kept as history.
// An unfinished latest attempt is resumed instead of abandoned.
export async function retryLongCaseSession(caseId: string, userId: string): Promise<RetryLongCaseResult> {
  const supabase = await createClient();

  // Two rapid clicks can race to the same attempt_number; the unique index
  // rejects the loser (23505), so re-read and retry once before failing.
  for (let tries = 0; tries < 2; tries++) {
    let latest: LongCaseSession | null;
    try {
      latest = await getLatestLongCaseAttempt(caseId, userId);
    } catch (err) {
      console.error("retryLongCaseSession lookup error:", err);
      return { ok: false, reason: "error" };
    }

    if (!latest) return { ok: false, reason: "no_prior_attempt" };
    if (!latest.completed_at) return { ok: true, session: latest, resumed: true };

    const { data, error } = await supabase
      .from("long_case_sessions")
      .insert({
        case_id: caseId,
        user_id: userId,
        phase: "history",
        attempt_number: latest.attempt_number + 1,
      })
      .select()
      .single();

    if (!error) return { ok: true, session: data as LongCaseSession, resumed: false };
    if (error.code !== "23505") {
      console.error("retryLongCaseSession error:", error);
      return { ok: false, reason: "error" };
    }
  }

  return { ok: false, reason: "error" };
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
