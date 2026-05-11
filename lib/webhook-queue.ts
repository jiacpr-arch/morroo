/**
 * Webhook event queue — durable persistence + retry for LINE/FB webhooks.
 *
 * Flow:
 *   1. Webhook handler calls enqueueWebhook() and returns 200 immediately.
 *   2. Processing runs via Next.js after() (post-response, same Vercel invocation).
 *   3. If processing fails, the event stays 'pending' and the retry cron picks it up.
 *   4. After max_attempts, status becomes 'failed' for manual inspection.
 */

import { createAdminClient } from "@/lib/supabase/admin";

export type WebhookChannel = "line" | "facebook";
export type WebhookStatus = "pending" | "processing" | "done" | "failed";

export interface WebhookEvent {
  id: string;
  channel: WebhookChannel;
  payload: Record<string, unknown>;
  attempts: number;
  max_attempts: number;
  status: WebhookStatus;
  next_retry_at: string;
  error: string | null;
}

/** Backoff schedule: attempt 1 → +5m, attempt 2 → +15m, attempt 3+ → +60m */
function nextRetryAt(attempts: number): string {
  const minutes = attempts === 1 ? 5 : attempts === 2 ? 15 : 60;
  return new Date(Date.now() + minutes * 60_000).toISOString();
}

export async function enqueueWebhook(
  channel: WebhookChannel,
  payload: Record<string, unknown>
): Promise<string | null> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("webhook_events")
    .insert({ channel, payload })
    .select("id")
    .single();

  if (error) {
    console.error("[webhook-queue] enqueue failed:", error);
    return null;
  }
  return data.id;
}

export async function markWebhookDone(id: string): Promise<void> {
  const supabase = createAdminClient();
  await supabase
    .from("webhook_events")
    .update({ status: "done", completed_at: new Date().toISOString() })
    .eq("id", id);
}

export async function markWebhookFailed(id: string, error: string): Promise<void> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("webhook_events")
    .select("attempts, max_attempts")
    .eq("id", id)
    .maybeSingle();

  if (!data) return;

  const attempts = data.attempts + 1;
  const isFinal = attempts >= data.max_attempts;

  await supabase
    .from("webhook_events")
    .update({
      attempts,
      status: isFinal ? "failed" : "pending",
      error: error.slice(0, 1000),
      next_retry_at: isFinal ? null : nextRetryAt(attempts),
      ...(isFinal ? { completed_at: new Date().toISOString() } : {}),
    })
    .eq("id", id);
}

/** Called by the retry cron — returns up to `limit` pending events due for retry. */
export async function claimPendingWebhooks(
  limit = 20
): Promise<WebhookEvent[]> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("webhook_events")
    .select("*")
    .eq("status", "pending")
    .lte("next_retry_at", new Date().toISOString())
    .order("next_retry_at", { ascending: true })
    .limit(limit);

  if (error) {
    console.error("[webhook-queue] claim failed:", error);
    return [];
  }

  if (!data?.length) return [];

  // Mark as processing so concurrent invocations don't double-process.
  // Duplicate processing is safe anyway: chatbot replies are idempotent
  // because we deduplicate on chat_messages inserts.
  const ids = data.map((e) => e.id);
  await supabase
    .from("webhook_events")
    .update({ status: "processing" })
    .in("id", ids);

  return data as WebhookEvent[];
}
