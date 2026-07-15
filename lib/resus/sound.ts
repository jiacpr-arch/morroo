// เสียงประกอบเกมหัตถการ — wrapper บางๆ บน Web Audio ของ Code Blue Sim
// (oscillator ล้วน ไม่มีไฟล์เสียง) — client-only เหมือนต้นทาง

import { initAudio, playBeep } from "@/lib/sim/sound";

export { initAudio };

/** ทำ step สำเร็จ — ติ๊งสั้นๆ ให้กำลังใจ */
export function playStepDone(): void {
  playBeep(880, 0.1, 0.25);
  setTimeout(() => playBeep(1175, 0.12, 0.25), 90);
}

/** เป้าย่อยสำเร็จ (เย็บ 1 เข็ม / ฉีด 1 จุด) */
export function playSubDone(): void {
  playBeep(988, 0.08, 0.2);
}

/** หยิบเครื่องมือผิด/ผิดตำแหน่ง — เสียงต่ำ */
export function playMistake(): void {
  playBeep(150, 0.3, 0.35);
}

/** เลือกเครื่องมือบนถาด */
export function playToolSelect(): void {
  playBeep(660, 0.05, 0.15);
}

/** จบด่านสำเร็จ — arpeggio ฉลอง */
export function playOpDone(): void {
  playBeep(523, 0.15, 0.3);
  setTimeout(() => playBeep(659, 0.15, 0.3), 140);
  setTimeout(() => playBeep(784, 0.15, 0.3), 280);
  setTimeout(() => playBeep(1047, 0.25, 0.3), 420);
}

/** ผู้ป่วยไปไม่ไหว */
export function playOpFailed(): void {
  playBeep(330, 0.25, 0.3);
  setTimeout(() => playBeep(247, 0.25, 0.3), 220);
  setTimeout(() => playBeep(165, 0.5, 0.3), 440);
}
