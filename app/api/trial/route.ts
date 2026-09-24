import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { getTrialStatus, grantSignupTrial, TRIAL_FULL_PRICES } from "@/lib/trial";

// Only accounts created within this window can start the sign-up trial, so an
// old free account can't claim it by calling the endpoint.
const NEW_ACCOUNT_WINDOW_MS = 24 * 60 * 60 * 1000;

/**
 * POST /api/trial — the signed-in user's free-trial status (for TrialBanner).
 *
 * Also starts the 7-day sign-up trial for a new account that doesn't have one
 * yet. Google and LINE sign-ups get it in their auth callbacks; email sign-ups
 * only get a session after confirming their email, so their first page load
 * after login lands here. Idempotent via the one-trial-per-account rule.
 */
export async function POST() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ active: false });

  let status = await getTrialStatus(user.id);
  const createdAt = user.created_at ? new Date(user.created_at).getTime() : 0;
  if (!status.active && Date.now() - createdAt < NEW_ACCOUNT_WINDOW_MS) {
    if (await grantSignupTrial(user.id, user.email)) {
      status = await getTrialStatus(user.id);
    }
  }

  return NextResponse.json({ ...status, prices: TRIAL_FULL_PRICES });
}
