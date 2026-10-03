import { describe, expect, it } from "vitest";
import { FEED_SOURCES, parseRss, stripHtml } from "./exam-news-feed";

const RSS = `<?xml version="1.0"?><rss><channel>
<item>
  <title><![CDATA[ศรว. ประกาศกำหนดการสอบ &amp; รับสมัคร]]></title>
  <link>https://news.google.com/rss/articles/abc?oc=5</link>
  <guid isPermaLink="false">abc</guid>
  <pubDate>Fri, 03 Oct 2025 03:00:00 GMT</pubDate>
  <description>&lt;a href="x"&gt;ศรว.&lt;/a&gt; เปิดรับสมัคร &amp;nbsp;OSCE</description>
  <source url="https://example.org">Thai PBS</source>
</item>
<item>
  <title>ไม่มีลิงก์</title>
  <link>javascript:alert(1)</link>
</item>
<item>
  <title>ลิงก์ไม่ปลอดภัย</title>
  <link>ftp://x.test/a</link>
</item>
<item>
  <title>ไม่มีวันที่</title>
  <link>https://example.org/a</link>
  <description>รายละเอียด</description>
</item>
</channel></rss>`;

describe("parseRss", () => {
  const items = parseRss(RSS);

  it("parses items, decodes CDATA/entities and the publisher", () => {
    expect(items).toHaveLength(2);
    expect(items[0]).toMatchObject({
      title: "ศรว. ประกาศกำหนดการสอบ & รับสมัคร",
      link: "https://news.google.com/rss/articles/abc?oc=5",
      guid: "abc",
      sourceName: "Thai PBS",
      pubDate: "2025-10-03T03:00:00.000Z",
    });
    expect(items[0].description).toBe("ศรว. เปิดรับสมัคร OSCE");
  });

  it("drops items whose link is not http(s) (feed data is untrusted)", () => {
    expect(items.map((i) => i.link)).toEqual([
      "https://news.google.com/rss/articles/abc?oc=5",
      "https://example.org/a",
    ]);
  });

  it("falls back to the link as guid and null date/publisher", () => {
    expect(items[1]).toMatchObject({ guid: "https://example.org/a", pubDate: null, sourceName: null });
  });

  it("returns nothing for empty or non-RSS input", () => {
    expect(parseRss("")).toEqual([]);
    expect(parseRss("<html>not a feed</html>")).toEqual([]);
  });
});

describe("stripHtml", () => {
  it("removes tags and double-encoded entities", () => {
    expect(stripHtml("&lt;p&gt;a&nbsp;&amp;amp; b&lt;/p&gt;")).toBe("a & b");
  });
});

describe("FEED_SOURCES", () => {
  it("has unique ids and https Thai-locale Google News urls", () => {
    expect(new Set(FEED_SOURCES.map((s) => s.id)).size).toBe(FEED_SOURCES.length);
    for (const s of FEED_SOURCES) {
      expect(s.url).toMatch(/^https:\/\/news\.google\.com\/rss\/search\?q=/);
      expect(s.url).toContain("hl=th&gl=TH&ceid=TH:th");
    }
  });
});
