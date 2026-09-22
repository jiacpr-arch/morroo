import { describe, it, expect, vi, afterEach, beforeEach } from "vitest";
import {
  computeLineQuotaStatus,
  LINE_QUOTA_RESERVE_MIN,
  LINE_QUOTA_RESERVE_FRACTION,
  replyLineMessage,
  replyOrPushLineMessage,
} from "./line";

describe("computeLineQuotaStatus", () => {
  it("never throttles when the plan is unlimited (limit === null)", () => {
    const status = computeLineQuotaStatus(null, 999_999);
    expect(status).toEqual({ limit: null, used: 999_999, remaining: null, throttled: false });
  });

  it("never throttles when usage is unknown (used === null)", () => {
    const status = computeLineQuotaStatus(1000, null);
    expect(status.throttled).toBe(false);
    expect(status.remaining).toBeNull();
  });

  it("does not throttle with plenty of headroom", () => {
    const status = computeLineQuotaStatus(15000, 1000);
    expect(status.remaining).toBe(14000);
    expect(status.throttled).toBe(false);
  });

  it("throttles once remaining drops to the reserve (fraction-based on a large plan)", () => {
    const limit = 15000;
    const reserve = Math.max(LINE_QUOTA_RESERVE_MIN, Math.ceil(limit * LINE_QUOTA_RESERVE_FRACTION));
    expect(reserve).toBe(750); // 5% of 15000

    const justAboveReserve = computeLineQuotaStatus(limit, limit - reserve - 1);
    expect(justAboveReserve.throttled).toBe(false);

    const atReserve = computeLineQuotaStatus(limit, limit - reserve);
    expect(atReserve.throttled).toBe(true);
  });

  it("throttles using the flat minimum reserve on a small plan", () => {
    const limit = 1000; // 5% would be 50, less than the 300 floor
    const reserve = Math.max(LINE_QUOTA_RESERVE_MIN, Math.ceil(limit * LINE_QUOTA_RESERVE_FRACTION));
    expect(reserve).toBe(LINE_QUOTA_RESERVE_MIN);

    const status = computeLineQuotaStatus(limit, limit - LINE_QUOTA_RESERVE_MIN);
    expect(status.throttled).toBe(true);
  });

  it("throttles when quota is fully exhausted", () => {
    const status = computeLineQuotaStatus(15000, 15000);
    expect(status.remaining).toBe(0);
    expect(status.throttled).toBe(true);
  });
});

interface FakeResponse {
  ok: boolean;
  status?: number;
  json: () => Promise<unknown>;
  text: () => Promise<string>;
}

function lineOk(): FakeResponse {
  return { ok: true, json: async () => ({}), text: async () => "" };
}

function lineFail(status: number, body = ""): FakeResponse {
  return { ok: false, status, json: async () => ({}), text: async () => body };
}

const ORIGINAL_TOKEN = process.env.LINE_CHANNEL_ACCESS_TOKEN;

beforeEach(() => {
  process.env.LINE_CHANNEL_ACCESS_TOKEN = "test-token";
});

afterEach(() => {
  vi.unstubAllGlobals();
  if (ORIGINAL_TOKEN === undefined) delete process.env.LINE_CHANNEL_ACCESS_TOKEN;
  else process.env.LINE_CHANNEL_ACCESS_TOKEN = ORIGINAL_TOKEN;
});

describe("replyLineMessage", () => {
  it("posts to the reply endpoint with the token and messages, and returns true on success", async () => {
    const fetchSpy = vi.fn().mockResolvedValue(lineOk());
    vi.stubGlobal("fetch", fetchSpy);

    const ok = await replyLineMessage("tok_123", [{ type: "text", text: "hi" }]);

    expect(ok).toBe(true);
    expect(fetchSpy).toHaveBeenCalledTimes(1);
    const [url, init] = fetchSpy.mock.calls[0];
    expect(url).toBe("https://api.line.me/v2/bot/message/reply");
    expect(JSON.parse(init.body)).toEqual({
      replyToken: "tok_123",
      messages: [{ type: "text", text: "hi" }],
    });
  });

  it("returns false when the reply token is invalid or expired", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(lineFail(400, "invalid reply token")));

    const ok = await replyLineMessage("stale_tok", [{ type: "text", text: "hi" }]);

    expect(ok).toBe(false);
  });

  it("returns false without calling fetch when no channel access token is configured", async () => {
    delete process.env.LINE_CHANNEL_ACCESS_TOKEN;
    const fetchSpy = vi.fn();
    vi.stubGlobal("fetch", fetchSpy);

    const ok = await replyLineMessage("tok_123", [{ type: "text", text: "hi" }]);

    expect(ok).toBe(false);
    expect(fetchSpy).not.toHaveBeenCalled();
  });
});

describe("replyOrPushLineMessage", () => {
  it("replies only, and never touches the push endpoint, when the reply succeeds", async () => {
    const fetchSpy = vi.fn().mockResolvedValue(lineOk());
    vi.stubGlobal("fetch", fetchSpy);

    const ok = await replyOrPushLineMessage("U123", "tok_123", [{ type: "text", text: "hi" }]);

    expect(ok).toBe(true);
    expect(fetchSpy).toHaveBeenCalledTimes(1);
    expect(fetchSpy.mock.calls[0][0]).toBe("https://api.line.me/v2/bot/message/reply");
  });

  it("goes straight to push when there's no reply token", async () => {
    const fetchSpy = vi.fn().mockResolvedValue(lineOk());
    vi.stubGlobal("fetch", fetchSpy);

    const ok = await replyOrPushLineMessage("U123", undefined, [{ type: "text", text: "hi" }]);

    expect(ok).toBe(true);
    expect(fetchSpy).toHaveBeenCalledTimes(1);
    expect(fetchSpy.mock.calls[0][0]).toBe("https://api.line.me/v2/bot/message/push");
  });

  it("falls back to push when the reply fails (e.g. an expired token from a slow handler)", async () => {
    const fetchSpy = vi
      .fn()
      .mockResolvedValueOnce(lineFail(400, "invalid reply token"))
      .mockResolvedValueOnce(lineOk());
    vi.stubGlobal("fetch", fetchSpy);

    const ok = await replyOrPushLineMessage("U123", "stale_tok", [{ type: "text", text: "hi" }]);

    expect(ok).toBe(true);
    expect(fetchSpy).toHaveBeenCalledTimes(2);
    expect(fetchSpy.mock.calls[0][0]).toBe("https://api.line.me/v2/bot/message/reply");
    expect(fetchSpy.mock.calls[1][0]).toBe("https://api.line.me/v2/bot/message/push");
  });
});
