/**
 * Facebook Page posting helper — with auto-refreshing token
 *
 * Required env vars:
 *   FACEBOOK_PAGE_ID     – morroo Page's numeric ID
 *   FACEBOOK_APP_ID      – morroo App ID (developers.facebook.com)
 *   FACEBOOK_APP_SECRET  – morroo App Secret
 *   FACEBOOK_USER_TOKEN  – initial long-lived User Access Token (60 days)
 *   NEXT_PUBLIC_SITE_URL – e.g. https://morroo.com
 *
 * Token auto-refresh: every time the blog cron runs, the code
 * exchanges the current User Token for a fresh 60-day token and
 * stores it in Supabase. As long as the cron runs at least once
 * every 60 days (it runs 2x/week), the token never expires.
 *
 * IMPORTANT: when switching to a new FB Page, delete the cached token:
 *   DELETE FROM app_settings WHERE key = 'facebook_user_token';
 */

import { createAdminClient } from "@/lib/supabase/admin";

/** Exchange current User Token for a fresh long-lived one (60 days) */
async function refreshUserToken(currentToken: string): Promise<string | null> {
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

/** Get the latest User Token — check Supabase first, fallback to env var */
async function getLatestUserToken(): Promise<string | null> {
  const supabase = createAdminClient();
  const envToken = process.env.FACEBOOK_USER_TOKEN;

  // Try to get stored token from Supabase
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "facebook_user_token")
    .maybeSingle();

  return data?.value ?? envToken ?? null;
}

/** Save refreshed token to Supabase for next use */
async function saveUserToken(token: string): Promise<void> {
  const supabase = createAdminClient();
  await supabase
    .from("app_settings")
    .upsert({ key: "facebook_user_token", value: token, updated_at: new Date().toISOString() });
}

/** Get Page Access Token from User Token */
async function getPageToken(pageId: string, userToken: string): Promise<string | null> {
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
  coverImage: string | null;
  hook?: string;
}): Promise<string> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com";

  if (!pageId) {
    throw new Error("FACEBOOK_PAGE_ID not set");
  }

  // Step 1: Get latest User Token (from Supabase or env)
  const currentToken = await getLatestUserToken();
  if (!currentToken) {
    throw new Error("No Facebook user token found");
  }

  // Step 2: Refresh token (extends 60 days from now)
  const freshToken = await refreshUserToken(currentToken);
  if (freshToken && freshToken !== currentToken) {
    await saveUserToken(freshToken);
  }

  // Step 3: Get Page Token
  const pageToken = await getPageToken(pageId, freshToken ?? currentToken);
  if (!pageToken) {
    throw new Error("Failed to obtain Facebook Page token");
  }

  // Step 4: Post to Facebook
  const articleUrl = `${siteUrl}/blog/${post.slug}`;
  const body_text = post.hook
    ? `${post.hook}\n\nอ่านต่อ → ${articleUrl}`
    : `📚 ${post.title}\n\n${post.description}\n\nอ่านต่อ → ${articleUrl}`;

  let endpoint: string;
  let body: Record<string, string>;

  if (post.coverImage) {
    endpoint = `https://graph.facebook.com/v24.0/${pageId}/photos`;
    body = {
      url: post.coverImage,
      caption: body_text,
      access_token: pageToken,
    };
  } else {
    endpoint = `https://graph.facebook.com/v24.0/${pageId}/feed`;
    body = {
      message: body_text,
      link: articleUrl,
      access_token: pageToken,
    };
  }

  const res = await fetch(endpoint, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  const data = await res.json();

  if (!res.ok || data.error) {
    console.error("[facebook] post failed:", JSON.stringify(data));
    throw new Error(data.error?.message ?? `HTTP ${res.status}`);
  }

  const postId: string = data.id ?? data.post_id ?? "";
  console.log(`[facebook] posted: id=${postId} slug=${post.slug}`);
  return postId;
}
