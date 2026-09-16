/**
 * Autopost a `news_items` announcement (product_update / exam) to Facebook
 * and LINE, mirroring the blog autopost flow in app/api/autopost/retry/route.ts
 * but simpler: no cover reprocessing, no IG, no retries — just "post once,
 * record the result".
 *
 * Called from app/api/admin/news/route.ts right after an admin creates a
 * news item (when notify_members is true and it's already published), and
 * from /api/cron/autopost-scheduled for items whose published_at has since
 * arrived.
 */
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook } from "@/lib/facebook";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogAnnounceFlex } from "@/lib/line-flex-templates";

const SITE_URL = "https://www.morroo.com";

export interface NewsAutopostResult {
  fb: string;
  line: string;
}

/**
 * Posts news item `id` to FB and (if LINE_AUTOPOST_ENABLED) LINE, and writes
 * the result back onto the row. Safe to call more than once — already-posted
 * platforms are skipped.
 */
export async function autopostNewsItem(id: string): Promise<NewsAutopostResult> {
  const admin = createAdminClient();
  const { data: item, error } = await admin
    .from("news_items")
    .select(
      "id, title, summary, cover_image, fb_post_id, line_broadcast_at",
    )
    .eq("id", id)
    .single();

  if (error || !item) {
    return { fb: "error:not_found", line: "error:not_found" };
  }

  const url = `${SITE_URL}/news/${item.id}`;
  const result: NewsAutopostResult = { fb: "skipped", line: "skipped" };

  // Facebook
  if (!item.fb_post_id) {
    try {
      const fbId = await postToFacebook({
        title: item.title,
        description: item.summary,
        slug: item.id,
        path: `/news/${item.id}`,
      });
      await admin
        .from("news_items")
        .update({ fb_post_id: fbId, fb_posted_at: new Date().toISOString(), fb_last_error: null })
        .eq("id", id);
      result.fb = `posted:${fbId}`;
    } catch (err) {
      await admin
        .from("news_items")
        .update({ fb_last_error: String(err).slice(0, 500) })
        .eq("id", id);
      result.fb = `error:${String(err).slice(0, 100)}`;
    }
  } else {
    result.fb = "already_posted";
  }

  // LINE — gated by LINE_AUTOPOST_ENABLED, same as blog autopost (broadcast
  // quota = 1 message × every follower, so it stays opt-in).
  const lineEnabled = process.env.LINE_AUTOPOST_ENABLED === "true";
  if (!item.line_broadcast_at && lineEnabled) {
    const flex = buildBlogAnnounceFlex({
      title: item.title,
      description: item.summary,
      url,
      coverImage: item.cover_image,
      kind: "news",
    });
    const lineResult = await broadcastLineMessages([flex]);
    await admin
      .from("news_items")
      .update(
        lineResult.ok
          ? { line_broadcast_at: new Date().toISOString(), line_last_error: null }
          : { line_last_error: (lineResult.error ?? "unknown").slice(0, 500) },
      )
      .eq("id", id);
    result.line = lineResult.ok ? "sent" : `error:${lineResult.error?.slice(0, 100)}`;
  } else if (!lineEnabled) {
    result.line = "skipped:LINE_AUTOPOST_ENABLED!=true";
  } else {
    result.line = "already_sent";
  }

  return result;
}
