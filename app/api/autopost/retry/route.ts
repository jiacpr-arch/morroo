/**
 * Retry autopost for articles where FB or LINE delivery failed.
 *
 * GET /api/autopost/retry?secret=…&platform=fb|line|both&slug=…&limit=1
 *   slug    – retry a specific article (optional; omit to pick unposted ones)
 *   platform – fb | line | both (default: both)
 *   limit    – max articles to process per invocation (default: 1, max: 10)
 *
 * Posts one article per invocation to stay within Vercel maxDuration.
 * For backfill, call repeatedly with limit=1 and sleep 10min between calls.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook } from "@/lib/facebook";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogAnnounceFlex } from "@/lib/line-flex-templates";
import { pickAutopostFormat, categoryHashtag } from "@/lib/autopost-format";
import { generateHook } from "@/lib/autopost-copy";

export const runtime = "nodejs";
export const maxDuration = 60;

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);

  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const targetSlug = searchParams.get("slug");
  const platform = (searchParams.get("platform") ?? "both") as "fb" | "line" | "both";
  const limit = Math.min(10, parseInt(searchParams.get("limit") ?? "1", 10));
  const doFb = platform === "fb" || platform === "both";
  const doLine = platform === "line" || platform === "both";

  const supabase = createAdminClient();
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com";

  // Build query for unposted articles
  let query = supabase
    .from("blog_posts")
    .select("slug, title, description, category, cover_image, cover_image_line, fb_post_id, line_broadcast_at, autopost_format")
    .order("published_at", { ascending: false });

  if (targetSlug) {
    query = query.eq("slug", targetSlug);
  } else {
    // Pick articles missing at least one platform
    if (doFb && !doLine) query = query.is("fb_post_id", null);
    else if (doLine && !doFb) query = query.is("line_broadcast_at", null);
    // for "both": pick any unposted (we'll skip per-platform based on existing values below)
  }

  const { data: posts, error } = await query.limit(limit);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  if (!posts?.length) {
    return NextResponse.json({ message: "No unposted articles found" });
  }

  const results: Array<{ slug: string; fb?: string; line?: string }> = [];

  for (const post of posts) {
    const result: { slug: string; fb?: string; line?: string } = { slug: post.slug };
    const articleUrl = `${siteUrl}/blog/${post.slug}`;
    const format = (post.autopost_format as "cover_caption" | "quote_card" | "link_only" | null)
      ?? pickAutopostFormat(post.slug);

    // FB retry
    if (doFb && !post.fb_post_id) {
      const hook = await generateHook({
        title: post.title,
        description: post.description,
        apiKey: process.env.ANTHROPIC_API_KEY,
      });
      const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
      const coverForFb =
        format === "cover_caption"
          ? (post.cover_image ?? null)
          : format === "quote_card"
            ? `${siteUrl}/api/og/quote?slug=${post.slug}`
            : null;

      try {
        const fbId = await postToFacebook({
          title: post.title,
          description: post.description,
          slug: post.slug,
          coverImage: coverForFb,
          hook: format === "cover_caption" ? `${hook}\n\n${hashtags}` : hook,
        });
        await supabase.from("blog_posts").update({
          fb_post_id: fbId,
          fb_posted_at: new Date().toISOString(),
          fb_last_error: null,
          autopost_format: format,
        }).eq("slug", post.slug);
        result.fb = `posted:${fbId}`;
      } catch (err) {
        await supabase.from("blog_posts").update({
          fb_last_error: String(err).slice(0, 500),
        }).eq("slug", post.slug);
        result.fb = `error:${String(err).slice(0, 100)}`;
      }
    } else if (doFb) {
      result.fb = "already_posted";
    }

    // LINE retry
    if (doLine && !post.line_broadcast_at) {
      const flex = buildBlogAnnounceFlex({
        title: post.title,
        description: post.description,
        url: articleUrl,
        coverImage: post.cover_image_line ?? null,
      });
      const lineResult = await broadcastLineMessages([flex]);
      await supabase.from("blog_posts").update(
        lineResult.ok
          ? { line_broadcast_at: new Date().toISOString(), line_last_error: null }
          : { line_last_error: (lineResult.error ?? "unknown").slice(0, 500) }
      ).eq("slug", post.slug);
      result.line = lineResult.ok ? "sent" : `error:${lineResult.error?.slice(0, 100)}`;
    } else if (doLine) {
      result.line = "already_sent";
    }

    results.push(result);
  }

  return NextResponse.json({ processed: results.length, results });
}
