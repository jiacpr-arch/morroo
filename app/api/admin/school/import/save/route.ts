import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

interface SavePayload {
  topic_id: string;
  source: string | null;
  lesson?: {
    title: string;
    body_md: string;
    layer: string;
    estimated_min: number;
  };
  flashcards?: {
    front: string;
    back: string;
    difficulty: string;
    layer?: string;
  }[];
  quizzes?: {
    stem: string;
    choices: { label: string; text: string }[];
    correct_answer: string;
    explanation?: string;
    difficulty: string;
    layer?: string;
  }[];
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

    const body = (await req.json()) as SavePayload;
    if (!body.topic_id) {
      return NextResponse.json({ error: "topic_id required" }, { status: 400 });
    }

    let lessonInserted = 0;
    let fcInserted = 0;
    let qzInserted = 0;
    const errors: string[] = [];

    if (body.lesson) {
      const { error } = await supabase.from("school_lessons").insert({
        topic_id: body.topic_id,
        layer: body.lesson.layer,
        title: body.lesson.title,
        body_md: body.lesson.body_md,
        estimated_min: body.lesson.estimated_min,
        source: body.source,
      });
      if (error) errors.push(`lesson: ${error.message}`);
      else lessonInserted = 1;
    }

    if (body.flashcards?.length) {
      const rows = body.flashcards.map((fc) => ({
        topic_id: body.topic_id,
        layer: fc.layer ?? body.lesson?.layer ?? "foundation",
        front: fc.front,
        back: fc.back,
        difficulty: fc.difficulty,
        source: body.source,
      }));
      const { error } = await supabase.from("school_flashcards").insert(rows);
      if (error) errors.push(`flashcards: ${error.message}`);
      else fcInserted = rows.length;
    }

    if (body.quizzes?.length) {
      const rows = body.quizzes.map((q) => ({
        topic_id: body.topic_id,
        layer: q.layer ?? body.lesson?.layer ?? "foundation",
        stem: q.stem,
        choices: q.choices,
        correct_answer: q.correct_answer,
        explanation: q.explanation ?? null,
        difficulty: q.difficulty,
        source: body.source,
      }));
      const { error } = await supabase.from("school_quizzes").insert(rows);
      if (error) errors.push(`quizzes: ${error.message}`);
      else qzInserted = rows.length;
    }

    return NextResponse.json({
      ok: errors.length === 0,
      lessonInserted,
      fcInserted,
      qzInserted,
      errors,
    });
  } catch (e) {
    return NextResponse.json(
      { error: e instanceof Error ? e.message : "Internal error" },
      { status: 500 }
    );
  }
}
