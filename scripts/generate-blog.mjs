/**
 * Blog article generator — runs on GitHub Actions (no Vercel timeout)
 *
 * Required env vars:
 *   SUPABASE_URL
 *   SUPABASE_SERVICE_ROLE_KEY
 *   ANTHROPIC_API_KEY
 *
 * Optional:
 *   TOGETHER_API_KEY         — cover image via FLUX (skipped if absent)
 *   SITE_URL                 — default https://www.morroo.com
 *   FACEBOOK_PAGE_ID
 *   FACEBOOK_ACCESS_TOKEN    — long-lived Page Access Token
 *   FACEBOOK_APP_ID
 *   FACEBOOK_APP_SECRET
 *   ARTICLE_COUNT            — how many articles to generate (default 1)
 */

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const TOGETHER_API_KEY = process.env.TOGETHER_API_KEY;
const SITE_URL = process.env.SITE_URL ?? "https://www.morroo.com";
const FACEBOOK_PAGE_ID = process.env.FACEBOOK_PAGE_ID;
const FACEBOOK_ACCESS_TOKEN = process.env.FACEBOOK_ACCESS_TOKEN;
const FACEBOOK_APP_ID = process.env.FACEBOOK_APP_ID;
const FACEBOOK_APP_SECRET = process.env.FACEBOOK_APP_SECRET;
const ARTICLE_COUNT = Math.max(1, parseInt(process.env.ARTICLE_COUNT ?? "1", 10));

const CATEGORIES = ["ความรู้ทั่วไป", "เตรียมสอบ", "เทคนิคสอบ"];

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
if (!ANTHROPIC_API_KEY) {
  console.error("Missing ANTHROPIC_API_KEY");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

/** Refresh Page Access Token if app credentials are available */
async function refreshPageToken(currentToken) {
  if (!FACEBOOK_APP_ID || !FACEBOOK_APP_SECRET) return currentToken;
  try {
    const res = await fetch(
      `https://graph.facebook.com/v24.0/oauth/access_token?grant_type=fb_exchange_token&client_id=${FACEBOOK_APP_ID}&client_secret=${FACEBOOK_APP_SECRET}&fb_exchange_token=${currentToken}`
    );
    const data = await res.json();
    if (data.access_token) {
      console.log("[facebook] token refreshed, expires in", data.expires_in, "s");
      // Persist refreshed token to app_settings
      await supabase
        .from("app_settings")
        .upsert({ key: "facebook_access_token", value: data.access_token, updated_at: new Date().toISOString() });
      return data.access_token;
    }
  } catch (err) {
    console.error("[facebook] token refresh failed:", err.message);
  }
  return currentToken;
}

async function getPageToken() {
  // Prefer stored token in Supabase over env var
  const { data } = await supabase
    .from("app_settings")
    .select("value")
    .eq("key", "facebook_access_token")
    .maybeSingle();
  return data?.value ?? FACEBOOK_ACCESS_TOKEN ?? null;
}

async function postToFacebook(title, description, slug, coverImage) {
  if (!FACEBOOK_PAGE_ID) return;

  let token = await getPageToken();
  if (!token) {
    console.log("[facebook] no token — skipping post");
    return;
  }

  token = await refreshPageToken(token);

  const articleUrl = `${SITE_URL}/blog/${slug}`;
  const message = `📚 ${title}\n\n${description}\n\nอ่านต่อ → ${articleUrl}`;

  let endpoint, body;
  if (coverImage) {
    endpoint = `https://graph.facebook.com/v24.0/${FACEBOOK_PAGE_ID}/photos`;
    body = { url: coverImage, caption: message, access_token: token };
  } else {
    endpoint = `https://graph.facebook.com/v24.0/${FACEBOOK_PAGE_ID}/feed`;
    body = { message, link: articleUrl, access_token: token };
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
    console.log(`[facebook] posted: ${slug}`);
  }
}

async function generateArticle(existingTitles) {
  const category = CATEGORIES[Math.floor(Math.random() * CATEGORIES.length)];

  const prompt = `คุณเป็นแพทย์ผู้เชี่ยวชาญและนักเขียนบทความ SEO สำหรับเว็บไซต์เตรียมสอบแพทย์ "หมอรู้" (morroo.com)

หมวดหมู่: ${category}

บทความที่เขียนไปแล้ว (ห้ามซ้ำ):
${existingTitles.slice(0, 20).map((t) => `- ${t}`).join("\n")}

สร้างบทความใหม่ 1 บทความ ตอบเป็น JSON เท่านั้น:
{
  "title": "หัวข้อภาษาไทย (SEO friendly, 40-80 ตัวอักษร)",
  "slug": "english-slug-with-dashes (ไม่มีภาษาไทย)",
  "description": "คำอธิบายสั้น 120-160 ตัวอักษร สำหรับ meta description",
  "image_prompt": "English prompt for generating a medical illustration cover image, clean modern style, no text, suitable as blog cover",
  "content": "เนื้อหา HTML (ใช้ <h2>, <h3>, <p>, <ul>, <ol>, <li>, <strong>, <table>) ความยาว 1,500-2,000 คำ"
}

กฎเนื้อหา:
- HTML เท่านั้น ไม่มี markdown
- ใส่ internal link ไปที่ /nl/practice หรือ /exams หรือ /longcase หรือ /pricing อย่างน้อย 2 จุด
- เนื้อหาถูกต้องทางการแพทย์ evidence-based
- ภาษากึ่งทางการ เข้าใจง่าย เหมาะกับนักศึกษาแพทย์
- เนื้อหาต้องลงลึก มีตัวอย่างประกอบ มีหัวข้อย่อยอย่างน้อย 5 หัวข้อ
- ใส่ตาราง หรือ bullet points ให้อ่านง่าย

ตอบ JSON เท่านั้น ไม่มี markdown code block`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 8192,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude API error: ${err}`);
  }

  const data = await res.json();
  const rawText = data.content?.[0]?.text ?? "";

  let article;
  try {
    article = JSON.parse(rawText);
  } catch {
    const match = rawText.match(/\{[\s\S]*\}/);
    if (!match) throw new Error("No JSON found in Claude response");
    article = JSON.parse(match[0]);
  }

  if (!article.title || !article.slug || !article.content) {
    throw new Error(`Incomplete article data: ${JSON.stringify(article).slice(0, 200)}`);
  }

  return { article, category };
}

async function generateCoverImage(slug, imagePrompt) {
  if (!TOGETHER_API_KEY || !imagePrompt) return null;

  try {
    const res = await fetch("https://api.together.xyz/v1/images/generations", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${TOGETHER_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "black-forest-labs/FLUX.1-schnell-Free",
        prompt: imagePrompt,
        width: 1200,
        height: 630,
        n: 1,
      }),
    });

    if (!res.ok) {
      console.error("[image] Together API error:", await res.text());
      return null;
    }

    const data = await res.json();
    const b64 = data.data?.[0]?.b64_json;
    const imageUrl = data.data?.[0]?.url;

    if (b64) {
      const buffer = Buffer.from(b64, "base64");
      const filePath = `blog-covers/${slug}.webp`;

      const { error: uploadError } = await supabase.storage
        .from("public-assets")
        .upload(filePath, buffer, { contentType: "image/webp", upsert: true });

      if (uploadError) {
        console.error("[image] upload error:", uploadError.message);
        return null;
      }

      const { data: publicUrl } = supabase.storage.from("public-assets").getPublicUrl(filePath);
      return publicUrl.publicUrl;
    }

    return imageUrl ?? null;
  } catch (err) {
    console.error("[image] error:", err.message);
    return null;
  }
}

async function run() {
  console.log(`Generating ${ARTICLE_COUNT} article(s)...`);

  // Load existing titles once
  const { data: existing } = await supabase
    .from("blog_posts")
    .select("title, slug")
    .order("published_at", { ascending: false })
    .limit(50);

  const existingTitles = (existing ?? []).map((p) => p.title);

  for (let i = 0; i < ARTICLE_COUNT; i++) {
    console.log(`\n--- Article ${i + 1}/${ARTICLE_COUNT} ---`);

    try {
      const { article, category } = await generateArticle(existingTitles);
      console.log(`Title: ${article.title}`);
      console.log(`Slug:  ${article.slug}`);

      // Ensure unique slug
      const { data: slugCheck } = await supabase
        .from("blog_posts")
        .select("slug")
        .eq("slug", article.slug)
        .maybeSingle();

      if (slugCheck) {
        article.slug = `${article.slug}-${Date.now().toString(36)}`;
        console.log(`Slug conflict — renamed to: ${article.slug}`);
      }

      // Generate cover image
      const coverImage = await generateCoverImage(article.slug, article.image_prompt);
      console.log(`Cover image: ${coverImage ? "yes" : "no"}`);

      // Calculate reading time
      const wordCount = article.content.replace(/<[^>]+>/g, " ").split(/\s+/).filter(Boolean).length;
      const readingTime = Math.max(3, Math.round(wordCount / 200));

      // Save to Supabase
      const { data: saved, error: saveError } = await supabase
        .from("blog_posts")
        .insert({
          slug: article.slug,
          title: article.title,
          description: article.description,
          category,
          reading_time: readingTime,
          content: article.content,
          cover_image: coverImage,
          published_at: new Date().toISOString(),
        })
        .select("slug, title, cover_image")
        .single();

      if (saveError) {
        console.error(`Save error: ${saveError.message}`);
        continue;
      }

      console.log(`Saved: "${saved.title}" (${saved.slug})`);
      existingTitles.unshift(saved.title);

      // Post to Facebook
      await postToFacebook(saved.title, article.description, saved.slug, saved.cover_image);
    } catch (err) {
      console.error(`Error generating article ${i + 1}:`, err.message);
    }
  }

  console.log("\nDone.");
}

run();
