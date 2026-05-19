/**
 * Instagram Graph API publisher — 2-step container/publish flow.
 *
 * Required env vars:
 *   INSTAGRAM_BUSINESS_ACCOUNT_ID — IG Business Account ID linked to the FB Page
 *   META_SYSTEM_USER_TOKEN        — preferred; Business Portfolio system user
 *                                   token with `instagram_basic` +
 *                                   `instagram_content_publish` permissions.
 *   FACEBOOK_USER_TOKEN           — legacy fallback, same priority chain as
 *                                   `lib/facebook.ts` (see getLatestUserToken).
 *
 * IG-specific constraints:
 *   - image_url must be a public JPEG/PNG (no webp); IG fetches it server-side
 *   - caption max 2200 chars, max 30 hashtags
 *   - no clickable URLs in caption — direct readers to "link in bio" instead
 *   - one publish per day per account is the soft rate limit; 25/day hard cap
 */

import { getLatestUserToken } from "@/lib/facebook";

/**
 * Best-effort check whether IG actually published a post we just attempted.
 *
 * The publish API occasionally returns a failure response (rate-limit hit
 * after the side-effect, transient network blip) even though IG accepted the
 * media. Without this check the row stays `ig_post_id IS NULL`, the cron
 * picks it up the next day, and we get a duplicate on the account.
 *
 * Feed: match by caption prefix within the last 15 minutes.
 * Story: caption isn't supported, so we take the most recent active story
 *        within the window — the publish call we just made is almost
 *        certainly it.
 */
async function findRecentlyPublishedMedia(
  igAccountId: string,
  token: string,
  match: { captionPrefix?: string; story?: boolean },
): Promise<string | null> {
  const edge = match.story ? "stories" : "media";
  try {
    const res = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/${edge}?fields=id,caption,timestamp&limit=5&access_token=${encodeURIComponent(token)}`,
    );
    const data = await res.json();
    if (!res.ok || !Array.isArray(data.data)) return null;
    const cutoff = Date.now() - 15 * 60 * 1000;
    for (const m of data.data as Array<{ id: string; caption?: string; timestamp?: string }>) {
      const ts = m.timestamp ? new Date(m.timestamp).getTime() : NaN;
      if (!Number.isFinite(ts) || ts < cutoff) continue;
      if (match.captionPrefix) {
        if (m.caption && m.caption.startsWith(match.captionPrefix)) return m.id;
      } else {
        return m.id;
      }
    }
  } catch (err) {
    console.warn("[instagram] verification fetch failed:", err);
  }
  return null;
}

export async function postToInstagram(post: {
  imageUrl: string;
  caption: string;
}): Promise<string> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) {
    throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  }

  const token = await getLatestUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  // Step 1: Create media container — retry on FB error 100 ("does not exist")
  // since the Supabase Storage CDN sometimes hasn't propagated the upload when
  // IG's server-side fetcher first hits the URL.
  let containerId: string | null = null;
  for (let attempt = 0; attempt < 3; attempt++) {
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
    if (containerRes.ok && containerData.id) {
      containerId = containerData.id;
      break;
    }
    const code = containerData.error?.code;
    if (code === 100 && attempt < 2) {
      await new Promise((r) => setTimeout(r, (attempt + 1) * 3000));
      continue;
    }
    console.error("[instagram] container create failed:", JSON.stringify(containerData));
    throw new Error(containerData.error?.message ?? `HTTP ${containerRes.status}`);
  }
  if (!containerId) {
    throw new Error("Instagram container creation exhausted retries");
  }

  // Step 2: Publish the container
  // IG docs note containers may take a few seconds to be ready for publish on
  // larger images — short retry loop with backoff handles transient "not ready".
  let publishError: Error | null = null;
  publish: for (let attempt = 0; attempt < 3; attempt++) {
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
    publishError = new Error(publishData.error?.message ?? `HTTP ${publishRes.status}`);
    break publish;
  }

  // Publish reported failure — but IG may have accepted the post anyway
  // (rate-limit response returned after the side-effect, network blip).
  // Verify before throwing; otherwise the next cron run picks up the same
  // row (ig_post_id IS NULL) and creates a duplicate.
  const recovered = await findRecentlyPublishedMedia(igAccountId, token, {
    captionPrefix: post.caption.slice(0, 80),
  });
  if (recovered) {
    console.warn(
      `[instagram] publish errored but post found on account: id=${recovered} container=${containerId} err=${publishError?.message}`,
    );
    return recovered;
  }
  throw publishError ?? new Error("Instagram publish exhausted retries");
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

  const token = await getLatestUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  // Container creation has a transient race with Supabase Storage CDN
  // propagation — IG's server-side fetcher occasionally reports "The requested
  // resource does not exist" (FB error code 100) when it polls the image URL
  // before the upload has finished propagating. Short retry with backoff fixes it.
  let containerId: string | null = null;
  for (let attempt = 0; attempt < 3; attempt++) {
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
    if (containerRes.ok && containerData.id) {
      containerId = containerData.id;
      break;
    }
    const code = containerData.error?.code;
    // 100 = "does not exist" (image URL fetch failed); retry once with backoff.
    // Anything else is a real error — fail fast.
    if (code === 100 && attempt < 2) {
      await new Promise((r) => setTimeout(r, (attempt + 1) * 3000));
      continue;
    }
    console.error("[instagram] story container create failed:", JSON.stringify(containerData));
    throw new Error(containerData.error?.message ?? `HTTP ${containerRes.status}`);
  }
  if (!containerId) {
    throw new Error("Instagram story container creation exhausted retries");
  }

  let publishError: Error | null = null;
  publish: for (let attempt = 0; attempt < 3; attempt++) {
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
    publishError = new Error(publishData.error?.message ?? `HTTP ${publishRes.status}`);
    break publish;
  }

  // Same false-negative recovery as feed: check active stories before throwing
  // so the next cron doesn't republish the same image.
  const recovered = await findRecentlyPublishedMedia(igAccountId, token, { story: true });
  if (recovered) {
    console.warn(
      `[instagram] story publish errored but story found on account: id=${recovered} container=${containerId} err=${publishError?.message}`,
    );
    return recovered;
  }
  throw publishError ?? new Error("Instagram story publish exhausted retries");
}
