/**
 * Blog article generator — runs on GitHub Actions (no Vercel timeout)
 *
 * Required env vars:
 *   SUPABASE_URL
 *   SUPABASE_SERVICE_ROLE_KEY
 *   ANTHROPIC_API_KEY
 *
 * Optional:
 *   OPENAI_API_KEY           — cover image via gpt-image-1 (skipped if absent)
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
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
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

สร้างบทความใหม่ 1 บทความ แล้วเรียก tool publish_article พร้อมข้อมูลครบถ้วน

กฎเนื้อหา:
- field "content" เป็น HTML (ใช้ <h2>, <h3>, <p>, <ul>, <ol>, <li>, <strong>, <table>) ความยาว 1,500-2,000 คำ ไม่มี markdown
- ใส่ internal link ไปที่ /nl/practice หรือ /exams หรือ /longcase หรือ /pricing อย่างน้อย 2 จุด
- เนื้อหาถูกต้องทางการแพทย์ evidence-based
- ภาษากึ่งทางการ เข้าใจง่าย เหมาะกับนักศึกษาแพทย์
- ลงลึก มีตัวอย่างประกอบ มีหัวข้อย่อยอย่างน้อย 5 หัวข้อ
- ใส่ตาราง หรือ bullet points ให้อ่านง่าย`;

  const tools = [
    {
      name: "publish_article",
      description: "Publish a blog article on morroo.com",
      input_schema: {
        type: "object",
        properties: {
          title: {
            type: "string",
            description: "หัวข้อภาษาไทย (SEO friendly, 40-80 ตัวอักษร)",
          },
          slug: {
            type: "string",
            description: "english-slug-with-dashes (ไม่มีภาษาไทย)",
          },
          description: {
            type: "string",
            description: "Meta description ภาษาไทย 120-160 ตัวอักษร",
          },
          cover_headline_en: {
            type: "string",
            description:
              'BIG BOLD UPPERCASE 2-3 word English headline that captures the article hook (e.g. "DERMATOLOGY LESIONS", "ACID-BASE 5 MIN"). Will be rendered as the main title on the cover image.',
          },
          cover_subtitle_th: {
            type: "string",
            description:
              'ข้อความไทยสั้นๆ ≤ 10 คำ ดึงดูดให้คลิก (e.g. "ดูผื่นให้เป็น ใน 5 นาที"). จะแสดงเป็น subtitle ใต้ headline บน cover',
          },
          image_prompt: {
            type: "string",
            description:
              "English description of the central VISUAL SCENE only (photo or illustration) — NO text, NO typography, NO logo. e.g. \"a doctor in white coat examining a patient's skin with a dermatoscope, soft natural lighting\"",
          },
          content: {
            type: "string",
            description: "HTML body 1,500-2,000 words (no markdown)",
          },
        },
        required: [
          "title",
          "slug",
          "description",
          "cover_headline_en",
          "cover_subtitle_th",
          "image_prompt",
          "content",
        ],
      },
    },
  ];

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
      tools,
      tool_choice: { type: "tool", name: "publish_article" },
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    throw new Error(`Claude API error: ${err}`);
  }

  const data = await res.json();
  const toolUse = (data.content ?? []).find((b) => b.type === "tool_use");
  if (!toolUse?.input) {
    throw new Error(`No tool_use in Claude response: ${JSON.stringify(data).slice(0, 300)}`);
  }

  const article = toolUse.input;
  if (!article.title || !article.slug || !article.content) {
    throw new Error(`Incomplete article data: ${JSON.stringify(article).slice(0, 200)}`);
  }

  return { article, category };
}

function slugToHeadline(slug) {
  return slug.split("-").slice(0, 2).join(" ").toUpperCase();
}

function buildCoverPrompt({ headline, subtitle, scene }) {
  return `Modern educational medical infographic poster, square 1:1 cover for a Thai medical-exam blog ("หมอรู้").

VISUAL SCENE (left side, ~1/3 width):
${scene}

TYPOGRAPHY (render text exactly as written, large and clearly readable, good kerning):
- Top-right: BIG BOLD UPPERCASE English headline — "${headline}"
- Below the headline: smaller Thai subtitle — "${subtitle}"
- Bottom-right corner: small CTA badge "หมอรู้ · morroo.com"

LAYOUT RULES:
- Place ALL text AND the CTA inside the central 60% vertical band of the canvas (top 20% and bottom 20% must contain only background / decorative shapes), so a 16:9 center-crop on a blog card preserves the headline, subtitle, and CTA.
- Photo or illustration on the left third; right two-thirds reserved for typography and supporting accents (subtle icons, ribbon shapes, soft circles).
- Generous whitespace; clear visual hierarchy; modern sans-serif feel.

STYLE:
- Designer-quality flat infographic; pastel backgrounds; subtle decorative shapes; professional medical study-card aesthetic.
- Choose a cohesive 3-color palette appropriate for the topic.
- Crisp, legible Thai vowels and tone marks (no broken Thai glyphs).

DO NOT:
- Misspell "morroo.com" or "หมอรู้".
- Add other URLs, fake brand marks, or watermarks.
- Render more than ~12 visible words of text total — stay readable at thumbnail size.`;
}

async function generateCoverImage(slug, { headline, subtitle, scene }) {
  if (!OPENAI_API_KEY || !scene) return null;

  const fullPrompt = buildCoverPrompt({
    headline: headline || slugToHeadline(slug),
    subtitle: subtitle || "",
    scene,
  });

  try {
    const res = await fetch("https://api.openai.com/v1/images/generations", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-image-1",
        prompt: fullPrompt,
        // Square works for IG feed natively + FB photo posts. Blog card
        // center-crops to 16:9; buildCoverPrompt() instructs the model to
        // keep all critical text inside the central 60% vertical band.
        size: "1024x1024",
        n: 1,
      }),
    });

    if (!res.ok) {
      console.error("[image] OpenAI image API error:", await res.text());
      return null;
    }

    const data = await res.json();
    const b64 = data.data?.[0]?.b64_json;
    if (!b64) return null;

    const buffer = Buffer.from(b64, "base64");
    const filePath = `blog-covers/${slug}.png`;

    const { error: uploadError } = await supabase.storage
      .from("public-assets")
      .upload(filePath, buffer, { contentType: "image/png", upsert: true });

    if (uploadError) {
      console.error("[image] upload error:", uploadError.message);
      return null;
    }

    const { data: publicUrl } = supabase.storage.from("public-assets").getPublicUrl(filePath);
    return publicUrl.publicUrl;
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
      const coverImage = await generateCoverImage(article.slug, {
        headline: article.cover_headline_en,
        subtitle: article.cover_subtitle_th,
        scene: article.image_prompt,
      });
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
