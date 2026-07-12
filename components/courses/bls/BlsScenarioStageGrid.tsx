"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, Lock, Trophy } from "lucide-react";
import { cn } from "@/lib/utils";
import { dashCard } from "@/components/courses/course-ui";
import {
  blsScenarios,
  FINAL_EXAM_ID,
  getStageProgress,
  isFinalExamUnlocked,
  type BlsStageProgress,
} from "@/lib/courses/bls/scenarios";

interface CardInfo {
  id: string;
  step: number;
  emoji: string;
  title: string;
  subtitle: string;
  locked: boolean;
}

// Numbered stage-select grid (1-8 chapters + locked final exam) — shared by
// the standalone hub page and embedded directly on the skill-practice page
// so students see the decision game without an extra navigation hop.
//
// Progress/unlock state lives in localStorage, so it's only known on the
// client. To avoid a hydration mismatch we render the "locked / no progress"
// default on first paint (matching the server render) and fill in real
// progress after mount.
export default function BlsScenarioStageGrid() {
  const router = useRouter();
  const [finalUnlocked, setFinalUnlocked] = useState(false);
  const [progressMap, setProgressMap] = useState<Record<string, BlsStageProgress | null>>({});

  useEffect(() => {
    setFinalUnlocked(isFinalExamUnlocked());
    const map: Record<string, BlsStageProgress | null> = {};
    for (const s of blsScenarios) map[s.id] = getStageProgress(s.id);
    setProgressMap(map);
  }, []);

  const cards: CardInfo[] = [
    ...blsScenarios.map((s) => ({
      id: s.id,
      step: s.stageNumber,
      emoji: s.emoji,
      title: s.title,
      subtitle: s.subtitle,
      locked: false,
    })),
    {
      id: FINAL_EXAM_ID,
      step: blsScenarios.length + 1,
      emoji: "🏆",
      title: "ข้อสอบรวม",
      subtitle: "ทบทวนไล่ตามลำดับทุกเคส",
      locked: !finalUnlocked,
    },
  ];

  return (
    <div className="grid grid-cols-1 gap-3">
      {cards.map((c) => {
        const progress = c.locked ? null : progressMap[c.id];
        return (
          <button
            key={c.id}
            onClick={() => !c.locked && router.push(`/bls/scenario/${c.id}`)}
            disabled={c.locked}
            className={cn(
              dashCard,
              "relative flex items-center gap-3 text-left transition-colors hover:border-sky-500/40 disabled:cursor-not-allowed disabled:opacity-55",
            )}
          >
            <span className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-sky-500 text-sm font-extrabold text-white">
              {c.step}
            </span>
            <span className="shrink-0 text-2xl">{c.emoji}</span>
            <span className="min-w-0 flex-1">
              <span className="block text-sm font-bold text-foreground">{c.title}</span>
              <span className="mt-0.5 block text-xs text-muted-foreground">{c.subtitle}</span>
            </span>
            {c.locked ? (
              <Lock size={18} className="shrink-0 text-muted-foreground" />
            ) : progress?.passed ? (
              <span className="inline-flex shrink-0 items-center gap-1 text-xs font-bold text-emerald-600">
                <Check size={14} strokeWidth={3} /> {progress.pct}%
              </span>
            ) : progress ? (
              <span className="shrink-0 text-xs text-muted-foreground">{progress.pct}%</span>
            ) : c.id === FINAL_EXAM_ID ? (
              <Trophy size={18} className="shrink-0 text-amber-500" />
            ) : null}
          </button>
        );
      })}
    </div>
  );
}
