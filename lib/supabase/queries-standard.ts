import { createClient } from "./server";
import type {
  Challenge,
  ChallengeSubmission,
  LeaderboardEntry,
  Badge,
  UserBadge,
  Reward,
  CouponCode,
  CouponRedemption,
  DifficultyLevel,
} from "../types-standard";

// ============================================
// Difficulty Queries
// ============================================

export async function getMcqQuestionsByDifficulty(
  difficultyLevel: DifficultyLevel,
  options?: { subjectId?: string; limit?: number }
) {
  const supabase = await createClient();
  let query = supabase
    .from("mcq_questions")
    .select("*, mcq_subjects(name, name_th, icon)")
    .eq("status", "active")
    .eq("difficulty_level", difficultyLevel);

  if (options?.subjectId) {
    query = query.eq("subject_id", options.subjectId);
  }

  const limit = options?.limit || 50;
  query = query.limit(limit);

  const { data, error } = await query;
  if (error) {
    console.error("Error fetching questions by difficulty:", error);
    return [];
  }
  return data || [];
}

export async function getDifficultyStats(userId: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("mcq_attempts")
    .select("is_correct, mcq_questions!inner(difficulty_level)")
    .eq("user_id", userId);

  if (error || !data) return { 1: { total: 0, correct: 0 }, 2: { total: 0, correct: 0 }, 3: { total: 0, correct: 0 } };

  const stats: Record<number, { total: number; correct: number }> = {
    1: { total: 0, correct: 0 },
    2: { total: 0, correct: 0 },
    3: { total: 0, correct: 0 },
  };

  for (const row of data) {
    const level = (row as unknown as { mcq_questions: { difficulty_level: number } }).mcq_questions.difficulty_level;
    if (stats[level]) {
      stats[level].total++;
      if (row.is_correct) stats[level].correct++;
    }
  }
  return stats;
}

// ============================================
// Challenge Queries
// ============================================

export async function getActiveChallenges(): Promise<Challenge[]> {
  const supabase = await createClient();
  const now = new Date().toISOString();
  const { data, error } = await supabase
    .from("challenges")
    .select("*")
    .eq("is_active", true)
    .lte("start_date", now)
    .gte("end_date", now)
    .order("start_date", { ascending: false });

  if (error) {
    console.error("Error fetching challenges:", error);
    return [];
  }
  return (data as Challenge[]) || [];
}

export async function getChallenge(id: string): Promise<Challenge | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("challenges")
    .select("*")
    .eq("id", id)
    .single();

  if (error) return null;
  return data as Challenge;
}

export async function getAllChallenges(): Promise<Challenge[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("challenges")
    .select("*")
    .order("start_date", { ascending: false });

  if (error) return [];
  return (data as Challenge[]) || [];
}

export async function getUserSubmission(
  challengeId: string,
  userId: string
): Promise<ChallengeSubmission | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("challenge_submissions")
    .select("*")
    .eq("challenge_id", challengeId)
    .eq("user_id", userId)
    .single();

  if (error) return null;
  return data as ChallengeSubmission;
}

// ============================================
// Leaderboard Queries
// ============================================

export async function getWeeklyLeaderboard(
  challengeId?: string,
  limit = 10
): Promise<LeaderboardEntry[]> {
  const supabase = await createClient();
  let query = supabase.from("leaderboard_weekly").select("*");

  if (challengeId) {
    query = query.eq("challenge_id", challengeId);
  }

  query = query.order("rank", { ascending: true }).limit(limit);

  const { data, error } = await query;
  if (error) {
    console.error("Error fetching weekly leaderboard:", error);
    return [];
  }
  return (data as LeaderboardEntry[]) || [];
}

export async function getMonthlyLeaderboard(
  challengeId?: string,
  limit = 10
): Promise<LeaderboardEntry[]> {
  const supabase = await createClient();
  let query = supabase.from("leaderboard_monthly").select("*");

  if (challengeId) {
    query = query.eq("challenge_id", challengeId);
  }

  query = query.order("rank", { ascending: true }).limit(limit);

  const { data, error } = await query;
  if (error) {
    console.error("Error fetching monthly leaderboard:", error);
    return [];
  }
  return (data as LeaderboardEntry[]) || [];
}

// ============================================
// Badge Queries
// ============================================

export async function getAllBadges(): Promise<Badge[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("badges")
    .select("*")
    .order("created_at", { ascending: true });

  if (error) return [];
  return (data as Badge[]) || [];
}

export async function getUserBadges(userId: string): Promise<UserBadge[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("user_badges")
    .select("*, badges(*)")
    .eq("user_id", userId)
    .order("earned_at", { ascending: false });

  if (error) return [];
  return (data as UserBadge[]) || [];
}

// ============================================
// Reward Queries
// ============================================

export async function getUserRewards(userId: string): Promise<Reward[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("rewards")
    .select("*")
    .eq("user_id", userId)
    .order("created_at", { ascending: false });

  if (error) return [];
  return (data as Reward[]) || [];
}

// ============================================
// Coupon Queries
// ============================================

export async function getCouponByCode(code: string): Promise<CouponCode | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("coupon_codes")
    .select("*")
    .eq("code", code.toUpperCase().trim())
    .single();

  if (error) return null;
  return data as CouponCode;
}

export async function getAllCoupons(): Promise<CouponCode[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("coupon_codes")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) return [];
  return (data as CouponCode[]) || [];
}

export async function getUserRedemptions(userId: string): Promise<CouponRedemption[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("coupon_redemptions")
    .select("*, coupon_codes(*)")
    .eq("user_id", userId)
    .order("redeemed_at", { ascending: false });

  if (error) return [];
  return (data as CouponRedemption[]) || [];
}

export async function getCouponRedemptionCount(couponId: string): Promise<number> {
  const supabase = await createClient();
  const { count } = await supabase
    .from("coupon_redemptions")
    .select("id", { count: "exact", head: true })
    .eq("coupon_id", couponId);

  return count ?? 0;
}
