/**
 * Daily IG insights snapshot cron.
 *
 * For every blog_post with an IG media id (feed / story / carousel / reel),
 * fetch latest insights and append a row to ig_insights_snapshots. Limited to
 * the 25 most recent posts to stay within Graph API rate budgets + Vercel's
 * 60 s function ceiling.
 *
 * Auth: dual-mode (matches the other cron endpoints).
 */

import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { fetchIgInsights, type IgMediaType } from "@/lib/instagram-insights";

export const runtime = "nodejs";
export const maxDuration = 60;

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

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("blog_posts")
    .select("slug, ig_post_id, ig_story_id, ig_carousel_id, ig_reel_id")
    .or("ig_post_id.not.is.null,ig_story_id.not.is.null,ig_carousel_id.not.is.null,ig_reel_id.not.is.null")
    .order("published_at", { ascending: false })
    .limit(25);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  let snapshotsTaken = 0;
  let mediaSkipped = 0;

  for (const row of data ?? []) {
    const targets: { mediaId: string; type: IgMediaType }[] = [];
    if (row.ig_post_id) targets.push({ mediaId: row.ig_post_id, type: "feed" });
    if (row.ig_story_id) targets.push({ mediaId: row.ig_story_id, type: "story" });
    if (row.ig_carousel_id) targets.push({ mediaId: row.ig_carousel_id, type: "carousel" });
    if (row.ig_reel_id) targets.push({ mediaId: row.ig_reel_id, type: "reel" });

    for (const t of targets) {
      const snap = await fetchIgInsights(t.mediaId, t.type);
      if (!snap) {
        mediaSkipped += 1;
        continue;
      }
      await admin.from("ig_insights_snapshots").insert({
        slug: row.slug,
        media_id: t.mediaId,
        media_type: t.type,
        reach: snap.reach,
        likes: snap.likes,
        saves: snap.saves,
        comments: snap.comments,
        shares: snap.shares,
        profile_visits: snap.profile_visits,
        video_views: snap.video_views,
        raw: snap.raw,
      });
      snapshotsTaken += 1;
    }
  }

  return NextResponse.json({ snapshotsTaken, mediaSkipped });
}
