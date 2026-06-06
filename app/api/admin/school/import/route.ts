import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

const MODEL = "claude-sonnet-4-6";

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
  const client = new Anthropic({ apiKey });

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
      const bytes = await file.arrayBuffer();
      const b64 = Buffer.from(bytes).toString("base64");

      const isPdf = file.type === "application/pdf";
      const isImage = file.type.startsWith("image/");
      if (!isPdf && !isImage) {
        return NextResponse.json({ error: "PDF or image only" }, { status: 400 });
      }

      const content: Anthropic.MessageParam["content"] = [
        isPdf
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
            },
        {
          type: "text",
          text: `Extract a lesson + flashcards + quizzes from this material.${
            hint ? `\n\nHint: ${hint}` : ""
          }`,
        },
      ];
      const data = await callExtractor(content, mode);
      return NextResponse.json({ ...data, mode });
    }

    // ── Branch 2 — JSON body (text or url)
    const body = (await req.json()) as {
      mode?: "text" | "url";
      extractMode?: string;
      text?: string;
      url?: string;
      hint?: string;
    };
    const mode = parseMode(body.extractMode);
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
    const data = await callExtractor(content, mode);
    return NextResponse.json({ ...data, mode });
  } catch (e) {
    console.error("import error", e);
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 }
    );
  }
}
