import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";
import { loadBookContext } from "@/lib/school/book-context";

export const runtime = "nodejs";
export const maxDuration = 60;

const MODEL = "claude-sonnet-4-6";
const MAX_CONTEXT_CHARS = 12000;

/**
 * "Ask more" for a School topic. Answers the student's question immediately,
 * grounded in that topic's full-text book, and stores the question (+ answer)
 * in school_questions so the enrich job can later turn recurring questions
 * into new flashcards/quizzes.
 *
 * Body: { question: string, topicId: string, chapterId?: string }
 * Returns: { answer: string }
 */
export async function POST(req: NextRequest) {
  try {
    const { question, topicId, chapterId } = (await req.json()) as {
      question?: string;
      topicId?: string;
      chapterId?: string;
    };
    if (!question || !topicId) {
      return NextResponse.json(
        { error: "Missing question or topicId" },
        { status: 400 }
      );
    }

    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const apiKey = process.env.ANTHROPIC_API_KEY;
    if (!apiKey) {
      return NextResponse.json(
        { error: "Service not configured" },
        { status: 503 }
      );
    }

    // Ground on the topic's full-text book (if any).
    const context = await loadBookContext(supabase, topicId, MAX_CONTEXT_CHARS);

    const client = new Anthropic({ apiKey });
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 1200,
      system: `You are an AI medical tutor for Thai medical school students (Y1–Y6).

Rules:
- Respond in the same language the student uses (Thai mixed with English medical terms is fine).
- Ground your answer in the provided reference text when relevant; explain WHY/HOW, not just WHAT.
- Use small chunks (2–4 short paragraphs max).
- If the reference does not cover it, answer from established medical knowledge but stay accurate and do not invent facts.
- If the question is outside medical education, politely redirect.`,
      messages: [
        {
          role: "user",
          content: context
            ? `Reference text (full-text book for this topic):\n\n${context}\n\n---\n\nStudent question: ${question}`
            : `Student question: ${question}`,
        },
      ],
    });

    const answer = response.content
      .filter((b) => b.type === "text")
      .map((b) => (b as { type: "text"; text: string }).text)
      .join("\n");

    // Persist (non-blocking on failure so the student still gets the answer,
    // but log it — a lost question never reaches the enrich loop).
    const { error: persistErr } = await supabase.from("school_questions").insert({
      user_id: user.id,
      topic_id: topicId,
      chapter_id: chapterId ?? null,
      question,
      ai_answer: answer,
    });
    if (persistErr) {
      console.error("school/ask persist failed", persistErr.message);
    }

    return NextResponse.json({ answer });
  } catch (err) {
    console.error("school/ask error", err);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
