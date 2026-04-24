import type { SupabaseClient } from "@supabase/supabase-js";
import { NextResponse } from "next/server";

export interface RateLimitResult {
  allowed: boolean;
  count: number;
  remaining: number;
  reset_at: string;
}

export interface RateLimitConfig {
  /** Max requests allowed per window */
  max: number;
  /** Window length in seconds */
  windowSeconds: number;
}

// Presets for the routes we care about. Keep them in one place so it's easy
// to scan and tune.
export const RATE_LIMITS = {
  aiChat: { max: 30, windowSeconds: 3600 },          // 30 Claude chats / hour
  mcqRecommended: { max: 60, windowSeconds: 3600 },  // 60 recs / hour
  reportError: { max: 20, windowSeconds: 86400 },    // 20 reports / day
} as const satisfies Record<string, RateLimitConfig>;

/**
 * Atomically bumps the counter for (userId, routeKey) in the current window.
 * Call before doing any expensive work. Missing/failing RPC fails open — we
 * don't want a rate-limit outage to take down the app.
 */
export async function checkRateLimit(
  supabase: SupabaseClient,
  userId: string,
  routeKey: string,
  config: RateLimitConfig
): Promise<RateLimitResult> {
  const { data, error } = await supabase.rpc("check_and_increment_rate_limit", {
    p_user_id: userId,
    p_route_key: routeKey,
    p_max: config.max,
    p_window_seconds: config.windowSeconds,
  });

  if (error || !data) {
    return { allowed: true, count: 0, remaining: config.max, reset_at: new Date().toISOString() };
  }

  return data as RateLimitResult;
}

/**
 * Convenience: returns a 429 NextResponse with standard headers when the
 * caller is over the limit, or null when the request should proceed.
 */
export function rateLimitResponse(result: RateLimitResult, config: RateLimitConfig): Response | null {
  if (result.allowed) return null;
  const retryAfterSeconds = Math.max(
    0,
    Math.ceil((new Date(result.reset_at).getTime() - Date.now()) / 1000)
  );
  return NextResponse.json(
    {
      error: "ขอมากเกินไป — กรุณารอแล้วลองใหม่",
      retry_after_seconds: retryAfterSeconds,
    },
    {
      status: 429,
      headers: {
        "Retry-After": String(retryAfterSeconds),
        "X-RateLimit-Limit": String(config.max),
        "X-RateLimit-Remaining": String(result.remaining),
        "X-RateLimit-Reset": result.reset_at,
      },
    }
  );
}
