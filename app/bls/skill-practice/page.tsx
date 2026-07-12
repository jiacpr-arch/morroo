"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { Play, Pause, RotateCcw, HeartPulse, Wind, Brain } from "lucide-react";
import { cn } from "@/lib/utils";
import { dashCard, textOverline } from "@/components/courses/course-ui";
import { playMetronomeClick, playBeep } from "@/lib/courses/bls/sound";
import ChecklistItem from "@/components/courses/bls/ChecklistItem";
import BlsScenarioStageGrid from "@/components/courses/bls/BlsScenarioStageGrid";

const TARGET_RATE = 110; // กลางช่วง 100–120
const RATE_LOW = 100;
const RATE_HIGH = 120;
const CYCLE_TARGET_SEC = 120; // 2 นาที = 1 cycle เปลี่ยนคนกด
const BREATH_PAUSE_MS = 5000; // pause หลังครบ 30 ครั้ง เพื่อช่วยหายใจ 2 ครั้ง

export default function BlsSkillPracticePage() {
  const [running, setRunning] = useState(false);
  const [metronomeOn, setMetronomeOn] = useState(true);
  const [rate, setRate] = useState(TARGET_RATE); // bpm ที่ตั้งไว้
  const [tapCount, setTapCount] = useState(0);
  const [elapsed, setElapsed] = useState(0);
  const [actualBpm, setActualBpm] = useState<number | null>(null);
  const [ratio302, setRatio302] = useState(true); // BLS-HCP default: 30:2 ช่วยหายใจ
  const [breathAlert, setBreathAlert] = useState(false);
  const [breathPauseStartedAt, setBreathPauseStartedAt] = useState<number | null>(null);
  const [breathTickNow, setBreathTickNow] = useState(0);
  const breathPauseRef = useRef(false);
  const beatCountRef = useRef(0);
  const tapTimesRef = useRef<number[]>([]);
  const elapsedTimerRef = useRef<number | undefined>(undefined);
  const metronomeTimerRef = useRef<number | undefined>(undefined);

  // Metronome — pause ทุก 30 ครั้ง 5 วินาทีเมื่อโหมด 30:2 เปิดอยู่
  useEffect(() => {
    if (!running || !metronomeOn) {
      clearInterval(metronomeTimerRef.current);
      return;
    }
    const intervalMs = 60000 / rate;
    metronomeTimerRef.current = window.setInterval(() => {
      if (breathPauseRef.current) return;
      playMetronomeClick();
      if (ratio302) {
        beatCountRef.current += 1;
        if (beatCountRef.current >= 30) {
          beatCountRef.current = 0;
          breathPauseRef.current = true;
          setBreathAlert(true);
          setBreathPauseStartedAt(Date.now());
          playBeep(523, 0.3, 0.3);
        }
      }
    }, intervalMs);
    return () => clearInterval(metronomeTimerRef.current);
  }, [running, metronomeOn, rate, ratio302]);

  // Resume after breath pause + tick clock for countdown display
  useEffect(() => {
    if (!breathPauseStartedAt) return;
    const iv = window.setInterval(() => {
      const now = Date.now();
      setBreathTickNow(now);
      if (now - breathPauseStartedAt >= BREATH_PAUSE_MS) {
        breathPauseRef.current = false;
        setBreathAlert(false);
        setBreathPauseStartedAt(null);
      }
    }, 100);
    return () => clearInterval(iv);
  }, [breathPauseStartedAt]);

  // Reset beat count when ratio mode flips or run stops
  useEffect(() => {
    beatCountRef.current = 0;
    breathPauseRef.current = false;
    setBreathAlert(false);
    setBreathPauseStartedAt(null);
  }, [ratio302, running]);

  // Elapsed timer
  useEffect(() => {
    if (!running) {
      clearInterval(elapsedTimerRef.current);
      return;
    }
    elapsedTimerRef.current = window.setInterval(() => {
      setElapsed((e) => e + 1);
    }, 1000);
    return () => clearInterval(elapsedTimerRef.current);
  }, [running]);

  const handleTap = () => {
    if (!running) return;
    const now = performance.now();
    const tapTimes = [...tapTimesRef.current, now].slice(-8);
    tapTimesRef.current = tapTimes;
    setTapCount((c) => c + 1);
    if (tapTimes.length >= 2) {
      const intervals: number[] = [];
      for (let i = 1; i < tapTimes.length; i++) intervals.push(tapTimes[i] - tapTimes[i - 1]);
      const avgInterval = intervals.reduce((a, b) => a + b, 0) / intervals.length;
      setActualBpm(Math.round(60000 / avgInterval));
    }
  };

  const handleReset = () => {
    setRunning(false);
    setTapCount(0);
    setElapsed(0);
    setActualBpm(null);
    tapTimesRef.current = [];
  };

  const fmtTime = (s: number) => {
    const m = Math.floor(s / 60);
    const r = s % 60;
    return `${m}:${String(r).padStart(2, "0")}`;
  };

  const bpmInZone = actualBpm != null && actualBpm >= RATE_LOW && actualBpm <= RATE_HIGH;
  const cycleProgress = Math.min((elapsed / CYCLE_TARGET_SEC) * 100, 100);
  const cycleDue = elapsed > 0 && elapsed % CYCLE_TARGET_SEC === 0;

  return (
    <div className="mx-auto max-w-2xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">ฝึก CPR (Skill Practice)</span>
      </nav>

      <header className="mb-6">
        <h1 className="flex items-center gap-2 text-2xl font-bold leading-snug sm:text-3xl">
          <HeartPulse size={24} className="text-sky-600" />
          ฝึก CPR (Skill Practice)
        </h1>
      </header>

      <div className="space-y-4">
        {/* Description */}
        <div className={dashCard}>
          <div className="text-sm leading-relaxed text-muted-foreground">
            ฝึกอัตราการกดหน้าอก <b>100–120 ครั้ง/นาที</b> ตามมาตรฐาน BLS (ILCOR 2025)
            <br />
            กดปุ่ม <b>เริ่ม</b> เพื่อเปิด metronome → แตะปุ่มใหญ่ตามจังหวะที่กดจริง → ตรวจสอบ BPM ของตัวเอง
            <br />
            เปลี่ยนคนกดทุก <b>2 นาที</b> เพื่อรักษาคุณภาพ
          </div>
        </div>

        {/* Decision-game — embedded directly instead of linking out to a separate hub */}
        <div className="space-y-3 pt-1">
          <div className="flex items-center gap-2 px-1">
            <Brain size={16} strokeWidth={2.2} className="shrink-0 text-sky-600" />
            <div className={textOverline}>เกมลำดับขั้นตัดสินใจ · 8 ด่าน + ข้อสอบรวม</div>
          </div>
          <BlsScenarioStageGrid />
        </div>

        {/* Breath alert banner */}
        {breathAlert && (
          <div className="flex w-full animate-pulse items-center justify-center gap-2 rounded-lg bg-sky-500 py-3 text-center text-base font-bold text-white">
            <Wind size={18} /> ช่วยหายใจ 2 ครั้ง — หยุดกด{" "}
            {breathPauseStartedAt && (
              <span className="font-mono">
                {Math.max(
                  0,
                  Math.ceil(
                    (BREATH_PAUSE_MS - ((breathTickNow || breathPauseStartedAt) - breathPauseStartedAt)) /
                      1000,
                  ),
                )}
                s
              </span>
            )}
          </div>
        )}

        {/* 30:2 mode toggle */}
        <ChecklistItem
          checked={ratio302}
          onClick={() => setRatio302(!ratio302)}
          tone="info"
          label="🌬️ โหมด 30:2 (ช่วยหายใจ)"
          sub="BLS-HCP standard: หยุดกดทุก 30 ครั้ง เพื่อช่วยหายใจ 2 ครั้ง (ก่อนใส่ advanced airway)"
        />

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3">
          <div className={cn(dashCard, "text-center")}>
            <div className="mb-1 text-xs text-muted-foreground">เวลา</div>
            <div className="text-2xl font-bold tabular-nums">{fmtTime(elapsed)}</div>
          </div>
          <div className={cn(dashCard, "text-center")}>
            <div className="mb-1 text-xs text-muted-foreground">นับครั้ง</div>
            <div className="text-2xl font-bold tabular-nums">{tapCount}</div>
          </div>
          <div
            className={cn(
              dashCard,
              "text-center",
              actualBpm == null ? "" : bpmInZone ? "ring-2 ring-emerald-500" : "ring-2 ring-red-500",
            )}
          >
            <div className="mb-1 text-xs text-muted-foreground">BPM จริง</div>
            <div
              className={cn(
                "text-2xl font-bold tabular-nums",
                actualBpm == null ? "text-muted-foreground" : bpmInZone ? "text-emerald-600" : "text-red-600",
              )}
            >
              {actualBpm ?? "—"}
            </div>
          </div>
        </div>

        {/* Cycle progress */}
        <div className={dashCard}>
          <div className="mb-2 flex items-center justify-between">
            <div className="text-sm text-muted-foreground">รอบนี้ ({CYCLE_TARGET_SEC}s)</div>
            {cycleDue && <div className="text-xs font-bold text-amber-600">⚠ เปลี่ยนคนกดได้แล้ว</div>}
          </div>
          <div className="h-2 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-sky-500 transition-all"
              style={{ width: `${cycleProgress}%` }}
            />
          </div>
        </div>

        {/* Controls — placed above the big tap button so Start is immediately visible */}
        <div className="grid grid-cols-3 gap-3">
          <button
            onClick={() => setRunning((r) => !r)}
            className={cn(
              "inline-flex items-center justify-center gap-2 rounded-xl py-4 font-semibold",
              running ? "bg-amber-500 text-white" : "bg-emerald-600 text-white",
            )}
          >
            {running ? (
              <>
                <Pause size={18} /> หยุด
              </>
            ) : (
              <>
                <Play size={18} /> เริ่ม
              </>
            )}
          </button>
          <button
            onClick={() => setMetronomeOn((m) => !m)}
            className={cn(
              "rounded-xl py-4 font-semibold",
              metronomeOn ? "bg-sky-500 text-white" : "bg-muted text-muted-foreground",
            )}
          >
            🔊 {metronomeOn ? "ปิดเสียง" : "เปิดเสียง"}
          </button>
          <button
            onClick={handleReset}
            className="inline-flex items-center justify-center gap-2 rounded-xl bg-muted py-4 font-semibold text-muted-foreground"
          >
            <RotateCcw size={18} /> รีเซ็ต
          </button>
        </div>

        {/* Big tap button */}
        <button
          onClick={handleTap}
          disabled={!running}
          className={cn(
            "w-full rounded-2xl py-12 text-2xl font-bold transition-all",
            running ? "bg-sky-500 text-white active:scale-95" : "bg-muted text-muted-foreground",
          )}
        >
          {running ? "แตะตามจังหวะที่กด" : "กดเริ่มก่อน"}
        </button>

        {/* Rate slider */}
        <div className={cn(dashCard, "space-y-2")}>
          <div className="flex items-center justify-between">
            <div className="text-sm text-muted-foreground">Metronome BPM</div>
            <div className="text-lg font-bold tabular-nums">{rate}</div>
          </div>
          <input
            type="range"
            min={RATE_LOW}
            max={RATE_HIGH}
            value={rate}
            onChange={(e) => setRate(Number(e.target.value))}
            className="w-full"
          />
          <div className="flex justify-between text-xs text-muted-foreground">
            <span>{RATE_LOW}</span>
            <span>{RATE_HIGH}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
