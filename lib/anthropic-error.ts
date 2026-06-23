import Anthropic from "@anthropic-ai/sdk";

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
