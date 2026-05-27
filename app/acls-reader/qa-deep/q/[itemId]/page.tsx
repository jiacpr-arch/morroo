import { notFound } from "next/navigation";
import Link from "next/link";
import { getQaDeep, getQaDeepChapters } from "@/lib/acls-reader/qa-deep";
import Markdown from "@/components/acls-reader/Markdown";
import Figure from "@/components/acls-reader/Figure";

export const revalidate = 600;
export const dynamicParams = true;

export async function generateStaticParams() {
  try {
    const data = await getQaDeep();
    return data.items.map((it) => ({ itemId: it.id }));
  } catch {
    return [];
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ itemId: string }>;
}) {
  const { itemId } = await params;
  const data = await getQaDeep();
  const item = data.items.find((i) => i.id === itemId);
  return { title: item?.question ?? "Q&A เชิงลึก" };
}

export default async function QaDeepItemPage({
  params,
}: {
  params: Promise<{ itemId: string }>;
}) {
  const { itemId } = await params;
  const [data, chapters] = await Promise.all([getQaDeep(), getQaDeepChapters()]);

  const item = data.items.find((i) => i.id === itemId);
  if (!item) notFound();

  // Prev / next within the same chapter (or within the ungrouped set).
  const group = data.items.filter((i) => i.chapterId === item.chapterId);
  const index = group.findIndex((i) => i.id === itemId);
  const prev = index > 0 ? group[index - 1] : null;
  const next = index < group.length - 1 ? group[index + 1] : null;

  const chapter = item.chapterId
    ? chapters.find((c) => c.id === item.chapterId)
    : null;
  const backHref = chapter
    ? `/acls-reader/qa-deep/${chapter.id}`
    : "/acls-reader/qa-deep";

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
        {chapter && (
          <>
            {" / "}
            <Link
              href={`/acls-reader/qa-deep/${chapter.id}`}
              className="hover:text-foreground"
            >
              {chapter.title}
            </Link>
          </>
        )}
      </nav>

      <article>
        <h1 className="mb-6 text-2xl font-bold leading-snug sm:text-3xl">
          {item.question}
        </h1>
        {item.cover && (
          <Figure
            src={item.cover.src}
            alt={item.cover.alt}
            caption={item.cover.caption}
          />
        )}
        <Markdown>{item.answer}</Markdown>
        {item.infographics.map((img, i) => (
          <Figure key={i} src={img.src} alt={img.alt} caption={img.caption} />
        ))}
      </article>

      {/* Prev / next question navigation */}
      <nav className="mt-14 grid grid-cols-1 gap-3 border-t border-border pt-6 sm:grid-cols-2">
        {prev ? (
          <Link
            href={`/acls-reader/qa-deep/q/${prev.id}`}
            className="group rounded-xl border border-border p-4 transition-colors hover:border-brand/40 hover:bg-muted/40"
          >
            <span className="text-xs text-muted-foreground">
              ← คำถามก่อนหน้า
            </span>
            <div className="mt-1 font-medium group-hover:text-brand">
              {prev.question}
            </div>
          </Link>
        ) : (
          <span />
        )}
        {next ? (
          <Link
            href={`/acls-reader/qa-deep/q/${next.id}`}
            className="group rounded-xl border border-border p-4 text-right transition-colors hover:border-brand/40 hover:bg-muted/40 sm:col-start-2"
          >
            <span className="text-xs text-muted-foreground">
              คำถามถัดไป →
            </span>
            <div className="mt-1 font-medium group-hover:text-brand">
              {next.question}
            </div>
          </Link>
        ) : (
          <span />
        )}
      </nav>

      <div className="mt-6 text-center">
        <Link
          href={backHref}
          className="text-sm font-medium text-brand hover:underline"
        >
          ← กลับไปรายการคำถาม
        </Link>
      </div>
    </div>
  );
}
