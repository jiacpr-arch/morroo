import type { NewsItem } from "@/lib/news";

/**
 * ดึงข่าวกู้ชีพ/AED จาก JiaAED public news API (jiaaed.com)
 * ฝั่ง JiaAED cache ไว้ 5 นาที — ฝั่งเรา revalidate เท่ากัน
 * ลิขสิทธิ์ข่าวต้นฉบับเป็นของสำนักข่าวที่อ้างอิง ต้องคงลิงก์ source_url เสมอ
 */

const JIAAED_NEWS_API = "https://jiaaed.com/api/news/public";

interface JiaAedNewsRow {
  id: string;
  source_title: string;
  source_url: string;
  source_name: string | null;
  topic: string | null;
  our_blurb: string | null;
  published_at: string;
}

function mapRow(row: JiaAedNewsRow): NewsItem {
  const summary = [row.our_blurb, row.source_name ? `ที่มา: ${row.source_name}` : null]
    .filter(Boolean)
    .join(" — ");
  return {
    id: row.id,
    sourceType: "external_aed",
    sourceSection: null,
    title: row.source_title,
    summary,
    body: null,
    link: row.source_url,
    coverImage: null,
    publishedAt: row.published_at,
    pinned: false,
  };
}

export async function getJiaAedNewsItems(limit = 30): Promise<NewsItem[]> {
  try {
    const res = await fetch(`${JIAAED_NEWS_API}?limit=${limit}`, {
      next: { revalidate: 300 },
      signal: AbortSignal.timeout(8_000),
    });
    if (!res.ok) return [];
    const data = (await res.json()) as { ok?: boolean; items?: JiaAedNewsRow[] };
    if (!data.ok || !Array.isArray(data.items)) return [];
    return data.items.filter((row) => row.source_url).map(mapRow);
  } catch {
    return [];
  }
}
