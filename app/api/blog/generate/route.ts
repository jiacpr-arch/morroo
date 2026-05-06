/**
 * Auto Blog Generator — AI คิดหัวข้อเอง + Together AI สร้างรูป cover
 *
 * Cron: อังคาร + ศุกร์ 02:00 ICT (19:00 UTC วันก่อน)
 * POST /api/blog/generate?secret=$BLOG_GENERATE_SECRET
 */

import { NextResponse, after } from "next/server";
import sharp from "sharp";
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook } from "@/lib/facebook";
import { broadcastLineMessages } from "@/lib/line";
import { buildBlogAnnounceFlex } from "@/lib/line-flex-templates";
import { pickAutopostFormat, categoryHashtag } from "@/lib/autopost-format";
import { generateHook } from "@/lib/autopost-copy";

export const runtime = "nodejs";
export const maxDuration = 60;

const CATEGORIES = ["ความรู้ทั่วไป", "เตรียมสอบ", "เทคนิคสอบ"];

function slugToHeadline(slug: string): string {
  // Fallback when Claude omits cover_headline_en — take first 2-3 segments
  // of the slug, uppercased. e.g. "dermatology-lesions-exam" → "DERMATOLOGY LESIONS"
  return slug.split("-").slice(0, 2).join(" ").toUpperCase();
}

function buildCoverPrompt({
  headline,
  subtitle,
  scene,
}: {
  headline: string;
  subtitle: string;
  scene: string;
}): string {
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

export async function POST(request: Request) {
  return handleGenerate(request);
}

export async function GET(request: Request) {
  return handleGenerate(request);
}

async function handleGenerate(request: Request) {
  const { searchParams } = new URL(request.url);
  if (searchParams.get("secret") !== process.env.BLOG_GENERATE_SECRET) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const anthropicApiKey = process.env.ANTHROPIC_API_KEY;
  const openaiApiKey = process.env.OPENAI_API_KEY;
  if (!anthropicApiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  const supabase = createAdminClient();

  // Step 1: Get existing titles to avoid duplicates
  const { data: existing } = await supabase
    .from("blog_posts")
    .select("title, slug")
    .order("published_at", { ascending: false })
    .limit(50);

  const existingTitles = (existing ?? []).map((p: { title: string }) => p.title);
  const category = CATEGORIES[Math.floor(Math.random() * CATEGORIES.length)];

  // Step 2: AI picks a new topic + writes the article + generates slug
  const topicPrompt = `คุณเป็นแพทย์ผู้เชี่ยวชาญและนักเขียนบทความ SEO สำหรับเว็บไซต์เตรียมสอบแพทย์ "หมอรู้" (morroo.com)

หมวดหมู่: ${category}

บทความที่เขียนไปแล้ว (ห้ามซ้ำ):
${existingTitles.slice(0, 20).map((t: string) => `- ${t}`).join("\n")}

สร้างบทความใหม่ 1 บทความ ตอบเป็น JSON เท่านั้น:
{
  "title": "หัวข้อภาษาไทย (SEO friendly, 40-80 ตัวอักษร)",
  "slug": "english-slug-with-dashes (ไม่มีภาษาไทย)",
  "description": "คำอธิบายสั้น 120-160 ตัวอักษร สำหรับ meta description",
  "keywords": "keyword1, keyword2, keyword3",
  "cover_headline_en": "BIG BOLD UPPERCASE 2-3 word English headline (e.g. \\"DERMATOLOGY LESIONS\\", \\"ACID-BASE 5 MIN\\")",
  "cover_subtitle_th": "ข้อความไทยสั้นๆ ≤10 คำ ดึงดูดให้คลิก (e.g. \\"ดูผื่นให้เป็น ใน 5 นาที\\")",
  "image_prompt": "English description of the central visual scene only — NO text, NO typography, just the photo/illustration. e.g. \\"a doctor in white coat examining a patient's skin with a dermatoscope, soft natural lighting\\"",
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

  const claudeRes = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": anthropicApiKey,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 8192,
      messages: [{ role: "user", content: topicPrompt }],
    }),
  });

  if (!claudeRes.ok) {
    const err = await claudeRes.text();
    return NextResponse.json({ error: "Claude API error", details: err }, { status: 500 });
  }

  const claudeData = await claudeRes.json();
  const rawText: string = claudeData.content?.[0]?.text ?? "";

  let article: {
    title: string;
    slug: string;
    description: string;
    keywords: string;
    cover_headline_en: string;
    cover_subtitle_th: string;
    image_prompt: string;
    content: string;
  };

  try {
    // Try direct parse, then regex extraction
    try {
      article = JSON.parse(rawText);
    } catch {
      const match = rawText.match(/\{[\s\S]*\}/);
      if (!match) throw new Error("No JSON found in response");
      article = JSON.parse(match[0]);
    }
  } catch (err) {
    console.error("[blog-generate] JSON parse failed:", rawText.slice(0, 200));
    return NextResponse.json({ error: "Failed to parse article JSON", raw: rawText.slice(0, 500) }, { status: 500 });
  }

  if (!article.title || !article.slug || !article.content) {
    return NextResponse.json({ error: "Incomplete article data", article }, { status: 500 });
  }

  // Ensure slug is unique
  const { data: slugCheck } = await supabase
    .from("blog_posts")
    .select("slug")
    .eq("slug", article.slug)
    .maybeSingle();

  if (slugCheck) {
    article.slug = `${article.slug}-${Date.now().toString(36)}`;
  }

  // Step 3: Generate cover image with OpenAI gpt-image-1
  let coverImageUrl: string | null = null;
  let coverBuffer: Buffer | null = null;

  if (openaiApiKey && article.image_prompt) {
    const fullImagePrompt = buildCoverPrompt({
      headline: article.cover_headline_en || slugToHeadline(article.slug),
      subtitle: article.cover_subtitle_th || article.title,
      scene: article.image_prompt,
    });

    try {
      const imageRes = await fetch("https://api.openai.com/v1/images/generations", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${openaiApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "gpt-image-1",
          prompt: fullImagePrompt,
          // Square works for IG feed natively + FB photo posts. Blog card
          // center-crops to 16:9; buildCoverPrompt() instructs the model to
          // keep all critical text inside the central 60% vertical band.
          size: "1024x1024",
          // "medium" keeps text/typography legible at ~$0.042/image vs
          // ~$0.167 for the default high tier — fine for blog/social covers.
          quality: "medium",
          n: 1,
        }),
      });

      if (imageRes.ok) {
        const imageData = await imageRes.json();
        const b64 = imageData.data?.[0]?.b64_json;

        if (b64) {
          // gpt-image-1 always returns PNG bytes as b64_json. Persist to our
          // own Storage bucket so the URL never expires.
          const buffer = Buffer.from(b64, "base64");
          coverBuffer = buffer; // captured by after() for LINE variant generation
          const filePath = `blog-covers/${article.slug}.png`;

          const { error: uploadError } = await supabase.storage
            .from("public-assets")
            .upload(filePath, buffer, {
              contentType: "image/png",
              upsert: true,
            });

          if (!uploadError) {
            const { data: publicUrl } = supabase.storage
              .from("public-assets")
              .getPublicUrl(filePath);
            // Append a cache-bust query so Next.js Image / Vercel CDN /
            // browser caches don't keep serving the old bytes when we
            // upsert a new PNG to the same Storage path.
            coverImageUrl = `${publicUrl.publicUrl}?v=${Date.now()}`;
          } else {
            console.error("[blog-generate] storage upload error:", uploadError);
          }
        }
      } else {
        console.error("[blog-generate] OpenAI image API error:", await imageRes.text());
      }
    } catch (err) {
      console.error("[blog-generate] image generation error:", err);
      // Continue without image — article is still valuable
    }
  }

  // Step 4: Calculate reading time
  const textOnly = article.content.replace(/<[^>]+>/g, " ");
  const wordCount = textOnly.split(/\s+/).filter(Boolean).length;
  const readingTime = Math.max(3, Math.round(wordCount / 200));

  // Step 5: Save to Supabase
  const { data: saved, error: saveError } = await supabase
    .from("blog_posts")
    .insert({
      slug: article.slug,
      title: article.title,
      description: article.description,
      category,
      reading_time: readingTime,
      content: article.content,
      cover_image: coverImageUrl,
      published_at: new Date().toISOString(),
    })
    .select("slug, title, cover_image")
    .single();

  if (saveError) {
    return NextResponse.json({ error: saveError.message }, { status: 500 });
  }

  console.log(`[blog-generate] published: "${saved.title}" (${saved.slug}) cover: ${saved.cover_image ? "yes" : "no"}`);

  // Step 6: Generate LINE variant + post to FB + LINE in background (non-blocking)
  after(async () => {
    const supabaseAsync = createAdminClient();
    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL ?? "https://morroo.com";
    const articleUrl = `${siteUrl}/blog/${saved.slug}`;
    const format = pickAutopostFormat(saved.slug);

    // Generate LINE-compatible variant: JPEG 1024×536 (LINE Flex hero max 1024px, JPEG/PNG only)
    let coverImageLineUrl: string | null = null;
    if (coverBuffer) {
      try {
        const lineBuffer = await sharp(coverBuffer)
          .resize(1024, 536, { fit: "cover" })
          .jpeg({ quality: 85 })
          .toBuffer();

        const lineFilePath = `blog-covers/${saved.slug}-line.jpg`;
        const { error: lineUploadError } = await supabaseAsync.storage
          .from("public-assets")
          .upload(lineFilePath, lineBuffer, {
            contentType: "image/jpeg",
            upsert: true,
          });

        if (!lineUploadError) {
          const { data: linePublicUrl } = supabaseAsync.storage
            .from("public-assets")
            .getPublicUrl(lineFilePath);
          coverImageLineUrl = linePublicUrl.publicUrl;
          await supabaseAsync.from("blog_posts")
            .update({ cover_image_line: coverImageLineUrl })
            .eq("slug", saved.slug);
        } else {
          console.error("[blog-generate] line image upload error:", lineUploadError);
        }
      } catch (err) {
        console.error("[blog-generate] line image resize error:", err);
      }
    }

    const hook = await generateHook({
      title: saved.title,
      description: article.description,
      apiKey: anthropicApiKey,
    });

    // Build hashtags for cover_caption format
    const hashtags = `#เตรียมสอบแพทย์ #หมอรู้ #${categoryHashtag(category)}`;
    const fullCaption = `${hook}\n\n${hashtags}`;

    // Determine cover image for FB based on format
    const coverForFb =
      format === "cover_caption"
        ? (saved.cover_image ?? null)
        : format === "quote_card"
          ? `${siteUrl}/api/og/quote?slug=${saved.slug}`
          : null; // link_only — FB renders OG card from blog page

    // FB autopost
    try {
      const fbId = await postToFacebook({
        title: saved.title,
        description: article.description,
        slug: saved.slug,
        coverImage: coverForFb,
        hook: format === "cover_caption" ? fullCaption : hook,
      });
      await supabaseAsync.from("blog_posts").update({
        fb_post_id: fbId,
        fb_posted_at: new Date().toISOString(),
        fb_last_error: null,
        autopost_format: format,
      }).eq("slug", saved.slug);
    } catch (err) {
      console.error("[blog-generate] facebook post error:", err);
      await supabaseAsync.from("blog_posts").update({
        fb_last_error: String(err).slice(0, 500),
        autopost_format: format,
      }).eq("slug", saved.slug);
    }

    // LINE broadcast (opt-in via env flag — quota: 1 broadcast = 1 msg × N followers)
    if (process.env.LINE_AUTOPOST_ENABLED === "true") {
      const flex = buildBlogAnnounceFlex({
        title: saved.title,
        description: article.description,
        url: articleUrl,
        coverImage: coverImageLineUrl,
      });
      const result = await broadcastLineMessages([flex]);
      await supabaseAsync.from("blog_posts").update(
        result.ok
          ? { line_broadcast_at: new Date().toISOString(), line_last_error: null }
          : { line_last_error: (result.error ?? "unknown").slice(0, 500) }
      ).eq("slug", saved.slug);
    }
  });

  return NextResponse.json({ success: true, post: saved });
}
