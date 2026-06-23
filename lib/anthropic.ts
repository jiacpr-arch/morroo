import Anthropic from "@anthropic-ai/sdk";

/**
 * Single place to construct the Anthropic client.
 *
 * Sets `maxRetries: 4` so transient upstream errors (429 rate limit, 5xx, 529
 * overloaded) are retried with exponential backoff before surfacing a failure —
 * the SDK default is only 2, which isn't enough when the API is busy. Always
 * construct via this helper instead of `new Anthropic(...)` directly so the
 * retry policy can't be forgotten in a new route.
 *
 * Callers should still guard on `process.env.ANTHROPIC_API_KEY` themselves when
 * they want a specific "not configured" response — the SDK otherwise throws on
 * first use when the key is missing.
 */
export function createAnthropic(): Anthropic {
  return new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
    maxRetries: 4,
  });
}
