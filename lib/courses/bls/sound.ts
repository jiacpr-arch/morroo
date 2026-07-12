// Web Audio API — no mp3 files needed.
// TS port of acls-emr/src/utils/sound.js (kept as a superset so the scenario
// player's `initAudio` import and the skill-practice page's metronome/beep
// imports both resolve from here).

// Older Safari exposes AudioContext under a vendor-prefixed name; the DOM lib
// types don't declare it, so we widen the window type just for this lookup.
interface WindowWithWebkitAudio extends Window {
  webkitAudioContext?: typeof AudioContext;
}

let audioCtx: AudioContext | null = null;

function getAudioContext(): AudioContext {
  if (!audioCtx) {
    const w = window as WindowWithWebkitAudio;
    const Ctor = window.AudioContext || w.webkitAudioContext;
    if (!Ctor) {
      throw new Error("Web Audio API is not supported in this browser");
    }
    audioCtx = new Ctor();
  }
  if (audioCtx.state === "suspended") {
    audioCtx.resume();
  }
  return audioCtx;
}

// Play a beep tone
export function playBeep(frequency = 880, duration = 0.15, volume = 0.3): void {
  try {
    const ctx = getAudioContext();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.value = frequency;
    osc.type = "sine";
    gain.gain.setValueAtTime(volume, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + duration);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + duration);
  } catch {
    // Audio not available
  }
}

// Cycle complete alert — double beep
export function playCycleAlert(): void {
  playBeep(880, 0.15, 0.4);
  setTimeout(() => playBeep(1100, 0.2, 0.4), 200);
}

// Drug due alert — triple beep
export function playDrugAlert(): void {
  playBeep(660, 0.1, 0.3);
  setTimeout(() => playBeep(660, 0.1, 0.3), 150);
  setTimeout(() => playBeep(880, 0.15, 0.3), 300);
}

// Shock delivered — short deep tone
export function playShockSound(): void {
  playBeep(440, 0.3, 0.5);
}

// ROSC celebration — ascending tones
export function playROSCSound(): void {
  playBeep(523, 0.15, 0.3);
  setTimeout(() => playBeep(659, 0.15, 0.3), 150);
  setTimeout(() => playBeep(784, 0.2, 0.3), 300);
}

// Metronome click
export function playMetronomeClick(): void {
  try {
    const ctx = getAudioContext();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.frequency.value = 1000;
    osc.type = "square";
    gain.gain.setValueAtTime(0.15, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.03);
    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.03);
  } catch {
    // Audio not available
  }
}

// Compressor rotation alert — ascending triple beep
export function playCompressorRotateAlert(): void {
  playBeep(440, 0.15, 0.4);
  setTimeout(() => playBeep(554, 0.15, 0.4), 180);
  setTimeout(() => playBeep(659, 0.2, 0.4), 360);
}

// Warning beep (10 sec before cycle ends)
export function playWarningBeep(): void {
  playBeep(660, 0.1, 0.2);
}

// Initialize audio context on first user interaction
export function initAudio(): void {
  getAudioContext();
}
