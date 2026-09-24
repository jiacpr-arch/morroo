import { createAdminClient } from "@/lib/supabase/admin";
import { REFERRAL_REWARD_DAYS } from "@/lib/referral";

export type ApplyReferralResult =
  | { ok: true }
  | { ok: false; error: "lookup_failed" | "not_found" | "self" | "update_failed" | "insert_failed" };

/**
 * Record that `userId` signed up with referral `code`: sets profiles.referred_by
 * and creates a pending referrals row (rewarded when the user first buys).
 * Shared by the email sign-up (/api/referral/apply) and Google OAuth callback.
 */
export async function applyReferralCode(
  userId: string,
  code: string
): Promise<ApplyReferralResult> {
  const upperCode = code.trim().toUpperCase();
  const admin = createAdminClient();

  const { data: referrer, error: referrerErr } = await admin
    .from("profiles")
    .select("id")
    .eq("referral_code", upperCode)
    .maybeSingle();

  if (referrerErr) return { ok: false, error: "lookup_failed" };
  if (!referrer) return { ok: false, error: "not_found" };
  if (referrer.id === userId) return { ok: false, error: "self" };

  const { error: updateErr } = await admin
    .from("profiles")
    .update({ referred_by: upperCode })
    .eq("id", userId);
  if (updateErr) return { ok: false, error: "update_failed" };

  const { error: insertErr } = await admin.from("referrals").insert({
    referrer_id: referrer.id,
    referred_id: userId,
    code: upperCode,
    status: "pending",
    reward_days: REFERRAL_REWARD_DAYS,
  });
  if (insertErr) return { ok: false, error: "insert_failed" };

  return { ok: true };
}
