import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import { createAdminClient } from "@/lib/supabase/admin";

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

  // Clear the cookie
  cookieStore.delete("line_oauth_state");

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
    console.error("LINE token exchange failed:", await tokenRes.text());
    return NextResponse.redirect(`${origin}/login?error=line_token_failed`);
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
  const supabase = createAdminClient();

  // Check if a profile already has this LINE user ID linked.
  // `maybeSingle()` returns null when no rows match but still surfaces an
  // error if the query is ambiguous (e.g. duplicate line_user_id rows).
  const { data: existingByLine, error: lookupError } = await supabase
    .from("profiles")
    .select("id, email")
    .eq("line_user_id", lineProfile.userId)
    .maybeSingle();

  if (lookupError) {
    console.error("LINE profile lookup failed:", lookupError);
    return NextResponse.redirect(`${origin}/login?error=line_lookup_failed`);
  }

  // Placeholder email for LINE accounts that didn't grant email scope.
  const targetEmail =
    lineEmail ?? `line_${lineProfile.userId}@line.morroo.com`;

  let userId: string;

  if (existingByLine) {
    // Already linked — just sign them in
    userId = existingByLine.id;
  } else {
    // Look up any existing profile with the target email. Querying `profiles`
    // directly avoids pulling the entire auth.users table via listUsers()
    // (which is paginated and would miss users past the first page).
    const { data: profileByEmail, error: emailLookupError } = await supabase
      .from("profiles")
      .select("id")
      .eq("email", targetEmail)
      .maybeSingle();

    if (emailLookupError) {
      console.error("LINE email lookup failed:", emailLookupError);
      return NextResponse.redirect(`${origin}/login?error=line_lookup_failed`);
    }

    if (profileByEmail) {
      // Link LINE to existing account
      userId = profileByEmail.id;
      const { error: updateError } = await supabase
        .from("profiles")
        .update({
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", userId);

      if (updateError) {
        console.error("Failed to link LINE to profile:", updateError);
        return NextResponse.redirect(
          `${origin}/login?error=line_link_failed`
        );
      }
    } else {
      // Create a new Supabase user. Use a deterministic ID-less flow and
      // rely on the unique email constraint at the DB to prevent duplicates
      // from concurrent requests (createUser will surface a conflict error).
      const tempPassword = `line_${crypto.randomUUID()}`;
      const { data: newUser, error: createError } =
        await supabase.auth.admin.createUser({
          email: targetEmail,
          password: tempPassword,
          email_confirm: true,
          user_metadata: {
            name: lineProfile.displayName,
            avatar_url: lineProfile.pictureUrl,
            provider: "line",
          },
        });

      if (createError || !newUser.user) {
        console.error("Failed to create user for LINE login:", createError);
        return NextResponse.redirect(
          `${origin}/login?error=line_create_failed`
        );
      }

      userId = newUser.user.id;

      const { error: upsertError } = await supabase.from("profiles").upsert(
        {
          id: userId,
          email: targetEmail,
          name: lineProfile.displayName,
          role: "user",
          membership_type: "free",
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        },
        { onConflict: "id", ignoreDuplicates: true }
      );

      if (upsertError) {
        console.error("Failed to upsert profile for LINE user:", upsertError);
        return NextResponse.redirect(
          `${origin}/login?error=line_create_failed`
        );
      }
    }
  }

  // ── Step 5: Generate a Supabase magic link to sign them in ────
  // We use admin.generateLink to create a magic link, then redirect
  // through the auth callback with the token
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || origin;

  const { data: existingProfile, error: profileError } = await supabase
    .from("profiles")
    .select("email")
    .eq("id", userId)
    .maybeSingle();

  if (profileError) {
    console.error("Failed to load profile after LINE login:", profileError);
    return NextResponse.redirect(`${origin}/login?error=line_session_failed`);
  }

  const userEmail = existingProfile?.email;
  if (!userEmail) {
    return NextResponse.redirect(`${origin}/login?error=line_no_email`);
  }

  const { data: linkData, error: linkError } =
    await supabase.auth.admin.generateLink({
      type: "magiclink",
      email: userEmail,
      options: { redirectTo: `${siteUrl}/auth/callback` },
    });

  if (linkError || !linkData?.properties?.hashed_token) {
    console.error("Failed to generate magic link:", linkError);
    return NextResponse.redirect(`${origin}/login?error=line_session_failed`);
  }

  // Build the Supabase auth verification URL
  // The hashed_token is used with the /auth/v1/verify endpoint
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  if (!supabaseUrl) {
    console.error("NEXT_PUBLIC_SUPABASE_URL is not configured");
    return NextResponse.redirect(`${origin}/login?error=line_session_failed`);
  }
  const verifyUrl = new URL(`${supabaseUrl}/auth/v1/verify`);
  verifyUrl.searchParams.set("token", linkData.properties.hashed_token);
  verifyUrl.searchParams.set("type", "magiclink");
  verifyUrl.searchParams.set(
    "redirect_to",
    `${siteUrl}/auth/callback${mode === "register" ? "?next=/onboarding" : ""}`
  );

  return NextResponse.redirect(verifyUrl.toString());
}
