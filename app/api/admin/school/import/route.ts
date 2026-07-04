import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createAnthropic } from "@/lib/anthropic";
import { createClient } from "@/lib/supabase/server";

const MODEL = "claude-sonnet-4-6";
const CLASSIFY_MODEL = "claude-haiku-4-5";

export const runtime = "nodejs";
export const maxDuration = 300;

type Mode = "faithful" | "expand" | "deep";

const EXTRACT_TOOL: Anthropic.Tool = {
  name: "submit_extracted_content",
  description:
    "Submit a lesson + flashcards + quizzes extracted (and optionally expanded) from the source material.",
  input_schema: {
    type: "object",
    properties: {
      lesson: {
        type: "object",
        properties: {
          title: { type: "string", description: "Concise lesson title (Thai or English)" },
          body_md: {
            type: "string",
            description:
              "Markdown lesson split into 2-6 parts. Between consecutive parts put a `## ⏸ Mini Quiz` marker line, and immediately after each marker embed ONE quiz that tests the part just above it, as a fenced ```quiz block containing JSON: " +
              '{ "stem": string, "choices": [{ "label": "A"|"B"|"C"|"D", "text": string }], "correct_answer": "A"|"B"|"C"|"D", "explanation": string }. ' +
              "The inline quiz MUST be answerable from the part directly above it. " +
              "In expand/deep modes, also include sections: ## 🧠 Why it matters, ## 🔑 Key concepts, ## 💡 Clinical pearls, ## 🎯 Mnemonics (when applicable), ## 🔗 Connections to other topics.",
          },
          layer: {
            type: "string",
            enum: ["foundation", "anatomy", "physio", "biochem", "path", "pharm", "clinical"],
          },
          estimated_min: { type: "integer", minimum: 1, maximum: 120 },
        },
        required: ["title", "body_md", "layer", "estimated_min"],
      },
      flashcards: {
        type: "array",
        description: "Atomic flashcards. faithful: 10-20, expand: 20-35, deep: 30-50.",
        items: {
          type: "object",
          properties: {
            front: { type: "string" },
            back: { type: "string" },
            difficulty: { type: "string", enum: ["easy", "medium", "hard"] },
          },
          required: ["front", "back", "difficulty"],
        },
      },
      quizzes: {
        type: "array",
        description: "Multiple-choice questions. faithful: 5-10, expand: 10-15, deep: 15-25.",
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
    required: ["lesson", "flashcards", "quizzes"],
  },
};

const SYSTEM_BASE = `You are an expert medical educator creating micro-learning units for Thai medical students (นักศึกษาแพทย์ Y1-Y6).

Audience context:
- Thai medical students study with mixed Thai + English medical terminology.
- Source material is often summary notes from senior students (รุ่นพี่) — concise, often missing foundational context that the senior assumed the reader knew.
- Students need to BOTH pass exams (NL/comprehensive) AND understand for clinical practice.

Output via the submit_extracted_content tool:

1. **lesson.body_md** — markdown lesson split into clearly-marked parts.
   - Use \`## ⏸ Mini Quiz\` between consecutive parts.
   - Immediately after each marker, embed ONE inline quiz as a fenced \`\`\`quiz block of JSON: { stem, choices:[{label,text}], correct_answer, explanation }. The quiz must be answerable from the part directly above it.
   - Use Thai mixed with English medical terms (the natural language of Thai med students).
   - Format math/equations in plain text — no LaTeX.

2. **flashcards** — atomic concept cards.
   - Front = concept/question (under 120 chars).
   - Back = concise answer (1-4 sentences, under 400 chars).
   - Mix difficulty: ~30% easy / 50% medium / 20% hard.

3. **quizzes** — MCQs with 4-5 options + correct answer + 1-3 sentence explanation. These feed the topic question bank (separate from inline mini-quizzes).

General quality rules:
- Prefer clinically relevant content over rote trivia.
- Use concrete examples, not abstract definitions.
- When you state a mechanism, briefly explain WHY (cause → effect chain).`;

const MODE_INSTRUCTIONS: Record<Mode, string> = {
  faithful: `MODE: FAITHFUL EXTRACTION
- Stay strictly to what's in the source material.
- Do NOT add facts, examples, or context not present in the source.
- Output: 1 lesson (2-4 parts), 10-20 flashcards, 5-10 quizzes.
- Use this mode when the source is authoritative (textbook, lecture).`,

  expand: `MODE: EXPAND FOR UNDERSTANDING
The source is a senior student's summary — often condensed and missing foundational context. Your job is to make it learnable for a student who is seeing this topic for the first time.

You MAY and SHOULD:
- Fill in foundational concepts the source assumes (anatomy, physiology basics, prerequisites).
- Add concrete clinical examples and patient scenarios.
- Add analogies that help intuition (เปรียบเทียบกับสิ่งใกล้ตัว).
- Add Thai mnemonics (สูตรช่วยจำ) where they aid memorization.
- Add "Why it matters" framing — when/why a clinician needs this knowledge.
- Connect to other topics in the medical curriculum.
- Add clinical pearls (high-yield points for NL/ward).

You MUST NOT:
- Invent facts that contradict the source.
- Add speculative/unverified information.
- Skip topics from the source.

Lesson structure (use these sections):
  ## 🧠 Why it matters
  ## 🔑 Key concepts (split into 2-4 parts with mini-quizzes between)
  ## 💡 Clinical pearls
  ## 🎯 Mnemonics (optional)
  ## 🔗 Connections to other topics

Output: 1 lesson (longer, 4-6 parts), 20-35 flashcards, 10-15 quizzes.
estimated_min: 15-30.`,

  deep: `MODE: DEEP DIVE
Same expansion rules as EXPAND mode, but go further:
- Detailed mechanisms with step-by-step pathophysiology.
- Multiple clinical scenarios per concept (Y3-Y6 ward perspective).
- Common exam pitfalls and high-yield distinctions (e.g., "Don't confuse X with Y because…").
- Include differential diagnosis thinking where relevant.
- Add 'classic exam questions' style quizzes (NL/USMLE-style clinical vignettes).

Lesson structure:
  ## 🧠 Why it matters
  ## 📚 Foundation review (prerequisites)
  ## 🔑 Key concepts (split into 3-6 parts with mini-quizzes between)
  ## 🩺 Clinical application (cases)
  ## 💡 Clinical pearls + high-yield
  ## ⚠️ Common pitfalls
  ## 🎯 Mnemonics
  ## 🔗 Connections to other topics

Output: 1 lesson (long, 5-8 parts), 30-50 flashcards, 15-25 quizzes.
estimated_min: 25-45.`,
};

const OUTPUT_TOKENS: Record<Mode, number> = {
  faithful: 12000,
  expand: 24000,
  deep: 40000,
};

interface ExtractedContent {
  lesson?: {
    title?: string;
    body_md?: string;
    layer?: string;
    estimated_min?: number;
  };
  flashcards?: unknown[];
  quizzes?: unknown[];
}

async function callExtractor(
  content: Anthropic.MessageParam["content"],
  mode: Mode,
) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    throw new Error("ANTHROPIC_API_KEY not set");
  }
  const client = createAnthropic();

  // Split system into cached base + per-request mode block.
  // Base is identical across imports → cache hit on subsequent calls.
  const system: Anthropic.TextBlockParam[] = [
    {
      type: "text",
      text: SYSTEM_BASE,
      cache_control: { type: "ephemeral" },
    },
    {
      type: "text",
      text: MODE_INSTRUCTIONS[mode],
    },
  ];

  const response = await client.messages.create({
    model: MODEL,
    max_tokens: OUTPUT_TOKENS[mode],
    system,
    tools: [EXTRACT_TOOL],
    tool_choice: { type: "tool", name: "submit_extracted_content" },
    messages: [{ role: "user", content }],
  });
  const tool = response.content.find((b) => b.type === "tool_use");
  if (!tool || tool.type !== "tool_use") {
    throw new Error("No tool_use returned");
  }
  return tool.input as ExtractedContent;
}

function parseMode(raw: unknown): Mode {
  if (raw === "faithful" || raw === "expand" || raw === "deep") return raw;
  return "expand";
}

interface TopicCandidate {
  id: string;
  year: number;
  name_th: string;
  system_name: string;
}

interface ClassifyResult {
  suggested_topic_id: string | null;
  confidence: number;
  reasoning: string;
  suggested_new_topic?: {
    year: number;
    system_hint: string;
    name_th: string;
  };
}

const CLASSIFY_TOOL: Anthropic.Tool = {
  name: "submit_topic_classification",
  description:
    "Submit which existing curriculum topic best matches the material, or propose a new topic if none fit.",
  input_schema: {
    type: "object",
    properties: {
      suggested_topic_index: {
        type: "integer",
        description:
          "Index (0-based) of the best-matching topic from the provided list. Use -1 if no existing topic is a good match.",
      },
      confidence: {
        type: "number",
        description:
          "Confidence 0.0-1.0 that the suggested topic correctly matches the material.",
        minimum: 0,
        maximum: 1,
      },
      reasoning: {
        type: "string",
        description:
          "One short sentence (Thai) explaining why this topic matches, or why none fit.",
      },
      suggested_new_topic: {
        type: "object",
        description:
          "Only when suggested_topic_index = -1: propose a new topic.",
        properties: {
          year: { type: "integer", minimum: 1, maximum: 6 },
          system_hint: {
            type: "string",
            description:
              "Best-guess system name in Thai (e.g. 'ระบบหัวใจและหลอดเลือด', 'ระบบหายใจ').",
          },
          name_th: {
            type: "string",
            description: "Proposed topic name in Thai.",
          },
        },
        required: ["year", "system_hint", "name_th"],
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
    .select("id, year, name_th, school_systems(name_th)")
    .order("year")
    .limit(500);
  if (!data) return [];
  return (data as Array<{
    id: string;
    year: number;
    name_th: string;
    school_systems: { name_th: string } | { name_th: string }[] | null;
  }>).map((r) => {
    const sys = Array.isArray(r.school_systems)
      ? r.school_systems[0]
      : r.school_systems;
    return {
      id: r.id,
      year: r.year,
      name_th: r.name_th,
      system_name: sys?.name_th ?? "—",
    };
  });
}

async function classifyTopic(
  classifyContent: Anthropic.ContentBlockParam[],
  topics: TopicCandidate[],
): Promise<ClassifyResult | null> {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey || topics.length === 0) return null;
  const client = createAnthropic();

  const topicList = topics
    .map((t, i) => `${i}. Y${t.year} · ${t.system_name} · ${t.name_th}`)
    .join("\n");

  const system = `You classify Thai medical-school study materials into the correct curriculum topic.

You will be given (1) the source material (PDF/text/image), and (2) a numbered list of existing topics in the curriculum (year + system + topic name).

Your job: pick the index of the topic that best matches the material's content, or return -1 if no existing topic is a reasonable fit (in which case propose a new topic).

Be conservative — only return a high confidence (>0.8) if the match is clearly correct. If multiple topics could plausibly match, pick the closest and lower the confidence.`;

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
              text: `Existing topics (pick the index that matches, or -1 if none):\n\n${topicList}`,
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
      suggested_new_topic?: ClassifyResult["suggested_new_topic"];
    };
    const idx = input.suggested_topic_index;
    return {
      suggested_topic_id: idx >= 0 && idx < topics.length ? topics[idx].id : null,
      confidence: input.confidence,
      reasoning: input.reasoning,
      suggested_new_topic: input.suggested_new_topic,
    };
  } catch (e) {
    console.error("classify error", e);
    return null;
  }
}

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
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

    // ── Branch 1 — multipart/form-data (file upload)
    if (contentType.startsWith("multipart/form-data")) {
      const form = await req.formData();
      const file = form.get("file");
      const hint = String(form.get("hint") ?? "");
      const mode = parseMode(form.get("mode"));
      if (!(file instanceof File)) {
        return NextResponse.json({ error: "Missing file" }, { status: 400 });
      }
      // Client falls back to browser text-extraction for big PDFs and sends
      // the result via JSON branch instead — anything reaching this branch
      // should be small. Cap at Vercel's effective limit; bigger requests
      // would have been truncated upstream anyway.
      const MAX_BYTES = 5 * 1024 * 1024;
      if (file.size > MAX_BYTES) {
        const mb = (file.size / 1024 / 1024).toFixed(1);
        return NextResponse.json(
          {
            error: `ไฟล์ใหญ่เกินไป (${mb} MB) — สำหรับ PDF ใช้ฝั่งเบราว์เซอร์ extract ก่อน, รูปภาพต้อง ≤4 MB`,
          },
          { status: 413 },
        );
      }
      const bytes = await file.arrayBuffer();
      if (bytes.byteLength === 0) {
        return NextResponse.json(
          { error: "ไฟล์ว่าง — ลองอัปโหลดใหม่" },
          { status: 400 },
        );
      }
      const b64 = Buffer.from(bytes).toString("base64");

      const isPdf = file.type === "application/pdf";
      const isImage = file.type.startsWith("image/");
      if (!isPdf && !isImage) {
        return NextResponse.json({ error: "PDF or image only" }, { status: 400 });
      }

      const mediaBlock: Anthropic.DocumentBlockParam | Anthropic.ImageBlockParam = isPdf
        ? {
            type: "document",
            source: {
              type: "base64",
              media_type: "application/pdf",
              data: b64,
            },
          }
        : {
            type: "image",
            source: {
              type: "base64",
              media_type: file.type as Anthropic.Base64ImageSource["media_type"],
              data: b64,
            },
          };
      const content: Anthropic.MessageParam["content"] = [
        mediaBlock,
        {
          type: "text",
          text: `Extract a lesson + flashcards + quizzes from this material.${
            hint ? `\n\nHint: ${hint}` : ""
          }`,
        },
      ];
      const topics = await loadTopicCandidates(supabase);
      const [data, classification] = await Promise.all([
        callExtractor(content, mode),
        classifyTopic([mediaBlock], topics),
      ]);
      return NextResponse.json({ ...data, mode, classification });
    }

    // ── Branch 2 — JSON body (text, url, page images, or storage path)
    const body = (await req.json()) as {
      mode?: "text" | "url" | "images" | "storage";
      extractMode?: string;
      text?: string;
      url?: string;
      hint?: string;
      images?: string[]; // base64 JPEG, one per page
      storage_path?: string; // path inside school-imports bucket
    };
    const mode = parseMode(body.extractMode);

    // Branch 2a — storage upload (large PDFs uploaded directly to Supabase)
    if (body.mode === "storage" && body.storage_path) {
      const { createAdminClient } = await import("@/lib/supabase/admin");
      const admin = createAdminClient();
      const BUCKET = "school-imports";
      const { data: blob, error: dlErr } = await admin.storage
        .from(BUCKET)
        .download(body.storage_path);
      if (dlErr || !blob) {
        return NextResponse.json(
          { error: `ดาวน์โหลดจาก storage ไม่สำเร็จ: ${dlErr?.message ?? "no file"}` },
          { status: 500 },
        );
      }
      const arr = new Uint8Array(await blob.arrayBuffer());
      // Anthropic PDF limit is 32 MB. Beyond that the model rejects the file.
      const ANTHROPIC_PDF_MAX = 32 * 1024 * 1024;
      if (arr.byteLength > ANTHROPIC_PDF_MAX) {
        await admin.storage.from(BUCKET).remove([body.storage_path]);
        const mb = (arr.byteLength / 1024 / 1024).toFixed(1);
        return NextResponse.json(
          {
            error: `PDF ใหญ่เกิน Claude limit (${mb} MB / 32 MB) — บีบอัดให้เล็กลง หรือแยกไฟล์`,
          },
          { status: 413 },
        );
      }
      const b64 = Buffer.from(arr).toString("base64");
      const mediaBlock: Anthropic.DocumentBlockParam = {
        type: "document",
        source: {
          type: "base64",
          media_type: "application/pdf",
          data: b64,
        },
      };
      const content: Anthropic.MessageParam["content"] = [
        mediaBlock,
        {
          type: "text",
          text: `Extract a lesson + flashcards + quizzes from this material.${
            body.hint ? `\n\nHint: ${body.hint}` : ""
          }`,
        },
      ];
      const topics = await loadTopicCandidates(supabase);
      try {
        const [data, classification] = await Promise.all([
          callExtractor(content, mode),
          classifyTopic([mediaBlock], topics),
        ]);
        return NextResponse.json({ ...data, mode, classification });
      } finally {
        // Always clean up the storage object — even on error — so we never
        // accumulate temp PDFs.
        admin.storage.from(BUCKET).remove([body.storage_path]).catch(() => {});
      }
    }

    // Branch 2b — page images (handwritten / scanned PDFs rendered in the browser)
    if (body.mode === "images" && Array.isArray(body.images) && body.images.length > 0) {
      // Cap at 12 to stay under Vercel body limits AND keep token cost
      // bounded (Claude charges ~2k input tokens per image).
      const MAX_IMAGES = 12;
      const imgs = body.images.slice(0, MAX_IMAGES);
      const imageBlocks: Anthropic.ImageBlockParam[] = imgs.map((b64) => ({
        type: "image",
        source: {
          type: "base64",
          media_type: "image/jpeg",
          data: b64,
        },
      }));
      const content: Anthropic.MessageParam["content"] = [
        ...imageBlocks,
        {
          type: "text",
          text: `Extract a lesson + flashcards + quizzes from these ${imgs.length} pages (handwritten or scanned).${
            body.hint ? `\n\nHint: ${body.hint}` : ""
          }`,
        },
      ];
      // Classify off the first page only — saves Haiku tokens.
      const classifyContent: Anthropic.ContentBlockParam[] = imageBlocks[0]
        ? [imageBlocks[0]]
        : [];
      const topics = await loadTopicCandidates(supabase);
      const [data, classification] = await Promise.all([
        callExtractor(content, mode),
        classifyTopic(classifyContent, topics),
      ]);
      return NextResponse.json({ ...data, mode, classification });
    }

    let materialText = "";
    if (body.mode === "text" && body.text) {
      materialText = body.text;
    } else if (body.mode === "url" && body.url) {
      try {
        const res = await fetch(body.url, {
          headers: { "user-agent": "Mozilla/5.0 morroo-importer" },
        });
        const text = await res.text();
        // Naive HTML strip
        materialText = text
          .replace(/<script[\s\S]*?<\/script>/gi, "")
          .replace(/<style[\s\S]*?<\/style>/gi, "")
          .replace(/<[^>]+>/g, " ")
          .replace(/\s+/g, " ")
          .slice(0, 60000);
      } catch (e) {
        return NextResponse.json({ error: `URL fetch failed: ${e}` }, { status: 400 });
      }
    } else {
      return NextResponse.json({ error: "Provide mode + text/url" }, { status: 400 });
    }

    const content: Anthropic.MessageParam["content"] = [
      {
        type: "text",
        text: `Extract a lesson + flashcards + quizzes from the following material.\n\n${
          body.hint ? `Hint: ${body.hint}\n\n` : ""
        }---\n\n${materialText}`,
      },
    ];
    const classifyExcerpt = materialText.slice(0, 8000);
    const topics = await loadTopicCandidates(supabase);
    const [data, classification] = await Promise.all([
      callExtractor(content, mode),
      classifyTopic(
        [{ type: "text", text: classifyExcerpt }],
        topics,
      ),
    ]);
    return NextResponse.json({ ...data, mode, classification });
  } catch (e) {
    console.error("import error", e);
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 }
    );
  }
}
