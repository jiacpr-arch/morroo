import Anthropic from "@anthropic-ai/sdk";
import { logAIError } from "@/lib/anthropic-error";

/**
 * Model fallback chains. The first model is the primary; later ones are smaller
 * models used only if the primary fails. Smaller models tend to be less
 * capacity-constrained, so a partial Anthropic outage degrades quality instead
 * of blocking the user entirely.
 */
export const CHAT_MODELS: string[] = ["claude-sonnet-4-6", "claude-haiku-4-5"];
export const SCORE_MODELS: string[] = ["claude-opus-4-7", "claude-sonnet-4-6"];

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

/**
 * Run a non-streaming message request through a model fallback chain. Tries each
 * model in order; if one fails (after the client's own retries are exhausted)
 * the next, smaller model is tried. Intermediate failures are logged so a
 * flaky primary is visible even when the fallback rescues the request; the
 * final failure propagates to the caller's catch (which logs + maps it).
 */
export async function createWithFallback(
  client: Anthropic,
  models: string[],
  params: Omit<Anthropic.MessageCreateParamsNonStreaming, "model">,
  context: string,
): Promise<Anthropic.Message> {
  let lastErr: unknown;
  for (let i = 0; i < models.length; i++) {
    try {
      return await client.messages.create({ ...params, model: models[i] });
    } catch (err) {
      lastErr = err;
      if (i < models.length - 1) logAIError(`${context}:fallback-from-${models[i]}`, err);
    }
  }
  throw lastErr;
}

/**
 * Stream text deltas through a model fallback chain. If a model fails *before*
 * emitting any text, the next model is tried. Once any token has been streamed
 * we do NOT fall back — restarting mid-message would duplicate or garble the
 * output the user already sees — so that error propagates to the caller.
 */
export async function* streamTextWithFallback(
  client: Anthropic,
  models: string[],
  params: Omit<Anthropic.MessageStreamParams, "model">,
  context: string,
): AsyncGenerator<string, void, unknown> {
  for (let i = 0; i < models.length; i++) {
    let emitted = false;
    try {
      const stream = client.messages.stream({ ...params, model: models[i] });
      for await (const event of stream) {
        if (event.type === "content_block_delta" && event.delta.type === "text_delta") {
          emitted = true;
          yield event.delta.text;
        }
      }
      return;
    } catch (err) {
      if (emitted || i === models.length - 1) throw err;
      logAIError(`${context}:fallback-from-${models[i]}`, err);
    }
  }
}
