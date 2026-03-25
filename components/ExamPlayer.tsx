"use client";

import { useState, useCallback } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import ExamTimer from "@/components/ExamTimer";
import { ArrowRight, Clock, Lock, CheckCircle, Play, PenLine, ChevronDown, ChevronUp } from "lucide-react";
import type { Exam, ExamPart } from "@/lib/types";

interface ExamPlayerProps {
  exam: Exam;
  parts: ExamPart[];
}

export default function ExamPlayer({ exam, parts }: ExamPlayerProps) {
  // currentPart: -1 = ยังไม่เริ่ม, 0-5 = ตอนที่กำลังทำ, 6 = ทำครบแล้ว
  const [currentPart, setCurrentPart] = useState(-1);
  const [timerRunning, setTimerRunning] = useState(false);
  const [notes, setNotes] = useState<Record<number, string>>({});
  const [expandedNotes, setExpandedNotes] = useState<Set<number>>(new Set());

  const totalParts = parts.length;
  const isFinished = currentPart >= totalParts;

  const startExam = () => {
    setCurrentPart(0);
    setTimerRunning(true);
  };

  const goToNextPart = useCallback(() => {
    setTimerRunning(false);
    setTimeout(() => {
      setCurrentPart((prev) => {
        const next = prev + 1;
        if (next < totalParts) {
          setTimerRunning(true);
        }
        return next;
      });
    }, 100);
  }, [totalParts]);

  const difficultyColors: Record<string, string> = {
    easy: "bg-green-100 text-green-700",
    medium: "bg-yellow-100 text-yellow-700",
    hard: "bg-red-100 text-red-700",
  };
  const difficultyLabels: Record<string, string> = {
    easy: "ง่าย",
    medium: "ปานกลาง",
    hard: "ยาก",
  };

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-8">
        <div className="flex items-center gap-2 mb-3 flex-wrap">
          <Badge variant="secondary">{exam.category}</Badge>
          <Badge className={difficultyColors[exam.difficulty]}>
            {difficultyLabels[exam.difficulty]}
          </Badge>
          {exam.is_free && (
            <Badge className="bg-brand/10 text-brand">ฟรี</Badge>
          )}
          <Badge variant="outline" className="gap-1">
            {totalParts} ตอน
          </Badge>
        </div>
        <h1 className="text-2xl sm:text-3xl font-bold">{exam.title}</h1>

        {/* Progress bar */}
        {currentPart >= 0 && (
          <div className="mt-4">
            <div className="flex items-center justify-between text-sm text-muted-foreground mb-1.5">
              <span>
                {isFinished
                  ? "ทำครบทุกตอนแล้ว!"
                  : `ตอนที่ ${currentPart + 1} จาก ${totalParts}`}
              </span>
              <span>{Math.min(currentPart, totalParts)}/{totalParts}</span>
            </div>
            <div className="h-2 bg-muted rounded-full overflow-hidden">
              <div
                className="h-full bg-brand rounded-full transition-all duration-500"
                style={{
                  width: `${(Math.min(currentPart, totalParts) / totalParts) * 100}%`,
                }}
              />
            </div>
          </div>
        )}
      </div>

      {/* Not started yet */}
      {currentPart === -1 && (
        <Card className="text-center py-12">
          <CardContent className="space-y-6">
            <div className="mx-auto w-20 h-20 rounded-full bg-brand/10 flex items-center justify-center">
              <Play className="h-10 w-10 text-brand" />
            </div>
            <div>
              <h2 className="text-xl font-bold mb-2">พร้อมเริ่มทำข้อสอบหรือยัง?</h2>
              <p className="text-muted-foreground max-w-md mx-auto">
                ข้อสอบนี้มี {totalParts} ตอน แสดงทีละตอน
                แต่ละตอนมีเวลาจำกัด เมื่อเริ่มแล้วเวลาจะนับถอยหลังอัตโนมัติ
              </p>
            </div>
            <Button
              size="lg"
              className="bg-brand hover:bg-brand-light text-white px-10 text-base"
              onClick={startExam}
            >
              เริ่มทำข้อสอบ <ArrowRight className="ml-2 h-5 w-5" />
            </Button>
          </CardContent>
        </Card>
      )}

      {/* Parts */}
      {currentPart >= 0 && (
        <div className="space-y-4">
          {parts.map((part, index) => {
            const isActive = index === currentPart;
            const isCompleted = index < currentPart;
            const isLocked = index > currentPart;

            if (isLocked) {
              return (
                <Card key={part.id} className="opacity-50">
                  <CardHeader className="pb-0">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-muted flex items-center justify-center">
                        <Lock className="h-4 w-4 text-muted-foreground" />
                      </div>
                      <span className="text-sm font-medium text-muted-foreground">
                        {part.title}
                      </span>
                    </div>
                  </CardHeader>
                </Card>
              );
            }

            if (isCompleted) {
              const hasNote = !!notes[index]?.trim();
              const isExpanded = expandedNotes.has(index);
              return (
                <Card key={part.id} className="border-brand/20 bg-brand/5">
                  <CardHeader className="pb-0">
                    <div
                      className="flex items-center justify-between cursor-pointer"
                      onClick={() => {
                        setExpandedNotes((prev) => {
                          const next = new Set(prev);
                          if (next.has(index)) next.delete(index);
                          else next.add(index);
                          return next;
                        });
                      }}
                    >
                      <div className="flex items-center gap-3">
                        <div className="w-8 h-8 rounded-full bg-brand/20 flex items-center justify-center">
                          <CheckCircle className="h-4 w-4 text-brand" />
                        </div>
                        <span className="text-sm font-medium text-brand">
                          {part.title}
                        </span>
                        {hasNote && (
                          <Badge variant="secondary" className="text-xs gap-1">
                            <PenLine className="h-3 w-3" /> มีบันทึก
                          </Badge>
                        )}
                      </div>
                      {hasNote && (
                        isExpanded
                          ? <ChevronUp className="h-4 w-4 text-muted-foreground" />
                          : <ChevronDown className="h-4 w-4 text-muted-foreground" />
                      )}
                    </div>
                    {isExpanded && hasNote && (
                      <div className="mt-3 ml-11 p-3 rounded-md bg-white border border-amber-200 text-sm whitespace-pre-line text-muted-foreground">
                        {notes[index]}
                      </div>
                    )}
                  </CardHeader>
                </Card>
              );
            }

            // Active part
            return (
              <Card key={part.id} className="border-brand shadow-md">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between flex-wrap gap-3">
                    <h2 className="text-lg font-bold text-brand">
                      {part.title}
                    </h2>
                    <div className="flex items-center gap-2 text-sm text-muted-foreground">
                      <Clock className="h-4 w-4" />
                      <span>{part.time_minutes} นาที</span>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Scenario */}
                  <div className="rounded-lg bg-muted/50 p-4 border-l-4 border-brand">
                    <h3 className="text-sm font-semibold text-muted-foreground mb-2">
                      สถานการณ์
                    </h3>
                    <div className="text-sm leading-relaxed whitespace-pre-line">
                      {part.scenario}
                    </div>
                  </div>

                  {/* Question */}
                  <div className="rounded-lg bg-brand/5 p-4 border border-brand/20">
                    <h3 className="text-sm font-semibold text-brand mb-2">
                      คำถาม
                    </h3>
                    <p className="text-sm font-medium">{part.question}</p>
                  </div>

                  {/* Note / Answer area */}
                  <div className="rounded-lg border border-amber-200 bg-amber-50/50 p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <PenLine className="h-4 w-4 text-amber-600" />
                      <h3 className="text-sm font-semibold text-amber-800">
                        คำตอบของคุณ
                      </h3>
                    </div>
                    <textarea
                      className="w-full min-h-[120px] rounded-md border border-amber-200 bg-white p-3 text-sm leading-relaxed placeholder:text-amber-300 focus:outline-none focus:ring-2 focus:ring-brand/30 resize-y"
                      placeholder="พิมพ์คำตอบของคุณที่นี่..."
                      value={notes[index] || ""}
                      onChange={(e) =>
                        setNotes((prev) => ({ ...prev, [index]: e.target.value }))
                      }
                    />
                  </div>

                  {/* Timer */}
                  <div className="pt-2 border-t">
                    <ExamTimer
                      key={index}
                      minutes={part.time_minutes}
                      running={timerRunning}
                      onTimeUp={goToNextPart}
                    />
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}

      {/* Finished */}
      {isFinished && (
        <div className="mt-8 text-center space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center">
            <CheckCircle className="h-8 w-8 text-brand" />
          </div>
          <h2 className="text-xl font-bold">ทำข้อสอบครบทุกตอนแล้ว!</h2>
          <p className="text-muted-foreground">
            {exam.is_free
              ? "ดูเฉลยและเปรียบเทียบคำตอบของคุณ"
              : "ต้องเป็นสมาชิก Premium เพื่อดูเฉลย"}
          </p>
          <Link
            href={`/exams/${exam.id}/answer`}
            onClick={() => {
              // Save notes to localStorage for the answer page
              localStorage.setItem(
                `exam-notes-${exam.id}`,
                JSON.stringify(notes)
              );
            }}
          >
            <Button
              size="lg"
              className="bg-brand hover:bg-brand-light text-white px-8"
            >
              ดูเฉลยและเปรียบเทียบ <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
        </div>
      )}
    </div>
  );
}
