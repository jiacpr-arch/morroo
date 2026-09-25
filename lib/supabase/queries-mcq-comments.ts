import type { SupabaseClient } from "@supabase/supabase-js";
import {
  avatarInitial,
  publicDisplayName,
  type CommentRow,
  type PublicComment,
} from "@/lib/mcq-comments";

export const COMMENT_FIELDS =
  "id, question_id, user_id, parent_id, body, created_at, edited_at, status, upvotes";

/**
 * Turns raw mcq_comments rows into the browser-safe shape: author name is
 * reduced to the public display form and user_id / email never leave the
 * server. profiles is RLS-restricted to the owner, so names are looked up
 * with the service-role client passed in as `admin`.
 */
export async function toPublicComments(
  admin: SupabaseClient,
  rows: CommentRow[],
  viewerId: string,
  votedIds: Set<string>
): Promise<PublicComment[]> {
  const userIds = [...new Set(rows.map((r) => r.user_id))];
  const profilesById = new Map<string, { name: string | null; role: string | null }>();
  if (userIds.length > 0) {
    const { data } = await admin
      .from("profiles")
      .select("id, name, role")
      .in("id", userIds);
    for (const p of (data ?? []) as { id: string; name: string | null; role: string | null }[]) {
      profilesById.set(p.id, { name: p.name, role: p.role });
    }
  }

  return rows.map((r) => {
    const prof = profilesById.get(r.user_id);
    const name = publicDisplayName(prof?.name);
    return {
      id: r.id,
      parent_id: r.parent_id,
      body: r.body,
      created_at: r.created_at,
      edited_at: r.edited_at,
      status: r.status,
      upvotes: r.upvotes,
      author: {
        name,
        initial: avatarInitial(name),
        is_admin: prof?.role === "admin",
      },
      is_mine: r.user_id === viewerId,
      has_voted: votedIds.has(r.id),
    };
  });
}
