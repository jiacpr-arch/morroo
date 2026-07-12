import type { Metadata } from "next";
import { getVideoLessons, groupVideoLessonsByTopic } from "@/lib/courses/video-lessons";
import { VIDEO_TOPICS } from "@/lib/courses/video-topics";
import VideoLessonsList from "@/components/courses/VideoLessonsList";

export const metadata: Metadata = {
  title: "วิดีโอบทเรียน",
};

export const revalidate = 600;

// Server shell: fetches + groups the video lessons, hands them to the client
// list (which owns the active-student/Dexie progress logic).
export default async function VideoLessonsPage() {
  const lessons = await getVideoLessons();
  const byTopic = groupVideoLessonsByTopic(lessons);
  const topicIds = VIDEO_TOPICS.map((t) => t.id).filter((id) => (byTopic[id]?.length ?? 0) > 0);

  return <VideoLessonsList lessons={lessons} byTopic={byTopic} topicIds={topicIds} />;
}
