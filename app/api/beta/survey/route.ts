import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { generateCouponCode } from "@/lib/beta";
import type { Profile } from "@/lib/types";

type SurveyType = "checkpoint_10" | "checkpoint_25" | "exit";

interface Body {
  type: SurveyType;
  responses: Record<string, unknown>;
}

const COUPON_GRACE_DAYS = 14;

export async function POST(request: Request) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "unauthenticated" }, { status: 401 });
  }

  let body: Body;
  try {
    body = (await request.json()) as Body;
  } catch {
    return NextResponse.json({ error: "invalid_json" }, { status: 400 });
  }

  if (!body?.type || !["checkpoint_10", "checkpoint_25", "exit"].includes(body.type)) {
    return NextResponse.json({ error: "invalid_type" }, { status: 400 });
  }
  if (!body.responses || typeof body.responses !== "object") {
    return NextResponse.json({ error: "missing_responses" }, { status: 400 });
  }

  const { error: insertError } = await supabase
    .from("beta_survey_responses")
    .insert({
      user_id: user.id,
      survey_type: body.type,
      responses: body.responses,
    });

  if (insertError) {
    return NextResponse.json({ error: insertError.message }, { status: 500 });
  }

  if (body.type !== "checkpoint_25") {
    return NextResponse.json({ ok: true });
  }

  // Checkpoint-25: issue coupon (idempotent — reuse if one already exists)
  const { data: existingProfile } = await supabase
    .from("profiles")
    .select("beta_expires_at, beta_coupon_code")
    .eq("id", user.id)
    .single();

  const profile = existingProfile as Pick<
    Profile,
    "beta_expires_at" | "beta_coupon_code"
  > | null;

  if (profile?.beta_coupon_code) {
    const { data: existing } = await supabase
      .from("beta_coupons")
      .select("code, discount_percent, expires_at")
      .eq("code", profile.beta_coupon_code)
      .single();
    return NextResponse.json({ ok: true, coupon: existing ?? null });
  }

  const betaExpiry = profile?.beta_expires_at
    ? new Date(profile.beta_expires_at)
    : new Date();
  const couponExpiry = new Date(
    betaExpiry.getTime() + COUPON_GRACE_DAYS * 86_400_000
  );

  // Tiny retry loop for code-collision (5 random chars = 60M combos, but be safe)
  let code = "";
  for (let attempt = 0; attempt < 5; attempt++) {
    code = generateCouponCode();
    const { error: couponErr } = await supabase.from("beta_coupons").insert({
      code,
      user_id: user.id,
      discount_percent: 50,
      expires_at: couponExpiry.toISOString(),
    });
    if (!couponErr) break;
    if (attempt === 4) {
      return NextResponse.json({ error: couponErr.message }, { status: 500 });
    }
    code = "";
  }

  if (!code) {
    return NextResponse.json({ error: "coupon_failed" }, { status: 500 });
  }

  const { error: updErr } = await supabase
    .from("profiles")
    .update({
      beta_coupon_code: code,
      beta_coupon_issued_at: new Date().toISOString(),
    })
    .eq("id", user.id);

  if (updErr) {
    return NextResponse.json({ error: updErr.message }, { status: 500 });
  }

  return NextResponse.json({
    ok: true,
    coupon: {
      code,
      discount_percent: 50,
      expires_at: couponExpiry.toISOString(),
    },
  });
}
