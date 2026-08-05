"use client";

import { useRef, useState } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  BookOpen,
  BookOpenText,
  Brain,
  ChevronLeft,
  ChevronRight,
} from "lucide-react";

export interface RailSubject {
  id: string;
  name_th: string;
  name_en: string;
  code: string | null;
  credits: number | null;
  credit_hours: string | null;
  lessons: number;
  quizzes: number;
  bookId?: string;
}

interface Props {
  subjects: RailSubject[];
}

/**
 * แถววิชาแบบ "ปัดเลื่อนดู" — หนึ่งแถวต่อชั้นปี เห็นทีละใบครึ่ง ๆ บนมือถือ
 * เพื่อสื่อว่ายังเลื่อนต่อได้ ส่วนจอใหญ่มีปุ่มลูกศรช่วยเลื่อนทีละหน้า
 */
export default function SubjectRail({ subjects }: Props) {
  const railRef = useRef<HTMLDivElement>(null);
  const [atStart, setAtStart] = useState(true);
  const [atEnd, setAtEnd] = useState(false);

  function syncEdges() {
    const el = railRef.current;
    if (!el) return;
    setAtStart(el.scrollLeft <= 8);
    setAtEnd(el.scrollLeft + el.clientWidth >= el.scrollWidth - 8);
  }

  function scrollByPage(dir: 1 | -1) {
    const el = railRef.current;
    if (!el) return;
    el.scrollBy({ left: dir * (el.clientWidth * 0.9), behavior: "smooth" });
  }

  return (
    <div className="relative">
      <div className="hidden sm:flex justify-end gap-2 mb-2">
        <Button
          variant="outline"
          size="icon"
          aria-label="เลื่อนไปทางซ้าย"
          disabled={atStart}
          onClick={() => scrollByPage(-1)}
        >
          <ChevronLeft className="h-4 w-4" />
        </Button>
        <Button
          variant="outline"
          size="icon"
          aria-label="เลื่อนไปทางขวา"
          disabled={atEnd}
          onClick={() => scrollByPage(1)}
        >
          <ChevronRight className="h-4 w-4" />
        </Button>
      </div>

      <div
        ref={railRef}
        onScroll={syncEdges}
        className="flex gap-4 overflow-x-auto snap-x snap-mandatory scroll-smooth pb-3 -mx-4 px-4 sm:mx-0 sm:px-0 [scrollbar-width:thin]"
      >
        {subjects.map((s) => {
          const empty = s.lessons === 0 && s.quizzes === 0;
          return (
            <Card
              key={s.id}
              className="snap-start shrink-0 w-[80%] sm:w-[320px] max-w-[360px]"
            >
              <CardContent className="p-5 h-full flex flex-col gap-3">
                <div className="flex items-start justify-between gap-2">
                  {s.code && (
                    <Badge variant="outline" className="font-mono text-[11px]">
                      {s.code}
                    </Badge>
                  )}
                  {empty && (
                    <Badge variant="secondary" className="text-[10px]">
                      เร็วๆ นี้
                    </Badge>
                  )}
                </div>
                <div>
                  <h3 className="font-semibold leading-snug">{s.name_th}</h3>
                  <p className="text-xs text-muted-foreground mt-1">
                    {s.name_en}
                  </p>
                </div>
                {s.credits != null && (
                  <p className="text-[11px] text-muted-foreground">
                    {s.credits} หน่วยกิต
                    {s.credit_hours && ` (${s.credit_hours})`}
                  </p>
                )}
                <div className="flex gap-3 text-xs text-muted-foreground mt-auto">
                  <span className="flex items-center gap-1">
                    <BookOpen className="h-3 w-3" /> {s.lessons} บท
                  </span>
                  <span className="flex items-center gap-1">
                    <Brain className="h-3 w-3" /> {s.quizzes} ข้อ
                  </span>
                </div>
                {s.bookId && (
                  <Link href={`/school/book/${s.bookId}`}>
                    <Button
                      size="sm"
                      variant="outline"
                      className="w-full gap-2 border-amber-300 text-amber-700 hover:bg-amber-50"
                    >
                      <BookOpenText className="h-4 w-4" /> หนังสือฉบับเต็ม
                    </Button>
                  </Link>
                )}
                {empty ? (
                  <Button size="sm" variant="outline" className="w-full" disabled>
                    เนื้อหาเร็วๆ นี้
                  </Button>
                ) : (
                  <Link href={`/school/topic/${s.id}`}>
                    <Button
                      size="sm"
                      className="w-full bg-brand hover:bg-brand-light text-white"
                    >
                      เปิดวิชานี้
                    </Button>
                  </Link>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>

      <p className="text-xs text-muted-foreground sm:hidden">
        ← ปัดเพื่อดูวิชาอื่น →
      </p>
    </div>
  );
}
