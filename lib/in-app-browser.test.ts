import { describe, expect, it } from "vitest";
import { detectInAppBrowserFromUA } from "./in-app-browser";

const SAFARI_IOS =
  "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1";
const CHROME_ANDROID =
  "Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Mobile Safari/537.36";
const FB_IAB_IOS = `${SAFARI_IOS} [FBAN/FBIOS;FBAV/450.0.0.0]`;
const FB_IAB_ANDROID = `${CHROME_ANDROID} [FB_IAB/FB4A;FBAV/450.0.0.0]`;
const IG_IAB = `${SAFARI_IOS} Instagram 300.0.0.0`;
const LINE_IAB = `${SAFARI_IOS} Line/13.5.0`;

describe("detectInAppBrowserFromUA", () => {
  it("detects Facebook's in-app browser on iOS and Android", () => {
    expect(detectInAppBrowserFromUA(FB_IAB_IOS)).toBe("facebook");
    expect(detectInAppBrowserFromUA(FB_IAB_ANDROID)).toBe("facebook");
  });

  it("detects Instagram's in-app browser", () => {
    expect(detectInAppBrowserFromUA(IG_IAB)).toBe("instagram");
  });

  it("detects LINE's in-app browser via the version-qualified token", () => {
    expect(detectInAppBrowserFromUA(LINE_IAB)).toBe("line");
  });

  it("returns null for regular browsers", () => {
    expect(detectInAppBrowserFromUA(SAFARI_IOS)).toBeNull();
    expect(detectInAppBrowserFromUA(CHROME_ANDROID)).toBeNull();
  });

  it("does not false-positive on an airline app UA containing 'line/<version>'", () => {
    // regression: "Airline/2.0" contains the substring "line/2.0" right where the
    // pattern looks, but there is no word boundary before it (it's mid-word) —
    // only a standalone "Line/<version>" token (LINE's real UA marker) must match
    expect(detectInAppBrowserFromUA(`${SAFARI_IOS} SomeAirline/2.0`)).toBeNull();
  });
});
