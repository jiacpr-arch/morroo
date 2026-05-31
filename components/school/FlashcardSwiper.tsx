"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { RotateCw, Trophy, ArrowLeft, ArrowRight } from "lucide-react";
import Link from "next/link";
import type { SchoolFlashcard } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";

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

  const effectiveCards = isPremium ? cards : cards.slice(0, freeLimit);
  const card = effectiveCards[index];
  const done = !card;

  async function rate(outcome: "again" | "good" | "easy") {
    if (!card) return;
    setSeen((s) => s + 1);
    if (outcome !== "again") setKnew((k) => k + 1);

    // Fire-and-forget progress write. Anonymous users skip.
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "flashcard",
          unit_id: card.id,
          outcome,
        });
      }
    } catch {
      // Non-blocking
    }

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
            <span className="ml-auto text-xs text-muted-foreground">
              แตะการ์ดเพื่อเปิดเฉลย
            </span>
          </div>

          <div className="flex-1 flex items-center justify-center text-center min-h-[180px]">
            {!flipped ? (
              <p className="text-lg sm:text-xl font-medium whitespace-pre-wrap">
                {card.front}
              </p>
            ) : (
              <div className="space-y-3">
                <p className="text-base sm:text-lg whitespace-pre-wrap">
                  {card.back}
                </p>
                {card.source && (
                  <p className="text-xs text-muted-foreground italic">
                    ที่มา: {card.source}
                  </p>
                )}
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
        <div className="grid grid-cols-3 gap-2">
          <Button
            onClick={() => rate("again")}
            variant="outline"
            className="border-rose-200 text-rose-700 hover:bg-rose-50"
          >
            ลืม
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
            ง่ายมาก
          </Button>
        </div>
      )}
    </div>
  );
}
