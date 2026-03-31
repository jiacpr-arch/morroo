import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";

export async function GET() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "กรุณาเข้าสู่ระบบก่อน" }, { status: 401 });
    }

    const admin = createAdminClient();

    // Get used coupons with coupon details
    const { data: redemptions } = await admin
      .from("coupon_redemptions")
      .select("*, coupon_codes(*)")
      .eq("user_id", user.id)
      .order("redeemed_at", { ascending: false });

    return NextResponse.json({
      used: redemptions || [],
    });
  } catch {
    return NextResponse.json({ error: "server_error" }, { status: 500 });
  }
}
