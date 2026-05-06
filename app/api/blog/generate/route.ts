/**
 * Auto Blog Generator — AI คิดหัวข้อเอง + OpenAI gpt-image-1 สร้างรูป cover
 *
 * Cron: อังคาร + ศุกร์ 02:00 ICT (19:00 UTC วันก่อน)
 * POST /api/blog/generate?secret=$BLOG_GENERATE_SECRET
 */

import { NextResponse, after } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { postToFacebook } from "@/lib/facebook";

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
  category,
}: {
  headline: string;
  subtitle: string;
  scene: string;
  category?: string;
}): string {
  const categoryHint =
    category === "เทคนิคสอบ"
      ? "Mood: focused, strategic, motivational — like a premium exam-prep brand campaign."
      : category === "เตรียมสอบ"
      ? "Mood: serious-but-approachable academic; reassuring and confidence-building."
      : "Mood: clean, intelligent, calm-confident editorial.";

  return `Premium designer-quality cover for a Thai medical-exam blog ("หมอรู้", morroo.com). Square 1:1, social-media-ready (Facebook / Instagram feed).

CREATIVE DIRECTION:
- Photorealistic medical advertising photography crossed with editorial infographic — feels premium, trustworthy, modern.
- Reference aesthetic: high-end pharma campaign, modern medical-school brochure, Apple-clean editorial layout.
- Audience: Thai medical students preparing for licensing exams (ศรว. / NL).
- ${categoryHint}

VISUAL SCENE (anchored on left ~1/3 of canvas):
${scene}

COMPOSITION:
- Strict rule-of-thirds: subject anchored at the left-third intersection; right two-thirds reserved for typography and breathing room.
- Generous negative space around the headline — no clutter or busy texture behind text.
- Clear single focal point with shallow depth of field on photographic subjects (background softly blurred, bokeh).
- Visual hierarchy in scan order: subject → headline → subtitle → CTA badge.
- Place ALL text AND the CTA inside the central 60% vertical band (top 20% and bottom 20% contain only background / decorative shapes), so a 16:9 center-crop on a blog card preserves the headline, subtitle, and CTA.

LIGHTING & ATMOSPHERE:
- Cinematic soft natural lighting; key light from upper-left at ~45°; gentle fill; soft shadow falloff.
- Crisp highlights without blown-out skin; controlled shadows; subtle ambient occlusion for depth.
- Photorealistic look as if shot on a 50mm lens at f/2.8; sharp focus on the subject's eyes / hands / instrument.

COLOR & MATERIAL:
- Cohesive 3-color palette appropriate for the topic — one calm primary (teal / navy / sage), one warm accent, one neutral background.
- Pastel, low-saturation backgrounds; balanced editorial color grading; print-quality contrast.
- Ultra-realistic skin texture, accurate Thai / Southeast-Asian features, natural fabric and material rendering, anatomically correct hands.

TYPOGRAPHY (render text exactly as written, large, well-kerned, designer-grade):
- Top-right: BIG BOLD UPPERCASE English headline — "${headline}"
- Below the headline: smaller Thai subtitle — "${subtitle}"
- Bottom-right corner: small CTA badge "หมอรู้ · morroo.com"
- Modern geometric sans-serif feel; crisp, legible Thai vowels and tone marks (no broken or stacked Thai glyphs).

DO NOT (negative direction — must avoid):
- Distorted or extra fingers, malformed hands, asymmetric eyes, melted faces, plastic / waxy skin.
- Blurry text, garbled letters, fake logos, fake URLs, watermarks, stock-photo signatures, QR codes.
- Misspell "morroo.com" or "หมอรู้".
- Harsh on-camera flash, oversaturated neon colors, cluttered or noisy backgrounds, amateur clip-art look, AI-generated kitsch.
- More than ~12 visible words of text total — must stay readable at thumbnail size.`;
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
  "image_prompt": "Detailed English description of the central visual scene only (no text, no typography). MUST include: (1) subject + action, (2) environment, (3) lighting style, (4) camera/lens hint, (5) mood. Aim for cinematic, premium, photorealistic. e.g. \\"a Thai female doctor in a crisp white coat carefully examining a patient's skin lesion with a dermatoscope, modern hospital interior softly blurred behind, cinematic soft window light from upper-left, shot on 50mm lens at f/2.8, calm and trustworthy mood\\"",
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

  if (openaiApiKey && article.image_prompt) {
    const fullImagePrompt = buildCoverPrompt({
      headline: article.cover_headline_en || slugToHeadline(article.slug),
      subtitle: article.cover_subtitle_th || article.title,
      scene: article.image_prompt,
      category,
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
          // "high" gives noticeably better composition, lighting, and Thai
          // typography rendering vs "medium". ~$0.167/image — at 2 covers/week
          // (~$17/yr) the quality lift is worth it for blog/social covers.
          quality: "high",
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

  // Step 6: Post to Facebook in background (non-blocking)
  after(async () => {
    await postToFacebook({
      title: saved.title,
      description: article.description,
      slug: saved.slug,
      coverImage: saved.cover_image ?? null,
    });
  });

  return NextResponse.json({ success: true, post: saved });
}
