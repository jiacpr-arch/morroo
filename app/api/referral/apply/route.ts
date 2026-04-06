import { NextRequest, NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";

// POST /api/referral/apply
// Body: { code: string, userId: string }
// ใช้ตอน register เพื่อบันทึก referred_by และสร้าง referral record
export async function POST(request: NextRequest) {
  const { code, userId } = await request.json();

  if (!code || !userId) {
    return NextResponse.json({ error: "Missing code or userId" }, { status: 400 });
  }

  const admin = createAdminClient();

  // หา referrer จาก referral_code
  const { data: referrer } = await admin
    .from("profiles")
    .select("id")
    .eq("referral_code", code.toUpperCase())
    .single();

  if (!referrer) {
    return NextResponse.json({ error: "รหัสผู้แนะนำไม่ถูกต้อง" }, { status: 404 });
  }

  // ไม่ให้ใช้ code ของตัวเอง
  if (referrer.id === userId) {
    return NextResponse.json({ error: "ไม่สามารถใช้รหัสของตัวเองได้" }, { status: 400 });
  }

  // บันทึก referred_by ใน profiles
  await admin
    .from("profiles")
    .update({ referred_by: code.toUpperCase() })
    .eq("id", userId);

  // สร้าง referral record (pending จนกว่าจะมีการซื้อ)
  await admin.from("referrals").insert({
    referrer_id: referrer.id,
    referred_id: userId,
    code: code.toUpperCase(),
    status: "pending",
    reward_days: 30,
  });

  return NextResponse.json({ success: true });
}

// GET /api/referral/apply?userId=xxx — ดึงจำนวน referrals ของ user
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const userId = searchParams.get("userId");

  if (!userId) {
    return NextResponse.json({ error: "Missing userId" }, { status: 400 });
  }

  const admin = createAdminClient();
  const { count } = await admin
    .from("referrals")
    .select("id", { count: "exact", head: true })
    .eq("referrer_id", userId);

  const { count: rewardedCount } = await admin
    .from("referrals")
    .select("id", { count: "exact", head: true })
    .eq("referrer_id", userId)
    .eq("status", "rewarded");

  return NextResponse.json({ total: count ?? 0, rewarded: rewardedCount ?? 0 });
}
