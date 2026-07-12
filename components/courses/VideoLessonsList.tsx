"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Video, Check, Circle, ChevronRight, Lock } from "lucide-react";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import { getLessonProgress, getAttemptsForStudent } from "@/lib/courses/offline/db";
import { buildProgressSets, clipDone, clipWatched } from "@/lib/courses/video-progress";
import { VIDEO_TOPIC_MAP } from "@/lib/courses/video-topics";
import type { VideoLesson } from "@/lib/courses/video-lessons";
import { dashCard } from "@/components/courses/course-ui";
import { cn } from "@/lib/utils";

interface VideoLessonsListProps {
  lessons: VideoLesson[];
  byTopic: Record<string, VideoLesson[]>;
  topicIds: string[];
}

// Client piece of the video-lessons library page: reads the active student +
// Dexie progress/attempts to compute done/watched badges. The lesson data
// itself is fetched server-side and handed down as props (RSC-first
// convention — see app/acls/page.tsx / AclsHub).
export default function VideoLessonsList({ lessons, byTopic, topicIds }: VideoLessonsListProps) {
  const activeStudent = usePreCourseStore((s) => s.activeStudent);
  const [progress, setProgress] = useState<{ lessonId: string }[]>([]);
  const [attempts, setAttempts] = useState<{ lessonId: string; passed: boolean }[]>([]);

  useEffect(() => {
    if (!activeStudent) {
      setProgress([]);
      setAttempts([]);
      return;
    }
    Promise.all([
      getLessonProgress(activeStudent.id),
      getAttemptsForStudent(activeStudent.id),
    ]).then(([p, a]) => {
      setProgress(p);
      setAttempts(a);
    });
  }, [activeStudent?.id]);

  const { progressLessonIds, passedLessonIds } = buildProgressSets(progress, attempts);

  const requiredTotal = lessons.filter((l) => l.required).length;
  const requiredDone = lessons.filter(
    (l) => l.required && clipDone(l, progressLessonIds, passedLessonIds),
  ).length;
  const pct = requiredTotal ? Math.round((requiredDone / requiredTotal) * 100) : 0;

  return (
    <div className="mx-auto max-w-2xl space-y-5 px-4 py-10 pb-24 sm:px-6 lg:px-8">
      <div className="space-y-2 text-center">
        <div
          className="mx-auto inline-flex h-16 w-16 items-center justify-center"
          style={{
            background: "linear-gradient(135deg, #7C3AED 0%, #5B21B6 100%)",
            borderRadius: "1.25rem",
            boxShadow: "0 8px 20px rgba(124, 58, 237, 0.28)",
          }}
        >
          <Video size={28} strokeWidth={2.2} className="text-white" />
        </div>
        <h1 className="text-2xl font-bold text-foreground">วิดีโอบทเรียน</h1>
        <p className="text-sm text-muted-foreground">
          คลิปสอนเชิงลึกทุกหัวข้อ · ดูครบ + ผ่านควิซ = นับเข้าใบประกาศนียบัตร
        </p>
      </div>

      {requiredTotal > 0 && (
        <div className={cn(dashCard, "text-center")}>
          <div
            className={cn(
              "text-4xl font-bold tabular-nums",
              pct === 100 ? "text-emerald-600 dark:text-emerald-400" : "text-purple-600 dark:text-purple-400",
            )}
          >
            {pct}%
          </div>
          <div className="mt-1 text-sm text-muted-foreground">
            ดูครบ + ผ่านควิซแล้ว {requiredDone}/{requiredTotal} คลิป (บังคับ)
          </div>
          <div className="mt-3 h-2 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full transition-all"
              style={{
                width: `${pct}%`,
                background: pct === 100 ? "var(--color-emerald-500, #10b981)" : "#7C3AED",
              }}
            />
          </div>
        </div>
      )}

      {topicIds.length === 0 && (
        <div className={cn(dashCard, "py-10 text-center text-sm text-muted-foreground")}>
          ยังไม่มีวิดีโอบทเรียน — แอดมินกำลังเพิ่มเนื้อหา
        </div>
      )}

      {topicIds.map((topicId) => {
        const clips = byTopic[topicId] || [];
        const meta = VIDEO_TOPIC_MAP[topicId];
        if (!meta || clips.length === 0) return null;
        return (
          <div key={topicId} className="space-y-2">
            <div className="px-1 text-[11px] font-semibold uppercase tracking-wider text-muted-foreground">
              <span className="mr-1.5" aria-hidden="true">
                {meta.emoji}
              </span>
              {meta.label}
            </div>
            <div className="space-y-2">
              {clips.map((clip, idx) => {
                const done = clipDone(clip, progressLessonIds, passedLessonIds);
                const watched = clipWatched(clip, progressLessonIds);
                return (
                  <Link
                    key={clip.id}
                    href={`/acls/video-lessons/${clip.id}`}
                    className={cn(
                      dashCard,
                      "!p-3 flex w-full items-center gap-3 border transition-colors hover:border-purple-400/40",
                      done ? "border-emerald-500/40" : "border-border",
                    )}
                  >
                    <div
                      className={cn(
                        "inline-flex h-9 w-9 shrink-0 items-center justify-center rounded-lg",
                        done
                          ? "bg-emerald-500/15 text-emerald-600 dark:text-emerald-400"
                          : "bg-purple-500/10 text-purple-600 dark:text-purple-400",
                      )}
                    >
                      {done ? <Check size={16} strokeWidth={2.6} /> : <Circle size={15} strokeWidth={2} />}
                    </div>
                    <div className="min-w-0 flex-1 text-left">
                      <div className="truncate text-sm font-bold text-foreground">
                        <span className="mr-1.5 font-mono text-muted-foreground">{idx + 1}.</span>
                        {clip.title}
                      </div>
                      <div className="mt-0.5 text-[11px] text-muted-foreground">
                        {watched && !done ? "ดูแล้ว · ยังไม่ผ่านควิซ" : done ? "ผ่านแล้ว" : "ยังไม่ดู"}
                        {clip.quiz?.length > 0 && <span className="ml-1.5">· มีควิซ</span>}
                        {!clip.required && <span className="ml-1.5 text-muted-foreground">· เสริม</span>}
                      </div>
                    </div>
                    <ChevronRight size={16} strokeWidth={2.2} className="shrink-0 text-muted-foreground" />
                  </Link>
                );
              })}
            </div>
          </div>
        );
      })}

      {!activeStudent && topicIds.length > 0 && (
        <div
          className={cn(
            dashCard,
            "!p-3 flex items-start gap-2 border border-blue-500/30 bg-blue-500/8 text-sm text-foreground/80",
          )}
        >
          <Lock size={15} strokeWidth={2.2} className="mt-0.5 shrink-0 text-blue-600 dark:text-blue-400" />
          <span>ลงทะเบียนเข้าเรียน (ที่หน้า Pre-course) เพื่อบันทึกความคืบหน้าและนับเข้าเงื่อนไขใบประกาศนียบัตร</span>
        </div>
      )}
    </div>
  );
}
