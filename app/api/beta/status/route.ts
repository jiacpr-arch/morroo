import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { computeBetaStatus } from "@/lib/beta";
import type { Profile } from "@/lib/types";

export const dynamic = "force-dynamic";

export async function GET() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return NextResponse.json({ authenticated: false, status: null });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select(
      "membership_type, membership_expires_at, beta_enrolled_via, beta_started_at, beta_expires_at, beta_questions_used, beta_questions_limit, has_seen_beta_welcome, beta_coupon_code, beta_coupon_issued_at"
    )
    .eq("id", user.id)
    .single();

  const status = computeBetaStatus(profile as Partial<Profile> as Profile | null);
  return NextResponse.json({ authenticated: true, status });
}
