"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, X, RotateCcw, ArrowRight, HeartPulse, Trophy, Clock } from "lucide-react";
import { cn } from "@/lib/utils";
import {
  dashCard,
  textHeadline,
  textOverline,
  btnPrimary,
  btnGhost,
  btnMd,
  btnLg,
  btnSm,
  btnBlock,
} from "@/components/courses/course-ui";
import { playMetronomeClick, playBeep, initAudio } from "@/lib/courses/bls/sound";
import { getStageById, saveStageProgress, DEFAULT_TIME_LIMIT_SEC } from "@/lib/courses/bls/scenarios";

const CPR_DRILL_SEC = 30;
const CPR_BPM = 110;
const POINTS_CORRECT = 10;
const POINTS_SPEED_BONUS = 5;
const POINTS_WRONG = -5;
const POINTS_TIMEOUT = -5;

export interface BlsScenarioPlayerProps {
  stageId: string;
}

export default function BlsScenarioPlayer({ stageId }: BlsScenarioPlayerProps) {
  const router = useRouter();
  // Memoize by stageId so the shuffled option order (and the final exam's
  // sampled steps) is computed once per stage and stays stable while the
  // student plays — re-renders on each answer must not reshuffle mid-question.
  const scenario = useMemo(() => getStageById(stageId), [stageId]);
  const steps = useMemo(() => scenario?.steps ?? [], [scenario]);

  const [stepIdx, setStepIdx] = useState(0);
  const [picked, setPicked] = useState<number | null>(null); // option index the student clicked
  const [locked, setLocked] = useState(false); // step answered (right/wrong/timeout) — no retry
  const [timedOut, setTimedOut] = useState(false);
  const [timeLeft, setTimeLeft] = useState(0);
  const [points, setPoints] = useState(0);
  const [correctCount, setCorrectCount] = useState(0);
  const [finished, setFinished] = useState(false);

  // Embedded CPR metronome drill
  const [drillActive, setDrillActive] = useState(false);
  const [drillDone, setDrillDone] = useState(false);
  const [drillLeft, setDrillLeft] = useState(CPR_DRILL_SEC);
  const [pulse, setPulse] = useState(false);
  const beatRef = useRef<number | undefined>(undefined);
  const countRef = useRef<number | undefined>(undefined);
  const timerRef = useRef<number | undefined>(undefined);

  const step = steps[stepIdx];
  const isLast = stepIdx === steps.length - 1;
  const stepTimeLimit = step?.timeLimitSec || DEFAULT_TIME_LIMIT_SEC;

  // Per-step countdown timer — starts fresh whenever stepIdx changes. Uses a
  // local counter (not React state) to decide when time's up, so a stale
  // `timeLeft` read from a prior render/step can never trigger a false
  // auto-lock — only this step's own interval can lock this step.
  useEffect(() => {
    if (!step || locked) return;
    let remaining = stepTimeLimit;
    setTimeLeft(remaining);
    timerRef.current = window.setInterval(() => {
      remaining -= 1;
      if (remaining <= 0) {
        clearInterval(timerRef.current);
        setTimeLeft(0);
        setLocked(true);
        setTimedOut(true);
        setPoints((p) => p + POINTS_TIMEOUT);
      } else {
        setTimeLeft(remaining);
      }
    }, 1000);
    return () => clearInterval(timerRef.current);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stepIdx]);

  // Metronome + countdown while the CPR drill is running
  useEffect(() => {
    if (!drillActive) return;
    initAudio();
    beatRef.current = window.setInterval(() => {
      playMetronomeClick();
      setPulse((p) => !p);
    }, 60000 / CPR_BPM);
    countRef.current = window.setInterval(() => {
      setDrillLeft((s) => {
        if (s <= 1) {
          clearInterval(beatRef.current);
          clearInterval(countRef.current);
          playBeep(660, 0.25, 0.3);
          setDrillActive(false);
          setDrillDone(true);
          return 0;
        }
        return s - 1;
      });
    }, 1000);
    return () => {
      clearInterval(beatRef.current);
      clearInterval(countRef.current);
    };
  }, [drillActive]);

  const pickOption = (i: number) => {
    if (locked || !step) return;
    clearInterval(timerRef.current);
    const opt = step.options[i];
    setPicked(i);
    setLocked(true);
    if (opt.correct) {
      setCorrectCount((c) => c + 1);
      const bonus = timeLeft > stepTimeLimit / 2 ? POINTS_SPEED_BONUS : 0;
      setPoints((p) => p + POINTS_CORRECT + bonus);
      if (step.cprDrill) {
        setDrillLeft(CPR_DRILL_SEC);
        setDrillDone(false);
        setDrillActive(true);
      }
    } else {
      setPoints((p) => p + POINTS_WRONG);
    }
  };

  const skipDrill = () => {
    clearInterval(beatRef.current);
    clearInterval(countRef.current);
    setDrillActive(false);
    setDrillDone(true);
  };

  const nextStep = () => {
    if (isLast) {
      setFinished(true);
      return;
    }
    setStepIdx((i) => i + 1);
    setPicked(null);
    setLocked(false);
    setTimedOut(false);
    setDrillActive(false);
    setDrillDone(false);
    setDrillLeft(CPR_DRILL_SEC);
  };

  const restart = () => {
    setStepIdx(0);
    setPicked(null);
    setLocked(false);
    setTimedOut(false);
    setPoints(0);
    setCorrectCount(0);
    setFinished(false);
    setDrillActive(false);
    setDrillDone(false);
    setDrillLeft(CPR_DRILL_SEC);
  };

  const drillPending = Boolean(locked && step?.cprDrill && !drillDone);

  const total = steps.length;
  const finalPct = total > 0 ? Math.round((correctCount / total) * 100) : 0;
  const finalPassed = finalPct >= (scenario?.passScore ?? 80);

  // Persist the result once, the moment the student reaches the score screen.
  useEffect(() => {
    if (finished && scenario) {
      saveStageProgress(scenario.id, { pct: finalPct, points, passed: finalPassed });
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [finished]);

  if (!scenario) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-16 text-center">
        <div className="text-sm text-muted-foreground">ไม่พบด่านนี้</div>
        <button onClick={() => router.push("/bls/scenario")} className={cn(btnPrimary, btnMd)}>
          กลับไปเลือกด่าน
        </button>
      </div>
    );
  }

  if (finished) {
    const pct = finalPct;
    const passed = finalPassed;

    return (
      <div className="mx-auto max-w-md space-y-5 text-center">
        <div
          className={cn(
            "mx-auto flex h-16 w-16 items-center justify-center rounded-2xl text-white shadow-lg",
            passed
              ? "bg-gradient-to-br from-emerald-500 to-emerald-700"
              : "bg-gradient-to-br from-amber-500 to-amber-600",
          )}
        >
          <Trophy size={28} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-2xl font-bold text-foreground">{passed ? "ผ่าน! 🎉" : "ลองอีกครั้งนะ"}</h1>
          <p className="mt-1 text-sm text-muted-foreground">{scenario.title}</p>
        </div>

        <div className={cn(dashCard, "grid grid-cols-2 gap-3")}>
          <div>
            <div className={cn(textOverline, "mb-1")}>ตอบถูก</div>
            <div
              className={cn(
                "text-4xl font-bold tabular-nums",
                passed ? "text-emerald-600" : "text-amber-600",
              )}
            >
              {correctCount}/{total}
            </div>
            <div className="mt-1 text-xs text-muted-foreground">
              {pct}% (เกณฑ์ผ่าน {scenario.passScore}%)
            </div>
          </div>
          <div>
            <div className={cn(textOverline, "mb-1")}>แต้มสะสม</div>
            <div className="text-4xl font-bold tabular-nums text-sky-600">{points}</div>
            <div className="mt-1 text-xs text-muted-foreground">คะแนน</div>
          </div>
        </div>

        <div className={cn(dashCard, "space-y-2 p-4 text-left")}>
          <div className={cn(textOverline, "mb-2")}>ทบทวนลำดับขั้นที่ถูกต้อง</div>
          <ol className="space-y-1.5">
            {steps.map((s, i) => {
              const right = s.options.find((o) => o.correct);
              return (
                <li key={i} className="flex gap-2 text-xs text-muted-foreground">
                  <span className="shrink-0 font-bold text-emerald-600">{i + 1}.</span>
                  <span>{right?.label}</span>
                </li>
              );
            })}
          </ol>
        </div>

        <div className="space-y-2">
          <button onClick={restart} className={cn(btnPrimary, btnLg, btnBlock)}>
            <RotateCcw size={16} strokeWidth={2.2} /> เล่นอีกครั้ง
          </button>
          <button onClick={() => router.push("/bls/scenario")} className={cn(btnGhost, btnBlock)}>
            กลับไปเลือกด่าน
          </button>
        </div>
      </div>
    );
  }

  if (!step) return null;

  const timeUrgent = timeLeft <= 5;

  return (
    <div className="space-y-4">
      <div className="space-y-2">
        <div className="flex items-center gap-3">
          <div className={cn(textHeadline, "flex min-w-0 flex-1 items-center gap-2")}>
            <HeartPulse size={20} className="shrink-0 text-sky-600" />
            <span className="truncate">{scenario.title}</span>
          </div>
          {!locked && (
            <div
              className={cn(
                "flex shrink-0 items-center gap-1 text-sm font-bold tabular-nums",
                timeUrgent ? "text-red-600" : "text-muted-foreground",
              )}
            >
              <Clock size={16} strokeWidth={2.4} /> {timeLeft}s
            </div>
          )}
        </div>
        {/* Progress bar */}
        <div className="h-1 overflow-hidden rounded-full bg-muted">
          <div
            className="h-full bg-sky-500 transition-all"
            style={{ width: `${((stepIdx + (locked ? 1 : 0)) / steps.length) * 100}%` }}
          />
        </div>
      </div>

      <div className={cn(textOverline, "flex items-center justify-between")}>
        <span>
          ขั้นที่ {stepIdx + 1} / {steps.length} · {scenario.subtitle}
        </span>
        <span className="text-sky-600">{points} แต้ม</span>
      </div>

      {/* Situation */}
      <div className={dashCard}>
        <div className="text-sm leading-relaxed text-muted-foreground">{step.situation}</div>
        <div className="mt-3 text-base font-bold text-foreground">{step.question}</div>
      </div>

      {timedOut && (
        <div className="py-1 text-center text-sm font-bold text-red-600">
          ⏱ หมดเวลา — ดูเฉลยด้านล่าง
        </div>
      )}

      {/* Options */}
      <div className="space-y-2">
        {step.options.map((opt, i) => {
          const isPicked = picked === i;
          const showState = isPicked || (locked && Boolean(opt.correct));
          return (
            <button
              key={i}
              onClick={() => pickOption(i)}
              disabled={locked}
              className={cn(
                dashCard,
                "flex w-full items-start gap-3 py-3 text-left transition-all disabled:cursor-default",
                showState
                  ? opt.correct
                    ? "bg-emerald-500/10 ring-2 ring-emerald-500"
                    : "bg-red-500/10 ring-2 ring-red-500"
                  : "hover:bg-muted",
              )}
            >
              <span
                className={cn(
                  "mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full text-white",
                  showState ? (opt.correct ? "bg-emerald-600" : "bg-red-600") : "bg-muted",
                )}
              >
                {showState ? (
                  opt.correct ? (
                    <Check size={14} strokeWidth={3} />
                  ) : (
                    <X size={14} strokeWidth={3} />
                  )
                ) : (
                  <span className="text-xs font-bold text-muted-foreground">
                    {String.fromCharCode(65 + i)}
                  </span>
                )}
              </span>
              <span className="flex-1">
                <span className="text-sm font-semibold leading-snug text-foreground">{opt.label}</span>
                {(isPicked || (locked && opt.correct)) && (
                  <span
                    className={cn(
                      "mt-1 block text-xs leading-snug",
                      opt.correct ? "text-emerald-600" : "text-red-600",
                    )}
                  >
                    {opt.feedback}
                  </span>
                )}
              </span>
            </button>
          );
        })}
      </div>

      {/* Embedded CPR metronome drill */}
      {drillPending && (
        <div className="space-y-3 rounded-xl bg-red-500/10 p-4 text-center">
          <div className="text-sm font-bold text-red-600">🫀 กดหน้าอกตามจังหวะ — {CPR_BPM}/นาที</div>
          <div
            className="mx-auto flex h-24 w-24 items-center justify-center rounded-full bg-gradient-to-br from-red-600 to-red-800 text-white shadow-lg transition-transform"
            style={{ transform: pulse ? "scale(1.12)" : "scale(0.96)" }}
          >
            <span className="text-3xl font-bold tabular-nums">{drillLeft}</span>
          </div>
          <div className="text-xs text-muted-foreground">กดลึกตามเกณฑ์ของบทนี้ ปล่อยให้อกคืนตัวสุด</div>
          <button onClick={skipDrill} className={cn(btnGhost, btnSm)}>
            ข้าม
          </button>
        </div>
      )}

      {/* Next */}
      {locked && !drillPending && (
        <button onClick={nextStep} className={cn(btnPrimary, btnLg, btnBlock)}>
          {isLast ? "ดูผลสรุป" : "ถัดไป"} <ArrowRight size={16} strokeWidth={2.2} />
        </button>
      )}
    </div>
  );
}
