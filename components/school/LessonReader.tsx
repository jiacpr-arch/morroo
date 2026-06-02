"use client";

import { useMemo, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { CheckCircle, XCircle, ArrowRight, Sparkles } from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import type { SchoolLesson, SchoolQuiz } from "@/lib/types-school";
import { createClient } from "@/lib/supabase/client";
import { XP, awardXp } from "@/lib/school/xp";
import BookmarkButton from "./BookmarkButton";
import NoteEditor from "./NoteEditor";
import RelatedConcepts from "./RelatedConcepts";

interface Props {
  lesson: SchoolLesson;
  miniQuizzes: SchoolQuiz[];
}

/**
 * Reader with mini-quiz interleaving. Authors split lesson body_md into
 * sections using a marker line `## ⏸ Mini Quiz` — the reader injects one
 * randomly-picked quiz from miniQuizzes between sections. Reaching the end
 * marks the lesson as read (XP awarded) and reveals a final retrieval quiz
 * tail.
 */
export default function LessonReader({ lesson, miniQuizzes }: Props) {
  const sections = useMemo(() => splitByMarker(lesson.body_md), [lesson.body_md]);
  const totalGates = sections.length - 1;

  const [step, setStep] = useState(0); // sections[step] currently visible
  const [completed, setCompleted] = useState(false);

  // For each gate, choose a quiz; track answer
  const [picks, setPicks] = useState<Record<number, string>>({});

  async function markCompleted() {
    if (completed) return;
    setCompleted(true);
    await awardXp(XP.lessonRead, `lesson:${lesson.id}`);
    try {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        await supabase.from("school_progress").insert({
          user_id: user.id,
          unit_type: "lesson",
          unit_id: lesson.id,
          outcome: "good",
          ease_factor: 2.5,
          interval_days: 7,
        });
      }
    } catch {
      // Non-blocking
    }
  }

  function nextSection() {
    if (step + 1 >= sections.length) {
      markCompleted();
      return;
    }
    setStep((s) => s + 1);
    if (step + 1 === sections.length - 1) {
      markCompleted();
    }
  }

  function pickAt(gateIdx: number, label: string) {
    if (picks[gateIdx]) return;
    setPicks({ ...picks, [gateIdx]: label });
  }

  const visibleSections = sections.slice(0, step + 1);

  return (
    <div className="space-y-6">
      {visibleSections.map((sec, idx) => (
        <div key={idx}>
          <Card>
            <CardContent className="p-5">
              <div className="flex items-center gap-2 mb-3">
                <Badge variant="outline" className="text-xs">
                  Part {idx + 1} / {sections.length}
                </Badge>
                <div className="ml-auto">
                  <BookmarkButton unitType="lesson" unitId={lesson.id} />
                </div>
              </div>
              <article className="prose prose-slate dark:prose-invert max-w-none">
                <ReactMarkdown remarkPlugins={[remarkGfm]}>{sec}</ReactMarkdown>
              </article>
              <RelatedConcepts unitType="lesson" unitId={lesson.id} />
            </CardContent>
          </Card>

          {/* Mini-quiz gate between sections — shown on the current part too
              so the reader can answer it and unlock the Continue button */}
          {idx < totalGates && idx <= step && miniQuizzes[idx] && (
            <MiniQuizCard
              quiz={miniQuizzes[idx]}
              picked={picks[idx] ?? null}
              onPick={(l) => pickAt(idx, l)}
            />
          )}

          {/* Continue button */}
          {idx === step && step + 1 < sections.length && (
            <Button
              onClick={nextSection}
              disabled={idx < totalGates && miniQuizzes[idx] && !picks[idx]}
              className="w-full mt-3 gap-2"
            >
              Part ถัดไป <ArrowRight className="h-4 w-4" />
            </Button>
          )}
        </div>
      ))}

      {step + 1 === sections.length && (
        <Card className="border-teal-300 bg-teal-50/40">
          <CardContent className="p-5 space-y-2">
            <p className="font-bold flex items-center gap-2 text-teal-700">
              <Sparkles className="h-5 w-5" /> เรียนจบบทนี้แล้ว
            </p>
            <p className="text-sm text-muted-foreground">
              ระบบบันทึกความก้าวหน้า + ให้ XP แล้ว
            </p>
            <NoteEditor unitType="lesson" unitId={lesson.id} />
          </CardContent>
        </Card>
      )}

      {/* Final retrieval — pick remaining quizzes not used as gates */}
      {step + 1 === sections.length && miniQuizzes.length > totalGates && (
        <FinalQuiz quizzes={miniQuizzes.slice(totalGates)} />
      )}
    </div>
  );
}

function MiniQuizCard({
  quiz,
  picked,
  onPick,
}: {
  quiz: SchoolQuiz;
  picked: string | null;
  onPick: (label: string) => void;
}) {
  return (
    <Card className="mt-3 border-emerald-200 bg-emerald-50/40">
      <CardContent className="p-4 space-y-2">
        <p className="text-xs font-bold uppercase text-emerald-700">Mini Quiz</p>
        <p className="font-medium text-sm">{quiz.stem}</p>
        <div className="space-y-1">
          {quiz.choices.map((c) => {
            const chosen = picked === c.label;
            const isCorrect = picked && c.label === quiz.correct_answer;
            const isWrong = chosen && !isCorrect;
            return (
              <button
                key={c.label}
                onClick={() => onPick(c.label)}
                disabled={picked !== null}
                className={[
                  "w-full text-left rounded border px-3 py-2 text-sm flex items-start gap-2",
                  isCorrect && "border-emerald-400 bg-emerald-50",
                  isWrong && "border-rose-400 bg-rose-50",
                  picked === null && "hover:bg-muted/50 cursor-pointer",
                ].filter(Boolean).join(" ")}
              >
                <span className="font-semibold w-5 shrink-0">{c.label}.</span>
                <span className="flex-1">{c.text}</span>
                {isCorrect && <CheckCircle className="h-4 w-4 text-emerald-600" />}
                {isWrong && <XCircle className="h-4 w-4 text-rose-600" />}
              </button>
            );
          })}
        </div>
        {picked !== null && quiz.explanation && (
          <p className="text-xs italic text-muted-foreground">
            {quiz.explanation}
          </p>
        )}
      </CardContent>
    </Card>
  );
}

function FinalQuiz({ quizzes }: { quizzes: SchoolQuiz[] }) {
  return (
    <Card className="border-sky-300">
      <CardContent className="p-5 space-y-3">
        <p className="font-bold flex items-center gap-1">
          <CheckCircle className="h-4 w-4 text-sky-600" />
          Final Retrieval ({quizzes.length} ข้อ)
        </p>
        <p className="text-xs text-muted-foreground">
          ทดสอบความเข้าใจตอนจบบท — ใช้ active recall เพื่อ retention
        </p>
        <ul className="space-y-2">
          {quizzes.map((q) => (
            <li key={q.id} className="border rounded p-3">
              <p className="text-sm font-medium mb-2">{q.stem}</p>
              <details>
                <summary className="text-xs text-muted-foreground cursor-pointer">
                  ดูเฉลย
                </summary>
                <div className="mt-2 space-y-1 text-xs">
                  <p className="font-semibold">{q.correct_answer}</p>
                  {q.explanation && <p className="text-muted-foreground">{q.explanation}</p>}
                </div>
              </details>
            </li>
          ))}
        </ul>
      </CardContent>
    </Card>
  );
}

const MARKER_RE = /^##\s*⏸\s*Mini Quiz.*$/m;

function splitByMarker(md: string): string[] {
  if (!md) return [""];
  const parts = md.split(MARKER_RE).map((s) => s.trim()).filter(Boolean);
  return parts.length ? parts : [md];
}
