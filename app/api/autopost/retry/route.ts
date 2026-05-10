/**
 * Retry autopost for articles where FB, LINE, or IG delivery failed.
 *
 * GET /api/autopost/retry?secret=…&platform=fb|line|ig|both|all&slug=…&limit=1
 *   slug    – retry a specific article (optional; omit to pick unposted ones)
 *   platform – fb | line | ig | both (= fb+line) | all (= fb+line+ig). Default: both
 *   limit    – max articles to process per invocation (default: 1, max: 10)
 *
 * Posts one article per invocation to stay within Vercel maxDuration.
 * For backfill, call repeatedly with limit=1 and sleep 10min between calls.
 */

import { NextResponse } from "next/server";
import sharp from "sharp";
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook } from "@/lib/facebook";
import { postToInstagram } from "@/lib/instagram";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogAnnounceFlex } from "@/lib/line-flex-templates";
import { pickAutopostFormat, categoryHashtag } from "@/lib/autopost-format";
import { generateHook } from "@/lib/autopost-copy";

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

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);

  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const targetSlug = searchParams.get("slug");
  const platform = (searchParams.get("platform") ?? "both") as
    | "fb" | "line" | "ig" | "both" | "all";
  const limit = Math.min(10, parseInt(searchParams.get("limit") ?? "1", 10));
  const doFb = platform === "fb" || platform === "both" || platform === "all";
  const doLine = platform === "line" || platform === "both" || platform === "all";
  const doIg = platform === "ig" || platform === "all";

  const supabase = createAdminClient();
  // Force canonical www domain — LINE Flex action URI strict-validates scheme
  // and rejects empty/relative URLs. `||` falls back when env var is empty too.
  const rawSiteUrl = process.env.NEXT_PUBLIC_SITE_URL || "https://www.morroo.com";
  const siteUrl = rawSiteUrl.replace(/^https:\/\/morroo\.com/, "https://www.morroo.com");

  // Build query for unposted articles
  let query = supabase
    .from("blog_posts")
    .select(
      "slug, title, description, category, cover_image, cover_image_line, fb_post_id, line_broadcast_at, ig_post_id, autopost_format",
    )
    .order("published_at", { ascending: false });

  if (targetSlug) {
    query = query.eq("slug", targetSlug);
  } else if (doIg && !doFb && !doLine) {
    query = query.is("ig_post_id", null);
  } else if (doFb && !doLine && !doIg) {
    query = query.is("fb_post_id", null);
  } else if (doLine && !doFb && !doIg) {
    query = query.is("line_broadcast_at", null);
  }
  // multi-platform: pick any rows; per-platform skip checks happen below

  const { data: posts, error } = await query.limit(limit);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
  if (!posts?.length) {
    return NextResponse.json({ message: "No unposted articles found" });
  }

  const results: Array<{ slug: string; fb?: string; line?: string; ig?: string }> = [];

  for (const post of posts) {
    const result: { slug: string; fb?: string; line?: string; ig?: string } = { slug: post.slug };
    // Hardcode canonical URL — env-derived siteUrl gave LINE "invalid uri scheme"
    // even with || + replace fallbacks, so something in env is malformed/empty.
    const articleUrl = `https://www.morroo.com/blog/${post.slug}`;
    console.log("[autopost-retry]", post.slug, "articleUrl=", articleUrl);
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

      try {
        const fbId = await postToFacebook({
          title: post.title,
          description: post.description,
          slug: post.slug,
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

    // LINE retry — gated by LINE_AUTOPOST_ENABLED to match /api/blog/generate behavior
    // (LINE broadcast quota = 1 msg × N followers, so opt-in only)
    const lineEnabled = process.env.LINE_AUTOPOST_ENABLED === "true";
    if (doLine && !post.line_broadcast_at && lineEnabled) {
      // Generate cover_image_line on demand if missing (script-generated posts skip it)
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

    // IG retry — gated by INSTAGRAM_AUTOPOST_ENABLED while we validate token perms
    // and Page→IG link in production; flip to "true" once first post succeeds.
    const igEnabled = process.env.INSTAGRAM_AUTOPOST_ENABLED === "true";
    if (doIg && !post.ig_post_id && igEnabled) {
      // Source cover URL by format. cover_image is a 1024×1024 PNG; quote_card
      // is rendered via next/og (also PNG). IG rejects both as PNG, so we
      // flatten to JPEG via ensureIgCover before posting (full resolution,
      // q=95 — quality is preserved, no downscale).
      const sourceCover =
        post.autopost_format === "quote_card" || (!post.autopost_format && pickAutopostFormat(post.slug) === "quote_card")
          ? `${siteUrl}/api/og/quote?slug=${post.slug}`
          : post.cover_image;
      const igCover = sourceCover ? await ensureIgCover(supabase, post.slug, sourceCover) : null;

      if (!igCover) {
        result.ig = "skipped:no_cover";
      } else {
        const hook = await generateHook({
          title: post.title,
          description: post.description,
          apiKey: process.env.ANTHROPIC_API_KEY,
        });
        const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(post.category)}`;
        // IG strips URL clickability in captions — direct readers via bio link.
        const navHint = `📖 อ่านบทความเต็มที่ลิงก์ใน bio (${siteUrl.replace(/^https?:\/\//, "")})`;
        const caption = `${hook}\n\n${navHint}\n\n${hashtags}`;

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
    } else if (doIg && !igEnabled) {
      result.ig = "skipped:INSTAGRAM_AUTOPOST_ENABLED!=true";
    } else if (doIg) {
      result.ig = "already_posted";
    }

    results.push(result);
  }

  return NextResponse.json({ processed: results.length, results });
}
