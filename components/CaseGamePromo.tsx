import Link from "next/link";
import { Play, Sparkles, Stethoscope, Trophy, Zap } from "lucide-react";
import { Button } from "@/components/ui/button";

/**
 * แบนเนอร์โปรโมต "เกมเคส" (/casegame) บนหน้าแรก — วางไว้บนสุดใต้ hero
 * ใช้โทน ward (พื้นเข้ม + amber/teal) เดียวกับหน้า /casegame ให้จำง่ายว่าเป็นเกม
 */
export default function CaseGamePromo({ count = 0 }: { count?: number }) {
  return (
    <section className="py-10 sm:py-12">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <Link
          href="/casegame"
          className="group relative block overflow-hidden rounded-2xl bg-[#132320] px-6 py-8 text-white shadow-lg transition-shadow hover:shadow-xl sm:px-10 sm:py-10"
        >
          <div
            className="pointer-events-none absolute inset-0 opacity-60 transition-opacity group-hover:opacity-80"
            style={{
              background:
                "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(217,138,43,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(26,188,156,.28), transparent 55%)",
            }}
          />
          <div className="relative flex flex-col items-center gap-6 text-center lg:flex-row lg:items-center lg:justify-between lg:text-left">
            <div className="max-w-2xl space-y-3">
              <div className="flex flex-wrap items-center justify-center gap-2 lg:justify-start">
                <span className="inline-flex items-center gap-1 rounded-full bg-amber-400 px-3 py-1 text-xs font-bold text-[#132320]">
                  <Sparkles className="h-3.5 w-3.5" /> ใหม่ล่าสุด
                </span>
                <span className="font-mono text-[11px] uppercase tracking-[.35em] text-amber-400">
                  Long Case · Ward Round
                </span>
              </div>
              <h2 className="text-3xl font-black sm:text-4xl">
                เกม<span className="text-amber-400">เคส</span> — เล่นเป็นแพทย์เจ้าของไข้
              </h2>
              <p className="text-sm leading-7 text-slate-300 sm:text-base">
                ซักประวัติ ตรวจร่างกาย สั่งแลป วินิจฉัยและรักษาภายใต้เวลากดดัน —
                ทุกการตัดสินใจมีผลต่อผู้ป่วย อิงจาก Long Case จริงทุกเคส
              </p>
              <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs text-slate-300 lg:justify-start">
                <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
                  <Stethoscope className="h-3.5 w-3.5 text-teal-400" />
                  {count > 0 ? `${count.toLocaleString("en-US")} เคสให้เล่น` : "อิงจาก Long Case จริง"}
                </span>
                <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
                  <Zap className="h-3.5 w-3.5 text-amber-400" /> เก็บ XP + Badge
                </span>
                <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
                  <Trophy className="h-3.5 w-3.5 text-amber-400" /> ขึ้น Leaderboard
                </span>
              </div>
            </div>
            <div className="shrink-0">
              <Button
                size="lg"
                className="pointer-events-none gap-2 bg-amber-500 px-8 text-base font-bold text-white transition-transform group-hover:scale-105 group-hover:bg-amber-400"
              >
                <Play className="h-5 w-5" /> เล่นเกมเคสฟรี
              </Button>
              <p className="mt-2 text-center text-xs text-slate-400">
                ไม่ต้องสมัครสมาชิกก็เล่นได้
              </p>
            </div>
          </div>
        </Link>
      </div>
    </section>
  );
}
