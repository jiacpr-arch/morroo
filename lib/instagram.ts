/**
 * Instagram Graph API publisher — 2-step container/publish flow.
 *
 * Required env vars:
 *   INSTAGRAM_BUSINESS_ACCOUNT_ID — IG Business Account ID linked to the FB Page
 *   FACEBOOK_USER_TOKEN           — same long-lived token used for FB posting;
 *                                   must include `instagram_basic` and
 *                                   `instagram_content_publish` permissions.
 *
 * IG-specific constraints:
 *   - image_url must be a public JPEG/PNG (no webp); IG fetches it server-side
 *   - caption max 2200 chars, max 30 hashtags
 *   - no clickable URLs in caption — direct readers to "link in bio" instead
 *   - one publish per day per account is the soft rate limit; 25/day hard cap
 */

import { createAdminClient } from "@/lib/supabase/admin";

/**
 * Reuse the same Supabase-cached User Token as `lib/facebook.ts`. We don't
 * refresh here because postToFacebook() runs first in every flow and already
 * extends the token; calling fb_exchange_token twice in one cron tick would
 * just churn cache for no benefit.
 */
async function getUserToken(): Promise<string | null> {
  const supabase = createAdminClient();
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "facebook_user_token")
    .maybeSingle();
  return data?.value ?? process.env.FACEBOOK_USER_TOKEN ?? null;
}

export async function postToInstagram(post: {
  imageUrl: string;
  caption: string;
}): Promise<string> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) {
    throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  }

  const token = await getUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  // Step 1: Create media container
  const containerRes = await fetch(
    `https://graph.facebook.com/v24.0/${igAccountId}/media`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        image_url: post.imageUrl,
        caption: post.caption.slice(0, 2200),
        access_token: token,
      }),
    },
  );
  const containerData = await containerRes.json();
  if (!containerRes.ok || containerData.error || !containerData.id) {
    console.error("[instagram] container create failed:", JSON.stringify(containerData));
    throw new Error(containerData.error?.message ?? `HTTP ${containerRes.status}`);
  }
  const containerId: string = containerData.id;

  // Step 2: Publish the container
  // IG docs note containers may take a few seconds to be ready for publish on
  // larger images — short retry loop with backoff handles transient "not ready".
  for (let attempt = 0; attempt < 3; attempt++) {
    const publishRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media_publish`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ creation_id: containerId, access_token: token }),
      },
    );
    const publishData = await publishRes.json();
    if (publishRes.ok && publishData.id) {
      console.log(`[instagram] posted: id=${publishData.id} container=${containerId}`);
      return publishData.id;
    }
    const code = publishData.error?.code;
    // 9007 = "Media ID is not available" — container still processing
    if (code === 9007 && attempt < 2) {
      await new Promise((r) => setTimeout(r, (attempt + 1) * 3000));
      continue;
    }
    console.error("[instagram] publish failed:", JSON.stringify(publishData));
    throw new Error(publishData.error?.message ?? `HTTP ${publishRes.status}`);
  }

  throw new Error("Instagram publish exhausted retries");
}

/**
 * Publish an Instagram Story image via the Graph API.
 *
 * Same 2-step container/publish flow as feed posts, with `media_type=STORIES`.
 *
 * IG Story constraints:
 *   - 9:16 portrait (1080×1920 recommended); other ratios are letterboxed
 *   - JPEG/PNG ≤ 8 MB, served over HTTPS
 *   - Stories do not accept captions — text overlays must be baked into the image
 *   - Token requires `instagram_content_publish` permission
 */
export async function postStoryToInstagram(post: {
  imageUrl: string;
}): Promise<string> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) {
    throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  }

  const token = await getUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  const containerRes = await fetch(
    `https://graph.facebook.com/v24.0/${igAccountId}/media`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        media_type: "STORIES",
        image_url: post.imageUrl,
        access_token: token,
      }),
    },
  );
  const containerData = await containerRes.json();
  if (!containerRes.ok || containerData.error || !containerData.id) {
    console.error("[instagram] story container create failed:", JSON.stringify(containerData));
    throw new Error(containerData.error?.message ?? `HTTP ${containerRes.status}`);
  }
  const containerId: string = containerData.id;

  for (let attempt = 0; attempt < 3; attempt++) {
    const publishRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media_publish`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ creation_id: containerId, access_token: token }),
      },
    );
    const publishData = await publishRes.json();
    if (publishRes.ok && publishData.id) {
      console.log(`[instagram] story posted: id=${publishData.id} container=${containerId}`);
      return publishData.id;
    }
    const code = publishData.error?.code;
    if (code === 9007 && attempt < 2) {
      await new Promise((r) => setTimeout(r, (attempt + 1) * 3000));
      continue;
    }
    console.error("[instagram] story publish failed:", JSON.stringify(publishData));
    throw new Error(publishData.error?.message ?? `HTTP ${publishRes.status}`);
  }

  throw new Error("Instagram story publish exhausted retries");
}
