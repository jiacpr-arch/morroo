import { notFound } from "next/navigation";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, ArrowRight, GraduationCap, Lock, Timer } from "lucide-react";
import {
  getBoardSpecialty,
  getBoardBlueprint,
  getBoardQuestionStats,
} from "@/lib/supabase/queries-board";
import BoardBlueprintTable from "@/components/BoardBlueprintTable";
import { BOARD_SECTIONS, BOARD_SPECIALTY_SLUGS } from "@/lib/types-board";
import type { Metadata } from "next";

export const revalidate = 300;

export async function generateStaticParams() {
  return BOARD_SPECIALTY_SLUGS.map((specialty) => ({ specialty }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ specialty: string }>;
}): Promise<Metadata> {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return { title: "ไม่พบสาขา" };
  return {
    title: `เตรียมสอบบอร์ด${s.name_th}`,
    description:
      s.description_th ??
      `ฝึกข้อสอบ MCQ สำหรับสอบบอร์ด${s.name_th} ตาม Blueprint ของ${s.royal_college ?? "ราชวิทยาลัยฯ"}`,
    alternates: { canonical: `https://www.morroo.com/board/${specialty}` },
  };
}

export default async function BoardSpecialtyPage({
  params,
}: {
  params: Promise<{ specialty: string }>;
}) {
  const { specialty } = await params;
  const s = await getBoardSpecialty(specialty);
  if (!s) return notFound();

  const [blueprints, stats] = await Promise.all([
    getBoardBlueprint(specialty),
    getBoardQuestionStats(specialty),
  ]);

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/board"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้าสาขาบอร์ด
        </Link>

        <div className="flex items-start gap-4 flex-wrap">
          <span className="text-5xl leading-none">{s.icon}</span>
          <div className="flex-1 min-w-[200px]">
            <div className="flex items-center gap-2 mb-1">
              <Badge className="bg-purple-100 text-purple-700 gap-1">
                <GraduationCap className="h-3 w-3" />
                Board Exam
              </Badge>
              {s.is_published ? (
                <Badge className="bg-emerald-100 text-emerald-700">
                  เปิดแล้ว
                </Badge>
              ) : (
                <Badge variant="secondary">เร็วๆนี้</Badge>
              )}
            </div>
            <h1 className="text-3xl font-bold">{s.name_th}</h1>
            <p className="text-sm text-muted-foreground mt-1">{s.name_en}</p>
            {s.royal_college && (
              <p className="text-sm text-muted-foreground mt-1">
                {s.royal_college}
              </p>
            )}
            {s.description_th && (
              <p className="mt-3 text-muted-foreground">{s.description_th}</p>
            )}
            {s.exam_format && (
              <p className="mt-2 text-sm text-muted-foreground">
                <strong className="text-foreground">รูปแบบการสอบ:</strong>{" "}
                {s.exam_format}
              </p>
            )}
          </div>
        </div>
      </div>

      {!s.is_published && (
        <Card className="mb-6 border-dashed">
          <CardContent className="pt-6 text-center">
            <Lock className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
            <p className="text-muted-foreground">
              สาขานี้กำลังจัดทำเนื้อหา —{" "}
              <Link href="/board" className="text-brand hover:underline">
                ดูสาขาอื่นที่เปิดแล้ว
              </Link>
            </p>
          </CardContent>
        </Card>
      )}

      {s.is_published && (
        <div className="mb-8">
          <h2 className="text-xl font-bold mb-3">เริ่มฝึก</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <Link href={`/board/${specialty}/mock`}>
              <Card className="hover:shadow-md hover:border-purple-300 transition-all h-full border-purple-200 bg-purple-50/30">
                <CardContent className="pt-5">
                  <div className="flex items-center justify-between gap-2">
                    <div className="min-w-0">
                      <div className="flex items-center gap-1.5">
                        <Timer className="h-4 w-4 text-purple-700" />
                        <span className="font-bold">จำลองสอบ (Mock)</span>
                      </div>
                      <div className="text-xs text-muted-foreground mt-0.5">
                        {s.total_mcq_count
                          ? `${s.total_mcq_count} ข้อ × ${Math.round(s.total_mcq_count * 1.2)} นาที ตาม Blueprint`
                          : "ตาม Blueprint จริง"}
                      </div>
                    </div>
                    <ArrowRight className="h-5 w-5 text-purple-700 shrink-0" />
                  </div>
                </CardContent>
              </Card>
            </Link>
            <Link href={`/board/${specialty}/practice`}>
              <Card className="hover:shadow-md hover:border-brand/30 transition-all h-full">
                <CardContent className="pt-5">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="font-bold">ฝึกคละทุกหมวด</div>
                      <div className="text-xs text-muted-foreground mt-0.5">
                        {stats.total > 0
                          ? `${stats.total} ข้อในคลัง`
                          : "ยังไม่มีข้อสอบ"}
                      </div>
                    </div>
                    <ArrowRight className="h-5 w-5 text-brand" />
                  </div>
                </CardContent>
              </Card>
            </Link>
            {BOARD_SECTIONS.map((sec) => {
              const count = stats.bySection[sec.code] ?? 0;
              return (
                <Link
                  key={sec.code}
                  href={`/board/${specialty}/practice?section=${sec.code}`}
                >
                  <Card className="hover:shadow-md hover:border-brand/30 transition-all h-full">
                    <CardContent className="pt-5">
                      <div className="flex items-center justify-between gap-2">
                        <div className="min-w-0">
                          <div className="font-bold truncate">
                            {sec.label_th}
                          </div>
                          <div className="text-xs text-muted-foreground mt-0.5">
                            {count > 0 ? `${count} ข้อ` : "ยังไม่มีข้อสอบ"}
                          </div>
                        </div>
                        <ArrowRight className="h-5 w-5 text-brand shrink-0" />
                      </div>
                    </CardContent>
                  </Card>
                </Link>
              );
            })}
          </div>
        </div>
      )}

      {blueprints.length > 0 && <BoardBlueprintTable blueprints={blueprints} />}

      {s.is_published && blueprints.length === 0 && (
        <div className="text-sm text-muted-foreground">
          ยังไม่มีข้อมูล Blueprint สำหรับสาขานี้
        </div>
      )}
    </div>
  );
}
