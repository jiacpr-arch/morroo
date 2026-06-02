import { createAdminClient } from "@/lib/supabase/admin";

export type NewsSourceType =
  | "product_update"
  | "blog"
  | "exam"
  | "external_health";

export type NewsSection =
  | "exams"
  | "school"
  | "longcase"
  | "acls"
  | "nl"
  | "blog";

export interface NewsItem {
  id: string;
  sourceType: NewsSourceType;
  sourceSection: NewsSection | null;
  title: string;
  summary: string;
  body: string | null;
  link: string | null;
  coverImage: string | null;
  publishedAt: string;
  pinned: boolean;
}

interface NewsRow {
  id: string;
  source_type: NewsSourceType;
  source_section: NewsSection | null;
  title: string;
  summary: string;
  body: string | null;
  link: string | null;
  cover_image: string | null;
  published_at: string;
  pinned: boolean;
}

function mapRow(row: NewsRow): NewsItem {
  return {
    id: row.id,
    sourceType: row.source_type,
    sourceSection: row.source_section,
    title: row.title,
    summary: row.summary,
    body: row.body,
    link: row.link,
    coverImage: row.cover_image,
    publishedAt: row.published_at,
    pinned: row.pinned,
  };
}

export interface NewsQueryOptions {
  sourceType?: NewsSourceType;
  section?: NewsSection;
  limit?: number;
  sinceDays?: number;
}

export async function getNewsItems(
  options: NewsQueryOptions = {}
): Promise<NewsItem[]> {
  const { sourceType, section, limit, sinceDays } = options;
  const supabase = createAdminClient();
  let q = supabase
    .from("news_items")
    .select(
      "id, source_type, source_section, title, summary, body, link, cover_image, published_at, pinned"
    )
    .order("pinned", { ascending: false })
    .order("published_at", { ascending: false });

  if (sourceType) q = q.eq("source_type", sourceType);
  if (section) q = q.eq("source_section", section);
  if (sinceDays) {
    const since = new Date(Date.now() - sinceDays * 24 * 60 * 60 * 1000);
    q = q.gte("published_at", since.toISOString());
  }
  if (limit) q = q.limit(limit);

  const { data, error } = await q;
  if (error || !data) return [];
  return (data as NewsRow[]).map(mapRow);
}

export async function getNewsItem(id: string): Promise<NewsItem | null> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("news_items")
    .select(
      "id, source_type, source_section, title, summary, body, link, cover_image, published_at, pinned"
    )
    .eq("id", id)
    .single();
  if (error || !data) return null;
  return mapRow(data as NewsRow);
}

export async function countRecentUpdatesBySection(
  section: NewsSection,
  sinceDays = 14
): Promise<number> {
  const supabase = createAdminClient();
  const since = new Date(Date.now() - sinceDays * 24 * 60 * 60 * 1000);
  const { count } = await supabase
    .from("news_items")
    .select("id", { count: "exact", head: true })
    .eq("source_section", section)
    .gte("published_at", since.toISOString());
  return count ?? 0;
}
