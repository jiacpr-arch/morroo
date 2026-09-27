import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Lock, Unlock, CheckCircle2 } from "lucide-react";
import PageIntro from "@/components/PageIntro";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolTopicsByYear,
  getSchoolMasteryByTopic,
  getSchoolStreak,
} from "@/lib/supabase/queries-school";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

const MASTERY_THRESHOLD = 80;

export const metadata = {
  title: "Mastery Progress — School",
  description: "ความเข้าใจรายหัวข้อ + threshold ปลดล็อก",
};

export default async function ProgressPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/progress");

  const { data: profile } = await supabase
    .from("profiles")
    .select("current_year")
    .eq("id", user.id)
    .maybeSingle();
  if (!profile?.current_year) redirect("/school/onboarding");

  const [topics, mastery, streak] = await Promise.all([
    getSchoolTopicsByYear(profile.current_year),
    getSchoolMasteryByTopic(user.id),
    getSchoolStreak(user.id),
  ]);

  // Sort topics by sort_order; mastery threshold gates next topic
  const sorted = [...topics].sort((a, b) => a.sort_order - b.sort_order);
  const items: Array<{
    topic: (typeof sorted)[number];
    mastery: { seen: number; correct: number; pct: number };
    mastered: boolean;
    unlocked: boolean;
  }> = [];
  for (let i = 0; i < sorted.length; i++) {
    const t = sorted[i];
    const m = mastery[t.id] ?? { seen: 0, correct: 0, pct: 0 };
    const mastered = m.seen >= 5 && m.pct >= MASTERY_THRESHOLD;
    const unlocked = i === 0 || items[i - 1].mastered;
    items.push({ topic: t, mastery: m, mastered, unlocked });
  }

  const overallPct = items.length
    ? Math.round(
        items.reduce((sum, x) => sum + x.mastery.pct, 0) / items.length
      )
    : 0;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school" className="mb-5 inline-flex min-h-10 items-center gap-2 rounded-md text-sm text-ink-soft hover:text-brand focus-visible:outline-2 focus-visible:outline-brand">
        <ArrowLeft className="h-4 w-4" /> กลับไป School
      </Link>
      <PageIntro
        eyebrow="School · ความคืบหน้า"
        title="ความเข้าใจรายหัวข้อ"
        description={`ฝึกอย่างน้อย 5 ข้อและตอบถูก ${MASTERY_THRESHOLD}% เพื่อปลดล็อกหัวข้อถัดไป`}
        className="mb-6"
      >
        <Badge className="bg-white text-brand-dark">ปี {profile.current_year}</Badge>
        <Badge variant="outline" className="bg-white">เฉลี่ย {overallPct}%</Badge>
        <Badge variant="outline" className="bg-white">เรียนต่อเนื่อง {streak.current_streak} วัน</Badge>
      </PageIntro>

      {items.length === 0 ? (
        <div className="rounded-2xl border border-surface-border bg-surface-warm p-8 text-center text-ink-soft">
          ยังไม่มีหัวข้อในชั้นปีนี้
        </div>
      ) : (
        <div className="space-y-3">
          {items.map(({ topic, mastery: m, mastered, unlocked }) => (
            <Card
              key={topic.id}
              className={!unlocked ? "border-dashed bg-surface-warm/50" : "shadow-sm"}
            >
              <CardContent className="p-4">
                <div className="flex items-center gap-3">
                  {mastered ? (
                    <CheckCircle2 className="h-5 w-5 text-emerald-600 shrink-0" />
                  ) : unlocked ? (
                    <Unlock className="h-5 w-5 text-muted-foreground shrink-0" />
                  ) : (
                    <Lock className="h-5 w-5 text-muted-foreground shrink-0" />
                  )}
                  <div className="flex-1 min-w-0">
                    <p className="font-semibold text-brand-dark">{topic.name_th}</p>
                    <p className="text-xs text-muted-foreground">{topic.name_en}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold">{m.pct}%</p>
                    <p className="text-xs text-muted-foreground">
                      {m.correct}/{m.seen} ข้อ
                    </p>
                  </div>
                </div>
                {/* progress bar */}
                <div className="h-1.5 bg-muted rounded-full overflow-hidden mt-3">
                  <div
                    className={`h-full transition-all ${
                      mastered
                        ? "bg-emerald-500"
                        : m.pct >= 50
                          ? "bg-amber-500"
                          : "bg-rose-400"
                    }`}
                    style={{ width: `${m.pct}%` }}
                  />
                </div>
                {unlocked && (
                  <div className="flex gap-2 mt-3">
                    <Link
                      href={`/school/flashcards?topic=${topic.id}`}
                      className="inline-flex min-h-10 flex-1 items-center justify-center rounded-xl border border-surface-border bg-white px-3 text-sm font-medium text-brand-dark hover:border-brand focus-visible:outline-2 focus-visible:outline-brand"
                    >
                      Flashcards
                    </Link>
                    <Link href={`/school/quiz?topic=${topic.id}`} className="inline-flex min-h-10 flex-1 items-center justify-center rounded-xl border border-surface-border bg-white px-3 text-sm font-medium text-brand-dark hover:border-brand focus-visible:outline-2 focus-visible:outline-brand">
                      Quiz
                    </Link>
                  </div>
                )}
                {!unlocked && (
                  <p className="text-xs text-muted-foreground mt-2 italic">
                    ปลดล็อกเมื่อหัวข้อก่อนหน้าได้ {MASTERY_THRESHOLD}%+
                  </p>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
