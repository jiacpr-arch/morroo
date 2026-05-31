import OnboardingForm from "@/components/school/OnboardingForm";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "เริ่มต้นใช้งาน School Mode",
  description: "เลือกชั้นปีและตั้งเป้าหมายรายวัน",
};

export default async function OnboardingPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/onboarding");

  const { data: profile } = await supabase
    .from("profiles")
    .select("current_year, school_daily_goal")
    .eq("id", user.id)
    .maybeSingle();

  return (
    <div className="mx-auto max-w-xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <h1 className="text-2xl font-bold mb-2">เริ่มต้นใช้งาน</h1>
      <p className="text-sm text-muted-foreground mb-6">
        เลือกชั้นปีเพื่อให้เรากรองเนื้อหาตรงกับคุณ + ตั้งเป้าหมายรายวันเพื่อสร้าง streak
      </p>
      <OnboardingForm
        initialYear={profile?.current_year ?? null}
        initialGoal={profile?.school_daily_goal ?? 20}
      />
    </div>
  );
}
