import { describe, it, expect, afterEach } from "vitest";
import { liffDeepLink, toLiffUri } from "./line-links";

const ORIGINAL_LIFF_ID = process.env.NEXT_PUBLIC_LIFF_ID;
const ORIGINAL_SITE_URL = process.env.NEXT_PUBLIC_SITE_URL;

function restoreEnv() {
  if (ORIGINAL_LIFF_ID === undefined) delete process.env.NEXT_PUBLIC_LIFF_ID;
  else process.env.NEXT_PUBLIC_LIFF_ID = ORIGINAL_LIFF_ID;
  if (ORIGINAL_SITE_URL === undefined) delete process.env.NEXT_PUBLIC_SITE_URL;
  else process.env.NEXT_PUBLIC_SITE_URL = ORIGINAL_SITE_URL;
}

afterEach(restoreEnv);

describe("liffDeepLink", () => {
  it("returns a liff.line.me URL for the path when NEXT_PUBLIC_LIFF_ID is set", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = "2010009663-BMDYoMQk";
    expect(liffDeepLink("/line/liff")).toBe("https://liff.line.me/2010009663-BMDYoMQk/line/liff");
  });

  it("falls back to a plain site URL when NEXT_PUBLIC_LIFF_ID is unset", () => {
    delete process.env.NEXT_PUBLIC_LIFF_ID;
    process.env.NEXT_PUBLIC_SITE_URL = "https://www.morroo.com";
    expect(liffDeepLink("/line/liff")).toBe("https://www.morroo.com/line/liff");
  });
});

describe("toLiffUri", () => {
  it("rewrites a morroo.com URL to a LIFF deep link, preserving path and query", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = "2010009663-BMDYoMQk";
    const input = "https://www.morroo.com/nl/practice?q=abc-123&utm_source=line&utm_medium=daily_mcq";
    expect(toLiffUri(input)).toBe(
      "https://liff.line.me/2010009663-BMDYoMQk/nl/practice?q=abc-123&utm_source=line&utm_medium=daily_mcq"
    );
  });

  it("rewrites the apex domain (morroo.com, no www) too", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = "2010009663-BMDYoMQk";
    expect(toLiffUri("https://morroo.com/pricing")).toBe(
      "https://liff.line.me/2010009663-BMDYoMQk/pricing"
    );
  });

  it("passes a URL through unchanged when NEXT_PUBLIC_LIFF_ID is unset", () => {
    delete process.env.NEXT_PUBLIC_LIFF_ID;
    const input = "https://www.morroo.com/dashboard";
    expect(toLiffUri(input)).toBe(input);
  });

  it("never rewrites a non-morroo URL, even with a LIFF ID configured", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = "2010009663-BMDYoMQk";
    const input = "https://www.facebook.com/morroo/posts/123";
    expect(toLiffUri(input)).toBe(input);
  });

  it("passes through an unparseable string unchanged instead of throwing", () => {
    process.env.NEXT_PUBLIC_LIFF_ID = "2010009663-BMDYoMQk";
    expect(toLiffUri("not a url")).toBe("not a url");
  });
});
