import { describe, it, expect, vi, afterEach } from "vitest";
import { verifyLineIdToken } from "./line-id-token";

interface FakeResponse {
  ok: boolean;
  status?: number;
  json: () => Promise<unknown>;
  text: () => Promise<string>;
}

function lineOk(body: unknown): FakeResponse {
  return { ok: true, json: async () => body, text: async () => "" };
}

function lineFail(status: number, body = ""): FakeResponse {
  return { ok: false, status, json: async () => ({}), text: async () => body };
}

afterEach(() => {
  vi.unstubAllGlobals();
});

describe("verifyLineIdToken", () => {
  it("returns sub + email when the token verifies and the audience matches", async () => {
    const fetchSpy = vi.fn().mockResolvedValue(
      lineOk({ sub: "U123", aud: "channel-1", email: "doc@example.com" })
    );
    vi.stubGlobal("fetch", fetchSpy);

    const result = await verifyLineIdToken("tok", "channel-1");

    expect(result).toEqual({ sub: "U123", email: "doc@example.com" });
    expect(fetchSpy).toHaveBeenCalledWith(
      "https://api.line.me/oauth2/v2.1/verify",
      expect.objectContaining({ method: "POST" })
    );
  });

  it("returns email:null when the token has no email claim (email scope not granted)", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(lineOk({ sub: "U123", aud: "channel-1" })));

    const result = await verifyLineIdToken("tok", "channel-1");

    expect(result).toEqual({ sub: "U123", email: null });
  });

  it("rejects a token whose audience doesn't match our channel", async () => {
    vi.stubGlobal(
      "fetch",
      vi.fn().mockResolvedValue(lineOk({ sub: "U123", aud: "some-other-channel" }))
    );

    const result = await verifyLineIdToken("tok", "channel-1");

    expect(result).toBeNull();
  });

  it("rejects when LINE's verify endpoint returns a non-2xx status", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(lineFail(400, "invalid_request")));

    const result = await verifyLineIdToken("bad-token", "channel-1");

    expect(result).toBeNull();
  });

  it("rejects when the response has no sub claim", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue(lineOk({ aud: "channel-1" })));

    const result = await verifyLineIdToken("tok", "channel-1");

    expect(result).toBeNull();
  });
});
