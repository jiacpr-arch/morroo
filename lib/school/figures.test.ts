import { describe, expect, it } from "vitest";
import {
  captionFromTitle,
  figureMarkdown,
  firstImageUrl,
  hasFigures,
} from "./figures";

describe("figureMarkdown", () => {
  it("writes alt + caption as a markdown image with a title", () => {
    expect(
      figureMarkdown("https://x/y.svg", { alt: "ระนาบร่างกาย", caption: "3 ระนาบ" })
    ).toBe('![ระนาบร่างกาย](https://x/y.svg "3 ระนาบ")');
  });

  it("omits the title when there is no caption", () => {
    expect(figureMarkdown("/a.png")).toBe("![](/a.png)");
    expect(figureMarkdown("/a.png", { alt: "x" })).toBe("![x](/a.png)");
  });

  it("neutralises characters that would break the syntax", () => {
    expect(
      figureMarkdown("/a.png", { alt: "a [b]", caption: 'say "hi"' })
    ).toBe('![a b](/a.png "say ”hi”")');
  });
});

describe("firstImageUrl / hasFigures", () => {
  it("finds the first image url, ignoring links", () => {
    const md = "intro [link](/x)\n\n![](/lesson-images/a.svg \"cap\")\n\n![b](/b.png)";
    expect(firstImageUrl(md)).toBe("/lesson-images/a.svg");
    expect(hasFigures(md)).toBe(true);
  });

  it("handles angle-bracketed urls and missing images", () => {
    expect(firstImageUrl("![](<https://x/a b.png>)")).toBe("https://x/a b.png");
    expect(firstImageUrl("no images here")).toBeNull();
    expect(hasFigures("")).toBe(false);
    expect(hasFigures(null)).toBe(false);
  });
});

describe("captionFromTitle", () => {
  it("strips an optional caption: prefix", () => {
    expect(captionFromTitle("caption: ดูลูกศร")).toBe("ดูลูกศร");
    expect(captionFromTitle("Caption:ดูลูกศร")).toBe("ดูลูกศร");
    expect(captionFromTitle("ดูลูกศร")).toBe("ดูลูกศร");
  });

  it("returns null for empty titles", () => {
    expect(captionFromTitle("")).toBeNull();
    expect(captionFromTitle("caption:   ")).toBeNull();
    expect(captionFromTitle(undefined)).toBeNull();
  });
});
