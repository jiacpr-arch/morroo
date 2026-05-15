/**
 * Story image preview — composes the 9:16 Story variant on the fly and streams
 * it back as JPEG. Use to eyeball the framing before flipping
 * FACEBOOK_STORY_AUTOPOST_ENABLED on.
 *
 * GET /api/autopost/story-preview?secret=…&slug=…
 *   slug       – blog_posts.slug; pulls cover_image + title from Supabase
 *   coverUrl   – alternative: bypass DB and compose from a direct URL
 *   headline   – override CTA bar headline (defaults to article title or static fallback)
 *
 * No DB writes, no Supabase Storage uploads, no FB/IG calls. Safe to hit repeatedly.
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { composeStoryImage } from "@/lib/autopost-story-image";

export const runtime = "nodejs";
export const maxDuration = 30;

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);

  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const slug = searchParams.get("slug");
  const coverUrlParam = searchParams.get("coverUrl");
  const headlineParam = searchParams.get("headline") ?? undefined;

  let coverUrl: string | null = coverUrlParam;
  let headline: string | undefined = headlineParam;
  if (!coverUrl) {
    if (!slug) {
      return NextResponse.json(
        { error: "Provide ?slug=… or ?coverUrl=…" },
        { status: 400 },
      );
    }
    const supabase = createAdminClient();
    const { data, error } = await supabase
      .from("blog_posts")
      .select("cover_image, title")
      .eq("slug", slug)
      .maybeSingle();
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }
    if (!data?.cover_image) {
      return NextResponse.json(
        { error: `No cover_image for slug=${slug}` },
        { status: 404 },
      );
    }
    coverUrl = data.cover_image;
    headline = headline ?? data.title;
  }

  const fetchRes = await fetch(coverUrl);
  if (!fetchRes.ok) {
    return NextResponse.json(
      { error: `Failed to fetch cover (${fetchRes.status})` },
      { status: 502 },
    );
  }
  const buffer = Buffer.from(await fetchRes.arrayBuffer());

  let storyBuffer: Buffer;
  try {
    storyBuffer = await composeStoryImage(buffer, { headline });
  } catch (err) {
    return NextResponse.json(
      { error: `Compose failed: ${String(err).slice(0, 200)}` },
      { status: 500 },
    );
  }

  return new Response(new Uint8Array(storyBuffer), {
    status: 200,
    headers: {
      "Content-Type": "image/jpeg",
      "Cache-Control": "private, max-age=60",
      "Content-Disposition": `inline; filename="${slug ?? "story"}-preview.jpg"`,
    },
  });
}
