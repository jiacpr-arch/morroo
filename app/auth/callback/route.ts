import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { sendWelcomeEmail } from "@/lib/email/send";
import { isValidReferralCode } from "@/lib/referral";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/profile";
  const refCode = searchParams.get("ref") ?? "";

  if (code) {
    const supabase = await createClient();
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.user) {
      // Upsert profile on OAuth login
      const name =
        data.user.user_metadata?.full_name ||
        data.user.user_metadata?.name ||
        data.user.email;

      const { data: upsertResult } = await supabase
        .from("profiles")
        .upsert(
          {
            id: data.user.id,
            email: data.user.email,
            name,
            role: "user",
            membership_type: "free",
          },
          { onConflict: "id", ignoreDuplicates: true }
        )
        .select("created_at")
        .single();

      // Send welcome email only for new signups (ignoreDuplicates returns null for existing rows)
      if (upsertResult && data.user.email) {
        sendWelcomeEmail({ name: name ?? "คุณ", email: data.user.email }).catch(
          (err) => console.error("Failed to send welcome email:", err)
        );

        // Track referral for new Google signups
        if (refCode && isValidReferralCode(refCode)) {
          fetch(`${origin}/api/referral/use`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ referredUserId: data.user.id, referralCode: refCode }),
          }).catch(() => {});
        }
      }

      return NextResponse.redirect(`${origin}${next}`);
    }
  }

  // Auth error - redirect to login
  return NextResponse.redirect(`${origin}/login?error=auth`);
}
