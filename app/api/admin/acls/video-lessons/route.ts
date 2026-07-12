import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: list all video lessons (grouped by topic client-side) and create a
// new one, appended at the end of its topic.
// Ported from acls-emr's src/services/videoLessonAdminService.js#listVideoLessonsAdmin/createVideoLesson.

export const runtime = "nodejs";

interface VideoLessonPayload {
  topic: string;
  title: string;
  youtubeId: string;
  orientation?: string;
  startSec?: number | string | null;
  endSec?: number | string | null;
  required?: boolean;
  keyPoints?: string;
  chapters?: unknown[];
  quiz?: unknown[];
  relatedPath?: string | null;
  relatedLabel?: string | null;
}

function toRow(p: VideoLessonPayload) {
  return {
    topic: p.topic,
    title: (p.title || "").trim(),
    youtube_id: (p.youtubeId || "").trim(),
    orientation: p.orientation || "portrait",
    start_sec: p.startSec === "" || p.startSec == null ? null : Number(p.startSec),
    end_sec: p.endSec === "" || p.endSec == null ? null : Number(p.endSec),
    required: p.required !== false,
    key_points: p.keyPoints || "",
    chapters: Array.isArray(p.chapters) ? p.chapters : [],
    quiz: Array.isArray(p.quiz) ? p.quiz : [],
    related_path: p.relatedPath || null,
    related_label: p.relatedLabel || null,
  };
}

export async function GET() {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("video_lessons")
    .select("*")
    .order("topic", { ascending: true })
    .order("sort_order", { ascending: true });
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ items: data ?? [] });
}

export async function POST(request: Request) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;

  let body: VideoLessonPayload;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }
  if (!body.topic || !body.title || !body.youtubeId) {
    return NextResponse.json({ error: "topic, title and youtubeId required" }, { status: 400 });
  }

  const supabase = createAdminClient();

  const { data: existing, error: countErr } = await supabase
    .from("video_lessons")
    .select("sort_order")
    .eq("topic", body.topic)
    .order("sort_order", { ascending: false })
    .limit(1);
  if (countErr) return NextResponse.json({ error: countErr.message }, { status: 500 });
  const nextOrder = ((existing?.[0] as { sort_order?: number } | undefined)?.sort_order ?? 0) + 1;

  const { data, error } = await supabase
    .from("video_lessons")
    .insert({ ...toRow(body), sort_order: nextOrder })
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ item: data });
}
