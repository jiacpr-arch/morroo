/**
 * Sanitises a post-login redirect target.
 *
 * Only same-origin, absolute *paths* are allowed (e.g. `/payment/monthly`).
 * Anything that could send the user off-site — protocol-relative `//evil.com`,
 * absolute URLs `https://evil.com`, or backslash tricks `/\evil.com` — is
 * rejected and the caller's fallback is returned instead. This keeps the
 * `redirect`/`next` query param from becoming an open-redirect vector.
 */
export function safeInternalPath(
  value: string | null | undefined,
  fallback = "/profile",
): string {
  if (!value) return fallback;
  // Must start with a single "/" followed by a non-slash, non-backslash char.
  // Rejects "", "/", "//host", "/\host", and "https://host".
  if (!/^\/[^/\\]/.test(value)) return fallback;
  return value;
}
