// Best-effort per-IP rate limiting for anonymous course endpoints (students
// aren't authenticated, so morroo's user-id-keyed lib/rate-limit.ts doesn't
// apply here). State is an in-memory Map per serverless instance — good
// enough to stop a single IP hammering these endpoints without adding
// external infra.

import type { NextRequest } from "next/server";

interface Bucket {
  count: number;
  resetAt: number;
}

const buckets = new Map<string, Bucket>();
const MAX_BUCKETS = 10_000;

export function getRequestIp(req: NextRequest): string {
  return (
    req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() ||
    req.headers.get("x-real-ip") ||
    "unknown"
  );
}

export function ipRateLimit(
  req: NextRequest,
  { key, limit, windowMs }: { key: string; limit: number; windowMs: number },
): { ok: boolean; retryAfter: number } {
  const now = Date.now();
  const id = `${key}:${getRequestIp(req)}`;
  let bucket = buckets.get(id);
  if (!bucket || now >= bucket.resetAt) {
    bucket = { count: 0, resetAt: now + windowMs };
    if (buckets.size >= MAX_BUCKETS) pruneExpired(now);
    buckets.set(id, bucket);
  }
  bucket.count += 1;
  if (bucket.count > limit) {
    return { ok: false, retryAfter: Math.max(1, Math.ceil((bucket.resetAt - now) / 1000)) };
  }
  return { ok: true, retryAfter: 0 };
}

function pruneExpired(now: number) {
  for (const [id, bucket] of buckets) {
    if (now >= bucket.resetAt) buckets.delete(id);
  }
  if (buckets.size >= MAX_BUCKETS) {
    const excess = buckets.size - MAX_BUCKETS + 1;
    let i = 0;
    for (const id of buckets.keys()) {
      if (i++ >= excess) break;
      buckets.delete(id);
    }
  }
}

/** Test hook. */
export function _resetIpRateLimitStore() {
  buckets.clear();
}
