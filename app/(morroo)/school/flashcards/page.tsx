import { Suspense } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { ArrowLeft } from "lucide-react";
import PageIntro from "@/components/PageIntro";
import FlashcardSwiper from "@/components/school/FlashcardSwiper";
import { getSchoolFlashcards, getSchoolTopicsByYear } from "@/lib/supabase/queries-school";
import { createClient } from "@/lib/supabase/server";
import { hasSchoolAccess, hasScopedAccess } from "@/lib/membership";
import { fetchEntitlements } from "@/lib/entitlements";
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
    const entitlements = await fetchEntitlements(supabase, user.id);
    const scopes = [
      ...(topicId ? [`topic:${topicId}`] : []),
      ...(year ? [`year:${year}`] : []),
    ];
    isPremium =
      hasSchoolAccess(profile, entitlements) ||
      hasScopedAccess("school", scopes, profile, entitlements);
  }

  const [cards, topics] = await Promise.all([
    getSchoolFlashcards({ topicId, year, limit: 50, randomize: true }),
    year ? getSchoolTopicsByYear(year) : Promise.resolve([]),
  ]);

  const activeTopic = topics.find((t) => t.id === topicId);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school" className="mb-5 inline-flex min-h-10 items-center gap-2 rounded-md text-sm text-ink-soft hover:text-brand focus-visible:outline-2 focus-visible:outline-brand">
        <ArrowLeft className="h-4 w-4" /> กลับไป School
      </Link>
      <PageIntro
        eyebrow="School · ทบทวน"
        title={activeTopic?.name_th ?? "ทบทวน Flashcards"}
        description="ทบทวนทีละใบในจังหวะของคุณ แล้วกลับมาฝึกซ้ำได้ทุกเมื่อ"
        className="mb-6"
      >
        <Badge className="bg-white text-brand-dark">Flashcards</Badge>
        {year && <Badge variant="outline" className="bg-white">ปี {year}</Badge>}
      </PageIntro>

      {cards.length === 0 ? (
        <div className="rounded-2xl border border-surface-border bg-surface-warm p-8 text-center text-ink-soft">
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
