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
  // IG's server-side fetcher first hits the URL. Rate limit errors fail fast
  // (daily quota — retrying within minutes wastes more calls and can't recover).
  let containerId: string | null = null;
  for (let attempt = 0; attempt < 4; attempt++) {
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
    const msg = containerData.error?.message ?? `HTTP ${containerRes.status}`;
    if (isRateLimitError(msg)) {
      console.error("[instagram] container hit daily rate limit, aborting:", msg);
      throw new Error(`Meta daily rate limit reached — cron will retry next day: ${msg}`);
    }
    if (code === 100 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] container retry after ${delay}ms: ${msg}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] container create failed:", JSON.stringify(containerData));
    throw new Error(msg);
  }
  if (!containerId) {
    throw new Error("Instagram container creation exhausted retries");
  }

  // Step 2: Publish the container
  // IG docs note containers may take a few seconds to be ready for publish on
  // larger images — short retry loop with backoff handles transient "not ready".
  let publishError: Error | null = null;
  publish: for (let attempt = 0; attempt < 4; attempt++) {
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
    const msg = publishData.error?.message ?? `HTTP ${publishRes.status}`;
    if (isRateLimitError(msg)) {
      console.error("[instagram] publish hit daily rate limit, aborting:", msg);
      throw new Error(`Meta daily rate limit reached — cron will retry next day: ${msg}`);
    }
    // 9007 = "Media ID is not available" — container still processing
    if (code === 9007 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] publish retry after ${delay}ms: ${msg}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] publish failed:", JSON.stringify(publishData));
    publishError = new Error(msg);
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
 *   - Optional `linkUrl` adds a tappable IG Story link sticker. Stickers
 *     require business/creator accounts; the call gracefully falls back to a
 *     plain story (no sticker) if Graph rejects the param.
 */
export async function postStoryToInstagram(post: {
  imageUrl: string;
  linkUrl?: string;
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
  //
  // When linkUrl is set, we first try creating with a `link_data` sticker. If
  // Graph rejects the sticker param (e.g. account isn't eligible — code 100
  // with subcode hinting at sticker) we retry without the sticker so the
  // Story still posts. The sticker is sugar; the story itself is the goal.
  const buildContainerBody = (withSticker: boolean) =>
    JSON.stringify({
      media_type: "STORIES",
      image_url: post.imageUrl,
      ...(withSticker && post.linkUrl ? { link_data: { url: post.linkUrl } } : {}),
      access_token: token,
    });

  let containerId: string | null = null;
  let stickerEligible = Boolean(post.linkUrl);
  for (let attempt = 0; attempt < 4; attempt++) {
    const containerRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: buildContainerBody(stickerEligible),
      },
    );
    const containerData = await containerRes.json();
    if (containerRes.ok && containerData.id) {
      containerId = containerData.id;
      if (stickerEligible) {
        console.log("[instagram] story posted with link sticker:", post.linkUrl);
      }
      break;
    }
    const code = containerData.error?.code;
    const message: string = containerData.error?.message ?? "";
    // If the link sticker is rejected (account ineligible / param unsupported),
    // strip it and retry on this same attempt counter — don't waste the budget.
    if (
      stickerEligible &&
      (message.toLowerCase().includes("link") || /link_data|sticker/i.test(message))
    ) {
      console.warn(
        "[instagram] story link sticker rejected, retrying without:",
        message,
      );
      stickerEligible = false;
      continue;
    }
    // Rate limit is daily quota — abort fast so we don't burn more calls.
    if (isRateLimitError(message)) {
      console.error("[instagram] story container hit daily rate limit, aborting:", message);
      throw new Error(`Meta daily rate limit reached — cron will retry next day: ${message}`);
    }
    // 100 = "does not exist" (image URL fetch failed); retry with backoff.
    if (code === 100 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] story container retry after ${delay}ms: ${message}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] story container create failed:", JSON.stringify(containerData));
    throw new Error(message || `HTTP ${containerRes.status}`);
  }
  if (!containerId) {
    throw new Error("Instagram story container creation exhausted retries");
  }

  let publishError: Error | null = null;
  publish: for (let attempt = 0; attempt < 4; attempt++) {
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
    const msg = publishData.error?.message ?? `HTTP ${publishRes.status}`;
    if (isRateLimitError(msg)) {
      console.error("[instagram] story publish hit daily rate limit, aborting:", msg);
      throw new Error(`Meta daily rate limit reached — cron will retry next day: ${msg}`);
    }
    if (code === 9007 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] story publish retry after ${delay}ms: ${msg}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] story publish failed:", JSON.stringify(publishData));
    publishError = new Error(msg);
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

/**
 * Publish an Instagram carousel (2–10 images) via the Graph API.
 *
 * Three-step flow:
 *   1. POST {ig-id}/media for each image_url with `is_carousel_item=true` →
 *      individual child container IDs.
 *   2. POST {ig-id}/media with `media_type=CAROUSEL` + `children=<ids>` +
 *      caption → parent container ID.
 *   3. POST {ig-id}/media_publish with the parent container ID.
 *
 * IG carousel constraints:
 *   - 2–10 children
 *   - all children must share the same aspect ratio (we use 1:1, 1080×1080)
 *   - caption attaches to the first slide and is up to 2200 chars
 *   - each child image_url must be a public JPEG (no webp, no PNG with alpha)
 *
 * Same FB error code 100 / 9007 retry handling as feed posts since the
 * Supabase Storage propagation race + container-not-ready race apply here too.
 * Rate limit errors ("Application request limit reached") FAIL FAST — these are
 * daily quotas (reset at midnight UTC) and retrying within minutes both wastes
 * more API calls and can't recover. The cron will retry next day naturally.
 */
function isRateLimitError(errorMsg: string): boolean {
  return (
    errorMsg.includes("Application request limit reached") ||
    errorMsg.includes("rate limit") ||
    errorMsg.includes("quota") ||
    errorMsg.toLowerCase().includes("temporarily unavailable")
  );
}

export async function postCarouselToInstagram(post: {
  imageUrls: string[];
  caption: string;
}): Promise<string> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) {
    throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  }
  if (post.imageUrls.length < 2 || post.imageUrls.length > 10) {
    throw new Error(`Carousel needs 2–10 slides (got ${post.imageUrls.length})`);
  }

  const token = await getLatestUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  // Step 1: create one child container per image with is_carousel_item=true.
  // Run sequentially so we can attribute "which slide failed" cleanly in logs.
  // If we hit the daily rate limit on ANY slide, abort the whole carousel —
  // continuing to retry just burns more of tomorrow's quota.
  const childIds: string[] = [];
  for (let i = 0; i < post.imageUrls.length; i++) {
    let childId: string | null = null;
    for (let attempt = 0; attempt < 4; attempt++) {
      const childRes = await fetch(
        `https://graph.facebook.com/v24.0/${igAccountId}/media`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            image_url: post.imageUrls[i],
            is_carousel_item: true,
            access_token: token,
          }),
        },
      );
      const childData = await childRes.json();
      if (childRes.ok && childData.id) {
        childId = childData.id;
        break;
      }
      const code = childData.error?.code;
      const msg = childData.error?.message ?? `HTTP ${childRes.status}`;
      if (isRateLimitError(msg)) {
        console.error(
          `[instagram] carousel child[${i}] hit daily rate limit, aborting:`,
          msg,
        );
        throw new Error(
          `Meta daily rate limit reached on carousel slide ${i + 1} — cron will retry next day: ${msg}`,
        );
      }
      if (code === 100 && attempt < 3) {
        const delay = (attempt + 1) * 3000;
        console.log(`[instagram] carousel child[${i}] retry after ${delay}ms: ${msg}`);
        await new Promise((r) => setTimeout(r, delay));
        continue;
      }
      console.error(
        `[instagram] carousel child[${i}] create failed:`,
        JSON.stringify(childData),
      );
      throw new Error(msg + (msg.includes("slide") ? "" : ` on slide ${i + 1}`));
    }
    if (!childId) {
      throw new Error(`Carousel slide ${i + 1} container creation exhausted retries`);
    }
    childIds.push(childId);
  }

  // Step 2: create the carousel parent container.
  let parentId: string | null = null;
  for (let attempt = 0; attempt < 4; attempt++) {
    const parentRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          media_type: "CAROUSEL",
          children: childIds.join(","),
          caption: post.caption.slice(0, 2200),
          access_token: token,
        }),
      },
    );
    const parentData = await parentRes.json();
    if (parentRes.ok && parentData.id) {
      parentId = parentData.id;
      break;
    }
    const code = parentData.error?.code;
    const msg = parentData.error?.message ?? `HTTP ${parentRes.status}`;
    if (isRateLimitError(msg)) {
      console.error("[instagram] carousel parent hit daily rate limit, aborting:", msg);
      throw new Error(`Meta daily rate limit reached on carousel parent — cron will retry next day: ${msg}`);
    }
    if (code === 100 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] carousel parent retry after ${delay}ms: ${msg}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] carousel parent create failed:", JSON.stringify(parentData));
    throw new Error(msg);
  }
  if (!parentId) {
    throw new Error("Instagram carousel parent creation exhausted retries");
  }

  // Step 3: publish the parent container.
  for (let attempt = 0; attempt < 4; attempt++) {
    const publishRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media_publish`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ creation_id: parentId, access_token: token }),
      },
    );
    const publishData = await publishRes.json();
    if (publishRes.ok && publishData.id) {
      console.log(
        `[instagram] carousel posted: id=${publishData.id} parent=${parentId} children=${childIds.length}`,
      );
      return publishData.id;
    }
    const code = publishData.error?.code;
    const msg = publishData.error?.message ?? `HTTP ${publishRes.status}`;
    if (isRateLimitError(msg)) {
      console.error("[instagram] carousel publish hit daily rate limit, aborting:", msg);
      throw new Error(`Meta daily rate limit reached on carousel publish — cron will retry next day: ${msg}`);
    }
    if (code === 9007 && attempt < 3) {
      const delay = (attempt + 1) * 3000;
      console.log(`[instagram] carousel publish retry after ${delay}ms: ${msg}`);
      await new Promise((r) => setTimeout(r, delay));
      continue;
    }
    console.error("[instagram] carousel publish failed:", JSON.stringify(publishData));
    throw new Error(msg);
  }

  throw new Error("Instagram carousel publish exhausted retries");
}

/**
 * Publish an Instagram Reel via the Graph API.
 *
 * Two-step container/publish flow as feed posts, but with `media_type=REELS`
 * and `video_url` instead of `image_url`. IG transcodes the video server-side
 * which takes 5–30 s depending on length, so we poll the container's
 * `status_code` until FINISHED before calling media_publish.
 *
 * IG Reel constraints:
 *   - 9:16 portrait MP4, H.264 codec, AAC audio
 *   - duration 3–90 s; size ≤ 1 GB but ≤ 100 MB strongly recommended
 *   - thumb_offset (ms) selects the cover frame
 *   - share_to_feed=true makes the reel also appear in feed
 *   - caption max 2200 chars, no clickable URLs (link in bio convention)
 */
export async function postReelToInstagram(post: {
  videoUrl: string;
  caption: string;
  thumbOffset?: number;
  shareToFeed?: boolean;
}): Promise<string> {
  const igAccountId = process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID;
  if (!igAccountId) {
    throw new Error("INSTAGRAM_BUSINESS_ACCOUNT_ID not set");
  }

  const token = await getLatestUserToken();
  if (!token) {
    throw new Error("No Facebook user token found");
  }

  // Step 1: create the REELS container. IG fetches the video server-side and
  // begins transcoding; we get the container id back immediately.
  let containerId: string | null = null;
  for (let attempt = 0; attempt < 3; attempt++) {
    const containerRes = await fetch(
      `https://graph.facebook.com/v24.0/${igAccountId}/media`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          media_type: "REELS",
          video_url: post.videoUrl,
          caption: post.caption.slice(0, 2200),
          share_to_feed: post.shareToFeed ?? true,
          thumb_offset: post.thumbOffset ?? 0,
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
    console.error("[instagram] reel container create failed:", JSON.stringify(containerData));
    throw new Error(containerData.error?.message ?? `HTTP ${containerRes.status}`);
  }
  if (!containerId) {
    throw new Error("Instagram reel container creation exhausted retries");
  }

  // Step 2: poll container status until FINISHED (or ERROR). Reels are async —
  // calling media_publish before status=FINISHED returns code 9007.
  // Budget: 8 polls × 5 s = 40 s, fits inside maxDuration=60 with overhead.
  for (let attempt = 0; attempt < 8; attempt++) {
    await new Promise((r) => setTimeout(r, 5000));
    const statusRes = await fetch(
      `https://graph.facebook.com/v24.0/${containerId}?fields=status_code,status&access_token=${token}`,
    );
    const statusData = await statusRes.json();
    if (statusData.status_code === "FINISHED") break;
    if (statusData.status_code === "ERROR") {
      console.error("[instagram] reel transcode error:", JSON.stringify(statusData));
      throw new Error(`Reel transcode error: ${statusData.status ?? "unknown"}`);
    }
    if (attempt === 7) {
      throw new Error(`Reel container not ready after 40s (status=${statusData.status_code})`);
    }
  }

  // Step 3: publish.
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
      console.log(`[instagram] reel posted: id=${publishData.id} container=${containerId}`);
      return publishData.id;
    }
    const code = publishData.error?.code;
    if (code === 9007 && attempt < 2) {
      await new Promise((r) => setTimeout(r, (attempt + 1) * 3000));
      continue;
    }
    console.error("[instagram] reel publish failed:", JSON.stringify(publishData));
    throw new Error(publishData.error?.message ?? `HTTP ${publishRes.status}`);
  }

  throw new Error("Instagram reel publish exhausted retries");
}
