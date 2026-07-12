import type { Metadata } from "next";
import Link from "next/link";
import { Wind, Users, Baby, AlertTriangle, Construction, type LucideIcon } from "lucide-react";
import { cn } from "@/lib/utils";
import { dashCard, textHeadline } from "@/components/courses/course-ui";

export const metadata: Metadata = {
  title: "ช่วยเหลือคนสำลัก",
  description: "Choking Relief — Foreign-Body Airway Obstruction",
};

type Tone = "info" | "warning" | "danger";

interface ChokingSection {
  id: string;
  Icon: LucideIcon;
  title: string;
  color: Tone;
  bullets: string[];
}

const sections: ChokingSection[] = [
  {
    id: "adult",
    Icon: Users,
    title: "ผู้ใหญ่ / เด็กโต — รู้ตัว",
    color: "info",
    bullets: [
      'ถามว่า "สำลักไหม?" — ถ้าไอแรงๆ ได้ ให้รอ',
      "ไอไม่ออก / พูดไม่ได้ → ทำ Abdominal Thrusts (Heimlich)",
      "ยืนด้านหลัง → กำมือใต้สะดือ → กระตุกเข้าและขึ้น",
      "หญิงตั้งครรภ์ระยะท้าย / อ้วนมาก → ใช้ Chest Thrusts แทน Abdominal Thrusts (Back Blows ทำได้ตามปกติ)",
      "ทำซ้ำจนวัตถุหลุด หรือผู้ป่วยหมดสติ",
    ],
  },
  {
    id: "infant",
    Icon: Baby,
    title: "ทารก < 1 ปี — รู้ตัว",
    color: "warning",
    bullets: [
      "คว่ำหน้าบนแขน หัวต่ำกว่าตัว → ตบหลัง 5 ครั้ง (Back Blows)",
      "พลิกหงาย → กด Chest Thrusts 5 ครั้ง (จุดเดียวกับ CPR)",
      "สลับ Back Blows / Chest Thrusts จนวัตถุหลุด",
      "ห้ามทำ Abdominal Thrusts ในทารก",
    ],
  },
  {
    id: "unconscious",
    Icon: AlertTriangle,
    title: "หมดสติ",
    color: "danger",
    bullets: [
      "วางผู้ป่วยลงพื้น → เรียก EMS ทันที",
      "เริ่ม CPR (30:2) — ก่อนเป่าให้ดูในปาก",
      "เห็นวัตถุ → เอาออก (ห้าม blind finger sweep)",
      "CPR ต่อจนทีมช่วยเหลือมาถึง",
      "หลังช่วยเหลือสำเร็จ ควรให้ EMS/แพทย์ประเมินต่อเสมอ (เสี่ยงบาดเจ็บอวัยวะภายในจาก thrusts + สิ่งของอาจหลงเหลือ)",
    ],
  },
];

const colorClass: Record<Tone, string> = {
  info: "bg-sky-500/15 text-sky-600",
  warning: "bg-amber-500/15 text-amber-600",
  danger: "bg-red-500/15 text-red-600",
};

const bulletClass: Record<Tone, string> = {
  info: "text-sky-600",
  warning: "text-amber-600",
  danger: "text-red-600",
};

export default function BlsChokingPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">ช่วยเหลือคนสำลัก</span>
      </nav>

      <header className="mb-6 flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-lg bg-sky-500/15 text-sky-600">
          <Wind size={22} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-2xl font-bold leading-snug sm:text-3xl">ช่วยเหลือคนสำลัก</h1>
          <p className="text-sm text-muted-foreground">Choking Relief — Foreign-Body Airway Obstruction</p>
        </div>
      </header>

      <div className="space-y-5">
        <div className="flex items-start gap-2 rounded-xl border border-amber-500/30 bg-amber-500/10 p-3">
          <Construction size={16} strokeWidth={2.4} className="mt-0.5 shrink-0 text-amber-600" />
          <span className="text-xs text-muted-foreground">
            เนื้อหาหลักครบแล้ว — กำลังเพิ่มรูป + วิดีโอสาธิตในเร็วๆ นี้
          </span>
        </div>

        <div className="space-y-3">
          {sections.map((s) => {
            const SIcon = s.Icon;
            return (
              <div key={s.id} className={cn(dashCard, "space-y-2")}>
                <div className="flex items-center gap-3">
                  <div
                    className={cn(
                      "flex h-9 w-9 shrink-0 items-center justify-center rounded-md",
                      colorClass[s.color],
                    )}
                  >
                    <SIcon size={18} strokeWidth={2.2} />
                  </div>
                  <div className={textHeadline}>{s.title}</div>
                </div>
                <ul className="space-y-1 pl-2">
                  {s.bullets.map((b, i) => (
                    <li key={i} className="flex gap-2 text-sm text-muted-foreground">
                      <span className={cn("shrink-0", bulletClass[s.color])}>•</span>
                      <span>{b}</span>
                    </li>
                  ))}
                </ul>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
