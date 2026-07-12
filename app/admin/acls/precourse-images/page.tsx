"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, ChevronRight, BookOpen, Eye } from "lucide-react";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { ImageManager, type AclsImage } from "@/components/admin/acls/ImageManager";
import { VideoManager, type PreCourseVideo } from "@/components/admin/acls/VideoManager";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";
import { preCourseLessons } from "@/lib/acls-reader/precourse";

interface ReadStep {
  type: "read";
  heading: string;
  body: string;
}
interface OtherStep {
  type: string;
  [key: string]: unknown;
}
type Step = ReadStep | OtherStep;
interface Lesson {
  id: string;
  title: string;
  steps: Step[];
}

const lessons = preCourseLessons as unknown as Lesson[];

// Stable id for a read step, matching acls-emr's deriveLesson()
// (`${lessonId}-r${readIndex}`) — morroo's lib/acls-reader/precourse.ts port
// doesn't attach these ids to steps (it only derives `sections`/`quiz` for
// the reader), so we recompute them here locally, deterministically, from
// the same step order. This keeps parent_id values compatible with any
// pre-existing acls_images rows seeded from the source app.
function readStepsWithIds(lesson: Lesson): { id: string; step: ReadStep }[] {
  let readIdx = 0;
  const out: { id: string; step: ReadStep }[] = [];
  for (const s of lesson.steps) {
    if (s.type === "read") {
      out.push({ id: `${lesson.id}-r${readIdx}`, step: s as ReadStep });
      readIdx += 1;
    }
  }
  return out;
}

interface ImageRow {
  id: string;
  parent_type: string;
  parent_id: string;
  src: string;
  alt: string | null;
  caption: string | null;
}

// Pre-course lesson media manager — walk each lesson's read steps and manage
// the images/videos attached to that step (acls_images with
// parent_type='precourse-step' | 'precourse-video').
// Simplified from acls-emr's src/pages/AdminPreCourseImages.jsx: this port
// skips the full student-facing step preview (ReadBody/LessonImages/
// LessonVideos/QuizQuestion components aren't part of this phase's ported
// surface) and only walks READ steps (media only ever attaches to read
// steps) — quiz steps are omitted from the stepper since there's nothing to
// manage on them.
export default function AdminPreCourseImagesPage() {
  const status = useAdminGate();
  const [lessonId, setLessonId] = useState(lessons[0]?.id ?? "");
  const [stepIdx, setStepIdx] = useState(0);
  const [images, setImages] = useState<ImageRow[]>([]);
  const [loading, setLoading] = useState(true);

  const load = useCallback(async () => {
    try {
      const { images } = await apiGet<{ images: ImageRow[] }>(
        "/api/admin/acls/images?parentTypes=precourse-step,precourse-video",
      );
      setImages(images);
    } catch (err) {
      alert("โหลดสื่อไม่สำเร็จ: " + errMsg(err));
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    if (status === "ok") load();
  }, [status, load]);

  const lesson = useMemo(() => lessons.find((l) => l.id === lessonId) ?? null, [lessonId]);
  const steps = useMemo(() => (lesson ? readStepsWithIds(lesson) : []), [lesson]);
  const totalSteps = steps.length;
  const safeIdx = Math.min(stepIdx, Math.max(0, totalSteps - 1));
  const current = steps[safeIdx] ?? null;

  const imagesByStep = useMemo(() => {
    const map = new Map<string, AclsImage[]>();
    for (const img of images) {
      if (img.parent_type !== "precourse-step") continue;
      const arr = map.get(img.parent_id) ?? [];
      arr.push(img);
      map.set(img.parent_id, arr);
    }
    return map;
  }, [images]);

  const videosByStep = useMemo(() => {
    const map = new Map<string, PreCourseVideo[]>();
    for (const img of images) {
      if (img.parent_type !== "precourse-video") continue;
      const arr = map.get(img.parent_id) ?? [];
      arr.push(img);
      map.set(img.parent_id, arr);
    }
    return map;
  }, [images]);

  const changeLesson = (id: string) => {
    setLessonId(id);
    setStepIdx(0);
  };

  const lessonMediaCount = (l: Lesson) => {
    let imgs = 0;
    let vids = 0;
    for (const { id } of readStepsWithIds(l)) {
      imgs += imagesByStep.get(id)?.length || 0;
      vids += videosByStep.get(id)?.length || 0;
    }
    return { imgs, vids };
  };

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="mb-6">
        <h1 className="text-2xl font-bold">สื่อประกอบบทเรียน (Pre-course)</h1>
        <p className="text-muted-foreground mt-1">เลือกบทเรียน แล้วเดินทีละหัวข้อเพื่อจัดการรูป/วิดีโอ</p>
      </div>

      <div className="border rounded-md p-3 space-y-2 mb-4">
        <label className="text-xs font-bold text-muted-foreground">เลือกบทเรียน</label>
        <select
          value={lessonId}
          onChange={(e) => changeLesson(e.target.value)}
          className="w-full px-3 py-2 bg-background border rounded-md text-sm"
        >
          {lessons.map((l) => {
            const { imgs, vids } = lessonMediaCount(l);
            return (
              <option key={l.id} value={l.id}>
                {l.title} — {imgs} รูป · {vids} วิดีโอ
              </option>
            );
          })}
        </select>
      </div>

      {loading ? (
        <div className="text-center text-sm text-muted-foreground py-8">กำลังโหลด…</div>
      ) : !lesson || totalSteps === 0 ? (
        <div className="text-center text-sm text-muted-foreground py-8">บทนี้ไม่มีหัวข้อเนื้อหา (read step)</div>
      ) : (
        <>
          <div className="border rounded-md p-3 space-y-2 mb-4">
            <div className="flex items-center justify-between gap-2">
              <span className="inline-flex items-center gap-1.5 bg-blue-600 text-white text-xs font-extrabold px-2.5 py-1 rounded-full shrink-0">
                หัวข้อ {safeIdx + 1} / {totalSteps}
              </span>
              <span className="text-xs font-bold text-muted-foreground truncate">{current?.step.heading}</span>
            </div>
          </div>

          <section className="border rounded-md p-4 space-y-3 mb-4">
            <div className="inline-flex items-center gap-1.5 text-xs font-bold text-muted-foreground">
              <Eye className="h-3 w-3" /> เนื้อหา (มุมมองย่อ)
            </div>
            <div className="text-lg font-bold text-blue-600">{current?.step.heading}</div>
            <div className="text-sm whitespace-pre-wrap leading-relaxed">{current?.step.body}</div>
          </section>

          <section className="border border-blue-200 rounded-md p-4 space-y-4">
            <div className="inline-flex items-center gap-1.5 text-xs font-bold text-blue-600">จัดการสื่อของหัวข้อนี้</div>
            {current && (
              <>
                <ImageManager
                  parentType="precourse-step"
                  parentId={current.id}
                  images={imagesByStep.get(current.id) || []}
                  onChange={load}
                />
                <div className="h-px bg-border" />
                <VideoManager stepId={current.id} videos={videosByStep.get(current.id) || []} onChange={load} />
              </>
            )}
          </section>

          <div className="flex items-center gap-2 pt-4">
            <button
              onClick={() => setStepIdx(Math.max(0, safeIdx - 1))}
              disabled={safeIdx === 0}
              className="inline-flex items-center gap-1 text-sm px-3 py-1.5 rounded-md border disabled:opacity-40"
            >
              <ChevronLeft className="h-4 w-4" /> ก่อนหน้า
            </button>
            <div className="flex-1" />
            <button
              onClick={() => setStepIdx(Math.min(totalSteps - 1, safeIdx + 1))}
              disabled={safeIdx >= totalSteps - 1}
              className="inline-flex items-center gap-1 text-sm px-3 py-1.5 rounded-md bg-brand text-white disabled:opacity-40"
            >
              ถัดไป <ChevronRight className="h-4 w-4" />
            </button>
          </div>
        </>
      )}

      <p className="text-xs text-muted-foreground text-center pt-6 inline-flex items-center justify-center gap-1 w-full">
        <BookOpen className="h-3 w-3" /> สื่อจะ refresh ในแอปนักเรียนภายใน 10 นาที (revalidate)
      </p>
    </div>
  );
}
