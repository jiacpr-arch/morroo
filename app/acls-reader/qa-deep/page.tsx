import Link from "next/link";
import { getQaDeep, getQaDeepChapters } from "@/lib/acls-reader/qa-deep";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";

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

  return (
    <div className="mx-auto max-w-4xl px-4 py-12 sm:px-6 lg:px-8">
      <header className="mb-10 text-center">
        <h1 className="text-3xl font-bold sm:text-4xl">{data.page.title}</h1>
        {data.page.intro && (
          <p className="mt-3 text-lg text-muted-foreground">{data.page.intro}</p>
        )}
      </header>

      {groupedChapters.length > 0 && (
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
          {groupedChapters.map((c) => (
            <Link key={c.id} href={`/acls-reader/qa-deep/${c.id}`} className="block">
              <Card className="h-full transition-shadow hover:shadow-md hover:ring-brand/30">
                <CardHeader>
                  <span className="text-2xl">{c.icon ?? "❓"}</span>
                  <CardTitle className="text-base">{c.title}</CardTitle>
                  <CardDescription>
                    {countByChapter.get(c.id)} คำถาม
                  </CardDescription>
                </CardHeader>
              </Card>
            </Link>
          ))}
        </div>
      )}

      {ungrouped.length > 0 && (
        <div className="mt-10">
          {groupedChapters.length > 0 && (
            <h2 className="mb-4 text-lg font-semibold">คำถามทั่วไป</h2>
          )}
          <ol className="space-y-3">
            {ungrouped.map((it, i) => (
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
      )}
    </div>
  );
}
