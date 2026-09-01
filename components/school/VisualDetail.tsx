"use client";

import { useEffect, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ImageIcon, Maximize2 } from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import type { SchoolVisual, SchoolFlashcard } from "@/lib/types-school";
import FlashcardSwiper from "./FlashcardSwiper";
import QuickCheckList from "./QuickCheckList";
import BookmarkButton from "./BookmarkButton";
import NoteEditor from "./NoteEditor";
import AudioPlayer from "./AudioPlayer";
import { createClient } from "@/lib/supabase/client";
import { XP, awardXp } from "@/lib/school/xp";

interface Props {
  visual: SchoolVisual;
  flashcards: SchoolFlashcard[];
}

export default function VisualDetail({ visual, flashcards }: Props) {
  const [zoomed, setZoomed] = useState(false);

  // Log "read" once on mount
  useEffect(() => {
    let cancelled = false;
    async function markSeen() {
      try {
        const supabase = createClient();
        const { data: { user } } = await supabase.auth.getUser();
        if (!user || cancelled) return;
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "visual",
          unit_id: visual.id,
          outcome: "good",
          ease_factor: 2.5,
          interval_days: 7,
        });
        await awardXp(XP.lessonRead, `visual:${visual.id}`);
      } catch {
        // Non-blocking
      }
    }
    markSeen();
    return () => {
      cancelled = true;
    };
  }, [visual.id]);

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-2 flex-wrap">
        <Badge className="bg-fuchsia-100 text-fuchsia-700">Visual Summary</Badge>
        <Badge variant="outline">{visual.layer}</Badge>
        <div className="ml-auto flex items-center gap-1">
          <AudioPlayer
            text={[visual.title, visual.caption ?? "", visual.notes_md ?? ""].join(". ")}
          />
          <BookmarkButton unitType="lesson" unitId={visual.id} />
        </div>
      </div>
      <h1 className="text-2xl font-bold">{visual.title}</h1>
      {visual.caption && (
        <p className="text-muted-foreground">{visual.caption}</p>
      )}

      {/* Image */}
      {visual.image_url ? (
        <Card className="overflow-hidden">
          <button
            type="button"
            onClick={() => setZoomed(true)}
            className="w-full block relative group"
          >
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={visual.image_url}
              alt={visual.title}
              className="w-full max-h-[600px] object-contain bg-muted"
            />
            <div className="absolute top-2 right-2 bg-background/80 backdrop-blur p-1.5 rounded opacity-0 group-hover:opacity-100 transition-opacity">
              <Maximize2 className="h-4 w-4" />
            </div>
          </button>
        </Card>
      ) : (
        <Card className="border-dashed">
          <CardContent className="p-6 text-center text-muted-foreground">
            <ImageIcon className="h-8 w-8 mx-auto mb-1 opacity-40" />
            <p className="text-xs">Text-only short note</p>
          </CardContent>
        </Card>
      )}

      {/* Notes */}
      {visual.notes_md && (
        <Card>
          <CardContent className="p-4">
            <p className="text-xs font-bold uppercase text-fuchsia-700 mb-2">
              สรุปสั้น
            </p>
            <article className="prose prose-slate dark:prose-invert prose-sm max-w-none">
              <ReactMarkdown remarkPlugins={[remarkGfm]}>
                {visual.notes_md}
              </ReactMarkdown>
            </article>
          </CardContent>
        </Card>
      )}

      {visual.source && (
        <p className="text-xs text-muted-foreground italic">
          ที่มา: {visual.source}
        </p>
      )}

      {/* Quick check Q&A */}
      {visual.check_questions.length > 0 && (
        <Card>
          <CardContent className="p-4">
            <QuickCheckList items={visual.check_questions} />
          </CardContent>
        </Card>
      )}

      {/* Inline flashcards — retrieval practice */}
      {flashcards.length > 0 && (
        <Card>
          <CardContent className="p-4 space-y-3">
            <p className="text-xs font-bold uppercase text-sky-700">
              ทบทวนด้วย Flashcards ({flashcards.length})
            </p>
            <FlashcardSwiper cards={flashcards} isPremium freeLimit={flashcards.length} />
          </CardContent>
        </Card>
      )}

      <NoteEditor unitType="lesson" unitId={visual.id} />

      {/* Zoom modal */}
      {zoomed && visual.image_url && (
        <div
          className="fixed inset-0 z-50 bg-black/80 flex items-center justify-center p-4"
          onClick={() => setZoomed(false)}
        >
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={visual.image_url}
            alt={visual.title}
            className="max-w-full max-h-full object-contain cursor-zoom-out"
          />
        </div>
      )}
    </div>
  );
}
