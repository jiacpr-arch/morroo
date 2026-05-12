/**
 * One-shot backfill: regenerate cover images for blog posts.
 *
 * For each affected post:
 *   1. Ask Claude for cover headline (EN), subtitle (TH), and visual scene
 *      derived from title/description/category.
 *   2. Call Together FLUX.1.1-pro (1024x1024) for a text-free illustration,
 *      then burn EN headline + Thai subtitle + CTA on top via sharp using
 *      bundled Inter Black + Sarabun Bold fonts (Thai glyphs stay crisp).
 *   3. Upload PNG bytes to public-assets/blog-covers/{slug}.png.
 *   4. Update blog_posts.cover_image to the new public URL.
 *
 * Required env vars:
 *   SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY, TOGETHER_API_KEY
 *
 * Optional control env vars:
 *   LIMIT  — process at most N rows (default unlimited)
 *   FORCE  — when "1"/"true", regenerate every row regardless of current
 *            cover_image. Default: only rows whose cover_image is null or
 *            not on Supabase Storage.
 *
 * Usage:
 *   node scripts/backfill-blog-covers.mjs
 */

import { createClient } from "@supabase/supabase-js";
import { composeCoverWithText } from "./lib/cover-compose.mjs";

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const TOGETHER_API_KEY = process.env.TOGETHER_API_KEY;
const LIMIT = parseInt(process.env.LIMIT ?? "", 10);
const FORCE = ["1", "true", "TRUE", "yes"].includes(process.env.FORCE ?? "");

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
if (!ANTHROPIC_API_KEY) {
  console.error("Missing ANTHROPIC_API_KEY");
  process.exit(1);
}
if (!TOGETHER_API_KEY) {
  console.error("Missing TOGETHER_API_KEY");
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

function slugToHeadline(slug) {
  return slug.split("-").slice(0, 2).join(" ").toUpperCase();
}

function buildCoverPrompt({ scene }) {
  return `Modern editorial medical illustration for a Thai medical-education blog ("หมอรู้"). Square 1:1 composition, 1024x1024.

SCENE (main subject occupies left 35-45% of canvas):
${scene}

COMPOSITION:
- Subject illustration anchored on the left side.
- Right 55-65% of canvas: clean, low-detail area — gradient, soft abstract shapes, or quiet background (typography will be composited on top in post-processing; do NOT render any text yourself).
- Generous whitespace; designer-quality flat or semi-flat illustration; subtle decorative shapes (soft circles, blobs, dotted accents).
- Cohesive 3-color palette appropriate for the topic; lean toward medical professional tones (deep teal, navy, soft cyan, warm clinical neutrals).

ABSOLUTE RULES — DO NOT:
- Render ANY text, letters, words, numbers, captions, labels, watermarks, signatures, URLs, brand marks, signs, charts, graphs, anatomical labels, callouts, or typography of ANY kind.
- Add diagonal banners, ribbons with text, or decorative scripts.
- Place the subject on the right side — keep right 55-65% reserved for clean negative space.

The output must be a pure illustration with no characters or glyphs visible anywhere.`;
}

async function deriveCoverFields({ title, description, category }) {
  const userPrompt = `บทความเตรียมสอบแพทย์
หัวข้อ: "${title}"
หมวดหมู่: ${category}
คำอธิบาย: ${description}

ตอบเป็น JSON เท่านั้น (ไม่มี code block, ไม่มีคำอธิบายเพิ่ม):
{
  "headline_en": "BIG BOLD UPPERCASE 2-3 word English headline (e.g. \\"DERMATOLOGY LESIONS\\", \\"ACID-BASE 5 MIN\\")",
  "subtitle_th": "ข้อความไทยสั้นๆ ≤ 10 คำ ดึงดูดให้คลิก",
  "scene": "English description of the central visual scene only — photo or illustration. NO text, NO typography, NO logo. 1-2 sentences."
}`;

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "x-api-key": ANTHROPIC_API_KEY,
      "anthropic-version": "2023-06-01",
      "content-type": "application/json",
    },
    body: JSON.stringify({
      model: "claude-sonnet-4-6",
      max_tokens: 512,
      messages: [{ role: "user", content: userPrompt }],
    }),
  });

  if (!res.ok) {
    throw new Error(`Claude API error: ${await res.text()}`);
  }

  const data = await res.json();
  const text = data.content?.[0]?.text?.trim() ?? "";
  const match = text.match(/\{[\s\S]*\}/);
  if (!match) throw new Error(`No JSON in Claude response: ${text.slice(0, 200)}`);

  const parsed = JSON.parse(match[0]);
  if (!parsed.scene) throw new Error("Claude response missing 'scene'");

  return {
    headline_en: parsed.headline_en?.toString().trim() || "",
    subtitle_th: parsed.subtitle_th?.toString().trim() || "",
    scene: parsed.scene.toString().trim(),
  };
}

async function generateAndUpload(slug, fullPrompt, { headline, subtitle }) {
  const res = await fetch("https://api.together.xyz/v1/images/generations", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${TOGETHER_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: "black-forest-labs/FLUX.1.1-pro",
      prompt: fullPrompt,
      width: 1024,
      height: 1024,
      n: 1,
      response_format: "b64_json",
    }),
  });

  if (!res.ok) {
    throw new Error(`Together image API error: ${await res.text()}`);
  }

  const data = await res.json();
  const b64 = data.data?.[0]?.b64_json;
  if (!b64) throw new Error("No b64_json in Together response");

  const rawBuffer = Buffer.from(b64, "base64");
  const buffer = await composeCoverWithText(rawBuffer, { headline, subtitle });
  const filePath = `blog-covers/${slug}.png`;

  const { error: uploadError } = await supabase.storage
    .from("public-assets")
    .upload(filePath, buffer, { contentType: "image/png", upsert: true });

  if (uploadError) {
    throw new Error(`Storage upload error: ${uploadError.message}`);
  }

  const { data: publicUrl } = supabase.storage.from("public-assets").getPublicUrl(filePath);
  // Cache-bust so Next.js Image / Vercel CDN / browser don't keep serving
  // the old bytes when we upsert a new PNG to the same Storage path.
  return `${publicUrl.publicUrl}?v=${Date.now()}`;
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

  let targets = (posts ?? []).filter((p) =>
    FORCE ? true : !isSupabaseStorageUrl(p.cover_image)
  );
  if (Number.isFinite(LIMIT) && LIMIT > 0) {
    targets = targets.slice(0, LIMIT);
  }
  console.log(
    `Found ${targets.length}/${posts?.length ?? 0} posts to backfill (FORCE=${FORCE}${
      Number.isFinite(LIMIT) && LIMIT > 0 ? `, LIMIT=${LIMIT}` : ""
    }).`
  );

  let okCount = 0;
  let failCount = 0;

  for (const post of targets) {
    console.log(`\n→ ${post.slug}`);
    try {
      const fields = await deriveCoverFields(post);
      console.log(`  headline: ${fields.headline_en}`);
      console.log(`  subtitle: ${fields.subtitle_th}`);
      console.log(`  scene:    ${fields.scene.slice(0, 80)}${fields.scene.length > 80 ? "…" : ""}`);

      const fullPrompt = buildCoverPrompt({ scene: fields.scene });

      const publicUrl = await generateAndUpload(post.slug, fullPrompt, {
        headline: fields.headline_en || slugToHeadline(post.slug),
        subtitle: fields.subtitle_th,
      });

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
