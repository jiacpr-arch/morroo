import { NextResponse } from "next/server";
import { cookies } from "next/headers";
import crypto from "crypto";

/**
 * GET /api/auth/line
 *
 * Redirects the user to LINE Login authorization URL.
 * Stores a CSRF `state` token in a cookie to verify the callback.
 *
 * Query params:
 *   ?mode=register  — used after callback to decide redirect destination
 */
export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const mode = searchParams.get("mode") ?? "login"; // "login" | "register"

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

  const redirectUri = `${origin}/api/auth/line/callback`;

  const lineAuthUrl = new URL("https://access.line.me/oauth2/v2.1/authorize");
  lineAuthUrl.searchParams.set("response_type", "code");
  lineAuthUrl.searchParams.set("client_id", channelId);
  lineAuthUrl.searchParams.set("redirect_uri", redirectUri);
  lineAuthUrl.searchParams.set("state", state);
  lineAuthUrl.searchParams.set("scope", "profile openid email");

  return NextResponse.redirect(lineAuthUrl.toString());
}
