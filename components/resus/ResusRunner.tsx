"use client";

// Operation MorRoo — จอเกมหัตถการ (title → game → debrief)
//
// สถานะ engine เป็น mutable ใน ref (S) + snapshot เข้า React state (view)
// ตามแบบ SimRunner: logic ทั้งหมดเป็น plain function แตะเฉพาะ ref + setter
// จึงปลอดภัยจาก stale closure — เวลาเดิน/เลือดไหลด้วย interval 250ms,
// กดค้าง (hold) เดินด้วย requestAnimationFrame ให้วงแหวนลื่น

import { useCallback, useEffect, useRef, useState } from "react";
import Link from "next/link";
import { Home, RefreshCw, Volume2, VolumeX } from "lucide-react";
import {
  DEFAULT_DIFFICULTY, DIFFICULTY, armTool, createInitialState, currentRhythm,
  currentStep, currentZone, fmtTime, getDifficulty, gradeFor, holdTick,
  pointerDown, pointerMove, pointerUp, scoreFor, starsFor, tick,
  type ActionOutcome,
} from "@/lib/resus/engine";
import EcgMonitor from "@/components/sim/EcgMonitor";
import { pointInZone, type Point } from "@/lib/resus/geometry";
import {
  initAudio, playMetronome, playMistake, playOpDone, playOpFailed, playRhythmGood,
  playRosc, playShock, playStepDone, playSubDone, playToolSelect,
} from "@/lib/resus/sound";
import { RESUS_BADGE_NAMES, recordResusRun, type RecordedRun } from "@/lib/resus/record";
import { parseEmphasis, type TextSegment } from "@/lib/sim/types";
import type { Grade, Operation, ResusState, ToolId } from "@/lib/resus/types";
import ResusField from "./ResusField";
import ToolTray from "./ToolTray";
import VitalsBar from "./VitalsBar";
import "./resus.css";

const HISCORE_PREFIX = "morroo_resus_hiscore";
const MUTE_KEY = "morroo_resus_muted";
const DIFF_KEY = "morroo_resus_difficulty";

const isBrowser = typeof window !== "undefined";
const hiscoreKey = (slug: string, diff: string) => `${HISCORE_PREFIX}_${slug}_${diff}`;
const readHiscore = (slug: string, diff: string) =>
  isBrowser ? Number(localStorage.getItem(hiscoreKey(slug, diff)) || 0) : 0;

function snapshot(st: ResusState): ResusState {
  return { ...st, timeline: [...st.timeline], traceHits: st.traceHits };
}

/** render ข้อความที่มี **คำเน้น** อย่างปลอดภัย (ไม่มี HTML) */
function EmText({ text }: { text: string }) {
  const segments: TextSegment[] = parseEmphasis(text);
  return (
    <>
      {segments.map((s, i) => (
        <span key={i} className={s.em ? "rss-em" : undefined}>{s.text}</span>
      ))}
    </>
  );
}

interface Toast {
  n: number;
  kind: "ok" | "bad";
  text: string;
}

interface Result {
  won: boolean;
  grade: Grade;
  stars: number;
  score: number;
  isHiscore: boolean;
}

interface ResusRunnerProps {
  operation: Operation;
  /** โหมดทดลองเล่น (admin playtest) — ไม่บันทึกผล/ไม่แจก XP */
  practice?: boolean;
}

export default function ResusRunner({ operation, practice = false }: ResusRunnerProps) {
  const op = operation;
  const [reducedMotion] = useState(
    () => isBrowser && window.matchMedia("(prefers-reduced-motion: reduce)").matches,
  );

  const [difficulty, setDifficulty] = useState(
    () => (isBrowser && localStorage.getItem(DIFF_KEY)) || DEFAULT_DIFFICULTY,
  );
  const [muted, setMuted] = useState(() => isBrowser && localStorage.getItem(MUTE_KEY) === "1");
  const mutedRef = useRef(muted);
  useEffect(() => { mutedRef.current = muted; }, [muted]);

  const S = useRef<ResusState>(createInitialState(DEFAULT_DIFFICULTY));
  const [view, setView] = useState<ResusState>(() => snapshot(createInitialState(DEFAULT_DIFFICULTY)));

  const [screen, setScreen] = useState<"title" | "game" | "debrief">("title");
  const [toast, setToast] = useState<Toast | null>(null);
  const [holdPct, setHoldPct] = useState(0);
  const [shaking, setShaking] = useState(false);
  const [redN, setRedN] = useState(0);
  const [whiteN, setWhiteN] = useState(0);
  const [result, setResult] = useState<Result | null>(null);
  const [reward, setReward] = useState<RecordedRun | null>(null);
  const [hiscore, setHiscore] = useState(() => readHiscore(op.slug, difficulty));

  const timers = useRef<{
    loop: ReturnType<typeof setInterval> | null;
    holdRaf: number | null;
    misc: ReturnType<typeof setTimeout>[];
  }>({ loop: null, holdRaf: null, misc: [] });
  const toastN = useRef(0);
  const endingRef = useRef(false);
  /** feedback จังหวะล่าสุดของ gesture rhythm (แสดงชั่วครู่เหนือเวที) */
  const [rhythmFb, setRhythmFb] = useState<{ n: number; q: "good" | "fast" | "slow" } | null>(null);
  const rhythmN = useRef(0);

  const stopHold = useCallback(() => {
    if (timers.current.holdRaf !== null) {
      cancelAnimationFrame(timers.current.holdRaf);
      timers.current.holdRaf = null;
    }
    setHoldPct(0);
  }, []);

  const clearAllTimers = useCallback(() => {
    const t = timers.current;
    if (t.loop) clearInterval(t.loop);
    if (t.holdRaf !== null) cancelAnimationFrame(t.holdRaf);
    t.misc.forEach(clearTimeout);
    t.loop = null;
    t.holdRaf = null;
    t.misc = [];
  }, []);
  useEffect(() => clearAllTimers, [clearAllTimers]);

  function syncView() {
    setView(snapshot(S.current));
  }

  function later(fn: () => void, ms: number) {
    timers.current.misc.push(setTimeout(fn, ms));
  }

  function sfx(fn: () => void) {
    if (!mutedRef.current) fn();
  }

  function vibrate(pattern: number[]) {
    if (isBrowser && navigator.vibrate) navigator.vibrate(pattern);
  }

  function showToast(kind: Toast["kind"], text: string) {
    toastN.current += 1;
    setToast({ n: toastN.current, kind, text });
    const n = toastN.current;
    later(() => {
      setToast((cur) => (cur?.n === n ? null : cur));
    }, kind === "ok" ? 3200 : 2600);
  }

  function endCase(won: boolean) {
    if (endingRef.current) return;
    endingRef.current = true;
    clearAllTimers();
    const st = S.current;
    const grade = gradeFor(st, won);
    const stars = starsFor(grade, won);
    const score = scoreFor(st, op, won);
    const key = hiscoreKey(op.slug, st.difficulty);
    let isHiscore = false;
    if (isBrowser && score > Number(localStorage.getItem(key) || 0)) {
      localStorage.setItem(key, String(score));
      setHiscore(score);
      isHiscore = score > 0;
    }
    // บันทึกผล + XP/Badge เบื้องหลัง — จอ debrief โชว์ทันที รางวัลตามมา
    setReward(null);
    if (!practice) {
      void recordResusRun(op.slug, st, { won, grade, score, stars }).then(setReward);
    }
    syncView();
    setToast(null);
    setResult({ won, grade, stars, score, isHiscore });
    setScreen("debrief");
    if (isBrowser) window.scrollTo(0, 0);
  }

  function mistakeFx() {
    vibrate([60, 40, 60]);
    sfx(playMistake);
    if (!reducedMotion) {
      setRedN((n) => n + 1);
      setShaking(true);
      later(() => setShaking(false), 450);
    }
  }

  /** แว้บขาวหนึ่งครั้ง — ใช้ตอนช็อกไฟฟ้า */
  function flashScreen() {
    vibrate([30, 30, 90]);
    if (!reducedMotion) setWhiteN((n) => n + 1);
  }

  // เมโทรนอมระหว่าง step ที่เป็น gesture rhythm (ปั๊ม/บีบ bag ตามจังหวะ)
  useEffect(() => {
    if (screen !== "game") return;
    const step = op.steps[view.stepIdx];
    if (!step || step.gesture.kind !== "rhythm") return;
    const period = 60000 / step.gesture.targetBpm;
    const id = setInterval(() => sfx(playMetronome), period);
    return () => clearInterval(id);
  }, [screen, view.stepIdx, op]);

  function handleOutcome(out: ActionOutcome) {
    switch (out.kind) {
      case "wrong_tool":
      case "wrong_zone":
      case "too_slow":
        stopHold();
        mistakeFx();
        showToast("bad", out.note);
        syncView();
        break;
      case "rhythm_feedback":
        // feedback จังหวะแบบเบาๆ ทุก tap — ไม่ใช้ toast เพราะจะสแปมจอ
        vibrate([12]);
        if (out.quality === "good") sfx(playRhythmGood);
        rhythmN.current += 1;
        setRhythmFb({ n: rhythmN.current, q: out.quality });
        syncView();
        break;
      case "sub_done": {
        sfx(playSubDone);
        const step = out.step;
        const total = step.subZones?.length ?? 1;
        showToast("ok", `${step.title} — จุดที่ ${Math.min(S.current.subIdx + 1, total)}/${total}`);
        syncView();
        break;
      }
      case "step_done":
        stopHold();
        if (out.step.isShock) { sfx(playShock); flashScreen(); }
        else sfx(playStepDone);
        showToast("ok", out.step.why);
        syncView();
        break;
      case "op_done":
        stopHold();
        if (out.step.fxState === "rosc") sfx(playRosc);
        else sfx(playOpDone);
        showToast("ok", out.step.why);
        syncView();
        later(() => endCase(true), reducedMotion ? 500 : 1200);
        break;
      case "op_failed":
        stopHold();
        mistakeFx();
        sfx(playOpFailed);
        syncView();
        later(() => endCase(false), reducedMotion ? 400 : 1000);
        break;
      default:
        syncView();
    }
  }

  // ---- pointer จากเวที (พิกัด viewBox แล้ว) ----

  function onFieldDown(p: Point) {
    const st = S.current;
    if (st.done || st.dead) return;
    if (!st.activeTool) {
      showToast("bad", "เลือกเครื่องมือจากถาดด้านล่างก่อน");
      return;
    }
    const step = currentStep(op, st);
    const out = pointerDown(st, op, p, performance.now());
    handleOutcome(out);
    // เริ่มวงแหวนกดค้างเมื่อ gesture คือ hold และกดถูกเป้า
    if (out.kind === "step_progress" && step?.gesture.kind === "hold") {
      startHoldLoop(step.gesture.ms);
    }
  }

  function startHoldLoop(totalMs: number) {
    stopHold();
    let last = performance.now();
    const frame = (now: number) => {
      const dt = now - last;
      last = now;
      const out = holdTick(S.current, op, dt);
      setHoldPct(Math.min(1, S.current.holdMs / totalMs));
      if (out.kind === "step_progress") {
        timers.current.holdRaf = requestAnimationFrame(frame);
        return;
      }
      timers.current.holdRaf = null;
      if (out.kind !== "noop") handleOutcome(out);
    };
    timers.current.holdRaf = requestAnimationFrame(frame);
  }

  function onFieldMove(p: Point) {
    const st = S.current;
    if (st.done || st.dead) return;
    const step = currentStep(op, st);
    if (!step) return;
    // กดค้างแล้วลากออกนอกเป้า → ยกเลิก hold (ไม่ลงโทษ)
    if (step.gesture.kind === "hold" && timers.current.holdRaf !== null) {
      const zone = currentZone(op, st);
      if (zone && !pointInZone(zone, p)) {
        stopHold();
        pointerUp(st);
      }
      return;
    }
    const out = pointerMove(st, op, p);
    if (out.kind !== "noop") handleOutcome(out);
  }

  function onFieldUp() {
    stopHold();
    pointerUp(S.current);
    syncView();
  }

  function onSelectTool(tool: ToolId) {
    if (S.current.done || S.current.dead) return;
    stopHold();
    armTool(S.current, tool);
    sfx(playToolSelect);
    syncView();
  }

  function startGame() {
    clearAllTimers();
    endingRef.current = false;
    if (!mutedRef.current) initAudio(); // ปลดล็อก AudioContext ตอนผู้ใช้แตะปุ่ม
    S.current = createInitialState(difficulty);
    syncView();
    setToast(null);
    setResult(null);
    setReward(null);
    setHoldPct(0);
    setRhythmFb(null);
    setScreen("game");
    // เวลา + โอกาสรอดไหลลง + เส้นตายต่อ step — 4Hz
    timers.current.loop = setInterval(() => {
      const out = tick(S.current, op, 0.25);
      if (out.kind === "op_failed" || out.kind === "too_slow") {
        handleOutcome(out);
        return;
      }
      syncView();
    }, 250);
  }

  function chooseDifficulty(id: string) {
    setDifficulty(id);
    if (isBrowser) localStorage.setItem(DIFF_KEY, id);
    setHiscore(readHiscore(op.slug, id));
  }

  function toggleMute() {
    setMuted((m) => {
      const next = !m;
      if (isBrowser) localStorage.setItem(MUTE_KEY, next ? "1" : "0");
      return next;
    });
  }

  // ============ TITLE ============
  if (screen === "title") {
    return (
      <div className="rss-app">
        <section className="rss-title">
          <div className="rss-eyebrow">Resus Hero · ห้องกู้ชีพ ACLS</div>
          <h1>
            <span className="rss-green-text">RESUS HERO</span><br />
            {op.title}
          </h1>
          <div className="rss-chart">
            <div className="rss-chart-head">
              🪪 {op.patient.name} · อายุ {op.patient.age} ปี
            </div>
            <p className="rss-chart-story">&ldquo;{op.patient.story}&rdquo;</p>
            <div className="rss-chart-meta">
              {op.steps.length} ขั้นตอน · เวลาเป้าหมาย {fmtTime(op.parTimeSec)} · เครื่องมือ {op.tools.length} ชิ้น
            </div>
          </div>
          <div className="rss-diff-group" role="group" aria-label="เลือกระดับความยาก">
            <span className="rss-diff-label">ระดับความยาก</span>
            <div className="rss-diff-btns">
              {Object.values(DIFFICULTY).map((d) => (
                <button
                  key={d.id}
                  type="button"
                  className={`rss-diff-btn ${difficulty === d.id ? "rss-diff-on" : ""}`}
                  onClick={() => chooseDifficulty(d.id)}
                  aria-pressed={difficulty === d.id}
                >
                  <span className="rss-diff-name">{d.label}</span>
                  <span className="rss-diff-meta">
                    {d.highlight === "full" ? "มีวงเป้า+เส้นนำ" : d.highlight === "subtle" ? "มีจุดชี้เป้า" : "ไม่ช่วยเลย"}
                  </span>
                </button>
              ))}
            </div>
          </div>
          <div className="rss-title-row">
            {hiscore > 0 && <div className="rss-hiscore-chip">HI-SCORE {hiscore}</div>}
            <button
              type="button"
              className="rss-icon-btn"
              onClick={toggleMute}
              aria-label={muted ? "เปิดเสียง" : "ปิดเสียง"}
            >
              {muted ? <VolumeX size={16} strokeWidth={2.4} /> : <Volume2 size={16} strokeWidth={2.4} />}
            </button>
          </div>
          <button type="button" className="rss-btn-main" onClick={startGame}>
            ⚡ เริ่มกู้ชีพ
          </button>
          <Link href="/resus" className="rss-btn-ghost">
            <Home size={15} strokeWidth={2.4} style={{ display: "inline", verticalAlign: "-2px", marginRight: 6 }} />
            กลับหน้ารวมด่าน
          </Link>
          <div className="rss-note">RESUS HERO · ACLS PROCEDURE GAME · MORROO</div>
        </section>
      </div>
    );
  }

  // ============ DEBRIEF ============
  if (screen === "debrief" && result) {
    const st = view;
    return (
      <div className="rss-app">
        <section className={`rss-debrief ${result.won ? "rss-winbg" : "rss-losebg"}`}>
          <div className={`rss-stamp ${result.won ? "rss-win" : "rss-lose"}`}>
            {result.won ? "ROSC! กู้ชีพสำเร็จ" : "ผู้ป่วยไม่รอด"}
          </div>
          <div className="rss-stars" aria-label={`ได้ ${result.stars} ดาว`}>
            {[1, 2, 3].map((i) => (
              <span key={i} className={i <= result.stars ? "rss-star-on" : "rss-star-off"}>★</span>
            ))}
          </div>
          <div className="rss-diff-badge">โหมด {getDifficulty(st.difficulty).label}</div>
          <p className="rss-verdict-sub">
            {result.won
              ? `${op.patient.name} ชีพจรกลับมาแล้ว — จำลำดับ ACLS ชุดนี้ไว้ให้ขึ้นใจ`
              : "ผู้ป่วยไปไม่ไหว — อ่าน debrief ทบทวนลำดับแล้วลองใหม่"}
            {result.isHiscore && <><br />🏆 New Hi-Score: {result.score}</>}
          </p>
          {reward && reward.loggedIn && reward.xpEarned > 0 && (
            <div className="rss-reward-row">
              <span className="rss-xp-pill">⚡ +{reward.xpEarned} XP</span>
              {reward.newBadges.map((slug) => (
                <span key={slug} className="rss-badge-pill">🏅 {RESUS_BADGE_NAMES[slug] ?? slug}</span>
              ))}
            </div>
          )}
          {reward && !reward.loggedIn && (
            <p className="rss-login-hint">
              <Link href="/login">เข้าสู่ระบบ</Link> เพื่อเก็บ XP, Badge และขึ้น Leaderboard
            </p>
          )}
          <div className="rss-grade-row">
            <div className="rss-grade-box">
              <span className={`rss-grade rss-g-${result.grade.toLowerCase()}`}>{result.grade}</span>
              <span className="rss-grade-label">GRADE</span>
            </div>
            <div className="rss-metric-grid">
              <Metric
                label="เวลาที่ใช้"
                value={`${fmtTime(st.elapsed)} / ${fmtTime(op.parTimeSec)}`}
                tone={st.elapsed <= op.parTimeSec ? "good" : "warn"}
              />
              <Metric
                label="พลาด"
                value={String(st.wrong)}
                tone={st.wrong === 0 ? "good" : st.wrong <= 2 ? "warn" : "badv"}
              />
              <Metric
                label="อาการผู้ป่วย"
                value={`${Math.round((st.hp / st.maxHp) * 100)}%`}
                tone={st.hp > 60 ? "good" : st.hp > 30 ? "warn" : "badv"}
              />
              <Metric label="คะแนน" value={String(result.score)} tone="" />
            </div>
          </div>
          <div className="rss-tl-title">ขั้นตอน + เกร็ดความรู้จากเคสนี้</div>
          <div className="rss-timeline">
            {st.timeline.map((it, i) => (
              <div key={i} className={`rss-tl-item ${it.ok ? "rss-ok" : "rss-err"}`}>
                <span className="rss-tl-time">{fmtTime(it.t)}</span>
                <span className="rss-tl-dot" />
                <span>
                  {it.text}
                  {it.note && (
                    <span className="rss-tl-note"><EmText text={it.note} /></span>
                  )}
                </span>
              </div>
            ))}
          </div>
          <div className="rss-debrief-actions">
            <button type="button" className="rss-btn-main" onClick={startGame}>
              <RefreshCw size={16} strokeWidth={2.6} style={{ display: "inline", verticalAlign: "-2px", marginRight: 8 }} />
              กู้ชีพอีกรอบ
            </button>
            <Link href="/resus" className="rss-btn-ghost">กลับหน้ารวมด่าน</Link>
          </div>
        </section>
      </div>
    );
  }

  // ============ GAME ============
  const st = view;
  const step = currentStep(op, st);
  const zone = currentZone(op, st);
  const diff = getDifficulty(st.difficulty);

  return (
    <div className={`rss-app ${shaking ? "rss-shake" : ""}`}>
      <section className="rss-game">
        <VitalsBar
          hp={st.hp}
          maxHp={st.maxHp}
          elapsed={st.elapsed}
          parTimeSec={op.parTimeSec}
          wrong={st.wrong}
        />
        <div className="rss-stepbanner" data-testid="step-banner">
          <span className="rss-stepnum">
            {Math.min(st.stepIdx + 1, op.steps.length)}/{op.steps.length}
          </span>
          {step ? step.title : "เสร็จสิ้นหัตถการ"}
          {step?.hpDrain && <span className="rss-bleedtag">โอกาสรอดกำลังลด!</span>}
          {step?.timeLimitSec && !st.timePenalized && (
            <span className={`rss-deadline ${st.stepElapsed > step.timeLimitSec - 10 ? "rss-deadline-hot" : ""}`}>
              ⏱ {Math.max(0, Math.ceil(step.timeLimitSec - st.stepElapsed))}s
            </span>
          )}
        </div>
        <div className="rss-stage">
          <div className="rss-monitor" aria-hidden="true">
            <EcgMonitor
              rhythm={currentRhythm(op, st) ?? "flat"}
              cpr={step?.gesture.kind === "rhythm" && step.tool === "cpr_hands"}
              width={150}
              height={44}
            />
          </div>
          <ResusField
            op={op}
            view={st}
            step={step}
            zone={zone}
            highlight={diff.highlight}
            holdPct={holdPct}
            onDown={onFieldDown}
            onMove={onFieldMove}
            onUp={onFieldUp}
          />
          {toast && (
            <div key={toast.n} className={`rss-toast ${toast.kind === "ok" ? "rss-toast-ok" : "rss-toast-bad"}`}>
              <EmText text={toast.text} />
            </div>
          )}
          {rhythmFb && step?.gesture.kind === "rhythm" && (
            <div key={`rfb-${rhythmFb.n}`} className={`rss-rhythmfb rss-rfb-${rhythmFb.q}`}>
              {rhythmFb.q === "good" ? "ตรงจังหวะ!" : rhythmFb.q === "fast" ? "เร็วไป!" : "ช้าไป!"}
            </div>
          )}
        </div>
        <ToolTray
          tools={op.tools}
          activeTool={st.activeTool}
          showHints={diff.highlight === "full"}
          onSelect={onSelectTool}
        />
      </section>
      {redN > 0 && <div key={`rf-${redN}`} className="rss-redflash rss-go" />}
      {whiteN > 0 && <div key={`wf-${whiteN}`} className="rss-whiteflash rss-go" />}
    </div>
  );
}

function Metric({ label, value, tone }: { label: string; value: string; tone: string }) {
  return (
    <div className="rss-metric">
      <span className="rss-metric-label">{label}</span>
      <span className={`rss-metric-val ${tone ? `rss-${tone}` : ""}`}>{value}</span>
    </div>
  );
}
