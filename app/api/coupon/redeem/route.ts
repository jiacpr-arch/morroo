import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

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

    // Fetch coupon
    const { data: coupon, error: couponError } = await supabase
      .from("coupon_codes")
      .select("*")
      .eq("code", upperCode)
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
    const { data: existing } = await supabase
      .from("coupon_redemptions")
      .select("id")
      .eq("coupon_id", coupon.id)
      .eq("user_id", user.id)
      .single();

    if (existing) {
      return NextResponse.json({ success: false, reason: "already_used" });
    }

    // Redeem: insert redemption + increment current_uses
    const { error: redeemError } = await supabase
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
    await supabase
      .from("coupon_codes")
      .update({ current_uses: coupon.current_uses + 1 })
      .eq("id", coupon.id);

    // Generate benefit description
    let benefit = "";
    switch (coupon.coupon_type) {
      case "free_trial":
        benefit = `ปลดล็อก ${coupon.value} ข้อฟรี`;
        break;
      case "discount_percent":
        benefit = `ส่วนลด ${coupon.value}%`;
        break;
      case "discount_fixed":
        benefit = `ส่วนลด ${coupon.value} บาท`;
        break;
      case "free_month":
        benefit = `ฟรีสมาชิก ${coupon.value} เดือน`;
        break;
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
