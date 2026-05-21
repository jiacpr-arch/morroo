/**
 * Central membership access helpers — single source of truth for which tier
 * grants what. Replace ad-hoc `=== "monthly" || === "yearly"` checks
 * throughout the codebase.
 *
 * Tier hierarchy:
 *   free                 → free quotas only
 *   bundle               → 10 questions, lifetime
 *   monthly / yearly     → student full access (NL MCQ, MEQ, long case)
 *   board_monthly / board_yearly → board MCQ + oral exam access
 *
 * Note: `monthly` / `yearly` (student full) DOES NOT include board access by
 * default — board is a separate add-on tier. Users can hold both
 * simultaneously via separate purchases. The `bundle` 10-question plan also
 * does not include board.
 */

export type MembershipType =
  | "free"
  | "bundle"
  | "monthly"
  | "yearly"
  | "mcq_monthly"
  | "mcq_yearly"
  | "meq_monthly"
  | "meq_yearly"
  | "longcase_monthly"
  | "longcase_yearly"
  | "board_monthly"
  | "board_yearly";

const FULL_STUDENT_TIERS = new Set<MembershipType>([
  "monthly",
  "yearly",
  "bundle",
]);

const BOARD_TIERS = new Set<MembershipType>(["board_monthly", "board_yearly"]);

const ANY_PAID_TIERS = new Set<MembershipType>([
  "bundle",
  "monthly",
  "yearly",
  "mcq_monthly",
  "mcq_yearly",
  "meq_monthly",
  "meq_yearly",
  "longcase_monthly",
  "longcase_yearly",
  "board_monthly",
  "board_yearly",
]);

interface MembershipLike {
  membership_type?: string | null;
  membership_expires_at?: string | null;
}

function isExpired(profile: MembershipLike | null | undefined): boolean {
  if (!profile?.membership_expires_at) return false;
  return new Date(profile.membership_expires_at) < new Date();
}

function hasTier(
  profile: MembershipLike | null | undefined,
  tiers: Set<MembershipType>
): boolean {
  if (!profile?.membership_type) return false;
  if (isExpired(profile)) return false;
  return tiers.has(profile.membership_type as MembershipType);
}

/** Full student access — NL MCQ unlimited, MEQ, long case student */
export function hasFullStudentAccess(
  profile: MembershipLike | null | undefined
): boolean {
  return hasTier(profile, FULL_STUDENT_TIERS);
}

/** Board access — board MCQ unlimited, oral exam */
export function hasBoardAccess(
  profile: MembershipLike | null | undefined
): boolean {
  return hasTier(profile, BOARD_TIERS);
}

/** Any paid plan, used for some UI affordances */
export function isPremium(
  profile: MembershipLike | null | undefined
): boolean {
  return hasTier(profile, ANY_PAID_TIERS);
}
