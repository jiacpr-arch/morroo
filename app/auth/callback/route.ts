import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  BETA_DURATION_DAYS,
  BETA_QUESTION_LIMIT,
  isPromoActive,
} from "@/lib/beta";
import { sendCapiEvent, getClientIp, getClientUserAgent } from "@/lib/facebook-capi";
import { sha256Norm, newEventId } from "@/lib/facebook-pixel";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/profile";

  if (code) {
    const supabase = await createClient();
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.user) {
      // Distinguish new signup vs returning user so we can fire a Google
      // Ads "sign_up" conversion on the next page only on the first login.
      const { data: existingProfile } = await supabase
        .from("profiles")
        .select("id")
        .eq("id", data.user.id)
        .maybeSingle();
      const isNewSignup = !existingProfile;

      // Upsert profile on OAuth login
      await supabase.from("profiles").upsert(
        {
          id: data.user.id,
          email: data.user.email,
          name:
            data.user.user_metadata?.full_name ||
            data.user.user_metadata?.name ||
            data.user.email,
          role: "user",
          membership_type: "free",
        },
        { onConflict: "id", ignoreDuplicates: true }
      );

      // Beta auto-enroll for brand-new OAuth signups during the promo window.
      const { data: profile } = await supabase
        .from("profiles")
        .select("onboarding_done, membership_type, beta_enrolled_via")
        .eq("id", data.user.id)
        .single();

      if (
        profile &&
        profile.membership_type === "free" &&
        !profile.beta_enrolled_via
      ) {
        const { data: promoRow } = await supabase
          .from("app_settings")
          .select("value")
          .eq("key", "beta_promo_ends_at")
          .single();
        const promoEndsAt = (promoRow as { value: string } | null)?.value ?? null;
        if (isPromoActive(promoEndsAt)) {
          const now = new Date();
          const expires = new Date(
            now.getTime() + BETA_DURATION_DAYS * 86_400_000
          );
          await supabase
            .from("profiles")
            .update({
              beta_enrolled_via: "new_signup",
              beta_started_at: now.toISOString(),
              beta_expires_at: expires.toISOString(),
              beta_questions_used: 0,
              beta_questions_limit: BETA_QUESTION_LIMIT,
              has_seen_beta_welcome: false,
            })
            .eq("id", data.user.id);
        }
      }

      const destination =
        profile && profile.onboarding_done === false
          ? "/onboarding"
          : next;

      const url = new URL(`${origin}${destination}`);
      if (isNewSignup) {
        // Mint a UUID the success page tracker reuses as the Pixel eventID,
        // so this server-side CAPI fire and the browser-side Pixel fire are
        // deduped by Meta within the 48h window.
        const fbe = newEventId();
        url.searchParams.set("signup", "1");
        url.searchParams.set("fbe", fbe);

        sendCapiEvent({
          eventName: "CompleteRegistration",
          eventId: fbe,
          actionSource: "website",
          eventSourceUrl: url.toString(),
          userData: {
            em: data.user.email ? sha256Norm(data.user.email) : undefined,
            client_ip_address: getClientIp(request.headers),
            client_user_agent: getClientUserAgent(request.headers),
            external_id: data.user.id,
          },
          customData: { content_name: "oauth_signup" },
        }).catch((e) =>
          console.error("[auth/callback] CAPI CompleteRegistration failed:", e)
        );
      }
      return NextResponse.redirect(url.toString());
    }
  }

  // Auth error - redirect to login
  return NextResponse.redirect(`${origin}/login?error=auth`);
}
