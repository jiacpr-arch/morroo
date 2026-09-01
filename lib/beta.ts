import type { Profile } from "./types";

export type EffectiveTier = "free" | "beta" | "beta_exhausted" | "paid";

export interface BetaStatus {
  tier: EffectiveTier;
  isBeta: boolean;
  betaEnrolledVia: "existing_user_upgrade" | "new_signup" | null;
  questionsUsed: number;
  questionsLimit: number;
  questionsRemaining: number;
  expiresAt: Date | null;
  daysLeft: number;
  isExpired: boolean;
  isQuotaExhausted: boolean;
  hasSeenWelcome: boolean;
  couponCode: string | null;
  couponIssuedAt: Date | null;
}

const PAID_TYPES = new Set(["monthly", "yearly", "bundle"]);

function isPaid(profile: Pick<Profile, "membership_type" | "membership_expires_at">): boolean {
  if (!PAID_TYPES.has(profile.membership_type)) return false;
  if (!profile.membership_expires_at) return true;
  return new Date(profile.membership_expires_at) > new Date();
}

export function computeBetaStatus(
  profile: Pick<
    Profile,
    | "membership_type"
    | "membership_expires_at"
    | "beta_enrolled_via"
    | "beta_started_at"
    | "beta_expires_at"
    | "beta_questions_used"
    | "beta_questions_limit"
    | "has_seen_beta_welcome"
    | "beta_coupon_code"
    | "beta_coupon_issued_at"
  > | null
): BetaStatus {
  const now = new Date();
  const empty: BetaStatus = {
    tier: "free",
    isBeta: false,
    betaEnrolledVia: null,
    questionsUsed: 0,
    questionsLimit: 25,
    questionsRemaining: 25,
    expiresAt: null,
    daysLeft: 0,
    isExpired: false,
    isQuotaExhausted: false,
    hasSeenWelcome: true,
    couponCode: null,
    couponIssuedAt: null,
  };

  if (!profile) return empty;
  if (isPaid(profile)) return { ...empty, tier: "paid", hasSeenWelcome: true };

  const expiresAt = profile.beta_expires_at ? new Date(profile.beta_expires_at) : null;
  if (!expiresAt || !profile.beta_enrolled_via) {
    return empty;
  }

  const used = profile.beta_questions_used ?? 0;
  const limit = profile.beta_questions_limit ?? 25;
  const remaining = Math.max(0, limit - used);
  const isExpired = expiresAt.getTime() <= now.getTime();
  const isExhausted = remaining === 0;
  const tier: EffectiveTier = isExpired || isExhausted ? "beta_exhausted" : "beta";
  const msLeft = expiresAt.getTime() - now.getTime();
  const daysLeft = isExpired ? 0 : Math.max(0, Math.ceil(msLeft / 86_400_000));

  return {
    tier,
    isBeta: true,
    betaEnrolledVia: profile.beta_enrolled_via,
    questionsUsed: used,
    questionsLimit: limit,
    questionsRemaining: remaining,
    expiresAt,
    daysLeft,
    isExpired,
    isQuotaExhausted: isExhausted,
    hasSeenWelcome: profile.has_seen_beta_welcome,
    couponCode: profile.beta_coupon_code,
    couponIssuedAt: profile.beta_coupon_issued_at
      ? new Date(profile.beta_coupon_issued_at)
      : null,
  };
}

export function formatThaiDate(date: Date): string {
  return date.toLocaleDateString("th-TH", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

export function formatHeaderCounter(s: BetaStatus): string {
  if (s.isExpired) return `🧪 Beta · หมดเขตแล้ว`;
  if (s.daysLeft <= 1) return `🧪 Beta · ${s.questionsUsed}/${s.questionsLimit} ข้อ · หมดเขตวันนี้!`;
  return `🧪 Beta · ${s.questionsUsed}/${s.questionsLimit} ข้อ · เหลือ ${s.daysLeft} วัน`;
}

export type CounterColor = "normal" | "warning" | "danger";

export function getHeaderCounterColor(s: BetaStatus): CounterColor {
  if (s.isExpired || s.daysLeft <= 1) return "danger";
  if (s.questionsUsed >= 21) return "warning";
  return "normal";
}

export function generateCouponCode(): string {
  // BETA-XXXXX where X is a random uppercase alphanumeric
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let suffix = "";
  for (let i = 0; i < 5; i++) {
    suffix += chars[Math.floor(Math.random() * chars.length)];
  }
  return `BETA-${suffix}`;
}

/**
 * Decide whether a new signup should be auto-enrolled as a beta tester.
 * The promo ends at `app_settings.beta_promo_ends_at` (ISO string).
 */
export function isPromoActive(promoEndsAt: string | null | undefined): boolean {
  if (!promoEndsAt) return false;
  const ends = new Date(promoEndsAt);
  if (Number.isNaN(ends.getTime())) return false;
  return ends.getTime() > Date.now();
}

export const BETA_DURATION_DAYS = 21;
export const BETA_QUESTION_LIMIT = 25;
