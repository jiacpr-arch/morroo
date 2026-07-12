import type { Metadata } from "next";
import Link from "next/link";
import { GitBranch, HeartPulse, Baby, Users, ChevronRight, Construction } from "lucide-react";
import { cn } from "@/lib/utils";
import { dashCard, textHeadline } from "@/components/courses/course-ui";

export const metadata: Metadata = {
  title: "BLS Algorithm",
  description: "ขั้นตอนช่วยชีวิตตาม ILCOR 2025",
};

const variants = [
  {
    id: "adult",
    Icon: Users,
    title: "Adult BLS",
    subtitle: "ผู้ใหญ่ (≥ 8 ปี) — Single & 2-rescuer",
    bullets: [
      "ประเมินที่เกิดเหตุ + เรียกขอความช่วยเหลือ",
      "CPR 30:2 (single) หรือ 30:2 / 15:2 (2-rescuer ตามอายุ)",
      "AED มาถึง → ใช้ทันที",
      "กดลึก 5–6 ซม. อัตรา 100–120/นาที ปล่อยหน้าอกคืนตัวเต็มที่ (full recoil)",
      "จำกัดการหยุดกดหน้าอกไม่เกิน 10 วินาทีต่อครั้ง (เป้า CCF > 80%)",
    ],
  },
  {
    id: "pediatric",
    Icon: HeartPulse,
    title: "Pediatric BLS",
    subtitle: "เด็ก (1 ปี – วัยรุ่น)",
    bullets: [
      "อัตราส่วน 30:2 (1 ผู้ช่วยเหลือ) / 15:2 (≥ 2 ผู้ช่วยเหลือ)",
      "ความลึก compression ≈ 1/3 ของหน้าอก (~5 ซม.)",
      "AED: ใช้ pediatric pads ถ้ามี (ถ้าไม่มีใช้ผู้ใหญ่)",
      "อัตรา 100–120 ครั้ง/นาที เช่นเดียวกับผู้ใหญ่",
    ],
  },
  {
    id: "infant",
    Icon: Baby,
    title: "Infant BLS",
    subtitle: "ทารก (< 1 ปี)",
    bullets: [
      "Heel-of-1-hand (1 rescuer) หรือ 2-thumb encircling (2 rescuer) — เลิกใช้ 2-finger technique แล้ว",
      "ความลึก ≈ 4 ซม. (1/3 ของหน้าอก)",
      "อัตราส่วน 30:2 / 15:2",
      "เปิดทางเดินหายใจด้วยท่า neutral/sniffing — ห้ามเอียงศีรษะแบบผู้ใหญ่ (hyperextension)",
      'ไม่มีคนเห็นเหตุการณ์ + ช่วยเหลือคนเดียว → CPR ก่อน ~2 นาที แล้วค่อยโทรขอ EMS ("phone fast")',
    ],
  },
];

export default function BlsAlgorithmPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">BLS Algorithm</span>
      </nav>

      <header className="mb-6 flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600">
          <GitBranch size={22} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-2xl font-bold leading-snug sm:text-3xl">BLS Algorithm</h1>
          <p className="text-sm text-muted-foreground">ขั้นตอนช่วยชีวิตตาม ILCOR 2025</p>
        </div>
      </header>

      <div className="space-y-5">
        <div className="flex items-start gap-2 rounded-xl border border-amber-500/30 bg-amber-500/10 p-3">
          <Construction size={16} strokeWidth={2.4} className="mt-0.5 shrink-0 text-amber-600" />
          <span className="text-xs text-muted-foreground">
            หน้านี้กำลังพัฒนา — เนื้อหา algorithm แบบเต็ม (รูป flowchart + รายละเอียดแต่ละขั้น) จะเพิ่มในเร็วๆ นี้
          </span>
        </div>

        <div className="space-y-3">
          {variants.map((v) => {
            const VIcon = v.Icon;
            return (
              <div key={v.id} className={cn(dashCard, "space-y-2")}>
                <div className="flex items-center gap-3">
                  <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-md bg-sky-500/15 text-sky-600">
                    <VIcon size={18} strokeWidth={2.2} />
                  </div>
                  <div>
                    <div className={textHeadline}>{v.title}</div>
                    <div className="text-xs text-muted-foreground">{v.subtitle}</div>
                  </div>
                </div>
                <ul className="space-y-1 pl-2">
                  {v.bullets.map((b, i) => (
                    <li key={i} className="flex gap-2 text-sm text-muted-foreground">
                      <span className="shrink-0 text-sky-600">•</span>
                      <span>{b}</span>
                    </li>
                  ))}
                </ul>
              </div>
            );
          })}
        </div>

        <Link
          href="/bls/skill-practice"
          className={cn(dashCard, "flex items-center gap-3 border border-border hover:border-sky-500/40")}
        >
          <div className="flex h-9 w-9 items-center justify-center rounded-md bg-emerald-500/15 text-emerald-600">
            <HeartPulse size={16} strokeWidth={2.2} />
          </div>
          <div className="flex-1">
            <div className="text-sm font-semibold text-foreground">ฝึก CPR Metronome</div>
            <div className="text-[11px] text-muted-foreground">ฝึก compression rate 100–120/นาที</div>
          </div>
          <ChevronRight size={16} strokeWidth={2.2} className="text-muted-foreground" />
        </Link>
      </div>
    </div>
  );
}
