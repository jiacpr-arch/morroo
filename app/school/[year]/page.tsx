import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, BookOpen, Layers } from "lucide-react";
import {
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
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

  const [topics, counts] = await Promise.all([
    getSchoolTopicsByYear(yearNum),
    getSchoolTopicCounts(),
  ]);

  // Group topics by system
  const bySystem: Record<string, typeof topics> = {};
  for (const t of topics) {
    const key = t.school_systems?.slug ?? "other";
    if (!bySystem[key]) bySystem[key] = [];
    bySystem[key].push(t);
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
          {Object.entries(bySystem).map(([slug, list]) => {
            const sys = list[0].school_systems;
            return (
              <div key={slug}>
                <div className="flex items-center gap-2 mb-3">
                  <span className="text-2xl">{sys?.icon}</span>
                  <h2 className="text-xl font-bold">{sys?.name_th}</h2>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  {list.map((t) => {
                    const fc = counts.flashcards[t.id] ?? 0;
                    const qz = counts.quizzes[t.id] ?? 0;
                    return (
                      <Card key={t.id} className="h-full">
                        <CardContent className="p-5 space-y-3">
                          <div>
                            <h3 className="font-semibold">{t.name_th}</h3>
                            <p className="text-xs text-muted-foreground mt-1">
                              {t.name_en}
                            </p>
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
                          <Link href={`/school/topic/${t.id}`}>
                            <Button
                              size="sm"
                              className="w-full bg-brand hover:bg-brand-light text-white"
                              disabled={fc === 0 && qz === 0}
                            >
                              เปิด Topic
                            </Button>
                          </Link>
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
