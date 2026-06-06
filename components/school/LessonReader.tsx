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
import { splitLessonParts, type InlineQuiz } from "@/lib/school/lesson-parts";
import {
  difficultyLabelTh,
  difficultyBadgeClass,
} from "@/lib/school/difficulty";
import type { SchoolDifficulty } from "@/lib/types-school";
import BookmarkButton from "./BookmarkButton";
import NoteEditor from "./NoteEditor";
import RelatedConcepts from "./RelatedConcepts";

interface Props {
  lesson: SchoolLesson;
  miniQuizzes: SchoolQuiz[];
}

/**
 * Reader with mini-quiz interleaving. Authors split lesson body_md into
 * sections using a marker line `## ⏸ Mini Quiz`, and author the quiz for each
 * gate inline right after its marker so it always matches the part above. The
 * reader shows that inline quiz between sections, falling back to a quiz from
 * the topic pool (`miniQuizzes`) only for lessons not yet migrated to inline.
 * Reaching the end marks the lesson as read (XP awarded) and reveals a final
 * retrieval quiz tail.
 */
export default function LessonReader({ lesson, miniQuizzes }: Props) {
  const { sections, gateQuizzes } = useMemo(() => {
    const parsed = splitLessonParts(lesson.body_md);
    return { sections: parsed.parts, gateQuizzes: parsed.gateQuizzes };
  }, [lesson.body_md]);
  const totalGates = sections.length - 1;

  // The quiz shown after part `idx`: inline quiz if authored, else fall back to
  // the legacy topic pool so un-migrated lessons keep working.
  const quizForGate = (idx: number): InlineQuiz | null =>
    gateQuizzes[idx] ?? miniQuizzes[idx] ?? null;

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
          {idx < totalGates && idx <= step && quizForGate(idx) && (
            <MiniQuizCard
              quiz={quizForGate(idx)!}
              picked={picks[idx] ?? null}
              onPick={(l) => pickAt(idx, l)}
            />
          )}

          {/* Continue button */}
          {idx === step && step + 1 < sections.length && (
            <Button
              onClick={nextSection}
              disabled={idx < totalGates && !!quizForGate(idx) && !picks[idx]}
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
  quiz: InlineQuiz;
  picked: string | null;
  onPick: (label: string) => void;
}) {
  return (
    <Card className="mt-3 border-emerald-200 bg-emerald-50/40">
      <CardContent className="p-4 space-y-2">
        <div className="flex items-center gap-2">
          <p className="text-xs font-bold uppercase text-emerald-700">Mini Quiz</p>
          {quiz.difficulty && <DifficultyBadge difficulty={quiz.difficulty} />}
        </div>
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

function DifficultyBadge({ difficulty }: { difficulty: SchoolDifficulty }) {
  return (
    <Badge className={`text-[10px] ${difficultyBadgeClass(difficulty)}`}>
      {difficultyLabelTh(difficulty)}
    </Badge>
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
              <div className="mb-2 flex items-start gap-2">
                <p className="text-sm font-medium flex-1">{q.stem}</p>
                {q.difficulty && <DifficultyBadge difficulty={q.difficulty} />}
              </div>
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

