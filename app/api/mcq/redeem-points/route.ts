import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  checkRateLimit,
  rateLimitResponse,
  RATE_LIMITS,
} from "@/lib/rate-limit";
import { REWARD_TIERS, type RewardTierId } from "@/lib/bug-hunter";

// POST /api/mcq/redeem-points
// Body: { tier: "days30" | "days90" }
// Spends the signed-in user's Bug Hunter points on free membership days.
export async function POST(request: NextRequest) {
  let body: { tier?: string };
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const tier = REWARD_TIERS[body.tier as RewardTierId];
  if (!tier) {
    return NextResponse.json(
      { error: `tier must be one of: ${Object.keys(REWARD_TIERS).join(", ")}` },
      { status: 400 }
    );
  }

  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json(
      { error: "ต้องเข้าสู่ระบบก่อนจึงจะแลกแต้มได้" },
      { status: 401 }
    );
  }

  const rl = await checkRateLimit(
    supabase,
    user.id,
    "mcq:redeem-points",
    RATE_LIMITS.redeemPoints
  );
  const rlResp = rateLimitResponse(rl, RATE_LIMITS.redeemPoints);
  if (rlResp) return rlResp;

  // The redeem RPC is SECURITY DEFINER and restricted to the service role.
  const admin = createAdminClient();
  const { data, error } = await admin.rpc("redeem_reporter_points", {
    p_user_id: user.id,
    p_cost: tier.cost,
    p_days: tier.days,
  });

  if (error) {
    console.error("[mcq/redeem-points] rpc error:", error);
    return NextResponse.json({ error: "แลกแต้มไม่สำเร็จ" }, { status: 500 });
  }

  const result = data as {
    ok: boolean;
    error?: string;
    new_balance?: number;
    membership_expires_at?: string;
  };

  if (!result.ok) {
    const messages: Record<string, string> = {
      insufficient_points: "แต้มไม่พอสำหรับรางวัลนี้",
      invalid_tier: "ตัวเลือกรางวัลไม่ถูกต้อง",
      profile_not_found: "ไม่พบโปรไฟล์ผู้ใช้",
    };
    return NextResponse.json(
      {
        error: messages[result.error ?? ""] ?? "แลกแต้มไม่สำเร็จ",
        new_balance: result.new_balance ?? null,
      },
      { status: 400 }
    );
  }

  return NextResponse.json({
    success: true,
    reward_days: tier.days,
    new_balance: result.new_balance ?? null,
    membership_expires_at: result.membership_expires_at ?? null,
  });
}
