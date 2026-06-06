/**
 * Second-pass enrichment via DeepSeek V3 (OpenAI-compatible API).
 *
 * Takes the lesson/flashcards/quizzes Claude already extracted from a PDF
 * and asks DeepSeek to add MORE flashcards, MORE quizzes, plus mnemonics
 * and clinical pearls. DeepSeek's per-token price is ~10× cheaper than
 * Claude Sonnet, which makes it well-suited to verbose expansion once
 * the structured base is in place.
 *
 * The admin previews + edits everything before saving — same flow as the
 * initial extract.
 */
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export const runtime = "nodejs";
export const maxDuration = 120;

const DEEPSEEK_URL = "https://api.deepseek.com/chat/completions";
const DEEPSEEK_MODEL = "deepseek-chat";

interface InputLesson {
  title: string;
  body_md: string;
  layer: string;
}
interface InputFlashcard {
  front: string;
  back: string;
  difficulty: string;
}
interface InputQuiz {
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string;
  difficulty: string;
}

interface RequestBody {
  lesson: InputLesson;
  flashcards: InputFlashcard[];
  quizzes: InputQuiz[];
  hint?: string;
}

const SYSTEM_PROMPT = `You are a medical educator helping Thai medical students (นักศึกษาแพทย์ Y1-Y6) learn more deeply.

You will be given an already-prepared lesson + flashcards + quizzes. Your job is to ADD MORE content that complements what's there — do not repeat existing concepts.

Rules:
- Add 10-15 NEW flashcards covering concepts the existing cards missed (foundation, clinical correlation, common confusions).
- Add 5-10 NEW MCQ quizzes (different angles from existing quizzes — clinical vignettes, mechanism questions, calculation if relevant).
- Add 1 mnemonics section (Thai mnemonics where possible) with 3-6 high-yield mnemonics.
- Add 1 clinical pearls section with 5-10 ward-relevant pearls.
- Use Thai mixed with English medical terms (the natural language of Thai med students).
- Stay medically accurate. Do not invent facts.
- Do NOT duplicate existing flashcard fronts or quiz stems.

Return ONLY valid JSON matching this exact shape:
{
  "additional_flashcards": [{"front": "...", "back": "...", "difficulty": "easy"|"medium"|"hard"}],
  "additional_quizzes": [{"stem": "...", "choices": [{"label": "A", "text": "..."}, ...], "correct_answer": "A"|"B"|"C"|"D", "explanation": "...", "difficulty": "easy"|"medium"|"hard"}],
  "mnemonics_md": "## 🎯 Mnemonics\\n\\n- ...",
  "clinical_pearls_md": "## 💡 Clinical pearls\\n\\n- ..."
}`;

interface DeepSeekResponse {
  choices?: Array<{ message?: { content?: string } }>;
  error?: { message?: string };
}

interface EnrichmentOutput {
  additional_flashcards: InputFlashcard[];
  additional_quizzes: InputQuiz[];
  mnemonics_md: string;
  clinical_pearls_md: string;
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

    const apiKey = process.env.DEEPSEEK_API_KEY;
    if (!apiKey) {
      return NextResponse.json(
        { error: "DEEPSEEK_API_KEY not set — ตั้งค่าใน environment ก่อน" },
        { status: 500 },
      );
    }

    const body = (await req.json()) as RequestBody;
    if (!body.lesson || !body.flashcards || !body.quizzes) {
      return NextResponse.json(
        { error: "Missing lesson/flashcards/quizzes" },
        { status: 400 },
      );
    }

    const existingFronts = body.flashcards
      .map((fc, i) => `${i + 1}. ${fc.front}`)
      .join("\n");
    const existingStems = body.quizzes
      .map((q, i) => `${i + 1}. ${q.stem}`)
      .join("\n");

    const userMessage = `Lesson title: ${body.lesson.title}
Layer: ${body.lesson.layer}
${body.hint ? `Hint: ${body.hint}\n` : ""}

LESSON CONTENT:
${body.lesson.body_md.slice(0, 6000)}

EXISTING FLASHCARD FRONTS (do not duplicate):
${existingFronts || "(none)"}

EXISTING QUIZ STEMS (do not duplicate):
${existingStems || "(none)"}

Add NEW flashcards, NEW quizzes, mnemonics, and clinical pearls. Return JSON only.`;

    const res = await fetch(DEEPSEEK_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: DEEPSEEK_MODEL,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: userMessage },
        ],
        response_format: { type: "json_object" },
        max_tokens: 8000,
        temperature: 0.5,
      }),
    });

    if (!res.ok) {
      const errText = await res.text();
      return NextResponse.json(
        { error: `DeepSeek ${res.status}: ${errText.slice(0, 300)}` },
        { status: 502 },
      );
    }

    const json = (await res.json()) as DeepSeekResponse;
    const content = json.choices?.[0]?.message?.content;
    if (!content) {
      return NextResponse.json(
        { error: "DeepSeek returned no content" },
        { status: 502 },
      );
    }

    let parsed: EnrichmentOutput;
    try {
      parsed = JSON.parse(content) as EnrichmentOutput;
    } catch {
      return NextResponse.json(
        { error: "DeepSeek returned invalid JSON" },
        { status: 502 },
      );
    }

    // Defensive: ensure arrays exist
    return NextResponse.json({
      additional_flashcards: parsed.additional_flashcards ?? [],
      additional_quizzes: parsed.additional_quizzes ?? [],
      mnemonics_md: parsed.mnemonics_md ?? "",
      clinical_pearls_md: parsed.clinical_pearls_md ?? "",
    });
  } catch (e) {
    console.error("expand-deepseek error", e);
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 },
    );
  }
}
