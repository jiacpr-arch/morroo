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
  const [storedState, mode] = storedValue.split(":");

  // Clear the cookie
  cookieStore.delete("line_oauth_state");

  if (!storedState || storedState !== state) {
    return NextResponse.redirect(`${origin}/login?error=line_invalid_state`);
  }

  const channelId = process.env.LINE_LOGIN_CHANNEL_ID!;
  const channelSecret = process.env.LINE_LOGIN_CHANNEL_SECRET!;
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

  // Check if a profile already has this LINE user ID linked
  const { data: existingByLine } = await supabase
    .from("profiles")
    .select("id, email")
    .eq("line_user_id", lineProfile.userId)
    .single();

  let userId: string;

  if (existingByLine) {
    // Already linked — just sign them in
    userId = existingByLine.id;
  } else if (lineEmail) {
    // Check if there's a Supabase user with this email
    const { data: existingUsers } = await supabase.auth.admin.listUsers();
    const matchingUser = existingUsers?.users?.find(
      (u) => u.email === lineEmail
    );

    if (matchingUser) {
      // Link LINE to existing account
      userId = matchingUser.id;
      await supabase
        .from("profiles")
        .update({
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", userId);
    } else {
      // Create new user
      const tempPassword = `line_${crypto.randomUUID()}`;
      const { data: newUser, error: createError } =
        await supabase.auth.admin.createUser({
          email: lineEmail,
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

      // Create profile
      await supabase.from("profiles").upsert(
        {
          id: userId,
          email: lineEmail,
          name: lineProfile.displayName,
          role: "user",
          membership_type: "free",
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        },
        { onConflict: "id", ignoreDuplicates: true }
      );
    }
  } else {
    // No email from LINE — create user with a placeholder email
    // LINE users without email scope get: line_{userId}@line.morroo.com
    const placeholderEmail = `line_${lineProfile.userId}@line.morroo.com`;

    // Check if we already have a user with this placeholder
    const { data: existingUsers } = await supabase.auth.admin.listUsers();
    const matchingUser = existingUsers?.users?.find(
      (u) => u.email === placeholderEmail
    );

    if (matchingUser) {
      userId = matchingUser.id;
      // Ensure LINE is linked
      await supabase
        .from("profiles")
        .update({
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", userId);
    } else {
      const tempPassword = `line_${crypto.randomUUID()}`;
      const { data: newUser, error: createError } =
        await supabase.auth.admin.createUser({
          email: placeholderEmail,
          password: tempPassword,
          email_confirm: true,
          user_metadata: {
            name: lineProfile.displayName,
            avatar_url: lineProfile.pictureUrl,
            provider: "line",
          },
        });

      if (createError || !newUser.user) {
        console.error("Failed to create LINE user:", createError);
        return NextResponse.redirect(
          `${origin}/login?error=line_create_failed`
        );
      }

      userId = newUser.user.id;

      await supabase.from("profiles").upsert(
        {
          id: userId,
          email: placeholderEmail,
          name: lineProfile.displayName,
          role: "user",
          membership_type: "free",
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        },
        { onConflict: "id", ignoreDuplicates: true }
      );
    }
  }

  // ── Step 5: Generate a Supabase magic link to sign them in ────
  // We use admin.generateLink to create a magic link, then redirect
  // through the auth callback with the token
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || origin;

  const { data: existingProfile } = await supabase
    .from("profiles")
    .select("email")
    .eq("id", userId)
    .single();

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
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const verifyUrl = new URL(`${supabaseUrl}/auth/v1/verify`);
  verifyUrl.searchParams.set("token", linkData.properties.hashed_token);
  verifyUrl.searchParams.set("type", "magiclink");
  verifyUrl.searchParams.set(
    "redirect_to",
    `${siteUrl}/auth/callback${mode === "register" ? "?next=/onboarding" : ""}`
  );

  return NextResponse.redirect(verifyUrl.toString());
}
