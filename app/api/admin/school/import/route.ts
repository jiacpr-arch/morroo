/**
 * School import — AI extraction, split into small steps.
 *
 * Why steps? Generating a lesson + all flashcards + a full question bank in one
 * request needs 20k-60k output tokens. That takes several minutes of model time,
 * which blows past the serverless execution limit (the function is killed and
 * the browser just sees the request die) — and `max_tokens` that large is also
 * rejected outright on a non-streaming request. So the client drives one small
 * request per step instead:
 *
 *   step=lesson      → the source file, once. Returns lesson + topic guess.
 *   step=flashcards  → derived from the returned lesson text (no re-upload).
 *   step=quizzes     → same, one small batch per call; the client loops.
 *
 * Every step caps `max_tokens` and streams the response so a slow generation can
 * never trip the non-streaming duration ceiling. When a step does hit its cap
 * the response is cut mid-JSON — see `lib/school/tool-json` for how the half
 * written field is recovered instead of silently vanishing.
 */
import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createAnthropic } from "@/lib/anthropic";
import { createClient } from "@/lib/supabase/server";
import { compareTopicByCode } from "@/lib/school/topic-order";
import {
  DIRECT_UPLOAD_MAX,
  isAllowedType,
  mediaTypeForPath,
  TOTAL_MAX,
} from "@/lib/school/import-files";
import {
  estimateMinutes,
  keepComplete,
  recoverStringField,
  tidyTruncatedBody,
} from "@/lib/school/tool-json";

const MODEL = "claude-sonnet-5";
const CLASSIFY_MODEL = "claude-haiku-4-5";

export const runtime = "nodejs";
export const maxDuration = 300;

type Mode = "faithful" | "expand" | "deep";
type Step = "lesson" | "flashcards" | "quizzes";

/**
 * Output ceiling per step. Small on purpose — see the file header — but the
 * lesson needs real headroom: a 700-1200 word Thai lesson plus 6-12 embedded
 * quiz blocks (one per part now, including the last — up from 2-4) is
 * ~7-10k tokens once JSON-escaped, so a lower ceiling truncated routinely
 * and cost the user two minutes of generation each time.
 */
const STEP_MAX_TOKENS: Record<Step, number> = {
  lesson: 16000,
  flashcards: 4500,
  quizzes: 5000,
};

const LAYERS = [
  "foundation",
  "anatomy",
  "physio",
  "biochem",
  "path",
  "pharm",
  "clinical",
] as const;

// ────────────────────────────────────────────────────────────────────────────
// Tools — one per step, so the model only ever fills a small payload
// ────────────────────────────────────────────────────────────────────────────

const LESSON_TOOL: Anthropic.Tool = {
  name: "submit_lesson",
  description: "Submit the lesson extracted from the source material.",
  input_schema: {
    type: "object",
    properties: {
      title: { type: "string", description: "Concise lesson title (Thai or English)" },
      body_md: {
        type: "string",
        description:
          "Markdown lesson split into 6-12 short parts (one idea each, ~60-150 words — this is a 'mini class' card deck that shows one part per screen, not a long-form article). " +
          "After EVERY part — including the very last one — put a `## ⏸ Mini Quiz` marker line, and immediately after each marker embed ONE quiz that tests the part just above it, as a fenced ```quiz block containing JSON: " +
          '{ "stem": string, "choices": [{ "label": "A"|"B"|"C"|"D", "text": string }], "correct_answer": "A"|"B"|"C"|"D", "explanation": string, "difficulty": "easy"|"medium"|"hard" }. ' +
          "The inline quiz MUST be answerable from the part directly above it. Order the parts so quiz difficulty ramps roughly easy → hard across the lesson. " +
          "A table or list stays whole inside one part even if that part runs longer than 150 words — never split a table/list apart. " +
          "Aim for 700-1200 words of prose total, split across the parts.",
      },
      layer: { type: "string", enum: [...LAYERS] },
      estimated_min: { type: "integer", minimum: 1, maximum: 120 },
    },
    required: ["title", "body_md", "layer", "estimated_min"],
  },
};

const FLASHCARDS_TOOL: Anthropic.Tool = {
  name: "submit_flashcards",
  description: "Submit a batch of atomic flashcards for the lesson.",
  input_schema: {
    type: "object",
    properties: {
      flashcards: {
        type: "array",
        items: {
          type: "object",
          properties: {
            front: { type: "string", description: "Concept/question, under 120 chars" },
            back: { type: "string", description: "Answer, 1-4 sentences, under 400 chars" },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: ["front", "back", "difficulty"],
        },
      },
    },
    required: ["flashcards"],
  },
};

const QUIZZES_TOOL: Anthropic.Tool = {
  name: "submit_quizzes",
  description: "Submit a batch of multiple-choice questions for the topic question bank.",
  input_schema: {
    type: "object",
    properties: {
      quizzes: {
        type: "array",
        items: {
          type: "object",
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
    },
    required: ["quizzes"],
  },
};

// ────────────────────────────────────────────────────────────────────────────
// Prompts
// ────────────────────────────────────────────────────────────────────────────

const SYSTEM_BASE = `You are an expert medical educator creating micro-learning units for Thai medical students (นักศึกษาแพทย์ Y1-Y6).

Audience context:
- Thai medical students study with mixed Thai + English medical terminology.
- Source material is often summary notes from senior students (รุ่นพี่) — concise, often missing foundational context that the senior assumed the reader knew.
- Students need to BOTH pass exams (NL/comprehensive) AND understand for clinical practice.

General quality rules:
- Write in Thai mixed with English medical terms (the natural language of Thai med students).
- Format math/equations in plain text — no LaTeX.
- Prefer clinically relevant content over rote trivia.
- Use concrete examples, not abstract definitions.
- When you state a mechanism, briefly explain WHY (cause → effect chain).`;

const MODE_INSTRUCTIONS: Record<Mode, string> = {
  faithful: `MODE: FAITHFUL EXTRACTION
- Stay strictly to what's in the source material.
- Do NOT add facts, examples, or context not present in the source.
- Use this mode when the source is authoritative (textbook, lecture).`,

  expand: `MODE: EXPAND FOR UNDERSTANDING
The source is a senior student's summary — often condensed and missing foundational context. Make it learnable for a student seeing this topic for the first time.

You MAY and SHOULD:
- Fill in foundational concepts the source assumes (anatomy, physiology basics, prerequisites).
- Add concrete clinical examples and patient scenarios.
- Add analogies that help intuition (เปรียบเทียบกับสิ่งใกล้ตัว).
- Add Thai mnemonics (สูตรช่วยจำ) where they aid memorization.
- Add "Why it matters" framing — when/why a clinician needs this knowledge.
- Add clinical pearls (high-yield points for NL/ward).

You MUST NOT:
- Invent facts that contradict the source.
- Add speculative/unverified information.
- State a specific drug dose, lab cut-off, or numeric threshold that is not in the source. If a number matters but the source omits it, describe it qualitatively instead.
- Skip topics from the source.

Mark every section you added that is NOT derived from the source with a trailing " (เพิ่มโดย AI)" on its heading, so the reviewer knows what to fact-check.`,

  deep: `MODE: DEEP DIVE
Same expansion rules as EXPAND mode (including the ban on inventing doses/cut-offs and the " (เพิ่มโดย AI)" heading marker), but go further:
- Detailed mechanisms with step-by-step pathophysiology.
- Multiple clinical scenarios per concept (Y3-Y6 ward perspective).
- Common exam pitfalls and high-yield distinctions (e.g., "Don't confuse X with Y because…").
- Include differential diagnosis thinking where relevant.`,
};

const LESSON_STRUCTURE: Record<Mode, string> = {
  faithful: `Lesson: 6-12 short parts total (~60-150 words each, one idea per part), a mini-quiz after EVERY part including the last.`,
  expand: `Lesson sections, each further split into short ~60-150-word parts so the WHOLE lesson totals 6-12 parts (a mini-quiz goes after every part, including the very last one):
  ## 🧠 Why it matters (usually 1 part)
  ## 🔑 Key concepts (split into several short parts, one idea each — most of the 6-12)
  ## 💡 Clinical pearls (1 part)
  ## 🎯 Mnemonics (optional, 0-1 part)
  ## 🔗 Connections to other topics (1 part)
estimated_min: 15-30.`,
  deep: `Lesson sections, each a short ~60-150-word part (split "Key concepts" further if needed) so the WHOLE lesson totals 6-12 parts — merge or drop optional sections rather than exceeding 12. A mini-quiz goes after EVERY part, including the very last one:
  ## 🧠 Why it matters
  ## 📚 Foundation review (prerequisites)
  ## 🔑 Key concepts (split into a few short parts)
  ## 🩺 Clinical application (cases)
  ## 💡 Clinical pearls + high-yield
  ## ⚠️ Common pitfalls
  ## 🎯 Mnemonics
  ## 🔗 Connections to other topics
estimated_min: 25-45.`,
};

// ────────────────────────────────────────────────────────────────────────────
// Model plumbing
// ────────────────────────────────────────────────────────────────────────────

interface StepResult {
  /** Parsed tool input. Fields the model only half-wrote are missing from it. */
  input: Record<string, unknown>;
  /** The raw tool JSON, half-written tail included. */
  raw: string;
  /** True when the model ran out of `max_tokens` mid-answer. */
  truncated: boolean;
}

/**
 * Run one step. Streams so that a slow generation can't hit the API's
 * non-streaming duration ceiling, then reads the single tool_use block.
 *
 * The raw `input_json_delta` text is kept alongside the parsed input: the SDK
 * parses the buffer leniently and throws away any value it only saw part of, so
 * on a `max_tokens` cut the parsed input silently loses whichever field the
 * model was writing. Callers use the raw buffer to get it back.
 */
async function runStep(
  step: Step,
  tool: Anthropic.Tool,
  system: Anthropic.TextBlockParam[],
  content: Anthropic.MessageParam["content"],
): Promise<StepResult> {
  if (!process.env.ANTHROPIC_API_KEY) throw new Error("ANTHROPIC_API_KEY not set");
  const client = createAnthropic();
  const stream = client.messages.stream({
    model: MODEL,
    max_tokens: STEP_MAX_TOKENS[step],
    system,
    tools: [tool],
    tool_choice: { type: "tool", name: tool.name },
    messages: [{ role: "user", content }],
  });
  let raw = "";
  for await (const event of stream) {
    if (event.type === "content_block_delta" && event.delta.type === "input_json_delta") {
      raw += event.delta.partial_json;
    }
  }
  const message = await stream.finalMessage();
  const block = message.content.find((b) => b.type === "tool_use");
  if (!block || block.type !== "tool_use") {
    throw new Error(`โมเดลไม่ได้ตอบเป็น ${tool.name}`);
  }
  return {
    input: block.input as Record<string, unknown>,
    raw,
    truncated: message.stop_reason === "max_tokens",
  };
}

function systemFor(mode: Mode, extra?: string): Anthropic.TextBlockParam[] {
  // Base is identical across every import → cache hit after the first call.
  const blocks: Anthropic.TextBlockParam[] = [
    { type: "text", text: SYSTEM_BASE, cache_control: { type: "ephemeral" } },
    { type: "text", text: MODE_INSTRUCTIONS[mode] },
  ];
  if (extra) blocks.push({ type: "text", text: extra });
  return blocks;
}

/** Wrap one file's bytes as the content block its type calls for. */
function mediaBlockFor(mediaType: string, bytes: Buffer): Anthropic.ContentBlockParam {
  const data = bytes.toString("base64");
  return mediaType === "application/pdf"
    ? { type: "document", source: { type: "base64", media_type: "application/pdf", data } }
    : {
        type: "image",
        source: {
          type: "base64",
          media_type: mediaType as Anthropic.Base64ImageSource["media_type"],
          data,
        },
      };
}

function parseMode(raw: unknown): Mode {
  if (raw === "faithful" || raw === "expand" || raw === "deep") return raw;
  return "faithful";
}

function parseStep(raw: unknown): Step {
  if (raw === "flashcards" || raw === "quizzes") return raw;
  return "lesson";
}

// ────────────────────────────────────────────────────────────────────────────
// Topic classification (cheap, runs alongside the lesson step)
// ────────────────────────────────────────────────────────────────────────────

interface TopicCandidate {
  id: string;
  year: number;
  term: number | null;
  name_th: string;
  system_name: string;
  code: string | null;
}

interface ClassifyResult {
  suggested_topic_id: string | null;
  confidence: number;
  reasoning: string;
}

const CLASSIFY_TOOL: Anthropic.Tool = {
  name: "submit_topic_classification",
  description: "Submit which existing curriculum subject best matches the material.",
  input_schema: {
    type: "object",
    properties: {
      suggested_topic_index: {
        type: "integer",
        description:
          "Index (0-based) of the best-matching subject from the provided list. Use -1 if none is a good match.",
      },
      confidence: {
        type: "number",
        description: "Confidence 0.0-1.0 that the suggestion is correct.",
        minimum: 0,
        maximum: 1,
      },
      reasoning: {
        type: "string",
        description: "One short sentence (Thai) explaining the match, or why none fit.",
      },
    },
    required: ["suggested_topic_index", "confidence", "reasoning"],
  },
};

async function loadTopicCandidates(
  supabase: Awaited<ReturnType<typeof createClient>>,
): Promise<TopicCandidate[]> {
  const { data } = await supabase
    .from("school_topics")
    .select("id, year, term, name_th, code, school_systems(name_th)")
    .order("year")
    .limit(500);
  if (!data) return [];
  return (
    data as Array<{
      id: string;
      year: number;
      term: number | null;
      name_th: string;
      code: string | null;
      school_systems: { name_th: string } | { name_th: string }[] | null;
    }>
  ).map((r) => {
    const sys = Array.isArray(r.school_systems) ? r.school_systems[0] : r.school_systems;
    return {
      id: r.id,
      year: r.year,
      term: r.term ?? null,
      name_th: r.name_th,
      system_name: sys?.name_th ?? "—",
      code: r.code ?? null,
    };
  })
  // เรียงตามชั้นปี + รหัสวิชา ให้ลิสต์ที่ส่งให้โมเดลอ่านง่ายเหมือนฝั่งนักเรียน
  .sort((a, b) => a.year - b.year || compareTopicByCode(a, b));
}

async function classifyTopic(
  classifyContent: Anthropic.ContentBlockParam[],
  topics: TopicCandidate[],
): Promise<ClassifyResult | null> {
  if (!process.env.ANTHROPIC_API_KEY || topics.length === 0) return null;
  const client = createAnthropic();

  const topicList = topics
    .map(
      (t, i) =>
        `${i}. Y${t.year}${t.term ? ` เทอม${t.term}` : ""} · ${t.system_name} · ${t.name_th}${
          t.code ? ` · รหัสวิชา ${t.code}` : ""
        }`,
    )
    .join("\n");

  const system = `You classify Thai medical-school study materials into the correct curriculum subject.

You will be given (1) the source material (PDF/text/image), and (2) a numbered list of existing subjects (year + term + system + subject name + course code).

Pick the index of the subject that best matches the material, or -1 if none is a reasonable fit.

Many Thai lecture slides print the course code (e.g. "FMMD 1104", "พศพบ 1104") on the cover or header. If the material shows a course code matching a subject's รหัสวิชา, that subject is the answer — confidence 0.95+.

Be conservative — only return confidence >0.8 if the match is clearly correct.`;

  try {
    const response = await client.messages.create({
      model: CLASSIFY_MODEL,
      max_tokens: 800,
      system,
      tools: [CLASSIFY_TOOL],
      tool_choice: { type: "tool", name: "submit_topic_classification" },
      messages: [
        {
          role: "user",
          content: [
            ...classifyContent,
            {
              type: "text",
              text: `Existing subjects (pick the index that matches, or -1):\n\n${topicList}`,
            },
          ],
        },
      ],
    });
    const tool = response.content.find((b) => b.type === "tool_use");
    if (!tool || tool.type !== "tool_use") return null;
    const input = tool.input as {
      suggested_topic_index: number;
      confidence: number;
      reasoning: string;
    };
    const idx = input.suggested_topic_index;
    return {
      suggested_topic_id: idx >= 0 && idx < topics.length ? topics[idx].id : null,
      confidence: input.confidence,
      reasoning: input.reasoning,
    };
  } catch (e) {
    console.error("classify error", e);
    return null;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Step handlers
// ────────────────────────────────────────────────────────────────────────────

interface LessonShape {
  title: string;
  body_md: string;
  layer: string;
  estimated_min: number;
}

/**
 * Turn a lesson step's output into a lesson, recovering whatever a `max_tokens`
 * cut took with it. Two minutes of generation and a fully-read PDF are too
 * expensive to throw away over a missing tail — the reviewer edits the lesson
 * before saving anyway, and `tidyTruncatedBody` tells them where to look.
 */
function buildLesson(res: StepResult): LessonShape {
  const out = res.input;

  const rawTitle = typeof out.title === "string" ? out.title : recoverStringField(res.raw, "title");
  const title = (rawTitle ?? "").trim();

  const rawBody = typeof out.body_md === "string" ? out.body_md : null;
  let body = (rawBody?.trim() ? rawBody : recoverStringField(res.raw, "body_md")) ?? "";

  if (!title || !body.trim()) {
    throw new Error(
      res.truncated
        ? "AI เขียนบทเรียนยาวเกินโควตาจนไม่เหลือเนื้อหาที่ใช้ได้ — ลองแยกไฟล์ให้เล็กลง หรือลดระดับการขยายเนื้อหา"
        : "AI ไม่ได้ส่งเนื้อหาบทเรียนกลับมา — กด \"เริ่มสร้างเนื้อหา\" อีกครั้ง",
    );
  }
  if (res.truncated) body = tidyTruncatedBody(body);

  const layer = LAYERS.includes(out.layer as (typeof LAYERS)[number])
    ? (out.layer as string)
    : "foundation";
  const minutes =
    typeof out.estimated_min === "number" && Number.isFinite(out.estimated_min)
      ? Math.min(120, Math.max(1, Math.round(out.estimated_min)))
      : estimateMinutes(body);

  return { title, body_md: body, layer, estimated_min: minutes };
}

async function handleLessonStep(
  supabase: Awaited<ReturnType<typeof createClient>>,
  mode: Mode,
  mediaBlocks: Anthropic.ContentBlockParam[],
  hint: string,
) {
  // Several files are one lesson, not one lesson each — say so explicitly, or
  // the model tends to write a section per file and repeat shared background.
  const multiFileNote =
    mediaBlocks.length > 1
      ? `\n\nThe material above spans ${mediaBlocks.length} files covering the same subject. Write ONE unified lesson from all of them: merge overlapping content instead of repeating it, order the material by what teaches best rather than by file order, and don't refer to the files individually ("ไฟล์แรก", "เอกสารที่ 2"). Where files genuinely conflict, keep the fuller treatment.`
      : "";
  const content: Anthropic.MessageParam["content"] = [
    ...mediaBlocks,
    {
      type: "text",
      text: `Write the lesson for this material.\n\n${LESSON_STRUCTURE[mode]}${multiFileNote}${
        hint ? `\n\nHint: ${hint}` : ""
      }`,
    },
  ];
  const topics = await loadTopicCandidates(supabase);
  // Classify off the first block only — one page/excerpt is plenty, and it
  // keeps the Haiku call cheap.
  const [res, classification] = await Promise.all([
    runStep("lesson", LESSON_TOOL, systemFor(mode), content),
    classifyTopic(mediaBlocks.slice(0, 1), topics),
  ]);
  return NextResponse.json({
    lesson: buildLesson(res),
    classification,
    truncated: res.truncated,
  });
}

async function handleFlashcardsStep(body: {
  lesson?: LessonShape;
  extractMode?: string;
  count?: number;
  existing?: string[];
}) {
  const mode = parseMode(body.extractMode);
  if (!body.lesson?.body_md?.trim()) {
    return NextResponse.json(
      { error: "บทเรียนยังไม่มีเนื้อหา — สร้างบทเรียนใหม่ก่อนแล้วค่อยสร้าง flashcards" },
      { status: 400 },
    );
  }
  const count = Math.min(Math.max(body.count ?? 12, 1), 15);
  const existing = (body.existing ?? []).slice(-60);
  const extra = `TASK: produce exactly ${count} flashcards from the lesson below.
- Front = concept/question (under 120 chars). Back = concise answer (1-4 sentences, under 400 chars).
- Mix difficulty: ~30% easy / 50% medium / 20% hard.
- One fact per card. No card may duplicate or paraphrase an already-covered card.`;
  const content: Anthropic.MessageParam["content"] = [
    {
      type: "text",
      text: `Lesson: ${body.lesson.title}\n\n${body.lesson.body_md}${
        existing.length
          ? `\n\n---\nAlready covered (do NOT repeat these):\n${existing.map((s) => `- ${s}`).join("\n")}`
          : ""
      }`,
    },
  ];
  const res = await runStep("flashcards", FLASHCARDS_TOOL, systemFor(mode, extra), content);
  // A batch cut short leaves a half-built last card; saving one would fail the
  // NOT NULL columns and take the whole insert with it.
  return NextResponse.json({
    flashcards: keepComplete<{ front: string; back: string; difficulty: string }>(
      res.input.flashcards,
      ["front", "back", "difficulty"],
    ),
  });
}

async function handleQuizzesStep(body: {
  lesson?: LessonShape;
  extractMode?: string;
  count?: number;
  existing?: string[];
}) {
  const mode = parseMode(body.extractMode);
  if (!body.lesson?.body_md?.trim()) {
    return NextResponse.json(
      { error: "บทเรียนยังไม่มีเนื้อหา — สร้างบทเรียนใหม่ก่อนแล้วค่อยสร้างข้อสอบ" },
      { status: 400 },
    );
  }
  const count = Math.min(Math.max(body.count ?? 8, 1), 10);
  const existing = (body.existing ?? []).slice(-60);
  const extra = `TASK: produce exactly ${count} multiple-choice questions from the lesson below.
- 4-5 options, one correct answer, plus a 1-3 sentence explanation.
- Spread difficulty (~30% easy / 50% medium / 20% hard).
- Cover points the listed already-asked questions do NOT cover. No near-duplicate stems.
- Distractors must be plausible, not obviously wrong.${
    mode === "deep" ? "\n- Prefer NL/USMLE-style clinical vignettes." : ""
  }`;
  const content: Anthropic.MessageParam["content"] = [
    {
      type: "text",
      text: `Lesson: ${body.lesson.title}\n\n${body.lesson.body_md}${
        existing.length
          ? `\n\n---\nAlready asked (do NOT repeat or paraphrase):\n${existing.map((s) => `- ${s}`).join("\n")}`
          : ""
      }`,
    },
  ];
  const res = await runStep("quizzes", QUIZZES_TOOL, systemFor(mode, extra), content);
  return NextResponse.json({
    quizzes: keepComplete<{
      stem: string;
      choices: { label: string; text: string }[];
      correct_answer: string;
      explanation: string;
      difficulty: string;
    }>(res.input.quizzes, ["stem", "choices", "correct_answer", "difficulty"]),
  });
}

// ────────────────────────────────────────────────────────────────────────────
// Route
// ────────────────────────────────────────────────────────────────────────────

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    const { data: profile } = await supabase
      .from("profiles")
      .select("role")
      .eq("id", user.id)
      .maybeSingle();
    if (profile?.role !== "admin") {
      return NextResponse.json({ error: "Admin only" }, { status: 403 });
    }

    const contentType = req.headers.get("content-type") ?? "";

    // ── Branch 1 — multipart/form-data: small files uploaded straight to us.
    // Only the lesson step ever carries files.
    if (contentType.startsWith("multipart/form-data")) {
      const form = await req.formData();
      const files = form.getAll("file").filter((f): f is File => f instanceof File);
      const hint = String(form.get("hint") ?? "");
      const mode = parseMode(form.get("extractMode"));
      if (files.length === 0) {
        return NextResponse.json({ error: "ไม่พบไฟล์" }, { status: 400 });
      }
      // Bigger batches go through Supabase Storage instead (see the client) —
      // anything arriving here should already be under the platform body cap.
      const total = files.reduce((sum, f) => sum + f.size, 0);
      if (total > DIRECT_UPLOAD_MAX) {
        const mb = (total / 1024 / 1024).toFixed(1);
        return NextResponse.json(
          { error: `ไฟล์รวมกันใหญ่เกินไป (${mb} MB) สำหรับช่องทางนี้` },
          { status: 413 },
        );
      }
      const mediaBlocks: Anthropic.ContentBlockParam[] = [];
      for (const file of files) {
        if (!isAllowedType(file.type)) {
          return NextResponse.json(
            { error: `รับเฉพาะ PDF หรือรูปภาพ — ${file.name}` },
            { status: 400 },
          );
        }
        const bytes = await file.arrayBuffer();
        if (bytes.byteLength === 0) {
          return NextResponse.json(
            { error: `ไฟล์ว่าง: ${file.name} — ลองอัปโหลดใหม่` },
            { status: 400 },
          );
        }
        mediaBlocks.push(mediaBlockFor(file.type, Buffer.from(bytes)));
      }
      return await handleLessonStep(supabase, mode, mediaBlocks, hint);
    }

    // ── Branch 2 — JSON body
    const body = (await req.json()) as {
      step?: string;
      extractMode?: string;
      hint?: string;
      storage_paths?: string[];
      lesson?: LessonShape;
      count?: number;
      existing?: string[];
    };
    const step = parseStep(body.step);

    if (step === "flashcards") return await handleFlashcardsStep(body);
    if (step === "quizzes") return await handleQuizzesStep(body);

    // Lesson step from a storage upload (batches too big for the request body).
    const mode = parseMode(body.extractMode);
    const paths = body.storage_paths ?? [];
    if (paths.length === 0) {
      return NextResponse.json({ error: "ไม่พบไฟล์ต้นฉบับ" }, { status: 400 });
    }
    const { createAdminClient } = await import("@/lib/supabase/admin");
    const admin = createAdminClient();
    const BUCKET = "school-imports";
    const cleanup = () => {
      // Always clean up the temp objects, even on failure.
      admin.storage
        .from(BUCKET)
        .remove(paths)
        .catch(() => {});
    };

    try {
      const mediaBlocks: Anthropic.ContentBlockParam[] = [];
      let total = 0;
      for (const path of paths) {
        const mediaType = mediaTypeForPath(path);
        if (!mediaType) {
          return NextResponse.json({ error: "ชนิดไฟล์ไม่รองรับ" }, { status: 400 });
        }
        const { data: blob, error: dlErr } = await admin.storage.from(BUCKET).download(path);
        if (dlErr || !blob) {
          return NextResponse.json(
            { error: `ดาวน์โหลดจาก storage ไม่สำเร็จ: ${dlErr?.message ?? "ไม่พบไฟล์"}` },
            { status: 500 },
          );
        }
        const arr = Buffer.from(await blob.arrayBuffer());
        // Anthropic's 32 MB ceiling is per request, so it's the combined size
        // that matters once several files ride along.
        total += arr.byteLength;
        if (total > TOTAL_MAX) {
          const mb = (total / 1024 / 1024).toFixed(1);
          return NextResponse.json(
            { error: `ไฟล์รวมกันเกินขีดจำกัด (${mb} MB / 32 MB) — บีบอัดหรือแบ่งอัปหลายรอบ` },
            { status: 413 },
          );
        }
        mediaBlocks.push(mediaBlockFor(mediaType, arr));
      }
      return await handleLessonStep(supabase, mode, mediaBlocks, body.hint ?? "");
    } finally {
      cleanup();
    }
  } catch (e) {
    console.error("school import error", e);
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 },
    );
  }
}
