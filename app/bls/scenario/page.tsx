import type { Metadata } from "next";
import Link from "next/link";
import { dashCard } from "@/components/courses/course-ui";
import BlsScenarioStageGrid from "@/components/courses/bls/BlsScenarioStageGrid";

export const metadata: Metadata = {
  title: "เกมลำดับขั้น BLS",
  description: "เกมตัดสินใจตามลำดับขั้น BLS แบบจับเวลา 8 ด่าน + ข้อสอบรวม",
};

// Stage-select hub (standalone page, e.g. for direct links/bookmarks) — the
// primary entry point is also embedded directly on the skill-practice page,
// but this route still works on its own and shares the same card grid
// component.
export default function BlsScenarioPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">เกมลำดับขั้น BLS</span>
      </nav>

      <header className="mb-6">
        <h1 className="text-2xl font-bold leading-snug sm:text-3xl">🧠 เกมลำดับขั้น BLS</h1>
      </header>

      <div className="space-y-4">
        <div className={dashCard}>
          <div className="text-sm leading-relaxed text-muted-foreground">
            เดินตามลำดับขั้น BLS ทีละด่าน <b>8 ด่าน ครบทุกบทเรียน</b> — เลือกคำตอบภายในเวลาที่กำหนด
            ตอบผิดแล้วแก้ใหม่ไม่ได้ ผ่านครบ 8 ด่านเพื่อปลดล็อก <b>ข้อสอบรวม</b>
          </div>
        </div>

        <BlsScenarioStageGrid />
      </div>
    </div>
  );
}
