import Link from "next/link";
import { redirect } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Settings } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { getSchoolSystems } from "@/lib/supabase/queries-school";
import OnboardingForm from "@/components/school/OnboardingForm";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Settings — School",
  description: "ตั้งค่าชั้นปี เป้าหมาย วันสอบ ระบบที่ไม่ถนัด",
};

export default async function SettingsPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/settings");

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
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-slate-100 text-slate-700">Settings</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Settings className="h-6 w-6" /> ตั้งค่า
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        เปลี่ยนชั้นปี / เป้าหมาย / วันสอบ / ระบบที่ไม่ถนัด ได้ตลอด
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
