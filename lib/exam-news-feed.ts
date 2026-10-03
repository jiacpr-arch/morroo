/**
 * แหล่งข่าว RSS + parser เล็กๆ ไม่พึ่ง dependency สำหรับ cron exam-news-fetch
 * (ทำแบบเดียวกับ roodee edu-news-feed — แต่แหล่งข่าวเป็นเรื่องสอบแพทย์)
 *
 * หน้าข่าวของ ศรว. (cmathai.org/news) ไม่มี RSS — cron exam-watch เฝ้าอยู่แล้วและแจ้งแอดมิน
 */

export interface FeedSource {
  id: string;
  url: string;
}

const gnews = (q: string) =>
  `https://news.google.com/rss/search?q=${encodeURIComponent(q)}&hl=th&gl=TH&ceid=TH:th`;

export const FEED_SOURCES: FeedSource[] = [
  { id: "gnews-nl", url: gnews('ศรว. OR "ใบประกอบวิชาชีพเวชกรรม" OR "สอบ NL" แพทย์ when:7d') },
  { id: "gnews-tmc", url: gnews("แพทยสภา สอบ OR ประกาศ OR กำหนดการ when:7d") },
  { id: "gnews-board", url: gnews('สอบวุฒิบัตร OR "แพทย์ประจำบ้าน" ราชวิทยาลัย สอบ when:7d') },
  {
    id: "gnews-intern",
    url: gnews('แพทย์เพิ่มพูนทักษะ OR "แพทย์ใช้ทุน" สอบ OR จับสลาก OR ประกาศ when:7d'),
  },
];

export interface FeedItem {
  guid: string;
  title: string;
  link: string;
  description: string;
  /** ชื่อสำนักข่าว (Google News ใส่ใน <source>) */
  sourceName: string | null;
  pubDate: string | null; // ISO
}

function decodeEntities(s: string): string {
  return s
    .replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1")
    .replace(/&#(\d+);/g, (_, n) => String.fromCharCode(Number(n)))
    .replace(/&#x([0-9a-f]+);/gi, (_, n) => String.fromCharCode(parseInt(n, 16)))
    .replace(/&quot;/g, '"')
    .replace(/&#39;|&apos;/g, "'")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&");
}

export function stripHtml(s: string): string {
  return decodeEntities(decodeEntities(s).replace(/<[^>]+>/g, " ")).replace(/\s+/g, " ").trim();
}

function tag(block: string, name: string): string {
  const m = block.match(new RegExp(`<${name}(?:\\s[^>]*)?>([\\s\\S]*?)</${name}>`, "i"));
  return m ? m[1] : "";
}

export function parseRss(xml: string): FeedItem[] {
  const items: FeedItem[] = [];
  for (const m of xml.matchAll(/<item[\s>][\s\S]*?<\/item>/gi)) {
    const block = m[0];
    const title = stripHtml(tag(block, "title"));
    const link = stripHtml(tag(block, "link"));
    // ลิงก์ต้องเป็น http(s) เท่านั้น — ข้อมูลจากฟีดเป็น untrusted
    if (!title || !/^https?:\/\//.test(link)) continue;
    const body = tag(block, "content:encoded") || tag(block, "description");
    const date = Date.parse(stripHtml(tag(block, "pubDate")));
    items.push({
      guid: stripHtml(tag(block, "guid")) || link,
      title,
      link,
      description: stripHtml(body).slice(0, 4000),
      sourceName: stripHtml(tag(block, "source")).slice(0, 100) || null,
      pubDate: Number.isNaN(date) ? null : new Date(date).toISOString(),
    });
  }
  return items;
}
