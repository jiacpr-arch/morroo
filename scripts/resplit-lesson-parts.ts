/**
 * resplit-lesson-parts — แบ่งบทเรียนเป็นส่วนสั้น ๆ แบบ "mini class"
 *
 * บทเรียนเดิมมี 3-4 Part ยาว Part ละ ~300 คำ สคริปต์นี้ให้ Claude แบ่งใหม่เป็น
 * 6-12 ส่วนสั้น (60-150 คำ, 1 ประเด็นต่อส่วน) แล้วใส่คำถามท้ายทุกส่วนรวมส่วน
 * สุดท้ายด้วย (trailing gate — ดู `lib/school/lesson-parts.ts`) ให้ตรงกับที่
 * `LessonReader` (layout="deck") โชว์ทีละส่วน คำถามทุกส่วน
 *
 * กติกาสำคัญ: **ย้ายข้อความเดิมไปวาง ไม่เขียนใหม่ ไม่เพิ่มข้อเท็จจริงใหม่** —
 * รูปที่แทรกไว้แล้ว (`![...](...)`​) ต้องอยู่ครบทุกรูป คำถามเดิมที่มีอยู่แล้ว
 * ให้ใช้ซ้ำกับส่วนที่ตรงกัน ส่วนที่ยังไม่มีคำถามค่อยแต่งใหม่ (ต้องตอบได้จาก
 * ส่วนนั้นเท่านั้น) ไล่ระดับง่าย→ยากตลอดบท
 *
 * ตรวจสอบก่อนบันทึกทุกครั้ง (ไม่ผ่านข้อไหน = ข้ามบทนั้น ไม่แตะ DB):
 *   - จำนวนส่วน 6-12, ทุกคำถามแยกเป็น JSON ที่ parser จริงอ่านได้ (round-trip
 *     ผ่าน buildLessonBody → splitLessonParts)
 *   - ทุกย่อหน้าของเนื้อหาเดิมต้องเจอในผลลัพธ์ (ตรวจแบบ normalize ช่องว่าง/ตัวเน้น)
 *     และความยาวรวมต้องไม่เพี้ยนเกิน ±5%
 *   - บรรทัดรูปภาพเดิมทุกบรรทัดต้องอยู่ครบ ไม่หาย ไม่ซ้ำ
 *
 * Env ที่ต้องมี: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, ANTHROPIC_API_KEY
 * Env เสริม:     MODEL (default claude-sonnet-4-6)
 *
 * เลือกบท:  LESSON_ID=<uuid>   หรือ  TOPIC="FMMD 1201" (ทุกบทในวิชา)  หรือ  ALL=1
 * ควบคุม:   DRY=1   เขียน before/after/spec ลง scripts/lesson-resplit-out/ อย่างเดียว ไม่แตะ DB
 *           FORCE=1 ทำซ้ำแม้บทถูกแบ่งแบบ mini class แล้ว (≥6 ส่วน + trailing gate)
 *
 * รัน:  npx tsx scripts/resplit-lesson-parts.ts
 * (ตัวแปรทั้งหมดข้างบนเป็น env var — ต้องอยู่ *หน้า* คำสั่ง หรือ export ไว้ก่อน ไม่ใช่
 *  argument ต่อท้าย เหมือน `scripts/generate-lesson-figures.ts`)
 *
 * โหมดจริง (ไม่มี DRY) สำรอง body_md เดิมไว้ที่ public.school_lessons_resplit_backup_20260920
 * ก่อนเขียนทับเสมอ (รัน `supabase/school_resplit_backup_20260920.sql` ครั้งเดียวก่อน) — ตาราง
 * นี้ตั้งใจไว้ใน public schema (ไม่ใช่ archive) เพราะ PostgREST (ที่ client ตัวนี้คุยด้วย)
 * เข้าถึง schema อื่นได้เฉพาะที่เปิด "Exposed schemas" ไว้ใน Supabase dashboard เท่านั้น —
 * ใช้ RLS เปิดแต่ไม่มี policy แทน (ปิดกั้น anon/authenticated โดยอัตโนมัติ, service role
 * ข้าม RLS ได้อยู่แล้วเลยยังเขียนได้) กู้คืนทีหลังได้ด้วย Supabase MCP/SQL ตรง ๆ
 * หลังรันทุกครั้ง เปิดดูบทใน /admin/school → tab แก้ไข ก่อนปล่อยให้นักเรียนเห็น
 */

import { createClient } from "@supabase/supabase-js";
import Anthropic from "@anthropic-ai/sdk";
import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import {
  splitLessonPartsRaw,
  splitLessonParts,
  buildLessonBody,
  hasTrailingGate,
  type InlineQuiz,
} from "@/lib/school/lesson-parts";
import type { SchoolDifficulty } from "@/lib/types-school";

// ────────────────────────────────────────────────────────────────────────────
// Config
// ────────────────────────────────────────────────────────────────────────────

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const ANTHROPIC_API_KEY = process.env.ANTHROPIC_API_KEY;
const MODEL = process.env.MODEL ?? "claude-sonnet-4-6";

const LESSON_ID = process.env.LESSON_ID;
const TOPIC = process.env.TOPIC;
const ALL = flag("ALL");
const DRY = flag("DRY");
const FORCE = flag("FORCE");

const OUT_DIR = path.join(process.cwd(), "scripts", "lesson-resplit-out");
const MIN_SECTIONS = 6;
const MAX_SECTIONS = 12;
const LENGTH_TOLERANCE = 0.05; // ±5%
const BACKUP_TABLE = "school_lessons_resplit_backup_20260920";

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
  estimated_min: number;
  sort_order: number;
  source: string | null;
  status: string;
  created_at: string;
  school_topics: { code: string | null; name_th: string } | null;
}

interface ResplitSection {
  body_md: string;
  heading?: string;
  quiz: {
    stem: string;
    choices: { label: string; text: string }[];
    correct_answer: string;
    explanation: string;
    difficulty: SchoolDifficulty;
  };
}

interface ResplitProposal {
  sections: ResplitSection[];
}

// ────────────────────────────────────────────────────────────────────────────
// Step 1 — ask Claude to re-split the lesson
// ────────────────────────────────────────────────────────────────────────────

const RESPLIT_TOOL: Anthropic.Tool = {
  name: "submit_resplit",
  description:
    "Re-split a lesson's long reading Parts into short 'mini class' sections, one question per section including the last.",
  input_schema: {
    type: "object",
    properties: {
      sections: {
        type: "array",
        minItems: MIN_SECTIONS,
        maxItems: MAX_SECTIONS,
        items: {
          type: "object",
          properties: {
            body_md: {
              type: "string",
              description:
                "This section's text, MOVED VERBATIM from the original lesson (same words, same markdown, same ![...](...) figure lines where they occur) — never rewritten, never new facts added. ~60-150 words; a table or list may run longer rather than being split apart.",
            },
            heading: {
              type: "string",
              description: "Optional short heading (≤ 40 chars) — only add one if the source had none for this content.",
            },
            quiz: {
              type: "object",
              description:
                "Answerable from this section alone. Reuse an existing gate quiz verbatim (stem/choices/correct_answer/explanation/difficulty unchanged) when it matches this section's content; otherwise author a new one.",
              properties: {
                stem: { type: "string" },
                choices: {
                  type: "array",
                  minItems: 4,
                  maxItems: 5,
                  items: {
                    type: "object",
                    properties: {
                      label: { type: "string", enum: ["A", "B", "C", "D", "E"] },
                      text: { type: "string" },
                    },
                    required: ["label", "text"],
                  },
                },
                correct_answer: { type: "string", enum: ["A", "B", "C", "D", "E"] },
                explanation: { type: "string" },
                difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
              },
              required: ["stem", "choices", "correct_answer", "explanation", "difficulty"],
            },
          },
          required: ["body_md", "quiz"],
        },
      },
    },
    required: ["sections"],
  },
};

const SYSTEM = `You restructure a Thai medical-school lesson into "mini class" sections for a card-deck reader that shows exactly one section per screen.

Rules:
- Produce ${MIN_SECTIONS}-${MAX_SECTIONS} sections. Each section: one idea, ~60-150 words. A table or list stays whole in one section even if that runs longer — never split a table/list apart.
- Move text VERBATIM. Do not rewrite, summarize, or paraphrase; do not add or remove facts. Every original paragraph must reappear, in order, inside some section's body_md. Every original "![alt](url \\"caption\\")" figure line must reappear exactly once, inside the section whose surrounding text it belongs to.
- Every section gets exactly one quiz, answerable from that section alone (including the LAST section — this lesson ends on a question too, unlike the old format).
- The lesson already has some gate quizzes authored inline; when a section's content matches one of them, reuse it (same stem/choices/correct_answer/explanation/difficulty) instead of writing a new one — do not discard existing quiz work.
- Order sections so quiz difficulty ramps roughly easy → hard across the lesson.
- Keep the lesson's own headings (### ...) where they already exist; only add a new heading when a section had none and one would help.`;

async function resplit(lesson: LessonRow): Promise<ResplitProposal> {
  const { parts, gateQuizzes } = splitLessonPartsRaw(lesson.body_md);
  const numbered = parts
    .map((p, i) => {
      const q = gateQuizzes[i];
      const qBlock = q ? `\n[existing gate quiz for this Part]\n${JSON.stringify(q)}` : "";
      return `=== Part ${i + 1} ===\n${p}${qBlock}`;
    })
    .join("\n\n");

  const res = await anthropic.messages.create({
    model: MODEL,
    max_tokens: 16000,
    system: SYSTEM,
    tools: [RESPLIT_TOOL],
    tool_choice: { type: "tool", name: RESPLIT_TOOL.name },
    messages: [
      {
        role: "user",
        content: `Subject: ${lesson.school_topics?.code ?? ""} ${lesson.school_topics?.name_th ?? ""}\nLesson: ${lesson.title}\n\n${numbered}`,
      },
    ],
  });
  const block = res.content.find((c) => c.type === "tool_use");
  if (!block || block.type !== "tool_use") throw new Error("model returned no tool call");
  const input = block.input as Partial<ResplitProposal>;
  if (!Array.isArray(input.sections)) throw new Error("no sections in response");
  return { sections: input.sections };
}

// ────────────────────────────────────────────────────────────────────────────
// Step 2 — validate
// ────────────────────────────────────────────────────────────────────────────

/** Collapse whitespace and strip markdown emphasis so verbatim comparison ignores cosmetic diffs. */
function normalize(s: string): string {
  return s.replace(/[*_`]/g, "").replace(/\s+/g, " ").trim();
}

const FIGURE_LINE_RE = /!\[[^\]]*\]\([^)]*\)(?:\s*"[^"]*")?/g;

class ValidationError extends Error {}

/**
 * Throws `ValidationError` on the first thing that isn't right. Nothing here
 * mutates the DB — the caller only proceeds to write once this returns.
 */
function validate(lesson: LessonRow, proposal: ResplitProposal, builtBody: string): void {
  const n = proposal.sections.length;
  if (n < MIN_SECTIONS || n > MAX_SECTIONS) {
    throw new ValidationError(`${n} sections (need ${MIN_SECTIONS}-${MAX_SECTIONS})`);
  }

  // The quizzes must round-trip through the REAL parser, not just look right —
  // build the body the same way live mode will, then re-read it back.
  const reparsed = splitLessonParts(builtBody);
  if (reparsed.parts.length !== n) {
    throw new ValidationError(
      `built body parses back into ${reparsed.parts.length} parts, expected ${n}`
    );
  }
  if (reparsed.gateQuizzes.some((q) => q === null)) {
    throw new ValidationError("a quiz block failed to round-trip through the parser");
  }
  if (!hasTrailingGate(builtBody)) {
    throw new ValidationError("built body has no trailing gate (last section has no quiz)");
  }

  // Verbatim coverage: every original paragraph must reappear somewhere in the output.
  const { parts: originalParts } = splitLessonPartsRaw(lesson.body_md);
  const originalParagraphs = originalParts
    .flatMap((p) => p.split(/\n{2,}/))
    .map((p) => p.trim())
    .filter(Boolean);
  const outputNormalized = normalize(proposal.sections.map((s) => s.body_md).join("\n\n"));
  const missing = originalParagraphs.filter((p) => !outputNormalized.includes(normalize(p)));
  if (missing.length > 0) {
    const sample = missing[0].slice(0, 80);
    throw new ValidationError(`${missing.length} original paragraph(s) missing from output, e.g. "${sample}…"`);
  }

  // Length tolerance — catches silent rewriting/summarizing even when every
  // paragraph technically "appears" (e.g. inside a longer rewritten passage).
  const originalLen = normalize(originalParts.join(" ")).length;
  const outputLen = outputNormalized.length;
  const delta = originalLen === 0 ? 0 : Math.abs(outputLen - originalLen) / originalLen;
  if (delta > LENGTH_TOLERANCE) {
    throw new ValidationError(
      `output length drifted ${(delta * 100).toFixed(1)}% from the original (limit ${LENGTH_TOLERANCE * 100}%) — looks rewritten, not moved`
    );
  }

  // Every original figure line must reappear exactly once.
  const originalFigures = (lesson.body_md.match(FIGURE_LINE_RE) ?? []).map(normalize).sort();
  const outputFigures = (builtBody.match(FIGURE_LINE_RE) ?? []).map(normalize).sort();
  if (JSON.stringify(originalFigures) !== JSON.stringify(outputFigures)) {
    throw new ValidationError(
      `figure lines don't match 1:1 (original ${originalFigures.length}, output ${outputFigures.length})`
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Main
// ────────────────────────────────────────────────────────────────────────────

async function loadLessons(): Promise<LessonRow[]> {
  let q = supabase
    .from("school_lessons")
    .select(
      "id, topic_id, layer, title, body_md, estimated_min, sort_order, source, status, created_at, school_topics(code, name_th)"
    )
    .eq("status", "active")
    .order("sort_order");
  if (LESSON_ID) q = q.eq("id", LESSON_ID);
  const { data, error } = await q;
  if (error) throw new Error(error.message);
  const rows = (data ?? []) as unknown as LessonRow[];
  if (TOPIC) return rows.filter((r) => r.school_topics?.code === TOPIC);
  return rows;
}

function alreadyMiniClass(body: string): boolean {
  const { parts } = splitLessonPartsRaw(body);
  return parts.length >= MIN_SECTIONS && hasTrailingGate(body);
}

async function backupAndSave(lesson: LessonRow, body: string): Promise<void> {
  // Own id (not lesson.id) so re-running with FORCE keeps every prior backup
  // instead of colliding on a primary key — full history, never overwritten.
  const { error: backupErr } = await supabase.from(BACKUP_TABLE).insert({
    lesson_id: lesson.id,
    topic_id: lesson.topic_id,
    layer: lesson.layer,
    title: lesson.title,
    body_md: lesson.body_md,
    estimated_min: lesson.estimated_min,
    sort_order: lesson.sort_order,
    source: lesson.source,
    status: lesson.status,
    lesson_created_at: lesson.created_at,
  });
  if (backupErr) {
    throw new Error(
      `backup insert failed (run supabase/school_resplit_backup_20260920.sql first?): ${backupErr.message}`
    );
  }
  const { error: updateErr } = await supabase
    .from("school_lessons")
    .update({ body_md: body })
    .eq("id", lesson.id);
  if (updateErr) throw new Error(`update lesson: ${updateErr.message}`);
}

async function processLesson(lesson: LessonRow): Promise<void> {
  const tag = `[${lesson.school_topics?.code ?? "?"} #${lesson.sort_order}] ${lesson.title}`;
  if (!lesson.body_md.trim()) {
    console.warn(`${tag}: empty body — skipped`);
    return;
  }
  if (alreadyMiniClass(lesson.body_md) && !FORCE) {
    console.log(`${tag}: already mini-class (≥${MIN_SECTIONS} sections, trailing gate) — skipped (FORCE=1 to redo)`);
    return;
  }

  console.log(`${tag}: asking ${MODEL} to re-split…`);
  const proposal = await resplit(lesson);
  const builtBody = buildLessonBody(
    proposal.sections.map((s) => ({
      body: s.heading ? `### ${s.heading}\n\n${s.body_md.trim()}` : s.body_md.trim(),
      quiz: s.quiz as InlineQuiz,
    }))
  );

  validate(lesson, proposal, builtBody); // throws ValidationError → caller catches, skips this lesson

  const dir = path.join(OUT_DIR, lesson.id);
  await mkdir(dir, { recursive: true });
  await writeFile(path.join(dir, "before.md"), lesson.body_md);
  await writeFile(path.join(dir, "after.md"), builtBody);
  await writeFile(path.join(dir, "spec.json"), JSON.stringify(proposal, null, 2));

  if (DRY) {
    console.log(`${tag}: DRY — wrote ${proposal.sections.length} sections to ${dir}`);
    return;
  }

  await backupAndSave(lesson, builtBody);
  console.log(`${tag}: done — ${proposal.sections.length} sections, backed up original to ${BACKUP_TABLE}`);
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
      const prefix = e instanceof ValidationError ? "VALIDATION FAILED" : "FAILED";
      console.error(`${prefix} ${lesson.title}: ${(e as Error).message}`);
    }
  }
  if (failed) process.exitCode = 1;
}

main();
