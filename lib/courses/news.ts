import { supabase } from "@/lib/acls-reader/supabase";
import type { CourseMode } from "@/lib/courses/config";

// Ported from acls-emr's src/services/newsService.js (fetchNews). Reads the
// `acls_news` table (renamed from the source's `news`) — public read policy
// requires is_active = true. No client-side cache layer here (unlike the
// source app's localStorage cache): pages calling this are RSCs with
// `export const revalidate`, and NewsCard (a client component) calls this
// directly against the anon-key browser client — same pattern already used
// by lib/courses/video-lessons.ts.

export type NewsCourse = "acls" | "bls" | "both";

export interface NewsItem {
  id: string;
  title: string;
  summary: string;
  source_url: string | null;
  source_name: string | null;
  language: string;
  course: NewsCourse;
  topics: string[];
  published_at: string;
  is_evergreen: boolean;
}

interface NewsRow {
  id: string;
  title: string;
  summary: string;
  source_url: string | null;
  source_name: string | null;
  language: string;
  course: string;
  topics: string[] | null;
  published_at: string;
  is_evergreen: boolean | null;
}

function mapNewsRow(row: NewsRow): NewsItem {
  return {
    id: row.id,
    title: row.title,
    summary: row.summary,
    source_url: row.source_url,
    source_name: row.source_name,
    language: row.language,
    course: (row.course as NewsCourse) || "both",
    topics: Array.isArray(row.topics) ? row.topics : [],
    published_at: row.published_at,
    is_evergreen: row.is_evergreen === true,
  };
}

export interface GetNewsOptions {
  /** Max rows to return. Defaults to 50 (the full /news list page). */
  limit?: number;
  /** Case-insensitive substring match against title/summary (server-side ILIKE). */
  search?: string | null;
  /** Only include items published within the last N days. Used by the compact NewsCard. */
  maxAgeDays?: number | null;
  /** Exclude evergreen reference items. Used by the compact NewsCard. */
  freshOnly?: boolean;
}

// Reads acls_news filtered to items visible on `course`'s site: the site's
// own course plus 'both' (cross-course) items — mirrors the source's
// COURSE_FILTER = IS_BLS ? ['bls','both'] : ['acls','both'].
export async function getNews(
  course: CourseMode,
  options: GetNewsOptions = {},
): Promise<NewsItem[]> {
  const { limit = 50, search = null, maxAgeDays = null, freshOnly = false } = options;

  let q = supabase
    .from("acls_news")
    .select(
      "id, title, summary, source_url, source_name, language, course, topics, published_at, is_evergreen",
    )
    .eq("is_active", true)
    .in("course", [course, "both"])
    .order("published_at", { ascending: false })
    .limit(limit);

  // Exclude evergreen reference (guidelines, landmark research) — used by the
  // compact NewsCard so it always surfaces genuine fresh news, never an old paper.
  if (freshOnly) {
    q = q.eq("is_evergreen", false);
  }

  // Hide stale items — used by the compact NewsCard so it never surfaces
  // months-old news as "ข่าวล่าสุด". The full /news page omits this.
  if (maxAgeDays != null) {
    const cutoff = new Date(Date.now() - maxAgeDays * 24 * 60 * 60 * 1000).toISOString();
    q = q.gte("published_at", cutoff);
  }

  if (search) {
    q = q.or(`title.ilike.%${search}%,summary.ilike.%${search}%`);
  }

  const { data, error } = await q;
  if (error) {
    console.warn("acls news fetch failed", error.message);
    return [];
  }
  return (data ?? []).map((r) => mapNewsRow(r as NewsRow));
}
