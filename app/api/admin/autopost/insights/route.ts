/**
 * Admin insights endpoint — returns the most recent insights snapshot per
 * (slug, media_type) plus the matching blog_posts row title/cover for display.
 *
 * GET /api/admin/autopost/insights
 *   ?refresh=1 → trigger a fresh pull from Graph API for the most recent
 *               posts (slow; for admin "refresh" button only). Without it
 *               the response is read-only off ig_insights_snapshots.
 */

import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { fetchIgInsights, type IgMediaType } from "@/lib/instagram-insights";

export const runtime = "nodejs";
export const maxDuration = 60;

interface BlogRow {
  slug: string;
  title: string;
  cover_image: string | null;
  ig_post_id: string | null;
  ig_story_id: string | null;
  ig_carousel_id: string | null;
  ig_reel_id: string | null;
}

async function snapshotAllRecent(): Promise<number> {
  const admin = createAdminClient();
  // Snapshot the 25 most recent blog_posts with any IG id. Limit keeps the
  // Graph API call count predictable and inside Vercel's 60 s budget.
  const { data, error } = await admin
    .from("blog_posts")
    .select("slug, ig_post_id, ig_story_id, ig_carousel_id, ig_reel_id")
    .or("ig_post_id.not.is.null,ig_story_id.not.is.null,ig_carousel_id.not.is.null,ig_reel_id.not.is.null")
    .order("published_at", { ascending: false })
    .limit(25);

  if (error) throw new Error(error.message);

  let count = 0;
  for (const row of data ?? []) {
    const targets: { mediaId: string; type: IgMediaType }[] = [];
    if (row.ig_post_id) targets.push({ mediaId: row.ig_post_id, type: "feed" });
    if (row.ig_story_id) targets.push({ mediaId: row.ig_story_id, type: "story" });
    if (row.ig_carousel_id) targets.push({ mediaId: row.ig_carousel_id, type: "carousel" });
    if (row.ig_reel_id) targets.push({ mediaId: row.ig_reel_id, type: "reel" });

    for (const t of targets) {
      const snap = await fetchIgInsights(t.mediaId, t.type);
      if (!snap) continue;
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
      count += 1;
    }
  }
  return count;
}

export async function GET(request: Request) {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();
  if ((profile as { role?: string } | null)?.role !== "admin") {
    return NextResponse.json({ error: "Admin only" }, { status: 403 });
  }

  const refresh = new URL(request.url).searchParams.get("refresh") === "1";
  let refreshedCount = 0;
  if (refresh) {
    try {
      refreshedCount = await snapshotAllRecent();
    } catch (err) {
      return NextResponse.json(
        { error: `refresh failed: ${String(err).slice(0, 200)}` },
        { status: 500 },
      );
    }
  }

  // Pull the latest snapshot per (slug, media_type). Easier in SQL via
  // DISTINCT ON, but we don't have that exposed — fetch all recent snapshots,
  // then dedupe in memory by (slug, media_type) since the rows are small.
  const { data: snaps, error: snapErr } = await supabase
    .from("ig_insights_snapshots")
    .select("slug, media_id, media_type, reach, likes, saves, comments, shares, profile_visits, video_views, captured_at")
    .order("captured_at", { ascending: false })
    .limit(500);
  if (snapErr) return NextResponse.json({ error: snapErr.message }, { status: 500 });

  const latestByKey = new Map<string, typeof snaps[number]>();
  for (const s of snaps ?? []) {
    const key = `${s.slug}::${s.media_type}`;
    if (!latestByKey.has(key)) latestByKey.set(key, s);
  }

  const slugs = Array.from(new Set(Array.from(latestByKey.values()).map((s) => s.slug)));
  let posts: BlogRow[] = [];
  if (slugs.length) {
    const { data: postsData } = await supabase
      .from("blog_posts")
      .select("slug, title, cover_image, ig_post_id, ig_story_id, ig_carousel_id, ig_reel_id")
      .in("slug", slugs);
    posts = (postsData as BlogRow[] | null) ?? [];
  }
  const postBySlug = new Map(posts.map((p) => [p.slug, p]));

  const items = Array.from(latestByKey.values()).map((s) => ({
    ...s,
    title: postBySlug.get(s.slug)?.title ?? s.slug,
    cover_image: postBySlug.get(s.slug)?.cover_image ?? null,
  }));

  return NextResponse.json({ items, refreshedCount });
}
