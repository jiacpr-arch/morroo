import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";

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

  const upperCode = code.toUpperCase();
  const admin = createAdminClient();

  const { data: referrer, error: referrerErr } = await admin
    .from("profiles")
    .select("id")
    .eq("referral_code", upperCode)
    .maybeSingle();

  if (referrerErr) {
    return NextResponse.json({ error: "ไม่สามารถตรวจสอบรหัสได้" }, { status: 500 });
  }
  if (!referrer) {
    return NextResponse.json({ error: "รหัสผู้แนะนำไม่ถูกต้อง" }, { status: 404 });
  }

  if (referrer.id === user.id) {
    return NextResponse.json({ error: "ไม่สามารถใช้รหัสของตัวเองได้" }, { status: 400 });
  }

  const { error: updateErr } = await admin
    .from("profiles")
    .update({ referred_by: upperCode })
    .eq("id", user.id);

  if (updateErr) {
    return NextResponse.json({ error: "บันทึกรหัสผู้แนะนำไม่สำเร็จ" }, { status: 500 });
  }

  const { error: insertErr } = await admin.from("referrals").insert({
    referrer_id: referrer.id,
    referred_id: user.id,
    code: upperCode,
    status: "pending",
    reward_days: 30,
  });

  if (insertErr) {
    return NextResponse.json({ error: "สร้างรายการแนะนำไม่สำเร็จ" }, { status: 500 });
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

  const { count: rewardedCount } = await admin
    .from("referrals")
    .select("id", { count: "exact", head: true })
    .eq("referrer_id", user.id)
    .eq("status", "rewarded");

  return NextResponse.json({ total: count ?? 0, rewarded: rewardedCount ?? 0 });
}
