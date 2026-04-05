import { createClient } from "./server";

// --- Types ---

export interface SubjectStat {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  avg_time_spent: number | null;
}

export interface RecentSession {
  session_id: string;
  mode: string;
  exam_type: string;
  subject_name_th: string | null;
  subject_icon: string | null;
  total_questions: number;
  correct_count: number;
  accuracy: number;
  created_at: string;
  completed_at: string;
}

export interface WeakTopic {
  subject_id: string;
  subject_name: string;
  subject_name_th: string;
  subject_icon: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  wrong_count: number;
}

export interface AccuracyTrend {
  week_start: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
}

export interface AdminOverallStats {
  total_students: number;
  active_students_7d: number;
  avg_accuracy: number;
  total_attempts: number;
  weakest_subject_name_th: string | null;
  weakest_subject_icon: string | null;
  weakest_subject_accuracy: number | null;
}

export interface StudentOverview {
  user_id: string;
  user_name: string;
  user_email: string;
  membership_type: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  last_active: string;
}

// --- Student Analytics ---

export async function getUserSubjectStats(
  userId: string
): Promise<SubjectStat[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_subject_stats", {
    p_user_id: userId,
  });
  if (error) {
    console.error("Error fetching user subject stats:", error);
    return [];
  }
  return (data as SubjectStat[]) || [];
}

export async function getUserRecentSessions(
  userId: string,
  limit: number = 10
): Promise<RecentSession[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_recent_sessions", {
    p_user_id: userId,
    p_limit: limit,
  });
  if (error) {
    console.error("Error fetching recent sessions:", error);
    return [];
  }
  return (data as RecentSession[]) || [];
}

export async function getUserWeakTopics(
  userId: string,
  threshold: number = 60
): Promise<WeakTopic[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_weak_topics", {
    p_user_id: userId,
    p_threshold: threshold,
  });
  if (error) {
    console.error("Error fetching weak topics:", error);
    return [];
  }
  return (data as WeakTopic[]) || [];
}

export async function getUserAccuracyTrend(
  userId: string
): Promise<AccuracyTrend[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_accuracy_trend", {
    p_user_id: userId,
  });
  if (error) {
    console.error("Error fetching accuracy trend:", error);
    return [];
  }
  return (data as AccuracyTrend[]) || [];
}

// --- New v2 types ---

export interface SubjectComparison {
  subject_id: string;
  subject_name_th: string;
  subject_icon: string;
  user_accuracy: number;
  global_accuracy: number;
  diff: number;
}

export interface HeatmapCell {
  day_of_week: number;
  hour_of_day: number;
  attempt_count: number;
}

// --- Student Analytics v2 ---

export async function getUserStreak(userId: string): Promise<number> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_streak", {
    p_user_id: userId,
  });
  if (error) {
    console.error("Error fetching streak:", error);
    return 0;
  }
  return (data as number) ?? 0;
}

export async function getUserVsGlobalAvg(
  userId: string
): Promise<SubjectComparison[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_user_vs_global_avg", {
    p_user_id: userId,
  });
  if (error) {
    console.error("Error fetching comparison:", error);
    return [];
  }
  return (data as SubjectComparison[]) || [];
}

// --- Admin Analytics ---

export async function getAdminActivityHeatmap(): Promise<HeatmapCell[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_admin_activity_heatmap");
  if (error) {
    console.error("Error fetching heatmap:", error);
    return [];
  }
  return (data as HeatmapCell[]) || [];
}

// --- Admin Analytics (existing) ---

export async function getAdminOverallStats(): Promise<AdminOverallStats | null> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_admin_overall_stats");
  if (error) {
    console.error("Error fetching admin overall stats:", error);
    return null;
  }
  // RPC returns an array of 1 row
  const rows = data as AdminOverallStats[];
  return rows?.[0] || null;
}

export async function getAdminStudentsOverview(): Promise<StudentOverview[]> {
  const supabase = await createClient();
  const { data, error } = await supabase.rpc("get_admin_students_overview");
  if (error) {
    console.error("Error fetching students overview:", error);
    return [];
  }
  return (data as StudentOverview[]) || [];
}
