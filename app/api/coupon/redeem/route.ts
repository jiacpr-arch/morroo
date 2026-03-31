import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

const PLATFORM = "medical"; // Change to "pharmacy" for pharmru.com

export async function POST(request: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ success: false, reason: "unauthorized" }, { status: 401 });
    }

    const body = await request.json();
    const { code } = body as { code?: string };

    if (!code || !code.trim()) {
      return NextResponse.json({ success: false, reason: "no_code" }, { status: 400 });
    }

    const upperCode = code.toUpperCase().trim();

    // Use admin client for DB operations (bypasses RLS)
    const admin = createAdminClient();

    // Fetch coupon (case-insensitive to handle legacy lowercase codes)
    const { data: coupon, error: couponError } = await admin
      .from("coupon_codes")
      .select("*")
      .ilike("code", upperCode)
      .single();

    if (couponError || !coupon) {
      return NextResponse.json({ success: false, reason: "not_found" });
    }

    // Validate coupon
    if (!coupon.is_active) {
      return NextResponse.json({ success: false, reason: "inactive" });
    }

    const now = new Date();
    if (coupon.starts_at && new Date(coupon.starts_at) > now) {
      return NextResponse.json({ success: false, reason: "not_started" });
    }

    if (coupon.expires_at && new Date(coupon.expires_at) < now) {
      return NextResponse.json({ success: false, reason: "expired" });
    }

    if (coupon.max_uses !== null && coupon.current_uses >= coupon.max_uses) {
      return NextResponse.json({ success: false, reason: "max_uses" });
    }

    // Check platform
    if (coupon.platform !== "all" && coupon.platform !== PLATFORM) {
      return NextResponse.json({ success: false, reason: "wrong_platform" });
    }

    // Check if user already used this coupon
    const { data: existing } = await admin
      .from("coupon_redemptions")
      .select("id")
      .eq("coupon_id", coupon.id)
      .eq("user_id", user.id)
      .single();

    if (existing) {
      return NextResponse.json({ success: false, reason: "already_used" });
    }

    // Redeem: insert redemption + increment current_uses
    const { error: redeemError } = await admin
      .from("coupon_redemptions")
      .insert({
        coupon_id: coupon.id,
        user_id: user.id,
        platform: PLATFORM,
      });

    if (redeemError) {
      return NextResponse.json({ success: false, reason: "redeem_failed" }, { status: 500 });
    }

    // Increment current_uses
    await admin
      .from("coupon_codes")
      .update({ current_uses: coupon.current_uses + 1 })
      .eq("id", coupon.id);

    // Apply benefit based on coupon type
    let benefit = "";

    switch (coupon.coupon_type) {
      case "free_month": {
        // Grant membership for X months
        const { data: profile } = await admin
          .from("profiles")
          .select("membership_type, membership_expires_at")
          .eq("id", user.id)
          .single();

        const currentExpiry = profile?.membership_expires_at
          ? new Date(profile.membership_expires_at)
          : null;
        const isCurrentlyActive = currentExpiry && currentExpiry > now;

        // If already active, extend from current expiry; otherwise from now
        const baseDate = isCurrentlyActive ? currentExpiry : now;
        const newExpiry = new Date(baseDate);
        newExpiry.setMonth(newExpiry.getMonth() + coupon.value);

        await admin
          .from("profiles")
          .update({
            membership_type: profile?.membership_type === "yearly" || profile?.membership_type === "bundle"
              ? profile.membership_type  // Don't downgrade yearly/bundle to monthly
              : "monthly",
            membership_expires_at: newExpiry.toISOString(),
          })
          .eq("id", user.id);

        benefit = `ฟรีสมาชิก ${coupon.value} เดือน (ถึง ${newExpiry.toLocaleDateString("th-TH")})`;
        break;
      }

      case "free_trial": {
        // Grant trial access: value = number of days of premium access
        const { data: profile } = await admin
          .from("profiles")
          .select("membership_type, membership_expires_at")
          .eq("id", user.id)
          .single();

        const currentExpiry = profile?.membership_expires_at
          ? new Date(profile.membership_expires_at)
          : null;
        const isCurrentlyActive = currentExpiry && currentExpiry > now;

        // If already active, extend; otherwise grant from now
        const baseDate = isCurrentlyActive ? currentExpiry : now;
        const newExpiry = new Date(baseDate);
        newExpiry.setDate(newExpiry.getDate() + coupon.value);

        // Only upgrade if user is free (don't downgrade paid users)
        const membershipType = profile?.membership_type === "yearly" || profile?.membership_type === "bundle"
          ? profile.membership_type
          : "monthly";

        await admin
          .from("profiles")
          .update({
            membership_type: membershipType,
            membership_expires_at: newExpiry.toISOString(),
          })
          .eq("id", user.id);

        benefit = `ทดลองใช้ฟรี ${coupon.value} วัน (ถึง ${newExpiry.toLocaleDateString("th-TH")})`;
        break;
      }

      case "discount_percent": {
        benefit = `ส่วนลด ${coupon.value}% (ใช้ได้ตอนซื้อแพ็กเกจ)`;
        break;
      }

      case "discount_fixed": {
        benefit = `ส่วนลด ${coupon.value} บาท (ใช้ได้ตอนซื้อแพ็กเกจ)`;
        break;
      }
    }

    return NextResponse.json({
      success: true,
      benefit,
      coupon_type: coupon.coupon_type,
      value: coupon.value,
    });
  } catch {
    return NextResponse.json({ success: false, reason: "server_error" }, { status: 500 });
  }
}
