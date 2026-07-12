"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import {
  readPrereqStatus,
  type LessonRef,
  type PrereqStatus,
} from "@/lib/acls-reader/prereqs";

interface SetRef {
  id: string;
  title: string;
}

function usePrereq(pretestIds: string[], lessons: LessonRef[]) {
  const [mounted, setMounted] = useState(false);
  const [status, setStatus] = useState<PrereqStatus>({
    preTestDone: false,
    lessonsPassed: 0,
    totalLessons: lessons.length,
    unlocked: false,
  });
  useEffect(() => {
    setStatus(readPrereqStatus(pretestIds, lessons));
    setMounted(true);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return { mounted, status };
}

function LockedNotice({ status }: { status: PrereqStatus }) {
  return (
    <div className="rounded-xl border border-amber-200 bg-amber-50 p-5">
      <p className="font-semibold text-amber-900">🔒 ยังล็อกอยู่</p>
      <p className="mt-1 text-sm text-amber-800">
        Post-test จะปลดล็อกเมื่อทำ pre-test และผ่าน pre-course ครบทั้ง 13 บท (≥75% ต่อบท)
      </p>
      <ul className="mt-3 space-y-1 text-sm">
        <li className="flex items-center gap-2">
          <span>{status.preTestDone ? "✅" : "⬜"}</span>
          <span className={status.preTestDone ? "text-amber-900" : "text-amber-800"}>
            ทำ pre-test แล้ว
          </span>
        </li>
        <li className="flex items-center gap-2">
          <span>{status.lessonsPassed >= status.totalLessons ? "✅" : "⬜"}</span>
          <span className="text-amber-800">
            ผ่าน pre-course{" "}
            <span className="font-semibold text-amber-900">
              {status.lessonsPassed}/{status.totalLessons}
            </span>{" "}
            บท
          </span>
        </li>
      </ul>
      <div className="mt-4 flex flex-wrap gap-2">
        {!status.preTestDone && (
          <Link
            href="/acls/test"
            className="rounded-lg border border-amber-300 bg-white px-3 py-1.5 text-sm font-medium text-amber-800 hover:bg-amber-100"
          >
            ไปทำ pre-test
          </Link>
        )}
        {status.lessonsPassed < status.totalLessons && (
          <Link
            href="/acls/learn"
            className="rounded-lg border border-amber-300 bg-white px-3 py-1.5 text-sm font-medium text-amber-800 hover:bg-amber-100"
          >
            ไปเรียน pre-course
          </Link>
        )}
      </div>
    </div>
  );
}

// Renders the post-test section on the test index — cards become real links
// only when prerequisites are met, otherwise they're shown locked.
export function PostTestGate({
  items,
  pretestIds,
  lessons,
}: {
  items: SetRef[];
  pretestIds: string[];
  lessons: LessonRef[];
}) {
  const { mounted, status } = usePrereq(pretestIds, lessons);
  if (items.length === 0) return null;

  const unlocked = mounted && status.unlocked;

  return (
    <div className="mb-8">
      <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        หลังเรียน (Post-test)
      </h2>

      {!unlocked && (
        <div className="mb-4">
          <LockedNotice status={status} />
        </div>
      )}

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
        {items.map((s) =>
          unlocked ? (
            <Link key={s.id} href={`/acls/test/${s.id}`} className="block">
              <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
                <CardHeader>
                  <CardTitle className="text-base">{s.title}</CardTitle>
                  <CardDescription>พร้อมทำแบบทดสอบ</CardDescription>
                </CardHeader>
              </Card>
            </Link>
          ) : (
            <Card
              key={s.id}
              className="h-full cursor-not-allowed opacity-60"
              aria-disabled
            >
              <CardHeader>
                <CardTitle className="text-base">🔒 {s.title}</CardTitle>
                <CardDescription>ยังล็อกอยู่</CardDescription>
              </CardHeader>
            </Card>
          )
        )}
      </div>
    </div>
  );
}

// Wraps the exam page for post-test sets so direct links can't bypass the lock.
export function PrereqGuard({
  pretestIds,
  lessons,
  children,
}: {
  pretestIds: string[];
  lessons: LessonRef[];
  children: React.ReactNode;
}) {
  const { mounted, status } = usePrereq(pretestIds, lessons);

  if (!mounted) {
    return <div className="h-40" aria-hidden />;
  }
  if (!status.unlocked) {
    return <LockedNotice status={status} />;
  }
  return <>{children}</>;
}
