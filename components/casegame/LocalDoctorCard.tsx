"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { summarizeExpertise, type SpecialtyExpertise } from "@/lib/sim/expertise";
import { readLocalRuns, summarizeLocal } from "@/lib/sim/local-progress";
import DoctorCard from "./DoctorCard";

interface LocalState {
  xp: number;
  wins: number;
  played: number;
  specialties: SpecialtyExpertise[];
}

/**
 * การ์ด "ตัวละครของคุณ" สำหรับคนที่ยังไม่ล็อกอิน — อ่านจาก localStorage
 *
 * หน้า /casegame เป็น server component จึงอ่าน localStorage เองไม่ได้ ตัวนี้
 * เลยแยกเป็น client และเรนเดอร์หลัง mount (คืน null ตอน SSR ไม่งั้น hydration
 * จะไม่ตรง) — เงียบสนิทถ้ายังไม่เคยเล่น คนที่มาครั้งแรกจะได้เห็น hero ตามปกติ
 */
export default function LocalDoctorCard() {
  const [state, setState] = useState<LocalState | null>(null);

  useEffect(() => {
    const runs = readLocalRuns();
    if (runs.length === 0) return;
    const { xp, wins, played } = summarizeLocal(runs);
    setState({
      xp,
      wins,
      played,
      specialties: summarizeExpertise(runs.map((r) => ({ specialty: r.specialty, won: r.won }))),
    });
  }, []);

  if (!state) return null;

  return (
    <div className="space-y-2">
      <DoctorCard xp={state.xp} specialties={state.specialties} totalWins={state.wins} />
      <p className="px-1 text-xs text-muted-foreground">
        เล่นไปแล้ว {state.played} เคสในเครื่องนี้ ·{" "}
        <Link href="/login" className="font-semibold text-brand underline">
          เข้าสู่ระบบ
        </Link>{" "}
        เพื่อเก็บไว้ถาวรและขึ้น Leaderboard
      </p>
    </div>
  );
}
