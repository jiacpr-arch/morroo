import { NextResponse } from "next/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { requireAdmin } from "@/lib/admin-auth";

// Admin: update or delete a video lesson. Reordering within a topic is done
// by the client swapping sort_order between two adjacent clips (two PATCH
// calls) — mirrors acls-emr's swapVideoLessonOrder.
// Ported from acls-emr's src/services/videoLessonAdminService.js#updateVideoLesson/deleteVideoLesson.

export const runtime = "nodejs";

interface VideoLessonPatch {
  topic?: string;
  title?: string;
  youtubeId?: string;
  orientation?: string;
  startSec?: number | string | null;
  endSec?: number | string | null;
  required?: boolean;
  keyPoints?: string;
  chapters?: unknown[];
  quiz?: unknown[];
  relatedPath?: string | null;
  relatedLabel?: string | null;
  sortOrder?: number;
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  let body: VideoLessonPatch;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ error: "invalid body" }, { status: 400 });
  }

  const patch: Record<string, unknown> = {};
  if (body.topic !== undefined) patch.topic = body.topic;
  if (body.title !== undefined) patch.title = (body.title || "").trim();
  if (body.youtubeId !== undefined) patch.youtube_id = (body.youtubeId || "").trim();
  if (body.orientation !== undefined) patch.orientation = body.orientation || "portrait";
  if (body.startSec !== undefined) {
    patch.start_sec = body.startSec === "" || body.startSec == null ? null : Number(body.startSec);
  }
  if (body.endSec !== undefined) {
    patch.end_sec = body.endSec === "" || body.endSec == null ? null : Number(body.endSec);
  }
  if (body.required !== undefined) patch.required = body.required !== false;
  if (body.keyPoints !== undefined) patch.key_points = body.keyPoints || "";
  if (body.chapters !== undefined) patch.chapters = Array.isArray(body.chapters) ? body.chapters : [];
  if (body.quiz !== undefined) patch.quiz = Array.isArray(body.quiz) ? body.quiz : [];
  if (body.relatedPath !== undefined) patch.related_path = body.relatedPath || null;
  if (body.relatedLabel !== undefined) patch.related_label = body.relatedLabel || null;
  if (body.sortOrder !== undefined) patch.sort_order = body.sortOrder;

  const supabase = createAdminClient();
  const { error } = await supabase.from("video_lessons").update(patch).eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}

export async function DELETE(
  _request: Request,
  { params }: { params: Promise<{ id: string }> },
) {
  const guard = await requireAdmin();
  if (!guard.ok) return guard.response;
  const { id } = await params;

  const supabase = createAdminClient();
  const { error } = await supabase.from("video_lessons").delete().eq("id", id);
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
