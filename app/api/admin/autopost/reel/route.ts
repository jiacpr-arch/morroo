/**
 * Admin endpoint for queueing an IG Reel.
 *
 * Reels need a pre-rendered MP4. Generating the video server-side blows past
 * Vercel's function budget (ffmpeg + transcoding), so the admin uploads the
 * MP4 elsewhere and pastes the public URL here. We persist the URL on
 * blog_posts.ig_reel_video_url so the standard retry pipeline can pick it up
 * (or the admin can hit "Post now" to publish immediately).
 *
 * POST /api/admin/autopost/reel  { slug, videoUrl, postNow?: boolean }
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { runAutopostRetry } from "@/app/api/autopost/retry/route";

export const runtime = "nodejs";
export const maxDuration = 60;

export async function POST(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();
  if ((profile as { role?: string } | null)?.role !== "admin") {
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }

  let body: { slug?: string; videoUrl?: string; postNow?: boolean } = {};
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "Invalid JSON body" }, { status: 400 });
  }

  const slug = body.slug?.trim();
  const videoUrl = body.videoUrl?.trim();
  if (!slug || !videoUrl) {
    return NextResponse.json({ error: "slug and videoUrl required" }, { status: 400 });
  }
  if (!/^https:\/\//i.test(videoUrl)) {
    return NextResponse.json(
      { error: "videoUrl must be https://" },
      { status: 400 },
    );
  }

  const { error } = await supabase
    .from("blog_posts")
    .update({ ig_reel_video_url: videoUrl })
    .eq("slug", slug);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  if (body.postNow) {
    try {
      const result = await runAutopostRetry({ platform: "ig_reel", slug, limit: 1 });
      return NextResponse.json({ queued: true, posted: result });
    } catch (err) {
      return NextResponse.json(
        { queued: true, error: String(err) },
        { status: 500 },
      );
    }
  }

  return NextResponse.json({ queued: true });
}
