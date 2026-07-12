import { notFound } from "next/navigation";
import Link from "next/link";
import { preCourseLessons, findLessonById } from "@/lib/courses/bls/lessons";
import LessonReader, { type Lesson } from "@/components/acls-reader/LessonReader";

export const dynamicParams = false;

export function generateStaticParams() {
  return preCourseLessons.map((l) => ({ lessonId: l.id }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const { lessonId } = await params;
  const lesson = findLessonById(lessonId);
  return { title: lesson?.title ?? "ไม่พบบทเรียน" };
}

export default async function LessonPage({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const { lessonId } = await params;
  const index = preCourseLessons.findIndex((l) => l.id === lessonId);
  if (index === -1) notFound();

  const lesson = preCourseLessons[index];
  const next = index < preCourseLessons.length - 1 ? preCourseLessons[index + 1] : null;

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <Link href="/bls/learn" className="hover:text-foreground">
          บทเรียน
        </Link>
        {" / "}
        <span className="text-foreground">{lesson.title}</span>
      </nav>

      <header className="mb-6">
        <h1 className="text-2xl font-bold leading-snug sm:text-3xl">{lesson.title}</h1>
        <p className="mt-1 text-sm text-muted-foreground">{lesson.description}</p>
      </header>

      <LessonReader lesson={lesson as Lesson} nextHref="/bls/learn" />

      {next && (
        <div className="mt-8 border-t border-border pt-4 text-sm text-muted-foreground">
          บทถัดไป:{" "}
          <Link href={`/bls/learn/${next.id}`} className="text-brand hover:underline">
            {next.title}
          </Link>
        </div>
      )}
    </div>
  );
}
