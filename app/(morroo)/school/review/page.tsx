import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Clock } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import FlashcardSwiper from "@/components/school/FlashcardSwiper";
import type { SchoolFlashcard } from "@/lib/types-school";
import { hasSchoolAccess } from "@/lib/membership";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Review Queue — School",
  description: "ทบทวนการ์ดที่ใกล้ลืม ตาม Spaced Repetition",
};

export default async function ReviewPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/review");

  const { data: profile } = await supabase
    .from("profiles")
    .select("membership_type, membership_expires_at, current_year")
    .eq("id", user.id)
    .maybeSingle();
  const isPremium = hasSchoolAccess(profile);

  // Pull due flashcards
  const { data: due } = await supabase
    .from("school_progress")
    .select("unit_id")
    .eq("user_id", user.id)
    .eq("unit_type", "flashcard")
    .lte("due_at", new Date().toISOString())
    .order("due_at", { ascending: true })
    .limit(50);

  const ids = (due ?? []).map((d: { unit_id: string }) => d.unit_id);
  let cards: SchoolFlashcard[] = [];
  if (ids.length) {
    const { data } = await supabase
      .from("school_flashcards")
      .select("*")
      .in("id", ids)
      .eq("status", "active");
    cards = (data as SchoolFlashcard[]) ?? [];
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-6 flex items-center gap-2">
        <Badge className="bg-rose-100 text-rose-700">Review</Badge>
        <Badge variant="outline">{cards.length} ใบใกล้ลืม</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Clock className="h-6 w-6 text-rose-600" /> ทบทวนตามตารางลืม
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        การ์ดที่ระบบ Spaced Repetition คำนวณว่าใกล้จะลืม — ทบทวนตอนนี้เพื่อ retention สูงสุด
      </p>

      {cards.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground space-y-3">
          <p>ไม่มีการ์ดที่ต้องทบทวนตอนนี้ 🎉</p>
          <p className="text-xs">
            หมายความว่าระบบยังจำไม่จำเป็นต้องเตือน — กลับมาดูพรุ่งนี้ หรือทำ Daily Lesson ใหม่
          </p>
        </div>
      ) : (
        <FlashcardSwiper cards={cards} isPremium={isPremium} freeLimit={20} />
      )}
    </div>
  );
}
