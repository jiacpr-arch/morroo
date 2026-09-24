import { createAdminClient } from "@/lib/supabase/admin";
import {
  hasUsedTrial,
  issueRedeemCode,
  redeemCode,
  TRIAL_DURATION_DAYS,
} from "@/lib/redeem";
import { PLAN_CATALOG } from "@/lib/membership";

/** Campaign tag on the redeem code auto-issued at sign-up. */
export const SIGNUP_TRIAL_CAMPAIGN = "signup_trial";

/** Full list prices shown next to the trial countdown. */
export const TRIAL_FULL_PRICES = {
  monthly: PLAN_CATALOG.monthly.amount,
  yearly: PLAN_CATALOG.yearly.amount,
};

/**
 * Give a brand-new account its 7-day free trial (student pack).
 *
 * The grant goes through a self-issued, self-redeemed trial code so it shares
 * the one-trial-per-account rule with lead / bot codes (see hasUsedTrial):
 * a user who already redeemed a trial code gets nothing here, and a user who
 * got the sign-up trial can't redeem another code later.
 *
 * Returns the trial's end date, or null when nothing was granted.
 */
export async function grantSignupTrial(
  userId: string,
  email?: string | null
): Promise<Date | null> {
  if (await hasUsedTrial(userId)) return null;

  try {
    const issued = await issueRedeemCode({
      rewardType: "monthly_1m",
      source: "organic",
      campaign: SIGNUP_TRIAL_CAMPAIGN,
      issuedToEmail: email ?? undefined,
    });
    const result = await redeemCode(issued.code, userId);
    if (!result.ok) {
      console.error("[trial] signup trial redeem failed:", result.error);
      return null;
    }
    return new Date(Date.now() + TRIAL_DURATION_DAYS * 86_400_000);
  } catch (err) {
    console.error("[trial] signup trial grant failed:", err);
    return null;
  }
}

export type TrialStatus =
  | { active: false }
  | { active: true; startedAt: string; endsAt: string; daysLeft: number };

/**
 * The user's free trial, if one is running right now. A user who has since
 * paid (latest entitlement came from Stripe / a slip) is not "on trial".
 */
export async function getTrialStatus(userId: string): Promise<TrialStatus> {
  const admin = createAdminClient();

  const { data: trial } = await admin
    .from("redeem_codes")
    .select("redeemed_at")
    .eq("redeemed_by", userId)
    .eq("reward_type", "monthly_1m")
    .not("redeemed_at", "is", null)
    .order("redeemed_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (!trial?.redeemed_at) return { active: false };

  const startedAt = new Date(trial.redeemed_at);
  const endsAt = new Date(startedAt.getTime() + TRIAL_DURATION_DAYS * 86_400_000);
  const msLeft = endsAt.getTime() - Date.now();
  if (msLeft <= 0) return { active: false };

  const { count: paid } = await admin
    .from("membership_entitlements")
    .select("product", { count: "exact", head: true })
    .eq("user_id", userId)
    .in("source", ["stripe", "slip"]);
  if ((paid ?? 0) > 0) return { active: false };

  return {
    active: true,
    startedAt: startedAt.toISOString(),
    endsAt: endsAt.toISOString(),
    daysLeft: Math.max(1, Math.ceil(msLeft / 86_400_000)),
  };
}
