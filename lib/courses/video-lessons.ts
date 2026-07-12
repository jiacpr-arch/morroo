import { supabase } from "@/lib/acls-reader/supabase";

// Video lessons (YouTube-based), ported from acls-emr's
// src/services/videoLessonService.js. Reads video_lessons — public,
// anon-readable (see supabase/migrations/20260712_acls_video_lessons.sql).
// No client-side cache layer here (unlike the source app's localStorage
// cache) — pages calling these are RSCs with `export const revalidate`,
// which already caches at the Next.js layer.

export interface VideoQuizQuestion {
  id: string;
  question: string;
  choices: { id: string; text: string }[];
  correctId: string;
  explanation?: string;
}

export interface VideoLesson {
  id: string;
  topic: string;
  title: string;
  youtubeId: string;
  orientation: "portrait" | "landscape";
  startSec: number | null;
  endSec: number | null;
  required: boolean;
  keyPoints: string;
  chapters: { label: string; startSec: number }[];
  quiz: VideoQuizQuestion[];
  relatedPath: string;
  relatedLabel: string;
  sortOrder: number;
}

interface VideoLessonRow {
  id: string;
  topic: string;
  title: string;
  youtube_id: string;
  orientation: string | null;
  start_sec: number | null;
  end_sec: number | null;
  required: boolean | null;
  key_points: string | null;
  chapters: unknown;
  quiz: unknown;
  related_path: string | null;
  related_label: string | null;
  sort_order: number | null;
}

function mapVideoLessonRow(row: VideoLessonRow): VideoLesson {
  return {
    id: row.id,
    topic: row.topic,
    title: row.title,
    youtubeId: row.youtube_id,
    orientation: row.orientation === "landscape" ? "landscape" : "portrait",
    startSec: row.start_sec ?? null,
    endSec: row.end_sec ?? null,
    required: row.required !== false,
    keyPoints: row.key_points || "",
    chapters: Array.isArray(row.chapters) ? (row.chapters as VideoLesson["chapters"]) : [],
    quiz: Array.isArray(row.quiz) ? (row.quiz as VideoQuizQuestion[]) : [],
    relatedPath: row.related_path || "",
    relatedLabel: row.related_label || "",
    sortOrder: row.sort_order ?? 0,
  };
}

export async function getVideoLessons(): Promise<VideoLesson[]> {
  try {
    const { data, error } = await supabase
      .from("video_lessons")
      .select("*")
      .order("topic", { ascending: true })
      .order("sort_order", { ascending: true });
    if (error) throw error;
    return (data ?? []).map((r) => mapVideoLessonRow(r as VideoLessonRow));
  } catch {
    return [];
  }
}

export async function getVideoLessonById(id: string): Promise<VideoLesson | null> {
  const lessons = await getVideoLessons();
  return lessons.find((l) => l.id === id) ?? null;
}

export function groupVideoLessonsByTopic(
  lessons: VideoLesson[],
): Record<string, VideoLesson[]> {
  const map: Record<string, VideoLesson[]> = {};
  for (const l of lessons) {
    (map[l.topic] ??= []).push(l);
  }
  return map;
}
