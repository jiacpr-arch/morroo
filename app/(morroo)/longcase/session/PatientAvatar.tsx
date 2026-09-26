"use client";

import CharacterSprite from "@/components/sim/CharacterSprite";
import { getCharacter } from "@/lib/sim/characters";

// Illustrated patient for the history phase — reuses the Code Blue Sim
// sprites, chosen by age/gender only (neutral pose, never the diagnosis),
// so the avatar never gives away what the student should find by asking.
export function PatientAvatar({ charId, talking }: { charId?: string; talking: boolean }) {
  const id = charId && getCharacter(charId) ? charId : "patient_generic";
  const name = getCharacter(id)?.name ?? "ผู้ป่วย";
  return (
    <div className="flex items-center gap-3">
      <div
        className="h-24 w-20 shrink-0 overflow-hidden rounded-xl bg-gradient-to-b from-amber-100 to-amber-50 [&_img]:w-full [&_svg]:w-full"
        aria-hidden="true"
      >
        <CharacterSprite charId={id} pose={talking ? "talk" : "idle"} talking={talking} />
      </div>
      <div className="text-sm">
        <p className="font-semibold text-gray-800">{name}</p>
        <p className="text-xs text-gray-500">{talking ? "กำลังตอบ…" : "รอคำถามจากคุณ"}</p>
      </div>
    </div>
  );
}
