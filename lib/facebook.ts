/**
 * Facebook Page posting helper
 *
 * Required env vars:
 *   FACEBOOK_PAGE_ID    – your Page's numeric ID
 *   FACEBOOK_PAGE_TOKEN – long-lived Page Access Token
 *   NEXT_PUBLIC_SITE_URL – e.g. https://morroo.com
 */

export async function postToFacebook(post: {
  title: string;
  description: string;
  slug: string;
  coverImage: string | null;
}): Promise<void> {
  const pageId = process.env.FACEBOOK_PAGE_ID;
  const token = process.env.FACEBOOK_PAGE_TOKEN;
  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com";

  if (!pageId || !token) {
    console.log("[facebook] FACEBOOK_PAGE_ID or FACEBOOK_PAGE_TOKEN not set — skipping");
    return;
  }

  const articleUrl = `${siteUrl}/blog/${post.slug}`;
  const message = `📚 ${post.title}\n\n${post.description}\n\nอ่านต่อ → ${articleUrl}`;

  // Use link post (with OG preview) if no explicit cover image URL,
  // otherwise use photo post so our generated cover appears.
  let endpoint: string;
  let body: Record<string, string>;

  if (post.coverImage) {
    // Photo post — attach the cover image URL + caption
    endpoint = `https://graph.facebook.com/v22.0/${pageId}/photos`;
    body = {
      url: post.coverImage,
      caption: message,
      access_token: token,
    };
  } else {
    // Link post — Facebook will scrape OG tags for thumbnail
    endpoint = `https://graph.facebook.com/v22.0/${pageId}/feed`;
    body = {
      message,
      link: articleUrl,
      access_token: token,
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
