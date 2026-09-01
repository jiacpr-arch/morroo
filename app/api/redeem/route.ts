import { NextResponse } from "next/server";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { redeemCode } from "@/lib/redeem";

/**
 * POST /api/redeem
 *
 * Body: { code: string }
 *
 * Auth required (Supabase session). Applies the redeem code's entitlement
 * to the signed-in user.
 */
export async function POST(request: Request) {
  let body: { code?: unknown };
  try {
    body = (await request.json()) as { code?: unknown };
  } catch {
    return NextResponse.json({ error: "invalid_body" }, { status: 400 });
  }

  const code = typeof body.code === "string" ? body.code.trim().toUpperCase() : "";
  if (!code) {
    return NextResponse.json({ error: "missing_code" }, { status: 400 });
  }

  const supabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const result = await redeemCode(code, user.id);

  if (!result.ok) {
    const status =
      result.error === "not_found" || result.error === "expired"
        ? 404
        : result.error === "already_redeemed"
          ? 409
          : 500;
    return NextResponse.json({ error: result.error }, { status });
  }

  return NextResponse.json({
    ok: true,
    rewardType: result.rewardType,
  });
}
