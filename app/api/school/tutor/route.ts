import { NextRequest, NextResponse } from "next/server";
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@/lib/supabase/server";

const MODEL = "claude-sonnet-4-6";

interface Citation {
  type: "lesson" | "flashcard" | "quiz" | "concept";
  id: string;
  title: string;
  href: string;
}

/**
 * AI Tutor — grounded medical Q&A.
 *
 * Body: { question: string, history?: {role, content}[] }
 * Returns: { answer: string, citations: Citation[] }
 *
 * The model is constrained to medical education for Thai medical students
 * Y1–Y6. Citations are computed by keyword-matching school_lessons and
 * school_concepts after the answer; the model never invents IDs.
 */
export async function POST(req: NextRequest) {
  try {
    const { question, history = [] } = (await req.json()) as {
      question?: string;
      history?: { role: "user" | "assistant"; content: string }[];
    };
    if (!question) {
      return NextResponse.json({ error: "Missing question" }, { status: 400 });
    }

    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();
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

    const client = new Anthropic({ apiKey });
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: 1500,
      system: `You are an AI medical tutor for Thai medical school students (Y1–Y6).

Rules:
- Respond in the same language the student uses (Thai mixed with English medical terms is fine).
- Explain WHY and HOW, not just WHAT. Tie answers back to underlying mechanisms (Bloom higher levels).
- Use small chunks (2–4 short paragraphs max) and avoid lecture-length walls of text.
- If the question is outside medical education (recreational, legal, harmful), politely redirect.
- End with a short "Concepts to review:" line listing 1–3 key concept names so the platform can link to deeper content.
- Never invent citations or URLs.`,
      messages: [
        ...history,
        { role: "user", content: question },
      ],
    });

    const text = response.content
      .filter((b) => b.type === "text")
      .map((b) => (b as { type: "text"; text: string }).text)
      .join("\n");

    // Heuristic citation: scan lessons + concepts by keyword overlap
    const haystack = text.toLowerCase();
    const [lessonsRes, conceptsRes] = await Promise.all([
      supabase.from("school_lessons").select("id, title").eq("status", "active").limit(200),
      supabase.from("school_concepts").select("id, slug, name_th, name_en"),
    ]);
    type LessonRow = { id: string; title: string };
    type ConceptRow = { id: string; slug: string; name_th: string; name_en: string };
    const citations: Citation[] = [];
    for (const c of (conceptsRes.data as ConceptRow[]) ?? []) {
      const ll = c.name_en.toLowerCase();
      const lt = c.name_th.toLowerCase();
      if (haystack.includes(ll) || haystack.includes(lt) || haystack.includes(c.slug)) {
        citations.push({
          type: "concept",
          id: c.id,
          title: c.name_th,
          href: `/school/concept/${c.slug}`,
        });
      }
    }
    for (const l of (lessonsRes.data as LessonRow[]) ?? []) {
      if (haystack.includes(l.title.toLowerCase())) {
        citations.push({
          type: "lesson",
          id: l.id,
          title: l.title,
          href: `/school/lesson/${l.id}`,
        });
      }
    }

    return NextResponse.json({
      answer: text,
      citations: citations.slice(0, 6),
    });
  } catch (err) {
    console.error("tutor error", err);
    return NextResponse.json({ error: "Internal error" }, { status: 500 });
  }
}
