import { describe, it, expect } from "vitest";
import { buildFbCaption, buildIgCaption } from "./autopost-copy";

// Regression guard for the LIFF rollout (lib/line-links.ts): FB/IG captions
// must always carry a plain, clickable morroo.com URL. A liff.line.me link
// opened outside the LINE app bounces through LINE Login's web flow first,
// which is wrong for a social caption meant to open directly — see the
// "LINE-only" warning at the top of lib/line-links.ts.
describe("buildFbCaption / buildIgCaption never emit a LIFF URL", () => {
  const parts = {
    hook: "หัวข้อทดสอบ",
    subline: "รายละเอียดทดสอบ",
    bullets: ["ข้อ 1", "ข้อ 2", "ข้อ 3"],
  };

  it("buildFbCaption's articleUrl passes through unchanged, never rewritten to LIFF", () => {
    const caption = buildFbCaption({
      ...parts,
      articleUrl: "https://www.morroo.com/blog/some-article",
      hashtags: "#หมอรู้",
    });
    expect(caption).toContain("www.morroo.com/blog/some-article");
    expect(caption).not.toContain("liff.line.me");
  });

  it("buildIgCaption's siteHost passes through unchanged, never rewritten to LIFF", () => {
    const caption = buildIgCaption({
      ...parts,
      siteHost: "www.morroo.com",
      hashtags: "#หมอรู้",
    });
    expect(caption).toContain("www.morroo.com");
    expect(caption).not.toContain("liff.line.me");
  });
});
