import { describe, it, expect, vi, afterEach } from "vitest";
import {
  getPushSupport,
  isIOS,
  unsubscribePushOnLogout,
  urlBase64ToUint8Array,
  type PushEnv,
} from "./push-client";

const IPHONE_SAFARI =
  "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1";
const IPAD_DESKTOP_UA =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15";
const ANDROID_CHROME =
  "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Mobile Safari/537.36";
const FB_IAB = `${ANDROID_CHROME} [FB_IAB/FB4A;FBAV/450.0.0.0;]`;

function env(over: Partial<PushEnv>): PushEnv {
  return {
    userAgent: ANDROID_CHROME,
    standalone: false,
    hasServiceWorker: true,
    hasPushManager: true,
    hasNotification: true,
    maxTouchPoints: 0,
    ...over,
  };
}

describe("isIOS", () => {
  it("detects iPhone and touch Macs (iPadOS)", () => {
    expect(isIOS(IPHONE_SAFARI)).toBe(true);
    expect(isIOS(IPAD_DESKTOP_UA, 5)).toBe(true);
    expect(isIOS(IPAD_DESKTOP_UA, 0)).toBe(false);
    expect(isIOS(ANDROID_CHROME)).toBe(false);
  });
});

describe("getPushSupport", () => {
  it("supports Android Chrome with the APIs present", () => {
    expect(getPushSupport(env({}))).toEqual({ kind: "supported" });
  });

  it("flags in-app browsers before anything else", () => {
    expect(getPushSupport(env({ userAgent: FB_IAB }))).toEqual({ kind: "in_app", app: "facebook" });
    expect(getPushSupport(env({ userAgent: `${IPHONE_SAFARI} Line/13.5.0` }))).toEqual({
      kind: "in_app",
      app: "line",
    });
  });

  it("asks iOS Safari tabs to install to the home screen first", () => {
    expect(getPushSupport(env({ userAgent: IPHONE_SAFARI, hasPushManager: false }))).toEqual({
      kind: "ios_needs_install",
    });
    expect(getPushSupport(env({ userAgent: IPAD_DESKTOP_UA, maxTouchPoints: 5 }))).toEqual({
      kind: "ios_needs_install",
    });
  });

  it("supports an installed iOS web app with the APIs present", () => {
    expect(getPushSupport(env({ userAgent: IPHONE_SAFARI, standalone: true }))).toEqual({
      kind: "supported",
    });
  });

  it("reports unsupported when the Push API is missing (e.g. installed on iOS < 16.4)", () => {
    expect(
      getPushSupport(env({ userAgent: IPHONE_SAFARI, standalone: true, hasPushManager: false }))
    ).toEqual({ kind: "unsupported" });
    expect(getPushSupport(env({ hasServiceWorker: false }))).toEqual({ kind: "unsupported" });
  });
});

describe("urlBase64ToUint8Array", () => {
  it("decodes base64url without padding", () => {
    // "hello?" → base64 "aGVsbG8/" → base64url "aGVsbG8_"
    expect(Array.from(urlBase64ToUint8Array("aGVsbG8_"))).toEqual(
      Array.from(Buffer.from("hello?"))
    );
    // "hi" → "aGk=" → unpadded "aGk"
    expect(Array.from(urlBase64ToUint8Array("aGk"))).toEqual([104, 105]);
  });
});

describe("unsubscribePushOnLogout", () => {
  afterEach(() => {
    vi.unstubAllGlobals();
  });

  function stubBrowser(sub: { endpoint: string; unsubscribe: () => Promise<boolean> } | null) {
    const fetchMock = vi.fn().mockResolvedValue(new Response("{}"));
    vi.stubGlobal("fetch", fetchMock);
    vi.stubGlobal("navigator", {
      serviceWorker: {
        getRegistration: async () => ({ pushManager: { getSubscription: async () => sub } }),
      },
    });
    return fetchMock;
  }

  it("deletes the server row and unsubscribes the browser", async () => {
    const unsubscribe = vi.fn().mockResolvedValue(true);
    const fetchMock = stubBrowser({ endpoint: "https://fcm.googleapis.com/fcm/send/x", unsubscribe });
    await unsubscribePushOnLogout();
    expect(fetchMock).toHaveBeenCalledWith(
      "/api/push/subscribe",
      expect.objectContaining({
        method: "DELETE",
        body: JSON.stringify({ endpoint: "https://fcm.googleapis.com/fcm/send/x" }),
      })
    );
    expect(unsubscribe).toHaveBeenCalled();
  });

  it("does nothing without a subscription and never throws", async () => {
    const fetchMock = stubBrowser(null);
    await unsubscribePushOnLogout();
    expect(fetchMock).not.toHaveBeenCalled();

    vi.stubGlobal("navigator", {
      serviceWorker: { getRegistration: () => Promise.reject(new Error("boom")) },
    });
    await expect(unsubscribePushOnLogout()).resolves.toBeUndefined();
  });
});
