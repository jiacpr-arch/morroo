import { createAdminClient } from "@/lib/supabase/admin";

export interface BlogPost {
  slug: string;
  title: string;
  description: string;
  publishedAt: string;
  category: string;
  readingTime: number;
  content: string;
}

// Map DB row → BlogPost shape
function mapRow(row: {
  slug: string;
  title: string;
  description: string;
  published_at: string;
  category: string;
  reading_time: number;
  content: string;
}): BlogPost {
  return {
    slug: row.slug,
    title: row.title,
    description: row.description,
    publishedAt: row.published_at,
    category: row.category,
    readingTime: row.reading_time,
    content: row.content,
  };
}

export async function getBlogPosts(): Promise<BlogPost[]> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("blog_posts")
    .select("slug, title, description, published_at, category, reading_time, content")
    .order("published_at", { ascending: false });

  if (error || !data) return [];
  return data.map(mapRow);
}

export async function getBlogPost(slug: string): Promise<BlogPost | null> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("blog_posts")
    .select("slug, title, description, published_at, category, reading_time, content")
    .eq("slug", slug)
    .single();

  if (error || !data) return null;
  return mapRow(data);
}

export async function getAllSlugs(): Promise<string[]> {
  const supabase = createAdminClient();
  const { data } = await supabase.from("blog_posts").select("slug");
  return (data ?? []).map((r: { slug: string }) => r.slug);
}
