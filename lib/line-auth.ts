/**
 * Shared "LINE identity → Supabase user" logic.
 *
 * Extracted from app/api/auth/line/callback/route.ts (the LINE Login OAuth
 * flow) so the LIFF auth bridge (app/api/auth/line/liff-session/route.ts)
 * can reuse the exact same find-or-create + link rules instead of
 * duplicating them. The OAuth callback's behavior is unchanged by this
 * extraction — every redirect/error path there still fires on the same
 * conditions as before.
 */
import type { createAdminClient } from "@/lib/supabase/admin";
import type { createClient as createServerSupabaseClient } from "@/lib/supabase/server";

type AdminClient = ReturnType<typeof createAdminClient>;
type ServerClient = Awaited<ReturnType<typeof createServerSupabaseClient>>;

export interface LineProfileInput {
  lineUserId: string;
  displayName?: string | null;
  pictureUrl?: string | null;
  /** From the ID token's `email` claim — null when the user didn't grant email scope. */
  email?: string | null;
}

/**
 * Placeholder email for LINE accounts that didn't grant (or don't have) an
 * email — matches the domain already used by app/api/auth/line/callback and
 * asserted on in app/api/line/expiry-warning/route.test.ts, so both auth
 * paths and the expiry-reminder "is this a real email" check stay consistent.
 */
export function linePlaceholderEmail(lineUserId: string): string {
  return `line_${lineUserId}@line.morroo.com`;
}

export interface ResolvedLineUser {
  userId: string;
  email: string;
  isNewSignup: boolean;
}

/**
 * Find the Supabase user for a verified LINE profile, or create one.
 *
 * Lookup order (mirrors the pre-refactor callback exactly):
 *   1. profiles.line_user_id already matches → that user.
 *   2. profiles.email matches the target email (real or placeholder) →
 *      link LINE onto that account.
 *   3. Neither → create a new auth user + profile row.
 */
export async function resolveOrCreateLineUser(
  admin: AdminClient,
  profile: LineProfileInput
): Promise<ResolvedLineUser | { error: string }> {
  const { data: existingByLine, error: lookupError } = await admin
    .from("profiles")
    .select("id, email")
    .eq("line_user_id", profile.lineUserId)
    .maybeSingle();

  if (lookupError) {
    console.error("[line-auth] line_user_id lookup failed:", lookupError);
    return { error: "line_lookup_failed" };
  }

  const targetEmail = profile.email ?? linePlaceholderEmail(profile.lineUserId);

  if (existingByLine) {
    return { userId: existingByLine.id, email: existingByLine.email ?? targetEmail, isNewSignup: false };
  }

  const { data: profileByEmail, error: emailLookupError } = await admin
    .from("profiles")
    .select("id")
    .eq("email", targetEmail)
    .maybeSingle();

  if (emailLookupError) {
    console.error("[line-auth] email lookup failed:", emailLookupError);
    return { error: "line_lookup_failed" };
  }

  if (profileByEmail) {
    const { error: updateError } = await admin
      .from("profiles")
      .update({
        line_user_id: profile.lineUserId,
        line_linked_at: new Date().toISOString(),
      })
      .eq("id", profileByEmail.id);

    if (updateError) {
      console.error("[line-auth] failed to link LINE to existing profile:", updateError);
      return { error: "line_link_failed" };
    }

    return { userId: profileByEmail.id, email: targetEmail, isNewSignup: false };
  }

  // No existing account by LINE id or email — create a new one.
  const tempPassword = `line_${crypto.randomUUID()}`;
  const { data: newUser, error: createError } = await admin.auth.admin.createUser({
    email: targetEmail,
    password: tempPassword,
    email_confirm: true,
    user_metadata: {
      name: profile.displayName,
      avatar_url: profile.pictureUrl,
      provider: "line",
    },
  });

  if (createError || !newUser.user) {
    console.error("[line-auth] failed to create user for LINE identity:", createError);
    return { error: "line_create_failed" };
  }

  const userId = newUser.user.id;

  // The auth.users INSERT trigger (handle_new_user) auto-creates a profile
  // row with default fields but no line_* columns. Upsert with
  // merge-on-conflict so the trigger-created row gets the LINE identity
  // backfilled, and this still works if the trigger is ever removed.
  const { error: upsertError } = await admin.from("profiles").upsert(
    {
      id: userId,
      email: targetEmail,
      name: profile.displayName,
      role: "user",
      membership_type: "free",
      line_user_id: profile.lineUserId,
      line_linked_at: new Date().toISOString(),
    },
    { onConflict: "id" }
  );

  if (upsertError) {
    console.error("[line-auth] failed to upsert profile for new LINE user:", upsertError);
    return { error: "line_create_failed" };
  }

  return { userId, email: targetEmail, isNewSignup: true };
}

export type LinkLineResult =
  | { ok: true }
  | { ok: false; reason: "already_linked_other" | "error" };

/**
 * Link a verified LINE userId onto an *already-signed-in* Supabase user
 * (the LIFF case: the visitor has a live morroo session and just proved
 * they own this LINE account). Refuses to steal a LINE identity that's
 * already linked to a different account — same rule the webhook's
 * MORROO-XXXXXX code flow enforces in app/api/line/webhook/route.ts.
 */
export async function linkLineToUser(
  admin: AdminClient,
  userId: string,
  lineUserId: string
): Promise<LinkLineResult> {
  const { data: existing, error: existingError } = await admin
    .from("profiles")
    .select("id")
    .eq("line_user_id", lineUserId)
    .maybeSingle();

  if (existingError) {
    console.error("[line-auth] existing-link lookup failed:", existingError);
    return { ok: false, reason: "error" };
  }

  if (existing && existing.id !== userId) {
    return { ok: false, reason: "already_linked_other" };
  }

  if (existing && existing.id === userId) {
    return { ok: true }; // already linked to this same account — no-op
  }

  const { error: updateError } = await admin
    .from("profiles")
    .update({
      line_user_id: lineUserId,
      line_linked_at: new Date().toISOString(),
    })
    .eq("id", userId);

  if (updateError) {
    console.error("[line-auth] failed to link LINE to profile:", updateError);
    return { ok: false, reason: "error" };
  }

  return { ok: true };
}

/**
 * Establish a Supabase session for `email` on the given request-scoped
 * server client, by generating a magic link and immediately verifying it
 * server-side. This sets the auth cookies directly on the app domain — see
 * the comment in app/api/auth/line/callback/route.ts for why this replaced
 * redirecting to Supabase's own /auth/v1/verify endpoint (which returns
 * session tokens in a URL fragment server routes can't read).
 */
export async function establishSessionFor(
  admin: AdminClient,
  serverSupabase: ServerClient,
  email: string,
  redirectTo: string
): Promise<{ ok: true } | { ok: false; error: string }> {
  const { data: linkData, error: linkError } = await admin.auth.admin.generateLink({
    type: "magiclink",
    email,
    options: { redirectTo },
  });

  if (linkError || !linkData?.properties?.hashed_token) {
    console.error("[line-auth] failed to generate magic link:", linkError);
    return { ok: false, error: "line_session_failed" };
  }

  const { error: verifyError } = await serverSupabase.auth.verifyOtp({
    type: "magiclink",
    token_hash: linkData.properties.hashed_token,
  });

  if (verifyError) {
    console.error("[line-auth] failed to verify magic link OTP:", verifyError);
    return { ok: false, error: "line_session_failed" };
  }

  return { ok: true };
}
