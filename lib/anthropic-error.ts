import Anthropic from "@anthropic-ai/sdk";
import * as Sentry from "@sentry/nextjs";
import { after } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { sendThrottledAdminAlert } from "@/lib/admin-alerts";

/** Where the admin raises the monthly spend limit. */
export const ANTHROPIC_LIMITS_URL = "https://console.anthropic.com/settings/limits";

/** Shown to users while the API account is out of budget — retrying won't help. */
export const AI_PAUSED_MESSAGE =
  "ระบบ AI ปิดปรับปรุงชั่วคราว กรุณากลับมาใช้งานใหม่ภายหลังนะคะ";

/**
 * True when the Anthropic account has hit its spend limit (or run out of
 * credit). Unlike 429/529 this is not transient: every AI call fails until the
 * limit resets or the admin raises it. The API returns it as a 400
 * invalid_request_error, so match on the message rather than the status.
 */
export function isUsageLimitError(err: unknown): boolean {
  const msg = err instanceof Error ? err.message : String(err ?? "");
  return /reached your specified API usage limits|credit balance is too low/i.test(msg);
}

/** "2026-10-01 at 00:00 UTC" from the usage-limit message, when present. */
export function usageLimitResetAt(err: unknown): string | null {
  const msg = err instanceof Error ? err.message : String(err ?? "");
  return msg.match(/regain access on ([^."]+)/i)?.[1]?.trim() ?? null;
}

export function buildUsageLimitAlertText(context: string, err: unknown): string {
  const resetAt = usageLimitResetAt(err);
  return [
    "🚨 Anthropic API ใช้ครบวงเงินแล้ว — ฟีเจอร์ AI ทั้งเว็บใช้ไม่ได้",
    `(AI ตรวจ MEQ, Long Case, แชต, สร้างข้อสอบ ฯลฯ) พบที่: ${context}`,
    resetAt ? `จะกลับมาใช้ได้เอง: ${resetAt}` : "ต้องเพิ่มวงเงินหรือเติมเครดิต",
    "",
    `เพิ่มวงเงิน: ${ANTHROPIC_LIMITS_URL}`,
    "(แจ้งเรื่องนี้ไม่เกิน 1 ครั้งทุก 6 ชม.)",
  ].join("\n");
}

function alertUsageLimit(context: string, err: unknown): void {
  const send = async () => {
    await sendThrottledAdminAlert(
      createAdminClient(),
      "ai_usage_limit",
      buildUsageLimitAlertText(context, err)
    );
  };
  try {
    // Keeps the serverless function alive until the LINE push finishes.
    after(send);
  } catch {
    // Outside a request scope (cron helpers, scripts, stream callbacks).
    void send().catch(() => {});
  }
}

/**
 * Fire-and-forget an `ai_error` event to PostHog (for trend dashboards +
 * alerts) without adding the posthog-node dependency. No-op unless
 * `POSTHOG_PROJECT_KEY` is set, so it's safe in any environment.
 */
function captureToPostHog(context: string, err: unknown): void {
  const key = process.env.POSTHOG_PROJECT_KEY;
  if (!key) return;
  const host = process.env.POSTHOG_HOST ?? "https://us.i.posthog.com";
  const status = err instanceof Anthropic.APIError ? err.status : undefined;
  void fetch(`${host}/capture/`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      api_key: key,
      event: "ai_error",
      distinct_id: "ai-server",
      properties: {
        ai_context: context,
        status,
        $process_person_profile: false,
      },
    }),
  }).catch(() => {});
}

/**
 * Log an AI-related error to the server console, Sentry, and PostHog so we can
 * see how often the upstream API is failing (and grab the request_id) — instead
 * of silently swallowing it after showing the user a friendly message.
 * `context` is a short tag like "longcase-examiner:score" identifying the call
 * site.
 */
export function logAIError(context: string, err: unknown): void {
  console.error(`[ai-error] ${context}:`, err);
  Sentry.captureException(err, { tags: { feature: "ai", ai_context: context } });
  captureToPostHog(context, err);
  if (isUsageLimitError(err)) alertUsageLimit(context, err);
}

/**
 * Map an Anthropic SDK / network error to a friendly Thai message that is safe
 * to show users mid-exam.
 *
 * Never leak the raw API error body (e.g.
 * `{"type":"error","error":{"type":"overloaded_error","message":"Overloaded"}}`)
 * to the UI — the SDK puts that JSON in `err.message` / `String(err)`, and it
 * renders as a broken-looking blob in the Examiner chat or a red full-screen
 * error. These are almost always transient upstream blips (429/500/529), so the
 * right user-facing message is "busy, try again", not a stack trace.
 *
 * Log the real error server-side (with request_id) before calling this so the
 * detail is still available for debugging.
 */
export function friendlyAIError(err: unknown): string {
  if (isUsageLimitError(err)) return AI_PAUSED_MESSAGE;
  // APIConnectionError is a subclass of APIError in the TS SDK and has no
  // `status`, so check it first.
  if (err instanceof Anthropic.APIConnectionError) {
    return "เชื่อมต่อระบบ AI ไม่ได้ กรุณาตรวจสอบอินเทอร์เน็ตแล้วลองใหม่อีกครั้งนะคะ";
  }
  if (err instanceof Anthropic.APIError) {
    const status = err.status;
    if (status === 429) {
      return "ระบบ AI มีผู้ใช้งานพร้อมกันจำนวนมาก กรุณารอสักครู่แล้วลองใหม่อีกครั้งนะคะ";
    }
    if (status === 529) {
      return "ระบบ AI กำลังมีผู้ใช้งานหนาแน่นชั่วคราว กรุณารอสักครู่แล้วลองใหม่อีกครั้งนะคะ";
    }
    if (typeof status === "number" && status >= 500) {
      return "ระบบ AI ขัดข้องชั่วคราว กรุณาลองใหม่อีกครั้งนะคะ";
    }
  }
  return "ขออภัย ระบบขัดข้องชั่วคราว กรุณาลองใหม่อีกครั้งนะคะ";
}
