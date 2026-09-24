import crypto from "crypto";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  COUPON_PLATFORM,
  couponGrantPlan,
  couponRewardDays,
  isSelfServeCoupon,
} from "@/lib/coupons";
import { grantPlanDays, grantProduct } from "@/lib/entitlements";
import { isPlanType } from "@/lib/membership";
import { isItemPlan } from "@/lib/items";
import { resolveItem } from "@/lib/billing/plan-resolver";

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
// The "monthly_1m" reward type keeps its stored name, but a free trial is now
// 7 days and only one trial code may ever be redeemed per account.
export const TRIAL_DURATION_DAYS = 7;
const TRIAL_REWARD_TYPE: RewardType = "monthly_1m";

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
  | "apply_failed"
  // the account has already redeemed a free-trial code
  | "trial_used"
  // coupon_codes-specific (see redeemCouponCode)
  | "inactive"
  | "not_started"
  | "exhausted"
  | "wrong_platform"
  | "checkout_only";

/** Reward granted by a code: lead redeem_codes reward, or a coupon_codes type. */
export type RedeemRewardType = RewardType | "free_trial" | "free_month";

export type RedeemResult =
  | { ok: true; rewardType: RedeemRewardType; days?: number }
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
  // Not a lead redeem code → try the coupon_codes table (admin-issued vouchers).
  if (!row) return redeemCouponCode(code, userId);
  if (row.redeemed_at) return { ok: false, error: "already_redeemed" };
  if (new Date(row.expires_at) < new Date()) {
    return { ok: false, error: "expired" };
  }
  if (row.reward_type === TRIAL_REWARD_TYPE && (await hasUsedTrial(userId))) {
    return { ok: false, error: "trial_used" };
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

  // Re-check after the claim so two different trial codes redeemed at the same
  // moment can't both go through.
  if (rewardType === TRIAL_REWARD_TYPE && (await hasUsedTrial(userId, code))) {
    await supabase
      .from("redeem_codes")
      .update({ redeemed_by: null, redeemed_at: null })
      .eq("code", code);
    return { ok: false, error: "trial_used" };
  }

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

/**
 * true when the user has already redeemed a free-trial code (optionally
 * ignoring `exceptCode`, the one being redeemed right now).
 */
export async function hasUsedTrial(
  userId: string,
  exceptCode?: string
): Promise<boolean> {
  const supabase = createAdminClient();
  let query = supabase
    .from("redeem_codes")
    .select("code", { count: "exact", head: true })
    .eq("redeemed_by", userId)
    .eq("reward_type", TRIAL_REWARD_TYPE)
    .not("redeemed_at", "is", null);
  if (exceptCode) query = query.neq("code", exceptCode);
  const { count, error } = await query;
  if (error) {
    console.error("hasUsedTrial lookup failed:", error);
    return false;
  }
  return (count ?? 0) > 0;
}

async function applyReward(
  userId: string,
  rewardType: RewardType,
  code: string
): Promise<boolean> {
  const supabase = createAdminClient();

  if (rewardType === TRIAL_REWARD_TYPE) {
    return extendMembershipDays(userId, TRIAL_DURATION_DAYS);
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

/**
 * Grant `days` of the student pack (mcq + meq + longcase + school), stacking
 * on top of any unexpired entitlement so a user who redeems mid-subscription
 * doesn't lose time. The legacy profile columns are re-derived afterwards.
 */
export async function extendMembershipDays(
  userId: string,
  days: number
): Promise<boolean> {
  return grantPlanDays(userId, "monthly", days, { source: "redeem" });
}

const COUPON_RPC_ERRORS: ReadonlySet<RedeemError> = new Set([
  "not_found",
  "inactive",
  "wrong_platform",
  "not_started",
  "expired",
  "exhausted",
  "already_redeemed",
]);

/**
 * Redeem an admin-issued coupon (coupon_codes). Validation + claim happen
 * atomically inside the `redeem_coupon_code` RPC
 * (supabase/migrations/20260912_coupon_codes.sql); the membership grant is
 * applied afterwards and rolled back via `unredeem_coupon_code` on failure.
 *
 * Only free_trial / free_month coupons are self-serve; discount coupons are
 * rejected with `checkout_only` before anything is consumed.
 */
export async function redeemCouponCode(
  code: string,
  userId: string
): Promise<RedeemResult> {
  const supabase = createAdminClient();

  const { data: coupon, error: lookupError } = await supabase
    .from("coupon_codes")
    .select("id, coupon_type, value, plan_type")
    .eq("code", code)
    .maybeSingle();
  if (lookupError) {
    console.error("redeemCouponCode lookup failed:", lookupError);
    return { ok: false, error: "apply_failed" };
  }
  if (!coupon) return { ok: false, error: "not_found" };
  if (!isSelfServeCoupon(coupon.coupon_type)) {
    return { ok: false, error: "checkout_only" };
  }

  const { data: claimed, error: claimError } = await supabase.rpc(
    "redeem_coupon_code",
    { p_code: code, p_user_id: userId, p_platform: COUPON_PLATFORM }
  );
  if (claimError) {
    const msg = (claimError.message ?? "").trim() as RedeemError;
    if (COUPON_RPC_ERRORS.has(msg)) return { ok: false, error: msg };
    console.error("redeemCouponCode claim failed:", claimError);
    return { ok: false, error: "apply_failed" };
  }
  const row = (Array.isArray(claimed) ? claimed[0] : claimed) as
    | { coupon_id: string; coupon_type: string; value: number }
    | undefined;
  if (!row || !isSelfServeCoupon(row.coupon_type)) {
    return { ok: false, error: "apply_failed" };
  }

  const days = couponRewardDays(row.coupon_type, row.value);
  const applied = await grantCouponPlan(userId, couponGrantPlan(coupon.plan_type), days, code);
  if (!applied) {
    await supabase.rpc("unredeem_coupon_code", {
      p_coupon_id: row.coupon_id,
      p_user_id: userId,
    });
    return { ok: false, error: "apply_failed" };
  }

  return { ok: true, rewardType: row.coupon_type, days };
}

/**
 * Apply `days` of whatever a free coupon points at: a PLAN_CATALOG plan
 * (student pack by default, or Board / MCQ / … alone) or a single item
 * (one specialty / subject / exam / case / topic).
 */
async function grantCouponPlan(
  userId: string,
  planType: string,
  days: number,
  code: string
): Promise<boolean> {
  if (isPlanType(planType)) {
    return grantPlanDays(userId, planType, days, { source: "coupon", reference: code });
  }
  if (isItemPlan(planType)) {
    const item = await resolveItem(planType);
    if (!item) {
      console.error("redeemCouponCode: unknown item plan", planType);
      return false;
    }
    return grantProduct(userId, item.product, days, {
      source: "coupon",
      reference: code,
      scope: item.scope,
    });
  }
  console.error("redeemCouponCode: unknown plan", planType);
  return false;
}
