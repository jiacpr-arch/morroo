// Called after a new user registers with a referral code
// POST /api/referral/use  { referredUserId, referralCode }

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { findReferrerByCode, REFERRAL_REWARD_DAYS } from "@/lib/referral";
import { extendActiveProducts } from "@/lib/entitlements";

export const runtime = "nodejs";

export async function POST(req: NextRequest) {
  const { referredUserId, referralCode } = await req.json();

  if (!referredUserId || !referralCode) {
    return NextResponse.json({ error: "Missing fields" }, { status: 400 });
  }

  const supabase = createAdminClient();

  // Find referrer
  const referrerId = await findReferrerByCode(referralCode, supabase);
  if (!referrerId) {
    return NextResponse.json({ error: "Invalid referral code" }, { status: 404 });
  }

  // Don't let users refer themselves
  if (referrerId === referredUserId) {
    return NextResponse.json({ error: "Cannot refer yourself" }, { status: 400 });
  }

  // Check if this user was already referred
  const { data: existing } = await supabase
    .from("referrals")
    .select("id")
    .eq("referred_id", referredUserId)
    .single();

  if (existing) {
    return NextResponse.json({ message: "Already tracked" });
  }

  // Record the referral
  const { error: insertError } = await supabase.from("referrals").insert({
    referrer_id: referrerId,
    referred_id: referredUserId,
  });

  if (insertError) {
    console.error("Failed to insert referral:", insertError);
    return NextResponse.json({ error: "DB error" }, { status: 500 });
  }

  // Give referrer +7 days reward on every product they hold (student pack
  // when nothing is active). Also re-derives the legacy profile expiry.
  const rewarded = await extendActiveProducts(referrerId, REFERRAL_REWARD_DAYS, {
    source: "referral",
    reference: referredUserId,
  });

  if (rewarded) {
    const now = new Date();
    await supabase
      .from("referrals")
      .update({ reward_given_at: now.toISOString() })
      .eq("referrer_id", referrerId)
      .eq("referred_id", referredUserId);
  }

  return NextResponse.json({ success: true });
}
