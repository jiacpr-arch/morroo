import type { Metadata } from "next";
import Link from "next/link";
import {
  preCourseLessons,
  preCourseVideos,
  getLessonQuizCount,
} from "@/lib/acls-reader/precourse";

export const metadata: Metadata = {
  title: "บทเรียน Pre-course",
  description: "บทเรียนย่อย ACLS 13 บท แบบอ่าน-ควิซ-อ่าน อ้างอิง ILCOR 2025",
};

export default function LearnIndexPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">บทเรียน</span>
      </nav>

      <header className="mb-8">
        <h1 className="text-3xl font-bold sm:text-4xl">บทเรียน Pre-course</h1>
        <p className="mt-2 text-muted-foreground">
          13 บทแบบ micro-learning — อ่านสั้น ๆ สลับควิซ พร้อมเฉลยทุกข้อ (อ้างอิง ILCOR 2025)
        </p>
      </header>

      <ol className="space-y-3">
        {preCourseLessons.map((lesson, i) => (
          <li key={lesson.id}>
            <Link
              href={`/acls/learn/${lesson.id}`}
              className="group flex items-start gap-4 rounded-xl border border-border p-4 transition-colors hover:border-brand/40 hover:bg-muted/40"
            >
              <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-brand/10 text-sm font-bold text-brand">
                {i + 1}
              </span>
              <div className="min-w-0 flex-1">
                <h2 className="font-semibold leading-snug group-hover:text-brand">
                  {lesson.title}
                </h2>
                <p className="mt-1 text-sm text-muted-foreground">{lesson.description}</p>
                <p className="mt-1 text-xs text-muted-foreground">
                  ~{lesson.estMinutes} นาที · {getLessonQuizCount(lesson)} ข้อสอบ · เกณฑ์ผ่าน{" "}
                  {lesson.passingScore}%
                </p>
              </div>
              <span className="self-center text-muted-foreground group-hover:text-brand">→</span>
            </Link>
          </li>
        ))}
      </ol>

      {preCourseVideos.length > 0 && (
        <div className="mt-10 rounded-xl border border-border bg-muted/40 p-4">
          <p className="mb-2 text-sm font-medium">วิดีโอประกอบ</p>
          <div className="flex flex-wrap gap-2">
            {preCourseVideos.map((v) => (
              <a
                key={v.url}
                href={v.url}
                target="_blank"
                rel="noopener noreferrer"
                className="rounded-lg border border-border px-3 py-1.5 text-sm text-brand hover:bg-background"
              >
                {v.label} ↗
              </a>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
