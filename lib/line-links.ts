/**
 * Shared helpers for turning morroo.com links into LIFF deep links.
 *
 * Opening a LIFF URL (`https://liff.line.me/{LIFF_ID}/...`) from inside the
 * LINE app skips straight past login — the visitor is already
 * LINE-authenticated, so /line/liff (see app/(liff)/line/liff and
 * app/api/auth/line/liff-session) signs them in immediately instead of
 * dropping them on a logged-out page. Both helpers fall back to a plain
 * morroo.com URL when NEXT_PUBLIC_LIFF_ID isn't configured, so nothing here
 * ever breaks a deploy that hasn't set up the LIFF app yet.
 *
 * LINE-only: these are for links that go into LINE Flex messages
 * (lib/line-flex-templates.ts, lib/daily-mcq-line.ts) exclusively. Never use
 * them for a Facebook/Instagram caption (lib/facebook.ts, lib/instagram.ts,
 * lib/autopost-copy.ts) — a liff.line.me URL opened outside the LINE app
 * bounces through LINE Login's web flow first, which is fine for a LINE
 * message but wrong for a social caption meant to open directly.
 */

// Same .trim() reasoning as SITE_URL in lib/daily-mcq-line.ts and
// lib/line-flex-templates.ts: NEXT_PUBLIC_SITE_URL has carried trailing
// whitespace in this Vercel project's env config before, and a malformed
// URI gets rejected outright by LINE's Flex "uri" action validation.
const SITE_URL = (process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com").trim();

/** Hosts that are "ours" — only these ever get rewritten to a LIFF URL. */
const OWN_HOSTS = new Set(["www.morroo.com", "morroo.com"]);

/** LIFF deep link for a relative `path` (e.g. "/line/liff"), or a plain site URL as fallback. */
export function liffDeepLink(path: string): string {
  const liffId = process.env.NEXT_PUBLIC_LIFF_ID;
  return liffId ? `https://liff.line.me/${liffId}${path}` : `${SITE_URL}${path}`;
}

/**
 * Rewrites an existing absolute morroo.com URL (already carrying whatever
 * query params/UTMs the caller built) into a LIFF deep link, preserving the
 * path and query string exactly. Non-morroo URLs, and any URL when
 * NEXT_PUBLIC_LIFF_ID isn't set, pass through unchanged.
 */
export function toLiffUri(fullUrl: string): string {
  const liffId = process.env.NEXT_PUBLIC_LIFF_ID;
  if (!liffId) return fullUrl;

  let parsed: URL;
  try {
    parsed = new URL(fullUrl);
  } catch {
    return fullUrl;
  }

  if (!OWN_HOSTS.has(parsed.hostname)) return fullUrl;

  return `https://liff.line.me/${liffId}${parsed.pathname}${parsed.search}`;
}
