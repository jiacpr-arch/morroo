import { NextResponse } from "next/server";
import { createClient as createServerSupabaseClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { verifyLineIdToken } from "@/lib/line-id-token";
import {
  resolveOrCreateLineUser,
  linkLineToUser,
  establishSessionFor,
} from "@/lib/line-auth";

/**
 * POST /api/auth/line/liff-session
 *
 * The LIFF auth bridge: verifies a LIFF-issued ID token with LINE, then
 * either links the LINE identity onto the visitor's existing morroo session
 * (if they're already logged in) or resolves/creates a Supabase account for
 * it and signs them straight in — the same find-or-create + link rules as
 * the LINE Login OAuth flow (app/api/auth/line/callback/route.ts), shared
 * via lib/line-auth.ts.
 *
 * Supersedes /api/line/liff-link, which could only link an *already
 * signed-in* session and otherwise left the visitor to go log in manually.
 *
 * Body: { idToken: string, displayName?: string, pictureUrl?: string }
 * Response: { ok: true, linked: boolean, isNewSignup?: boolean, reason?: string }
 *        or { ok: false, error: string }
 */
export async function POST(request: Request) {
  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  if (!channelId) {
    return NextResponse.json(
      { ok: false, error: "LINE_LOGIN_CHANNEL_ID is not configured" },
      { status: 500 }
    );
  }

  let body: { idToken?: unknown; displayName?: unknown; pictureUrl?: unknown };
  try {
    body = (await request.json()) as typeof body;
  } catch {
    return NextResponse.json({ ok: false, error: "invalid_body" }, { status: 400 });
  }

  const idToken = typeof body.idToken === "string" ? body.idToken : "";
  if (!idToken) {
    return NextResponse.json({ ok: false, error: "missing_id_token" }, { status: 400 });
  }

  const verified = await verifyLineIdToken(idToken, channelId);
  if (!verified) {
    return NextResponse.json({ ok: false, error: "id_token_invalid" }, { status: 401 });
  }

  const lineUserId = verified.sub;
  const displayName = typeof body.displayName === "string" ? body.displayName : null;
  const pictureUrl = typeof body.pictureUrl === "string" ? body.pictureUrl : null;

  const admin = createAdminClient();
  const serverSupabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await serverSupabase.auth.getUser();

  // Already logged into morroo — just link this LINE identity onto that account.
  if (user) {
    const linkResult = await linkLineToUser(admin, user.id, lineUserId);
    if (!linkResult.ok) {
      if (linkResult.reason === "already_linked_other") {
        return NextResponse.json({ ok: true, linked: false, reason: "already_linked_other" });
      }
      return NextResponse.json({ ok: false, error: "link_failed" }, { status: 500 });
    }
    return NextResponse.json({ ok: true, linked: true });
  }

  // No morroo session yet — resolve or create the account, then sign in.
  const resolved = await resolveOrCreateLineUser(admin, {
    lineUserId,
    displayName,
    pictureUrl,
    email: verified.email,
  });

  if ("error" in resolved) {
    return NextResponse.json({ ok: false, error: resolved.error }, { status: 500 });
  }

  const { origin } = new URL(request.url);
  const sessionResult = await establishSessionFor(
    admin,
    serverSupabase,
    resolved.email,
    `${origin}/auth/callback`
  );

  if (!sessionResult.ok) {
    return NextResponse.json({ ok: false, error: sessionResult.error }, { status: 500 });
  }

  return NextResponse.json({ ok: true, linked: true, isNewSignup: resolved.isNewSignup });
}
