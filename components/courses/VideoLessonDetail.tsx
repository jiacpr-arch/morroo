"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ChevronLeft, ChevronRight, MapPin, FileText, CheckCircle2, BookOpen, Check } from "lucide-react";
import { usePreCourseStore } from "@/lib/courses/stores/pre-course-store";
import {
  markLessonRead,
  saveQuizAttempt,
  getLessonProgress,
  getBestAttempt,
  getAttemptCount,
} from "@/lib/courses/offline/db";
import { scheduleFlush } from "@/lib/courses/offline/sync-engine";
import { videoLessonKey, VIDEO_TOPIC_MAP } from "@/lib/courses/video-topics";
import { getCourseMeta } from "@/lib/courses/config";
import { formatClipTime } from "@/lib/courses/youtube";
import type { VideoLesson } from "@/lib/courses/video-lessons";
import { groupVideoLessonsByTopic } from "@/lib/courses/video-lessons";
import YouTubeLessonPlayer, {
  type YouTubeLessonPlayerHandle,
} from "@/components/courses/YouTubeLessonPlayer";
import VideoQuiz from "@/components/courses/VideoQuiz";
import { dashCard } from "@/components/courses/course-ui";
import { cn } from "@/lib/utils";

const passingScore = getCourseMeta("acls").passingScore.lesson;

function ReadBody({ body }: { body: string }) {
  const lines = (body ?? "")
    .split("\n")
    .map((l) => l.trim())
    .filter(Boolean);

  return (
    <div className="text-[15px] leading-7 text-foreground/85">
      {lines.map((line, i) => {
        const bullet = line.match(/^([•\-*])\s+(.*)$/);
        const numbered = line.match(/^(\d+)[).]\s+(.*)$/);
        if (bullet) {
          return (
            <div key={i} className={cn("flex gap-2.5", i > 0 && "mt-2")}>
              <span className="shrink-0 text-brand">•</span>
              <span>{bullet[2]}</span>
            </div>
          );
        }
        if (numbered) {
          return (
            <div key={i} className={cn("flex gap-2.5", i > 0 && "mt-2")}>
              <span className="shrink-0 font-semibold text-brand">{numbered[1]}.</span>
              <span>{numbered[2]}</span>
            </div>
          );
        }
        return (
          <p key={i} className={cn(i > 0 && "mt-2")}>
            {line}
          </p>
        );
      })}
    </div>
  );
}

interface VideoLessonDetailProps {
  lessons: VideoLesson[];
  currentId: string;
}

// Client detail page: player + chapters/timestamps + key-points summary +
// inline quiz + watched tracking + prev/next-in-topic nav + related-lesson
// link. Ported from acls-emr's src/pages/VideoLessonDetail.jsx.
export default function VideoLessonDetail({ lessons, currentId }: VideoLessonDetailProps) {
  const router = useRouter();
  const activeStudent = usePreCourseStore((s) => s.activeStudent);
  const playerRef = useRef<YouTubeLessonPlayerHandle | null>(null);

  const byTopic = useMemo(() => groupVideoLessonsByTopic(lessons), [lessons]);

  const clip = useMemo(() => {
    for (const list of Object.values(byTopic)) {
      const found = list.find((c) => c.id === currentId);
      if (found) return found;
    }
    return null;
  }, [byTopic, currentId]);

  const topicClips = clip ? byTopic[clip.topic] || [] : [];
  const clipIndex = clip ? topicClips.findIndex((c) => c.id === clip.id) : -1;
  const nextClip = clipIndex >= 0 ? topicClips[clipIndex + 1] : null;
  const topicMeta = clip ? VIDEO_TOPIC_MAP[clip.topic] : null;

  const [watched, setWatched] = useState(false);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [quizSubmitted, setQuizSubmitted] = useState(false);
  const [quizPassed, setQuizPassed] = useState(false);
  const startedAtRef = useRef(new Date().toISOString());

  // init watched/passed state จาก progress เดิม
  useEffect(() => {
    setWatched(false);
    setAnswers({});
    setQuizSubmitted(false);
    setQuizPassed(false);
    startedAtRef.current = new Date().toISOString();
    if (!clip || !activeStudent) return;
    const key = videoLessonKey(clip.id);
    getLessonProgress(activeStudent.id).then((rows) => {
      if (rows.some((r) => r.lessonId === key)) setWatched(true);
    });
    if (clip.quiz?.length) {
      getBestAttempt(activeStudent.id, key).then((best) => {
        if (best?.passed) {
          setQuizSubmitted(true);
          setQuizPassed(true);
        }
      });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [clip?.id, activeStudent?.id]);

  const handleWatched = () => {
    setWatched(true);
    if (activeStudent && clip) {
      markLessonRead(activeStudent.id, videoLessonKey(clip.id));
      scheduleFlush();
    }
  };

  const quiz = useMemo(() => clip?.quiz || [], [clip]);
  const allAnswered = quiz.length > 0 && quiz.every((q) => answers[q.id] != null);

  const submitQuiz = () => {
    if (!allAnswered || !clip) return;
    const correctCount = quiz.filter((q) => answers[q.id] === q.correctId).length;
    const score = Math.round((correctCount / quiz.length) * 100);
    const passed = score >= passingScore;
    setQuizSubmitted(true);
    setQuizPassed(passed);
    if (activeStudent) {
      const lessonId = videoLessonKey(clip.id);
      const detailed = quiz.map((q) => ({
        questionId: q.id,
        chosenId: answers[q.id],
        correct: answers[q.id] === q.correctId,
      }));
      void (async () => {
        const prevCount = await getAttemptCount(activeStudent.id, lessonId);
        await saveQuizAttempt({
          studentId: activeStudent.id,
          lessonId,
          score,
          totalQuestions: quiz.length,
          correctCount,
          answers: detailed,
          startedAt: startedAtRef.current,
          finishedAt: new Date().toISOString(),
          passed,
          attemptNumber: prevCount + 1,
        });
        scheduleFlush();
      })();
    }
  };

  if (!clip) {
    return (
      <div className="mx-auto max-w-2xl space-y-3 px-4 py-12 text-center sm:px-6 lg:px-8">
        <div className="text-sm text-muted-foreground">ไม่พบวิดีโอนี้</div>
        <button
          onClick={() => router.push("/acls/video-lessons")}
          className="rounded-lg px-3 py-1.5 text-sm text-muted-foreground underline"
        >
          กลับไปไลบรารีวิดีโอ
        </button>
      </div>
    );
  }

  const done = watched && (quiz.length === 0 || quizPassed);

  return (
    <div className="mx-auto max-w-2xl space-y-4 px-4 py-6 pb-24 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2">
        <Link
          href="/acls/video-lessons"
          className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
        >
          <ChevronLeft size={18} strokeWidth={2.2} /> {topicMeta?.emoji} {topicMeta?.label}
        </Link>
      </div>

      <YouTubeLessonPlayer
        ref={playerRef}
        videoId={clip.youtubeId}
        startSec={clip.startSec}
        endSec={clip.endSec}
        orientation={clip.orientation}
        onWatched={handleWatched}
      />

      <div>
        <div className="flex items-start justify-between gap-2">
          <h1 className="text-xl font-bold text-foreground">{clip.title}</h1>
          {done && (
            <span className="mt-1 inline-flex shrink-0 items-center gap-1 text-[11px] font-bold text-emerald-600 dark:text-emerald-400">
              <CheckCircle2 size={14} strokeWidth={2.4} /> ผ่านแล้ว
            </span>
          )}
        </div>
        <div className="mt-0.5 text-sm text-muted-foreground">
          คลิป {clipIndex + 1}/{topicClips.length}
          {watched ? " · ดูจบแล้ว ✓" : ' · ดูจนเกือบจบเพื่อนับว่า "ดูครบ"'}
        </div>
      </div>

      {/* A — สารบัญช่วงเวลา */}
      {clip.chapters?.length > 0 && (
        <div className={cn(dashCard, "!p-3")}>
          <div className="mb-2 inline-flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wider text-purple-600 dark:text-purple-400">
            <MapPin size={12} strokeWidth={2.4} /> สารบัญช่วงเวลา
          </div>
          <div className="space-y-1">
            {clip.chapters.map((ch, i) => (
              <button
                key={i}
                type="button"
                onClick={() => playerRef.current?.seekTo(ch.startSec)}
                className="-mx-1 flex w-full items-center gap-2.5 rounded-md px-1 py-1.5 text-left transition-colors hover:bg-muted/50"
              >
                <span
                  className="shrink-0 rounded-md bg-purple-500/10 px-2 py-0.5 font-mono text-xs font-bold tabular-nums text-purple-600 dark:text-purple-400"
                >
                  {formatClipTime(ch.startSec)}
                </span>
                <span className="flex-1 text-sm text-foreground/85">{ch.label}</span>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* B — สรุปประเด็นสำคัญ */}
      {clip.keyPoints?.trim() && (
        <div className={dashCard}>
          <div className="mb-2 inline-flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wider text-purple-600 dark:text-purple-400">
            <FileText size={12} strokeWidth={2.4} /> สรุปประเด็นสำคัญ
          </div>
          <ReadBody body={clip.keyPoints} />
        </div>
      )}

      {/* C — เช็คความเข้าใจ (ควิซ) */}
      {quiz.length > 0 && (
        <div className={cn(dashCard, "space-y-4")}>
          <div className="inline-flex items-center gap-1.5 text-[11px] font-semibold uppercase tracking-wider text-emerald-600 dark:text-emerald-400">
            <CheckCircle2 size={12} strokeWidth={2.4} /> เช็คความเข้าใจ (ผ่าน ≥ {passingScore}%)
          </div>
          {quiz.map((q) => (
            <VideoQuiz
              key={q.id}
              question={q}
              chosenId={answers[q.id]}
              onChoose={(cid) => !quizSubmitted && setAnswers((a) => ({ ...a, [q.id]: cid }))}
              locked={quizSubmitted}
              showCorrect={quizSubmitted}
            />
          ))}
          {!quizSubmitted ? (
            <button
              onClick={submitQuiz}
              disabled={!allAnswered}
              className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-emerald-700 disabled:cursor-not-allowed disabled:opacity-40"
            >
              ส่งคำตอบ
            </button>
          ) : (
            <div
              className={cn(
                "text-center text-sm font-bold",
                quizPassed ? "text-emerald-600 dark:text-emerald-400" : "text-amber-600 dark:text-amber-400",
              )}
            >
              {quizPassed ? "🎉 ผ่านควิซแล้ว!" : "ยังไม่ผ่าน — ทบทวนคลิปแล้วลองใหม่"}
              {!quizPassed && (
                <button
                  onClick={() => {
                    setQuizSubmitted(false);
                    setAnswers({});
                  }}
                  className="mx-auto mt-2 block text-sm text-muted-foreground underline"
                >
                  ลองใหม่
                </button>
              )}
            </div>
          )}
        </div>
      )}

      {/* D — อ่านต่อในบทเรียน */}
      {clip.relatedPath && (
        <Link
          href={clip.relatedPath}
          className={cn(
            dashCard,
            "!p-3 flex items-center gap-3 border-l-4 border-l-blue-500 transition-colors hover:bg-muted/50",
          )}
        >
          <BookOpen size={18} strokeWidth={2.2} className="shrink-0 text-blue-600 dark:text-blue-400" />
          <span className="flex-1 text-sm font-bold text-blue-600 dark:text-blue-400">
            {clip.relatedLabel || "อ่านต่อในบทเรียน"}
          </span>
          <ChevronRight size={16} strokeWidth={2.2} className="shrink-0 text-blue-600 dark:text-blue-400" />
        </Link>
      )}

      {/* next */}
      {nextClip && (
        <button
          onClick={() => router.push(`/acls/video-lessons/${nextClip.id}`)}
          className="flex w-full items-center justify-center gap-1.5 rounded-lg bg-blue-600 px-4 py-3 text-sm font-semibold text-white transition-colors hover:bg-blue-700"
        >
          คลิปถัดไป: {nextClip.title} <ChevronRight size={16} strokeWidth={2.4} />
        </button>
      )}
      {!nextClip && done && (
        <div
          className={cn(
            dashCard,
            "!p-3 flex w-full items-center justify-center gap-1.5 text-center text-sm font-bold text-emerald-600 dark:text-emerald-400",
          )}
        >
          <Check size={15} strokeWidth={2.6} /> จบหัวข้อนี้แล้ว
        </div>
      )}
    </div>
  );
}
