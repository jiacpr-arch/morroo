"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { RotateCw, Trophy, ArrowLeft, ArrowRight, Sparkles, HelpCircle, EyeOff } from "lucide-react";
import Link from "next/link";
import type { SchoolFlashcard } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { nextSrsState } from "@/lib/school/srs";
import { applyStreak } from "@/lib/school/streak";
import SelfExplainModal from "./SelfExplainModal";
import ElaborateModal from "./ElaborateModal";
import RelatedConcepts from "./RelatedConcepts";
import BookmarkButton from "./BookmarkButton";
import NoteEditor from "./NoteEditor";
import AudioPlayer from "./AudioPlayer";
import { XP, awardXp, awardBadge, detectBadges } from "@/lib/school/xp";

interface Props {
  cards: SchoolFlashcard[];
  isPremium?: boolean;
  freeLimit?: number;
}

const LAYER_BADGE: Record<string, string> = {
  anatomy: "bg-rose-100 text-rose-700",
  physio: "bg-sky-100 text-sky-700",
  biochem: "bg-amber-100 text-amber-700",
  path: "bg-purple-100 text-purple-700",
  pharm: "bg-emerald-100 text-emerald-700",
  clinical: "bg-orange-100 text-orange-700",
  foundation: "bg-slate-100 text-slate-700",
};

export default function FlashcardSwiper({
  cards,
  isPremium = false,
  freeLimit = 10,
}: Props) {
  const [index, setIndex] = useState(0);
  const [flipped, setFlipped] = useState(false);
  const [seen, setSeen] = useState(0);
  const [knew, setKnew] = useState(0);
  const [explainOpen, setExplainOpen] = useState(false);
  const [elaborateOpen, setElaborateOpen] = useState(false);
  const [clozeMode, setClozeMode] = useState(false);

  const effectiveCards = isPremium ? cards : cards.slice(0, freeLimit);
  const card = effectiveCards[index];
  const done = !card;

  async function rate(outcome: "again" | "hard" | "good" | "easy") {
    if (!card) return;
    setSeen((s) => s + 1);
    if (outcome !== "again") setKnew((k) => k + 1);

    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        // 1. Compute next SRS state from existing progress
        const { data: prev } = await supabase
          .from("school_progress")
          .select("ease_factor, interval_days")
          .eq("user_id", user.id)
          .eq("unit_type", "flashcard")
          .eq("unit_id", card.id)
          .order("reviewed_at", { ascending: false })
          .limit(1)
          .maybeSingle();
        const next = nextSrsState(prev, outcome);
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "flashcard",
          unit_id: card.id,
          outcome,
          ease_factor: next.ease_factor,
          interval_days: next.interval_days,
          due_at: next.due_at.toISOString(),
        });

        // 2. Update streak
        const { data: streak } = await supabase
          .from("school_streaks")
          .select("*")
          .eq("user_id", user.id)
          .maybeSingle();
        const nextStreak = applyStreak(
          streak ?? { current_streak: 0, longest_streak: 0, last_active_date: null }
        );
        await supabase.from("school_streaks").upsert({
          user_id: user.id,
          ...nextStreak,
        });
      }
    } catch {
      // Non-blocking
    }

    // XP + badges
    const xpAmount =
      outcome === "again"
        ? XP.flashcardAgain
        : outcome === "hard"
          ? XP.flashcardHard
          : outcome === "good"
            ? XP.flashcardGood
            : XP.flashcardEasy;
    await awardXp(xpAmount, `flashcard:${outcome}`);
    if (seen === 0) await awardBadge("first_card");
    if ((seen + 1) % 25 === 0) await detectBadges();

    setFlipped(false);
    setIndex((i) => i + 1);
  }

  if (done) {
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <Trophy className="h-12 w-12 text-amber-500 mx-auto" />
          <h2 className="text-2xl font-bold">จบรอบนี้แล้ว!</h2>
          <p className="text-muted-foreground">
            ทบทวนไป {seen} ใบ จำได้ {knew} ใบ ({seen ? Math.round((knew / seen) * 100) : 0}%)
          </p>
          {!isPremium && cards.length > freeLimit && (
            <div className="border rounded-lg p-4 bg-amber-50 text-amber-900 text-sm">
              ยังเหลืออีก {cards.length - freeLimit} ใบ — สมัคร Premium เพื่อทบทวนแบบไม่จำกัด
            </div>
          )}
          <div className="flex gap-3 justify-center">
            <Button
              onClick={() => {
                setIndex(0);
                setSeen(0);
                setKnew(0);
                setFlipped(false);
              }}
              variant="outline"
              className="gap-2"
            >
              <RotateCw className="h-4 w-4" /> ทบทวนอีกรอบ
            </Button>
            <Link href="/school">
              <Button className="gap-2">
                <ArrowLeft className="h-4 w-4" /> กลับหน้าหลัก
              </Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between text-sm text-muted-foreground">
        <span>
          ใบที่ {index + 1} / {effectiveCards.length}
        </span>
        <span>
          จำได้ {knew} / {seen}
        </span>
      </div>

      <Card
        className="min-h-[280px] cursor-pointer select-none transition-shadow hover:shadow-md"
        onClick={() => setFlipped((f) => !f)}
      >
        <CardContent className="p-6 sm:p-8 flex flex-col gap-4">
          <div className="flex items-center gap-2">
            <Badge className={LAYER_BADGE[card.layer] ?? "bg-slate-100 text-slate-700"}>
              {card.layer}
            </Badge>
            <Badge variant="outline" className="text-xs">
              {card.difficulty}
            </Badge>
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                setClozeMode((m) => !m);
              }}
              className={`ml-auto text-xs flex items-center gap-1 px-2 py-1 rounded transition-colors ${
                clozeMode
                  ? "bg-indigo-100 text-indigo-700"
                  : "text-muted-foreground hover:bg-muted"
              }`}
              title="Cloze — ปิดคำตอบบางส่วน บังคับเดา"
            >
              <EyeOff className="h-3 w-3" /> Cloze
            </button>
            <AudioPlayer text={flipped ? card.back : card.front} />
            <BookmarkButton unitType="flashcard" unitId={card.id} />
          </div>

          <div className="flex-1 flex flex-col items-center justify-center text-center min-h-[180px]">
            {card.image_url && (
              <img
                src={card.image_url}
                alt=""
                className="max-h-40 mb-3 rounded"
                aria-hidden
              />
            )}
            {!flipped ? (
              <p className="text-lg sm:text-xl font-medium whitespace-pre-wrap">
                {card.front}
              </p>
            ) : (
              <div className="space-y-3">
                <p className="text-base sm:text-lg whitespace-pre-wrap">
                  {clozeMode ? maskCloze(card.back) : card.back}
                </p>
                {card.source && (
                  <p className="text-xs text-muted-foreground italic">
                    ที่มา: {card.source}
                  </p>
                )}
                <RelatedConcepts unitType="flashcard" unitId={card.id} />
                <NoteEditor unitType="flashcard" unitId={card.id} />
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {!flipped ? (
        <Button onClick={() => setFlipped(true)} className="w-full gap-2">
          เปิดเฉลย <ArrowRight className="h-4 w-4" />
        </Button>
      ) : (
        <div className="space-y-2">
          <div className="grid grid-cols-4 gap-2">
            <Button
              onClick={() => rate("again")}
              variant="outline"
              className="border-rose-200 text-rose-700 hover:bg-rose-50"
            >
              ลืม
            </Button>
            <Button
              onClick={() => rate("hard")}
              variant="outline"
              className="border-amber-200 text-amber-700 hover:bg-amber-50"
            >
              ยาก
            </Button>
            <Button
              onClick={() => rate("good")}
              variant="outline"
              className="border-sky-200 text-sky-700 hover:bg-sky-50"
            >
              จำได้
            </Button>
            <Button
              onClick={() => rate("easy")}
              variant="outline"
              className="border-emerald-200 text-emerald-700 hover:bg-emerald-50"
            >
              ง่าย
            </Button>
          </div>
          <div className="grid grid-cols-2 gap-2">
            <Button
              onClick={() => setExplainOpen(true)}
              variant="ghost"
              size="sm"
              className="text-violet-700 hover:bg-violet-50 gap-2"
            >
              <Sparkles className="h-4 w-4" /> Feynman
            </Button>
            <Button
              onClick={() => setElaborateOpen(true)}
              variant="ghost"
              size="sm"
              className="text-amber-700 hover:bg-amber-50 gap-2"
            >
              <HelpCircle className="h-4 w-4" /> ทำไม / อย่างไร
            </Button>
          </div>
        </div>
      )}

      {explainOpen && (
        <SelfExplainModal
          concept={`${card.front}\n\nคำตอบที่ถูก: ${card.back}`}
          onClose={() => setExplainOpen(false)}
        />
      )}
      {elaborateOpen && (
        <ElaborateModal
          concept={`${card.front} → ${card.back}`}
          onClose={() => setElaborateOpen(false)}
        />
      )}
    </div>
  );
}

/**
 * Cloze deletion — masks roughly every 3rd content word with [...].
 * Forces the learner to generate (generation effect, Slamecka & Graf 1978).
 */
function maskCloze(text: string): string {
  const words = text.split(/(\s+)/);
  let nth = 0;
  return words
    .map((w) => {
      if (/^\s+$/.test(w) || w.length < 4) return w;
      nth += 1;
      return nth % 3 === 0 ? "▢▢▢" : w;
    })
    .join("");
}
