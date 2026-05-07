import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { redeemCode } from "@/lib/redeem";

export const runtime = "nodejs";

export async function POST(request: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json(
      { ok: false, error: "กรุณาเข้าสู่ระบบก่อนใช้โค้ด" },
      { status: 401 }
    );
  }

  let code: string;
  try {
    const body = await request.json();
    code = String(body.code ?? "").trim();
  } catch {
    return NextResponse.json(
      { ok: false, error: "ข้อมูลคำขอไม่ถูกต้อง" },
      { status: 400 }
    );
  }

  if (!code) {
    return NextResponse.json(
      { ok: false, error: "กรุณาระบุโค้ด" },
      { status: 400 }
    );
  }

  const admin = createAdminClient();
  const result = await redeemCode(admin, code, user.id);

  if (!result.ok) {
    const status =
      result.reason === "invalid" || result.reason === "expired"
        ? 400
        : result.reason === "already_redeemed" || result.reason === "user_already_redeemed"
        ? 409
        : 500;
    return NextResponse.json(
      { ok: false, reason: result.reason, error: result.message },
      { status }
    );
  }

  return NextResponse.json({
    ok: true,
    rewardType: result.rewardType,
    expiresAt: result.expiresAt,
  });
}
