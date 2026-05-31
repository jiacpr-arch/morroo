import OnboardingForm from "@/components/school/OnboardingForm";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { getSchoolSystems } from "@/lib/supabase/queries-school";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "เริ่มต้นใช้งาน School Mode",
  description: "เลือกชั้นปี ตั้งเป้าหมายรายวัน และระบบที่ไม่ถนัด",
};

export default async function OnboardingPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/onboarding");

  const [{ data: profile }, systems] = await Promise.all([
    supabase
      .from("profiles")
      .select("current_year, school_daily_goal, exam_date, weak_subjects")
      .eq("id", user.id)
      .maybeSingle(),
    getSchoolSystems(),
  ]);

  return (
    <div className="mx-auto max-w-xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <h1 className="text-2xl font-bold mb-2">เริ่มต้นใช้งาน</h1>
      <p className="text-sm text-muted-foreground mb-6">
        ตั้งค่าครั้งเดียว — ระบบจะปรับ Daily Lesson + Mixed ให้เหมาะกับคุณ
      </p>
      <OnboardingForm
        initialYear={profile?.current_year ?? null}
        initialGoal={profile?.school_daily_goal ?? 20}
        initialExamDate={profile?.exam_date ?? null}
        initialWeakSubjects={profile?.weak_subjects ?? []}
        systems={systems.map((s) => ({
          id: s.id,
          name_th: s.name_th,
          icon: s.icon,
        }))}
      />
    </div>
  );
}
