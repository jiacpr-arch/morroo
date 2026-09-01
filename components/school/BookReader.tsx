"use client";

import { useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { CheckCircle2, Circle, List } from "lucide-react";
import type { SchoolBookChapter } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { XP, awardXp } from "@/lib/school/xp";
import { formatChapterBody } from "@/lib/school/format-book";
import AskMore from "./AskMore";

interface Props {
  topicId: string;
  chapters: SchoolBookChapter[];
  readChapterIds: string[];
}

/**
 * Reference reader for a topic's full-text book: a table of contents that
 * jumps to each chapter, then every chapter rendered in full for continuous
 * reading. Optional per-chapter "mark as read" awards XP and records progress
 * (unit_type 'book_chapter'). Distinct from LessonReader, which is the gated
 * micro-learning + retrieval loop.
 */
export default function BookReader({ topicId, chapters, readChapterIds }: Props) {
  const [read, setRead] = useState<Set<string>>(new Set(readChapterIds));

  async function markRead(chapterId: string) {
    if (read.has(chapterId)) return;
    setRead((prev) => new Set(prev).add(chapterId));
    await awardXp(XP.bookChapterRead, `book_chapter:${chapterId}`);
    try {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (user) {
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "book_chapter",
          unit_id: chapterId,
          outcome: "good",
          ease_factor: 2.5,
          interval_days: 30,
        });
      }
    } catch {
      // Non-blocking
    }
  }

  return (
    <div className="space-y-6">
      {/* Table of contents */}
      {chapters.length > 1 && (
        <Card>
          <CardContent className="p-5">
            <p className="mb-3 flex items-center gap-2 text-sm font-bold uppercase text-muted-foreground">
              <List className="h-4 w-4" /> สารบัญ ({chapters.length} บท)
            </p>
            <ol className="space-y-1">
              {chapters.map((ch, i) => (
                <li key={ch.id}>
                  <a
                    href={`#ch-${ch.id}`}
                    className="flex items-center gap-2 rounded p-1.5 text-sm transition-colors hover:bg-muted/50"
                  >
                    {read.has(ch.id) ? (
                      <CheckCircle2 className="h-4 w-4 shrink-0 text-emerald-600" />
                    ) : (
                      <Circle className="h-4 w-4 shrink-0 text-muted-foreground" />
                    )}
                    <span className="flex-1">
                      {i + 1}. {ch.title}
                    </span>
                  </a>
                </li>
              ))}
            </ol>
          </CardContent>
        </Card>
      )}

      {/* Chapters in full */}
      {chapters.map((ch, i) => (
        <Card key={ch.id} id={`ch-${ch.id}`} className="scroll-mt-20">
          <CardContent className="p-5">
            <div className="mb-3 flex items-center gap-2">
              <Badge variant="outline" className="text-xs">
                บทที่ {i + 1}
              </Badge>
              {read.has(ch.id) && (
                <Badge className="bg-emerald-100 text-xs text-emerald-700">
                  อ่านแล้ว
                </Badge>
              )}
            </div>
            <h2 className="mb-5 text-2xl font-bold">{ch.title}</h2>
            <article
              className="prose prose-slate prose-lg max-w-[68ch] dark:prose-invert
                prose-p:leading-8 prose-p:text-foreground/85
                prose-li:my-1 prose-li:leading-7 prose-li:text-foreground/85
                prose-strong:text-foreground prose-strong:font-semibold"
            >
              <ReactMarkdown
                remarkPlugins={[remarkGfm]}
                components={{
                  // The source text encodes section titles as ALL-CAPS / Title-case
                  // labels; formatChapterBody promotes them to h3 so they render as
                  // clearly distinct, scannable section heads instead of more body text.
                  h3: ({ children }) => (
                    <h3 className="mt-8 mb-2 border-l-4 border-brand/60 pl-3 text-base font-bold uppercase tracking-wide text-brand first:mt-0">
                      {children}
                    </h3>
                  ),
                }}
              >
                {formatChapterBody(ch.body_md)}
              </ReactMarkdown>
            </article>
            {ch.source && (
              <p className="mt-4 text-xs italic text-muted-foreground">
                ที่มา: {ch.source}
              </p>
            )}
            <Button
              variant={read.has(ch.id) ? "ghost" : "outline"}
              size="sm"
              className="mt-4 gap-2"
              disabled={read.has(ch.id)}
              onClick={() => markRead(ch.id)}
            >
              <CheckCircle2 className="h-4 w-4" />
              {read.has(ch.id) ? "อ่านจบบทนี้แล้ว" : "ทำเครื่องหมายว่าอ่านจบ"}
            </Button>
          </CardContent>
        </Card>
      ))}

      <AskMore topicId={topicId} />
    </div>
  );
}
