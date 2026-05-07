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

import sharp from "sharp";
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
  // Force canonical www domain — `morroo.com` redirects to `www.morroo.com`,
  // and FB's URL validator/scraper rejects URLs that 301 (link param fails,
  // autolinker truncates at `.com`).
  const rawSiteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://www.morroo.com";
  const siteUrl = rawSiteUrl.replace(/^https:\/\/morroo\.com/, "https://www.morroo.com");

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
  // FB caption auto-link ตัด path ของ URL ทุกความยาว — กด URL ได้แค่ domain
  // แก้โดยใส่ navigation hint ให้ user ไปต่อหา "บทความ" เมนูเองที่ homepage
  const navHint = `📖 อ่านบทความเต็มที่ ${siteUrl} → เมนู "บทความ"`;
  const photo_caption = post.hook
    ? `${post.hook}\n\n${navHint}`
    : `📚 ${post.title}\n\n${post.description}\n\n${navHint}`;
  const feed_message = post.hook
    ? `${post.hook}\n\n${articleUrl}`
    : `📚 ${post.title}\n\n${post.description}\n\n${articleUrl}`;

  let res: Response;

  if (post.coverImage) {
    // Download cover and convert to JPEG before upload — FB sometimes
    // rejects fetching from Supabase Storage URLs with cache-bust query
    // strings, and gpt-image-1 PNGs occasionally have format quirks.
    const imgRes = await fetch(post.coverImage);
    if (!imgRes.ok) {
      throw new Error(`Failed to fetch cover image: HTTP ${imgRes.status}`);
    }
    const rawBuffer = Buffer.from(await imgRes.arrayBuffer());
    const jpegBuffer = await sharp(rawBuffer).jpeg({ quality: 90 }).toBuffer();

    const fd = new FormData();
    fd.append("source", new Blob([new Uint8Array(jpegBuffer)], { type: "image/jpeg" }), "cover.jpg");
    fd.append("caption", photo_caption);
    fd.append("access_token", pageToken);

    res = await fetch(`https://graph.facebook.com/v24.0/${pageId}/photos`, {
      method: "POST",
      body: fd,
    });
  } else {
    // No cover: post with explicit `link` param so FB scrapes OG meta and
    // renders a rich link card preview. Requires the domain to be registered
    // under FB App Settings → Basic → App Domains.
    res = await fetch(`https://graph.facebook.com/v24.0/${pageId}/feed`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        message: feed_message,
        link: articleUrl,
        access_token: pageToken,
      }),
    });
  }

  const data = await res.json();

  if (!res.ok || data.error) {
    console.error("[facebook] post failed:", JSON.stringify(data));
    throw new Error(data.error?.message ?? `HTTP ${res.status}`);
  }

  const postId: string = data.post_id ?? data.id ?? "";
  console.log(`[facebook] posted: id=${postId} slug=${post.slug}`);
  return postId;
}
