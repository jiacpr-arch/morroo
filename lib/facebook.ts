/**
 * Facebook Page posting helper.
 *
 * Token priority chain (getLatestUserToken):
 *   1. META_SYSTEM_USER_TOKEN — Business Portfolio system user, never expires.
 *      When set, refresh + cache are skipped (fb_exchange_token rejects system
 *      user tokens with code 190). Preferred for production.
 *   2. app_settings.facebook_user_token — Supabase-cached refreshed user token
 *   3. FACEBOOK_USER_TOKEN — initial long-lived user token (60-day)
 *
 * Required env vars:
 *   FACEBOOK_PAGE_ID            – morroo Page's numeric ID
 *   META_SYSTEM_USER_TOKEN      – preferred; never-expiring system user token
 *   FACEBOOK_APP_ID             – only needed for legacy user-token refresh
 *   FACEBOOK_APP_SECRET         – only needed for legacy user-token refresh
 *   FACEBOOK_USER_TOKEN         – legacy fallback (60-day user token)
 *   NEXT_PUBLIC_SITE_URL        – e.g. https://morroo.com
 *
 * Legacy user-token refresh: every time the blog cron runs, the code
 * exchanges the current User Token for a fresh 60-day token and stores
 * it in Supabase. As long as the cron runs at least once every 60 days
 * it never expires. Skipped under META_SYSTEM_USER_TOKEN.
 *
 * IMPORTANT: when switching to a new FB Page, delete the cached token:
 *   DELETE FROM app_settings WHERE key = 'facebook_user_token';
 */

import { createAdminClient } from "@/lib/supabase/admin";

/** True when a Meta Business Portfolio system user token is configured. */
export function isSystemUserTokenActive(): boolean {
  return Boolean(process.env.META_SYSTEM_USER_TOKEN);
}

/** Exchange current User Token for a fresh long-lived one (60 days) */
export async function refreshUserToken(currentToken: string): Promise<string | null> {
  const appId = process.env.FACEBOOK_APP_ID;
  const appSecret = process.env.FACEBOOK_APP_SECRET;
  if (!appId || !appSecret) return currentToken; // can't refresh, use as-is

  const res = await fetch(
    `https://graph.facebook.com/v24.0/oauth/access_token?grant_type=fb_exchange_token&client_id=${appId}&client_secret=${appSecret}&fb_exchange_token=${currentToken}`
  );
  const data = await res.json();
  if (data.error || !data.access_token) {
    console.error("[facebook] token refresh failed:", JSON.stringify(data));
    return currentToken; // fallback to current token
  }
  console.log("[facebook] token refreshed, expires in", data.expires_in, "seconds");
  return data.access_token;
}

/**
 * Resolve the access token to use for Graph API calls.
 *
 * Priority: META_SYSTEM_USER_TOKEN → Supabase-cached user token → FACEBOOK_USER_TOKEN.
 * System user token short-circuits the DB lookup because it never expires
 * and Vercel env is its single source of truth.
 */
export async function getLatestUserToken(): Promise<string | null> {
  if (process.env.META_SYSTEM_USER_TOKEN) {
    return process.env.META_SYSTEM_USER_TOKEN;
  }

  const supabase = createAdminClient();
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "facebook_user_token")
    .maybeSingle();

  return data?.value ?? process.env.FACEBOOK_USER_TOKEN ?? null;
}

/** Save refreshed token to Supabase for next use */
export async function saveUserToken(token: string): Promise<void> {
  const supabase = createAdminClient();
  await supabase
    .from("app_settings")
    .upsert({ key: "facebook_user_token", value: token, updated_at: new Date().toISOString() });
}

/** Get Page Access Token from User Token */
export async function getPageToken(pageId: string, userToken: string): Promise<string | null> {
  const res = await fetch(
    `https://graph.facebook.com/v24.0/${pageId}?fields=access_token&access_token=${userToken}`
  );
  const data = await res.json();
  if (data.error || !data.access_token) {
    console.error("[facebook] failed to get page token:", JSON.stringify(data));
    return null;
  }
  return data.access_token;
}

export async function postToFacebook(post: {
  title: string;
  description: string;
  slug: string;
  hook?: string;
}): Promise<string> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  // Hardcode canonical URL — env-derived siteUrl gave FB "url invalid" on /feed
  // (matches the same workaround in app/api/autopost/retry/route.ts:209 for LINE).
  const siteUrl = "https://www.morroo.com";

  if (!pageId) {
    throw new Error("FACEBOOK_PAGE_ID not set");
  }

  // Step 1: Get latest User Token (from Supabase or env)
  const currentToken = await getLatestUserToken();
  if (!currentToken) {
    throw new Error("No Facebook user token found");
  }

  // Step 2: Refresh long-lived user token (extends 60 days). Skip under the
  // system user token — fb_exchange_token returns code 190 on system user
  // credentials and there is nothing to refresh (never-expiring).
  let activeToken = currentToken;
  if (!isSystemUserTokenActive()) {
    const freshToken = await refreshUserToken(currentToken);
    if (freshToken && freshToken !== currentToken) {
      await saveUserToken(freshToken);
      activeToken = freshToken;
    }
  }

  // Step 3: Get Page Token
  const pageToken = await getPageToken(pageId, activeToken);
  if (!pageToken) {
    throw new Error("Failed to obtain Facebook Page token");
  }

  // Step 4: Post to Facebook as a feed post with `link` param. FB scrapes
  // OG meta from the article page to render the link preview card, and the
  // full URL in the message body remains clickable to the exact path
  // (photo posts truncate caption autolinks to the domain). Requires the
  // host to be registered under FB App Settings → Basic → App Domains, and
  // the article page must expose absolute og:image / og:title / og:description.
  //
  // Trailing "🔗 <url>" gives readers a second clickable touchpoint after the
  // body copy + matches the rich-caption template assembled by buildFbCaption.
  const articleUrl = `${siteUrl}/blog/${post.slug}`;
  const message = post.hook
    ? `${post.hook}\n\n🔗 ${articleUrl}`
    : `📚 ${post.title}\n\n${post.description}\n\n🔗 ${articleUrl}`;

  const res = await fetch(`https://graph.facebook.com/v24.0/${pageId}/feed`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      message,
      link: articleUrl,
      access_token: pageToken,
    }),
  });

  const data = await res.json();

  if (!res.ok || data.error) {
    console.error("[facebook] post failed:", JSON.stringify({ articleUrl, status: res.status, response: data }));
    throw new Error(data.error?.message ?? `HTTP ${res.status}`);
  }

  const postId: string = data.post_id ?? data.id ?? "";
  console.log(`[facebook] posted: id=${postId} slug=${post.slug}`);
  return postId;
}

/**
 * Publish a Facebook Page photo story via the Graph API.
 *
 * Two-step flow per FB docs:
 *   1. POST {page-id}/photos with published=false → photo_id
 *   2. POST {page-id}/photo_stories with photo_id → story post id
 *
 * Story image constraints:
 *   - 9:16 portrait, 1080×1920 recommended
 *   - JPEG/PNG; max ~4 MB
 *   - Page token must include `pages_manage_posts` + `pages_read_engagement`
 */
export async function postStoryToFacebook(post: {
  imageUrl: string;
}): Promise<string> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  if (!pageId) {
    throw new Error("FACEBOOK_PAGE_ID not set");
  }

  const currentToken = await getLatestUserToken();
  if (!currentToken) {
    throw new Error("No Facebook user token found");
  }

  const pageToken = await getPageToken(pageId, currentToken);
  if (!pageToken) {
    throw new Error("Failed to obtain Facebook Page token");
  }

  // Step 1: Upload as unpublished photo to get a photo_id.
  const photoRes = await fetch(`https://graph.facebook.com/v24.0/${pageId}/photos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      url: post.imageUrl,
      published: false,
      access_token: pageToken,
    }),
  });
  const photoData = await photoRes.json();
  if (!photoRes.ok || photoData.error || !photoData.id) {
    console.error("[facebook] story photo upload failed:", JSON.stringify(photoData));
    throw new Error(photoData.error?.message ?? `HTTP ${photoRes.status}`);
  }
  const photoId: string = photoData.id;

  // Step 2: Publish the photo as a story.
  const storyRes = await fetch(`https://graph.facebook.com/v24.0/${pageId}/photo_stories`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      photo_id: photoId,
      access_token: pageToken,
    }),
  });
  const storyData = await storyRes.json();
  if (!storyRes.ok || storyData.error) {
    console.error("[facebook] story publish failed:", JSON.stringify(storyData));
    throw new Error(storyData.error?.message ?? `HTTP ${storyRes.status}`);
  }

  const storyId: string = storyData.post_id ?? storyData.id ?? photoId;
  console.log(`[facebook] story posted: id=${storyId} photo=${photoId}`);
  return storyId;
}
