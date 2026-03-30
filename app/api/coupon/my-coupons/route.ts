import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

export async function GET() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
    }

    // Get used coupons
    const { data: redemptions } = await supabase
      .from("coupon_redemptions")
      .select("*, coupon_codes(*)")
      .eq("user_id", user.id)
      .order("redeemed_at", { ascending: false });

    // Get reward coupons (unclaimed)
    const { data: rewards } = await supabase
      .from("rewards")
      .select("*")
      .eq("user_id", user.id)
      .not("coupon_code", "is", null)
      .order("created_at", { ascending: false });

    return NextResponse.json({
      used: redemptions || [],
      rewards: rewards || [],
    });
  } catch {
    return NextResponse.json({ error: "server_error" }, { status: 500 });
  }
}
