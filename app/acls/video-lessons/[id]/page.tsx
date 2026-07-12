import type { Metadata } from "next";
import { getVideoLessons } from "@/lib/courses/video-lessons";
import VideoLessonDetail from "@/components/courses/VideoLessonDetail";

export const revalidate = 600;
export const dynamicParams = true;

export async function generateStaticParams() {
  try {
    const lessons = await getVideoLessons();
    return lessons.map((l) => ({ id: l.id }));
  } catch {
    return [];
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}): Promise<Metadata> {
  const { id } = await params;
  const lessons = await getVideoLessons();
  const title = lessons.find((l) => l.id === id)?.title ?? "วิดีโอบทเรียน";
  return { title };
}

// Server shell: fetches the full lesson list (needed for prev/next-in-topic
// navigation) and hands it down to the client detail component.
export default async function VideoLessonDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const lessons = await getVideoLessons();

  return <VideoLessonDetail lessons={lessons} currentId={id} />;
}
