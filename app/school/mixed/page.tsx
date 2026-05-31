import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Shuffle } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { getMixedFlashcards } from "@/lib/supabase/queries-school";
import FlashcardSwiper from "@/components/school/FlashcardSwiper";
import { hasSchoolAccess } from "@/lib/membership";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Interleaved Mix — School",
  description: "ฝึกแบบสลับ topic ภายในรอบเดียว เพิ่ม retention",
};

export default async function MixedPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/mixed");

  const { data: profile } = await supabase
    .from("profiles")
    .select("current_year, weak_subjects, membership_type, membership_expires_at")
    .eq("id", user.id)
    .maybeSingle();
  if (!profile?.current_year) redirect("/school/onboarding");
  const isPremium = hasSchoolAccess(profile);

  const cards = await getMixedFlashcards({
    userId: user.id,
    year: profile.current_year,
    weakSystemIds: profile.weak_subjects ?? [],
    limit: 30,
  });

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-6 flex items-center gap-2">
        <Badge className="bg-fuchsia-100 text-fuchsia-700">Interleaving</Badge>
        <Badge variant="outline">ปี {profile.current_year}</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Shuffle className="h-6 w-6 text-fuchsia-600" /> Mixed Practice
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ผสม topic หลายอันในรอบเดียว — งานวิจัยพบว่าเรียนแบบสลับ retention ระยะยาวดีกว่าทำทีละ topic
      </p>
      {cards.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีการ์ดในชั้นปีนี้
        </div>
      ) : (
        <FlashcardSwiper cards={cards} isPremium={isPremium} freeLimit={15} />
      )}
    </div>
  );
}
