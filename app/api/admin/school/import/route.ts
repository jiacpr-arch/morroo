import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

const MODEL = "claude-sonnet-4-6";

export const runtime = "nodejs";
export const maxDuration = 60;

const EXTRACT_TOOL: Anthropic.Tool = {
  name: "submit_extracted_content",
  description:
    "Submit a lesson + flashcards + quizzes extracted from the source material.",
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
              "Markdown lesson split into 2-4 parts. Between consecutive parts put a `## ⏸ Mini Quiz` marker line, and immediately after each marker embed ONE quiz that tests the part just above it, as a fenced ```quiz block containing JSON: " +
              '{ "stem": string, "choices": [{ "label": "A"|"B"|"C"|"D", "text": string }], "correct_answer": "A"|"B"|"C"|"D", "explanation": string }. ' +
              "The inline quiz MUST be answerable from the part directly above it. Each part should be 2-4 short paragraphs.",
          },
          layer: {
            type: "string",
            enum: ["foundation", "anatomy", "physio", "biochem", "path", "pharm", "clinical"],
          },
          estimated_min: { type: "integer", minimum: 1, maximum: 60 },
        },
        required: ["title", "body_md", "layer", "estimated_min"],
      },
      flashcards: {
        type: "array",
        description: "10-20 atomic flashcards extracted from the material.",
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
        description: "5-10 multiple-choice questions.",
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

const SYSTEM_PROMPT = `You are a medical educator extracting micro-learning units from source material for Thai medical school students.

Output via submit_extracted_content:
1. lesson — markdown body split into 2-4 parts using \`## ⏸ Mini Quiz\` marker between parts. Immediately after each marker, embed ONE inline quiz that tests the part directly above it, as a fenced \`\`\`quiz block of JSON ({ stem, choices:[{label,text}], correct_answer, explanation }). The inline quiz must be answerable from the part above. Keep each part under 200 words.
2. flashcards — 10-20 atomic concept cards. Front = concept/question (under 100 chars). Back = concise answer (1-3 sentences, under 300 chars).
3. quizzes — 5-10 MCQs with 4-5 options + correct answer + 1-2 sentence explanation. These feed the topic question bank and end-of-lesson retrieval (separate from the inline mini-quizzes above).

Rules:
- Use Thai mixed with English medical terms (Thai med students study in mixed language).
- Stay faithful — do not invent facts not in the source.
- Prefer clinically relevant content over rote trivia when possible.
- Mix difficulty: roughly 30% easy / 50% medium / 20% hard.`;

function maxOutputTokensFor(_payloadLen: number) {
  // Always reserve enough headroom for full output
  return 12000;
}

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

async function callExtractor(content: Anthropic.MessageParam["content"]) {
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    throw new Error("ANTHROPIC_API_KEY not set");
  }
  const client = new Anthropic({ apiKey });
  const response = await client.messages.create({
    model: MODEL,
    max_tokens: maxOutputTokensFor(JSON.stringify(content).length),
    system: SYSTEM_PROMPT,
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
                media_type: file.type as Anthropic.ImageBlockParam["source"]["media_type"],
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
      const data = await callExtractor(content);
      return NextResponse.json(data);
    }

    // ── Branch 2 — JSON body (text or url)
    const body = (await req.json()) as {
      mode?: "text" | "url";
      text?: string;
      url?: string;
      hint?: string;
    };
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
    const data = await callExtractor(content);
    return NextResponse.json(data);
  } catch (e) {
    console.error("import error", e);
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 }
    );
  }
}
