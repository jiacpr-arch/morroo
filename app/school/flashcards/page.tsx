import { Suspense } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import FlashcardSwiper from "@/components/school/FlashcardSwiper";
import { getSchoolFlashcards, getSchoolTopicsByYear } from "@/lib/supabase/queries-school";
import { createClient } from "@/lib/supabase/server";
import { hasSchoolAccess } from "@/lib/membership";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Flashcards — โหมด School",
  description: "ทบทวนเนื้อหาแพทย์แบบ flashcard",
};

export const dynamic = "force-dynamic";

interface PageProps {
  searchParams: Promise<{ topic?: string; year?: string }>;
}

export default async function FlashcardsPage({ searchParams }: PageProps) {
  const params = await searchParams;
  const year = params.year ? Number(params.year) : undefined;
  const topicId = params.topic;

  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  let isPremium = false;
  if (user) {
    const { data: profile } = await supabase
      .from("profiles")
      .select("membership_type, membership_expires_at")
      .eq("id", user.id)
      .maybeSingle();
    isPremium = hasSchoolAccess(profile);
  }

  const [cards, topics] = await Promise.all([
    getSchoolFlashcards({ topicId, year, limit: 50, randomize: true }),
    year ? getSchoolTopicsByYear(year) : Promise.resolve([]),
  ]);

  const activeTopic = topics.find((t) => t.id === topicId);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <div className="mb-6">
        <Link href="/school">
          <Button variant="ghost" size="sm" className="gap-2 -ml-2">
            <ArrowLeft className="h-4 w-4" /> กลับ
          </Button>
        </Link>
        <div className="mt-2 flex items-center gap-2">
          <Badge className="bg-sky-100 text-sky-700">Flashcards</Badge>
          {activeTopic && <Badge variant="outline">{activeTopic.name_th}</Badge>}
          {year && !activeTopic && <Badge variant="outline">ปี {year}</Badge>}
        </div>
        <h1 className="text-2xl font-bold mt-2">
          {activeTopic?.name_th ?? "ทบทวน Flashcards"}
        </h1>
      </div>

      {cards.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี flashcards สำหรับหัวข้อนี้ — กลับไปเลือกหัวข้ออื่นได้เลย
        </div>
      ) : (
        <Suspense fallback={<div>Loading...</div>}>
          <FlashcardSwiper cards={cards} isPremium={isPremium} freeLimit={10} />
        </Suspense>
      )}
    </div>
  );
}
