import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { REFERRAL_REWARD_DAYS } from "@/lib/referral";
import { applyReferralCode } from "@/lib/referral-apply";

// POST /api/referral/apply
// Body: { code: string }
// ใช้ตอน register เพื่อบันทึก referred_by และสร้าง referral record
// userId มาจาก session ห้ามไว้ใจ body (กันคนเปลี่ยน referred_by ของคนอื่น)
export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { code } = await request.json();
  if (!code || typeof code !== "string") {
    return NextResponse.json({ error: "Missing code" }, { status: 400 });
  }

  const result = await applyReferralCode(user.id, code);
  if (!result.ok) {
    const errors: Record<typeof result.error, [string, number]> = {
      lookup_failed: ["ไม่สามารถตรวจสอบรหัสได้", 500],
      not_found: ["รหัสผู้แนะนำไม่ถูกต้อง", 404],
      self: ["ไม่สามารถใช้รหัสของตัวเองได้", 400],
      update_failed: ["บันทึกรหัสผู้แนะนำไม่สำเร็จ", 500],
      insert_failed: ["สร้างรายการแนะนำไม่สำเร็จ", 500],
    };
    const [message, status] = errors[result.error];
    return NextResponse.json({ error: message }, { status });
  }

  return NextResponse.json({ success: true });
}

// GET /api/referral/apply — ดึงจำนวน referrals ของ user ที่ login อยู่
export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const admin = createAdminClient();
  const { count } = await admin
    .from("referrals")
    .select("id", { count: "exact", head: true })
    .eq("referrer_id", user.id);

  const { data: rewardedRows } = await admin
    .from("referrals")
    .select("reward_days")
    .eq("referrer_id", user.id)
    .eq("status", "rewarded");

  const rewarded = rewardedRows?.length ?? 0;
  const rewardedDays = (rewardedRows ?? []).reduce(
    (sum, r) => sum + (r.reward_days ?? REFERRAL_REWARD_DAYS),
    0
  );

  return NextResponse.json({ total: count ?? 0, rewarded, rewardedDays });
}
