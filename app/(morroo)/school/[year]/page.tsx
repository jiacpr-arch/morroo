import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, BookOpen, BookOpenText, Layers } from "lucide-react";
import {
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
  getSchoolBookMap,
} from "@/lib/supabase/queries-school";

export const revalidate = 60;

interface PageProps {
  params: Promise<{ year: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { year } = await params;
  return {
    title: `ปี ${year} — โหมด School`,
    description: `เนื้อหาเรียนปี ${year} แบบ micro-learning`,
  };
}

export default async function YearPage({ params }: PageProps) {
  const { year } = await params;
  const yearNum = Number(year);
  if (!Number.isInteger(yearNum) || yearNum < 1 || yearNum > 6) notFound();

  const [topics, counts, bookMap] = await Promise.all([
    getSchoolTopicsByYear(yearNum),
    getSchoolTopicCounts(),
    getSchoolBookMap(),
  ]);

  // Prefer grouping by term (ตรงกับโครงหลักสูตร: ปี → เทอม → รายวิชา).
  // Fall back to grouping by system for years whose topics have no term set.
  const hasTerms = topics.some((t) => t.term != null);

  // Leading integer of a "credits" string like "2 (2-0-4)" → 2
  const creditValue = (c: string | null) => {
    const n = parseInt((c ?? "").trim(), 10);
    return Number.isNaN(n) ? 0 : n;
  };

  type Group = { key: string; heading: string; icon?: string; list: typeof topics };
  const groups: Group[] = [];

  if (hasTerms) {
    const byTerm = new Map<number, typeof topics>();
    for (const t of topics) {
      const key = t.term ?? 99; // unassigned terms sort last
      if (!byTerm.has(key)) byTerm.set(key, []);
      byTerm.get(key)!.push(t);
    }
    for (const term of [...byTerm.keys()].sort((a, b) => a - b)) {
      const list = byTerm.get(term)!;
      const credits = list.reduce((sum, t) => sum + creditValue(t.credits), 0);
      groups.push({
        key: `term-${term}`,
        heading:
          term === 99
            ? "รายวิชาอื่น ๆ"
            : `เทอม ${term}${credits ? ` · ${credits} หน่วยกิต` : ""}`,
        list,
      });
    }
  } else {
    const bySystem = new Map<string, typeof topics>();
    for (const t of topics) {
      const key = t.school_systems?.slug ?? "other";
      if (!bySystem.has(key)) bySystem.set(key, []);
      bySystem.get(key)!.push(t);
    }
    for (const [slug, list] of bySystem) {
      groups.push({
        key: slug,
        heading: list[0].school_systems?.name_th ?? "อื่น ๆ",
        icon: list[0].school_systems?.icon,
        list,
      });
    }
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link href="/school">
          <Button variant="ghost" size="sm" className="gap-2 -ml-2">
            <ArrowLeft className="h-4 w-4" /> กลับ
          </Button>
        </Link>
        <div className="mt-2 flex items-center gap-2">
          <Badge className="bg-indigo-100 text-indigo-700">ปี {yearNum}</Badge>
          <Badge variant="secondary">{topics.length} หัวข้อ</Badge>
        </div>
        <h1 className="text-3xl font-bold mt-2">ชั้นปี {yearNum}</h1>
      </div>

      {topics.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          เนื้อหาปีนี้กำลังจัดทำ — เริ่มที่ปี 1 ก่อนได้เลย
        </div>
      ) : (
        <div className="space-y-8">
          {groups.map((g) => {
            return (
              <div key={g.key}>
                <div className="flex items-center gap-2 mb-3">
                  {g.icon && <span className="text-2xl">{g.icon}</span>}
                  <h2 className="text-xl font-bold">{g.heading}</h2>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  {g.list.map((t) => {
                    const fc = counts.flashcards[t.id] ?? 0;
                    const qz = counts.quizzes[t.id] ?? 0;
                    const bookId = bookMap[t.id];
                    const empty = fc === 0 && qz === 0;
                    return (
                      <Card key={t.id} className="h-full">
                        <CardContent className="p-5 space-y-3">
                          <div>
                            <div className="flex items-start justify-between gap-2">
                              <h3 className="font-semibold">
                                {t.school_systems?.icon && !g.icon && (
                                  <span className="mr-1" aria-hidden>
                                    {t.school_systems.icon}
                                  </span>
                                )}
                                {t.name_th}
                              </h3>
                              {empty && (
                                <Badge
                                  variant="secondary"
                                  className="shrink-0 text-[10px]"
                                >
                                  เร็วๆ นี้
                                </Badge>
                              )}
                            </div>
                            <p className="text-xs text-muted-foreground mt-1">
                              {t.name_en}
                            </p>
                            {(t.code || t.credits) && (
                              <div className="mt-1.5 flex flex-wrap items-center gap-1.5">
                                {t.code && (
                                  <span className="rounded bg-muted px-1.5 py-0.5 font-mono text-[10px] text-muted-foreground">
                                    {t.code}
                                  </span>
                                )}
                                {t.credits && (
                                  <span className="text-[10px] text-muted-foreground">
                                    {t.credits} นก.
                                  </span>
                                )}
                              </div>
                            )}
                          </div>
                          {t.summary && (
                            <p className="text-sm text-muted-foreground line-clamp-2">
                              {t.summary}
                            </p>
                          )}
                          <div className="flex gap-2 text-xs text-muted-foreground">
                            <span className="flex items-center gap-1">
                              <Layers className="h-3 w-3" /> {fc} cards
                            </span>
                            <span className="flex items-center gap-1">
                              <BookOpen className="h-3 w-3" /> {qz} ข้อ
                            </span>
                          </div>
                          {bookId && (
                            <Link href={`/school/book/${bookId}`}>
                              <Button
                                size="sm"
                                variant="outline"
                                className="w-full gap-2 border-amber-300 text-amber-700 hover:bg-amber-50"
                              >
                                <BookOpenText className="h-4 w-4" /> อ่านหนังสือฉบับเต็ม
                              </Button>
                            </Link>
                          )}
                          {empty ? (
                            <Button
                              size="sm"
                              variant="outline"
                              className="w-full"
                              disabled
                            >
                              เนื้อหาเร็วๆ นี้
                            </Button>
                          ) : (
                            <Link href={`/school/topic/${t.id}`}>
                              <Button
                                size="sm"
                                className="w-full bg-brand hover:bg-brand-light text-white"
                              >
                                เปิด Topic
                              </Button>
                            </Link>
                          )}
                        </CardContent>
                      </Card>
                    );
                  })}
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
