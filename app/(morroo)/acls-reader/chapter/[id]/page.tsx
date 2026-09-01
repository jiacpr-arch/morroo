import { notFound } from "next/navigation";
import Link from "next/link";
import { getChapters } from "@/lib/acls-reader/content";
import Markdown from "@/components/acls-reader/Markdown";
import Figure from "@/components/acls-reader/Figure";

export const revalidate = 600;
export const dynamicParams = true;

export async function generateStaticParams() {
  try {
    const chapters = await getChapters();
    return chapters.map((c) => ({ id: c.id }));
  } catch {
    return [];
  }
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const chapters = await getChapters();
  const chapter = chapters.find((c) => c.id === id);
  return { title: chapter?.title ?? "ไม่พบบทเรียน" };
}

export default async function ChapterPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const chapters = await getChapters();
  const index = chapters.findIndex((c) => c.id === id);
  if (index === -1) notFound();

  const chapter = chapters[index];
  const prev = index > 0 ? chapters[index - 1] : null;
  const next = index < chapters.length - 1 ? chapters[index + 1] : null;

  // Table of contents from section headings (only worth showing if 2+).
  const toc = chapter.sections
    .map((s, i) => ({ heading: s.heading, anchor: `s-${i}` }))
    .filter((t) => t.heading);

  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/acls-reader" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">{chapter.title}</span>
      </nav>

      <header className="mb-8 flex items-center gap-3">
        <span className="text-4xl">{chapter.icon ?? "📘"}</span>
        <h1 className="text-3xl font-bold leading-snug sm:text-4xl">
          {chapter.title}
        </h1>
      </header>

      {toc.length >= 2 && (
        <nav className="mb-10 rounded-xl border border-border bg-muted/40 p-4">
          <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            ในบทนี้
          </p>
          <ol className="space-y-1">
            {toc.map((t) => (
              <li key={t.anchor}>
                <a
                  href={`#${t.anchor}`}
                  className="text-sm text-brand hover:underline"
                >
                  {t.heading}
                </a>
              </li>
            ))}
          </ol>
        </nav>
      )}

      <div className="space-y-10">
        {chapter.sections.map((s, i) => (
          <section key={i} id={`s-${i}`} className="scroll-mt-24">
            {s.heading && (
              <h2 className="mb-3 text-2xl font-semibold">{s.heading}</h2>
            )}
            {s.body && <Markdown>{s.body}</Markdown>}
            {s.images?.map((img, j) => (
              <Figure key={j} src={img.src} alt={img.alt} caption={img.caption} />
            ))}
            {s.qa && s.qa.length > 0 && (
              <div className="mt-4 space-y-3">
                {s.qa.map((qa, k) => (
                  <details key={k} className="group rounded-lg border border-border p-4">
                    <summary className="flex cursor-pointer list-none items-center justify-between gap-3 font-medium">
                      {qa.q}
                      <span className="text-muted-foreground transition-transform group-open:rotate-180">
                        ▼
                      </span>
                    </summary>
                    <div className="mt-3">
                      {qa.images?.map((img, m) => (
                        <Figure
                          key={m}
                          src={img.src}
                          alt={img.alt}
                          caption={img.caption}
                        />
                      ))}
                      <Markdown>{qa.a}</Markdown>
                    </div>
                  </details>
                ))}
              </div>
            )}
          </section>
        ))}
      </div>

      {/* Prev / next chapter navigation */}
      <nav className="mt-14 grid grid-cols-1 gap-3 border-t border-border pt-6 sm:grid-cols-2">
        {prev ? (
          <Link
            href={`/acls-reader/chapter/${prev.id}`}
            className="group rounded-xl border border-border p-4 transition-colors hover:border-brand/40 hover:bg-muted/40"
          >
            <span className="text-xs text-muted-foreground">← บทก่อนหน้า</span>
            <div className="mt-1 font-medium group-hover:text-brand">
              {prev.icon ? `${prev.icon} ` : ""}
              {prev.title}
            </div>
          </Link>
        ) : (
          <span />
        )}
        {next ? (
          <Link
            href={`/acls-reader/chapter/${next.id}`}
            className="group rounded-xl border border-border p-4 text-right transition-colors hover:border-brand/40 hover:bg-muted/40 sm:col-start-2"
          >
            <span className="text-xs text-muted-foreground">บทถัดไป →</span>
            <div className="mt-1 font-medium group-hover:text-brand">
              {next.icon ? `${next.icon} ` : ""}
              {next.title}
            </div>
          </Link>
        ) : (
          <span />
        )}
      </nav>

      <div className="mt-6 text-center">
        <Link
          href="/acls-reader"
          className="text-sm font-medium text-brand hover:underline"
        >
          ดูบททั้งหมด
        </Link>
      </div>
    </div>
  );
}
