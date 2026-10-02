/**
 * generate-lesson-infographics — อินโฟกราฟิกสรุปบทเรียน School สไตล์เดียวกับที่ทำใน ChatGPT
 *
 * ทำไมไม่ใช้ hero ใน generate-lesson-figures.ts: ตัวนั้นส่ง prompt สั้น ๆ ตรงเข้า image API
 * ไม่มีตัวอย่างสไตล์ และเอารูปแรกไปใส่เลย ผลเลยไม่นิ่ง ส่วนรูปที่ทำใน ChatGPT สวยเพราะ
 * (1) มีการเขียน brief ละเอียดก่อน (2) มีตัวอย่างสไตล์ในบทสนทนา (3) คนเลือกรูปเอง
 * สคริปต์นี้ทำทั้ง 3 ข้อผ่าน API:
 *
 *   1. Claude อ่าน body_md แล้วจัดกลุ่ม Part ที่ต่อกันเป็นอินโฟกราฟิก 1 รูปต่อ 2–4 Part
 *      และเขียน brief ภาษาอังกฤษที่ระบุ layout + ข้อความไทย/อังกฤษทุกคำที่ต้องอยู่ในรูป
 *      (ข้อความมาจากบทเรียนเท่านั้น)
 *   2. ส่ง brief + รูปตัวอย่างสไตล์ใน scripts/infographic-style/*.jpg เข้า OpenAI
 *      /v1/images/edits (รูปตัวอย่างใช้คุมสไตล์ ไม่ใช่เนื้อหา) ได้ N รูปต่อ 1 อินโฟกราฟิก
 *   3. เขียนรูปทั้งหมด + review.html ลง scripts/lesson-infographics-out/{lesson_id}/
 *      ให้คนเปิดดูแล้วเลือก — ขั้นนี้ยังไม่แตะ Supabase
 *   4. รันอีกครั้งด้วย PICK=... เพื่ออัปโหลดรูปที่เลือกขึ้น Storage แล้วแทรกท้าย Part
 *      สุดท้ายของกลุ่ม (ก่อน Mini Quiz) ใน body_md
 *
 * Env ที่ต้องมี: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
 *   ขั้นสร้าง:  ANTHROPIC_API_KEY, OPENAI_API_KEY
 * Env เสริม:  MODEL (default claude-sonnet-5) · IMAGE_MODEL (default gpt-image-2.5-flare,
 *             ตกไป gpt-image-1 อัตโนมัติ) · N (รูปต่ออินโฟกราฟิก, default 3)
 *             · QUALITY (default high — ข้อความไทยเยอะ ต่ำกว่านี้ตัวอักษรเพี้ยน)
 *
 * เลือกบท:  LESSON_ID=<uuid>  หรือ  TOPIC="FMMD 1201"
 *
 * ขั้นที่ 1 — สร้างรูปให้เลือก (ไม่แตะ DB):
 *   TOPIC="FMMD 1201" npx tsx scripts/generate-lesson-infographics.ts
 *   → เปิด scripts/lesson-infographics-out/<lesson_id>/review.html
 *
 * ขั้นที่ 2 — ใส่รูปที่เลือก (ใช้ไฟล์ที่สร้างไว้ ไม่เรียก AI ซ้ำ):
 *   LESSON_ID=<uuid> PICK="1:2,2:1,3:3" npx tsx scripts/generate-lesson-infographics.ts
 *   (อินโฟกราฟิกที่ 1 ใช้รูปที่ 2, ที่ 2 ใช้รูปที่ 1 … อันไหนไม่อยากใส่ก็ไม่ต้องใส่ในรายการ)
 *   รันซ้ำได้ — รูปอินโฟกราฟิกเดิมของบทนั้นจะถูกลบออกก่อนแทรกชุดใหม่
 */

import { createClient } from "@supabase/supabase-js";
import Anthropic from "@anthropic-ai/sdk";
import sharp from "sharp";
import { mkdir, readdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { splitLessonPartsRaw, joinLessonParts } from "@/lib/school/lesson-parts";
import { figureMarkdown } from "@/lib/school/figures";

// ────────────────────────────────────────────────────────────────────────────
// Config
// ────────────────────────────────────────────────────────────────────────────

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const MODEL = process.env.MODEL ?? "claude-sonnet-5";
const IMAGE_MODEL = process.env.IMAGE_MODEL ?? "gpt-image-2.5-flare";
const IMAGE_MODEL_FALLBACK = "gpt-image-1";
const N = Math.min(Math.max(Number(process.env.N ?? 3) || 3, 1), 6);
const QUALITY = process.env.QUALITY ?? "high";

const LESSON_ID = process.env.LESSON_ID;
const TOPIC = process.env.TOPIC;
const PICK = process.env.PICK;

const BUCKET = "public-assets";
const PREFIX = "school/lessons";
const OUT_DIR = path.join(process.cwd(), "scripts", "lesson-infographics-out");
const STYLE_DIR = path.join(process.cwd(), "scripts", "infographic-style");
/** Storage file names start with this so re-applying can find and replace them. */
const FILE_PREFIX = "infographic-";

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}
if (!LESSON_ID && !TOPIC) {
  console.error('Pick lessons with LESSON_ID=<uuid> or TOPIC="FMMD 1201"');
  process.exit(1);
}
if (PICK && !LESSON_ID) {
  console.error("PICK needs a single LESSON_ID");
  process.exit(1);
}
if (!PICK && (!ANTHROPIC_API_KEY || !OPENAI_API_KEY)) {
  console.error("Generating needs ANTHROPIC_API_KEY and OPENAI_API_KEY");
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// ────────────────────────────────────────────────────────────────────────────
// Types
// ────────────────────────────────────────────────────────────────────────────

interface LessonRow {
  id: string;
  layer: string;
  title: string;
  body_md: string;
  sort_order: number;
  school_topics: { code: string | null; name_th: string } | null;
}

interface InfographicBrief {
  /** 1-based Part numbers covered, consecutive. The image goes at the end of the last one. */
  parts: number[];
  title: string;
  alt: string;
  caption: string;
  prompt: string;
}

/** Saved next to the images so the PICK run doesn't need to call any AI again. */
interface Manifest {
  lesson_id: string;
  model: string;
  image_model: string;
  infographics: (InfographicBrief & { files: string[] })[];
}

// ────────────────────────────────────────────────────────────────────────────
// Step 1 — Claude writes the briefs
// ────────────────────────────────────────────────────────────────────────────

const BRIEF_TOOL: Anthropic.Tool = {
  name: "plan_infographics",
  description: "Plan the summary infographics for one lesson.",
  input_schema: {
    type: "object",
    properties: {
      infographics: {
        type: "array",
        minItems: 1,
        maxItems: 5,
        items: {
          type: "object",
          properties: {
            parts: {
              type: "array",
              items: { type: "integer" },
              description: "Consecutive 1-based Part numbers this infographic summarises (usually 2–4).",
            },
            title: { type: "string", description: "Short Thai title, for the admin" },
            alt: { type: "string", description: "Thai, ≤ 120 chars, what the image shows" },
            caption: { type: "string", description: "Thai, one sentence shown under the image" },
            prompt: {
              type: "string",
              description:
                "English layout brief for the image model. See the system prompt for the required structure.",
            },
          },
          required: ["parts", "title", "alt", "caption", "prompt"],
        },
      },
    },
    required: ["infographics"],
  },
};

const SYSTEM = `You plan summary infographics for Thai medical-school micro-lessons. The lesson is split into
reading "Parts" by the marker line "## ⏸ Mini Quiz". An infographic is shown at the end of a group of Parts,
right before the quiz, as a one-look recap.

Grouping:
- Group consecutive Parts into infographics, usually 2–4 Parts each, so the whole lesson gets 2–4 images.
- Skip Parts that are only mnemonics, clinical connections or a closing summary unless they add a key fact.

Each infographic is ONE landscape 3:2 poster made of 3–5 rounded panels (like a study-notes page). For each
prompt write, in English:
1. A one-line overview of the grid (e.g. "Top row: two panels side by side; middle: one full-width panel; bottom: a table panel and a small panel").
2. Per panel: its position, its header text, the exact body text, and what to draw. Choose the visual that fits
   the content: numbered steps, arrow flow (A → B → C), comparison table, labelled anatomy/cell diagram with
   callouts, check/cross list, or a cute character explaining one point.
3. Put EVERY piece of text that must appear in the image inside double quotes, exactly as it should be rendered.
   Nothing outside quotes may be rendered as text.

Text rules (the image model renders Thai well only when text is short):
- Use the lesson's own wording: Thai sentences with English medical terms kept in English, like the lesson does.
- Headers ≤ 6 words. Each label or bullet ≤ 12 words. At most ~60 quoted strings per image.
- Only facts that are stated in the lesson text. Never invent numbers, doses, names or examples.
- Tables: at most 5 rows × 3 columns.

Style is set separately by reference images — do not describe colours or art style in the prompt.`;

async function planBriefs(lesson: LessonRow): Promise<InfographicBrief[]> {
  const anthropic = new Anthropic({ apiKey: ANTHROPIC_API_KEY, maxRetries: 4 });
  const { parts } = splitLessonPartsRaw(lesson.body_md);
  const numbered = parts.map((p, i) => `=== Part ${i + 1} ===\n${p}`).join("\n\n");
  const res = await anthropic.messages.create({
    model: MODEL,
    max_tokens: 16000,
    system: SYSTEM,
    tools: [BRIEF_TOOL],
    tool_choice: { type: "tool", name: BRIEF_TOOL.name },
    messages: [
      {
        role: "user",
        content: `Subject: ${lesson.school_topics?.code ?? ""} ${lesson.school_topics?.name_th ?? ""}\nLesson: ${lesson.title}\nThis lesson has ${parts.length} Parts.\n\n${numbered}`,
      },
    ],
  });
  const block = res.content.find((c) => c.type === "tool_use");
  if (!block || block.type !== "tool_use") throw new Error("model returned no tool call");
  const list = (block.input as { infographics?: InfographicBrief[] }).infographics;
  if (!Array.isArray(list) || !list.length) throw new Error("no infographics planned");
  return list
    .map((b) => ({
      ...b,
      parts: [...new Set(b.parts)]
        .filter((p) => Number.isInteger(p) && p >= 1 && p <= parts.length)
        .sort((a, z) => a - z),
    }))
    .filter((b) => b.parts.length > 0);
}

// ────────────────────────────────────────────────────────────────────────────
// Step 2 — render with style references
// ────────────────────────────────────────────────────────────────────────────

const STYLE = `Create a polished educational infographic poster for Thai medical students, landscape 3:2.

STYLE — match the attached reference images as closely as possible: same art style, colour palette, typography,
panel shapes, icon style and cute character style. Use them ONLY for style; do not copy their content, text or layout.
- Soft pastel palette: light aqua/teal panel backgrounds, lavender/purple for cells, pink, peach, soft yellow,
  with dark teal / navy pill-shaped section headers in bold white text.
- Rounded-corner card panels with subtle drop shadows on an off-white background, generous spacing.
- Clean, friendly vector illustration with soft shading and thin outlines; cute kawaii-style people (students,
  doctors) when a character is used. Bright and welcoming — never dark, gory or photorealistic.
- Crisp, rounded modern Thai sans-serif typography, high contrast, perfectly legible. Numbered teal circles,
  green check / red cross icons, teal arrows.

TEXT — render only the text inside double quotes below, spelled exactly as given (Thai and English).
Do not add any other words, letters, watermarks or signatures.

CONTENT:
`;

async function loadStyleRefs(): Promise<{ name: string; buf: Buffer }[]> {
  const names = (await readdir(STYLE_DIR)).filter((f) => /\.(png|jpe?g|webp)$/i.test(f)).sort();
  if (!names.length) throw new Error(`no style reference images in ${STYLE_DIR}`);
  return Promise.all(names.map(async (name) => ({ name, buf: await readFile(path.join(STYLE_DIR, name)) })));
}

function mimeOf(name: string): string {
  if (/\.png$/i.test(name)) return "image/png";
  if (/\.webp$/i.test(name)) return "image/webp";
  return "image/jpeg";
}

async function callEdits(model: string, prompt: string, refs: { name: string; buf: Buffer }[]) {
  const form = new FormData();
  form.append("model", model);
  form.append("prompt", prompt);
  form.append("n", String(N));
  form.append("size", "1536x1024");
  form.append("quality", QUALITY);
  for (const r of refs) {
    form.append("image[]", new Blob([new Uint8Array(r.buf)], { type: mimeOf(r.name) }), r.name);
  }
  return fetch("https://api.openai.com/v1/images/edits", {
    method: "POST",
    headers: { Authorization: `Bearer ${OPENAI_API_KEY}` },
    body: form,
  });
}

async function renderCandidates(brief: InfographicBrief, refs: { name: string; buf: Buffer }[]): Promise<Buffer[]> {
  const prompt = STYLE + brief.prompt;
  let res = await callEdits(IMAGE_MODEL, prompt, refs);
  if (!res.ok && res.status >= 400 && res.status < 500 && IMAGE_MODEL !== IMAGE_MODEL_FALLBACK) {
    console.warn(`  ${IMAGE_MODEL} rejected (${res.status}: ${await res.text()}) — falling back to ${IMAGE_MODEL_FALLBACK}`);
    res = await callEdits(IMAGE_MODEL_FALLBACK, prompt, refs);
  }
  if (!res.ok) throw new Error(`OpenAI image error ${res.status}: ${await res.text()}`);
  const json = (await res.json()) as { data?: { b64_json?: string }[] };
  const images = (json.data ?? []).map((d) => d.b64_json).filter((b): b is string => !!b);
  if (!images.length) throw new Error("OpenAI image: empty response");
  return Promise.all(
    images.map((b64) => sharp(Buffer.from(b64, "base64")).webp({ quality: 88 }).toBuffer())
  );
}

// ────────────────────────────────────────────────────────────────────────────
// Review page
// ────────────────────────────────────────────────────────────────────────────

function esc(s: string): string {
  return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function reviewHtml(lesson: LessonRow, manifest: Manifest): string {
  const sections = manifest.infographics
    .map(
      (g, i) => `
<section>
  <h2>อินโฟกราฟิกที่ ${i + 1} · Part ${g.parts.join(", ")} — ${esc(g.title)}</h2>
  <p class="cap">${esc(g.caption)}</p>
  <div class="grid">
    ${g.files
      .map(
        (f, j) => `<figure><a href="${f}" target="_blank"><img src="${f}" loading="lazy"></a><figcaption>รูปที่ ${j + 1} → <code>${i + 1}:${j + 1}</code></figcaption></figure>`
      )
      .join("\n    ")}
  </div>
  <details><summary>brief</summary><pre>${esc(g.prompt)}</pre></details>
</section>`
    )
    .join("\n");
  return `<!doctype html>
<html lang="th"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>เลือกอินโฟกราฟิก — ${esc(lesson.title)}</title>
<style>
body{font-family:system-ui,sans-serif;margin:24px;background:#f8fafc;color:#0f172a}
section{background:#fff;border:1px solid #e2e8f0;border-radius:14px;padding:16px;margin:0 0 24px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(420px,1fr));gap:12px}
img{width:100%;border-radius:8px;border:1px solid #e2e8f0}
.cap{color:#475569}pre{white-space:pre-wrap;font-size:12px;background:#f1f5f9;padding:12px;border-radius:8px}
code{background:#e0f2fe;padding:2px 6px;border-radius:6px}
</style></head><body>
<h1>${esc(lesson.title)}</h1>
<p>เลือกรูปที่ชอบ 1 รูปต่ออินโฟกราฟิก แล้วรัน:<br>
<code>LESSON_ID=${lesson.id} PICK="1:2,2:1" npx tsx scripts/generate-lesson-infographics.ts</code><br>
อินโฟกราฟิกไหนไม่มีรูปที่ใช้ได้ ไม่ต้องใส่ในรายการ · ตรวจข้อความไทย/ข้อเท็จจริงในรูปทุกครั้งก่อนเลือก</p>
${sections}
</body></html>`;
}

// ────────────────────────────────────────────────────────────────────────────
// Generate (step 1–3)
// ────────────────────────────────────────────────────────────────────────────

async function generate(lesson: LessonRow, refs: { name: string; buf: Buffer }[]): Promise<void> {
  const tag = `[${lesson.school_topics?.code ?? "?"} #${lesson.sort_order}] ${lesson.title}`;
  if (!lesson.body_md.trim()) {
    console.warn(`${tag}: empty body — skipped`);
    return;
  }
  console.log(`${tag}: planning infographics with ${MODEL}…`);
  const briefs = await planBriefs(lesson);
  const dir = path.join(OUT_DIR, lesson.id);
  await mkdir(dir, { recursive: true });

  const manifest: Manifest = { lesson_id: lesson.id, model: MODEL, image_model: IMAGE_MODEL, infographics: [] };
  for (const [i, brief] of briefs.entries()) {
    console.log(`  #${i + 1} Part ${brief.parts.join(",")} "${brief.title}" — rendering ${N} candidates…`);
    let files: string[] = [];
    try {
      const bufs = await renderCandidates(brief, refs);
      files = bufs.map((_, j) => `g${i + 1}-c${j + 1}.webp`);
      await Promise.all(bufs.map((b, j) => writeFile(path.join(dir, files[j]), b)));
    } catch (e) {
      console.warn(`  #${i + 1} failed — ${(e as Error).message}`);
    }
    manifest.infographics.push({ ...brief, files });
    // Save as we go so a later failure doesn't lose the images already paid for.
    await writeFile(path.join(dir, "manifest.json"), JSON.stringify(manifest, null, 2));
  }
  await writeFile(path.join(dir, "review.html"), reviewHtml(lesson, manifest));
  console.log(`${tag}: open ${path.join(dir, "review.html")} to pick`);
}

// ────────────────────────────────────────────────────────────────────────────
// Apply (step 4)
// ────────────────────────────────────────────────────────────────────────────

function parsePick(raw: string): Map<number, number> {
  const picks = new Map<number, number>();
  for (const item of raw.split(",").map((s) => s.trim()).filter(Boolean)) {
    const m = item.match(/^(\d+)\s*:\s*(\d+)$/);
    if (!m) throw new Error(`PICK item "${item}" must look like 1:2`);
    picks.set(Number(m[1]), Number(m[2]));
  }
  return picks;
}

/** Remove infographics a previous PICK run inserted, so re-applying replaces rather than duplicates. */
function stripInfographics(body: string, lessonId: string): string {
  // Caption titles may contain ")" — match the quoted title explicitly instead of [^)]*.
  const re = new RegExp(
    `^!\\[[^\\]]*\\]\\(\\S*${PREFIX}/${lessonId}/${FILE_PREFIX}\\S*?(?:\\s+"[^"]*")?\\)\\s*$`,
    "gm"
  );
  return body.replace(re, "").replace(/\n{3,}/g, "\n\n");
}

async function apply(lesson: LessonRow): Promise<void> {
  const dir = path.join(OUT_DIR, lesson.id);
  const manifest = JSON.parse(await readFile(path.join(dir, "manifest.json"), "utf8")) as Manifest;
  const picks = parsePick(PICK!);

  const inserts: { part: number; md: string }[] = [];
  for (const [g, c] of picks) {
    const info = manifest.infographics[g - 1];
    const file = info?.files[c - 1];
    if (!file) throw new Error(`no candidate ${g}:${c} in manifest`);
    const storagePath = `${PREFIX}/${lesson.id}/${FILE_PREFIX}${g}.webp`;
    const { error } = await supabase.storage
      .from(BUCKET)
      .upload(storagePath, await readFile(path.join(dir, file)), { contentType: "image/webp", upsert: true });
    if (error) throw new Error(`upload ${storagePath}: ${error.message}`);
    const { data } = supabase.storage.from(BUCKET).getPublicUrl(storagePath);
    // Cache-bust: upsert to the same path must not keep serving the old bytes.
    const url = `${data.publicUrl}?v=${Date.now()}`;
    inserts.push({ part: Math.max(...info.parts), md: figureMarkdown(url, { alt: info.alt, caption: info.caption }) });
  }

  const { parts, gateRaw } = splitLessonPartsRaw(stripInfographics(lesson.body_md, lesson.id));
  const next = [...parts];
  for (const { part, md } of inserts) {
    const i = Math.min(Math.max(part - 1, 0), next.length - 1);
    next[i] = `${next[i].trimEnd()}\n\n${md}\n`;
  }
  const { error } = await supabase
    .from("school_lessons")
    .update({ body_md: joinLessonParts(next, gateRaw) })
    .eq("id", lesson.id);
  if (error) throw new Error(`update lesson: ${error.message}`);
  console.log(`${lesson.title}: inserted ${inserts.length} infographic(s) — check it in /admin/school`);
}

// ────────────────────────────────────────────────────────────────────────────
// Main
// ────────────────────────────────────────────────────────────────────────────

async function loadLessons(): Promise<LessonRow[]> {
  let q = supabase
    .from("school_lessons")
    .select("id, layer, title, body_md, sort_order, school_topics(code, name_th)")
    .eq("status", "active")
    .order("sort_order");
  if (LESSON_ID) q = q.eq("id", LESSON_ID);
  const { data, error } = await q;
  if (error) throw new Error(error.message);
  const rows = (data ?? []) as unknown as LessonRow[];
  return TOPIC ? rows.filter((r) => r.school_topics?.code === TOPIC) : rows;
}

async function main() {
  const lessons = await loadLessons();
  if (!lessons.length) {
    console.log("No lessons matched.");
    return;
  }
  if (PICK) {
    await apply(lessons[0]);
    return;
  }
  const refs = await loadStyleRefs();
  console.log(
    `${lessons.length} lesson(s) · ${MODEL} → ${IMAGE_MODEL} · ${N} candidates each · ${refs.length} style refs`
  );
  let failed = 0;
  for (const lesson of lessons) {
    try {
      await generate(lesson, refs);
    } catch (e) {
      failed += 1;
      console.error(`FAILED ${lesson.title}: ${(e as Error).message}`);
    }
  }
  if (failed) process.exitCode = 1;
}

main();
