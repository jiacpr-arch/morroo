import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { code } = body as { code?: string };

    if (!code || !code.trim()) {
      return NextResponse.json({ valid: false, reason: "no_code" }, { status: 400 });
    }

    const supabase = await createClient();
    const { data: coupon, error } = await supabase
      .from("coupon_codes")
      .select("*")
      .ilike("code", code.toUpperCase().trim())
      .single();

    if (error || !coupon) {
      return NextResponse.json({ valid: false, reason: "not_found" });
    }

    if (!coupon.is_active) {
      return NextResponse.json({ valid: false, reason: "inactive" });
    }

    const now = new Date();
    if (coupon.starts_at && new Date(coupon.starts_at) > now) {
      return NextResponse.json({ valid: false, reason: "not_started" });
    }

    if (coupon.expires_at && new Date(coupon.expires_at) < now) {
      return NextResponse.json({ valid: false, reason: "expired" });
    }

    if (coupon.max_uses !== null && coupon.current_uses >= coupon.max_uses) {
      return NextResponse.json({ valid: false, reason: "max_uses" });
    }

    return NextResponse.json({
      valid: true,
      coupon_type: coupon.coupon_type,
      value: coupon.value,
      description: coupon.description,
      platform: coupon.platform,
      expires_at: coupon.expires_at,
    });
  } catch {
    return NextResponse.json({ valid: false, reason: "server_error" }, { status: 500 });
  }
}
