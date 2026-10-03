import { describe, it, expect } from "vitest";
import {
  extractAnnouncementLines,
  diffNewLines,
  buildAdminAlert,
} from "./exam-watch";

const SAMPLE_HTML = `
<html><head><title>ข่าว ศรว.</title>
<style>.x{color:red}</style>
<script>var a = "กำหนดการสอบ ปลอมใน script";</script>
</head><body>
<nav><a href="/">หน้าแรก</a><a href="/news">ข่าว</a></nav>
<h2><a href="/news/1">ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569</a></h2>
<h2><a href="/news/2">รับสมัครสอบขั้นตอนที่ 2 ครั้งที่ 3 (19 กรกฎาคม 2569)</a></h2>
<p>เนื้อหาทั่วไปที่ไม่เกี่ยวข้องกับการสอบเลยสักนิดเดียว ยาวพอสมควรแต่ไม่มีคีย์เวิร์ด</p>
<h2><a href="/news/3">ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569</a></h2>
</body></html>`;

describe("extractAnnouncementLines", () => {
  it("สกัดเฉพาะบรรทัดที่มีคีย์เวิร์ดเกี่ยวกับการสอบ ไม่เอา script/เมนู/เนื้อหาทั่วไป", () => {
    const lines = extractAnnouncementLines(SAMPLE_HTML);
    expect(lines).toContain("ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569");
    expect(lines).toContain(
      "รับสมัครสอบขั้นตอนที่ 2 ครั้งที่ 3 (19 กรกฎาคม 2569)"
    );
    expect(lines.join(" ")).not.toContain("ปลอมใน script");
    expect(lines).not.toContain("ข่าว");
  });

  it("บรรทัดซ้ำถูก dedupe", () => {
    const lines = extractAnnouncementLines(SAMPLE_HTML);
    const target = lines.filter(
      (l) => l === "ประกาศกำหนดการสอบขั้นตอนที่ 1 ประจำปี 2569"
    );
    expect(target).toHaveLength(1);
  });

  it("HTML ว่าง → ลิสต์ว่าง", () => {
    expect(extractAnnouncementLines("<html></html>")).toEqual([]);
  });
});

describe("diffNewLines", () => {
  it("คืนเฉพาะบรรทัดที่ไม่เคยเห็น", () => {
    expect(diffNewLines(["a ประกาศ"], ["a ประกาศ", "b วันสอบใหม่"])).toEqual([
      "b วันสอบใหม่",
    ]);
  });

  it("บรรทัดเก่าหายไปจากหน้า ไม่นับเป็นของใหม่", () => {
    expect(diffNewLines(["a", "b"], ["b"])).toEqual([]);
  });
});

describe("buildAdminAlert", () => {
  it("โชว์สูงสุด 6 บรรทัด + บอกจำนวนที่เหลือ", () => {
    const lines = Array.from({ length: 8 }, (_, i) => `ประกาศที่ ${i + 1}`);
    const msg = buildAdminAlert(lines);
    expect(msg).toContain("• ประกาศที่ 6");
    expect(msg).not.toContain("• ประกาศที่ 7");
    expect(msg).toContain("และอีก 2 รายการ");
    expect(msg).toContain("/admin/exam-dates");
  });
});

import {
  classifyCmaUrl,
  extractAnnouncementLinks,
  extractPdfLinks,
  htmlToText,
  isCmaHost,
} from "./exam-watch";

const LIST_HTML = `
<ul>
  <li><a href="/news/detail/971">ประกาศกำหนดการสอบส่วนที่ 1 ปี 2570</a></li>
  <li><a href="https://cmathai.org/news/detail/970?x=1#top"><span>รับสมัครสอบ OSCE รอบ 1/2570</span></a></li>
  <li><a href="/news/detail/969">เรื่องทั่วไปที่ไม่เกี่ยวกับอะไรเลย</a></li>
  <li><a href="/news/detail/971">ประกาศกำหนดการสอบส่วนที่ 1 ปี 2570</a></li>
  <li><a href="https://evil.example.com/news/detail/5">ประกาศสอบปลอม</a></li>
  <li><a href="http://cmathai.org/news/detail/6">ประกาศสอบ (http)</a></li>
  <li><a href="javascript:alert(1)">ประกาศสอบ js</a></li>
  <li><a href="/news_attach/att-1.pdf">ประกาศสอบ ไฟล์</a></li>
</ul>`;

describe("extractAnnouncementLinks", () => {
  const links = extractAnnouncementLinks(LIST_HTML);

  it("keeps exam-related detail links in page order, resolved and deduped", () => {
    expect(links.map((l) => l.url)).toEqual([
      "https://cmathai.org/news/detail/971",
      "https://cmathai.org/news/detail/970?x=1",
    ]);
    expect(links[1].text).toBe("รับสมัครสอบ OSCE รอบ 1/2570");
  });

  it("drops other hosts, plain http, javascript: and non-detail links", () => {
    const urls = links.map((l) => l.url).join(" ");
    expect(urls).not.toContain("evil.example.com");
    expect(urls).not.toContain("http://");
    expect(urls).not.toContain("javascript");
    expect(urls).not.toContain("news_attach");
  });

  it("respects the limit and returns [] for a page with no links", () => {
    expect(extractAnnouncementLinks(LIST_HTML, undefined, 1)).toHaveLength(1);
    expect(extractAnnouncementLinks("<html></html>")).toEqual([]);
  });
});

describe("extractPdfLinks / classifyCmaUrl / isCmaHost", () => {
  it("finds attachments under /news_attach on the allowed host only", () => {
    const html = `<a href="/news_attach/att-notice-21-7-25-000.pdf">ไฟล์</a>
      <a href="https://cmathai.org/news_attach/b.PDF">b</a>
      <a href="https://other.org/news_attach/c.pdf">c</a>
      <a href="/files/d.pdf">d</a>`;
    expect(extractPdfLinks(html)).toEqual([
      "https://cmathai.org/news_attach/att-notice-21-7-25-000.pdf",
      "https://cmathai.org/news_attach/b.PDF",
    ]);
  });

  it("classifies and rejects urls", () => {
    expect(classifyCmaUrl("/news/detail/1")?.kind).toBe("detail");
    expect(classifyCmaUrl("https://www.cmathai.org/news_attach/x.pdf")?.kind).toBe("pdf");
    expect(classifyCmaUrl("https://cmathai.org.evil.com/news/detail/1")).toBeNull();
    expect(classifyCmaUrl("https://user:pw@cmathai.org/news/detail/1")).toBeNull();
    expect(classifyCmaUrl("https://cmathai.org/news/detail/abc")).toBeNull();
    expect(classifyCmaUrl("not a url at all %%%", "notbase")).toBeNull();
  });

  it("checks the post-redirect host", () => {
    expect(isCmaHost("https://cmathai.org/x")).toBe(true);
    expect(isCmaHost("https://evil.com/x")).toBe(false);
    expect(isCmaHost("http://cmathai.org/x")).toBe(false);
    expect(isCmaHost("zzz")).toBe(false);
  });
});

describe("htmlToText", () => {
  it("strips scripts, styles, tags and keeps line structure", () => {
    const text = htmlToText(
      "<style>.a{}</style><script>x=1</script><h1>ประกาศ</h1><p>สอบ วันเสาร์ที่ 10 ตุลาคม 2569</p><p>&nbsp;เวลา 09.00 น.</p>"
    );
    expect(text).toContain("ประกาศ");
    expect(text).toContain("สอบ วันเสาร์ที่ 10 ตุลาคม 2569");
    expect(text).not.toContain("x=1");
    expect(text).not.toContain(".a{}");
    expect(text).not.toContain("<");
  });
});
