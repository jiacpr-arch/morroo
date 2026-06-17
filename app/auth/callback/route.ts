import { NextRequest, NextResponse, after } from "next/server";
import { createClient } from "@/lib/supabase/server";
import {
  BETA_DURATION_DAYS,
  BETA_QUESTION_LIMIT,
  isPromoActive,
} from "@/lib/beta";
import { sendTikTokEvent } from "@/lib/tiktok/events-api";
import { sendMetaEvent } from "@/lib/meta/events-api";
import { sendWelcomeEmail } from "@/lib/email/send";

export async function GET(request: NextRequest) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/profile";

  if (code) {
    const supabase = await createClient();
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);

    if (!error && data.user) {
      const userCreatedAt = data.user.created_at
        ? new Date(data.user.created_at).getTime()
        : 0;
      const isNewSignup = Date.now() - userCreatedAt < 60_000;

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

      if (isNewSignup) {
        const userAgent = request.headers.get("user-agent");
        const forwardedFor = request.headers.get("x-forwarded-for");
        const ip = forwardedFor?.split(",")[0]?.trim() ?? null;
        // Pass the Meta click/browser IDs (set by the pixel in layout.tsx) and
        // the TikTok equivalents so the CAPI CompleteRegistration can be
        // attributed back to the ad that drove the signup. Without fbc/fbp,
        // Meta receives the event but can't tie it to the campaign, so Ads
        // Manager under-reports registrations to ~0.
        const fbc = request.cookies.get("_fbc")?.value ?? null;
        const fbp = request.cookies.get("_fbp")?.value ?? null;
        const ttclid = request.cookies.get("ttclid")?.value ?? null;
        const ttp = request.cookies.get("_ttp")?.value ?? null;
        const eventUrl = `${origin}${destination}`;
        const signupEventId = `signup:${data.user!.id}`;
        after(() =>
          sendTikTokEvent({
            event: "CompleteRegistration",
            eventId: signupEventId,
            email: data.user!.email ?? null,
            externalId: data.user!.id,
            ip,
            userAgent,
            ttclid,
            ttp,
            url: eventUrl,
            contentName: "signup",
          })
        );
        after(() =>
          sendMetaEvent({
            event: "CompleteRegistration",
            eventId: signupEventId,
            email: data.user!.email ?? null,
            externalId: data.user!.id,
            ip,
            userAgent,
            fbc,
            fbp,
            url: eventUrl,
            contentName: "signup",
          })
        );

        const welcomeEmail = data.user!.email;
        const welcomeName =
          data.user!.user_metadata?.full_name ||
          data.user!.user_metadata?.name ||
          welcomeEmail ||
          "คุณหมอ";
        if (welcomeEmail) {
          after(() =>
            sendWelcomeEmail({
              email: welcomeEmail,
              name: typeof welcomeName === "string" ? welcomeName : "คุณหมอ",
            }).catch((err) => {
              console.error("[auth] welcome email failed:", err);
            })
          );
        }
      }

      const dest = isNewSignup
        ? `${destination}${destination.includes("?") ? "&" : "?"}signup=1`
        : destination;
      return NextResponse.redirect(`${origin}${dest}`);
    }
  }

  // Auth error - redirect to login
  return NextResponse.redirect(`${origin}/login?error=auth`);
}
