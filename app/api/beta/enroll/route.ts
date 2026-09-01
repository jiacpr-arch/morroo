import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { BETA_DURATION_DAYS, BETA_QUESTION_LIMIT, isPromoActive } from "@/lib/beta";
import type { Profile } from "@/lib/types";

/**
 * Enroll the current user as a Beta tester IF
 *   - promo window is still open (app_settings.beta_promo_ends_at),
 *   - they are on the free tier, AND
 *   - they are not already enrolled.
 *
 * Called right after signup / first OAuth login. Safe to re-call — no-op
 * when the user is already enrolled or paid.
 */
export async function POST() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ error: "unauthenticated" }, { status: 401 });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("membership_type, beta_enrolled_via, beta_expires_at")
    .eq("id", user.id)
    .single();

  const p = profile as Pick<
    Profile,
    "membership_type" | "beta_enrolled_via" | "beta_expires_at"
  > | null;

  if (!p) {
    return NextResponse.json({ error: "no_profile" }, { status: 404 });
  }

  if (p.membership_type !== "free" || p.beta_enrolled_via) {
    return NextResponse.json({ ok: true, enrolled: false, reason: "already_set" });
  }

  const { data: promoRow } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "beta_promo_ends_at")
    .single();

  const promoEndsAt = (promoRow as { value: string } | null)?.value ?? null;
  if (!isPromoActive(promoEndsAt)) {
    return NextResponse.json({ ok: true, enrolled: false, reason: "promo_closed" });
  }

  const now = new Date();
  const expires = new Date(now.getTime() + BETA_DURATION_DAYS * 86_400_000);

  const { error } = await supabase
    .from("profiles")
    .update({
      beta_enrolled_via: "new_signup",
      beta_started_at: now.toISOString(),
      beta_expires_at: expires.toISOString(),
      beta_questions_used: 0,
      beta_questions_limit: BETA_QUESTION_LIMIT,
      has_seen_beta_welcome: false,
    })
    .eq("id", user.id);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ ok: true, enrolled: true });
}
