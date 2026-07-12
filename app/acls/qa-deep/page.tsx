import Link from "next/link";
import { getQaDeep, getQaDeepChapters } from "@/lib/acls-reader/qa-deep";

export const revalidate = 600;

export default async function QaDeepIndex() {
  const [data, chapters] = await Promise.all([getQaDeep(), getQaDeepChapters()]);

  const countByChapter = new Map<string, number>();
  for (const it of data.items) {
    if (it.chapterId) {
      countByChapter.set(it.chapterId, (countByChapter.get(it.chapterId) ?? 0) + 1);
    }
  }
  const groupedChapters = chapters.filter((c) => countByChapter.has(c.id));
  const ungrouped = data.items.filter((it) => !it.chapterId);
  const totalQuestions = data.items.length;

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      {/* Hero header */}
      <header className="mb-12 overflow-hidden rounded-3xl border border-brand/15 bg-gradient-to-br from-brand/10 via-brand-light/5 to-transparent px-6 py-10 text-center sm:px-10 sm:py-12">
        <span className="inline-flex items-center gap-2 rounded-full bg-brand/10 px-4 py-1.5 text-sm font-semibold text-brand">
          Q&amp;A เชิงลึก
        </span>
        <h1 className="mt-5 text-3xl font-extrabold tracking-tight text-brand-dark sm:text-4xl lg:text-5xl">
          {data.page.title}
        </h1>
        {data.page.intro && (
          <p className="mx-auto mt-4 max-w-2xl text-lg leading-relaxed text-foreground/70 sm:text-xl">
            {data.page.intro}
          </p>
        )}
        {totalQuestions > 0 && (
          <p className="mt-5 text-base font-medium text-muted-foreground">
            รวม <span className="font-bold text-brand">{totalQuestions}</span> คำถามที่คัดสรรมาเพื่อทบทวน
          </p>
        )}
      </header>

      {groupedChapters.length > 0 && (
        <section>
          <h2 className="mb-5 flex items-center gap-3 text-xl font-bold text-brand-dark sm:text-2xl">
            <span className="h-7 w-1.5 rounded-full bg-brand" />
            เลือกหมวดหมู่
          </h2>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            {groupedChapters.map((c) => (
              <Link key={c.id} href={`/acls/qa-deep/${c.id}`} className="group block">
                <div className="flex h-full items-start gap-4 rounded-2xl border border-border bg-card p-5 shadow-sm transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-lg hover:shadow-brand/5">
                  <span className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-brand/10 text-2xl transition-colors group-hover:bg-brand/15">
                    {c.icon ?? "❓"}
                  </span>
                  <div className="min-w-0 flex-1">
                    <h3 className="text-base font-bold leading-snug text-foreground transition-colors group-hover:text-brand sm:text-lg">
                      {c.title}
                    </h3>
                    <p className="mt-1.5 text-sm font-medium text-muted-foreground">
                      {countByChapter.get(c.id)} คำถาม
                    </p>
                  </div>
                </div>
              </Link>
            ))}
          </div>
        </section>
      )}

      {ungrouped.length > 0 && (
        <section className="mt-12">
          {groupedChapters.length > 0 && (
            <h2 className="mb-5 flex items-center gap-3 text-xl font-bold text-brand-dark sm:text-2xl">
              <span className="h-7 w-1.5 rounded-full bg-brand" />
              คำถามทั่วไป
            </h2>
          )}
          <ol className="space-y-3">
            {ungrouped.map((it, i) => (
              <li key={it.id}>
                <Link
                  href={`/acls/qa-deep/q/${it.id}`}
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
        </section>
      )}
    </div>
  );
}
