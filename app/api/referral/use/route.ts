// Called after a new user registers with a referral code
// POST /api/referral/use  { referredUserId, referralCode }

import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { findReferrerByCode, REFERRAL_REWARD_DAYS } from "@/lib/referral";

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

  // Give referrer +7 days reward
  const { data: referrer } = await supabase
    .from("profiles")
    .select("membership_type, membership_expires_at")
    .eq("id", referrerId)
    .single();

  if (referrer) {
    const now = new Date();
    const base =
      referrer.membership_expires_at && new Date(referrer.membership_expires_at) > now
        ? new Date(referrer.membership_expires_at)
        : now;

    const newExpiry = new Date(base);
    newExpiry.setDate(newExpiry.getDate() + REFERRAL_REWARD_DAYS);

    await supabase
      .from("profiles")
      .update({ membership_expires_at: newExpiry.toISOString() })
      .eq("id", referrerId);

    await supabase
      .from("referrals")
      .update({ reward_given_at: now.toISOString() })
      .eq("referrer_id", referrerId)
      .eq("referred_id", referredUserId);
  }

  return NextResponse.json({ success: true });
}
