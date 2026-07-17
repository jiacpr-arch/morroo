"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import Link from "next/link";
import { AlertTriangle, Home, RefreshCw, Volume2, VolumeX, Zap } from "lucide-react";
import { resolveCharacter, type SimDbCharacter } from "@/lib/sim/characters";
import CharacterSprite from "@/components/sim/CharacterSprite";
import EcgMonitor from "@/components/sim/EcgMonitor";
import {
  DEFAULT_DIFFICULTY, DIFFICULTY, applyFx, createInitialState, fmtTime,
  getDifficulty, gradeFor, nextNode, pushEtco2, recordCorrect, recordWrong,
  scoreFor, shuffled,
} from "@/lib/sim/engine";
import {
  initAudio, playBeep, playMetronomeClick, playROSCSound, playShockSound,
  playWarningBeep,
} from "@/lib/sim/sound";
import { SIM_BADGE_NAMES, recordSimRun, type RecordedRun } from "@/lib/sim/record";
import {
  parseEmphasis,
  type ChoiceNode, type ChoiceOption, type NodeFx, type Pose,
  type SimScenario, type SimState, type TextSegment,
} from "@/lib/sim/types";
import "./sim.css";

const HISCORE_PREFIX = "morroo_sim_hiscore";
const MUTE_KEY = "morroo_sim_muted";
const DIFF_KEY = "morroo_sim_difficulty";

const isBrowser = typeof window !== "undefined";
const hiscoreKey = (slug: string, diff: string) => `${HISCORE_PREFIX}_${slug}_${diff}`;
const readHiscore = (slug: string, diff: string) =>
  isBrowser ? Number(localStorage.getItem(hiscoreKey(slug, diff)) || 0) : 0;

// สำเนาสถานะ engine สำหรับ render (render ห้ามอ่าน ref ตรงๆ)
function snapshot(st: SimState): SimState {
  return { ...st, timeline: [...st.timeline], etco2Trace: [...st.etco2Trace] };
}

const RHYTHM_NAMES: Record<string, string> = {
  flat: "ASYSTOLE",
  vf: "V-FIB ⚠",
  nsr: "SINUS — ROSC",
};

interface Speaker { who: string; pose: Pose; popN: number }
interface Result { won: boolean; grade: string; score: number; isHiscore: boolean }
type ChoiceData = ChoiceNode["choice"];

/** บทพูดที่พิมพ์ทีละตัว — reveal ตามจำนวนตัวอักษร ไม่มี HTML */
function DlgText({ segments, count }: { segments: TextSegment[]; count: number }) {
  const parts: { key: number; em: boolean; text: string }[] = [];
  let remaining = count;
  for (let i = 0; i < segments.length; i++) {
    const s = segments[i];
    const take = Math.max(0, Math.min(s.text.length, remaining));
    remaining -= take;
    if (take) parts.push({ key: i, em: s.em, text: s.text.slice(0, take) });
  }
  return (
    <>
      {parts.map((p) => (
        <span key={p.key} className={p.em ? "cbs-em" : undefined}>
          {p.text}
        </span>
      ))}
    </>
  );
}

interface SimRunnerProps {
  scenario: SimScenario;
  /** โหมดทดลองเล่น (admin playtest) — ไม่บันทึกผล/ไม่แจก XP */
  practice?: boolean;
  /** ตัวละครจากตาราง sim_characters (เพิ่มจาก built-in 4 ตัว) */
  characters?: SimDbCharacter[];
}

export default function SimRunner({ scenario, practice = false, characters }: SimRunnerProps) {
  const dbCharacters = useMemo(
    () => new Map((characters ?? []).map((c) => [c.slug, c])),
    [characters],
  );
  // เกมเคส (long case) ใช้เอนจินเดียวกันแต่ไม่มี CPR/shock/rhythm — ปรับข้อความให้เข้าธีม ward
  const isLongcase = scenario.category === "longcase";
  const hubHref = isLongcase ? "/casegame" : "/sim";
  const [reducedMotion] = useState(
    () => isBrowser && window.matchMedia("(prefers-reduced-motion: reduce)").matches,
  );

  const [difficulty, setDifficulty] = useState(
    () => (isBrowser && localStorage.getItem(DIFF_KEY)) || DEFAULT_DIFFICULTY,
  );
  const [muted, setMuted] = useState(() => isBrowser && localStorage.getItem(MUTE_KEY) === "1");
  const mutedRef = useRef(muted);
  useEffect(() => { mutedRef.current = muted; }, [muted]);

  // ---- engine state: mutable ใน ref (logic) + snapshot state (render) ----
  const S = useRef<SimState>(createInitialState(DEFAULT_DIFFICULTY));
  const [view, setView] = useState<SimState>(() => snapshot(createInitialState(DEFAULT_DIFFICULTY)));

  const [screen, setScreen] = useState<"title" | "game" | "debrief">("title");
  const [speaker, setSpeaker] = useState<Speaker | null>(null);
  const [plate, setPlate] = useState<{ name: string } | null>(null); // override (time-skip)
  const [dlgSegments, setDlgSegments] = useState<TextSegment[]>([]);
  const [dlgCount, setDlgCount] = useState(0);
  const [typing, setTyping] = useState(false);
  const [choice, setChoice] = useState<{ q: string; options: ChoiceOption[]; hintTgt: string | null } | null>(null);
  const [decisionLeft, setDecisionLeft] = useState(getDifficulty(difficulty).decisionTime);
  const [drama, setDrama] = useState<"red" | "white" | null>(null);
  const [inter, setInter] = useState<{ text: string; green: boolean } | null>(null);
  const [flashN, setFlashN] = useState(0);
  const [redN, setRedN] = useState(0);
  const [shaking, setShaking] = useState(false);
  const [result, setResult] = useState<Result | null>(null);
  const [reward, setReward] = useState<RecordedRun | null>(null);
  const [hiscore, setHiscore] = useState(() => readHiscore(scenario.slug, difficulty));

  const timers = useRef<{
    type: ReturnType<typeof setTimeout> | null;
    dec: ReturnType<typeof setInterval> | null;
    misc: ReturnType<typeof setTimeout>[];
    metronome: ReturnType<typeof setInterval> | null;
  }>({ type: null, dec: null, misc: [], metronome: null });
  const busyRef = useRef(false);
  const [awaitTap, setAwaitTap] = useState(false);
  const currentChoiceRef = useRef<ChoiceData | null>(null);
  const retryChoiceRef = useRef<ChoiceData | null>(null);
  const hintUsedRef = useRef(false); // โหมดง่าย: ใบ้ target หลังตอบผิดครั้งแรกของแต่ละจุด
  const typeDoneRef = useRef<(() => void) | null>(null);
  const fullSegmentsRef = useRef<TextSegment[]>([]);
  const popCounter = useRef(0);

  const stopMetronome = useCallback(() => {
    if (timers.current.metronome) {
      clearInterval(timers.current.metronome);
      timers.current.metronome = null;
    }
  }, []);

  const clearAllTimers = useCallback(() => {
    const t = timers.current;
    if (t.type) clearTimeout(t.type);
    if (t.dec) clearInterval(t.dec);
    if (t.metronome) clearInterval(t.metronome);
    t.misc.forEach(clearTimeout);
    t.type = null; t.dec = null; t.metronome = null; t.misc = [];
  }, []);
  useEffect(() => clearAllTimers, [clearAllTimers]);

  // ---- flow ทั้งหมดเป็น plain functions: เรียกไขว้/เรียกซ้ำกันได้อิสระ
  //      ปลอดภัยจาก stale closure เพราะแตะเฉพาะ ref + state setter (stable) ----

  function syncView() {
    setView(snapshot(S.current));
  }

  function later(fn: () => void, ms: number) {
    timers.current.misc.push(setTimeout(fn, ms));
  }

  function vibrate(pattern: number[]) {
    if (isBrowser && navigator.vibrate) navigator.vibrate(pattern);
  }

  function sfx(fn: () => void) {
    if (!mutedRef.current) fn();
  }

  // metronome ~110/นาที ระหว่าง CPR (หยุดเมื่อ shock/ROSC/ผิด/จบเคส)
  function startMetronome() {
    stopMetronome();
    if (mutedRef.current) return;
    timers.current.metronome = setInterval(() => {
      if (!mutedRef.current) playMetronomeClick();
    }, 545);
  }

  // ผูกเสียงกับ fx ที่ node ทำ (เรียกก่อน applyFx เพื่ออ่านสถานะ cpr เดิม)
  function soundForFx(fx?: NodeFx) {
    if (!fx) return;
    if (fx.shock) { sfx(playShockSound); stopMetronome(); }
    if (fx.rosc) { sfx(playROSCSound); stopMetronome(); }
    if (fx.alarm) sfx(playWarningBeep);
    if (fx.cpr && !S.current.cpr) startMetronome();
  }

  function totalChars(segments: TextSegment[]) {
    return segments.reduce((n, s) => n + s.text.length, 0);
  }

  function finishTyping() {
    if (timers.current.type) clearTimeout(timers.current.type);
    timers.current.type = null;
    setDlgCount(totalChars(fullSegmentsRef.current));
    setTyping(false);
    const done = typeDoneRef.current;
    typeDoneRef.current = null;
    if (done) done();
  }

  function typeText(text: string, onDone?: () => void) {
    if (timers.current.type) clearTimeout(timers.current.type);
    const segments = parseEmphasis(text);
    fullSegmentsRef.current = segments;
    typeDoneRef.current = onDone || null;
    setTyping(true);
    setDlgSegments(segments);
    setDlgCount(0);
    const total = totalChars(segments);
    let i = 0;
    const step = () => {
      if (i >= total) { finishTyping(); return; }
      i += 1;
      setDlgCount(i);
      timers.current.type = setTimeout(step, reducedMotion ? 0 : 16);
    };
    step();
  }

  function doShake() {
    setShaking(true);
    later(() => setShaking(false), 450);
  }

  function doBigMoment() {
    vibrate([90, 50, 160]);
    if (!reducedMotion) {
      setFlashN((n) => n + 1);
      doShake();
    }
  }

  function endCase(won: boolean) {
    clearAllTimers();
    const st = S.current;
    const grade = gradeFor(st, won);
    const score = scoreFor(st, won);
    const key = hiscoreKey(scenario.slug, st.difficulty);
    let isHiscore = false;
    if (isBrowser && score > Number(localStorage.getItem(key) || 0)) {
      localStorage.setItem(key, String(score));
      setHiscore(score);
      isHiscore = score > 0;
    }
    // บันทึกผล + XP/Badge เบื้องหลัง — จอ debrief โชว์ทันที รางวัลตามมา
    setReward(null);
    if (!practice) {
      void recordSimRun(scenario.slug, st, { won, grade, score }).then(setReward);
    }
    syncView();
    setResult({ won, grade, score, isHiscore });
    setChoice(null);
    setInter(null);
    setScreen("debrief");
    if (isBrowser) window.scrollTo(0, 0);
  }

  function showChoice(c: ChoiceData) {
    currentChoiceRef.current = c;
    setDrama("white");
    const diff = getDifficulty(S.current.difficulty);
    // โหมดง่าย: หลังพลาดจุดนี้ไปแล้วครั้งนึง ใบ้หมวด target ที่ถูก + dim ตัวที่ผิด
    const hintTgt = diff.hints && hintUsedRef.current
      ? (c.options.find((o) => o.ok)?.tgt || null)
      : null;
    setChoice({ q: c.q, options: shuffled(c.options), hintTgt });
    setDecisionLeft(diff.decisionTime);
    if (timers.current.dec) clearInterval(timers.current.dec);
    let left = diff.decisionTime;
    timers.current.dec = setInterval(() => {
      left -= 0.25;
      setDecisionLeft(left);
      if (left <= 0) {
        if (timers.current.dec) clearInterval(timers.current.dec);
        timers.current.dec = null;
        pick({
          tgt: "—",
          label: "",
          ok: false,
          timeout: true,
          why: isLongcase
            ? "หมดเวลา — ผู้ป่วยยังรอการตัดสินใจของคุณ"
            : "หมดเวลา — ใน arrest ความลังเลก็คือการตัดสินใจแบบหนึ่ง",
          worsen: true,
        });
      }
    }, 250);
  }

  function runNode(node: NonNullable<ReturnType<typeof nextNode>>) {
    const st = S.current;
    if ("t" in node && node.t) st.simTime += node.t;
    syncView();

    if ("say" in node) {
      const { who, pose, text, fx } = node.say;
      soundForFx(fx);
      applyFx(st, fx);
      pushEtco2(st);
      setDrama(pose === "panic" ? "red" : null);
      popCounter.current += 1;
      setSpeaker({ who, pose, popN: popCounter.current });
      setPlate(null);
      setAwaitTap(true);
      typeText(text);
      syncView();
      return;
    }

    if ("inter" in node) {
      busyRef.current = true;
      soundForFx(node.fx);
      applyFx(st, node.fx);
      pushEtco2(st);
      if (node.drama) setDrama(node.drama);
      syncView();
      doBigMoment();
      setInter({ text: node.inter, green: !!node.green });
      later(() => {
        setInter(null);
        busyRef.current = false;
        advance();
      }, reducedMotion ? 350 : 1050);
      return;
    }

    if ("skip" in node) {
      busyRef.current = true;
      setDrama(null);
      popCounter.current += 1;
      setSpeaker({ who: "att_dech", pose: "idle", popN: popCounter.current });
      setPlate({ name: "— เวลาเดินต่อ —" });
      setAwaitTap(false);
      typeText(`⏩ ${node.skip}…`, () => {
        later(() => {
          busyRef.current = false;
          advance();
        }, reducedMotion ? 200 : 700);
      });
      return;
    }

    if ("choice" in node) {
      showChoice(node.choice);
      return;
    }

    if ("end" in node) {
      endCase(true);
      return;
    }

    advance();
  }

  function advance() {
    const node = nextNode(S.current, scenario.story);
    if (!node) { endCase(true); return; }
    runNode(node);
  }

  function pick(option: ChoiceOption) {
    if (timers.current.dec) { clearInterval(timers.current.dec); timers.current.dec = null; }
    setChoice(null);
    const st = S.current;

    if (option.ok) {
      recordCorrect(st, option);
      currentChoiceRef.current = null;
      hintUsedRef.current = false; // จุดถัดไปเริ่มใหม่ ไม่ใบ้
      syncView();
      advance();
      return;
    }

    recordWrong(st, option);
    pushEtco2(st);
    hintUsedRef.current = true; // จุดนี้เคยพลาด — โหมดง่ายจะใบ้ตอนเล่นซ้ำ
    vibrate([60, 40, 60]);
    sfx(() => playBeep(160, 0.28, 0.35)); // เสียงผิดต่ำ
    if (!reducedMotion) {
      setRedN((n) => n + 1);
      doShake();
    }
    stopMetronome();
    syncView();

    popCounter.current += 1;
    setSpeaker({ who: "att_dech", pose: "stern", popN: popCounter.current });
    setPlate(null);
    setDrama("red");

    // โหมดยาก: ไม่เฉลยเหตุผลตอนพลาด (เก็บไว้ debrief) — เพิ่มความกดดัน
    const showWhy = getDifficulty(st.difficulty).showWhyOnWrong;
    const whyText = showWhy && option.why ? ` ${option.why}` : "";

    if (st.hp <= 0) {
      setAwaitTap(false);
      typeText(`**ผู้ป่วยไปแล้ว…**${whyText}`, () => {
        later(() => endCase(false), reducedMotion ? 400 : 1400);
      });
      return;
    }

    // ดุแล้วให้ตัดสินใจข้อเดิมซ้ำ (สภาพแย่ลงแล้ว)
    retryChoiceRef.current = currentChoiceRef.current;
    setAwaitTap(true);
    typeText(
      `**ช้าก่อน!**${whyText}${option.worsen ? " — ผู้ป่วยแย่ลง สีผิวคล้ำขึ้น!" : ""}`,
    );
  }

  function onDialogTap() {
    if (busyRef.current) return;
    if (timers.current.type) { finishTyping(); return; }
    if (!awaitTap) return;
    setAwaitTap(false);
    if (retryChoiceRef.current) {
      const c = retryChoiceRef.current;
      retryChoiceRef.current = null;
      showChoice(c);
      return;
    }
    advance();
  }

  function startGame() {
    clearAllTimers();
    if (!mutedRef.current) initAudio(); // ปลดล็อก AudioContext ตอนผู้ใช้แตะปุ่ม
    S.current = createInitialState(difficulty);
    syncView();
    busyRef.current = false;
    setAwaitTap(false);
    currentChoiceRef.current = null;
    retryChoiceRef.current = null;
    hintUsedRef.current = false;
    setResult(null);
    setReward(null);
    setChoice(null);
    setInter(null);
    setDrama(null);
    setSpeaker(null);
    setPlate(null);
    setDlgSegments([]);
    setDlgCount(0);
    setScreen("game");
    later(() => advance(), reducedMotion ? 100 : 400);
  }

  function chooseDifficulty(id: string) {
    setDifficulty(id);
    if (isBrowser) localStorage.setItem(DIFF_KEY, id);
    setHiscore(readHiscore(scenario.slug, id));
  }

  function toggleMute() {
    setMuted((m) => {
      const next = !m;
      if (isBrowser) localStorage.setItem(MUTE_KEY, next ? "1" : "0");
      if (next) stopMetronome();
      return next;
    });
  }

  // ============ TITLE ============
  if (screen === "title") {
    return (
      <div className="cbs-app">
        <section className="cbs-title">
          <div className="cbs-eyebrow">{isLongcase ? "Long Case · Ward Round" : "Code Blue · ER Night Shift"}</div>
          <h1>
            morroo<br />
            <span className="cbs-gold-text">{isLongcase ? "LONG CASE" : "CODE BLUE"}</span><br />
            {scenario.title.replace(/^(CODE BLUE|LONG CASE):\s*/, "")}
          </h1>
          <p className="cbs-title-sub">
            {scenario.subtitle}<br />
            {isLongcase ? (
              <>
                คุณคือ <b>แพทย์เจ้าของไข้</b> — ทุกคำถามและคำสั่งมีผลต่อผู้ป่วย<br />
                ตัดสินใจผิด อาการแย่ลงจริง เวลาไม่เคยรอใคร
              </>
            ) : (
              <>
                คุณคือ <b>Team Leader</b> — ทีมทั้งห้องรอฟังคำสั่งของคุณ<br />
                ตัดสินใจผิด ผู้ป่วยแย่ลงจริง เวลาไม่เคยรอใคร
              </>
            )}
          </p>
          <div className="cbs-diff-group" role="group" aria-label="เลือกระดับความยาก">
            <span className="cbs-diff-label">ระดับความยาก</span>
            <div className="cbs-diff-btns">
              {Object.values(DIFFICULTY).map((d) => (
                <button
                  key={d.id}
                  type="button"
                  className={`cbs-diff-btn ${difficulty === d.id ? "cbs-diff-on" : ""}`}
                  onClick={() => chooseDifficulty(d.id)}
                  aria-pressed={difficulty === d.id}
                >
                  <span className="cbs-diff-name">{d.label}</span>
                  <span className="cbs-diff-meta">{d.decisionTime}s · ♥{d.hp}</span>
                </button>
              ))}
            </div>
          </div>
          <div className="cbs-title-row">
            {hiscore > 0 && <div className="cbs-hiscore-chip">HI-SCORE {hiscore}</div>}
            <button
              type="button"
              className="cbs-icon-btn"
              onClick={toggleMute}
              aria-label={muted ? "เปิดเสียง" : "ปิดเสียง"}
            >
              {muted ? <VolumeX size={16} strokeWidth={2.4} /> : <Volume2 size={16} strokeWidth={2.4} />}
            </button>
          </div>
          <button type="button" className="cbs-btn-main" onClick={startGame}>
            <AlertTriangle size={18} strokeWidth={2.6} style={{ display: "inline", verticalAlign: "-3px", marginRight: 8 }} />
            รับเคส
          </button>
          <Link href={hubHref} className="cbs-btn-ghost">
            <Home size={15} strokeWidth={2.4} style={{ display: "inline", verticalAlign: "-2px", marginRight: 6 }} />
            กลับหน้ารวมเคส
          </Link>
          <div className="cbs-note">{isLongcase ? "DECISION GAME · LONG CASE · MORROO" : "DECISION GAME · ACLS TRAINING · MORROO"}</div>
        </section>
      </div>
    );
  }

  // ============ DEBRIEF ============
  if (screen === "debrief" && result) {
    const st = view;
    return (
      <div className="cbs-app">
        <section className={`cbs-debrief ${result.won ? "cbs-winbg" : "cbs-losebg"}`}>
          <div className={`cbs-stamp ${result.won ? "cbs-win" : "cbs-lose"}`}>
            {result.won ? (isLongcase ? "CASE CLEARED" : "ROSC!") : (isLongcase ? "CASE FAILED" : "CODE ENDED")}
          </div>
          <div className="cbs-diff-badge">โหมด {getDifficulty(st.difficulty).label}</div>
          <p className="cbs-verdict-sub">
            {result.won
              ? isLongcase
                ? "วินิจฉัยและจัดการถูกต้อง — เคสนี้เป็นของคุณ"
                : "ผู้ป่วยกลับมามีชีพจร — ส่งต่อ Cath lab เคสนี้เป็นของคุณ"
              : isLongcase
                ? "ผู้ป่วยแย่ลงจากการตัดสินใจที่พลาด — อ่าน debrief ด้านล่าง แล้วกลับมาแก้มือ"
                : "ผู้ป่วยเสียชีวิต — อ่าน debrief ด้านล่าง แล้วกลับมาแก้มือ"}
            {result.isHiscore && <><br />🏆 New Hi-Score: {result.score}</>}
          </p>
          {reward && reward.loggedIn && reward.xpEarned > 0 && (
            <div className="cbs-reward-row">
              <span className="cbs-xp-pill"><Zap size={13} strokeWidth={2.6} /> +{reward.xpEarned} XP</span>
              {reward.newBadges.map((slug) => (
                <span key={slug} className="cbs-badge-pill">🏅 {SIM_BADGE_NAMES[slug] ?? slug}</span>
              ))}
            </div>
          )}
          {reward && !reward.loggedIn && (
            <p className="cbs-login-hint">
              <Link href="/login">เข้าสู่ระบบ</Link> เพื่อเก็บ XP, Badge และขึ้น Leaderboard
            </p>
          )}
          <div className="cbs-grade-row">
            <div className="cbs-grade-box">
              <span className={`cbs-grade cbs-g-${result.grade.toLowerCase()}`}>{result.grade}</span>
              <span className="cbs-grade-label">GRADE</span>
            </div>
            <div className="cbs-metric-grid">
              {!isLongcase && (
                <>
                  <Metric label="เริ่ม CPR ภายใน" value={st.firstCPRAt >= 0 ? fmtTime(st.firstCPRAt) : "—"}
                    tone={st.firstCPRAt >= 0 && st.firstCPRAt <= 90 ? "good" : "warn"} />
                  <Metric label="Shock แรกภายใน" value={st.firstShockAt >= 0 ? fmtTime(st.firstShockAt) : "—"}
                    tone={st.firstShockAt >= 0 && st.firstShockAt <= 300 ? "good" : "warn"} />
                </>
              )}
              <Metric label="ตัดสินใจพลาด" value={String(st.wrong)}
                tone={st.wrong === 0 ? "good" : st.wrong <= 2 ? "warn" : "badv"} />
              <Metric label="เวลาทั้งเคส" value={fmtTime(st.simTime)} tone="" />
            </div>
          </div>
          {!isLongcase && st.etco2Trace.length > 1 && (
            <div className="cbs-etco2">
              <div className="cbs-tl-title">EtCO₂ — คุณภาพ CPR ตลอดเคส</div>
              <Etco2Sparkline trace={st.etco2Trace} />
              <div className="cbs-etco2-cap">ยิ่งสูง = เลือดไปเลี้ยงดีระหว่างกด · พุ่งเกิน 35 = สัญญาณ ROSC</div>
            </div>
          )}
          <div className="cbs-tl-title">TIMELINE การตัดสินใจของคุณ</div>
          <div className="cbs-timeline">
            {st.timeline.map((it, i) => (
              <div key={i} className={`cbs-tl-item ${it.ok ? "cbs-ok" : "cbs-err"}`}>
                <span className="cbs-tl-time">{fmtTime(it.t)}</span>
                <span className="cbs-tl-dot" />
                <span>
                  {it.text}
                  {it.note && <span className="cbs-tl-note">{it.note}</span>}
                </span>
              </div>
            ))}
          </div>
          <div className="cbs-debrief-actions">
            <button type="button" className="cbs-btn-main" onClick={startGame}>
              <RefreshCw size={16} strokeWidth={2.6} style={{ display: "inline", verticalAlign: "-2px", marginRight: 8 }} />
              เล่นเคสนี้อีกครั้ง
            </button>
            <Link href={hubHref} className="cbs-btn-ghost">กลับหน้ารวมเคส</Link>
          </div>
        </section>
      </div>
    );
  }

  // ============ GAME ============
  const st = view;
  const char = speaker ? resolveCharacter(speaker.who, dbCharacters) : null;
  const plateName = plate?.name || char?.name || " ";
  const plateColors = plate ? null : char?.plate || null;
  const gameDiff = getDifficulty(st.difficulty);
  const maxHp = st.maxHp || gameDiff.hp;
  const timerPct = Math.max(0, (decisionLeft / gameDiff.decisionTime) * 100);
  const rhythmBad = st.rhythm === "vf" || st.rhythm === "flat";

  return (
    <div className={`cbs-app ${shaking ? "cbs-shake" : ""}`}>
      <section className="cbs-game">
        <div className={`cbs-stage ${drama === "red" ? "cbs-drama-red" : drama === "white" ? "cbs-drama" : ""}`}>
          <div className="cbs-hud">
            <div className="cbs-hud-monitor">
              <span className={`cbs-rhythm-name ${rhythmBad ? "cbs-bad" : ""}`}>
                {st.alarm || st.rhythm !== "flat" ? RHYTHM_NAMES[st.rhythm] : "MONITOR — STANDBY"}
              </span>
              <EcgMonitor rhythm={st.rhythm} cpr={st.cpr} />
            </div>
            <div className="cbs-hud-right">
              <div className="cbs-gauge">
                <span className="cbs-gauge-label">PATIENT</span>
                <div className="cbs-gauge-cells">
                  {Array.from({ length: maxHp }).map((_, i) => (
                    <span
                      key={i}
                      className={`cbs-cell ${i >= st.hp ? "cbs-off" : (st.hp === 1 && i === 0 ? "cbs-last" : "")}`}
                    />
                  ))}
                </div>
              </div>
              <div className="cbs-timechip">{fmtTime(st.simTime)}</div>
            </div>
          </div>

          {speaker && (
            <div className={`cbs-sprite ${reducedMotion ? "" : "cbs-pop"}`} key={`sp-${speaker.popN}`}>
              {/* motion loop แยกชั้นจาก pop-in เพื่อให้ animation ซ้อนกันได้ */}
              <div className={!reducedMotion && char?.motion && char.motion !== "none" ? `cbs-motion-${char.motion}` : undefined}>
                <CharacterSprite
                  charId={speaker.who}
                  pose={speaker.pose}
                  talking={typing}
                  images={char?.images}
                  name={char?.name}
                />
              </div>
            </div>
          )}

          {choice && (
            <div className="cbs-choices">
              <div className="cbs-qbanner">⚖ {choice.q}</div>
              {choice.hintTgt && (
                <div className="cbs-hint">💡 ลองสั่งหมวด <b>{choice.hintTgt}</b> ดูสิ</div>
              )}
              {choice.options.map((o, i) => {
                const dim = choice.hintTgt && o.tgt !== choice.hintTgt;
                const glow = choice.hintTgt && o.tgt === choice.hintTgt;
                return (
                  <button
                    key={i}
                    type="button"
                    className={`cbs-choice ${dim ? "cbs-choice-dim" : ""} ${glow ? "cbs-choice-hint" : ""}`}
                    onClick={() => pick(o)}
                  >
                    <span className="cbs-choice-tgt">▸ สั่ง {o.tgt}</span>
                    {o.label}
                  </button>
                );
              })}
              <div className="cbs-choice-timer">
                <div
                  className={`cbs-choice-timer-fill ${timerPct < 30 ? "cbs-low" : ""}`}
                  style={{ width: `${timerPct}%` }}
                />
              </div>
            </div>
          )}
        </div>

        <div className="cbs-dlg-area">
          {/* กล่องบทพูดแบบ visual novel: แตะเพื่อข้าม/ไปต่อ */}
          <div
            className="cbs-dlg"
            onClick={onDialogTap}
            role="button"
            tabIndex={0}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") { e.preventDefault(); onDialogTap(); }
            }}
          >
            <div
              className="cbs-nameplate"
              style={plateColors ? { background: `linear-gradient(180deg, ${plateColors[0]}, ${plateColors[1]})` } : undefined}
            >
              {plateName}
            </div>
            <div className="cbs-dlg-text">
              <DlgText segments={dlgSegments} count={dlgCount} />
            </div>
            {!typing && awaitTap && <div className="cbs-adv">▼</div>}
          </div>
        </div>
      </section>

      {inter && (
        <div className="cbs-inter">
          <div className="cbs-inter-burst" />
          <div className={`cbs-inter-bubble ${inter.green ? "cbs-green-bubble" : ""}`}>
            <span className="cbs-inter-text">{inter.text}</span>
          </div>
        </div>
      )}
      {flashN > 0 && <div key={`fl-${flashN}`} className="cbs-flash cbs-go" />}
      {redN > 0 && <div key={`rf-${redN}`} className="cbs-redflash cbs-go" />}
    </div>
  );
}

function Metric({ label, value, tone }: { label: string; value: string; tone: string }) {
  return (
    <div className="cbs-metric">
      <span className="cbs-metric-label">{label}</span>
      <span className={`cbs-metric-val ${tone ? `cbs-${tone}` : ""}`}>{value}</span>
    </div>
  );
}

// กราฟ EtCO2 แบบ area sparkline — เน้นจุดปลาย (ROSC) และเส้นเป้า 35
function Etco2Sparkline({ trace }: { trace: { t: number; v: number }[] }) {
  const W = 300;
  const H = 60;
  const maxV = 45;
  const tMax = trace[trace.length - 1].t || 1;
  const x = (t: number) => (t / tMax) * W;
  const y = (v: number) => H - (Math.min(v, maxV) / maxV) * (H - 6) - 3;
  const pts = trace.map((p) => `${x(p.t).toFixed(1)},${y(p.v).toFixed(1)}`);
  const line = `M ${pts.join(" L ")}`;
  const area = `${line} L ${W},${H} L 0,${H} Z`;
  const last = trace[trace.length - 1];
  const targetY = y(35);
  return (
    <svg className="cbs-spark" viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" role="img" aria-label="กราฟ EtCO2">
      <line x1="0" y1={targetY} x2={W} y2={targetY} className="cbs-spark-target" strokeDasharray="4 4" />
      <path d={area} className="cbs-spark-area" />
      <path d={line} className="cbs-spark-line" />
      <circle cx={x(last.t)} cy={y(last.v)} r="3.5" className="cbs-spark-dot" />
    </svg>
  );
}
