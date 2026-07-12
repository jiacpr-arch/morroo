"use client";

// เสียงสำหรับเกม BLS — Web Audio ล้วน ไม่มีไฟล์เสียง (client-only)
// แยกจาก lib/sim/sound.ts โดยตั้งใจ: ฝั่ง firstaid ไม่พึ่งพาโค้ดของเกม ACLS

type AudioWindow = Window & { webkitAudioContext?: typeof AudioContext };

let ctx: AudioContext | null = null;

function getCtx(): AudioContext | null {
  if (typeof window === "undefined") return null;
  if (!ctx) {
    const Ctor = window.AudioContext || (window as AudioWindow).webkitAudioContext;
    if (!Ctor) return null;
    ctx = new Ctor();
  }
  if (ctx.state === "suspended") void ctx.resume();
  return ctx;
}

/** ปลดล็อก AudioContext ตอนผู้ใช้แตะครั้งแรก (นโยบาย autoplay) */
export function initBlsAudio(): void {
  getCtx();
}

function beep(frequency: number, duration: number, volume: number, type: OscillatorType = "sine"): void {
  try {
    const c = getCtx();
    if (!c) return;
    const osc = c.createOscillator();
    const gain = c.createGain();
    osc.connect(gain);
    gain.connect(c.destination);
    osc.frequency.value = frequency;
    osc.type = type;
    gain.gain.setValueAtTime(volume, c.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, c.currentTime + duration);
    osc.start(c.currentTime);
    osc.stop(c.currentTime + duration);
  } catch {
    // Audio not available
  }
}

/** คลิก metronome จังหวะกดหน้าอก (เรียกทุก ~545ms = 110 ครั้ง/นาที) */
export function playMetronomeClick(): void {
  beep(1000, 0.03, 0.15, "square");
}

export function playCorrect(): void {
  beep(660, 0.12, 0.25);
  setTimeout(() => beep(880, 0.15, 0.25), 130);
}

export function playWrong(): void {
  beep(180, 0.25, 0.3);
}
