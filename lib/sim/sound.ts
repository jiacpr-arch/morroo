// Web Audio API — ไม่ต้องมีไฟล์เสียง (client-only)

type AudioWindow = Window & { webkitAudioContext?: typeof AudioContext };

let audioCtx: AudioContext | null = null;

function getAudioContext(): AudioContext | null {
  if (typeof window === "undefined") return null;
  if (!audioCtx) {
    const Ctor = window.AudioContext || (window as AudioWindow).webkitAudioContext;
    if (!Ctor) return null;
    audioCtx = new Ctor();
  }
  if (audioCtx.state === "suspended") {
    void audioCtx.resume();
  }
  return audioCtx;
}

export function playBeep(frequency = 880, duration = 0.15, volume = 0.3): void {
  try {
    const ctx = getAudioContext();
    if (!ctx) return;
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

// Warning beep (alarm)
export function playWarningBeep(): void {
  playBeep(660, 0.1, 0.2);
}

// Metronome click (~110/นาที ระหว่าง CPR)
export function playMetronomeClick(): void {
  try {
    const ctx = getAudioContext();
    if (!ctx) return;
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

// ปลดล็อก AudioContext ตอนผู้ใช้แตะปุ่มครั้งแรก (นโยบาย autoplay ของเบราว์เซอร์)
export function initAudio(): void {
  getAudioContext();
}
