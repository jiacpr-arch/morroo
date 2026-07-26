import { xpToRank } from "@/lib/school/rank";
import { xpToLevel } from "@/lib/school/xp";

interface Props {
  xp: number;
  /** ต่อท้ายด้วย "Lv.N" — ใช้ในหน้าที่เคยแสดง level ตัวเลขมาก่อน คนเดิมจะได้ไม่งง */
  showLevel?: boolean;
  size?: "sm" | "md";
  className?: string;
}

/**
 * ป้ายยศแพทย์ — ตัวกลางที่ทุกหน้านอกเกมใช้ร่วมกัน
 *
 * มีไว้เพื่อไม่ให้เว็บพูดสองภาษา: ก่อนหน้านี้ /school กับ leaderboard แสดง
 * "Level 3" ส่วนโซนเกมแสดง "เอกซ์เทิร์น" ทั้งที่มาจาก school_xp ก้อนเดียวกัน
 *
 * server component ล้วน (ไม่มี state) — วางในหน้าไหนก็ได้
 */
export default function RankBadge({ xp, showLevel = false, size = "md", className = "" }: Props) {
  const { rank } = xpToRank(xp);
  const text = size === "sm" ? rank.short : rank.title;

  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full border border-amber-300 bg-amber-50 font-semibold text-amber-800 ${
        size === "sm" ? "px-2 py-0.5 text-[11px]" : "px-2.5 py-1 text-xs"
      } ${className}`}
      title={rank.trait}
    >
      <span aria-hidden>{rank.icon}</span>
      {text}
      {showLevel && (
        <span className="font-normal text-amber-700/70">· Lv.{xpToLevel(xp).level}</span>
      )}
    </span>
  );
}
