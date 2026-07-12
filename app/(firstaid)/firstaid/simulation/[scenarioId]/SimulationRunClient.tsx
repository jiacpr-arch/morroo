"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { ArrowLeft, CheckCircle2 } from "lucide-react";
import { scenariosById } from "@/lib/firstaid/content/scenarios";
import ScenarioRunner from "@/components/firstaid/ScenarioRunner";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import {
  useProgressStore,
  pushProgress,
} from "@/lib/firstaid/stores/progressStore";
import { fetchContentMedia } from "@/lib/firstaid/lessonMediaSteps";
import { track } from "@/lib/firstaid/analytics";

export default function SimulationRunClient({
  scenarioId,
}: {
  scenarioId: string;
}) {
  useEnsureLearner();
  const router = useRouter();
  const scenario = (scenariosById as Record<string, any>)[scenarioId];
  const learner = useLearnerStore((s) => s.learner);
  const markScenarioPassed = useProgressStore((s) => s.markScenarioPassed);
  const [result, setResult] = useState<{
    score: number;
    total: number;
    passed: boolean;
  } | null>(null);
  const [media, setMedia] = useState<any[]>([]);

  // โหลดสื่อที่แอดมินผูกไว้กับสถานการณ์นี้ (passthrough ใน Phase 1)
  useEffect(() => {
    let cancelled = false;
    fetchContentMedia("scenario", scenarioId).then((rows: any[]) => {
      if (!cancelled) setMedia(rows);
    });
    return () => {
      cancelled = true;
    };
  }, [scenarioId]);

  if (!scenario) {
    return (
      <div className="page-container">
        <div className="card">ไม่พบฉาก</div>
        <Link href="/simulation" className="btn btn-primary btn-block" style={{ marginTop: 12 }}>
          กลับ
        </Link>
      </div>
    );
  }

  const onFinish = ({
    history,
    score,
    total,
  }: {
    history: Array<{ stepId: string; choiceId: string; correct: boolean }>;
    score: number;
    total: number;
  }) => {
    const passed = score >= Math.ceil(total * 0.7);
    if (learner?.id) {
      // Fire-and-forget server write (แทน Dexie saveSimulationRun + flushSync).
      // endingId: ฉากในคอนเทนต์ไม่มี ending แยก — ใช้ stepId สุดท้ายที่ผู้เรียนตอบแทน
      pushProgress({
        learnerId: learner.id,
        simulationRun: {
          uuid: crypto.randomUUID(),
          scenarioId,
          endingId: history[history.length - 1]?.stepId ?? "end",
          passed,
          finishedAt: new Date().toISOString(),
        },
      });
    }
    // ผ่านฉากนี้แล้ว → อัปเดต store ทันที เพื่อให้เกณฑ์ปลดล็อก Post-test นับต่อได้เลย
    if (passed) markScenarioPassed(scenarioId);
    track("simulation_complete", { scenarioId, score, total, passed });
    setResult({ score, total, passed });
  };

  if (result) {
    return (
      <div className="page-container">
        <div className="card" style={{ textAlign: "center", padding: 28 }}>
          <CheckCircle2
            size={48}
            color={result.passed ? "#10B981" : "#D97706"}
            style={{ margin: "0 auto" }}
          />
          <div className="text-title" style={{ marginTop: 12 }}>
            ตอบถูก {result.score} / {result.total}
          </div>
          <div className="text-caption" style={{ marginTop: 4 }}>
            {result.passed ? "ผ่านเกณฑ์ 70% — เก่งมาก!" : "ลองทบทวนแล้วฝึกใหม่ได้"}
          </div>
        </div>
        <div style={{ marginTop: 16, display: "flex", gap: 8 }}>
          <button
            type="button"
            className="btn btn-secondary"
            style={{ flex: 1 }}
            onClick={() => router.push("/simulation")}
          >
            เลือกฉากอื่น
          </button>
          <button
            type="button"
            className="btn btn-primary"
            style={{ flex: 1 }}
            onClick={() => setResult(null)}
          >
            ฝึกใหม่
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container">
      <Link href="/simulation" className="btn btn-ghost" style={{ paddingLeft: 0 }}>
        <ArrowLeft size={16} /> รายการฉาก
      </Link>
      <div style={{ marginTop: 4 }}>
        <div className="text-caption">{scenario.summary}</div>
        <div className="text-title" style={{ color: scenario.color }}>{scenario.title}</div>
      </div>
      <div style={{ marginTop: 16 }}>
        <ScenarioRunner scenario={scenario} onFinish={onFinish} media={media} />
      </div>
    </div>
  );
}
