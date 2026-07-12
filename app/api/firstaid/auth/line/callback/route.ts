import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import crypto from "crypto";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { safeInternalPath } from "@/lib/safe-redirect";
import { adoptDeviceProgress, isUuid } from "@/lib/firstaid/server/learner";

/**
 * GET /api/firstaid/auth/line/callback
 *
 * Handles the LINE Login OAuth callback for the firstaid subdomain. Cloned
 * from /api/auth/line/callback (token exchange → profile → email → find-or-
 * create Supabase user → server-side verifyOtp = SSR session cookies) with the
 * firstaid identity model on top:
 *
 * 1. `fa_learner_links` (line_user_id → auth_user_id + learner_id) is the
 *    source of truth, replacing the old app's `line_identities` table.
 * 2. On first login the anonymous learner id from the `fa_learner_id` cookie
 *    (set client-side before the redirect) is adopted as the canonical
 *    learner_id, so pre-login progress survives — same semantics as the old
 *    api/auth/line.js bridge.
 * 3. On repeat logins from a device that accumulated progress under a
 *    different anonymous id, the progress rows are re-pointed to the canonical
 *    learner_id (adoptDeviceProgress).
 * 4. New users get profiles.onboarding_done = true so they never hit morroo's
 *    onboarding flow, and no morroo CAPI/welcome-email side effects fire —
 *    firstaid tracks with its own pixel client-side.
 *
 * Errors redirect to `/?error=...` (firstaid has no /login page — the
 * subdomain root is the landing page).
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const state = searchParams.get("state");
  const lineError = searchParams.get("error");

  const failRedirect = (params: URLSearchParams | string) => {
    const qs = typeof params === "string" ? new URLSearchParams({ error: params }) : params;
    return NextResponse.redirect(`${origin}/?${qs.toString()}`);
  };

  // LINE returned an error (user denied, etc.)
  if (lineError) {
    return failRedirect("line_denied");
  }

  if (!code || !state) {
    return failRedirect("line_missing_params");
  }

  // Verify CSRF state
  const cookieStore = await cookies();
  const storedState = cookieStore.get("fa_line_oauth_state")?.value ?? "";

  // Post-login destination stashed by /api/firstaid/auth/line. Re-sanitised
  // here as defence in depth before it's used in a redirect.
  const nextPath = safeInternalPath(cookieStore.get("fa_line_oauth_next")?.value, "");

  // Anonymous learner id set client-side before the redirect — used to adopt
  // or merge pre-login progress into the canonical learner.
  const deviceLearnerId = cookieStore.get("fa_learner_id")?.value ?? "";

  // Clear the transient cookies
  cookieStore.delete("fa_line_oauth_state");
  cookieStore.delete("fa_line_oauth_next");
  cookieStore.delete("fa_learner_id");

  if (!storedState || storedState !== state) {
    return failRedirect("line_invalid_state");
  }

  const channelId = process.env.FIRSTAID_LINE_LOGIN_CHANNEL_ID;
  const channelSecret = process.env.FIRSTAID_LINE_LOGIN_CHANNEL_SECRET;
  if (!channelId || !channelSecret) {
    console.error("firstaid LINE login env vars missing");
    return failRedirect("line_not_configured");
  }
  const redirectUri = `${origin}/api/firstaid/auth/line/callback`;

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
    console.error("firstaid LINE token exchange failed:", rawBody);

    // Surface LINE's actual error code/description in the redirect URL so the
    // landing page can show it.
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
    return failRedirect(params);
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
    console.error("firstaid LINE profile fetch failed:", await profileRes.text());
    return failRedirect("line_profile_failed");
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

  // ── Step 4: Resolve identity via fa_learner_links ─────────────
  const supabase = createAdminClient();

  const { data: link, error: linkLookupError } = await supabase
    .from("fa_learner_links")
    .select("line_user_id, auth_user_id, learner_id")
    .eq("line_user_id", lineProfile.userId)
    .maybeSingle();

  if (linkLookupError) {
    console.error("fa_learner_links lookup failed:", linkLookupError);
    return failRedirect("line_lookup_failed");
  }

  let userId: string;
  let learnerId: string;

  if (link?.auth_user_id) {
    // Known LINE identity — reuse its auth user + canonical learner id, and
    // merge any progress this device accumulated anonymously under a
    // different local learner id (reconcileLearner semantics of the old
    // api/auth/line.js flow).
    userId = link.auth_user_id as string;
    learnerId = link.learner_id as string;
    await adoptDeviceProgress(supabase, learnerId, deviceLearnerId);
  } else {
    // First firstaid login for this LINE identity — find or create the
    // Supabase auth user, then bind it to a learner id.
    const targetEmail = lineEmail ?? `line_${lineProfile.userId}@line.morroo.com`;

    // Look up any existing profile with the target email (e.g. the same
    // person already uses morroo with their LINE email).
    const { data: profileByEmail, error: emailLookupError } = await supabase
      .from("profiles")
      .select("id")
      .eq("email", targetEmail)
      .maybeSingle();

    if (emailLookupError) {
      console.error("firstaid LINE email lookup failed:", emailLookupError);
      return failRedirect("line_lookup_failed");
    }

    if (profileByEmail) {
      // Link LINE to the existing account
      userId = profileByEmail.id as string;
      const { error: updateError } = await supabase
        .from("profiles")
        .update({
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        })
        .eq("id", userId);

      if (updateError) {
        console.error("Failed to link LINE to profile:", updateError);
        return failRedirect("line_link_failed");
      }
    } else {
      // Create a new Supabase user; the unique email constraint prevents
      // duplicates from concurrent requests.
      const tempPassword = `line_${crypto.randomUUID()}`;
      const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
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
        console.error("Failed to create user for firstaid LINE login:", createError);
        return failRedirect("line_create_failed");
      }

      userId = newUser.user.id;

      // The auth.users INSERT trigger (handle_new_user) auto-creates a profile
      // row; upsert with merge-on-conflict backfills the LINE identity and —
      // crucially for firstaid — marks onboarding as done so the middleware
      // never bounces a firstaid learner into morroo's onboarding flow.
      const { error: upsertError } = await supabase.from("profiles").upsert(
        {
          id: userId,
          email: targetEmail,
          name: lineProfile.displayName,
          role: "user",
          membership_type: "free",
          onboarding_done: true,
          line_user_id: lineProfile.userId,
          line_linked_at: new Date().toISOString(),
        },
        { onConflict: "id" }
      );

      if (upsertError) {
        console.error("Failed to upsert profile for firstaid LINE user:", upsertError);
        return failRedirect("line_create_failed");
      }
    }

    // Determine the canonical learner id. Precedence:
    // 1. fa_migrated_learners — identities copied from the old firstaid
    //    deployment (no auth user was pre-created there, so the mapping to
    //    their historical progress/certificates lives in this staging table
    //    until first login mints the real fa_learner_links row).
    // 2. The anonymous device learner id cookie (pre-login progress carries
    //    over for free).
    // 3. A fresh uuid.
    const { data: migrated } = await supabase
      .from("fa_migrated_learners")
      .select("learner_id")
      .eq("line_user_id", lineProfile.userId)
      .maybeSingle();

    if (migrated?.learner_id) {
      learnerId = migrated.learner_id as string;
    } else {
      learnerId = isUuid(deviceLearnerId) ? deviceLearnerId : crypto.randomUUID();
    }

    if (link) {
      // A link row existed without an auth_user_id (shouldn't happen in
      // practice, but the column is nullable) — keep its learner id canonical
      // and backfill the auth user.
      learnerId = link.learner_id as string;
      const { error: backfillError } = await supabase
        .from("fa_learner_links")
        .update({
          auth_user_id: userId,
          display_name: lineProfile.displayName,
          picture_url: lineProfile.pictureUrl ?? null,
        })
        .eq("line_user_id", lineProfile.userId);
      if (backfillError) {
        console.error("fa_learner_links backfill failed:", backfillError);
        return failRedirect("line_link_failed");
      }
      await adoptDeviceProgress(supabase, learnerId, deviceLearnerId);
    } else {
      const { error: linkInsertError } = await supabase.from("fa_learner_links").insert({
        line_user_id: lineProfile.userId,
        auth_user_id: userId,
        learner_id: learnerId,
        display_name: lineProfile.displayName,
        picture_url: lineProfile.pictureUrl ?? null,
      });
      if (linkInsertError) {
        // Lost a race with a concurrent first login — the winner's learner id
        // is canonical; merge this device's progress into it instead.
        if (linkInsertError.code === "23505") {
          const { data: winner } = await supabase
            .from("fa_learner_links")
            .select("learner_id")
            .eq("line_user_id", lineProfile.userId)
            .maybeSingle();
          if (winner?.learner_id) {
            learnerId = winner.learner_id as string;
            await adoptDeviceProgress(supabase, learnerId, deviceLearnerId);
          }
        } else {
          console.error("fa_learner_links insert failed:", linkInsertError);
          return failRedirect("line_link_failed");
        }
      } else {
        // Migrated learners log in with a canonical id that differs from the
        // device's anonymous id — fold any pre-login progress into it (no-op
        // when the two ids match).
        await adoptDeviceProgress(supabase, learnerId, deviceLearnerId);
      }
    }
  }

  // ── Step 5: Sign the user in by verifying the OTP server-side ─
  // (verifyOtp through the SSR server client sets the auth cookies on this
  // host directly — same proven flow as /api/auth/line/callback.)
  const { data: profileForSignIn, error: profileForSignInError } = await supabase
    .from("profiles")
    .select("email")
    .eq("id", userId)
    .maybeSingle();

  if (profileForSignInError) {
    console.error("Failed to load profile for sign-in:", profileForSignInError);
    return failRedirect("line_session_failed");
  }

  let userEmail: string | null = (profileForSignIn?.email as string | undefined) ?? null;
  if (!userEmail) {
    // Profile row missing (e.g. no handle_new_user trigger) — fall back to the
    // auth record itself.
    const { data: authUser } = await supabase.auth.admin.getUserById(userId);
    userEmail = authUser?.user?.email ?? null;
  }
  if (!userEmail) {
    return failRedirect("line_no_email");
  }

  const { data: linkData, error: linkError } = await supabase.auth.admin.generateLink({
    type: "magiclink",
    email: userEmail,
  });

  if (linkError || !linkData?.properties?.hashed_token) {
    console.error("Failed to generate magic link:", linkError);
    return failRedirect("line_session_failed");
  }

  const supabaseServer = await createServerSupabaseClient();
  const { error: verifyError } = await supabaseServer.auth.verifyOtp({
    type: "magiclink",
    token_hash: linkData.properties.hashed_token,
  });

  if (verifyError) {
    console.error("Failed to verify magic link OTP:", verifyError);
    return failRedirect("line_session_failed");
  }

  // No morroo CAPI signup events / welcome email here — firstaid tracks with
  // its own Meta pixel client-side.

  const destination = nextPath || "/settings";
  return NextResponse.redirect(`${origin}${destination}`);
}
