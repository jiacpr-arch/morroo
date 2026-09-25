"use client";

import { useState, useCallback, useEffect, useRef } from "react";
import { usePathname } from "next/navigation";
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
import type { McqAnswerKey, McqPracticeQuestion, McqRevealResponse } from "@/lib/mcq-public";
import DifficultyBadge from "@/components/DifficultyBadge";
import type { DifficultyLevel } from "@/lib/types-standard";
import Link from "next/link";
import {
  saveMcqAttempt,
  recordMcqReview,
  createMcqSession,
  updateMcqSession,
} from "@/lib/supabase/mutations-mcq";
import { createClient } from "@/lib/supabase/client";
import { track } from "@/lib/analytics";
import McqAiChat from "@/components/McqAiChat";
import ReportErrorButton from "@/components/ReportErrorButton";
import McqDiscussion from "@/components/McqDiscussion";
import { useBeta } from "@/components/beta/BetaProvider";
import BetaCheckpointSurvey from "@/components/beta/BetaCheckpointSurvey";
import BetaExitSurvey from "@/components/beta/BetaExitSurvey";
import BetaPaywall from "@/components/beta/BetaPaywall";
import { formatBaht, planIntroAmount } from "@/lib/membership";

interface McqPracticeProps {
  /**
   * ข้อสอบไม่มีเฉลย — ตอบแล้วขอเฉลยทีละข้อจาก /api/mcq/reveal ยกเว้นข้อที่ server
   * ฝัง answerKey มาให้แล้ว (ผู้ใช้ยังไม่ล็อกอิน ช่วงข้อฟรี)
   */
  questions: McqPracticeQuestion[];
  isPremium?: boolean;
  freeUsedCount?: number;
  freeLimit?: number;
  viaRecommendation?: boolean;
  /** Session metadata — defaults to student/NL2 for backward compatibility */
  sessionAudience?: "student" | "board";
  sessionExamType?: "NL1" | "NL2" | null;
  sessionBoardSpecialty?: string | null;
  sessionBoardSection?: string | null;
}

export default function McqPractice({
  questions,
  isPremium = false,
  freeUsedCount = 0,
  freeLimit = 5,
  viaRecommendation = false,
  sessionAudience = "student",
  sessionExamType = "NL2",
  sessionBoardSpecialty = null,
  sessionBoardSection = null,
}: McqPracticeProps) {
  const { status: betaStatus, recordAttempt, refresh: refreshBeta } = useBeta();
  const pathname = usePathname();
  // Only an unexpired Beta counts: once Beta ends the user falls back to the
  // normal free cap instead of being locked out.
  const isBeta = (betaStatus?.isBeta ?? false) && !betaStatus?.isExpired;
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
  // เฉลยของข้อปัจจุบัน — มีหลังตอบแล้วเท่านั้น
  const [answerKey, setAnswerKey] = useState<McqAnswerKey | null>(null);
  const [revealing, setRevealing] = useState(false);
  const [revealError, setRevealError] = useState<{ message: string; needsLogin: boolean } | null>(null);
  // เฉลยที่เคยขอแล้วในรอบนี้ (ทำใหม่ไม่ต้องยิง /api/mcq/reveal ซ้ำ)
  const revealedKeys = useRef<Map<string, McqAnswerKey>>(new Map());
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
  const isQuotaExhausted =
    !isPremium && showResult && freeRemaining === 0;

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
            exam_type: sessionAudience === "student" ? sessionExamType ?? "NL2" : null,
            audience: sessionAudience,
            board_specialty: sessionBoardSpecialty,
            board_section: sessionBoardSection,
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

  // Bring the new question back into view — otherwise the next question
  // opens scrolled down to where the explanation/"ข้อถัดไป" button was.
  const topRef = useRef<HTMLDivElement>(null);
  const isFirstRender = useRef(true);
  useEffect(() => {
    if (isFirstRender.current) {
      isFirstRender.current = false;
      return;
    }
    topRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
  }, [currentIndex]);

  // ปลายทางของ funnel ฝั่ง /nl/practice — คนที่ทำฟรีจนครบโควตาแล้วเจอกำแพง
  // เทียบเท่า casegame_cta_view ของเกม: เป็นตัวหารที่บอกว่ามีคนไปถึงจุดตัดสินใจ
  // กี่คน ยิงครั้งเดียวต่อการโหลดหน้า ไม่งั้น re-render จะยิงซ้ำรัว
  const quotaEventSentRef = useRef(false);
  useEffect(() => {
    if (!isQuotaExhausted || quotaEventSentRef.current) return;
    quotaEventSentRef.current = true;
    track("mcq_free_limit_hit", {
      logged_in: !!userId,
      answered_in_session: sessionAnswered,
      reason: "quota",
    });
  }, [isQuotaExhausted, userId, sessionAnswered]);

  const question = questions[currentIndex];
  // ข้อที่แสดงอยู่ตอนนี้ — ใช้ทิ้งผล /api/mcq/reveal ที่กลับมาหลังเปลี่ยนข้อแล้ว
  const currentQuestionId = useRef<string | undefined>(question?.id);
  useEffect(() => {
    currentQuestionId.current = question?.id;
  }, [question?.id]);

  const applyResult = useCallback(
    (label: string, key: McqAnswerKey) => {
      setAnswerKey(key);
      setShowResult(true);

      const isCorrect = label === key.correct_answer;
      // Auto-expand explanation when correct so students can learn more
      if (isCorrect) {
        setShowExplanation(true);
      }
      setStats((prev) => ({
        correct: prev.correct + (isCorrect ? 1 : 0),
        total: prev.total + 1,
      }));
      setSessionAnswered((prev) => prev + 1);

      // ตัวชี้วัดเดียวที่บอกว่าคนที่กดโฆษณาเข้า /nl/practice "ทำข้อสอบจริง" ไหม
      // saveMcqAttempt ด้านล่างบันทึกเฉพาะคนล็อกอิน ส่วนทราฟฟิกจากโฆษณาเกือบ
      // ทั้งหมดยังไม่มีบัญชี ก่อนหน้านี้จึงมองไม่เห็นอะไรเลยหลังเขาเปิดหน้ามา
      track("mcq_answer_submit", {
        is_correct: isCorrect,
        logged_in: !!userId,
        is_premium: isPremium,
        // ข้อที่เท่าไหร่ของรอบนี้ — บอกว่าคนอยู่ทำต่อกี่ข้อก่อนเลิก
        answered_in_session: sessionAnswered + 1,
        subject_id: question.subject_id ?? null,
        difficulty: question.difficulty ?? null,
      });

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

        // NL only — the review queue and ?mode=review are student-audience.
        // Wrong → enters/resets the queue; right on a due question → next
        // interval. Never throws.
        if (sessionAudience === "student") {
          void recordMcqReview(userId, question.id, isCorrect);
        }

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
      question,
      isPremium,
      userId,
      sessionId,
      isBeta,
      recordAttempt,
      effectiveUsedBaseline,
      sessionAnswered,
      effectiveLimit,
      viaRecommendation,
      sessionAudience,
    ]
  );

  const handleSelectAnswer = useCallback(
    async (label: string) => {
      if (showResult || revealing || !question) return;
      setSelectedAnswer(label);
      setRevealError(null);

      const cached = question.answerKey ?? revealedKeys.current.get(question.id);
      if (cached) {
        applyResult(label, cached);
        return;
      }

      // เฉลยไม่ได้มากับข้อสอบ — ถาม server (ต้องล็อกอิน, มี rate limit,
      // ข้อที่อยู่ใน Mock ที่กำลังสอบจะถูกปฏิเสธ)
      const questionId = question.id;
      setRevealing(true);
      try {
        const res = await fetch("/api/mcq/reveal", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ questionId, selected: label }),
        });
        const data = (await res.json().catch(() => null)) as
          | (McqRevealResponse & { error?: string })
          | null;
        if (currentQuestionId.current !== questionId) return;
        if (!res.ok || !data || typeof data.correct_answer !== "string") {
          setSelectedAnswer(null);
          setRevealError({
            message:
              data?.error ??
              (res.status === 401 ? "เข้าสู่ระบบเพื่อดูเฉลย" : "โหลดเฉลยไม่สำเร็จ ลองใหม่อีกครั้ง"),
            needsLogin: res.status === 401,
          });
          return;
        }
        const key: McqAnswerKey = {
          correct_answer: data.correct_answer,
          explanation: data.explanation ?? null,
          detailed_explanation: data.detailed_explanation ?? null,
        };
        revealedKeys.current.set(questionId, key);
        applyResult(label, key);
      } catch {
        if (currentQuestionId.current !== questionId) return;
        setSelectedAnswer(null);
        setRevealError({ message: "โหลดเฉลยไม่สำเร็จ ลองใหม่อีกครั้ง", needsLogin: false });
      } finally {
        if (currentQuestionId.current === questionId) setRevealing(false);
      }
    },
    [showResult, revealing, question, applyResult]
  );

  const handleNext = useCallback(() => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
      setSelectedAnswer(null);
      setShowResult(false);
      setShowExplanation(false);
      setAnswerKey(null);
      setRevealing(false);
      setRevealError(null);
    }
  }, [currentIndex, questions.length]);

  const handleRestart = useCallback(() => {
    setCurrentIndex(0);
    setSelectedAnswer(null);
    setShowResult(false);
    setShowExplanation(false);
    setAnswerKey(null);
    setRevealing(false);
    setRevealError(null);
    setStats({ correct: 0, total: 0 });
    setSessionAnswered(0);
  }, []);

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

  if (!question) {
    return (
      <div className="text-center py-16">
        <p className="text-lg text-muted-foreground">ไม่มีข้อสอบ</p>
      </div>
    );
  }

  return (
    <div ref={topRef} className="space-y-6 scroll-mt-20">
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
        {question.difficulty_level && (
          <DifficultyBadge level={question.difficulty_level as DifficultyLevel} />
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
          const isCorrect = !!answerKey && choice.label === answerKey.correct_answer;

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
              onClick={() => void handleSelectAnswer(choice.label)}
              disabled={showResult || revealing}
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

      {revealing && (
        <p className="text-sm text-muted-foreground" role="status">
          กำลังตรวจคำตอบ…
        </p>
      )}

      {revealError && (
        <div
          className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-800"
          role="alert"
        >
          {revealError.message}
          {revealError.needsLogin && (
            <>
              {" "}
              <Link
                href={`/login?next=${encodeURIComponent(pathname || "/nl/practice")}`}
                className="font-medium text-brand hover:underline"
              >
                เข้าสู่ระบบ →
              </Link>
            </>
          )}
        </div>
      )}

      {/* Explanation */}
      {showResult && answerKey && (answerKey.detailed_explanation || answerKey.explanation) && (
        <div>
          {/* Free users: show short explanation always */}
          {!isPremium && answerKey.explanation && (
            <Card className="border-brand/20 mb-3">
              <CardContent className="p-4">
                <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                  {answerKey.explanation}
                </p>
              </CardContent>
            </Card>
          )}

          {/* Toggle detailed explanation */}
          {answerKey.detailed_explanation && (
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
                              คำตอบที่ถูกต้อง: {answerKey.correct_answer}
                            </h4>
                          </div>
                          <p className="text-sm leading-relaxed text-green-900">
                            {answerKey.detailed_explanation.summary}
                          </p>
                        </CardContent>
                      </Card>

                      {/* Detailed reason */}
                      <Card className="border-blue-200 bg-blue-50/30">
                        <CardContent className="p-4">
                          <h4 className="font-bold text-blue-800 mb-2">เหตุผลโดยละเอียด</h4>
                          <p className="text-sm leading-relaxed whitespace-pre-line text-foreground/80">
                            {answerKey.detailed_explanation.reason}
                          </p>
                        </CardContent>
                      </Card>

                      {/* Each choice explanation */}
                      <div>
                        <h4 className="font-bold text-sm mb-3">อธิบายแต่ละตัวเลือก</h4>
                        <div className="space-y-2">
                          {answerKey.detailed_explanation.choices.map((ce) => (
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
                      {answerKey.detailed_explanation.key_takeaway && (
                        <Card className="border-amber-200 bg-amber-50/30">
                          <CardContent className="p-4">
                            <h4 className="font-bold text-amber-800 mb-1 text-sm">สรุปจุดสำคัญ</h4>
                            <p className="text-sm leading-relaxed text-amber-900">
                              {answerKey.detailed_explanation.key_takeaway}
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
                            <p className="text-sm">{answerKey.detailed_explanation.summary}</p>
                          </CardContent>
                        </Card>
                        <Card className="border-blue-200 bg-blue-50/30">
                          <CardContent className="p-4">
                            <p className="text-sm">{answerKey.detailed_explanation.reason}</p>
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
                              อัปเกรด {formatBaht(planIntroAmount("monthly"))}/เดือน
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
          {isPremium && !answerKey.detailed_explanation && answerKey.explanation && (
            <Card className="border-brand/20">
              <CardContent className="p-4">
                <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                  {answerKey.explanation}
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

      {/* Discussion thread — only after answering so comments can't spoil
          the answer. Reading/posting is free for signed-in users. */}
      {showResult && (
        <McqDiscussion key={question.id} questionId={question.id} userId={userId} />
      )}

      {/* AI Chat - ask questions about this MCQ */}
      {showResult && answerKey && (
        <McqAiChat
          question={question}
          correctAnswer={answerKey.correct_answer}
          selectedAnswer={selectedAnswer}
          isPremium={isPremium}
        />
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
                  reason="quota"
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
                          อัปเกรด {formatBaht(planIntroAmount("monthly"))}/เดือน
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
