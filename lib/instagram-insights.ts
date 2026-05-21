/**
 * Instagram Insights helper.
 *
 * Fetches per-media metrics from the Graph API. Different media types support
 * different metric sets — Meta returns an error if you request an unsupported
 * one — so we narrow per type.
 *
 * Reference: https://developers.facebook.com/docs/instagram-platform/api-reference/instagram-media/insights
 */

import { getLatestUserToken } from "@/lib/facebook";

export type IgMediaType = "feed" | "story" | "carousel" | "reel";

export interface IgInsightSnapshot {
  reach: number | null;
  likes: number | null;
  saves: number | null;
  comments: number | null;
  shares: number | null;
  profile_visits: number | null;
  video_views: number | null;
  raw: unknown;
}

/**
 * Metric set per media type. Keeping these in sync with Graph API v24 docs;
 * unsupported metrics return error code 100 ("metric not supported").
 */
const METRICS: Record<IgMediaType, string[]> = {
  feed: ["reach", "likes", "saves", "comments", "shares", "profile_visits"],
  carousel: ["reach", "likes", "saves", "comments", "shares", "profile_visits"],
  story: ["reach", "replies", "shares", "profile_visits"],
  reel: ["reach", "likes", "comments", "shares", "saves", "plays", "ig_reels_video_view_total_time"],
};

export async function fetchIgInsights(
  mediaId: string,
  mediaType: IgMediaType,
): Promise<IgInsightSnapshot | null> {
  const token = await getLatestUserToken();
  if (!token) {
    console.error("[ig-insights] no token available");
    return null;
  }

  const metric = METRICS[mediaType].join(",");
  const res = await fetch(
    `https://graph.facebook.com/v24.0/${mediaId}/insights?metric=${metric}&access_token=${token}`,
  );
  const data = await res.json();
  if (!res.ok || data.error) {
    console.error(
      `[ig-insights] fetch failed mediaId=${mediaId} type=${mediaType}:`,
      JSON.stringify(data),
    );
    return null;
  }

  // Graph API returns { data: [{ name, values: [{value}] }, ...] }.
  // Flatten into a name→value lookup.
  const values: Record<string, number> = {};
  for (const item of data.data ?? []) {
    const v = item.values?.[0]?.value;
    if (typeof v === "number") values[item.name] = v;
  }

  return {
    reach: values.reach ?? null,
    likes: values.likes ?? null,
    saves: values.saves ?? null,
    comments: values.comments ?? null,
    shares: values.shares ?? null,
    profile_visits: values.profile_visits ?? null,
    video_views: values.plays ?? values.video_views ?? null,
    raw: data,
  };
}
