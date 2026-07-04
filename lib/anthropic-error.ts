import Anthropic from "@anthropic-ai/sdk";
import * as Sentry from "@sentry/nextjs";

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
