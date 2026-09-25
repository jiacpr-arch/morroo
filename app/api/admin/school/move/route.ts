import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { parseMoveRequest, type MoveResult } from "@/lib/school/move-content";

/**
 * Move School content that was imported into the wrong subject.
 *
 * - scope "batch": every lesson, flashcard and quiz one uploaded file produced
 *   (same topic_id + source), i.e. undo "posted the file to the wrong subject".
 * - scope "lesson": a single lesson.
 *
 * Moved lessons are appended after the target subject's existing lessons (the
 * student page numbers "บทที่ N" by sort_order), and their Visual Summary cards
 * follow them. Writes are ordered so a retry after a partial failure finishes
 * the job: visuals before lessons (visuals are found through lessons still in
 * the source subject), and flashcards/quizzes are matched by the source subject.
 */
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

    const parsed = parseMoveRequest(await req.json().catch(() => null));
    if (!parsed.ok) return NextResponse.json({ error: parsed.error }, { status: 400 });
    const { fromTopicId, toTopicId, scope } = parsed.value;

    const { data: target, error: targetErr } = await supabase
      .from("school_topics")
      .select("id")
      .eq("id", toTopicId)
      .maybeSingle();
    if (targetErr) throw targetErr;
    if (!target) {
      return NextResponse.json({ error: "ไม่พบวิชาปลายทาง" }, { status: 404 });
    }

    let lessonQuery = supabase.from("school_lessons").select("id").eq("topic_id", fromTopicId);
    if (scope.kind === "lesson") lessonQuery = lessonQuery.eq("id", scope.id);
    else if (scope.source === null) lessonQuery = lessonQuery.is("source", null);
    else lessonQuery = lessonQuery.eq("source", scope.source);
    const { data: lessonRows, error: lessonErr } = await lessonQuery
      .order("sort_order")
      .order("created_at");
    if (lessonErr) throw lessonErr;
    const lessonIds = ((lessonRows as { id: string }[] | null) ?? []).map((r) => r.id);

    if (scope.kind === "lesson" && lessonIds.length === 0) {
      return NextResponse.json({ error: "ไม่พบบทเรียนนี้ในวิชาต้นทาง" }, { status: 404 });
    }

    if (lessonIds.length > 0) {
      const { error: visualErr } = await supabase
        .from("school_visuals")
        .update({ topic_id: toTopicId })
        .in("lesson_id", lessonIds);
      if (visualErr) throw visualErr;

      const { count, error: countErr } = await supabase
        .from("school_lessons")
        .select("id", { count: "exact", head: true })
        .eq("topic_id", toTopicId);
      if (countErr) throw countErr;
      const base = count ?? 0;
      const results = await Promise.all(
        lessonIds.map((id, i) =>
          supabase
            .from("school_lessons")
            .update({ topic_id: toTopicId, sort_order: base + i })
            .eq("id", id),
        ),
      );
      const failed = results.find((r) => r.error);
      if (failed?.error) throw failed.error;
    }

    let flashcards = 0;
    let quizzes = 0;
    if (scope.kind === "batch") {
      const moveTable = async (table: "school_flashcards" | "school_quizzes") => {
        let q = supabase.from(table).update({ topic_id: toTopicId }).eq("topic_id", fromTopicId);
        q = scope.source === null ? q.is("source", null) : q.eq("source", scope.source);
        const { data, error } = await q.select("id");
        if (error) throw error;
        return (data as unknown[] | null)?.length ?? 0;
      };
      [flashcards, quizzes] = await Promise.all([
        moveTable("school_flashcards"),
        moveTable("school_quizzes"),
      ]);
    }

    const result: MoveResult = { ok: true, lessons: lessonIds.length, flashcards, quizzes };
    return NextResponse.json(result);
  } catch (e) {
    const message =
      e && typeof e === "object" && "message" in e && typeof e.message === "string"
        ? e.message
        : "Internal error";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
