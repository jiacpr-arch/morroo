/**
 * Verify a LINE-issued ID token (from LIFF's `liff.getIDToken()` or the
 * OAuth token exchange's `id_token`) against LINE's own verify endpoint.
 *
 * Never trust a client-supplied LINE userId — the `sub` claim here is the
 * only value that's actually been checked against LINE, and the `aud`
 * claim must match our own LINE Login channel so a token minted for a
 * different channel can't be replayed against ours.
 */
export interface VerifiedLineIdToken {
  /** LINE userId (the `sub` claim) — verified. */
  sub: string;
  /** Present only when the token's scope included `email` and the user consented. */
  email: string | null;
}

export async function verifyLineIdToken(
  idToken: string,
  channelId: string
): Promise<VerifiedLineIdToken | null> {
  const res = await fetch("https://api.line.me/oauth2/v2.1/verify", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      id_token: idToken,
      client_id: channelId,
    }),
  });

  if (!res.ok) {
    const detail = await res.text().catch(() => "<no body>");
    console.error(`[line-id-token] verify failed status=${res.status} body=${detail}`);
    return null;
  }

  const payload = (await res.json().catch(() => null)) as
    | { sub?: string; aud?: string; email?: string }
    | null;

  if (!payload?.sub || payload.aud !== channelId) {
    return null;
  }

  return { sub: payload.sub, email: payload.email ?? null };
}
