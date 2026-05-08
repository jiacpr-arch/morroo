import crypto from "crypto";

const LINE_AUTH_BASE = "https://access.line.me/oauth2/v2.1/authorize";
const LINE_TOKEN_URL = "https://api.line.me/oauth2/v2.1/token";
const LINE_PROFILE_URL = "https://api.line.me/v2/profile";

export interface LineProfile {
  userId: string;
  displayName: string;
  pictureUrl?: string;
}

export function buildLineAuthorizeUrl(state: string, redirectUri: string): string {
  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  if (!channelId) throw new Error("LINE_LOGIN_CHANNEL_ID not set");

  const params = new URLSearchParams({
    response_type: "code",
    client_id: channelId,
    redirect_uri: redirectUri,
    state,
    scope: "profile openid",
    bot_prompt: "aggressive",
  });
  return `${LINE_AUTH_BASE}?${params.toString()}`;
}

export async function exchangeLineCode(
  code: string,
  redirectUri: string
): Promise<{ accessToken: string } | null> {
  const channelId = process.env.LINE_LOGIN_CHANNEL_ID;
  const channelSecret = process.env.LINE_LOGIN_CHANNEL_SECRET;
  if (!channelId || !channelSecret) {
    console.error("[line-oauth] LINE_LOGIN_CHANNEL_ID/SECRET not set");
    return null;
  }

  const body = new URLSearchParams({
    grant_type: "authorization_code",
    code,
    redirect_uri: redirectUri,
    client_id: channelId,
    client_secret: channelSecret,
  });

  const res = await fetch(LINE_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: body.toString(),
  });

  if (!res.ok) {
    const err = await res.text().catch(() => "<no body>");
    console.error(`[line-oauth] token exchange failed status=${res.status} body=${err}`);
    return null;
  }
  const data = (await res.json()) as { access_token?: string };
  if (!data.access_token) return null;
  return { accessToken: data.access_token };
}

export async function fetchLineProfile(accessToken: string): Promise<LineProfile | null> {
  const res = await fetch(LINE_PROFILE_URL, {
    method: "GET",
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (!res.ok) {
    const err = await res.text().catch(() => "<no body>");
    console.error(`[line-oauth] profile fetch failed status=${res.status} body=${err}`);
    return null;
  }
  return (await res.json()) as LineProfile;
}

/**
 * Sign + verify a short-lived OAuth state token. Carries the auth user_id
 * so the callback can link the LINE account to the correct user without
 * trusting any client-side data.
 */
const SIG_TTL_SECONDS = 600;

export function signOAuthState(userId: string): string {
  const secret = process.env.LINE_OAUTH_STATE_SECRET || process.env.LINE_LOGIN_CHANNEL_SECRET;
  if (!secret) throw new Error("LINE_OAUTH_STATE_SECRET not set");
  const issuedAt = Math.floor(Date.now() / 1000);
  const payload = `${userId}.${issuedAt}`;
  const sig = crypto.createHmac("sha256", secret).update(payload).digest("base64url");
  return `${payload}.${sig}`;
}

export function verifyOAuthState(
  state: string
): { userId: string } | { error: string } {
  const secret = process.env.LINE_OAUTH_STATE_SECRET || process.env.LINE_LOGIN_CHANNEL_SECRET;
  if (!secret) return { error: "secret not set" };
  const parts = state.split(".");
  if (parts.length !== 3) return { error: "malformed state" };
  const [userId, issuedAtStr, sig] = parts;

  const expected = crypto
    .createHmac("sha256", secret)
    .update(`${userId}.${issuedAtStr}`)
    .digest("base64url");

  let recv: Buffer;
  let exp: Buffer;
  try {
    recv = Buffer.from(sig, "base64url");
    exp = Buffer.from(expected, "base64url");
  } catch {
    return { error: "bad signature encoding" };
  }
  if (recv.length !== exp.length || !crypto.timingSafeEqual(recv, exp)) {
    return { error: "bad signature" };
  }

  const issuedAt = parseInt(issuedAtStr, 10);
  if (!Number.isFinite(issuedAt)) return { error: "bad timestamp" };
  if (Math.floor(Date.now() / 1000) - issuedAt > SIG_TTL_SECONDS) {
    return { error: "state expired" };
  }
  return { userId };
}
