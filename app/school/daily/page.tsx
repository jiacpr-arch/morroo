import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Sparkles } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getMixedFlashcards,
  getMixedQuizzes,
} from "@/lib/supabase/queries-school";
import DailyLessonStepper from "@/components/school/DailyLessonStepper";
import { hasSchoolAccess } from "@/lib/membership";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Daily Lesson 5 นาที — School",
  description: "บทเรียน 5 นาทีต่อวัน — Mix flashcard + quiz ของชั้นปีคุณ",
};

export default async function DailyPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/daily");

  const { data: profile } = await supabase
    .from("profiles")
    .select("current_year, school_daily_goal, membership_type, membership_expires_at")
    .eq("id", user.id)
    .maybeSingle();
  if (!profile?.current_year) redirect("/school/onboarding");

  const isPremium = hasSchoolAccess(profile);
  const [cards, quizzes] = await Promise.all([
    getMixedFlashcards({ userId: user.id, year: profile.current_year, limit: 5 }),
    getMixedQuizzes({ userId: user.id, year: profile.current_year, limit: 3 }),
  ]);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-6 flex items-center gap-2">
        <Badge className="bg-violet-100 text-violet-700">Daily Lesson</Badge>
        <Badge variant="outline">ปี {profile.current_year}</Badge>
        <Badge variant="outline">~5 นาที</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Sparkles className="h-6 w-6 text-violet-600" /> บทเรียนประจำวัน
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        Mix flashcard + quiz — ใช้ Spaced Repetition + Interleaving
      </p>

      {cards.length + quizzes.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีเนื้อหาสำหรับชั้นปีของคุณ — ลองเปลี่ยนชั้นปีที่ Onboarding
        </div>
      ) : (
        <DailyLessonStepper
          cards={cards}
          quizzes={quizzes}
          isPremium={isPremium}
        />
      )}
    </div>
  );
}
