"use client";

import Link from "next/link";
import { Check, Lock, Trophy } from "lucide-react";
import {
  BLS_FINAL_ID,
  BLS_STAGES,
  countPassedStages,
  isBlsStageUnlocked,
  isFinalUnlocked,
} from "@/lib/firstaid/content/blsGame";
import { useEnsureLearner } from "@/lib/firstaid/hooks/useLearner";
import { useEnsureProgress } from "@/lib/firstaid/hooks/useProgress";
import { useLearnerStore } from "@/lib/firstaid/stores/learnerStore";
import { useProgressStore } from "@/lib/firstaid/stores/progressStore";

export default function BlsHubClient() {
  useEnsureLearner();
  const learner = useLearnerStore((s) => s.learner);
  useEnsureProgress(learner?.id);
  const passedScenarioIds = useProgressStore((s) => s.passedScenarioIds);
  const loaded = useProgressStore((s) => s.loaded);

  const passedCount = countPassedStages(passedScenarioIds);
  const finalOpen = isFinalUnlocked(passedScenarioIds);
  const finalPassed = passedScenarioIds.has(BLS_FINAL_ID);

  return (
    <div className="page-container">
      <div className="text-caption">เกมฝึกตัดสินใจ</div>
      <div className="text-display">BLS 8 ด่าน</div>
      <p className="text-body" style={{ color: "var(--color-text-muted)", marginTop: 4 }}>
        เคสต่อเนื่องด่านละหนึ่งเคส ตอบภายในเวลา เลือกแล้วล็อกเลย —
        ผ่านด่านก่อนหน้าจึงจะปลดด่านถัดไป ครบ 8 ด่านปลดข้อสอบรวม
      </p>

      <div style={{ margin: "14px 0 6px", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
        <span className="text-caption">ความคืบหน้า</span>
        <span className="text-caption" style={{ fontWeight: 700 }}>{passedCount}/8 ด่าน</span>
      </div>
      <div className="progress-track">
        <div className="progress-bar" style={{ width: `${(passedCount / 8) * 100}%` }} />
      </div>

      {/* skeleton ระหว่างรอ progress กัน "ล็อกหลอก" ของคนที่เคยผ่านแล้ว */}
      {!loaded ? (
        <div className="bls-grid" style={{ marginTop: 16 }}>
          {BLS_STAGES.map((s) => (
            <div key={s.id} className="bls-stage-card" style={{ opacity: 0.4 }}>
              <span className="bls-stage-num">ด่าน {s.stageNumber}</span>
              <span className="bls-stage-emoji">{s.emoji}</span>
              <span className="bls-stage-title">…</span>
            </div>
          ))}
        </div>
      ) : (
        <>
          <div className="bls-grid" style={{ marginTop: 16 }}>
            {BLS_STAGES.map((s) => {
              const unlocked = isBlsStageUnlocked(s.stageNumber, passedScenarioIds);
              const passed = passedScenarioIds.has(s.id);
              const card = (
                <div className={`bls-stage-card ${unlocked ? "" : "bls-locked"}`}>
                  <span className="bls-stage-num">ด่าน {s.stageNumber}</span>
                  <span className="bls-stage-emoji">{s.emoji}</span>
                  <span className="bls-stage-title">{s.title}</span>
                  {passed ? (
                    <span className="badge badge-success" style={{ alignSelf: "flex-start", marginTop: 2 }}>
                      <Check size={12} strokeWidth={3} style={{ marginRight: 3 }} /> ผ่านแล้ว
                    </span>
                  ) : (
                    <span className="text-caption">{s.steps.length} ขั้น</span>
                  )}
                  {!unlocked && <Lock size={15} className="bls-stage-lock" />}
                </div>
              );
              return unlocked ? (
                <Link key={s.id} href={`/bls/${s.id}`}>{card}</Link>
              ) : (
                <div key={s.id} aria-disabled>{card}</div>
              );
            })}
          </div>

          {/* Final Exam */}
          {finalOpen ? (
            <Link href={`/bls/${BLS_FINAL_ID}`}>
              <div
                className="card"
                style={{
                  marginTop: 14, display: "flex", alignItems: "center", gap: 12,
                  borderColor: "var(--color-warning)", background: "#FFFBEB",
                }}
              >
                <span style={{ fontSize: 30 }}>🏆</span>
                <div style={{ flex: 1 }}>
                  <div className="text-headline" style={{ color: "#92400E" }}>ข้อสอบรวม — ทบทวนทุกเคส</div>
                  <div className="text-caption">
                    {finalPassed ? "ผ่านแล้ว — เล่นทวนได้เสมอ" : "ปลดล็อกแล้ว! วัดความแม่นทั้ง 8 เคสต่อเนื่อง"}
                  </div>
                </div>
                {finalPassed && <Trophy size={20} style={{ color: "var(--color-warning)" }} />}
              </div>
            </Link>
          ) : (
            <div className="card bls-locked" style={{ marginTop: 14, display: "flex", alignItems: "center", gap: 12 }}>
              <span style={{ fontSize: 30 }}>🏆</span>
              <div style={{ flex: 1 }}>
                <div className="text-headline">ข้อสอบรวม — ทบทวนทุกเคส</div>
                <div className="text-caption">ผ่านครบทั้ง 8 ด่านก่อนจึงจะปลดล็อก</div>
              </div>
              <Lock size={18} style={{ color: "var(--color-text-muted)" }} />
            </div>
          )}
        </>
      )}
    </div>
  );
}
