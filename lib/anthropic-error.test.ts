import { describe, expect, it } from "vitest";
import Anthropic from "@anthropic-ai/sdk";
import {
  AI_PAUSED_MESSAGE,
  buildUsageLimitAlertText,
  friendlyAIError,
  isUsageLimitError,
  usageLimitResetAt,
} from "./anthropic-error";

// Exactly what the SDK surfaced on 2026-09-28 (logged in _ai_grade_errors).
const USAGE_LIMIT_MSG =
  '400 {"type":"error","error":{"type":"invalid_request_error","message":"You have reached your specified API usage limits. You will regain access on 2026-10-01 at 00:00 UTC."},"request_id":"req_011CfVX34iWu9mWNdtzbbnsv"}';

describe("isUsageLimitError", () => {
  it("matches the spend-limit error", () => {
    expect(isUsageLimitError(new Error(USAGE_LIMIT_MSG))).toBe(true);
  });

  it("matches the out-of-credit error", () => {
    expect(
      isUsageLimitError(new Error("Your credit balance is too low to access the Anthropic API."))
    ).toBe(true);
  });

  it("ignores transient and unrelated errors", () => {
    expect(isUsageLimitError(new Error("529 Overloaded"))).toBe(false);
    expect(isUsageLimitError(new Error("400 max_tokens: too large"))).toBe(false);
    expect(isUsageLimitError(null)).toBe(false);
  });
});

describe("usageLimitResetAt", () => {
  it("extracts the reset time", () => {
    expect(usageLimitResetAt(new Error(USAGE_LIMIT_MSG))).toBe("2026-10-01 at 00:00 UTC");
  });

  it("returns null when the message has no reset time", () => {
    expect(usageLimitResetAt(new Error("credit balance is too low"))).toBeNull();
  });
});

describe("buildUsageLimitAlertText", () => {
  it("names the call site, reset time and where to raise the limit", () => {
    const text = buildUsageLimitAlertText("grade", new Error(USAGE_LIMIT_MSG));
    expect(text).toContain("grade");
    expect(text).toContain("2026-10-01 at 00:00 UTC");
    expect(text).toContain("console.anthropic.com/settings/limits");
  });
});

describe("friendlyAIError", () => {
  it("tells users AI is paused instead of asking them to retry", () => {
    expect(friendlyAIError(new Error(USAGE_LIMIT_MSG))).toBe(AI_PAUSED_MESSAGE);
  });

  it("keeps the retry message for rate limits", () => {
    const err = new Anthropic.RateLimitError(429, undefined, "rate limited", new Headers());
    expect(friendlyAIError(err)).toContain("ลองใหม่");
  });
});
