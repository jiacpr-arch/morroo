/**
 * Retry autopost for articles where FB, LINE, IG, or Story delivery failed.
 *
 * GET /api/autopost/retry?secret=…&platform=fb|line|ig|fb_story|ig_story|stories|both|all&slug=…&limit=1
 *   slug    – retry a specific article (optional; omit to pick unposted ones)
 *   platform – fb | line | ig | fb_story | ig_story | stories (= fb_story+ig_story)
 *              | both (= fb+line) | all (= fb+line+ig+fb_story+ig_story). Default: both
 *   limit    – max articles to process per invocation (default: 1, max: 10)
 *
 * Posts one article per invocation to stay within Vercel maxDuration.
 * For backfill, call repeatedly with limit=1 and sleep 10min between calls.
 *
 * The core loop is exported as `runAutopostRetry()` so the Vercel cron handler
 * (`/api/cron/autopost-ig`) and the session-gated admin retry endpoint can
 * reuse the same logic without passing BLOG_GENERATE_SECRET around.
 */

import { NextResponse } from "next/server";
import sharp from "sharp";
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook, postStoryToFacebook } from "@/lib/facebook";
import {
  postToInstagram,
  postStoryToInstagram,
  postCarouselToInstagram,
  postReelToInstagram,
} from "@/lib/instagram";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogAnnounceFlex } from "@/lib/line-flex-templates";
import { pickAutopostFormat, categoryHashtag } from "@/lib/autopost-format";
import { generateHook, buildFbCaption, buildIgCaption } from "@/lib/autopost-copy";
import { composeStoryImage } from "@/lib/autopost-story-image";
import { composeCarouselSlides } from "@/lib/autopost-carousel-image";

export const runtime = "nodejs";
export const maxDuration = 60;

/**
 * Generate IG-compatible JPEG at original 1024×1024. IG's container endpoint
 * rejects PNGs from gpt-image-1 ("Only photo or video can be accepted as
 * media type") — likely because of the alpha channel. Flatten + JPEG handles
 * both. Quality 95 to keep typography crisp.
 */
async function ensureIgCover(
  supabase: ReturnType<typeof createAdminClient>,
  slug: string,
  coverImage: string,
): Promise<string | null> {
  try {
    const res = await fetch(coverImage);
    if (!res.ok) return null;
    const buffer = Buffer.from(await res.arrayBuffer());
    const igBuffer = await sharp(buffer)
      .flatten({ background: "#ffffff" })
      .jpeg({ quality: 95 })
      .toBuffer();

    const filePath = `blog-covers/${slug}-ig.jpg`;
    const { error: uploadError } = await supabase.storage
      .from("public-assets")
      .upload(filePath, igBuffer, { contentType: "image/jpeg", upsert: true });
    if (uploadError) {
      console.error("[autopost-retry] ig cover upload error:", uploadError);
      return null;
    }
    const { data: pub } = supabase.storage.from("public-assets").getPublicUrl(filePath);
    return pub.publicUrl;
  } catch (err) {
    console.error("[autopost-retry] ig cover gen error:", err);
    return null;
  }
}

/**
 * Generate Story-compatible JPEG variant (1080×1920, 9:16 portrait). Square
 * cover is centered over a blurred-cover background; FB Stories + IG Stories
 * share this asset. Stories don't render captions so all text must be on-image.
 */
async function ensureStoryCover(
  supabase: ReturnType<typeof createAdminClient>,
  slug: string,
  coverImage: string,
  headline?: string,
): Promise<string | null> {
  try {
    const res = await fetch(coverImage);
    if (!res.ok) return null;
    const buffer = Buffer.from(await res.arrayBuffer());
    const storyBuffer = await composeStoryImage(buffer, { headline });

    const filePath = `blog-covers/${slug}-story.jpg`;
    const { error: uploadError } = await supabase.storage
      .from("public-assets")
      .upload(filePath, storyBuffer, { contentType: "image/jpeg", upsert: true });
    if (uploadError) {
      console.error("[autopost-retry] story cover upload error:", uploadError);
      return null;
    }
    const { data: pub } = supabase.storage.from("public-assets").getPublicUrl(filePath);
    const url = pub.publicUrl;
    await supabase.from("blog_posts").update({ cover_image_story: url }).eq("slug", slug);
    return url;
  } catch (err) {
    console.error("[autopost-retry] story cover gen error:", err);
    return null;
  }
}

/**
 * Render carousel slides, upload each to Supabase Storage, return their
 * public URLs. Same pattern as ensureIgCover/ensureStoryCover: produces a
 * stable per-slide path so retries are idempotent.
 */
async function ensureCarouselSlides(
  supabase: ReturnType<typeof createAdminClient>,
  slug: string,
  input: {
    hook: string;
    title: string;
    bullets: string[];
    articleUrl: string;
  },
): Promise<string[] | null> {
  try {
    const slides = await composeCarouselSlides(input);
    const urls: string[] = [];
    for (let i = 0; i < slides.length; i++) {
      const filePath = `blog-covers/${slug}-carousel-${i + 1}.jpg`;
      const { error: uploadError } = await supabase.storage
        .from("public-assets")
        .upload(filePath, slides[i], { contentType: "image/jpeg", upsert: true });
      if (uploadError) {
        console.error(
          `[autopost-retry] carousel slide ${i + 1} upload error:`,
          uploadError,
        );
        return null;
      }
      const { data: pub } = supabase.storage.from("public-assets").getPublicUrl(filePath);
      urls.push(pub.publicUrl);
    }
    await supabase
      .from("blog_posts")
      .update({ ig_carousel_slide_urls: urls })
      .eq("slug", slug);
    return urls;
  } catch (err) {
    console.error("[autopost-retry] carousel compose error:", err);
    return null;
  }
}

/**
 * Generate LINE-compatible JPEG variant (1024×536, ≤1MB) from an existing
 * cover image URL. LINE Flex hero requires JPEG/PNG ≤1024px wide;
 * gpt-image-1 PNG at 1024×1024 sometimes exceeds 1MB and uses 1:1 aspect.
 */
async function ensureLineCover(
  supabase: ReturnType<typeof createAdminClient>,
  slug: string,
  coverImage: string,
): Promise<string | null> {
  try {
    const res = await fetch(coverImage);
    if (!res.ok) return null;
    const buffer = Buffer.from(await res.arrayBuffer());
    const lineBuffer = await sharp(buffer)
      .resize(1024, 536, { fit: "cover" })
      .jpeg({ quality: 85 })
      .toBuffer();

    const filePath = `blog-covers/${slug}-line.jpg`;
    const { error: uploadError } = await supabase.storage
      .from("public-assets")
      .upload(filePath, lineBuffer, { contentType: "image/jpeg", upsert: true });
    if (uploadError) {
      console.error("[autopost-retry] line cover upload error:", uploadError);
      return null;
    }
    const { data: pub } = supabase.storage.from("public-assets").getPublicUrl(filePath);
    const url = pub.publicUrl;
    await supabase.from("blog_posts").update({ cover_image_line: url }).eq("slug", slug);
    return url;
  } catch (err) {
    console.error("[autopost-retry] line cover gen error:", err);
    return null;
  }
}

export type AutopostPlatform =
  | "fb"
  | "line"
  | "ig"
  | "fb_story"
  | "ig_story"
  | "ig_carousel"
  | "ig_reel"
  | "stories"
  | "both"
  | "all";

export interface AutopostRetryResult {
  slug: string;
  fb?: string;
  line?: string;
  ig?: string;
  fb_story?: string;
  ig_story?: string;
  ig_carousel?: string;
  ig_reel?: string;
}

export interface AutopostRetryResponse {
  processed: number;
  results: AutopostRetryResult[];
  message?: string;
}

export async function runAutopostRetry(opts: {
  platform: AutopostPlatform;
  limit?: number;
  slug?: string | null;
}): Promise<AutopostRetryResponse> {
  const { platform } = opts;
  const targetSlug = opts.slug ?? null;
  const limit = Math.min(10, Math.max(1, opts.limit ?? 1));

  const doFb = platform === "fb" || platform === "both" || platform === "all";
  const doLine = platform === "line" || platform === "both" || platform === "all";
  const doIg = platform === "ig" || platform === "all";
  const doFbStory = platform === "fb_story" || platform === "stories" || platform === "all";
  const doIgStory = platform === "ig_story" || platform === "stories" || platform === "all";
  const doIgCarousel = platform === "ig_carousel" || platform === "all";
  const doIgReel = platform === "ig_reel"; // never auto-run from "all" — needs an admin-supplied video URL

  const supabase = createAdminClient();
  // Force canonical www domain — LINE Flex action URI strict-validates scheme
  // and rejects empty/relative URLs. `||` falls back when env var is empty too.
  const rawSiteUrl = process.env.NEXT_PUBLIC_SITE_URL || "https://www.morroo.com";
  const siteUrl = rawSiteUrl.replace(/^https:\/\/morroo\.com/, "https://www.morroo.com");

  let query = supabase
    .from("blog_posts")
    .select(
      "slug, title, description, category, cover_image, cover_image_line, cover_image_story, fb_post_id, line_broadcast_at, ig_post_id, fb_story_id, ig_story_id, ig_carousel_id, ig_reel_id, ig_reel_video_url, ig_carousel_slide_urls, autopost_format",
    )
    .order("published_at", { ascending: false });

  if (targetSlug) {
    query = query.eq("slug", targetSlug);
  } else if (doIg && !doFb && !doLine && !doFbStory && !doIgStory && !doIgCarousel && !doIgReel) {
    query = query.is("ig_post_id", null);
  } else if (doFb && !doLine && !doIg && !doFbStory && !doIgStory && !doIgCarousel && !doIgReel) {
    query = query.is("fb_post_id", null);
  } else if (doLine && !doFb && !doIg && !doFbStory && !doIgStory && !doIgCarousel && !doIgReel) {
    query = query.is("line_broadcast_at", null);
  } else if (doFbStory && !doFb && !doLine && !doIg && !doIgStory && !doIgCarousel && !doIgReel) {
    query = query.is("fb_story_id", null);
  } else if (doIgStory && !doFb && !doLine && !doIg && !doFbStory && !doIgCarousel && !doIgReel) {
    query = query.is("ig_story_id", null);
  } else if (doIgCarousel && !doFb && !doLine && !doIg && !doFbStory && !doIgStory && !doIgReel) {
    query = query.is("ig_carousel_id", null);
  } else if (doIgReel && !doFb && !doLine && !doIg && !doFbStory && !doIgStory && !doIgCarousel) {
    // Reels only retry rows that already have a video URL queued by the admin
    query = query.is("ig_reel_id", null).not("ig_reel_video_url", "is", null);
  }

  const { data: posts, error } = await query.limit(limit);
  if (error) {
    throw new Error(error.message);
  }
  if (!posts?.length) {
    return { processed: 0, results: [], message: "No unposted articles found" };
  }

  const results: AutopostRetryResult[] = [];

  for (const post of posts) {
    const result: AutopostRetryResult = { slug: post.slug };
    // Hardcode canonical URL — env-derived siteUrl gave LINE "invalid uri scheme"
    // even with || + replace fallbacks, so something in env is malformed/empty.
    const articleUrl = `https://www.morroo.com/blog/${post.slug}`;
    console.log("[autopost-retry]", post.slug, "articleUrl=", articleUrl);
    const format = (post.autopost_format as "cover_caption" | "quote_card" | "link_only" | null)
      ?? pickAutopostFormat(post.slug);

    // FB retry
    if (doFb && !post.fb_post_id) {
      const hookParts = await generateHook({
        title: post.title,
        description: post.description,
        apiKey: process.env.ANTHROPIC_API_KEY,
      });
      const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
      const fbCaption = buildFbCaption({
        ...hookParts,
        articleUrl,
        hashtags,
      });

      try {
        const fbId = await postToFacebook({
          title: post.title,
          description: post.description,
          slug: post.slug,
          hook: fbCaption,
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

    // LINE retry — gated by LINE_AUTOPOST_ENABLED to match /api/blog/generate behavior
    // (LINE broadcast quota = 1 msg × N followers, so opt-in only)
    const lineEnabled = process.env.LINE_AUTOPOST_ENABLED === "true";
    if (doLine && !post.line_broadcast_at && lineEnabled) {
      const lineCover =
        post.cover_image_line
        ?? (post.cover_image ? await ensureLineCover(supabase, post.slug, post.cover_image) : null);

      const flex = buildBlogAnnounceFlex({
        title: post.title,
        description: post.description,
        url: articleUrl,
        coverImage: lineCover,
      });
      const lineResult = await broadcastLineMessages([flex]);
      await supabase.from("blog_posts").update(
        lineResult.ok
          ? { line_broadcast_at: new Date().toISOString(), line_last_error: null }
          : { line_last_error: (lineResult.error ?? "unknown").slice(0, 500) }
      ).eq("slug", post.slug);
      result.line = lineResult.ok ? "sent" : `error:${lineResult.error?.slice(0, 100)}`;
    } else if (doLine && !lineEnabled) {
      result.line = "skipped:LINE_AUTOPOST_ENABLED!=true";
    } else if (doLine) {
      result.line = "already_sent";
    }

    // IG retry
    if (doIg && !post.ig_post_id) {
      const sourceCover =
        post.autopost_format === "quote_card" || (!post.autopost_format && pickAutopostFormat(post.slug) === "quote_card")
          ? `${siteUrl}/api/og/quote?slug=${post.slug}`
          : post.cover_image;
      const igCover = sourceCover ? await ensureIgCover(supabase, post.slug, sourceCover) : null;

      if (!igCover) {
        result.ig = "skipped:no_cover";
      } else {
        const hookParts = await generateHook({
          title: post.title,
          description: post.description,
          apiKey: process.env.ANTHROPIC_API_KEY,
        });
        const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
        const caption = buildIgCaption({
          ...hookParts,
          siteHost: siteUrl.replace(/^https?:\/\//, ""),
          hashtags,
        });

        try {
          const igId = await postToInstagram({ imageUrl: igCover, caption });
          await supabase.from("blog_posts").update({
            ig_post_id: igId,
            ig_posted_at: new Date().toISOString(),
            ig_last_error: null,
          }).eq("slug", post.slug);
          result.ig = `posted:${igId}`;
        } catch (err) {
          await supabase.from("blog_posts").update({
            ig_last_error: String(err).slice(0, 500),
          }).eq("slug", post.slug);
          result.ig = `error:${String(err).slice(0, 100)}`;
        }
      }
    } else if (doIg) {
      result.ig = "already_posted";
    }

    // FB / IG Story retries share the same 9:16 asset. Generate on demand if missing.
    const needStoryCover = (doFbStory && !post.fb_story_id) || (doIgStory && !post.ig_story_id);
    const storyCover = needStoryCover
      ? (post.cover_image_story
        ?? (post.cover_image ? await ensureStoryCover(supabase, post.slug, post.cover_image, post.title) : null))
      : null;

    const fbStoryEnabled = process.env.FACEBOOK_STORY_AUTOPOST_ENABLED === "true";
    if (doFbStory && !post.fb_story_id && fbStoryEnabled) {
      if (!storyCover) {
        result.fb_story = "skipped:no_cover";
      } else {
        try {
          const fbStoryId = await postStoryToFacebook({ imageUrl: storyCover });
          await supabase.from("blog_posts").update({
            fb_story_id: fbStoryId,
            fb_story_posted_at: new Date().toISOString(),
            fb_story_last_error: null,
          }).eq("slug", post.slug);
          result.fb_story = `posted:${fbStoryId}`;
        } catch (err) {
          await supabase.from("blog_posts").update({
            fb_story_last_error: String(err).slice(0, 500),
          }).eq("slug", post.slug);
          result.fb_story = `error:${String(err).slice(0, 100)}`;
        }
      }
    } else if (doFbStory && !fbStoryEnabled) {
      result.fb_story = "skipped:FACEBOOK_STORY_AUTOPOST_ENABLED!=true";
    } else if (doFbStory) {
      result.fb_story = "already_posted";
    }

    if (doIgStory && !post.ig_story_id) {
      if (!storyCover) {
        result.ig_story = "skipped:no_cover";
      } else {
        try {
          // Attach link sticker pointing at the article so the Story has a
          // tappable "open article" target. lib/instagram.ts retries without
          // the sticker if the account turns out to be ineligible.
          const igStoryId = await postStoryToInstagram({
            imageUrl: storyCover,
            linkUrl: articleUrl,
          });
          await supabase.from("blog_posts").update({
            ig_story_id: igStoryId,
            ig_story_posted_at: new Date().toISOString(),
            ig_story_last_error: null,
          }).eq("slug", post.slug);
          result.ig_story = `posted:${igStoryId}`;
        } catch (err) {
          await supabase.from("blog_posts").update({
            ig_story_last_error: String(err).slice(0, 500),
          }).eq("slug", post.slug);
          result.ig_story = `error:${String(err).slice(0, 100)}`;
        }
      }
    } else if (doIgStory) {
      result.ig_story = "already_posted";
    }

    // IG Carousel — 5 slides assembled from cover + hook + 3 bullets + CTA card.
    // The final slide visually mimics a link-preview card with the article URL,
    // since IG strips clickable URLs from captions.
    if (doIgCarousel && !post.ig_carousel_id) {
      const hookParts = await generateHook({
        title: post.title,
        description: post.description,
        apiKey: process.env.ANTHROPIC_API_KEY,
      });
      const existingSlides = Array.isArray(post.ig_carousel_slide_urls)
        ? (post.ig_carousel_slide_urls as string[])
        : null;
      const slideUrls =
        existingSlides && existingSlides.length >= 2 && existingSlides.length <= 10
          ? existingSlides
          : await ensureCarouselSlides(supabase, post.slug, {
              hook: hookParts.hook,
              title: post.title,
              bullets: hookParts.bullets,
              articleUrl,
            });

      if (!slideUrls) {
        result.ig_carousel = "skipped:compose_failed";
      } else {
        const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
        const caption = buildIgCaption({
          ...hookParts,
          siteHost: siteUrl.replace(/^https?:\/\//, ""),
          hashtags,
        });
        try {
          const carouselId = await postCarouselToInstagram({
            imageUrls: slideUrls,
            caption,
          });
          await supabase
            .from("blog_posts")
            .update({
              ig_carousel_id: carouselId,
              ig_carousel_posted_at: new Date().toISOString(),
              ig_carousel_last_error: null,
            })
            .eq("slug", post.slug);
          result.ig_carousel = `posted:${carouselId}`;
        } catch (err) {
          await supabase
            .from("blog_posts")
            .update({ ig_carousel_last_error: String(err).slice(0, 500) })
            .eq("slug", post.slug);
          result.ig_carousel = `error:${String(err).slice(0, 100)}`;
        }
      }
    } else if (doIgCarousel) {
      result.ig_carousel = "already_posted";
    }

    // IG Reel — needs ig_reel_video_url pre-set by admin (no auto video gen).
    if (doIgReel && !post.ig_reel_id) {
      if (!post.ig_reel_video_url) {
        result.ig_reel = "skipped:no_video_url";
      } else {
        const hookParts = await generateHook({
          title: post.title,
          description: post.description,
          apiKey: process.env.ANTHROPIC_API_KEY,
        });
        const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
        const caption = buildIgCaption({
          ...hookParts,
          siteHost: siteUrl.replace(/^https?:\/\//, ""),
          hashtags,
        });
        try {
          const reelId = await postReelToInstagram({
            videoUrl: post.ig_reel_video_url,
            caption,
            shareToFeed: true,
          });
          await supabase
            .from("blog_posts")
            .update({
              ig_reel_id: reelId,
              ig_reel_posted_at: new Date().toISOString(),
              ig_reel_last_error: null,
            })
            .eq("slug", post.slug);
          result.ig_reel = `posted:${reelId}`;
        } catch (err) {
          await supabase
            .from("blog_posts")
            .update({ ig_reel_last_error: String(err).slice(0, 500) })
            .eq("slug", post.slug);
          result.ig_reel = `error:${String(err).slice(0, 100)}`;
        }
      }
    } else if (doIgReel) {
      result.ig_reel = "already_posted";
    }

    results.push(result);
  }

  return { processed: results.length, results };
}

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);

  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const platform = (searchParams.get("platform") ?? "both") as AutopostPlatform;
  const limit = Math.min(10, parseInt(searchParams.get("limit") ?? "1", 10));
  const slug = searchParams.get("slug");

  try {
    const result = await runAutopostRetry({ platform, limit, slug });
    if (result.message && result.processed === 0) {
      return NextResponse.json({ message: result.message });
    }
    return NextResponse.json(result);
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}

