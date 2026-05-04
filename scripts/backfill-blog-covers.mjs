/**
 * One-shot backfill: regenerate cover images for every blog post that's
 * missing a Supabase-hosted cover (null, expired Together AI URL, etc.).
 *
 * For each affected post:
 *   1. Ask Claude for an English image_prompt derived from title/description.
 *   2. Call OpenAI gpt-image-1 (1536x1024) for the image.
 *   3. Upload PNG bytes to public-assets/blog-covers/{slug}.png.
 *   4. Update blog_posts.cover_image to the new public URL.
 *
 * Usage (run once after merge):
 *   SUPABASE_URL=... \
 *   SUPABASE_SERVICE_ROLE_KEY=... \
 *   ANTHROPIC_API_KEY=... \
 *   OPENAI_API_KEY=... \
 *   node scripts/backfill-blog-covers.mjs
 *
 * Idempotent: re-running only touches rows whose cover_image is still not
 * pointing at our Storage bucket.
 */

import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
if (!ANTHROPIC_API_KEY) {
  console.error("Missing ANTHROPIC_API_KEY");
  process.exit(1);
}
if (!OPENAI_API_KEY) {
  console.error("Missing OPENAI_API_KEY");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

function isSupabaseStorageUrl(url) {
  if (!url) return false;
  try {
    const u = new URL(url);
    return u.hostname.endsWith(".supabase.co") && u.pathname.startsWith("/storage/v1/object/public/");
  } catch {
    return false;
  }
}

async function deriveImagePrompt({ title, description, category }) {
  const userPrompt = `บทความเตรียมสอบแพทย์หัวข้อ: "${title}"
หมวดหมู่: ${category}
คำอธิบาย: ${description}

เขียน English image prompt สั้นๆ (1-2 ประโยค) สำหรับสร้างภาพ cover บทความ
สไตล์: medical illustration, clean modern style, no text, suitable as blog cover.
ตอบเฉพาะ prompt ภาษาอังกฤษ ไม่ต้องมีคำอธิบายเพิ่ม`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 256,
      messages: [{ role: "user", content: userPrompt }],
    }),
  });

  if (!res.ok) {
    throw new Error(`Claude API error: ${await res.text()}`);
  }

  const data = await res.json();
  const text = data.content?.[0]?.text?.trim();
  if (!text) throw new Error("Empty image prompt from Claude");
  return text;
}

async function generateAndUpload(slug, imagePrompt) {
  const res = await fetch("https://api.openai.com/v1/images/generations", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "gpt-image-1",
      prompt: imagePrompt,
      size: "1536x1024",
      n: 1,
    }),
  });

  if (!res.ok) {
    throw new Error(`OpenAI image API error: ${await res.text()}`);
  }

  const data = await res.json();
  const b64 = data.data?.[0]?.b64_json;
  if (!b64) throw new Error("No b64_json in OpenAI response");

  const buffer = Buffer.from(b64, "base64");
  const filePath = `blog-covers/${slug}.png`;

  const { error: uploadError } = await supabase.storage
    .from("public-assets")
    .upload(filePath, buffer, { contentType: "image/png", upsert: true });

  if (uploadError) {
    throw new Error(`Storage upload error: ${uploadError.message}`);
  }

  const { data: publicUrl } = supabase.storage.from("public-assets").getPublicUrl(filePath);
  return publicUrl.publicUrl;
}

async function run() {
  const { data: posts, error } = await supabase
    .from("blog_posts")
    .select("slug, title, description, category, cover_image")
    .order("published_at", { ascending: false });

  if (error) {
    console.error("Failed to load blog_posts:", error.message);
    process.exit(1);
  }

  const targets = (posts ?? []).filter((p) => !isSupabaseStorageUrl(p.cover_image));
  console.log(`Found ${targets.length}/${posts?.length ?? 0} posts needing a fresh cover.`);

  let okCount = 0;
  let failCount = 0;

  for (const post of targets) {
    console.log(`\n→ ${post.slug}`);
    try {
      const imagePrompt = await deriveImagePrompt(post);
      console.log(`  prompt: ${imagePrompt.slice(0, 80)}${imagePrompt.length > 80 ? "…" : ""}`);

      const publicUrl = await generateAndUpload(post.slug, imagePrompt);

      const { error: updateError } = await supabase
        .from("blog_posts")
        .update({ cover_image: publicUrl })
        .eq("slug", post.slug);

      if (updateError) throw new Error(`DB update error: ${updateError.message}`);

      console.log(`  ✓ ${publicUrl}`);
      okCount++;
    } catch (err) {
      console.error(`  ✗ ${err.message}`);
      failCount++;
    }

    await new Promise((r) => setTimeout(r, 500));
  }

  console.log(`\nDone. Success: ${okCount}, Failed: ${failCount}`);
}

run();
