"use client";

import { useState, useCallback, useEffect, useRef } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  CheckCircle,
  XCircle,
  ArrowRight,
  RotateCcw,
  ChevronDown,
  ChevronUp,
} from "lucide-react";
import type { McqQuestion } from "@/lib/types-mcq";
import {
  saveMcqAttempt,
  createMcqSession,
  updateMcqSession,
} from "@/lib/supabase/mutations-mcq";
import { createClient } from "@/lib/supabase/client";

interface McqPracticeProps {
  questions: McqQuestion[];
}

export default function McqPractice({ questions }: McqPracticeProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [showResult, setShowResult] = useState(false);
  const [showExplanation, setShowExplanation] = useState(false);
  const [stats, setStats] = useState({ correct: 0, total: 0 });
  const [userId, setUserId] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const questionStartTime = useRef<number>(Date.now());

  // Get user on mount and create session
  useEffect(() => {
    async function init() {
      try {
        const supabase = createClient();
        const {
          data: { user },
        } = await supabase.auth.getUser();
        if (user) {
          setUserId(user.id);
          const session = await createMcqSession({
            user_id: user.id,
            mode: "practice",
            exam_type: "NL2",
            total_questions: questions.length,
          });
          if (session) {
            setSessionId(session.id);
          }
        }
      } catch {
        // Not logged in or error — skip saving
      }
    }
    init();
  }, [questions.length]);

  // Reset question timer when question changes
  useEffect(() => {
    questionStartTime.current = Date.now();
  }, [currentIndex]);

  const question = questions[currentIndex];

  const handleSelectAnswer = useCallback(
    (label: string) => {
      if (showResult) return;
      setSelectedAnswer(label);
      setShowResult(true);

      const isCorrect = label === question.correct_answer;
      setStats((prev) => ({
        correct: prev.correct + (isCorrect ? 1 : 0),
        total: prev.total + 1,
      }));

      // Save attempt to DB if logged in
      if (userId) {
        const timeSpent = Math.round(
          (Date.now() - questionStartTime.current) / 1000
        );
        saveMcqAttempt({
          user_id: userId,
          question_id: question.id,
          selected_answer: label,
          is_correct: isCorrect,
          time_spent_seconds: timeSpent,
          mode: "practice",
          session_id: sessionId,
        }).catch(() => {
          // Silently fail — don't block UI
        });
      }
    },
    [showResult, question, userId, sessionId]
  );

  const handleNext = useCallback(() => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
      setSelectedAnswer(null);
      setShowResult(false);
      setShowExplanation(false);
    }
  }, [currentIndex, questions.length]);

  const handleRestart = useCallback(() => {
    setCurrentIndex(0);
    setSelectedAnswer(null);
    setShowResult(false);
    setShowExplanation(false);
    setStats({ correct: 0, total: 0 });
  }, []);

  if (!question) {
    return (
      <div className="text-center py-16">
        <p className="text-lg text-muted-foreground">ไม่มีข้อสอบ</p>
      </div>
    );
  }

  const isFinished = showResult && currentIndex === questions.length - 1;
  const percentage =
    stats.total > 0 ? Math.round((stats.correct / stats.total) * 100) : 0;

  // Update session when finished
  const hasUpdatedSession = useRef(false);
  useEffect(() => {
    if (isFinished && sessionId && !hasUpdatedSession.current) {
      hasUpdatedSession.current = true;
      updateMcqSession(sessionId, {
        correct_count: stats.correct,
        completed_at: new Date().toISOString(),
      }).catch(() => {});
    }
  }, [isFinished, sessionId, stats.correct]);

  return (
    <div className="space-y-6">
      {/* Progress Bar */}
      <div className="flex items-center justify-between text-sm">
        <span className="text-muted-foreground">
          ข้อ {currentIndex + 1} / {questions.length}
        </span>
        <div className="flex items-center gap-3">
          <span className="text-green-600">✓ {stats.correct}</span>
          <span className="text-red-600">✗ {stats.total - stats.correct}</span>
          {stats.total > 0 && (
            <Badge
              variant="secondary"
              className={
                percentage >= 60
                  ? "bg-green-100 text-green-700"
                  : "bg-red-100 text-red-700"
              }
            >
              {percentage}%
            </Badge>
          )}
        </div>
      </div>

      <div className="w-full bg-muted rounded-full h-1.5">
        <div
          className="bg-brand h-1.5 rounded-full transition-all duration-300"
          style={{
            width: `${((currentIndex + (showResult ? 1 : 0)) / questions.length) * 100}%`,
          }}
        />
      </div>

      {/* Subject Badge */}
      {question.mcq_subjects && (
        <Badge variant="secondary" className="text-xs">
          {question.mcq_subjects.icon} {question.mcq_subjects.name_th}
          {question.exam_source && ` • ${question.exam_source}`}
        </Badge>
      )}

      {/* Question */}
      <Card>
        <CardContent className="p-6">
          <p className="text-base leading-relaxed whitespace-pre-line">
            {question.scenario}
          </p>
        </CardContent>
      </Card>

      {/* Choices */}
      <div className="space-y-3">
        {question.choices.map((choice) => {
          const isSelected = selectedAnswer === choice.label;
          const isCorrect = choice.label === question.correct_answer;

          let borderClass = "border-border hover:border-brand/50";
          let bgClass = "bg-white";

          if (showResult) {
            if (isCorrect) {
              borderClass = "border-green-500";
              bgClass = "bg-green-50";
            } else if (isSelected && !isCorrect) {
              borderClass = "border-red-500";
              bgClass = "bg-red-50";
            } else {
              borderClass = "border-border opacity-60";
            }
          } else if (isSelected) {
            borderClass = "border-brand";
            bgClass = "bg-brand/5";
          }

          return (
            <button
              key={choice.label}
              onClick={() => handleSelectAnswer(choice.label)}
              disabled={showResult}
              className={`w-full text-left p-4 rounded-xl border-2 transition-all ${borderClass} ${bgClass} ${
                !showResult ? "cursor-pointer" : "cursor-default"
              }`}
            >
              <div className="flex items-start gap-3">
                <span
                  className={`flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold ${
                    showResult && isCorrect
                      ? "bg-green-500 text-white"
                      : showResult && isSelected && !isCorrect
                        ? "bg-red-500 text-white"
                        : "bg-muted text-muted-foreground"
                  }`}
                >
                  {showResult && isCorrect ? (
                    <CheckCircle className="h-5 w-5" />
                  ) : showResult && isSelected && !isCorrect ? (
                    <XCircle className="h-5 w-5" />
                  ) : (
                    choice.label
                  )}
                </span>
                <span className="text-sm leading-relaxed pt-1">
                  {choice.text}
                </span>
              </div>
            </button>
          );
        })}
      </div>

      {/* Explanation */}
      {showResult && question.explanation && (
        <div>
          <button
            onClick={() => setShowExplanation(!showExplanation)}
            className="flex items-center gap-2 text-sm text-brand hover:underline"
          >
            {showExplanation ? (
              <ChevronUp className="h-4 w-4" />
            ) : (
              <ChevronDown className="h-4 w-4" />
            )}
            {showExplanation ? "ซ่อนคำอธิบาย" : "ดูคำอธิบาย"}
          </button>
          {showExplanation && (
            <Card className="mt-3 border-brand/20">
              <CardContent className="p-4">
                <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                  {question.explanation}
                </p>
              </CardContent>
            </Card>
          )}
        </div>
      )}

      {/* Actions */}
      {showResult && (
        <div className="flex items-center gap-3">
          {!isFinished ? (
            <Button
              onClick={handleNext}
              className="bg-brand hover:bg-brand-light text-white gap-2"
            >
              ข้อถัดไป <ArrowRight className="h-4 w-4" />
            </Button>
          ) : (
            <div className="w-full">
              <Card className="border-brand/20 bg-brand/5">
                <CardContent className="p-6 text-center">
                  <h3 className="text-xl font-bold mb-2">ทำครบแล้ว!</h3>
                  <p className="text-3xl font-bold text-brand mb-1">
                    {stats.correct} / {stats.total}
                  </p>
                  <p className="text-muted-foreground mb-4">
                    ({percentage}%){" "}
                    {percentage >= 80
                      ? "ดีมาก!"
                      : percentage >= 60
                        ? "ผ่านเกณฑ์"
                        : "ต้องทบทวนเพิ่ม"}
                  </p>
                  <Button
                    onClick={handleRestart}
                    variant="outline"
                    className="gap-2"
                  >
                    <RotateCcw className="h-4 w-4" /> ทำใหม่อีกครั้ง
                  </Button>
                </CardContent>
              </Card>
            </div>
          )}
        </div>
      )}
    </div>
  );
}
