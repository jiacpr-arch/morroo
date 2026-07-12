import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, TrendingUp, Lock, Unlock, CheckCircle2 } from "lucide-react";
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
  let prevMastered = true;
  const items = sorted.map((t) => {
    const m = mastery[t.id] ?? { seen: 0, correct: 0, pct: 0 };
    const mastered = m.seen >= 5 && m.pct >= MASTERY_THRESHOLD;
    const unlocked = prevMastered;
    prevMastered = mastered;
    return { topic: t, mastery: m, mastered, unlocked };
  });

  const overallPct = items.length
    ? Math.round(
        items.reduce((sum, x) => sum + x.mastery.pct, 0) / items.length
      )
    : 0;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-indigo-100 text-indigo-700">Mastery</Badge>
        <Badge variant="outline">ปี {profile.current_year}</Badge>
        <Badge variant="outline">เฉลี่ย {overallPct}%</Badge>
        <Badge variant="outline">Streak {streak.current_streak} วัน</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <TrendingUp className="h-6 w-6 text-indigo-600" /> Progress รายหัวข้อ
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ระบบใช้ Mastery Learning (Bloom) — ทำ quiz ≥ 5 ข้อ + ถูก ≥ {MASTERY_THRESHOLD}% เพื่อปลดล็อกหัวข้อถัดไป
      </p>

      {items.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีหัวข้อในชั้นปีนี้
        </div>
      ) : (
        <div className="space-y-2">
          {items.map(({ topic, mastery: m, mastered, unlocked }) => (
            <Card
              key={topic.id}
              className={!unlocked ? "opacity-50 border-dashed" : ""}
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
                    <p className="font-semibold">{topic.name_th}</p>
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
                      className="flex-1"
                    >
                      <Button size="sm" variant="outline" className="w-full">
                        Flashcards
                      </Button>
                    </Link>
                    <Link href={`/school/quiz?topic=${topic.id}`} className="flex-1">
                      <Button size="sm" variant="outline" className="w-full">
                        Quiz
                      </Button>
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
