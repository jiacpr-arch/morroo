// ============================================
// Standard Features Types
// Difficulty Levels, Competition, Coupon System
// ============================================

// ---- Difficulty Levels ----

export const DIFFICULTY_LEVELS = [
  { level: 1, label_th: "พื้นฐาน", label_en: "Basic", color: "green", hex: "#22c55e" },
  { level: 2, label_th: "ประยุกต์", label_en: "Applied", color: "yellow", hex: "#eab308" },
  { level: 3, label_th: "ขั้นสูง", label_en: "Advanced", color: "red", hex: "#ef4444" },
] as const;

export type DifficultyLevel = 1 | 2 | 3;

export function getDifficultyInfo(level: DifficultyLevel) {
  return DIFFICULTY_LEVELS.find((d) => d.level === level) ?? DIFFICULTY_LEVELS[0];
}

// ---- Competition System ----

export interface Challenge {
  id: string;
  title: string;
  description: string | null;
  challenge_type: "weekly" | "monthly";
  start_date: string;
  end_date: string;
  question_ids: string[];
  is_active: boolean;
  created_at: string;
}

export interface ChallengeSubmission {
  id: string;
  challenge_id: string;
  user_id: string;
  score: number;
  total_questions: number;
  correct_answers: number;
  time_taken_seconds: number | null;
  submitted_at: string;
}

export interface LeaderboardEntry {
  user_id: string;
  display_name: string | null;
  name: string | null;
  avatar_url: string | null;
  score: number;
  correct_answers: number;
  total_questions: number;
  time_taken_seconds: number | null;
  challenge_id: string;
  challenge_title: string;
  start_date: string;
  end_date: string;
  rank: number;
}

export interface Badge {
  id: string;
  name: string;
  name_th: string;
  description: string;
  description_th: string;
  icon_url: string | null;
  condition_type: string;
  condition_value: number;
  created_at: string;
}

export interface UserBadge {
  id: string;
  user_id: string;
  badge_id: string;
  earned_at: string;
  badges?: Badge;
}

export interface Reward {
  id: string;
  challenge_id: string;
  user_id: string;
  reward_type: "free_month" | "discount_50" | "certificate" | "badge";
  coupon_code: string | null;
  is_claimed: boolean;
  created_at: string;
}

// ---- Coupon System ----

export type CouponType = "free_trial" | "discount_percent" | "discount_fixed" | "free_month";
export type CouponPlatform = "medical" | "pharmacy" | "all";

export interface CouponCode {
  id: string;
  code: string;
  description: string | null;
  coupon_type: CouponType;
  value: number;
  platform: CouponPlatform;
  max_uses: number | null;
  max_uses_per_user: number;
  current_uses: number;
  starts_at: string;
  expires_at: string | null;
  source: string | null;
  is_active: boolean;
  created_at: string;
  created_by: string | null;
}

export interface CouponRedemption {
  id: string;
  coupon_id: string;
  user_id: string;
  redeemed_at: string;
  platform: "medical" | "pharmacy";
  coupon_codes?: CouponCode;
}

export const COUPON_TYPE_LABELS: Record<CouponType, string> = {
  free_trial: "ทดลองฟรี",
  discount_percent: "ลดเป็น %",
  discount_fixed: "ลดเป็นบาท",
  free_month: "ฟรี X เดือน",
};

export const BADGE_ICONS: Record<string, string> = {
  streak: "🔥",
  total_correct: "💯",
  top_rank: "🏆",
  speed: "⚡",
  challenge_complete: "🎯",
  total_correct_advanced: "🔬",
};
