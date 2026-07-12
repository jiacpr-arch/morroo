"use client";

import { cn } from "@/lib/utils";
import type { VideoQuizQuestion } from "@/lib/courses/video-lessons";

interface VideoQuizProps {
  question: VideoQuizQuestion;
  chosenId?: string;
  onChoose: (choiceId: string) => void;
  locked: boolean;
  showCorrect: boolean;
}

// Renders a single video-lesson quiz question (choice list + reveal state).
// Styled to match components/acls-reader/LessonReader.tsx's QuizStepView —
// this is the video-lesson equivalent for the ported "เช็คความเข้าใจ" block.
export default function VideoQuiz({ question, chosenId, onChoose, locked, showCorrect }: VideoQuizProps) {
  const answered = chosenId != null;

  return (
    <div className="space-y-3">
      <div className="rounded-xl border border-border p-4">
        <p className="mb-3 text-sm font-medium">{question.question}</p>
        <div className="space-y-2">
          {question.choices.map((c) => {
            const isAnswer = c.id === question.correctId;
            let tone = "border-border hover:border-brand/40 hover:bg-muted/40";
            if (showCorrect && answered) {
              if (isAnswer) tone = "border-brand bg-brand/10";
              else if (c.id === chosenId) tone = "border-destructive bg-destructive/10";
              else tone = "border-border opacity-70";
            } else if (chosenId === c.id) {
              tone = "border-brand bg-brand/10";
            }
            return (
              <button
                key={c.id}
                type="button"
                onClick={() => !locked && onChoose(c.id)}
                disabled={locked}
                className={cn(
                  "flex w-full items-center justify-between rounded-lg border p-3 text-left text-sm transition-colors",
                  tone,
                  locked && "cursor-default",
                )}
              >
                <span>{c.text}</span>
              </button>
            );
          })}
        </div>
      </div>
      {showCorrect && question.explanation && (
        <div className="rounded-lg bg-muted/50 p-2.5 text-xs text-muted-foreground">
          {question.explanation}
        </div>
      )}
    </div>
  );
}
