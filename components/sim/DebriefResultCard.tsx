"use client";

// "ผลของคุณ" — การ์ดแรกที่เห็นตอนจบเกมเคส รวมคะแนน/เกรด, จุดที่พลาด, และ
// "เทียบกับผู้เล่นอื่น" (percentile) ไว้ที่เดียวก่อนถึง CTA สมัคร — เดิมมีแค่
// grade box + metric grid ลอยๆ ไม่มีบริบทว่า "ดีแค่ไหนเทียบคนอื่น" เลย
//
// แสดงให้ทั้งผู้เล่นที่ล็อกอินและยังไม่ล็อกอิน (ต่างจาก DebriefSignupCta ที่
// โชว์เฉพาะ guest) — rank fetch เป็น fire-and-forget เสมอ ไม่บล็อกอะไร และข้าม
// เมื่อเป็นโหมด practice (admin playtest ไม่นับสถิติ)

import { useEffect, useRef, useState } from "react";
import { fmtTime } from "@/lib/sim/engine";
import { track } from "@/lib/analytics";
import { CASEGAME_EVENTS, buildRankViewProps, caseGameCategory } from "@/lib/sim/track";
import { rankCopy, weakSpecialtiesFromLocal, weakestPoint } from "@/lib/sim/debrief-summary";
import type { LocalRun } from "@/lib/sim/local-progress";
import type { SimState } from "@/lib/sim/types";

interface RankState {
  scope: "slug" | "category" | null;
  sample: number;
  below: number;
  tie: number;
  percentile: number | null;
}

interface Props {
  slug: string;
  category?: string;
  runId: string;
  result: { won: boolean; grade: string; score: number };
  state: Pick<SimState, "wrong" | "simTime" | "timeline" | "firstCPRAt" | "firstShockAt">;
  isLongcase: boolean;
  practice: boolean;
  /** ประวัติในเครื่อง — [] เมื่อล็อกอินอยู่ (อ่านสาขาอ่อนจากบัญชีแทนได้ในอนาคต) */
  history: LocalRun[];
  onRank?: (percentile: number | null) => void;
}

function Metric({ label, value, tone }: { label: string; value: string; tone: string }) {
  return (
    <div className="cbs-metric">
      <span className="cbs-metric-label">{label}</span>
      <span className={`cbs-metric-val ${tone ? `cbs-${tone}` : ""}`}>{value}</span>
    </div>
  );
}

export default function DebriefResultCard({
  slug, category, runId, result, state, isLongcase, practice, history, onRank,
}: Props) {
  const [rank, setRank] = useState<RankState | null>(null);
  const viewedRunRef = useRef("");

  useEffect(() => {
    if (practice) return;
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 2500);

    fetch(
      `/api/casegame/rank?slug=${encodeURIComponent(slug)}&score=${result.score}&category=${caseGameCategory(category)}`,
      { signal: controller.signal },
    )
      .then((r) => (r.ok ? r.json() : null))
      .then((data: RankState | null) => {
        if (!data) return;
        setRank(data);
        onRank?.(data.percentile);
        if (viewedRunRef.current !== runId) {
          viewedRunRef.current = runId;
          track(
            CASEGAME_EVENTS.rankView,
            buildRankViewProps({
              slug, category, runId, scope: data.scope, sample: data.sample, percentile: data.percentile,
            }),
          );
        }
      })
      .catch(() => {
        // เน็ตช้า/route ล่ม — แถว rank แค่ไม่โผล่ ไม่ทำให้จอ debrief พัง
      });

    return () => {
      clearTimeout(timeout);
      controller.abort();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [slug, category, runId, result.score, practice]);

  const weak = weakestPoint(state.timeline);
  const weakSpecialties = history.length > 1 ? weakSpecialtiesFromLocal(history) : [];
  const rankLine = rank
    ? rankCopy({ won: result.won, scope: rank.scope, sample: rank.sample, below: rank.below, tie: rank.tie })
    : null;

  return (
    <div className="cbs-result-card">
      <div className="cbs-result-title">ผลของคุณ</div>
      <div className="cbs-grade-row">
        <div className="cbs-grade-box">
          <span className={`cbs-grade cbs-g-${result.grade.toLowerCase()}`}>{result.grade}</span>
          <span className="cbs-grade-label">GRADE</span>
        </div>
        <div className="cbs-metric-grid">
          {!isLongcase && (
            <>
              <Metric
                label="เริ่ม CPR ภายใน"
                value={state.firstCPRAt >= 0 ? fmtTime(state.firstCPRAt) : "—"}
                tone={state.firstCPRAt >= 0 && state.firstCPRAt <= 90 ? "good" : "warn"}
              />
              <Metric
                label="Shock แรกภายใน"
                value={state.firstShockAt >= 0 ? fmtTime(state.firstShockAt) : "—"}
                tone={state.firstShockAt >= 0 && state.firstShockAt <= 300 ? "good" : "warn"}
              />
            </>
          )}
          <Metric
            label="ตัดสินใจพลาด"
            value={String(state.wrong)}
            tone={state.wrong === 0 ? "good" : state.wrong <= 2 ? "warn" : "badv"}
          />
          <Metric label="เวลาทั้งเคส" value={fmtTime(state.simTime)} tone="" />
        </div>
      </div>

      {weak && (
        <p className="cbs-result-weak">
          จุดที่พลาด: {weak.text}
          {weak.note && <> — {weak.note}</>}
          {weak.moreErrors > 0 && ` (และอีก ${weak.moreErrors} จุด)`}
        </p>
      )}
      {!weak && (
        <p className="cbs-result-weak cbs-result-weak-clean">ไม่พลาดสักคำสั่ง — ไร้ที่ติ</p>
      )}

      {rankLine && <p className="cbs-result-rank">{rankLine}</p>}

      {weakSpecialties.length > 0 && (
        <p className="cbs-result-weak">สาขาที่ยังไม่ผ่าน: {weakSpecialties.join(", ")}</p>
      )}
    </div>
  );
}
