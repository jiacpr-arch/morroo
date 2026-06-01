/**
 * School content self-improvement loop.
 *
 * Reads unprocessed student questions (school_questions, status 'open'),
 * groups them by topic, and for each topic asks Claude — grounded on that
 * topic's full-text book — to generate a few NEW flashcards/quizzes that
 * address what students asked. Generated units are auto-published
 * (status 'active') and tagged source 'student-driven:<topic_slug>' so they
 * can be filtered or rolled back. Processed questions are marked 'processed'.
 *
 * Auth: ?secret=<BLOG_GENERATE_SECRET> or Authorization: Bearer <CRON_SECRET>.
 * Schedule (vercel.json): daily.
 */

import { NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createAdminClient } from "@/lib/supabase/admin";

export const runtime = "nodejs";
export const maxDuration = 300;

const MODEL = "claude-sonnet-4-6";
const MAX_TOPICS_PER_RUN = 3;
const MAX_QUESTIONS_PER_TOPIC = 20;
const MAX_CONTEXT_CHARS = 12000;

const ENRICH_TOOL = {
  name: "submit_enrichment",
  description:
    "Submit new flashcards and quizzes that answer the students' questions, grounded in the reference text.",
  input_schema: {
    type: "object" as const,
    properties: {
      flashcards: {
        type: "array",
        description: "1-6 new atomic flashcards addressing the questions. Front=concept/question, Back=concise answer.",
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
        description: "1-4 new single-best-answer MCQs addressing the questions.",
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
    required: ["flashcards", "quizzes"],
  },
};

const SYSTEM_PROMPT = `You are a medical educator improving a Thai medical-school topic based on what students actually asked.

You are given: (1) the topic's reference text, (2) a list of student questions, (3) the fronts/stems of EXISTING flashcards/quizzes.

Produce NEW micro-learning units that directly address the students' questions:
- Stay faithful to the reference text and established medical facts — do NOT invent facts.
- Do NOT duplicate existing flashcards/quizzes (different concept or clearly deeper angle only).
- Use Thai medical terminology where natural (Thai students learn in mixed Thai+English).
- Keep flashcard fronts < 100 chars, backs < 300 chars.
- Generate at most 6 flashcards and 4 quizzes. Fewer is fine if questions are narrow.

Call submit_enrichment with your output.`;

function isAuthorized(request: Request): boolean {
  const url = new URL(request.url);
  const secret = url.searchParams.get("secret");
  if (secret && secret === process.env.BLOG_GENERATE_SECRET) return true;
  const auth = request.headers.get("authorization");
  if (auth && process.env.CRON_SECRET && auth === `Bearer ${process.env.CRON_SECRET}`)
    return true;
  return false;
}

interface QuestionRow {
  id: string;
  topic_id: string;
  question: string;
}

export async function GET(request: Request) {
  if (!isAuthorized(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return NextResponse.json({ error: "ANTHROPIC_API_KEY not set" }, { status: 500 });
  }

  const supabase = createAdminClient();
  const client = new Anthropic({ apiKey });

  const { data: open, error } = await supabase
    .from("school_questions")
    .select("id, topic_id, question")
    .eq("status", "open")
    .order("created_at", { ascending: true })
    .limit(200);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  // Group questions by topic.
  const byTopic = new Map<string, QuestionRow[]>();
  for (const q of (open as QuestionRow[]) ?? []) {
    const arr = byTopic.get(q.topic_id) ?? [];
    if (arr.length < MAX_QUESTIONS_PER_TOPIC) arr.push(q);
    byTopic.set(q.topic_id, arr);
  }

  const topicIds = [...byTopic.keys()].slice(0, MAX_TOPICS_PER_RUN);
  const summary: Record<string, unknown>[] = [];

  for (const topicId of topicIds) {
    const questions = byTopic.get(topicId) ?? [];
    try {
      const result = await enrichTopic(supabase, client, topicId, questions);
      summary.push({ topicId, ...result });
    } catch (e) {
      summary.push({ topicId, error: (e as Error).message });
    }
  }

  return NextResponse.json({
    ok: true,
    topics_processed: topicIds.length,
    open_total: open?.length ?? 0,
    details: summary,
  });
}

async function enrichTopic(
  supabase: ReturnType<typeof createAdminClient>,
  client: Anthropic,
  topicId: string,
  questions: QuestionRow[]
) {
  // Topic meta (slug for source tag) + grounding context + existing units.
  const { data: topic } = await supabase
    .from("school_topics")
    .select("slug")
    .eq("id", topicId)
    .maybeSingle();
  const slug = (topic as { slug?: string } | null)?.slug ?? topicId;

  const { data: book } = await supabase
    .from("school_books")
    .select("id")
    .eq("topic_id", topicId)
    .maybeSingle();

  let context = "";
  let layer = "foundation";
  if (book) {
    const { data: chapters } = await supabase
      .from("school_book_chapters")
      .select("title, body_md")
      .eq("book_id", (book as { id: string }).id)
      .order("sort_order");
    context = (chapters ?? [])
      .map((c: { title: string; body_md: string }) => `## ${c.title}\n${c.body_md}`)
      .join("\n\n")
      .slice(0, MAX_CONTEXT_CHARS);
  }

  const [{ data: fcRows }, { data: qzRows }] = await Promise.all([
    supabase.from("school_flashcards").select("front, layer").eq("topic_id", topicId).limit(200),
    supabase.from("school_quizzes").select("stem").eq("topic_id", topicId).limit(200),
  ]);
  if (fcRows && fcRows.length > 0 && (fcRows[0] as { layer?: string }).layer) {
    layer = (fcRows[0] as { layer: string }).layer;
  }
  const existingFronts = (fcRows ?? []).map((r: { front: string }) => `- ${r.front}`).join("\n");
  const existingStems = (qzRows ?? []).map((r: { stem: string }) => `- ${r.stem}`).join("\n");
  const questionList = questions.map((q, i) => `${i + 1}. ${q.question}`).join("\n");

  const userContent = `REFERENCE TEXT:\n${context || "(no book text available)"}\n\n---\n\nSTUDENT QUESTIONS:\n${questionList}\n\n---\n\nEXISTING FLASHCARD FRONTS:\n${existingFronts || "(none)"}\n\nEXISTING QUIZ STEMS:\n${existingStems || "(none)"}\n\nGenerate new units now.`;

  const response = await client.messages.create({
    model: MODEL,
    max_tokens: 4000,
    system: SYSTEM_PROMPT,
    tools: [ENRICH_TOOL],
    tool_choice: { type: "tool", name: "submit_enrichment" },
    messages: [{ role: "user", content: userContent }],
  });

  const tool = response.content.find((b) => b.type === "tool_use");
  const input = (tool as { input?: { flashcards?: unknown[]; quizzes?: unknown[] } } | undefined)
    ?.input;
  const flashcards = (input?.flashcards ?? []) as {
    front: string;
    back: string;
    difficulty: string;
  }[];
  const quizzes = (input?.quizzes ?? []) as {
    stem: string;
    choices: { label: string; text: string }[];
    correct_answer: string;
    explanation: string;
    difficulty: string;
  }[];

  const source = `student-driven:${slug}`;
  const tag = `[ai] ${new Date().toISOString().slice(0, 10)} ${source}`;

  if (flashcards.length > 0) {
    await supabase.from("school_flashcards").insert(
      flashcards.map((fc) => ({
        topic_id: topicId,
        layer,
        front: fc.front,
        back: fc.back,
        difficulty: ["easy", "medium", "hard"].includes(fc.difficulty) ? fc.difficulty : "medium",
        source: tag,
        status: "active",
      }))
    );
  }
  if (quizzes.length > 0) {
    await supabase.from("school_quizzes").insert(
      quizzes.map((q) => ({
        topic_id: topicId,
        layer,
        stem: q.stem,
        choices: q.choices,
        correct_answer: q.correct_answer,
        explanation: q.explanation,
        difficulty: ["easy", "medium", "hard"].includes(q.difficulty) ? q.difficulty : "medium",
        source: tag,
        status: "active",
      }))
    );
  }

  // Mark these questions processed.
  await supabase
    .from("school_questions")
    .update({ status: "processed", processed_at: new Date().toISOString() })
    .in(
      "id",
      questions.map((q) => q.id)
    );

  return {
    questions: questions.length,
    flashcards_added: flashcards.length,
    quizzes_added: quizzes.length,
  };
}
