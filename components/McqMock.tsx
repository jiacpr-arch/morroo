"use client";

import { useState, useCallback, useEffect, useMemo, useRef } from "react";
import { useRouter } from "next/navigation";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  CheckCircle,
  XCircle,
  ArrowLeft,
  ArrowRight,
  RotateCcw,
  ChevronDown,
  ChevronUp,
  Clock,
  Send,
  AlertTriangle,
} from "lucide-react";
import Link from "next/link";
import type { McqQuestion } from "@/lib/types-mcq";
import ReportErrorButton from "@/components/ReportErrorButton";
import { track } from "@/lib/analytics";
import { planIntroAmount } from "@/lib/membership";
import { createClient } from "@/lib/supabase/client";
import { fetchMockPercentile, submitMockExam } from "@/lib/supabase/mutations-mcq";
import { pickMockRank } from "@/lib/mcq-mock-percentile";
import {
  toMockReviewItem,
  type McqMockQuestion,
  type McqMockReviewItem,
  type MockSubmitResponse,
} from "@/lib/mcq-mock-grade";
import MockRankCard, { type MockRankState } from "@/components/MockRankCard";

/**
 * เปิดการบันทึกผล + percentile เทียบคนอื่นท้ายสอบ (get_mock_percentile)
 * ส่งเฉพาะ mock จริง (/nl/mock, /board/[specialty]/mock) — /nl/try เป็นเดโม
 * ห้ามส่ง ไม่งั้นผลเดโมจะไปปนใน cohort
 *
 * cohort ตรงนี้ใช้แค่แสดงผล (ชื่อชุด/ลิงก์) — cohort ที่บันทึกจริงมาจาก token
 * ที่ server เซ็น (lib/mcq-mock-token.ts)
 */
export interface McqMockCohort {
  audience: "student" | "board";
  examType?: "NL1" | "NL2" | null;
  boardSpecialty?: string | null;
  /** ชื่อชุดที่โชว์บนการ์ด/ข้อความแชร์ เช่น "Mock NL" */
  label: string;
  /** path ของหน้านี้ ใช้ทำลิงก์แชร์และ ?next= ตอนล็อกอิน */
  path: string;
}

interface McqMockBaseProps {
  timeLimitMinutes: number;
  /**
   * Shown as a sales card on the results screen for visitors who haven't
   * bought a plan yet (e.g. the public /nl/try demo). Omit to keep the
   * plain results screen — used by the full /nl/mock exam.
   */
  upsell?: { totalQuestions?: number };
  cohort?: McqMockCohort;
}

type McqMockProps = McqMockBaseProps &
  (
    | {
        /**
         * โหมด server ตรวจ (ผู้ใช้ล็อกอินบนหน้า mock จริง): ข้อสอบไม่มีเฉลย
         * ตอนส่งยิง /api/mcq/mock/submit ได้คะแนน + เฉลยกลับมา
         */
        questions: McqMockQuestion[];
        mockToken: string;
      }
    | {
        /** โหมดตรวจใน browser (ผู้ใช้ยังไม่ล็อกอิน, /nl/try): ไม่บันทึก ไม่จัดอันดับ */
        questions: McqQuestion[];
        mockToken?: undefined;
      }
  );

type MockPhase = "exam" | "results" | "review";

interface SubjectResult {
  subjectId: string;
  subjectName: string;
  icon: string;
  correct: number;
  total: number;
}

/** ผลตรวจจาก server ของรอบหนึ่ง (โหมด token) — ไม่มี state ของรอบนี้ = กำลังตรวจ */
type GradeState =
  | { attempt: number; status: "error"; message: string }
  | { attempt: number; status: "done"; response: MockSubmitResponse };

function hasAnswerKey(q: McqMockQuestion | McqQuestion): q is McqQuestion {
  return typeof (q as Partial<McqQuestion>).correct_answer === "string";
}

export default function McqMock(props: McqMockProps) {
  const { timeLimitMinutes, upsell, cohort } = props;
  const questions: McqMockQuestion[] = props.questions;
  const mockToken = props.mockToken ?? null;
  const router = useRouter();

  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<number, string>>({});
  const [phase, setPhase] = useState<MockPhase>("exam");
  const [timeLeft, setTimeLeft] = useState(timeLimitMinutes * 60); // seconds
  const [showConfirmSubmit, setShowConfirmSubmit] = useState(false);
  const [reviewIndex, setReviewIndex] = useState(0);
  const [showExplanation, setShowExplanation] = useState(false);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  // รอบที่เท่าไหร่ (สอบใหม่ = +1) — ผล rank ผูกกับรอบ ถ้ารอบไม่ตรงถือว่ายังโหลดอยู่
  // เลี่ยง setState ตรงๆ ใน effect ตอนเข้าหน้าผล
  const [attempt, setAttempt] = useState(0);
  const [rankResult, setRankResult] = useState<{
    attempt: number;
    state: MockRankState;
  } | null>(null);
  const savedAttemptRef = useRef<number | null>(null);
  const [grade, setGrade] = useState<GradeState | null>(null);
  // token ใช้ได้ครั้งเดียว — สอบใหม่ในโหมด token = ขอชุดใหม่จาก server
  const [restarting, setRestarting] = useState(false);

  // โหมด browser: เฉลยมากับข้อสอบอยู่แล้ว
  const localReview = useMemo(() => {
    if (mockToken) return null;
    const map = new Map<string, McqMockReviewItem>();
    for (const q of props.questions) {
      if (hasAnswerKey(q)) map.set(q.id, toMockReviewItem(q));
    }
    return map;
  }, [mockToken, props.questions]);

  const currentGrade = grade && grade.attempt === attempt ? grade : null;
  const review = useMemo(() => {
    if (localReview) return localReview;
    if (currentGrade?.status !== "done") return null;
    return new Map(currentGrade.response.perQuestion.map((p) => [p.id, p]));
  }, [localReview, currentGrade]);

  // Timer — นับจากเวลาจริง (Date.now) ไม่ใช่จำนวน tick เพราะ browser หน่วง
  // setInterval ตอนแท็บอยู่เบื้องหลัง ไม่งั้นเวลาบนจอจะเหลือเกินจริงและส่งเลยกำหนด
  useEffect(() => {
    if (phase !== "exam") return;
    const total = timeLimitMinutes * 60;
    const startedAt = Date.now();

    timerRef.current = setInterval(() => {
      const left = Math.max(0, total - Math.floor((Date.now() - startedAt) / 1000));
      setTimeLeft(left);
      if (left <= 0) {
        // Time's up - auto submit
        clearInterval(timerRef.current!);
        setPhase("results");
      }
    }, 1000);

    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, [phase, attempt, timeLimitMinutes]);

  const finishRank = useCallback(
    (forAttempt: number, state: MockRankState) => setRankResult({ attempt: forAttempt, state }),
    []
  );

  const requestPercentile = useCallback(
    async (forAttempt: number, res: MockSubmitResponse) => {
      if (!cohort) return;
      if (!res.ranked || !res.sessionId) {
        return finishRank(
          forAttempt,
          res.unrankedReason === "save_failed" || !res.unrankedReason
            ? { status: "unavailable" }
            : { status: "unranked", reason: res.unrankedReason }
        );
      }
      const rows = await fetchMockPercentile(res.sessionId);
      if (!rows) return finishRank(forAttempt, { status: "unavailable" });
      const rank = pickMockRank(rows);
      track("mock_percentile_view", {
        audience: cohort.audience,
        total_questions: res.total,
        ranked: rank.status === "ranked",
        percentile: rank.status === "ranked" ? rank.percentile : null,
      });
      finishRank(forAttempt, { status: "done", rank });
    },
    [cohort, finishRank]
  );

  // โหมด token: ส่งคำตอบให้ server ตรวจ (ได้คะแนน + เฉลย) แล้วขอ percentile
  const submitToServer = useCallback(
    async (forAttempt: number, token: string, answerByIndex: Record<number, string>) => {
      const byId: Record<string, string | null> = {};
      questions.forEach((q, i) => {
        byId[q.id] = answerByIndex[i] ?? null;
      });
      const res = await submitMockExam(token, byId);
      if (!res.ok) {
        setGrade({ attempt: forAttempt, status: "error", message: res.error });
        return;
      }
      setGrade({ attempt: forAttempt, status: "done", response: res.data });
      try {
        await requestPercentile(forAttempt, res.data);
      } catch {
        finishRank(forAttempt, { status: "unavailable" });
      }
    },
    [questions, requestPercentile, finishRank]
  );

  // ส่งข้อสอบ (กดเอง หรือหมดเวลา) → ตรวจ/บันทึก แล้วขอ percentile
  // ครั้งเดียวต่อรอบ (ref กัน StrictMode ยิงซ้ำ / สลับไปหน้า review แล้วกลับมา)
  useEffect(() => {
    if (phase !== "results") return;
    if (savedAttemptRef.current === attempt) return;
    savedAttemptRef.current = attempt;

    if (mockToken) {
      void submitToServer(attempt, mockToken, answers);
      return;
    }
    if (!cohort) return;

    // โหมด browser บนหน้า mock จริง: ไม่บันทึก — บอกให้ล็อกอินถ้ายังไม่ได้ล็อกอิน
    (async () => {
      try {
        const supabase = createClient();
        const {
          data: { user },
        } = await supabase.auth.getUser();
        finishRank(attempt, user ? { status: "unavailable" } : { status: "guest" });
      } catch {
        finishRank(attempt, { status: "unavailable" });
      }
    })();
  }, [phase, attempt, cohort, mockToken, answers, submitToServer, finishRank]);

  const formatTime = (seconds: number) => {
    const h = Math.floor(seconds / 3600);
    const m = Math.floor((seconds % 3600) / 60);
    const s = seconds % 60;
    if (h > 0) {
      return `${h}:${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
    }
    return `${m}:${s.toString().padStart(2, "0")}`;
  };

  const handleSelectAnswer = useCallback(
    (label: string) => {
      if (phase !== "exam") return;
      setAnswers((prev) => ({ ...prev, [currentIndex]: label }));
    },
    [phase, currentIndex]
  );

  const handleNext = useCallback(() => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex((prev) => prev + 1);
    }
  }, [currentIndex, questions.length]);

  const handlePrev = useCallback(() => {
    if (currentIndex > 0) {
      setCurrentIndex((prev) => prev - 1);
    }
  }, [currentIndex]);

  const handleSubmit = useCallback(() => {
    if (timerRef.current) clearInterval(timerRef.current);
    setPhase("results");
    setShowConfirmSubmit(false);
  }, []);

  const handleRestart = useCallback(() => {
    if (mockToken) {
      // token เดิมใช้แล้ว — ให้ server สุ่มชุดใหม่ + token ใหม่ (page ใส่ key=token
      // ไว้ component จึง remount เองเมื่อได้ชุดใหม่)
      setRestarting(true);
      router.refresh();
      return;
    }
    setCurrentIndex(0);
    setAnswers({});
    setPhase("exam");
    setTimeLeft(timeLimitMinutes * 60);
    setShowConfirmSubmit(false);
    setReviewIndex(0);
    setShowExplanation(false);
    setAttempt((n) => n + 1);
  }, [mockToken, router, timeLimitMinutes]);

  const correctAnswerOf = (q: McqMockQuestion): string | null =>
    review?.get(q.id)?.correct_answer ?? null;

  // Calculate results
  const getResults = () => {
    let correct = 0;
    const subjectMap = new Map<string, SubjectResult>();

    questions.forEach((q, i) => {
      const userAnswer = answers[i];
      const correctAnswer = correctAnswerOf(q);
      const isCorrect = userAnswer !== undefined && userAnswer === correctAnswer;
      if (isCorrect) correct++;

      const subjectId = q.subject_id;
      const subjectName = q.mcq_subjects?.name_th || "ไม่ระบุ";
      const icon = q.mcq_subjects?.icon || "📝";

      if (!subjectMap.has(subjectId)) {
        subjectMap.set(subjectId, {
          subjectId,
          subjectName,
          icon,
          correct: 0,
          total: 0,
        });
      }
      const entry = subjectMap.get(subjectId)!;
      entry.total++;
      if (isCorrect) entry.correct++;
    });

    return {
      correct,
      total: questions.length,
      percentage: Math.round((correct / questions.length) * 100),
      subjects: Array.from(subjectMap.values()).sort(
        (a, b) => b.total - a.total
      ),
    };
  };

  const answeredCount = Object.keys(answers).length;
  const question = questions[currentIndex];

  if (!question) {
    return (
      <div className="text-center py-16">
        <p className="text-lg text-muted-foreground">ไม่มีข้อสอบ</p>
      </div>
    );
  }

  if (restarting) {
    return (
      <div className="text-center py-16 text-muted-foreground animate-pulse">
        กำลังสุ่มข้อสอบชุดใหม่...
      </div>
    );
  }

  // โหมด token: ยังไม่ได้ผลตรวจจาก server — รอ หรือให้ลองส่งใหม่
  if (phase !== "exam" && !review) {
    const failed = currentGrade?.status === "error" ? currentGrade : null;
    return (
      <Card className={failed ? "border-red-200 bg-red-50" : ""}>
        <CardContent className="p-8 text-center space-y-4">
          {failed ? (
            <>
              <AlertTriangle className="h-8 w-8 text-red-600 mx-auto" />
              <p className="font-semibold text-red-800">ส่งคำตอบไม่สำเร็จ</p>
              <p className="text-sm text-red-700">{failed.message}</p>
              {mockToken && (
                <Button
                  onClick={() => {
                    setGrade(null);
                    void submitToServer(attempt, mockToken, answers);
                  }}
                  className="bg-brand hover:bg-brand-light text-white gap-2"
                >
                  <Send className="h-4 w-4" /> ลองส่งอีกครั้ง
                </Button>
              )}
            </>
          ) : (
            <p className="text-muted-foreground animate-pulse">
              กำลังตรวจคำตอบ...
            </p>
          )}
        </CardContent>
      </Card>
    );
  }

  // --- EXAM PHASE ---
  if (phase === "exam") {
    const isTimeLow = timeLeft < 300; // under 5 min

    return (
      <div className="space-y-6">
        {/* Timer & Progress */}
        <div className="sticky top-0 z-10 bg-background/95 backdrop-blur pb-3 pt-1 -mx-1 px-1">
          <div className="flex items-center justify-between text-sm mb-2">
            <span className="text-muted-foreground">
              ข้อ {currentIndex + 1} / {questions.length}
            </span>
            <div className="flex items-center gap-3">
              <Badge variant="secondary">
                ตอบแล้ว {answeredCount}/{questions.length}
              </Badge>
              <Badge
                variant="secondary"
                className={
                  isTimeLow
                    ? "bg-red-100 text-red-700 animate-pulse"
                    : "bg-blue-100 text-blue-700"
                }
              >
                <Clock className="h-3 w-3 mr-1" />
                {formatTime(timeLeft)}
              </Badge>
            </div>
          </div>

          <div className="w-full bg-muted rounded-full h-1.5">
            <div
              className="bg-brand h-1.5 rounded-full transition-all duration-300"
              style={{
                width: `${(answeredCount / questions.length) * 100}%`,
              }}
            />
          </div>
        </div>

        {/* Question Number Grid (mini nav) */}
        <div className="flex flex-wrap gap-1.5">
          {questions.map((_, i) => (
            <button
              key={i}
              onClick={() => setCurrentIndex(i)}
              className={`w-8 h-8 rounded-lg text-xs font-medium transition-all ${
                i === currentIndex
                  ? "bg-brand text-white ring-2 ring-brand/30"
                  : answers[i] !== undefined
                    ? "bg-brand/20 text-brand"
                    : "bg-muted text-muted-foreground hover:bg-muted/80"
              }`}
            >
              {i + 1}
            </button>
          ))}
        </div>

        {/* Subject Badge */}
        {question.mcq_subjects && (
          <Badge variant="secondary" className="text-xs">
            {question.mcq_subjects.icon} {question.mcq_subjects.name_th}
            {question.exam_source && ` \u2022 ${question.exam_source}`}
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

        {/* Choices - select but do NOT reveal answer */}
        <div className="space-y-3">
          {question.choices.map((choice) => {
            const isSelected = answers[currentIndex] === choice.label;

            return (
              <button
                key={choice.label}
                onClick={() => handleSelectAnswer(choice.label)}
                className={`w-full text-left p-4 rounded-xl border-2 transition-all cursor-pointer ${
                  isSelected
                    ? "border-brand bg-brand/5"
                    : "border-border hover:border-brand/50 bg-white"
                }`}
              >
                <div className="flex items-start gap-3">
                  <span
                    className={`flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold ${
                      isSelected
                        ? "bg-brand text-white"
                        : "bg-muted text-muted-foreground"
                    }`}
                  >
                    {choice.label}
                  </span>
                  <span className="text-sm leading-relaxed pt-1">
                    {choice.text}
                  </span>
                </div>
              </button>
            );
          })}
        </div>

        {/* Navigation */}
        <div className="flex items-center justify-between">
          <Button
            onClick={handlePrev}
            variant="outline"
            disabled={currentIndex === 0}
            className="gap-2"
          >
            <ArrowLeft className="h-4 w-4" /> ข้อก่อนหน้า
          </Button>

          <div className="flex gap-2">
            {currentIndex < questions.length - 1 ? (
              <Button
                onClick={handleNext}
                className="bg-brand hover:bg-brand-light text-white gap-2"
              >
                ข้อถัดไป <ArrowRight className="h-4 w-4" />
              </Button>
            ) : null}

            <Button
              onClick={() => setShowConfirmSubmit(true)}
              variant="outline"
              className="gap-2 border-purple-300 text-purple-700 hover:bg-purple-50"
            >
              <Send className="h-4 w-4" /> ส่งข้อสอบ
            </Button>
          </div>
        </div>

        {/* Confirm Submit Dialog */}
        {showConfirmSubmit && (
          <Card className="border-2 border-purple-300 bg-purple-50">
            <CardContent className="p-6">
              <div className="flex items-start gap-3">
                <AlertTriangle className="h-6 w-6 text-purple-600 flex-shrink-0 mt-0.5" />
                <div>
                  <h3 className="font-bold text-lg mb-2">ยืนยันส่งข้อสอบ?</h3>
                  <p className="text-sm text-muted-foreground mb-1">
                    ตอบแล้ว {answeredCount} จาก {questions.length} ข้อ
                  </p>
                  {answeredCount < questions.length && (
                    <p className="text-sm text-red-600 mb-3">
                      ยังมี {questions.length - answeredCount} ข้อที่ยังไม่ได้ตอบ
                    </p>
                  )}
                  <div className="flex gap-3 mt-4">
                    <Button
                      onClick={handleSubmit}
                      className="bg-purple-600 hover:bg-purple-700 text-white gap-2"
                    >
                      <Send className="h-4 w-4" /> ยืนยันส่ง
                    </Button>
                    <Button
                      onClick={() => setShowConfirmSubmit(false)}
                      variant="outline"
                    >
                      ทำต่อ
                    </Button>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        )}
      </div>
    );
  }

  // --- RESULTS PHASE ---
  if (phase === "results") {
    const results = getResults();

    return (
      <div className="space-y-6">
        {/* Score Card */}
        <Card className="border-brand/20 bg-brand/5">
          <CardContent className="p-8 text-center">
            <h2 className="text-2xl font-bold mb-4">ผลการสอบ</h2>
            <p className="text-5xl font-bold text-brand mb-2">
              {results.correct} / {results.total}
            </p>
            <Badge
              className={`text-lg px-4 py-1 ${
                results.percentage >= 60
                  ? "bg-green-100 text-green-700"
                  : "bg-red-100 text-red-700"
              }`}
            >
              {results.percentage}%{" "}
              {results.percentage >= 80
                ? "ดีมาก!"
                : results.percentage >= 60
                  ? "ผ่านเกณฑ์"
                  : "ไม่ผ่านเกณฑ์"}
            </Badge>
            <p className="text-sm text-muted-foreground mt-3">
              เวลาที่ใช้: {formatTime(timeLimitMinutes * 60 - timeLeft)} /{" "}
              {formatTime(timeLimitMinutes * 60)}
            </p>
          </CardContent>
        </Card>

        {/* Percentile เทียบผู้ที่ทำ mock ประเภทเดียวกัน */}
        {cohort && (
          <MockRankCard
            state={
              rankResult && rankResult.attempt === attempt
                ? rankResult.state
                : { status: "loading" }
            }
            label={cohort.label}
            shareUrl={`https://www.morroo.com${cohort.path}`}
            loginNext={cohort.path}
            correct={results.correct}
            total={results.total}
          />
        )}

        {/* Upsell — shown only to visitors who haven't bought a plan yet */}
        {upsell && (
          <Card className="border-2 border-brand bg-gradient-to-br from-brand/10 to-transparent">
            <CardContent className="p-6 text-center space-y-3">
              <h3 className="text-xl font-bold">
                {results.percentage >= 80
                  ? "เก่งมาก! พร้อมลุยข้อสอบจริงหรือยัง?"
                  : results.percentage >= 60
                    ? "เกือบผ่านแล้ว ฝึกต่ออีกนิดก็เป๊ะ"
                    : "ยังมีจุดที่พลาดอยู่ ฝึกเพิ่มก่อนสอบจริงดีกว่า"}
              </h3>
              <p className="text-sm text-muted-foreground max-w-md mx-auto">
                นี่แค่ตัวอย่าง {results.total} ข้อ — สมัครสมาชิกฝึกได้ไม่จำกัด
                ครบทุกสาขา
                {upsell.totalQuestions
                  ? ` จากคลังข้อสอบกว่า ${upsell.totalQuestions.toLocaleString("th-TH")} ข้อ`
                  : ""}{" "}
                พร้อมเฉลยละเอียดทุกข้อ
              </p>
              <p className="text-sm font-semibold text-brand">
                เริ่มต้นเพียง {planIntroAmount("monthly")} บาท/เดือน
              </p>
              <Link
                href="/pricing"
                onClick={() =>
                  track("try_exam_upsell_cta_click", {
                    score_percentage: results.percentage,
                  })
                }
                className="inline-block"
              >
                <Button
                  size="lg"
                  className="bg-brand hover:bg-brand-light text-white gap-2"
                >
                  สมัครสมาชิกฝึกไม่จำกัด <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
            </CardContent>
          </Card>
        )}

        {/* Subject Breakdown */}
        <Card>
          <CardContent className="p-6">
            <h3 className="font-bold text-lg mb-4">คะแนนแยกตามสาขา</h3>
            <div className="space-y-3">
              {results.subjects.map((s) => {
                const pct =
                  s.total > 0 ? Math.round((s.correct / s.total) * 100) : 0;
                return (
                  <div key={s.subjectId} className="flex items-center gap-3">
                    <span className="text-lg w-8">{s.icon}</span>
                    <span className="flex-1 text-sm">{s.subjectName}</span>
                    <span className="text-sm font-medium">
                      {s.correct}/{s.total}
                    </span>
                    <Badge
                      variant="secondary"
                      className={`w-14 justify-center ${
                        pct >= 60
                          ? "bg-green-100 text-green-700"
                          : "bg-red-100 text-red-700"
                      }`}
                    >
                      {pct}%
                    </Badge>
                    <div className="w-24 bg-muted rounded-full h-2">
                      <div
                        className={`h-2 rounded-full transition-all ${
                          pct >= 60 ? "bg-green-500" : "bg-red-500"
                        }`}
                        style={{ width: `${pct}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>

        {/* Actions */}
        <div className="flex flex-wrap gap-3">
          <Button
            onClick={() => {
              setPhase("review");
              setReviewIndex(0);
              setShowExplanation(false);
            }}
            className="bg-brand hover:bg-brand-light text-white gap-2"
          >
            <CheckCircle className="h-4 w-4" /> ดูเฉลยทุกข้อ
          </Button>
          <Button onClick={handleRestart} variant="outline" className="gap-2">
            <RotateCcw className="h-4 w-4" /> สอบใหม่
          </Button>
        </div>
      </div>
    );
  }

  // --- REVIEW PHASE ---
  if (phase === "review") {
    const reviewQuestion = questions[reviewIndex];
    // เฉลยของข้อนี้ (โหมด token มาจาก response ของ /api/mcq/mock/submit)
    const reviewKey: McqMockReviewItem = review?.get(reviewQuestion.id) ?? {
      id: reviewQuestion.id,
      correct_answer: null,
      explanation: null,
      detailed_explanation: null,
    };
    const userAnswer = answers[reviewIndex];
    const isCorrect =
      userAnswer !== undefined && userAnswer === reviewKey.correct_answer;

    return (
      <div className="space-y-6">
        {/* Review Header */}
        <div className="flex items-center justify-between">
          <h3 className="font-bold">
            ทบทวนข้อ {reviewIndex + 1} / {questions.length}
          </h3>
          <div className="flex gap-2">
            <Badge
              variant="secondary"
              className={
                isCorrect
                  ? "bg-green-100 text-green-700"
                  : "bg-red-100 text-red-700"
              }
            >
              {isCorrect ? "ถูก" : "ผิด"}
            </Badge>
            {!userAnswer && (
              <Badge variant="secondary" className="bg-gray-100 text-gray-600">
                ไม่ได้ตอบ
              </Badge>
            )}
          </div>
        </div>

        {/* Subject Badge */}
        {reviewQuestion.mcq_subjects && (
          <Badge variant="secondary" className="text-xs">
            {reviewQuestion.mcq_subjects.icon}{" "}
            {reviewQuestion.mcq_subjects.name_th}
            {reviewQuestion.exam_source &&
              ` \u2022 ${reviewQuestion.exam_source}`}
          </Badge>
        )}

        {/* Question */}
        <Card>
          <CardContent className="p-6">
            <p className="text-base leading-relaxed whitespace-pre-line">
              {reviewQuestion.scenario}
            </p>
          </CardContent>
        </Card>

        {/* Choices - show correct/wrong */}
        <div className="space-y-3">
          {reviewQuestion.choices.map((choice) => {
            const isSelected = userAnswer === choice.label;
            const isChoiceCorrect =
              choice.label === reviewKey.correct_answer;

            let borderClass = "border-border opacity-60";
            let bgClass = "bg-white";

            if (isChoiceCorrect) {
              borderClass = "border-green-500";
              bgClass = "bg-green-50";
            } else if (isSelected && !isChoiceCorrect) {
              borderClass = "border-red-500";
              bgClass = "bg-red-50";
            }

            return (
              <div
                key={choice.label}
                className={`w-full text-left p-4 rounded-xl border-2 ${borderClass} ${bgClass}`}
              >
                <div className="flex items-start gap-3">
                  <span
                    className={`flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold ${
                      isChoiceCorrect
                        ? "bg-green-500 text-white"
                        : isSelected && !isChoiceCorrect
                          ? "bg-red-500 text-white"
                          : "bg-muted text-muted-foreground"
                    }`}
                  >
                    {isChoiceCorrect ? (
                      <CheckCircle className="h-5 w-5" />
                    ) : isSelected && !isChoiceCorrect ? (
                      <XCircle className="h-5 w-5" />
                    ) : (
                      choice.label
                    )}
                  </span>
                  <span className="text-sm leading-relaxed pt-1">
                    {choice.text}
                  </span>
                </div>
              </div>
            );
          })}
        </div>

        {/* Explanation */}
        {(reviewKey.detailed_explanation || reviewKey.explanation) && (
          <div>
            <button
              onClick={() => setShowExplanation(!showExplanation)}
              className="flex items-center gap-2 text-sm font-medium text-brand hover:underline"
            >
              {showExplanation ? (
                <ChevronUp className="h-4 w-4" />
              ) : (
                <ChevronDown className="h-4 w-4" />
              )}
              {showExplanation ? "ซ่อนคำอธิบาย" : "ดูเฉลยละเอียด"}
            </button>
            {showExplanation && (
              <div className="mt-3 space-y-4">
                {reviewKey.detailed_explanation ? (
                  <>
                    <Card className="border-green-300 bg-green-50/50">
                      <CardContent className="p-4">
                        <div className="flex items-start gap-2 mb-2">
                          <CheckCircle className="h-5 w-5 text-green-600 mt-0.5 flex-shrink-0" />
                          <h4 className="font-bold text-green-800">
                            คำตอบที่ถูกต้อง: {reviewKey.correct_answer}
                          </h4>
                        </div>
                        <p className="text-sm leading-relaxed text-green-900">
                          {reviewKey.detailed_explanation.summary}
                        </p>
                      </CardContent>
                    </Card>

                    <Card className="border-blue-200 bg-blue-50/30">
                      <CardContent className="p-4">
                        <h4 className="font-bold text-blue-800 mb-2">เหตุผลโดยละเอียด</h4>
                        <p className="text-sm leading-relaxed whitespace-pre-line text-foreground/80">
                          {reviewKey.detailed_explanation.reason}
                        </p>
                      </CardContent>
                    </Card>

                    <div>
                      <h4 className="font-bold text-sm mb-3">อธิบายแต่ละตัวเลือก</h4>
                      <div className="space-y-2">
                        {reviewKey.detailed_explanation.choices.map((ce) => (
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
                                <p className="text-muted-foreground mt-1 leading-relaxed">
                                  {ce.explanation}
                                </p>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>

                    {reviewKey.detailed_explanation.key_takeaway && (
                      <Card className="border-amber-200 bg-amber-50/30">
                        <CardContent className="p-4">
                          <h4 className="font-bold text-amber-800 mb-1 text-sm">สรุปจุดสำคัญ</h4>
                          <p className="text-sm leading-relaxed text-amber-900">
                            {reviewKey.detailed_explanation.key_takeaway}
                          </p>
                        </CardContent>
                      </Card>
                    )}
                  </>
                ) : (
                  <Card className="border-brand/20">
                    <CardContent className="p-4">
                      <p className="text-sm leading-relaxed whitespace-pre-line text-muted-foreground">
                        {reviewKey.explanation}
                      </p>
                    </CardContent>
                  </Card>
                )}
              </div>
            )}
          </div>
        )}

        {/* Report wrong answer */}
        <div className="pt-1">
          <ReportErrorButton
            questionId={reviewQuestion.id}
            choiceLabels={reviewQuestion.choices.map((c) => c.label)}
          />
        </div>

        {/* Review Navigation */}
        <div className="flex items-center justify-between">
          <Button
            onClick={() => {
              setReviewIndex((prev) => prev - 1);
              setShowExplanation(false);
            }}
            variant="outline"
            disabled={reviewIndex === 0}
            className="gap-2"
          >
            <ArrowLeft className="h-4 w-4" /> ข้อก่อนหน้า
          </Button>

          <div className="flex gap-2">
            <Button
              onClick={() => setPhase("results")}
              variant="outline"
              className="gap-2"
            >
              กลับหน้าผล
            </Button>

            {reviewIndex < questions.length - 1 && (
              <Button
                onClick={() => {
                  setReviewIndex((prev) => prev + 1);
                  setShowExplanation(false);
                }}
                className="bg-brand hover:bg-brand-light text-white gap-2"
              >
                ข้อถัดไป <ArrowRight className="h-4 w-4" />
              </Button>
            )}
          </div>
        </div>
      </div>
    );
  }

  return null;
}
