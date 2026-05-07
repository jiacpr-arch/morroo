import crypto from "crypto";
import type { SupabaseClient } from "@supabase/supabase-js";

export type RewardType = "monthly_1m" | "bundle_10q";

export interface RedeemCode {
  code: string;
  reward_type: RewardType;
  source: string;
  campaign: string | null;
  lead_id: string | null;
  issued_to_email: string | null;
  redeemed_by: string | null;
  redeemed_at: string | null;
  expires_at: string;
}

export const REDEEM_CODE_TTL_DAYS = 7;
export const MONTHLY_TRIAL_DAYS = 30;
export const BUNDLE_EXPIRY_YEARS = 99;

// Crockford base32 alphabet (no I, L, O, U) — easier to read/type than hex
const ALPHABET = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

function randomChunk(len: number): string {
  const bytes = crypto.randomBytes(len);
  let out = "";
  for (let i = 0; i < len; i++) {
    out += ALPHABET[bytes[i] % ALPHABET.length];
  }
  return out;
}

export function generateCodeString(): string {
  return `MORROO-${randomChunk(4)}-${randomChunk(4)}`;
}

export function isValidCodeFormat(code: string): boolean {
  return /^MORROO-[0-9A-HJKMNP-TV-Z]{4}-[0-9A-HJKMNP-TV-Z]{4}$/i.test(code);
}

export interface IssueCodeArgs {
  supabase: SupabaseClient;
  rewardType: RewardType;
  source: string;
  campaign?: string | null;
  leadId?: string | null;
  email?: string | null;
}

/**
 * Issue a redeem code. Idempotent on (lead_id, reward_type) — if a code already exists
 * for that pair, returns the existing one instead of creating a new row.
 */
export async function issueRedeemCode({
  supabase,
  rewardType,
  source,
  campaign = null,
  leadId = null,
  email = null,
}: IssueCodeArgs): Promise<RedeemCode> {
  if (leadId) {
    const { data: existing } = await supabase
      .from("redeem_codes")
      .select("*")
      .eq("lead_id", leadId)
      .eq("reward_type", rewardType)
      .maybeSingle();
    if (existing) return existing as RedeemCode;
  }

  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + REDEEM_CODE_TTL_DAYS);

  // Retry on rare collisions
  for (let attempt = 0; attempt < 5; attempt++) {
    const code = generateCodeString();
    const { data, error } = await supabase
      .from("redeem_codes")
      .insert({
        code,
        reward_type: rewardType,
        source,
        campaign,
        lead_id: leadId,
        issued_to_email: email,
        expires_at: expiresAt.toISOString(),
      })
      .select("*")
      .single();
    if (!error && data) return data as RedeemCode;
    if (error && !/duplicate key|unique constraint/i.test(error.message)) {
      throw new Error(`failed to issue redeem code: ${error.message}`);
    }
  }
  throw new Error("failed to issue redeem code after 5 attempts");
}

export type ApplyResult =
  | { ok: true; rewardType: RewardType; expiresAt: string }
  | { ok: false; reason: "invalid" | "expired" | "already_redeemed" | "user_already_redeemed" | "error"; message: string };

/**
 * Validate + apply a redeem code for a logged-in user. On success the user's
 * profile is upgraded (Monthly: +30 days; Bundle: +99 years) and the code is
 * marked redeemed. Idempotent: re-running with the same (code,user) is safe.
 */
export async function redeemCode(
  supabase: SupabaseClient,
  code: string,
  userId: string
): Promise<ApplyResult> {
  if (!isValidCodeFormat(code)) {
    return { ok: false, reason: "invalid", message: "รูปแบบโค้ดไม่ถูกต้อง" };
  }

  const normalized = code.toUpperCase();

  const { data: row, error: fetchErr } = await supabase
    .from("redeem_codes")
    .select("*")
    .eq("code", normalized)
    .maybeSingle();

  if (fetchErr) {
    return { ok: false, reason: "error", message: fetchErr.message };
  }
  if (!row) {
    return { ok: false, reason: "invalid", message: "ไม่พบโค้ดนี้ในระบบ" };
  }

  const r = row as RedeemCode;

  if (r.redeemed_by && r.redeemed_by === userId) {
    return { ok: true, rewardType: r.reward_type, expiresAt: r.redeemed_at ?? new Date().toISOString() };
  }

  if (r.redeemed_by) {
    return { ok: false, reason: "already_redeemed", message: "โค้ดนี้ถูกใช้ไปแล้ว" };
  }

  if (new Date(r.expires_at) < new Date()) {
    return { ok: false, reason: "expired", message: "โค้ดนี้หมดอายุแล้ว" };
  }

  const { data: existingForUser } = await supabase
    .from("redeem_codes")
    .select("code")
    .eq("redeemed_by", userId)
    .maybeSingle();
  if (existingForUser) {
    return {
      ok: false,
      reason: "user_already_redeemed",
      message: "บัญชีนี้เคยใช้สิทธิ์รางวัลแล้ว — 1 บัญชีต่อ 1 โค้ดเท่านั้น",
    };
  }

  const now = new Date();
  const newExpiry = new Date(now);
  if (r.reward_type === "monthly_1m") {
    newExpiry.setDate(newExpiry.getDate() + MONTHLY_TRIAL_DAYS);
  } else {
    newExpiry.setFullYear(newExpiry.getFullYear() + BUNDLE_EXPIRY_YEARS);
  }
  const membershipType = r.reward_type === "monthly_1m" ? "monthly" : "bundle";

  const { error: profileErr } = await supabase
    .from("profiles")
    .update({
      membership_type: membershipType,
      membership_expires_at: newExpiry.toISOString(),
    })
    .eq("id", userId);
  if (profileErr) {
    return { ok: false, reason: "error", message: profileErr.message };
  }

  const { error: markErr } = await supabase
    .from("redeem_codes")
    .update({
      redeemed_by: userId,
      redeemed_at: now.toISOString(),
    })
    .eq("code", normalized)
    .is("redeemed_by", null);
  if (markErr) {
    return { ok: false, reason: "error", message: markErr.message };
  }

  if (r.lead_id) {
    await supabase
      .from("leads")
      .update({ stage: "redeemed", user_id: userId })
      .eq("id", r.lead_id);
  }

  return { ok: true, rewardType: r.reward_type, expiresAt: newExpiry.toISOString() };
}
