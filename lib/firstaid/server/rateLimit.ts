// Lightweight rate limiting + input hygiene for the public (unauthenticated)
// firstaid endpoints (some of which fan out to the admin's LINE).
//
// NOTE: the store is in-memory, so it is per-serverless-instance and resets on
// cold start — best-effort, not a hard guarantee across a scaled deployment. A
// durable limiter (Supabase counter / Upstash) is the follow-up if abuse persists.
//
// Re-expressed for Web API route handlers: instead of writing to a Node `res`,
// rateLimited() returns a ready-made 429 Response when the caller is over the
// limit (return it from the handler), or null when the request may proceed.

const buckets = new Map<string, number[]>()

export function clientIp(request: Request): string {
  const xff = request.headers.get('x-forwarded-for')
  if (typeof xff === 'string' && xff.length) return xff.split(',')[0].trim()
  return 'unknown'
}

export interface RateLimitOptions {
  key?: string
  limit?: number
  windowMs?: number
}

// Sliding-window counter. Returns a 429 Response when the caller is over the
// limit; returns null (and records the hit) otherwise.
export function rateLimited(
  request: Request,
  { key = 'default', limit = 10, windowMs = 60_000 }: RateLimitOptions = {},
): Response | null {
  const now = Date.now()
  const id = `${key}:${clientIp(request)}`
  const hits = (buckets.get(id) || []).filter((t) => now - t < windowMs)
  if (hits.length >= limit) {
    return Response.json({ error: 'Too many requests, please try again later' }, { status: 429 })
  }
  hits.push(now)
  buckets.set(id, hits)
  // Opportunistic cleanup so the map doesn't grow unbounded.
  if (buckets.size > 5000) {
    for (const [k, v] of buckets) {
      if (v.every((t) => now - t >= windowMs)) buckets.delete(k)
    }
  }
  return null
}

// Cap length and collapse whitespace/control chars before interpolating
// user-supplied text into a LINE message, so a caller can't inject extra lines
// or blow up the message size.
export function sanitizeLine(value: unknown, max = 80): string {
  return String(value ?? '')
    .replace(/\p{Cc}+/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .slice(0, max)
}
