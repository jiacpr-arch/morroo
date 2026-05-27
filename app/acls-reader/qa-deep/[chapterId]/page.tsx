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

  const chapterTitle = chapters.find((c) => c.id === chapterId)?.title;

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
            <span className="text-foreground">{chapterTitle}</span>
          </>
        )}
      </nav>

      {chapterTitle && (
        <h1 className="mb-6 text-2xl font-bold sm:text-3xl">{chapterTitle}</h1>
      )}

      <ol className="space-y-3">
        {items.map((it, i) => (
          <li key={it.id}>
            <Link
              href={`/acls-reader/qa-deep/q/${it.id}`}
              className="group flex items-start gap-3 rounded-xl border border-border p-4 transition-colors hover:border-brand/40 hover:bg-muted/40"
            >
              <span className="mt-0.5 flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-muted text-sm font-semibold text-muted-foreground">
                {i + 1}
              </span>
              <span className="font-medium group-hover:text-brand">
                {it.question}
              </span>
            </Link>
          </li>
        ))}
      </ol>
    </div>
  );
}
