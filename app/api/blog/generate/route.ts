/**
 * Auto Blog Generator — AI คิดหัวข้อเอง + Together AI สร้างรูป cover
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
  const togetherApiKey = process.env.TOGETHER_API_KEY;
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

  // Step 3: Generate cover image with Together AI
  let coverImageUrl: string | null = null;

  if (togetherApiKey && article.image_prompt) {
    try {
      const imageRes = await fetch("https://api.together.xyz/v1/images/generations", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${togetherApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "black-forest-labs/FLUX.1-schnell-Free",
          prompt: article.image_prompt,
          width: 1200,
          height: 630,
          n: 1,
        }),
      });

      if (imageRes.ok) {
        const imageData = await imageRes.json();
        const b64 = imageData.data?.[0]?.b64_json;
        const imageUrl = imageData.data?.[0]?.url;

        if (b64) {
          // Upload base64 image to Supabase Storage
          const buffer = Buffer.from(b64, "base64");
          const filePath = `blog-covers/${article.slug}.webp`;

          const { error: uploadError } = await supabase.storage
            .from("public-assets")
            .upload(filePath, buffer, {
              contentType: "image/webp",
              upsert: true,
            });

          if (!uploadError) {
            const { data: publicUrl } = supabase.storage
              .from("public-assets")
              .getPublicUrl(filePath);
            coverImageUrl = publicUrl.publicUrl;
          } else {
            console.error("[blog-generate] storage upload error:", uploadError);
          }
        } else if (imageUrl) {
          coverImageUrl = imageUrl;
        }
      } else {
        console.error("[blog-generate] Together API error:", await imageRes.text());
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
