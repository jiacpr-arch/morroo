import { afterEach, describe, expect, it, vi } from "vitest";
import { trackVerifiedPurchase } from "./verified-purchase";
import { trackPurchase } from "./conversions";

afterEach(() => vi.unstubAllGlobals());

function setup(blockStorage = false) {
  const saved = new Map<string, string>();
  const gtag = vi.fn();
  const fbq = vi.fn();
  const fakeWindow = {
    gtag, fbq,
    sessionStorage: {
      getItem: (key: string) => { if (blockStorage) throw Error("blocked"); return saved.get(key) ?? null; },
      setItem: (key: string, value: string) => { if (blockStorage) throw Error("blocked"); saved.set(key, value); },
    },
  };
  vi.stubGlobal("window", fakeWindow);
  return { gtag, fbq, saved };
}

describe("verified Google purchase", () => {
  it("does not record pending, failed or malformed responses", () => {
    const { gtag } = setup();
    for (const status of ["pending", "error", undefined]) {
      expect(trackVerifiedPurchase("unpaid", { status, amount: 100, currency: "THB" })).toBe(false);
    }
    for (const amount of [NaN, Infinity, -1]) {
      expect(trackVerifiedPurchase("bad-amount", { status: "ok", amount, currency: "THB" })).toBe(false);
    }
    expect(gtag).not.toHaveBeenCalled();
  });
  it("sends a paid order once with value, currency and stable transaction ID", () => {
    const { gtag, saved } = setup();
    const data = { status: "ok", amount: 299, currency: "THB" };
    expect(trackVerifiedPurchase("paid-once", data)).toBe(true);
    expect(trackVerifiedPurchase("paid-once", data)).toBe(false);
    expect(gtag).toHaveBeenCalledExactlyOnceWith("event", "purchase", {
      transaction_id: "paid-once", value: 299, currency: "THB",
    });
    expect(saved.get("purchase_tracked:paid-once")).toBe("1");
  });
  it("respects a persisted purchase marker", () => {
    const { gtag, saved } = setup();
    saved.set("purchase_tracked:previous-load", "1");
    expect(trackVerifiedPurchase("previous-load", { status: "ok", amount: 299, currency: "THB" })).toBe(false);
    expect(gtag).not.toHaveBeenCalled();
  });
  it("does not break payment success when browser storage is blocked", () => {
    const { gtag } = setup(true);
    expect(trackVerifiedPurchase("blocked-storage", { status: "ok", amount: 299, currency: "THB" })).toBe(true);
    expect(trackVerifiedPurchase("blocked-storage", { status: "ok", amount: 299, currency: "THB" })).toBe(false);
    expect(gtag).toHaveBeenCalledTimes(1);
  });
  it("queues a Google event if the tag has not initialized", () => {
    const fakeWindow: { dataLayer?: Array<IArguments> } = {};
    vi.stubGlobal("window", fakeWindow);
    trackPurchase({ transactionId: "queued", value: 299, currency: "THB" });
    expect(Array.from(fakeWindow.dataLayer![0])).toEqual([
      "event", "purchase", { transaction_id: "queued", value: 299, currency: "THB" },
    ]);
  });
});
