"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import {
  ArrowRight, Check, ChevronLeft, Clock, HeartPulse, Lock, RotateCcw, Trophy, X,
} from "lucide-react";
import {
  BLS_FINAL_ID,
  DEFAULT_TIME_LIMIT_SEC,
  getStageById,
  isBlsStageUnlocked,
  isFinalUnlocked,
  type BlsStage,
} from "@/lib/firstaid/content/blsGame";
import { initBlsAudio, playCorrect, playMetronomeClick, playWrong } from "@/lib/firstaid/blsAudio";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { useEnsureProgress } from "@/lib/firstaid/hooks/useProgress";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import { pushProgress, useProgressStore } from "@/lib/firstaid/stores/progressStore";
import { track } from "@/lib/firstaid/analytics";

const CPR_DRILL_SEC = 30;
const CPR_BPM = 110;
const POINTS_CORRECT = 10;
const POINTS_SPEED_BONUS = 5;
const POINTS_WRONG = -5;

export default function BlsStageRunner({ stageId }: { stageId: string }) {
  useEnsureLearner();
  const learner = useLearnerStore((s) => s.learner);
  useEnsureProgress(learner?.id);
  const passedScenarioIds = useProgressStore((s) => s.passedScenarioIds);
  const progressLoaded = useProgressStore((s) => s.loaded);

  // โหลดด่านหลัง mount เท่านั้น — getStageById สลับตัวเลือกแบบสุ่ม
  // ถ้ารันตอน SSR ลำดับ server/client จะไม่ตรงกัน (hydration mismatch)
  const [stage, setStage] = useState<BlsStage | null | undefined>(undefined);
  useEffect(() => {
    setStage(getStageById(stageId));
  }, [stageId]);

  const [stepIdx, setStepIdx] = useState(0);
  const [picked, setPicked] = useState<number | null>(null);
  const [locked, setLocked] = useState(false); // ตอบแล้ว (ถูก/ผิด/หมดเวลา) — ไม่มี retry
  const [timedOut, setTimedOut] = useState(false);
  const [timeLeft, setTimeLeft] = useState(0);
  const [points, setPoints] = useState(0);
  const [correctCount, setCorrectCount] = useState(0);
  const [finished, setFinished] = useState(false);

  // CPR metronome drill ฝังในด่าน
  const [drillActive, setDrillActive] = useState(false);
  const [drillDone, setDrillDone] = useState(false);
  const [drillLeft, setDrillLeft] = useState(CPR_DRILL_SEC);
  const beatRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const countRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);
  const savedRef = useRef(false);

  const steps = stage?.steps ?? [];
  const step = steps[stepIdx];
  const isLast = stepIdx === steps.length - 1;
  const stepTimeLimit = step?.timeLimitSec || DEFAULT_TIME_LIMIT_SEC;

  useEffect(() => {
    if (stage) track("bls_stage_start", { stage_id: stage.id });
  }, [stage]);

  // จับเวลาต่อข้อ — ใช้ตัวนับ local ไม่อ่าน state เก่า กัน stale timer ล็อกข้ามข้อ
  useEffect(() => {
    if (!step || locked || finished) return undefined;
    let remaining = stepTimeLimit;
    setTimeLeft(remaining);
    timerRef.current = setInterval(() => {
      remaining -= 1;
      if (remaining <= 0) {
        if (timerRef.current) clearInterval(timerRef.current);
        setTimeLeft(0);
        setLocked(true);
        setTimedOut(true);
        setPoints((p) => p + POINTS_WRONG);
        playWrong();
      } else {
        setTimeLeft(remaining);
      }
    }, 1000);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stepIdx, stage]);

  // metronome + นับถอยหลังระหว่าง drill
  useEffect(() => {
    if (!drillActive) return undefined;
    initBlsAudio();
    beatRef.current = setInterval(() => playMetronomeClick(), 60000 / CPR_BPM);
    countRef.current = setInterval(() => {
      setDrillLeft((s) => {
        if (s <= 1) {
          if (beatRef.current) clearInterval(beatRef.current);
          if (countRef.current) clearInterval(countRef.current);
          playCorrect();
          setDrillActive(false);
          setDrillDone(true);
          return 0;
        }
        return s - 1;
      });
    }, 1000);
    return () => {
      if (beatRef.current) clearInterval(beatRef.current);
      if (countRef.current) clearInterval(countRef.current);
    };
  }, [drillActive]);

  const total = steps.length;
  const finalPct = total > 0 ? Math.round((correctCount / total) * 100) : 0;
  const finalPassed = finalPct >= (stage?.passScore ?? 80);

  // บันทึกผลครั้งเดียวตอนถึงจอสรุป — optimistic ใน store + fire-and-forget ขึ้น server
  useEffect(() => {
    if (!finished || !stage || savedRef.current) return;
    savedRef.current = true;
    if (finalPassed) {
      useProgressStore.getState().markScenarioPassed(stage.id);
    }
    if (learner?.id) {
      pushProgress({
        learnerId: learner.id,
        simulationRun: {
          uuid: crypto.randomUUID(),
          scenarioId: stage.id,
          endingId: finalPassed ? "pass" : "fail",
          passed: finalPassed,
          finishedAt: new Date().toISOString(),
        },
      });
    }
    track("bls_stage_complete", {
      stage_id: stage.id,
      passed: finalPassed,
      pct: finalPct,
      points,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [finished]);

  function pickOption(i: number) {
    if (locked || !step) return;
    initBlsAudio(); // ปลดล็อกเสียงจาก user gesture แรก
    if (timerRef.current) clearInterval(timerRef.current);
    const opt = step.options[i];
    setPicked(i);
    setLocked(true);
    if (opt.correct) {
      playCorrect();
      setCorrectCount((c) => c + 1);
      const bonus = timeLeft > stepTimeLimit / 2 ? POINTS_SPEED_BONUS : 0;
      setPoints((p) => p + POINTS_CORRECT + bonus);
      if (step.cprDrill) {
        setDrillLeft(CPR_DRILL_SEC);
        setDrillDone(false);
        setDrillActive(true);
      }
    } else {
      playWrong();
      setPoints((p) => p + POINTS_WRONG);
    }
  }

  function skipDrill() {
    if (beatRef.current) clearInterval(beatRef.current);
    if (countRef.current) clearInterval(countRef.current);
    setDrillActive(false);
    setDrillDone(true);
  }

  function nextStep() {
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
  }

  function restart() {
    savedRef.current = false;
    setStage(getStageById(stageId)); // สลับตัวเลือกใหม่รอบใหม่
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
  }

  // ---- จอสถานะพิเศษ ----
  if (stage === undefined || !progressLoaded) {
    return (
      <div className="page-container" style={{ textAlign: "center", paddingTop: 80 }}>
        <div className="text-caption">กำลังโหลด…</div>
      </div>
    );
  }

  if (stage === null) {
    return (
      <div className="page-container" style={{ textAlign: "center", paddingTop: 80 }}>
        <div className="text-body">ไม่พบด่านนี้</div>
        <Link href="/bls" className="btn btn-primary" style={{ marginTop: 16 }}>
          กลับไปเลือกด่าน
        </Link>
      </div>
    );
  }

  // กันเข้าด่านล็อกตรงๆ ทาง URL (เช็คหลัง progress โหลดแล้วเท่านั้น กันล็อกหลอก)
  const unlocked =
    stage.id === BLS_FINAL_ID
      ? isFinalUnlocked(passedScenarioIds)
      : isBlsStageUnlocked(stage.stageNumber, passedScenarioIds);
  if (!unlocked) {
    return (
      <div className="page-container" style={{ textAlign: "center", paddingTop: 80 }}>
        <Lock size={40} style={{ margin: "0 auto 12px", color: "var(--color-text-muted)" }} />
        <div className="text-headline">ด่านนี้ยังล็อกอยู่</div>
        <p className="text-caption" style={{ marginTop: 6 }}>
          ต้องผ่านด่านก่อนหน้าก่อนจึงจะเล่นด่านนี้ได้
        </p>
        <Link href="/bls" className="btn btn-primary" style={{ marginTop: 16 }}>
          กลับไปเลือกด่าน
        </Link>
      </div>
    );
  }

  // ---- จอสรุปผล ----
  if (finished) {
    return (
      <div className="page-container" style={{ paddingTop: 40 }}>
        <div style={{ maxWidth: 480, margin: "0 auto", textAlign: "center" }}>
          <div
            style={{
              width: 64, height: 64, margin: "0 auto 14px",
              display: "flex", alignItems: "center", justifyContent: "center",
              color: "#fff", borderRadius: "var(--radius-2xl)",
              background: finalPassed
                ? "linear-gradient(135deg, var(--color-success), #047857)"
                : "linear-gradient(135deg, var(--color-warning), #B45309)",
              boxShadow: "0 8px 20px rgba(5,150,105,.28)",
            }}
          >
            <Trophy size={28} strokeWidth={2.2} />
          </div>
          <h1 className="text-title">{finalPassed ? "ผ่าน! 🎉" : "ลองอีกครั้งนะ"}</h1>
          <p className="text-caption" style={{ marginTop: 4 }}>{stage.title}</p>

          <div className="card" style={{ marginTop: 16, display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
            <div>
              <div className="text-caption">ตอบถูก</div>
              <div style={{ fontSize: 34, fontWeight: 800, color: finalPassed ? "var(--color-success)" : "var(--color-warning)" }}>
                {correctCount}/{total}
              </div>
              <div className="text-caption">{finalPct}% (เกณฑ์ผ่าน {stage.passScore}%)</div>
            </div>
            <div>
              <div className="text-caption">แต้มสะสม</div>
              <div style={{ fontSize: 34, fontWeight: 800, color: "var(--color-info)" }}>{points}</div>
              <div className="text-caption">คะแนน</div>
            </div>
          </div>

          <div className="card" style={{ marginTop: 12, textAlign: "left" }}>
            <div className="text-caption" style={{ marginBottom: 8 }}>ทบทวนลำดับขั้นที่ถูกต้อง</div>
            <ol style={{ listStyle: "none", display: "flex", flexDirection: "column", gap: 6 }}>
              {steps.map((s, i) => {
                const right = s.options.find((o) => o.correct);
                return (
                  <li key={i} style={{ fontSize: 12.5, color: "var(--color-text-secondary)", display: "flex", gap: 8 }}>
                    <span style={{ color: "var(--color-success)", fontWeight: 700, flexShrink: 0 }}>{i + 1}.</span>
                    <span>{right?.label}</span>
                  </li>
                );
              })}
            </ol>
          </div>

          <div style={{ marginTop: 16, display: "flex", flexDirection: "column", gap: 8 }}>
            <button onClick={restart} className="btn btn-primary btn-lg btn-block">
              <RotateCcw size={16} strokeWidth={2.2} /> เล่นอีกครั้ง
            </button>
            <Link href="/bls" className="btn btn-ghost btn-block">กลับไปเลือกด่าน</Link>
          </div>
        </div>
      </div>
    );
  }

  // ---- จอเล่นเกม ----
  const drillPending = locked && !!step?.cprDrill && !drillDone && picked !== null && step.options[picked]?.correct;
  const timeUrgent = timeLeft <= 5;

  return (
    <div className="page-container">
      {/* หัวด่าน + เวลา */}
      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
        <Link
          href="/bls"
          aria-label="กลับ"
          style={{ width: 36, height: 36, display: "inline-flex", alignItems: "center", justifyContent: "center", borderRadius: "var(--radius-full)" }}
        >
          <ChevronLeft size={20} />
        </Link>
        <div className="text-headline" style={{ flex: 1, minWidth: 0, display: "flex", alignItems: "center", gap: 8 }}>
          <HeartPulse size={18} style={{ color: "var(--color-danger)", flexShrink: 0 }} />
          <span style={{ overflow: "hidden", textOverflow: "ellipsis", whiteSpace: "nowrap" }}>{stage.title}</span>
        </div>
        {!locked && (
          <div
            className={timeUrgent ? "bls-timer-urgent" : undefined}
            style={{ display: "flex", alignItems: "center", gap: 4, fontWeight: 700, fontVariantNumeric: "tabular-nums", color: "var(--color-text-muted)", flexShrink: 0 }}
          >
            <Clock size={16} strokeWidth={2.4} /> {timeLeft}s
          </div>
        )}
      </div>

      <div className="progress-track" style={{ marginBottom: 14 }}>
        <div className="progress-bar" style={{ width: `${((stepIdx + (locked ? 1 : 0)) / total) * 100}%` }} />
      </div>

      <div className="text-caption" style={{ display: "flex", justifyContent: "space-between", marginBottom: 8 }}>
        <span>ขั้นที่ {stepIdx + 1} / {total}{step?.sourceStage ? ` · ${step.sourceStage}` : ` · ${stage.subtitle}`}</span>
        <span style={{ color: "var(--color-info)", fontWeight: 700 }}>{points} แต้ม</span>
      </div>

      {/* สถานการณ์ */}
      <div className="card">
        <div className="text-body" style={{ color: "var(--color-text-secondary)" }}>{step?.situation}</div>
        <div className="text-body-strong" style={{ marginTop: 10 }}>{step?.question}</div>
      </div>

      {timedOut && (
        <div style={{ textAlign: "center", fontWeight: 700, color: "var(--color-danger)", padding: "8px 0" }}>
          ⏱ หมดเวลา — ดูเฉลยด้านล่าง
        </div>
      )}

      {/* ตัวเลือก */}
      <div style={{ display: "flex", flexDirection: "column", gap: 8, marginTop: 12 }}>
        {step?.options.map((opt, i) => {
          const isPicked = picked === i;
          const showState = isPicked || (locked && opt.correct);
          return (
            <button
              key={i}
              onClick={() => pickOption(i)}
              disabled={locked}
              className="card"
              style={{
                textAlign: "left", display: "flex", gap: 10, alignItems: "flex-start",
                cursor: locked ? "default" : "pointer", padding: 12,
                borderColor: showState ? (opt.correct ? "var(--color-success)" : "var(--color-danger)") : undefined,
                borderWidth: showState ? 2 : 1,
                background: showState
                  ? opt.correct ? "#ECFDF5" : "#FEF2F2"
                  : "var(--color-bg-secondary)",
              }}
            >
              <span
                style={{
                  width: 24, height: 24, flexShrink: 0, marginTop: 2,
                  display: "inline-flex", alignItems: "center", justifyContent: "center",
                  borderRadius: "50%", color: "#fff", fontSize: 12, fontWeight: 700,
                  background: showState
                    ? opt.correct ? "var(--color-success)" : "var(--color-danger)"
                    : "var(--color-bg-tertiary)",
                }}
              >
                {showState ? (
                  opt.correct ? <Check size={14} strokeWidth={3} /> : <X size={14} strokeWidth={3} />
                ) : (
                  <span style={{ color: "var(--color-text-muted)" }}>{String.fromCharCode(65 + i)}</span>
                )}
              </span>
              <span style={{ flex: 1 }}>
                <span className="text-body-strong" style={{ display: "block", lineHeight: 1.4 }}>{opt.label}</span>
                {showState && (
                  <span
                    style={{
                      display: "block", fontSize: 12.5, marginTop: 4, lineHeight: 1.45,
                      color: opt.correct ? "var(--color-success)" : "var(--color-danger)",
                    }}
                  >
                    {opt.feedback}
                  </span>
                )}
              </span>
            </button>
          );
        })}
      </div>

      {/* CPR metronome drill */}
      {drillPending && (
        <div className="card" style={{ marginTop: 12, textAlign: "center", background: "#FEF2F2" }}>
          <div style={{ fontWeight: 700, color: "var(--color-danger)", marginBottom: 10 }}>
            🫀 กดหน้าอกตามจังหวะ — {CPR_BPM}/นาที
          </div>
          <div className="bls-metronome">{drillLeft}</div>
          <div className="text-caption" style={{ marginTop: 10 }}>
            กดลึกตามเกณฑ์ของบทนี้ ปล่อยให้อกคืนตัวสุด
          </div>
          <button onClick={skipDrill} className="btn btn-ghost" style={{ marginTop: 4 }}>ข้าม</button>
        </div>
      )}

      {/* ถัดไป */}
      {locked && !drillPending && (
        <button onClick={nextStep} className="btn btn-primary btn-lg btn-block" style={{ marginTop: 14 }}>
          {isLast ? "ดูผลสรุป" : "ถัดไป"} <ArrowRight size={16} strokeWidth={2.2} />
        </button>
      )}
    </div>
  );
}
