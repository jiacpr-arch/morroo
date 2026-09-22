import { NextResponse, after } from "next/server";
import { cookies } from "next/headers";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { sendTikTokEvent } from "@/lib/tiktok/events-api";
import { sendMetaEvent, sourceUrl } from "@/lib/meta/events-api";
import { sendWelcomeEmail } from "@/lib/email/send";
import { safeInternalPath } from "@/lib/safe-redirect";
import { resolveOrCreateLineUser, establishSessionFor } from "@/lib/line-auth";

/**
 * GET /api/auth/line/callback
 *
 * Handles the LINE Login OAuth callback:
 * 1. Validates CSRF state
 * 2. Exchanges authorization code for access token
 * 3. Fetches LINE user profile (userId, displayName, email)
 * 4. Finds existing Supabase user by LINE userId or email, OR creates a new one
 * 5. Stores line_user_id in profiles table
 * 6. Signs the user into Supabase and redirects
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const state = searchParams.get("state");
  const error = searchParams.get("error");

  // LINE returned an error (user denied, etc.)
  if (error) {
    return NextResponse.redirect(`${origin}/login?error=line_denied`);
  }

  if (!code || !state) {
    return NextResponse.redirect(`${origin}/login?error=line_missing_params`);
  }

  // Verify CSRF state
  const cookieStore = await cookies();
  const storedValue = cookieStore.get("line_oauth_state")?.value ?? "";
  const [storedState, rawMode] = storedValue.split(":");
  const mode: "login" | "register" = rawMode === "register" ? "register" : "login";

  // Post-login destination stashed by /api/auth/line (e.g. back to checkout).
  // Re-sanitised here as defence in depth before it's used in a redirect.
  const nextPath = safeInternalPath(
    cookieStore.get("line_oauth_next")?.value,
    "",
  );

  // Clear the cookies
  cookieStore.delete("line_oauth_state");
  cookieStore.delete("line_oauth_next");

  if (!storedState || storedState !== state) {
    return NextResponse.redirect(`${origin}/login?error=line_invalid_state`);
  }

  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  const channelSecret = process.env.LINE_LOGIN_CHANNEL_SECRET;
  if (!channelId || !channelSecret) {
    console.error("LINE login env vars missing");
    return NextResponse.redirect(`${origin}/login?error=line_not_configured`);
  }
  const redirectUri = `${origin}/api/auth/line/callback`;

  // ── Step 1: Exchange code for tokens ──────────────────────────
  const tokenRes = await fetch("https://api.line.me/oauth2/v2.1/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "authorization_code",
      code,
      redirect_uri: redirectUri,
      client_id: channelId,
      client_secret: channelSecret,
    }),
  });

  if (!tokenRes.ok) {
    const rawBody = await tokenRes.text();
    console.error("LINE token exchange failed:", rawBody);

    // Surface LINE's actual error code/description in the redirect URL so the
    // login page can show it. LINE returns JSON like
    // {"error":"invalid_grant","error_description":"..."} on 4xx.
    let reason = "";
    let detail = "";
    try {
      const parsed = JSON.parse(rawBody) as {
        error?: string;
        error_description?: string;
      };
      reason = parsed.error ?? "";
      detail = parsed.error_description ?? "";
    } catch {
      detail = rawBody;
    }

    const params = new URLSearchParams({ error: "line_token_failed" });
    if (reason) params.set("reason", reason);
    if (detail) params.set("detail", detail.slice(0, 200));
    params.set("redirect_uri", redirectUri);
    return NextResponse.redirect(`${origin}/login?${params.toString()}`);
  }

  const tokenData = (await tokenRes.json()) as {
    access_token: string;
    id_token?: string;
  };

  // ── Step 2: Get LINE user profile ─────────────────────────────
  const profileRes = await fetch("https://api.line.me/v2/profile", {
    headers: { Authorization: `Bearer ${tokenData.access_token}` },
  });

  if (!profileRes.ok) {
    console.error("LINE profile fetch failed:", await profileRes.text());
    return NextResponse.redirect(`${origin}/login?error=line_profile_failed`);
  }

  const lineProfile = (await profileRes.json()) as {
    userId: string;
    displayName: string;
    pictureUrl?: string;
  };

  // ── Step 3: Get email from ID token (if available) ────────────
  let lineEmail: string | null = null;
  if (tokenData.id_token) {
    try {
      const verifyRes = await fetch("https://api.line.me/oauth2/v2.1/verify", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          id_token: tokenData.id_token,
          client_id: channelId,
        }),
      });
      if (verifyRes.ok) {
        const idTokenPayload = (await verifyRes.json()) as { email?: string };
        lineEmail = idTokenPayload.email ?? null;
      }
    } catch {
      // Email is optional — continue without it
    }
  }

  // ── Step 4: Find or create Supabase user ──────────────────────
  // (logic shared with the LIFF auth bridge — see lib/line-auth.ts)
  const supabase = createAdminClient();

  const resolved = await resolveOrCreateLineUser(supabase, {
    lineUserId: lineProfile.userId,
    displayName: lineProfile.displayName,
    pictureUrl: lineProfile.pictureUrl,
    email: lineEmail,
  });

  if ("error" in resolved) {
    return NextResponse.redirect(`${origin}/login?error=${resolved.error}`);
  }

  const { userId, isNewSignup } = resolved;

  // ── Step 5: Sign the user in by verifying the OTP server-side ─
  // The previous flow redirected to Supabase's /auth/v1/verify endpoint,
  // which (for admin-generated magic links) returns session tokens in the URL
  // fragment. Server routes can't read the fragment, so the session was lost
  // and the user landed back on the home page unauthenticated. Calling
  // verifyOtp through the SSR server client sets the auth cookies on the app
  // domain directly.
  const { data: profileForSignIn, error: profileForSignInError } =
    await supabase
      .from("profiles")
      .select("email")
      .eq("id", userId)
      .maybeSingle();

  if (profileForSignInError) {
    console.error("Failed to load profile for sign-in:", profileForSignInError);
    return NextResponse.redirect(`${origin}/login?error=line_session_failed`);
  }

  const userEmail = profileForSignIn?.email;
  if (!userEmail) {
    return NextResponse.redirect(`${origin}/login?error=line_no_email`);
  }

  const supabaseServer = await createServerSupabaseClient();
  const sessionResult = await establishSessionFor(
    supabase,
    supabaseServer,
    userEmail,
    `${origin}/auth/callback`
  );

  if (!sessionResult.ok) {
    return NextResponse.redirect(`${origin}/login?error=${sessionResult.error}`);
  }

  if (isNewSignup) {
    const userAgent = request.headers.get("user-agent");
    const forwardedFor = request.headers.get("x-forwarded-for");
    const ip = forwardedFor?.split(",")[0]?.trim() ?? null;
    const signupEventId = `signup:${userId}`;
    // เดิมใช้ after() แต่พบว่าหายเงียบเกือบหมดบน production (ดู
    // app/api/track/casegame/route.ts) — ยิงครั้งต่อการสมัครสมาชิกใหม่หนึ่งครั้ง
    // เท่านั้น แลก latency เพื่อความชัวร์ได้ (ต่างจาก welcome email ด้านล่างที่
    // ยังปล่อยเป็น after() ไว้ ไม่ใช่ตัวชี้วัดที่แคมเปญโฆษณาต้องพึ่ง)
    await Promise.all([
      sendTikTokEvent({
        event: "CompleteRegistration",
        eventId: signupEventId,
        email: lineEmail,
        externalId: userId,
        ip,
        userAgent,
        contentName: "signup",
      }),
      sendMetaEvent({
        event: "CompleteRegistration",
        eventId: signupEventId,
        // LINE sends the user straight back to the callback; /register is the
        // page that started the flow.
        url: sourceUrl("/register"),
        email: lineEmail,
        externalId: userId,
        ip,
        userAgent,
        contentName: "signup",
      }),
    ]);

    // Welcome email — only when LINE returned a real email (the placeholder
    // line_<uid>@line.morroo.com would bounce at Resend).
    if (lineEmail) {
      const welcomeName = lineProfile.displayName || "คุณหมอ";
      after(() =>
        sendWelcomeEmail({ email: lineEmail, name: welcomeName }).catch(
          (err) => {
            console.error("[line] welcome email failed:", err);
          }
        )
      );
    }
  }

  // A `next` path (e.g. a buyer bounced from checkout) wins over the default
  // landing — and over onboarding — so we don't strand them away from the sale.
  const destination =
    nextPath || (mode === "register" ? "/onboarding" : "/profile");
  // ?signup=1 makes the browser fire the GA4 sign_up event (see
  // components/analytics/SignupConversion); the CAPI events above cover
  // Meta/TikTok, matching the Google OAuth path in app/auth/callback.
  const dest = isNewSignup
    ? `${destination}${destination.includes("?") ? "&" : "?"}signup=1`
    : destination;
  return NextResponse.redirect(`${origin}${dest}`);
}
