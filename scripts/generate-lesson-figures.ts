/**
 * generate-lesson-figures — ใส่รูปประกอบให้บทเรียน School ทีละบท
 *
 * ต่อ 1 บทเรียน (school_lessons):
 *   1. ส่ง body_md ให้ Claude เสนอ "figure spec": diagram เป็น SVG 1 รูปต่อ Part
 *      (label ไทย ควบคุมข้อความได้ 100%), prompt สำหรับ hero, และ key points สำหรับการ์ดสรุป
 *   2. เรนเดอร์: SVG ใช้ตรง ๆ (ตรวจว่าพาร์สได้/ไม่มี script) · การ์ดสรุปจาก template SVG ในไฟล์นี้
 *      · hero **ปิดเป็นค่าเริ่มต้น** (ดูหมายเหตุด้านล่าง) — เปิดด้วย WITH_HERO=1 เท่านั้น ถ้าเปิดจะเรียก
 *      OpenAI gpt-image-2.5-flare (ตกไป gpt-image-1 อัตโนมัติถ้า org ยังไม่มีสิทธิ์ใช้รุ่นใหม่)
 *   3. อัปโหลดขึ้น Supabase Storage `public-assets/school/lessons/{lesson_id}/…`
 *   4. เขียนกลับ body_md ด้วย `![alt](url "caption")` ตามตำแหน่ง Part/anchor ที่ Claude ระบุ
 *      (ผ่าน splitLessonPartsRaw/joinLessonParts — marker `## ⏸ Mini Quiz` และ quiz ไม่ถูกแตะ)
 *      และ upsert แถวใน school_visuals (lesson_id) สำหรับการ์ดสรุป
 *
 * หมายเหตุเรื่อง hero: ทดสอบแล้วรูปที่ได้จาก gpt-image-2.5-flare ผ่าน API ตรง ๆ
 * คุณภาพ/สไตล์ไม่นิ่งพอ (ครั้งหนึ่งหลุดเป็นภาพมืดมีกะโหลก) เทียบกับรูปที่ทำเอง/อัปโหลดมือ
 * ผ่านหน้า `/admin/school` → tab แก้ไข → ปุ่ม "+ แทรกรูปตรงนี้" จึงปิด hero ไว้เป็นค่าเริ่มต้น
 * ให้ diagram (ที่คุม label ได้ 100%) เป็นตัวหลัก ส่วน hero ให้แอดมินเลือกรูปเองแทน
 *
 * Env ที่ต้องมี: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 * Env เสริม:     OPENAI_API_KEY (ใช้เมื่อ WITH_HERO=1), MODEL (default claude-sonnet-4-6)
 *
 * เลือกบท:  LESSON_ID=<uuid>   หรือ  TOPIC="FMMD 1201" (ทุกบทในวิชา)  หรือ  ALL=1
 * ควบคุม:   DRY=1   เขียน spec + svg ลง scripts/lesson-figures-out/ อย่างเดียว ไม่อัป/ไม่แก้ DB
 *           FORCE=1 ทำซ้ำแม้บทมีรูปแล้ว (รูปเก่าที่สคริปต์นี้ใส่จะถูกลบออกก่อน)
 *           WITH_HERO=1 เปิดสร้าง hero ด้วย AI (ปิดอยู่โดยค่าเริ่มต้น — ดูหมายเหตุด้านบน)
 *
 * รัน:  npx tsx scripts/generate-lesson-figures.ts
 * (ตัวแปรทั้งหมดข้างบนเป็น env var — ต้องอยู่ *หน้า* คำสั่ง หรือ export ไว้ก่อน ไม่ใช่ argument ต่อท้าย
 *  เช่น `LESSON_ID=xxx DRY=1 npx tsx scripts/generate-lesson-figures.ts` หรือถ้าใช้ `npm run gen:figures`
 *  ต้อง `export LESSON_ID=xxx DRY=1` ก่อน แล้วค่อยรัน `npm run gen:figures` เฉย ๆ — npm run ไม่ได้แปลง
 *  `npm run gen:figures LESSON_ID=xxx` ให้เป็น env var ให้ มันจะส่งเป็น arg ของสคริปต์แทน)
 *
 * หลังรันทุกครั้ง เปิดดูบทใน /admin/school → tab แก้ไข → "หน้าเหมือนนักเรียน" ก่อนปล่อย
 * รูปไหนไม่ดี แก้ SVG ในมือ (เป็นข้อความ) แล้วอัปทับผ่านช่อง "+ แทรกรูปตรงนี้" ได้
 */

import { createClient } from "@supabase/supabase-js";
import Anthropic from "@anthropic-ai/sdk";
import sharp from "sharp";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { splitLessonPartsRaw, joinLessonParts } from "@/lib/school/lesson-parts";
import { figureMarkdown, hasFigures } from "@/lib/school/figures";

// ────────────────────────────────────────────────────────────────────────────
// Config
// ────────────────────────────────────────────────────────────────────────────

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const MODEL = process.env.MODEL ?? "claude-sonnet-4-6";

const LESSON_ID = process.env.LESSON_ID;
const TOPIC = process.env.TOPIC;
const ALL = flag("ALL");
const DRY = flag("DRY");
const FORCE = flag("FORCE");
const WITH_HERO = flag("WITH_HERO");

const BUCKET = "public-assets";
const PREFIX = "school/lessons";
const OUT_DIR = path.join(process.cwd(), "scripts", "lesson-figures-out");
const MAX_SVG_BYTES = 200 * 1024;
const SOURCE_TAG = `figure-gen:${MODEL}`;

function flag(name: string): boolean {
  return ["1", "true", "yes"].includes((process.env[name] ?? "").toLowerCase());
}

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
if (!ANTHROPIC_API_KEY) {
  console.error("Missing ANTHROPIC_API_KEY");
  process.exit(1);
}
if (!LESSON_ID && !TOPIC && !ALL) {
  console.error('Pick lessons with LESSON_ID=<uuid>, TOPIC="FMMD 1201" or ALL=1');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
const anthropic = new Anthropic({ apiKey: ANTHROPIC_API_KEY, maxRetries: 4 });

// ────────────────────────────────────────────────────────────────────────────
// Types
// ────────────────────────────────────────────────────────────────────────────

interface LessonRow {
  id: string;
  topic_id: string;
  layer: string;
  title: string;
  body_md: string;
  sort_order: number;
  school_topics: { code: string | null; name_th: string; slug: string } | null;
}

interface FigureSpec {
  part: number;
  anchor: string;
  title: string;
  alt: string;
  caption: string;
  svg: string;
}

interface Proposal {
  hero: { alt: string; caption: string; image_prompt: string } | null;
  figures: FigureSpec[];
  summary: {
    headline: string;
    points: string[];
    check_questions: { q: string; a: string }[];
  };
}

// ────────────────────────────────────────────────────────────────────────────
// Step 1 — ask Claude for the figure spec
// ────────────────────────────────────────────────────────────────────────────

const PROPOSE_TOOL: Anthropic.Tool = {
  name: "propose_figures",
  description:
    "Propose the figures for one micro-lesson: one SVG diagram per reading Part, a hero illustration prompt, and a one-card summary.",
  input_schema: {
    type: "object",
    properties: {
      hero: {
        type: "object",
        description:
          "Decorative opening illustration. image_prompt is an English scene description for an image model — NO text, labels or typography in the scene.",
        properties: {
          alt: { type: "string" },
          caption: { type: "string", description: "Thai, one sentence" },
          image_prompt: { type: "string" },
        },
        required: ["alt", "caption", "image_prompt"],
      },
      figures: {
        type: "array",
        description:
          "At most ONE diagram per Part. Skip Parts that are pearls / mnemonics / connections / summary.",
        items: {
          type: "object",
          properties: {
            part: { type: "integer", description: "1-based Part number" },
            anchor: {
              type: "string",
              description:
                "EXACT copy of one existing line in that Part (a heading or the first line of a paragraph). The figure is inserted right after the paragraph containing this line.",
            },
            title: { type: "string", description: "Short Thai title of the diagram" },
            alt: { type: "string", description: "Thai, ≤ 120 chars" },
            caption: {
              type: "string",
              description: "Thai, one sentence telling the reader what to look at",
            },
            svg: {
              type: "string",
              description:
                'Complete SVG document. viewBox="0 0 1200 H" (H 640–800), no width/height, white background rect, real <text> elements with font-family="Sarabun, \'Noto Sans Thai\', system-ui, sans-serif", ≤ 7 visual elements, ≤ 6 labels (Thai + English term in parentheses), one idea per figure. No <script>, <foreignObject>, external hrefs, or raster images.',
            },
          },
          required: ["part", "anchor", "title", "alt", "caption", "svg"],
        },
      },
      summary: {
        type: "object",
        description: "End-of-lesson summary card content",
        properties: {
          headline: { type: "string", description: "Thai, ≤ 40 chars" },
          points: {
            type: "array",
            minItems: 3,
            maxItems: 5,
            items: { type: "string", description: "Thai, ≤ 70 chars, one fact each" },
          },
          check_questions: {
            type: "array",
            minItems: 2,
            maxItems: 4,
            items: {
              type: "object",
              properties: { q: { type: "string" }, a: { type: "string" } },
              required: ["q", "a"],
            },
          },
        },
        required: ["headline", "points", "check_questions"],
      },
    },
    required: ["hero", "figures", "summary"],
  },
};

const SYSTEM = `You design teaching figures for Thai medical students (mixed Thai + English medical terms).
The lesson is split into reading "Parts" by the marker line "## ⏸ Mini Quiz". Each figure must let a student
answer "what should I remember from this Part" in one look.

Rules:
- One diagram per Part at most; none for Parts that are pearls, mnemonics, connections or summaries.
- Diagram = mechanism / steps / classification / comparison. ≤ 7 visual elements, ≤ 6 labels.
- Labels in Thai with the English term in parentheses. Never state a dose, cut-off or number that is not in the lesson text.
- SVG must be self-contained and valid XML: viewBox="0 0 1200 H", white background, rounded boxes (rx=14), one <marker> for arrows,
  palette ink #0f172a / muted #64748b / line #cbd5e1 / accent ${"${accent}"} / teal #0d9488 / amber #d97706 / sky #0284c7.
  Thai text is wide: keep each text line ≤ 32 Thai characters, font-size 18–26, split into <tspan> lines instead of shrinking.
- anchor must be copied verbatim from the lesson text so the figure lands next to the concept it explains.
- Summary points are the 3–5 facts a student must be able to recall before the final quiz.`;

const ACCENT_BY_LAYER: Record<string, { fg: string; bg: string; name: string }> = {
  anatomy: { fg: "#e11d48", bg: "#ffe4e6", name: "Anatomy" },
  physio: { fg: "#0284c7", bg: "#e0f2fe", name: "Physiology" },
  biochem: { fg: "#d97706", bg: "#fef3c7", name: "Biochemistry" },
  path: { fg: "#7c3aed", bg: "#ede9fe", name: "Pathology" },
  pharm: { fg: "#059669", bg: "#d1fae5", name: "Pharmacology" },
  clinical: { fg: "#ea580c", bg: "#ffedd5", name: "Clinical" },
  foundation: { fg: "#475569", bg: "#e2e8f0", name: "Foundation" },
};

function accentFor(layer: string) {
  return ACCENT_BY_LAYER[layer] ?? ACCENT_BY_LAYER.foundation;
}

async function propose(lesson: LessonRow): Promise<Proposal> {
  const accent = accentFor(lesson.layer);
  const { parts } = splitLessonPartsRaw(lesson.body_md);
  const numbered = parts
    .map((p, i) => `=== Part ${i + 1} ===\n${p}`)
    .join("\n\n");
  const res = await anthropic.messages.create({
    model: MODEL,
    max_tokens: 16000,
    system: SYSTEM.replace("${accent}", accent.fg),
    tools: [PROPOSE_TOOL],
    tool_choice: { type: "tool", name: PROPOSE_TOOL.name },
    messages: [
      {
        role: "user",
        content: `Subject: ${lesson.school_topics?.code ?? ""} ${lesson.school_topics?.name_th ?? ""}\nLesson: ${lesson.title}\nLayer: ${lesson.layer}\n\n${numbered}`,
      },
    ],
  });
  const block = res.content.find((c) => c.type === "tool_use");
  if (!block || block.type !== "tool_use") throw new Error("model returned no tool call");
  const input = block.input as Partial<Proposal>;
  if (!input.summary || !Array.isArray(input.figures)) throw new Error("incomplete proposal");
  return {
    hero: input.hero ?? null,
    figures: input.figures,
    summary: input.summary,
  };
}

// ────────────────────────────────────────────────────────────────────────────
// Step 2 — render / validate
// ────────────────────────────────────────────────────────────────────────────

async function validateSvg(svg: string, label: string): Promise<Buffer> {
  const trimmed = svg.trim();
  if (!trimmed.startsWith("<svg") && !trimmed.startsWith("<?xml")) {
    throw new Error(`${label}: not an <svg> document`);
  }
  if (!/viewBox=/.test(trimmed)) throw new Error(`${label}: missing viewBox`);
  if (/<script|<foreignObject|xlink:href\s*=\s*"http|href\s*=\s*"http/i.test(trimmed)) {
    throw new Error(`${label}: script / foreignObject / external href not allowed`);
  }
  const buf = Buffer.from(trimmed, "utf8");
  if (buf.length > MAX_SVG_BYTES) throw new Error(`${label}: ${buf.length} bytes > ${MAX_SVG_BYTES}`);
  // sharp parses the XML (librsvg) — throws on malformed markup.
  await sharp(buf).metadata();
  return buf;
}

/**
 * Hero image model. gpt-image-2.5-flare (released 2026-09-08) replaces
 * gpt-image-1: sharper detail and ~50% lower latency at the "flare" (fast)
 * tier, which is what a decorative no-text illustration needs — "sunburst"
 * is the slower, higher-precision-editing tier and isn't worth it here.
 *
 * Verified against the live API (2026-09-20): `aspect_ratio`/`resolution`
 * came back "Unknown parameter" — third-party write-ups describing that
 * shape didn't match this account's actual API version, and OpenAI's own
 * docs weren't reachable to confirm ahead of time. Uses the SAME
 * `size`/`quality` shape as gpt-image-1 instead (same model family, and
 * that shape is proven working via the fallback call below). Still falls
 * back to gpt-image-1 once on any 4xx (e.g. an org not yet rolled onto the
 * new model) rather than failing the whole hero step.
 */
const HERO_MODEL = "gpt-image-2.5-flare";
const HERO_MODEL_FALLBACK = "gpt-image-1";

async function callImageApi(
  model: string,
  prompt: string,
  body: Record<string, unknown>
): Promise<Response> {
  return fetch("https://api.openai.com/v1/images/generations", {
    method: "POST",
    headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({ model, prompt, ...body }),
  });
}

async function renderHero(prompt: string): Promise<Buffer | null> {
  if (!WITH_HERO || !OPENAI_API_KEY) return null;
  // Verified 2026-09-20: without an explicit anti-realism anchor, gpt-image
  // models default to photorealistic/cinematic renders — a first pilot run
  // returned a moody Renaissance alchemist scene with a skull and skeleton,
  // nothing like the flat SVG diagrams it needs to sit next to. Name the
  // style genre directly ("Duolingo/Notion-style flat vector illustration")
  // and list the drift we saw as an explicit negative, not just "friendly".
  const full = `Flat 2D vector illustration, the style of a modern app onboarding screen or Duolingo/Notion-style explainer graphic — NOT a photo, NOT a painting, NOT cinematic or photorealistic rendering. 3:2 landscape. Simple geometric shapes, soft even lighting, minimal shading, generous light/white negative space. Palette: teal, soft slate blue, warm cream/neutral background, gentle pastel accents — bright and welcoming, never dark or moody. Friendly and encouraging, suitable for a nursing/medical-school app used by young students.
SCENE: ${prompt}
STRICT RULES — do not include ANY of: photorealism, oil-painting or cinematic lighting, dark/gothic/moody atmosphere, candles or candlelight, skulls, skeletons, occult or alchemist imagery, antique/Renaissance settings, horror or unsettling elements, text, letters, numbers, labels, captions, watermarks, or typography of any kind.`;

  let res = await callImageApi(HERO_MODEL, full, {
    size: "1536x1024",
    quality: "medium",
  });
  if (!res.ok && res.status >= 400 && res.status < 500) {
    const errText = await res.text();
    console.warn(`${HERO_MODEL} rejected (${res.status}: ${errText}) — falling back to ${HERO_MODEL_FALLBACK}`);
    res = await callImageApi(HERO_MODEL_FALLBACK, full, { size: "1536x1024", quality: "medium" });
  }
  if (!res.ok) throw new Error(`OpenAI image error ${res.status}: ${await res.text()}`);
  const json = (await res.json()) as { data?: { b64_json?: string }[] };
  const b64 = json.data?.[0]?.b64_json;
  if (!b64) throw new Error("OpenAI image: empty response");
  return sharp(Buffer.from(b64, "base64")).resize({ width: 1200 }).webp({ quality: 82 }).toBuffer();
}

function esc(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

/** Wrap Thai text at roughly `max` characters per line (breaks at spaces when possible). */
function wrap(text: string, max: number): string[] {
  const words = text.split(/\s+/);
  const lines: string[] = [];
  let cur = "";
  for (const w of words) {
    if (!cur) cur = w;
    else if ((cur + " " + w).length <= max) cur += " " + w;
    else {
      lines.push(cur);
      cur = w;
    }
    while (cur.length > max) {
      lines.push(cur.slice(0, max));
      cur = cur.slice(max);
    }
  }
  if (cur) lines.push(cur);
  return lines.slice(0, 2);
}

/** Summary card: same template for every lesson so the set reads as one system. */
function summaryCardSvg(opts: {
  headline: string;
  subject: string;
  layer: string;
  points: string[];
}): string {
  const accent = accentFor(opts.layer);
  const font = "Sarabun, 'Noto Sans Thai', system-ui, sans-serif";
  const rows = opts.points.slice(0, 5);
  const rowH = 120;
  const top = 250;
  const H = top + rows.length * rowH + 110;
  const items = rows
    .map((p, i) => {
      const y = top + i * rowH;
      const lines = wrap(p, 46);
      const text = lines
        .map(
          (l, j) =>
            `<tspan x="150" dy="${j === 0 ? 0 : 34}">${esc(l)}</tspan>`
        )
        .join("");
      return `
  <g>
    <rect x="60" y="${y}" width="1080" height="${rowH - 20}" rx="18" fill="#f8fafc" stroke="#e2e8f0" stroke-width="2"/>
    <circle cx="105" cy="${y + (rowH - 20) / 2}" r="26" fill="${accent.fg}"/>
    <text x="105" y="${y + (rowH - 20) / 2 + 10}" text-anchor="middle" font-family="${font}" font-size="28" font-weight="700" fill="#ffffff">${i + 1}</text>
    <text x="150" y="${y + (lines.length > 1 ? 40 : 58)}" font-family="${font}" font-size="26" fill="#0f172a">${text}</text>
  </g>`;
    })
    .join("");
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 ${H}" role="img" aria-labelledby="t">
  <title id="t">${esc(opts.headline)}</title>
  <rect width="1200" height="${H}" fill="#ffffff"/>
  <rect x="0" y="0" width="1200" height="170" fill="${accent.fg}"/>
  <text x="60" y="78" font-family="${font}" font-size="24" fill="#ffffff" opacity="0.85">${esc(opts.subject)} · ${esc(accent.name)}</text>
  <text x="60" y="132" font-family="${font}" font-size="40" font-weight="700" fill="#ffffff">${esc(opts.headline)}</text>
  <text x="60" y="215" font-family="${font}" font-size="22" fill="#64748b">สรุปบทนี้ใน 1 ภาพ — ทวนก่อนทำ Final Retrieval</text>${items}
  <text x="60" y="${H - 40}" font-family="${font}" font-size="18" fill="#94a3b8">รูปสรุปสร้างด้วย AI · ตรวจโดยทีมหมอรู้</text>
</svg>`;
}

// ────────────────────────────────────────────────────────────────────────────
// Step 3 — upload
// ────────────────────────────────────────────────────────────────────────────

async function upload(lessonId: string, name: string, buf: Buffer, contentType: string): Promise<string> {
  const filePath = `${PREFIX}/${lessonId}/${name}`;
  const { error } = await supabase.storage
    .from(BUCKET)
    .upload(filePath, buf, { contentType, upsert: true });
  if (error) throw new Error(`upload ${filePath}: ${error.message}`);
  const { data } = supabase.storage.from(BUCKET).getPublicUrl(filePath);
  // Cache-bust: upsert to the same path must not keep serving old bytes.
  return `${data.publicUrl}?v=${Date.now()}`;
}

// ────────────────────────────────────────────────────────────────────────────
// Step 4 — write back into body_md
// ────────────────────────────────────────────────────────────────────────────

/** Insert `md` after the paragraph of `part` that contains `anchor` (fallback: after the first paragraph). */
function insertAfterAnchor(part: string, anchor: string, md: string): string {
  const paras = part.split(/\n{2,}/);
  const needle = anchor.trim();
  let idx = paras.findIndex((p) => p.split("\n").some((l) => l.trim() === needle));
  if (idx === -1) idx = paras.findIndex((p) => needle && p.includes(needle));
  if (idx === -1) idx = 0;
  paras.splice(idx + 1, 0, md);
  return paras.join("\n\n");
}

/** Hero goes right after the H1 if the lesson starts with one, else at the very top. */
function insertHero(part: string, md: string): string {
  const paras = part.split(/\n{2,}/);
  const at = paras[0]?.trim().startsWith("# ") ? 1 : 0;
  paras.splice(at, 0, md);
  return paras.join("\n\n");
}

/** Remove images this script placed earlier (same storage prefix) so FORCE never duplicates. */
function stripGenerated(body: string, lessonId: string): string {
  const re = new RegExp(`^!\\[[^\\]]*\\]\\([^)]*${PREFIX}/${lessonId}/[^)]*\\)\\s*$`, "gm");
  return body.replace(re, "").replace(/\n{3,}/g, "\n\n");
}

// ────────────────────────────────────────────────────────────────────────────
// Main
// ────────────────────────────────────────────────────────────────────────────

async function loadLessons(): Promise<LessonRow[]> {
  let q = supabase
    .from("school_lessons")
    .select("id, topic_id, layer, title, body_md, sort_order, school_topics(code, name_th, slug)")
    .eq("status", "active")
    .order("sort_order");
  if (LESSON_ID) q = q.eq("id", LESSON_ID);
  const { data, error } = await q;
  if (error) throw new Error(error.message);
  const rows = (data ?? []) as unknown as LessonRow[];
  if (TOPIC) return rows.filter((r) => r.school_topics?.code === TOPIC);
  return rows;
}

async function processLesson(lesson: LessonRow): Promise<void> {
  const tag = `[${lesson.school_topics?.code ?? "?"} #${lesson.sort_order}] ${lesson.title}`;
  if (!lesson.body_md.trim()) {
    console.warn(`${tag}: empty body — skipped`);
    return;
  }
  if (hasFigures(lesson.body_md) && !FORCE) {
    console.log(`${tag}: already has figures — skipped (FORCE=1 to redo)`);
    return;
  }

  console.log(`${tag}: asking ${MODEL} for figure spec…`);
  const spec = await propose(lesson);
  const subject = `${lesson.school_topics?.code ?? ""} ${lesson.school_topics?.name_th ?? ""}`.trim();
  const summarySvg = summaryCardSvg({
    headline: spec.summary.headline,
    subject,
    layer: lesson.layer,
    points: spec.summary.points,
  });

  // Validate every SVG before touching storage or the DB.
  const figureBufs: { spec: FigureSpec; buf: Buffer; name: string }[] = [];
  for (const f of spec.figures) {
    try {
      const buf = await validateSvg(f.svg, `part ${f.part} "${f.title}"`);
      figureBufs.push({ spec: f, buf, name: `p${f.part}.svg` });
    } catch (e) {
      console.warn(`${tag}: dropped figure — ${(e as Error).message}`);
    }
  }
  const summaryBuf = await validateSvg(summarySvg, "summary card");

  // Hero goes through the real image API in both DRY and live runs — it's the
  // one step DRY previously skipped entirely (returned before reaching it),
  // which meant `DRY=1` never actually exercised the OpenAI call. Only the
  // Supabase upload + DB write below are gated on DRY, not the render.
  let heroBuf: Buffer | null = null;
  if (spec.hero) {
    try {
      heroBuf = await renderHero(spec.hero.image_prompt);
    } catch (e) {
      console.warn(`${tag}: hero skipped — ${(e as Error).message}`);
    }
  }

  if (DRY) {
    const dir = path.join(OUT_DIR, lesson.id);
    await mkdir(dir, { recursive: true });
    await writeFile(path.join(dir, "spec.json"), JSON.stringify({ ...spec, figures: spec.figures.map((f) => ({ ...f, svg: undefined })) }, null, 2));
    for (const f of figureBufs) await writeFile(path.join(dir, f.name), f.buf);
    await writeFile(path.join(dir, "summary.svg"), summaryBuf);
    if (heroBuf) await writeFile(path.join(dir, "hero.webp"), heroBuf);
    console.log(
      `${tag}: DRY — wrote ${figureBufs.length} diagrams + summary${heroBuf ? " + hero" : " (no hero — WITH_HERO not set, or see warning above if it was)"} to ${dir}`
    );
    return;
  }

  // Upload (hero was already rendered above).
  let heroUrl: string | null = null;
  if (heroBuf) heroUrl = await upload(lesson.id, "hero.webp", heroBuf, "image/webp");
  const figureUrls = new Map<FigureSpec, string>();
  for (const f of figureBufs) {
    figureUrls.set(f.spec, await upload(lesson.id, f.name, f.buf, "image/svg+xml"));
  }
  const summaryUrl = await upload(lesson.id, "summary.svg", summaryBuf, "image/svg+xml");

  // Write back body_md.
  const base = FORCE ? stripGenerated(lesson.body_md, lesson.id) : lesson.body_md;
  const { parts, gateRaw } = splitLessonPartsRaw(base);
  const next = [...parts];
  for (const [f, url] of figureUrls) {
    const i = Math.min(Math.max(f.part - 1, 0), next.length - 1);
    next[i] = insertAfterAnchor(next[i], f.anchor, figureMarkdown(url, { alt: f.alt, caption: f.caption }));
  }
  if (heroUrl && spec.hero) {
    next[0] = insertHero(next[0], figureMarkdown(heroUrl, { alt: spec.hero.alt, caption: spec.hero.caption }));
  }
  const body = joinLessonParts(next, gateRaw);
  const { error: upErr } = await supabase.from("school_lessons").update({ body_md: body }).eq("id", lesson.id);
  if (upErr) throw new Error(`update lesson: ${upErr.message}`);

  // Summary card → school_visuals (one per lesson from this script).
  await supabase.from("school_visuals").delete().eq("lesson_id", lesson.id).like("source", "figure-gen:%");
  const { error: visErr } = await supabase.from("school_visuals").insert({
    topic_id: lesson.topic_id,
    lesson_id: lesson.id,
    layer: lesson.layer,
    title: spec.summary.headline,
    image_url: summaryUrl,
    caption: spec.summary.points[0] ?? null,
    notes_md: spec.summary.points.map((p) => `- ${p}`).join("\n"),
    check_questions: spec.summary.check_questions,
    linked_flashcard_ids: [],
    source: SOURCE_TAG,
    sort_order: lesson.sort_order,
    status: "active",
  });
  if (visErr) throw new Error(`insert visual: ${visErr.message}`);

  console.log(
    `${tag}: done — ${figureUrls.size} diagrams, hero ${heroUrl ? "yes" : "no"}, summary card saved`
  );
}

async function main() {
  const lessons = await loadLessons();
  if (!lessons.length) {
    console.log("No lessons matched.");
    return;
  }
  console.log(`${lessons.length} lesson(s) · model ${MODEL} · ${DRY ? "DRY RUN" : "LIVE"}`);
  let failed = 0;
  for (const lesson of lessons) {
    try {
      await processLesson(lesson);
    } catch (e) {
      failed += 1;
      console.error(`FAILED ${lesson.title}: ${(e as Error).message}`);
    }
  }
  if (failed) process.exitCode = 1;
}

main();
