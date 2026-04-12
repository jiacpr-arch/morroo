/**
 * Facebook Page posting helper
 *
 * Required env vars:
 *   FACEBOOK_PAGE_ID     – your Page's numeric ID
 *   FACEBOOK_USER_TOKEN  – long-lived User Access Token (60 days)
 *   NEXT_PUBLIC_SITE_URL – e.g. https://morroo.com
 *
 * The code fetches a fresh Page Access Token at runtime using the
 * User Token, so you never need to manually exchange tokens.
 */

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
}): Promise<void> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  const userToken = process.env.FACEBOOK_USER_TOKEN;
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com";

  if (!pageId || !userToken) {
    console.log("[facebook] FACEBOOK_PAGE_ID or FACEBOOK_USER_TOKEN not set — skipping");
    return;
  }

  // Fetch fresh Page Token at runtime
  const pageToken = await getPageToken(pageId, userToken);
  if (!pageToken) return;

  const articleUrl = `${siteUrl}/blog/${post.slug}`;
  const message = `📚 ${post.title}\n\n${post.description}\n\nอ่านต่อ → ${articleUrl}`;

  let endpoint: string;
  let body: Record<string, string>;

  if (post.coverImage) {
    endpoint = `https://graph.facebook.com/v24.0/${pageId}/photos`;
    body = {
      url: post.coverImage,
      caption: message,
      access_token: pageToken,
    };
  } else {
    endpoint = `https://graph.facebook.com/v24.0/${pageId}/feed`;
    body = {
      message,
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
  } else {
    console.log(`[facebook] posted: id=${data.id ?? data.post_id} slug=${post.slug}`);
  }
}
