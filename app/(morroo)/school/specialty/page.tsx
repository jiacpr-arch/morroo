import Link from "next/link";
import { redirect } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Compass, Target, Sparkles } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolSystems,
  getSystemCompetency,
} from "@/lib/supabase/queries-school";
import {
  computeSpecialtyMatch,
  focusSystemsFor,
  getSpecialty,
} from "@/lib/school/specialty";
import { SpecialtyRadar, type RadarDatum } from "@/components/school/SpecialtyRadar";
import SpecialtyExplorer from "@/components/school/SpecialtyExplorer";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "สายเฉพาะทาง — เลือกอาชีพในฝัน | School",
  description:
    "ดูค่าพลังรายระบบแบบ radar chart แล้วค้นว่าคุณเหมาะกับเฉพาะทางแพทย์สายไหน ควรเน้นวิชาอะไร",
};

export default async function SpecialtyPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/specialty");

  const [systems, competency, { data: profile }] = await Promise.all([
    getSchoolSystems(),
    getSystemCompetency(user.id),
    supabase
      .from("profiles")
      .select("target_specialty, specialty_interests")
      .eq("id", user.id)
      .maybeSingle(),
  ]);

  const interests =
    (profile?.specialty_interests as Record<string, number> | null) ?? null;
  const targetId = (profile?.target_specialty as string | null) ?? null;
  const target = getSpecialty(targetId);

  const matches = computeSpecialtyMatch(competency, interests);
  const topMatch = matches[0];
  const focusSlugs = target ? focusSystemsFor(target.id, competency) : [];
  const systemBySlug = new Map(systems.map((s) => [s.slug, s]));

  // Radar: icon labels + power vs target profile.
  const radarData: RadarDatum[] = systems.map((s) => ({
    label: s.icon,
    power: competency[s.slug] ?? 0,
    target: target
      ? Math.round(
          ((target.weights as Record<string, number | undefined>)[s.slug] ?? 0) * 100
        )
      : undefined,
  }));

  const hasInterests = interests != null;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>

      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-teal-100 text-teal-700">สายเฉพาะทาง</Badge>
        {target && <Badge variant="outline">เป้าหมาย: {target.name_th}</Badge>}
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Compass className="h-6 w-6 text-teal-600" /> เลือกอาชีพในฝัน
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        เก็บค่าพลังความสามารถรายระบบเหมือนเลือกอาชีพในเกม — ค่าพลังคิดจาก
        <b> ผลเรียนจริง</b> ผสมกับ <b>ความสนใจ</b> ที่คุณให้คะแนน
      </p>

      {!hasInterests && (
        <Card className="mb-6 border-teal-200 bg-teal-50/50">
          <CardContent className="p-4 flex items-center gap-3">
            <Sparkles className="h-5 w-5 text-teal-600 shrink-0" />
            <p className="text-sm">
              เริ่มต้นด้วยการให้คะแนนความสนใจด้านล่าง แล้วกดบันทึก —
              ระบบจะแนะนำสายที่เหมาะกับคุณทันที (ค่าพลังจะแม่นขึ้นเรื่อยๆ เมื่อคุณทำ quiz)
            </p>
          </CardContent>
        </Card>
      )}

      {/* Radar + system breakdown */}
      <Card className="mb-6">
        <CardContent className="p-4 sm:p-5">
          <h2 className="font-semibold mb-2">เรดาร์ค่าพลังรายระบบ</h2>
          <SpecialtyRadar data={radarData} targetName={target?.name_th} />
          <div className="mt-4 grid grid-cols-2 sm:grid-cols-3 gap-x-4 gap-y-1 text-xs">
            {systems.map((s) => (
              <div key={s.slug} className="flex items-center justify-between gap-2">
                <span className="truncate">
                  {s.icon} {s.name_th}
                </span>
                <span className="font-semibold tabular-nums">
                  {competency[s.slug] ?? 0}%
                </span>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Ranked specialty matches */}
      <Card className="mb-6">
        <CardContent className="p-4 sm:p-5">
          <h2 className="font-semibold mb-1">สายที่เหมาะกับคุณ</h2>
          {topMatch && (
            <p className="text-sm text-muted-foreground mb-4">
              ตอนนี้คุณเข้าทาง <b className="text-teal-700">{topMatch.specialty.icon} {topMatch.specialty.name_th}</b> มากที่สุด ({topMatch.scorePct}%)
            </p>
          )}
          <div className="space-y-2">
            {matches.map(({ specialty, scorePct }) => {
              const isTarget = specialty.id === targetId;
              return (
                <div
                  key={specialty.id}
                  className={`rounded-lg border p-3 ${
                    isTarget ? "border-teal-400 bg-teal-50/50" : ""
                  }`}
                >
                  <div className="flex items-center gap-2 mb-1.5">
                    <span>{specialty.icon}</span>
                    <span className="font-medium text-sm">{specialty.name_th}</span>
                    {isTarget && (
                      <Badge className="bg-teal-600 text-white text-[10px] px-1.5 py-0">
                        เป้าหมาย
                      </Badge>
                    )}
                    <span className="ml-auto font-bold text-sm tabular-nums">
                      {scorePct}%
                    </span>
                  </div>
                  <div className="h-1.5 bg-muted rounded-full overflow-hidden">
                    <div
                      className="h-full bg-teal-500 transition-all"
                      style={{ width: `${scorePct}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>

      {/* Focus subjects for the target */}
      {target && (
        <Card className="mb-6 border-amber-200 bg-amber-50/40">
          <CardContent className="p-4 sm:p-5">
            <h2 className="font-semibold mb-1 flex items-center gap-2">
              <Target className="h-5 w-5 text-amber-600" />
              ควรเน้นวิชาไหนเพื่อไป {target.name_th}
            </h2>
            {focusSlugs.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                เยี่ยม! ค่าพลังในระบบหลักของสายนี้แข็งแล้ว — รักษาระดับไว้ด้วยการทบทวน
              </p>
            ) : (
              <>
                <p className="text-sm text-muted-foreground mb-3">
                  ระบบที่สายนี้ต้องใช้มากแต่ค่าพลังคุณยังน้อย — เก็บคะแนนเพิ่มที่นี่ก่อน
                </p>
                <div className="flex flex-wrap gap-2 mb-3">
                  {focusSlugs.map((slug) => {
                    const sys = systemBySlug.get(slug);
                    return (
                      <Badge key={slug} variant="outline" className="gap-1">
                        {sys?.icon} {sys?.name_th ?? slug} · {competency[slug] ?? 0}%
                      </Badge>
                    );
                  })}
                </div>
                <Link href="/school/quiz">
                  <Button size="sm" className="gap-2">
                    ไปฝึก Quiz เก็บค่าพลัง
                  </Button>
                </Link>
              </>
            )}
          </CardContent>
        </Card>
      )}

      {/* Questionnaire + target picker */}
      <SpecialtyExplorer
        systems={systems.map((s) => ({
          slug: s.slug,
          name_th: s.name_th,
          icon: s.icon,
        }))}
        initialInterests={interests}
        initialTarget={targetId}
      />
    </div>
  );
}
