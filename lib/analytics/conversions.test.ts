import { afterEach, describe, expect, it, vi } from "vitest";
import { trackLineLead, trackPricingViewContent } from "./conversions";

afterEach(() => vi.unstubAllGlobals());

function setup() {
  const fbq = vi.fn();
  const ttq = { track: vi.fn() };
  const gtag = vi.fn();
  vi.stubGlobal("window", { fbq, ttq, gtag });
  return { fbq, ttq, gtag };
}

describe("trackPricingViewContent", () => {
  it("fires a pixel ViewContent tagged with the pricing surface", () => {
    const { fbq, ttq } = setup();
    trackPricingViewContent("home");
    expect(fbq).toHaveBeenCalledExactlyOnceWith("track", "ViewContent", {
      content_name: "pricing",
      content_type: "pricing",
      content_ids: ["home"],
    });
    expect(ttq.track).toHaveBeenCalledExactlyOnceWith("ViewContent", {
      content_name: "pricing",
      content_type: "pricing",
      content_id: "home",
    });
  });

  it("never throws when fbq is missing (ad blocker)", () => {
    vi.stubGlobal("window", {});
    expect(() => trackPricingViewContent("home")).not.toThrow();
  });
});

describe("trackLineLead", () => {
  it("fires a pixel Lead without an eventID (no server CAPI pair to dedupe against)", () => {
    const { fbq, ttq, gtag } = setup();
    trackLineLead("casegame_debrief");
    // exactly 3 args — no eventID options object, unlike trackLead()
    expect(fbq).toHaveBeenCalledExactlyOnceWith("track", "Lead", {
      content_name: "line_oa",
      content_category: "casegame_debrief",
    });
    expect(ttq.track).toHaveBeenCalledExactlyOnceWith("ClickButton", {
      content_name: "line_oa",
      content_id: "casegame_debrief",
    });
    // must not inflate Google Ads lead conversions
    expect(gtag).not.toHaveBeenCalled();
  });

  it("never throws when fbq is missing (ad blocker)", () => {
    vi.stubGlobal("window", {});
    expect(() => trackLineLead("floating")).not.toThrow();
  });
});
