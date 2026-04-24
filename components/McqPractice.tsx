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
  Lock,
  Sparkles,
} from "lucide-react";
import type { McqQuestion } from "@/lib/types-mcq";
import DifficultyBadge from "@/components/DifficultyBadge";
import type { DifficultyLevel } from "@/lib/types-standard";
import Link from "next/link";
import {
  saveMcqAttempt,
  createMcqSession,
  updateMcqSession,
} from "@/lib/supabase/mutations-mcq";
import { createClient } from "@/lib/supabase/client";
import McqAiChat from "@/components/McqAiChat";
import ReportErrorButton from "@/components/ReportErrorButton";
import { useBeta } from "@/components/beta/BetaProvider";
import BetaCheckpointSurvey from "@/components/beta/BetaCheckpointSurvey";
import BetaExitSurvey from "@/components/beta/BetaExitSurvey";
import BetaPaywall from "@/components/beta/BetaPaywall";

interface McqPracticeProps {
  questions: McqQuestion[];
  isPremium?: boolean;
  freeUsedCount?: number;
  freeLimit?: number;
  viaRecommendation?: boolean;
}

export default function McqPractice({
  questions,
  isPremium = false,
  freeUsedCount = 0,
  freeLimit = 5,
  viaRecommendation = false,
}: McqPracticeProps) {
  const { status: betaStatus, recordAttempt, refresh: refreshBeta } = useBeta();
  const isBeta = betaStatus?.isBeta ?? false;
  // Beta users get their own quota (from DB). Non-beta free users keep the
  // legacy 5-question/free cap.
  const effectiveLimit = isBeta
    ? betaStatus!.questionsLimit
    : freeLimit;
  const effectiveUsedBaseline = isBeta
    ? betaStatus!.questionsUsed
    : freeUsedCount;
  const [checkpointKind, setCheckpointKind] = useState<
    "checkpoint_10" | "checkpoint_25" | null
  >(null);
  const shownCheckpoints = useRef<Set<number>>(new Set());
  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [showResult, setShowResult] = useState(false);
  const [showExplanation, setShowExplanation] = useState(false);
  const [stats, setStats] = useState({ correct: 0, total: 0 });
  const [userId, setUserId] = useState<string | null>(null);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [sessionAnswered, setSessionAnswered] = useState(0);
  const questionStartTime = useRef<number>(Date.now());

  // How many free questions remain (counting previous sessions + this session)
  const freeRemaining = Math.max(
    0,
    effectiveLimit - effectiveUsedBaseline - sessionAnswered
  );
  const isBetaExpired = isBeta && (betaStatus?.isExpired ?? false);
  const isQuotaExhausted =
    !isPremium && showResult && (freeRemaining === 0 || isBetaExpired);

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
      // Auto-expand explanation when correct so students can learn more
      if (isCorrect) {
        setShowExplanation(true);
      }
      setStats((prev) => ({
        correct: prev.correct + (isCorrect ? 1 : 0),
        total: prev.total + 1,
      }));
      setSessionAnswered((prev) => prev + 1);

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
          via_recommendation: viaRecommendation,
        }).catch(() => {
          // Silently fail — don't block UI
        });

        // Beta: optimistic counter bump + checkpoint survey triggers.
        if (isBeta) {
          recordAttempt();
          const newTotalUsed = effectiveUsedBaseline + sessionAnswered + 1;
          if (
            newTotalUsed === 10 &&
            !shownCheckpoints.current.has(10)
          ) {
            shownCheckpoints.current.add(10);
            setCheckpointKind("checkpoint_10");
          } else if (
            newTotalUsed === effectiveLimit &&
            !shownCheckpoints.current.has(effectiveLimit)
          ) {
            shownCheckpoints.current.add(effectiveLimit);
            setCheckpointKind("checkpoint_25");
          }
        }
      }
    },
    [
      showResult,
      question,
      userId,
      sessionId,
      isBeta,
      recordAttempt,
      effectiveUsedBaseline,
      sessionAnswered,
      effectiveLimit,
    ]
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
    setSessionAnswered(0);
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

      {/* Quota indicator (hidden on beta — header counter covers it) */}
      {!isPremium && !isBeta && (
        <div className="flex items-center justify-between text-xs bg-amber-50 border border-amber-200 rounded-lg px-3 py-2">
          <span className="text-amber-700">
            🎁 ข้อฟรีคงเหลือ:{" "}
            <span className="font-bold">
              {Math.max(0, freeLimit - freeUsedCount - sessionAnswered)} / {freeLimit}
            </span>{" "}
            ข้อ
          </span>
          <Link href="/pricing" className="text-brand font-medium hover:underline">
            อัปเกรด →
          </Link>
        </div>
      )}

      {/* Subject Badge + Difficulty */}
      <div className="flex items-center gap-2 flex-wrap">
        {question.mcq_subjects && (
          <Badge variant="secondary" className="text-xs">
            {question.mcq_subjects.icon} {question.mcq_subjects.name_th}
            {question.exam_source && ` • ${question.exam_source}`}
          </Badge>
        )}
        {(question as McqQuestion & { difficulty_level?: number }).difficulty_level && (
          <DifficultyBadge
            level={(question as McqQuestion & { difficulty_level?: number }).difficulty_level as DifficultyLevel}
          />
        )}
      </div>

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
      {showResult && (question.detailed_explanation || question.explanation) && (
        <div>
          {/* Free users: show short explanation always */}
          {!isPremium && question.explanation && (
            <Card className="border-brand/20 mb-3">
              <CardContent className="p-4">
                <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                  {question.explanation}
                </p>
              </CardContent>
            </Card>
          )}

          {/* Toggle detailed explanation */}
          {question.detailed_explanation && (
            <>
              <button
                onClick={() => setShowExplanation(!showExplanation)}
                className="flex items-center gap-2 text-sm font-medium text-brand hover:underline"
              >
                {showExplanation ? (
                  <ChevronUp className="h-4 w-4" />
                ) : (
                  <ChevronDown className="h-4 w-4" />
                )}
                {isPremium
                  ? showExplanation
                    ? "ซ่อนเฉลยละเอียด"
                    : "ดูเฉลยละเอียด"
                  : showExplanation
                    ? "ซ่อน"
                    : "ดูเฉลยละเอียด (Premium)"}
                {!isPremium && <Lock className="h-3 w-3 text-muted-foreground" />}
              </button>

              {showExplanation && (
                <div className="mt-3 space-y-4">
                  {isPremium ? (
                    <>
                      {/* Correct answer summary */}
                      <Card className="border-green-300 bg-green-50/50">
                        <CardContent className="p-4">
                          <div className="flex items-start gap-2 mb-2">
                            <CheckCircle className="h-5 w-5 text-green-600 mt-0.5 flex-shrink-0" />
                            <h4 className="font-bold text-green-800">
                              คำตอบที่ถูกต้อง: {question.correct_answer}
                            </h4>
                          </div>
                          <p className="text-sm leading-relaxed text-green-900">
                            {question.detailed_explanation.summary}
                          </p>
                        </CardContent>
                      </Card>

                      {/* Detailed reason */}
                      <Card className="border-blue-200 bg-blue-50/30">
                        <CardContent className="p-4">
                          <h4 className="font-bold text-blue-800 mb-2">เหตุผลโดยละเอียด</h4>
                          <p className="text-sm leading-relaxed whitespace-pre-line text-foreground/80">
                            {question.detailed_explanation.reason}
                          </p>
                        </CardContent>
                      </Card>

                      {/* Each choice explanation */}
                      <div>
                        <h4 className="font-bold text-sm mb-3">อธิบายแต่ละตัวเลือก</h4>
                        <div className="space-y-2">
                          {question.detailed_explanation.choices.map((ce) => (
                            <div
                              key={ce.label}
                              className={`p-3 rounded-lg border text-sm ${
                                ce.is_correct
                                  ? "border-green-300 bg-green-50/50"
                                  : "border-border bg-muted/30"
                              }`}
                            >
                              <div className="flex items-start gap-2">
                                <span
                                  className={`flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                                    ce.is_correct
                                      ? "bg-green-500 text-white"
                                      : "bg-muted text-muted-foreground"
                                  }`}
                                >
                                  {ce.label}
                                </span>
                                <div>
                                  <span className="font-medium">{ce.text}</span>
                                  {ce.is_correct && (
                                    <Badge className="ml-2 bg-green-100 text-green-700 text-[10px]">
                                      ถูกต้อง
                                    </Badge>
                                  )}
                                  <p className="text-muted-foreground mt-1 leading-relaxed">
                                    {ce.explanation}
                                  </p>
                                </div>
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* Key takeaway */}
                      {question.detailed_explanation.key_takeaway && (
                        <Card className="border-amber-200 bg-amber-50/30">
                          <CardContent className="p-4">
                            <h4 className="font-bold text-amber-800 mb-1 text-sm">สรุปจุดสำคัญ</h4>
                            <p className="text-sm leading-relaxed text-amber-900">
                              {question.detailed_explanation.key_takeaway}
                            </p>
                          </CardContent>
                        </Card>
                      )}
                    </>
                  ) : (
                    /* Free: show blurred preview + upgrade CTA */
                    <div className="relative rounded-xl overflow-hidden">
                      <div className="blur-sm pointer-events-none select-none space-y-3" aria-hidden>
                        <Card className="border-green-300 bg-green-50/50">
                          <CardContent className="p-4">
                            <p className="text-sm">{question.detailed_explanation.summary}</p>
                          </CardContent>
                        </Card>
                        <Card className="border-blue-200 bg-blue-50/30">
                          <CardContent className="p-4">
                            <p className="text-sm">{question.detailed_explanation.reason}</p>
                          </CardContent>
                        </Card>
                      </div>
                      <div className="absolute inset-0 bg-gradient-to-b from-white/30 to-white/95 flex flex-col items-center justify-end pb-6">
                        <div className="text-center space-y-3 px-4">
                          <div className="mx-auto w-10 h-10 rounded-full bg-brand/10 flex items-center justify-center">
                            <Sparkles className="h-5 w-5 text-brand" />
                          </div>
                          <p className="font-bold text-sm">เฉลยละเอียด + Key Points</p>
                          <p className="text-xs text-muted-foreground">สำหรับสมาชิก Premium เท่านั้น</p>
                          <Link href="/pricing">
                            <button className="bg-brand hover:bg-brand/90 text-white text-sm px-5 py-2 rounded-lg font-medium">
                              อัปเกรด ฿199/เดือน
                            </button>
                          </Link>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </>
          )}

          {/* Fallback simple explanation for premium (no detailed_explanation yet) */}
          {isPremium && !question.detailed_explanation && question.explanation && (
            <Card className="border-brand/20">
              <CardContent className="p-4">
                <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                  {question.explanation}
                </p>
              </CardContent>
            </Card>
          )}
        </div>
      )}

      {/* Report wrong answer — any student can flag mistakes & earn Bug Hunter points */}
      {showResult && userId && (
        <div className="pt-1">
          <ReportErrorButton
            questionId={question.id}
            choiceLabels={question.choices.map((c) => c.label)}
          />
        </div>
      )}

      {/* AI Chat - ask questions about this MCQ */}
      {showResult && (
        <McqAiChat question={question} selectedAnswer={selectedAnswer} isPremium={isPremium} />
      )}

      {/* Actions */}
      {showResult && (
        <div className="flex items-center gap-3">
          {isQuotaExhausted ? (
            /* Quota exhausted — beta users see BetaPaywall (coupon-aware),
               everyone else sees the legacy free-tier upsell. */
            <div className="w-full">
              {isBeta && betaStatus ? (
                <BetaPaywall
                  status={betaStatus}
                  reason={isBetaExpired ? "expired" : "quota"}
                />
              ) : (
                <Card className="border-brand bg-brand/5">
                  <CardContent className="p-6 text-center space-y-3">
                    <div className="mx-auto w-12 h-12 rounded-full bg-brand/10 flex items-center justify-center">
                      <Lock className="h-6 w-6 text-brand" />
                    </div>
                    <h3 className="text-lg font-bold">
                      ครบ {freeLimit} ข้อฟรีแล้ว!
                    </h3>
                    <p className="text-sm text-muted-foreground">
                      อัปเกรดเพื่อทำข้อสอบต่อและดูเฉลยละเอียดทุกข้อ
                    </p>
                    <div className="flex flex-col sm:flex-row gap-2 justify-center">
                      <Link href="/pricing">
                        <button className="bg-brand hover:bg-brand/90 text-white px-6 py-2.5 rounded-lg font-medium text-sm w-full sm:w-auto">
                          <Sparkles className="h-4 w-4 inline mr-1" />
                          อัปเกรด ฿199/เดือน
                        </button>
                      </Link>
                      <Button
                        onClick={handleRestart}
                        variant="outline"
                        className="gap-2 text-sm"
                      >
                        <RotateCcw className="h-4 w-4" /> ทำใหม่
                      </Button>
                    </div>
                    <p className="text-xs text-muted-foreground">
                      คะแนนของคุณ: {stats.correct}/{stats.total} ({percentage}%)
                    </p>
                  </CardContent>
                </Card>
              )}
            </div>
          ) : !isFinished ? (
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

      {/* Beta checkpoint surveys — fire after the 10th / 25th attempt */}
      {isBeta && checkpointKind && (
        <BetaCheckpointSurvey
          kind={checkpointKind}
          open
          onDismiss={() => setCheckpointKind(null)}
          onSubmitted={() => {
            setCheckpointKind(null);
            refreshBeta();
          }}
        />
      )}

      {/* Beta exit survey — only after 3+ attempts in a session */}
      {isBeta && (
        <BetaExitSurvey attemptsInSession={sessionAnswered} />
      )}
    </div>
  );
}
