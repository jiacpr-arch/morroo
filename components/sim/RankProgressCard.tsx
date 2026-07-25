"use client";

import { ChevronRight, GraduationCap } from "lucide-react";
import { EXPERTISE_TIERS, type SpecialtyExpertise } from "@/lib/sim/expertise";
import type { RankDelta } from "@/lib/school/rank-delta";
import "./rank-card.css";

interface Props extends RankDelta {
  /** ความเชี่ยวชาญของสาขาที่เพิ่งเล่น — เกม Resus ไม่มีสาขาจึงไม่ส่งมา */
  expertise?: SpecialtyExpertise | null;
  expertiseUp?: boolean;
}

/**
 * ความคืบหน้าของ "ตัวละคร" ท้ายเกม — ยศแพทย์ + ความเชี่ยวชาญสาขาที่เพิ่งเล่น
 *
 * ใช้ร่วมกันทั้งเกมเคสและ Resus Hero จึงรับเป็น field ตรง ๆ ไม่ผูกกับ
 * RecordedRun ของเกมใดเกมหนึ่ง
 *
 * แสดงเฉพาะคนที่ล็อกอิน (คนไม่ล็อกอินเห็น CTA แทน) — คืน null เงียบ ๆ เมื่อ
 * อ่านยศไม่ได้ เพื่อไม่ให้จอ debrief พังเพราะข้อมูลเสริม
 */
export default function RankProgressCard({
  rankAfter, rankBefore, rankedUp, expertise = null, expertiseUp = false,
}: Props) {
  if (!rankAfter) return null;

  const { rank, next, xpIntoRank, xpForNext, progress } = rankAfter;
  const nextExpertiseTier = expertise
    ? EXPERTISE_TIERS[expertise.tier.level + 1] ?? null
    : null;

  return (
    <div className="cbs-rank-card">
      {rankedUp && rankBefore && (
        <div className="cbs-rank-up">
          <span className="cbs-rank-up-label">เลื่อนขั้น!</span>
          <span className="cbs-rank-up-path">
            {rankBefore.rank.title}
            <ChevronRight size={14} strokeWidth={3} aria-hidden />
            <strong>{rank.title}</strong>
          </span>
        </div>
      )}

      <div className="cbs-rank-head">
        <span className="cbs-rank-icon" aria-hidden>{rank.icon}</span>
        <div className="cbs-rank-name">
          <span className="cbs-rank-title">{rank.title}</span>
          <span className="cbs-rank-trait">{rank.trait}</span>
        </div>
      </div>

      {next ? (
        <div className="cbs-rank-bar-wrap">
          <div
            className="cbs-rank-bar"
            role="progressbar"
            aria-valuenow={progress}
            aria-valuemin={0}
            aria-valuemax={100}
            aria-label={`ความคืบหน้าไปยัง${next.title}`}
          >
            <span className="cbs-rank-bar-fill" style={{ width: `${progress}%` }} />
          </div>
          <div className="cbs-rank-bar-cap">
            อีก {(xpForNext - xpIntoRank).toLocaleString("th-TH")} XP ถึง{" "}
            <strong>{next.title}</strong>
          </div>
        </div>
      ) : (
        <div className="cbs-rank-bar-cap cbs-rank-maxed">
          <GraduationCap size={14} strokeWidth={2.4} aria-hidden /> ขั้นสูงสุดของสายวิชาการแล้ว
        </div>
      )}

      {expertise && (
        <div className={`cbs-expertise ${expertiseUp ? "cbs-expertise-up" : ""}`}>
          <span className="cbs-expertise-dot" aria-hidden>{expertise.tier.icon}</span>
          <span className="cbs-expertise-body">
            <strong>{expertise.specialty}</strong> — {expertise.tier.label}
            {expertiseUp && <span className="cbs-expertise-new">ขึ้นขั้นใหม่!</span>}
            {nextExpertiseTier && expertise.winsToNext !== null && (
              <span className="cbs-expertise-next">
                ชนะอีก {expertise.winsToNext} เคสถึงขั้น {nextExpertiseTier.label}
              </span>
            )}
          </span>
        </div>
      )}
    </div>
  );
}
