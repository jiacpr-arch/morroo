import type { SupabaseClient } from "@supabase/supabase-js";

/**
 * Load a topic's full-text book as a single string for grounding Claude
 * (chapters concatenated in order, truncated to `maxChars`). Returns "" when
 * the topic has no active book. Shared by the ask endpoint and the enrich job
 * so both ground on the same text the same way.
 *
 * Accepts any Supabase client (server user-context or admin/service-role).
 */
export async function loadBookContext(
  client: SupabaseClient,
  topicId: string,
  maxChars: number
): Promise<string> {
  const { data: book } = await client
    .from("school_books")
    .select("id")
    .eq("topic_id", topicId)
    .eq("status", "active")
    .maybeSingle();
  if (!book) return "";

  const { data: chapters } = await client
    .from("school_book_chapters")
    .select("title, body_md")
    .eq("book_id", (book as { id: string }).id)
    .order("sort_order");

  return (chapters ?? [])
    .map((c: { title: string; body_md: string }) => `## ${c.title}\n${c.body_md}`)
    .join("\n\n")
    .slice(0, maxChars);
}
