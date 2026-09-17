/**
 * Weekly LINE blog digest — ONE carousel every Wednesday 12:00 BKK holding every
 * article published in the last week, instead of a broadcast per article.
 *
 * Why: a LINE broadcast costs 1 message × every follower. With a new article
 * every day that was ~7,000+ messages/month on its own (plus the daily MCQ
 * card) and blew the OA monthly quota in Aug 2026. Facebook still gets each
 * article the day it's published (free) — see scripts/generate-blog.mjs.
 *
 * Picks blog_posts with line_broadcast_at IS NULL, so anything that failed
 * to send one week is simply retried the next. Scheduled in vercel.json;
 * auth is the same dual-mode as /api/cron/autopost-ig.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogDigestCarousel, BLOG_DIGEST_MAX_POSTS } from "@/lib/line-flex-templates";
import { ensureLineCover } from "@/app/api/autopost/retry/route";

export const runtime = "nodejs";
export const maxDuration = 60;

// Look back a little over a week so a late Wednesday run still catches an
// early-week article; the line_broadcast_at IS NULL filter prevents repeats.
const LOOKBACK_DAYS = 8;

function isAuthorized(request: Request): boolean {
  const secret = new URL(request.url).searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  return Boolean(process.env.CRON_SECRET) && auth === `Bearer ${process.env.CRON_SECRET}`;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  if (process.env.LINE_AUTOPOST_ENABLED !== "true") {
    return NextResponse.json({ sent: 0, message: "skipped:LINE_AUTOPOST_ENABLED!=true" });
  }

  const supabase = createAdminClient();
  const since = new Date(Date.now() - LOOKBACK_DAYS * 86400_000).toISOString();

  const { data: posts, error } = await supabase
    .from("blog_posts")
    .select("slug, title, description, cover_image, cover_image_line")
    .is("line_broadcast_at", null)
    .gte("published_at", since)
    .order("published_at", { ascending: false })
    .limit(BLOG_DIGEST_MAX_POSTS);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  if (!posts?.length) {
    return NextResponse.json({ sent: 0, message: "No unsent articles this week" });
  }

  // LINE Flex hero images must be JPEG/PNG ≤1024px; the daily FB-only
  // autopost no longer produces cover_image_line, so make it here.
  const digestPosts = [];
  for (const post of posts) {
    const coverImage =
      post.cover_image_line ??
      (post.cover_image ? await ensureLineCover(supabase, post.slug, post.cover_image) : null);
    digestPosts.push({
      title: post.title,
      description: post.description,
      url: `https://www.morroo.com/blog/${post.slug}`,
      coverImage,
    });
  }

  const slugs = posts.map((p) => p.slug);
  const result = await broadcastLineMessages([buildBlogDigestCarousel(digestPosts)]);

  await supabase
    .from("blog_posts")
    .update(
      result.ok
        ? { line_broadcast_at: new Date().toISOString(), line_last_error: null }
        : { line_last_error: (result.error ?? "unknown").slice(0, 500) },
    )
    .in("slug", slugs);

  if (!result.ok) {
    return NextResponse.json({ sent: 0, slugs, error: result.error }, { status: 502 });
  }
  return NextResponse.json({ sent: 1, articles: slugs.length, slugs });
}
