import type { Metadata } from "next";
import Link from "next/link";
import { Zap, Shield, Construction } from "lucide-react";
import { cn } from "@/lib/utils";
import { dashCard } from "@/components/courses/course-ui";

export const metadata: Metadata = {
  title: "การใช้ AED",
  description: "Automated External Defibrillator — 5 ขั้นตอน",
};

const steps = [
  {
    n: 1,
    title: "เปิดเครื่อง AED",
    detail: "กดปุ่ม Power หรือเปิดฝา — ทำตามเสียงที่เครื่องบอกตลอด",
  },
  {
    n: 2,
    title: "ติดแผ่น Pads",
    detail:
      "แผ่นขวาบน (ใต้กระดูกไหปลาร้า) + แผ่นซ้ายล่าง (ใต้รักแร้) — ทารก: ติดหน้า-หลัง; เด็ก < 8 ปี หรือ < 25 กก.: ใช้ pediatric pads/attenuator ถ้ามี (ไม่มีก็ใช้ผู้ใหญ่ได้)",
  },
  {
    n: 3,
    title: "เคลียร์ — ห้ามแตะผู้ป่วย",
    detail: "เครื่องกำลัง analyze จังหวะหัวใจ — ให้ทุกคนถอยห่าง",
  },
  {
    n: 4,
    title: "กดปุ่ม Shock (ถ้าเครื่องสั่ง)",
    detail: "เคลียร์อีกครั้ง → กด Shock → CPR ต่อทันที 2 นาที",
  },
  {
    n: 5,
    title: "CPR ต่อ → วิเคราะห์ซ้ำ",
    detail:
      'ไม่ว่า "shock advised" หรือ "no shock advised" ให้กดหน้าอกต่อทันที 2 นาทีเสมอ (ห้ามตรวจชีพจรก่อน) — AED จะ analyze ซ้ำทุก 2 นาที ทำซ้ำจนกว่าทีม ALS มาถึง',
  },
];

export default function BlsAedPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 sm:px-6 lg:px-8">
      <nav className="mb-6 text-sm text-muted-foreground">
        <Link href="/bls" className="hover:text-foreground">
          หน้าแรก
        </Link>
        {" / "}
        <span className="text-foreground">การใช้ AED</span>
      </nav>

      <header className="mb-6 flex items-center gap-3">
        <div className="flex h-11 w-11 items-center justify-center rounded-lg bg-amber-500/15 text-amber-600">
          <Zap size={22} strokeWidth={2.2} />
        </div>
        <div>
          <h1 className="text-2xl font-bold leading-snug sm:text-3xl">การใช้ AED</h1>
          <p className="text-sm text-muted-foreground">Automated External Defibrillator — 5 ขั้นตอน</p>
        </div>
      </header>

      <div className="space-y-5">
        <div className="flex items-start gap-2 rounded-xl border border-amber-500/30 bg-amber-500/10 p-3">
          <Construction size={16} strokeWidth={2.4} className="mt-0.5 shrink-0 text-amber-600" />
          <span className="text-xs text-muted-foreground">
            เนื้อหาหลักครบแล้ว — กำลังเพิ่มรูปประกอบ + วิดีโอสาธิตในเร็วๆ นี้
          </span>
        </div>

        <div className="space-y-3">
          {steps.map((s) => (
            <div key={s.n} className={cn(dashCard, "flex items-start gap-3")}>
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full bg-amber-500/15 text-amber-600 tabular-nums">
                {s.n}
              </div>
              <div className="flex-1">
                <div className="text-sm font-semibold text-foreground">{s.title}</div>
                <div className="mt-0.5 text-xs text-muted-foreground">{s.detail}</div>
              </div>
            </div>
          ))}
        </div>

        <div className="space-y-2 rounded-xl border border-sky-500/30 bg-sky-500/10 p-4">
          <div className="flex items-center gap-2 text-sky-600">
            <Shield size={16} strokeWidth={2.4} />
            <span className="text-sm font-bold">ข้อควรระวัง</span>
          </div>
          <ul className="space-y-1 pl-2 text-sm text-muted-foreground">
            <li className="flex gap-2">
              <span className="text-sky-600">•</span>
              <span>หน้าอกเปียก → เช็ดให้แห้งก่อน</span>
            </li>
            <li className="flex gap-2">
              <span className="text-sky-600">•</span>
              <span>แผ่นยา (nitroglycerin/fentanyl patch) → ดึงออก เช็ดยาก่อนติด หรือห่าง ≥ 1 นิ้ว (2.5 ซม.) ถ้าดึงไม่ทัน</span>
            </li>
            <li className="flex gap-2">
              <span className="text-sky-600">•</span>
              <span>
                เครื่องกระตุ้นหัวใจ (pacemaker/ICD, คลำเป็นก้อนแข็งใต้ผิวหนัง) → ติดห่างให้มากที่สุด (ควร ≥ 8 ซม.) ห้ามวางทับ
              </span>
            </li>
            <li className="flex gap-2">
              <span className="text-sky-600">•</span>
              <span>ขนหน้าอกหนา → โกนหรือใช้แผ่นสำรอง</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}
