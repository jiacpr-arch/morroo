// Referral code utilities
// Referral code = first 8 hex chars of user UUID (uppercase), deterministic — no DB needed

export function getReferralCode(userId: string): string {
  return userId.replace(/-/g, "").slice(0, 8).toUpperCase();
}

export function getReferralLink(userId: string, baseUrl = "https://www.morroo.com"): string {
  return `${baseUrl}/register?ref=${getReferralCode(userId)}`;
}

// Validate that a string looks like a referral code (8 hex chars)
export function isValidReferralCode(code: string): boolean {
  return /^[0-9A-F]{8}$/i.test(code);
}

// Find user ID by referral code prefix
// Returns null if not found
export async function findReferrerByCode(
  code: string,
  supabase: ReturnType<typeof import("@/lib/supabase/admin").createAdminClient>
): Promise<string | null> {
  if (!isValidReferralCode(code)) return null;

  // Find profile whose UUID starts with the code (after removing dashes)
  const { data } = await supabase
    .from("profiles")
    .select("id")
    .ilike("id", `${code.toLowerCase()}%`);

  return data?.[0]?.id ?? null;
}

export const REFERRAL_REWARD_DAYS = 7; // days added to referrer's membership
