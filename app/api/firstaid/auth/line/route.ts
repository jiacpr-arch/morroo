import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import crypto from "crypto";
import { safeInternalPath } from "@/lib/safe-redirect";

/**
 * GET /api/firstaid/auth/line
 *
 * Redirects the user to the LINE Login authorization URL for the firstaid
 * channel (OA @jiacpr). Stores a CSRF `state` token in a cookie to verify the
 * callback. Cloned from /api/auth/line with the firstaid channel + cookies.
 *
 * Query params:
 *   ?next=/path — where to land after login (sanitised internal path)
 *
 * The anonymous learner id cookie `fa_learner_id` (set client-side before the
 * redirect) is intentionally left untouched here — the callback reads it to
 * adopt/merge pre-login progress.
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  // Optional post-login destination. Sanitised to an internal path so it can't
  // become an open redirect. Stashed in an httpOnly cookie (not the LINE state
  // round-trip) and read by the callback after the session is established.
  const next = safeInternalPath(searchParams.get("next"), "");

  const channelId = process.env.FIRSTAID_LINE_LOGIN_CHANNEL_ID;
  if (!channelId) {
    return NextResponse.json(
      { error: "FIRSTAID_LINE_LOGIN_CHANNEL_ID is not configured" },
      { status: 500 }
    );
  }

  // Generate CSRF state token
  const state = crypto.randomBytes(16).toString("hex");

  // Store state in a cookie (httpOnly, short-lived)
  const cookieStore = await cookies();
  cookieStore.set("fa_line_oauth_state", state, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: 600, // 10 minutes
    path: "/",
  });
  // Remember where to send the user after login.
  if (next) {
    cookieStore.set("fa_line_oauth_next", next, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 600,
      path: "/",
    });
  }

  const redirectUri = `${origin}/api/firstaid/auth/line/callback`;

  const lineAuthUrl = new URL("https://access.line.me/oauth2/v2.1/authorize");
  lineAuthUrl.searchParams.set("response_type", "code");
  lineAuthUrl.searchParams.set("client_id", channelId);
  lineAuthUrl.searchParams.set("redirect_uri", redirectUri);
  lineAuthUrl.searchParams.set("state", state);
  lineAuthUrl.searchParams.set("scope", "profile openid email");
  // Nudge the user to add the OA (@jiacpr) as a friend during login — this is
  // what feeds the LINE nurture funnel, same as the old firstaid app.
  lineAuthUrl.searchParams.set("bot_prompt", "aggressive");

  return NextResponse.redirect(lineAuthUrl.toString());
}
