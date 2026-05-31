import { notFound } from "next/navigation";
import Link from "next/link";
import { getQaDeepByChapter, getQaDeepChapters } from "@/lib/acls-reader/qa-deep";

export const revalidate = 600;
export const dynamicParams = true;

export async function generateStaticParams() {
  try {
    const chapters = await getQaDeepChapters();
    return chapters.map((c) => ({ chapterId: c.id }));
  } catch {
    return [];
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ chapterId: string }>;
}) {
  const { chapterId } = await params;
  const chapters = await getQaDeepChapters();
  const title = chapters.find((c) => c.id === chapterId)?.title ?? "Q&A เชิงลึก";
  return { title };
}

export default async function QaDeepChapterPage({
  params,
}: {
  params: Promise<{ chapterId: string }>;
}) {
  const { chapterId } = await params;
  const [{ items }, chapters] = await Promise.all([
    getQaDeepByChapter(chapterId),
    getQaDeepChapters(),
  ]);
  if (!items.length) notFound();

  const chapter = chapters.find((c) => c.id === chapterId);
  const chapterTitle = chapter?.title;

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls-reader" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <Link href="/acls-reader/qa-deep" className="hover:text-foreground">
          Q&A เชิงลึก
        </Link>
        {chapterTitle && (
          <>
            {" / "}
            <span className="font-medium text-foreground">{chapterTitle}</span>
          </>
        )}
      </nav>

      {chapterTitle && (
        <header className="mb-8 flex items-start gap-4 rounded-2xl border border-brand/15 bg-gradient-to-br from-brand/10 to-transparent p-6">
          <span className="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-brand/10 text-3xl">
            {chapter?.icon ?? "❓"}
          </span>
          <div className="min-w-0">
            <h1 className="text-2xl font-extrabold leading-tight text-brand-dark sm:text-3xl">
              {chapterTitle}
            </h1>
            <p className="mt-1.5 text-base font-medium text-muted-foreground">
              {items.length} คำถามในหมวดนี้
            </p>
          </div>
        </header>
      )}

      <ol className="space-y-3">
        {items.map((it, i) => (
          <li key={it.id}>
            <Link
              href={`/acls-reader/qa-deep/q/${it.id}`}
              className="group flex items-start gap-4 rounded-2xl border border-border bg-card p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-md hover:shadow-brand/5"
            >
              <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-brand/10 text-sm font-bold text-brand transition-colors group-hover:bg-brand group-hover:text-white">
                {i + 1}
              </span>
              <span className="text-base font-semibold leading-relaxed text-foreground transition-colors group-hover:text-brand sm:text-lg">
                {it.question}
              </span>
            </Link>
          </li>
        ))}
      </ol>
    </div>
  );
}
