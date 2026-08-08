import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import {
  getSchoolTopicsByYear,
  getSchoolTopicCounts,
  getSchoolBookMap,
} from "@/lib/supabase/queries-school";
import SubjectRail from "@/components/school/SubjectRail";
import { getSchoolAccess } from "@/lib/school/access-server";
import { canOpenTopic } from "@/lib/school/access";

// การ์ดวิชาบอกสถานะล็อก/ปลดล็อกของผู้ใช้คนนั้น จึง render ต่อ request
export const dynamic = "force-dynamic";

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

  const [topics, counts, bookMap, { access }] = await Promise.all([
    getSchoolTopicsByYear(yearNum),
    getSchoolTopicCounts(),
    getSchoolBookMap(),
    getSchoolAccess(),
  ]);

  const totalCredits = topics.reduce((sum, t) => sum + (t.credits ?? 0), 0);

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
            <ArrowLeft className="h-4 w-4" /> เลือกชั้นปีอื่น
          </Button>
        </Link>
        <div className="mt-2 flex items-center gap-2 flex-wrap">
          <Badge className="bg-indigo-100 text-indigo-700">ปี {yearNum}</Badge>
          <Badge variant="secondary">{topics.length} วิชา</Badge>
          {totalCredits > 0 && (
            <Badge variant="secondary">รวม {totalCredits} หน่วยกิต</Badge>
          )}
        </div>
        <h1 className="text-3xl font-bold mt-2">ชั้นปี {yearNum}</h1>
        <p className="text-sm text-muted-foreground mt-1">
          ปัดดูวิชาทั้งหมดของปีนี้ แล้วแตะวิชาที่อยากเรียน
        </p>
      </div>

      {topics.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          เนื้อหาปีนี้กำลังจัดทำ — เริ่มที่ปี 1 ก่อนได้เลย
        </div>
      ) : (
        <div className="space-y-10">
          {Object.entries(bySystem).map(([slug, list]) => {
            const sys = list[0].school_systems;
            return (
              <div key={slug}>
                <div className="flex items-center gap-2 mb-3">
                  <span className="text-2xl">{sys?.icon}</span>
                  <h2 className="text-xl font-bold">{sys?.name_th}</h2>
                  <Badge variant="secondary" className="ml-1">
                    {list.length} วิชา
                  </Badge>
                </div>
                <SubjectRail
                  subjects={list.map((t) => ({
                    id: t.id,
                    name_th: t.name_th,
                    name_en: t.name_en,
                    code: t.code,
                    credits: t.credits,
                    credit_hours: t.credit_hours,
                    lessons: counts.lessons[t.id] ?? 0,
                    quizzes: counts.quizzes[t.id] ?? 0,
                    bookId: bookMap[t.id],
                    isPreview: t.is_preview,
                    locked: !canOpenTopic(access, t),
                  }))}
                />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
