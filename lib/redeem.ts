import crypto from "crypto";
import { createAdminClient } from "@/lib/supabase/admin";

export type RewardType = "monthly_1m" | "bundle_10q";
export type RedeemSource =
  | "fb_leadgen_form"
  | "fb_messenger"
  | "line_oa"
  | "landing"
  | "organic"
  | "admin";

const CODE_PREFIX = "MORROO";
const CODE_TTL_DAYS = 7;
const BUNDLE_QUESTION_COUNT = 10;
const MONTHLY_DURATION_DAYS = 30;

// Crockford base32 — drops I, L, O, U to avoid confusion with 1/0/V.
const ALPHABET = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

function randomSegment(length: number): string {
  const bytes = crypto.randomBytes(length);
  let out = "";
  for (let i = 0; i < length; i++) {
    out += ALPHABET[bytes[i] % ALPHABET.length];
  }
  return out;
}

export function formatRedeemCode(): string {
  return `${CODE_PREFIX}-${randomSegment(4)}-${randomSegment(4)}`;
}

export type IssueRedeemCodeArgs = {
  rewardType: RewardType;
  source: RedeemSource;
  campaign?: string;
  leadId?: string;
  issuedToEmail?: string;
};

export type IssuedRedeemCode = {
  code: string;
  rewardType: RewardType;
  expiresAt: Date;
};

/**
 * Generate a unique redeem code and persist it. Retries on the unlikely event
 * of a primary-key collision (1 in ~1T per attempt).
 */
export async function issueRedeemCode(
  args: IssueRedeemCodeArgs
): Promise<IssuedRedeemCode> {
  const supabase = createAdminClient();
  const expiresAt = new Date(
    Date.now() + CODE_TTL_DAYS * 24 * 60 * 60 * 1000
  );

  for (let attempt = 0; attempt < 5; attempt++) {
    const code = formatRedeemCode();
    const { error } = await supabase.from("redeem_codes").insert({
      code,
      reward_type: args.rewardType,
      source: args.source,
      campaign: args.campaign ?? null,
      lead_id: args.leadId ?? null,
      issued_to_email: args.issuedToEmail ?? null,
      expires_at: expiresAt.toISOString(),
    });

    if (!error) {
      return { code, rewardType: args.rewardType, expiresAt };
    }

    // 23505 = unique_violation; only retry on PK collision.
    if (error.code !== "23505") {
      throw new Error(`issueRedeemCode failed: ${error.message}`);
    }
  }

  throw new Error("issueRedeemCode failed: too many code collisions");
}

export type RedeemError =
  | "not_found"
  | "expired"
  | "already_redeemed"
  | "apply_failed";

export type RedeemResult =
  | { ok: true; rewardType: RewardType }
  | { ok: false; error: RedeemError };

/**
 * Atomically validate a redeem code and apply its entitlement to the user.
 *
 * The race-free claim uses an UPDATE…WHERE redeemed_at IS NULL guarded by the
 * code, so two concurrent redeem attempts from the same user yield exactly
 * one winner. Entitlement application happens only after the claim succeeds.
 */
export async function redeemCode(
  code: string,
  userId: string
): Promise<RedeemResult> {
  const supabase = createAdminClient();

  const { data: row, error: lookupError } = await supabase
    .from("redeem_codes")
    .select("code, reward_type, expires_at, redeemed_at, lead_id")
    .eq("code", code)
    .maybeSingle();

  if (lookupError) {
    console.error("redeemCode lookup failed:", lookupError);
    return { ok: false, error: "apply_failed" };
  }
  if (!row) return { ok: false, error: "not_found" };
  if (row.redeemed_at) return { ok: false, error: "already_redeemed" };
  if (new Date(row.expires_at) < new Date()) {
    return { ok: false, error: "expired" };
  }

  // Claim the code — only one writer wins.
  const { data: claimed, error: claimError } = await supabase
    .from("redeem_codes")
    .update({
      redeemed_by: userId,
      redeemed_at: new Date().toISOString(),
    })
    .eq("code", code)
    .is("redeemed_at", null)
    .select("code, reward_type")
    .maybeSingle();

  if (claimError) {
    console.error("redeemCode claim failed:", claimError);
    return { ok: false, error: "apply_failed" };
  }
  if (!claimed) return { ok: false, error: "already_redeemed" };

  const rewardType = claimed.reward_type as RewardType;
  const applied = await applyReward(userId, rewardType, code);

  if (!applied) {
    // Roll the claim back so the user can retry.
    await supabase
      .from("redeem_codes")
      .update({ redeemed_by: null, redeemed_at: null })
      .eq("code", code);
    return { ok: false, error: "apply_failed" };
  }

  if (row.lead_id) {
    await supabase
      .from("leads")
      .update({
        stage: "redeemed",
        user_id: userId,
        updated_at: new Date().toISOString(),
      })
      .eq("id", row.lead_id);
  }

  return { ok: true, rewardType };
}

async function applyReward(
  userId: string,
  rewardType: RewardType,
  code: string
): Promise<boolean> {
  const supabase = createAdminClient();

  if (rewardType === "monthly_1m") {
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_expires_at")
      .eq("id", userId)
      .maybeSingle();

    // Stack on top of any unexpired entitlement.
    const now = new Date();
    const base =
      profile?.membership_expires_at &&
      new Date(profile.membership_expires_at) > now
        ? new Date(profile.membership_expires_at)
        : now;
    const newExpiry = new Date(
      base.getTime() + MONTHLY_DURATION_DAYS * 24 * 60 * 60 * 1000
    );

    const { error } = await supabase
      .from("profiles")
      .update({
        membership_type: "monthly",
        membership_expires_at: newExpiry.toISOString(),
      })
      .eq("id", userId);

    if (error) {
      console.error("applyReward monthly failed:", error);
      return false;
    }
    return true;
  }

  // bundle_10q
  const { error } = await supabase.from("bundle_credits").insert({
    user_id: userId,
    delta: BUNDLE_QUESTION_COUNT,
    source: "redeem",
    reference: code,
  });

  if (error) {
    console.error("applyReward bundle failed:", error);
    return false;
  }
  return true;
}

export async function bundleCreditBalance(userId: string): Promise<number> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("bundle_credits")
    .select("delta")
    .eq("user_id", userId);
  if (error) {
    console.error("bundleCreditBalance failed:", error);
    return 0;
  }
  return (data ?? []).reduce((sum, r) => sum + (r.delta ?? 0), 0);
}
