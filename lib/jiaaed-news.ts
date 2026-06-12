import type { NewsItem } from "@/lib/news";

// ฟีดข่าวสาธารณะจาก jiaaed.com (โปรเจกต์ JiaAED ในเครือเดียวกัน)
// ทุก item ต้องลิงก์กลับไปข่าวต้นฉบับ (source_url) เพราะลิขสิทธิ์เป็นของสำนักข่าวเดิม
const FEED_URL = "https://jiaaed.com/api/news/public";

interface JiaAedFeedItem {
  our_blurb: string;
  source_title: string;
  source_url: string;
  source_name: string;
  topic: string | null;
  published_at: string;
}

export async function getJiaAedNews(limit = 30): Promise<NewsItem[]> {
  try {
    const res = await fetch(`${FEED_URL}?limit=${limit}`, {
      next: { revalidate: 300 },
    });
    if (!res.ok) return [];
    const data = (await res.json()) as { items?: JiaAedFeedItem[] };
    if (!Array.isArray(data.items)) return [];
    return data.items.map((item, i) => ({
      id: `jiaaed-${i}`,
      sourceType: "external_health",
      sourceSection: null,
      title: item.source_title,
      summary: item.source_name
        ? `${item.our_blurb} — ${item.source_name}`
        : item.our_blurb,
      body: null,
      link: item.source_url,
      coverImage: null,
      publishedAt: item.published_at,
      pinned: false,
    }));
  } catch {
    return [];
  }
}
