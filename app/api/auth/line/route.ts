import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import crypto from "crypto";
import { safeInternalPath } from "@/lib/safe-redirect";

/**
 * GET /api/auth/line
 *
 * Redirects the user to LINE Login authorization URL.
 * Stores a CSRF `state` token in a cookie to verify the callback.
 *
 * Query params:
 *   ?mode=register  — used after callback to decide redirect destination
 *   ?next=/path     — where to land after login (e.g. back to checkout)
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const mode = searchParams.get("mode") ?? "login"; // "login" | "register"
  // Optional post-login destination, e.g. a buyer bounced from /payment/[plan].
  // Sanitised to an internal path so it can't become an open redirect. Stashed
  // in an httpOnly cookie (not the LINE state round-trip) and read by the
  // callback after the session is established.
  const next = safeInternalPath(searchParams.get("next"), "");

  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  if (!channelId) {
    return NextResponse.json(
      { error: "LINE_LOGIN_CHANNEL_ID is not configured" },
      { status: 500 }
    );
  }

  // Generate CSRF state token
  const state = crypto.randomBytes(16).toString("hex");

  // Store state + mode in a cookie (httpOnly, short-lived)
  const cookieStore = await cookies();
  cookieStore.set("line_oauth_state", `${state}:${mode}`, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    maxAge: 600, // 10 minutes
    path: "/",
  });
  // Remember where to send the user after login. A separate cookie keeps the
  // CSRF state value clean and avoids encoding a path with ":" into it.
  if (next) {
    cookieStore.set("line_oauth_next", next, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "lax",
      maxAge: 600,
      path: "/",
    });
  }

  const redirectUri = `${origin}/api/auth/line/callback`;

  const lineAuthUrl = new URL("https://access.line.me/oauth2/v2.1/authorize");
  lineAuthUrl.searchParams.set("response_type", "code");
  lineAuthUrl.searchParams.set("client_id", channelId);
  lineAuthUrl.searchParams.set("redirect_uri", redirectUri);
  lineAuthUrl.searchParams.set("state", state);
  lineAuthUrl.searchParams.set("scope", "profile openid email");

  return NextResponse.redirect(lineAuthUrl.toString());
}
