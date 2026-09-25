"use client";

import Link from "next/link";
import Image from "next/image";
import { Play, Sparkles, Stethoscope, Trophy, Zap } from "lucide-react";
import { track } from "@/lib/analytics";

/**
 * แบนเนอร์โปรโมต "เกมเคส" (/casegame) บนหน้าแรก — วางไว้บนสุดใต้ hero
 * ใช้โทน ward (พื้นเข้ม + amber/teal) เดียวกับหน้า /casegame ให้จำง่ายว่าเป็นเกม
 */
export default function CaseGamePromo({ count = 0 }: { count?: number }) {
  return (
    <section className="py-12 sm:py-16">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <Link
          href="/casegame"
          onClick={() => track("casegame_promo_click", { surface: "home" })}
          className="group relative grid overflow-hidden rounded-3xl bg-[#132320] text-white shadow-lg transition-shadow hover:shadow-xl focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-brand lg:grid-cols-[0.85fr_1.15fr]"
        >
          <div className="relative overflow-hidden">
            <Image
              src="/images/games/courses/long-case-meq.jpg"
              width={900}
              height={600}
              blurDataURL="data:image/webp;base64,UklGRlYAAABXRUJQVlA4IEoAAADQAQCdASoMAAgAA4BaJQBOgCHPEBxEAAD9sx1hW65BVuO/dk3brHYkuZ5A9qZVF6BtP4SnCSbpg60tVii2+tD3XEVmoIRImfdgAA=="
              alt="ภาพประกอบเกมฝึกคิดเป็นแพทย์ ตั้งแต่ซักประวัติจนถึงวางแผนรักษา"
              sizes="(max-width: 639px) calc(100vw - 32px), (max-width: 1023px) calc(100vw - 48px), (max-width: 1279px) 40vw, 517px"
              placeholder="blur"
              className="h-full w-full object-cover motion-safe:transition-transform motion-safe:duration-500 motion-safe:group-hover:scale-[1.03]"
            />
          </div>
          <div
            className="pointer-events-none absolute inset-0 opacity-60 transition-opacity group-hover:opacity-80"
            style={{
              background:
                "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(217,138,43,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(26,188,156,.28), transparent 55%)",
            }}
          />
          <div className="relative flex flex-col items-start gap-6 p-6 text-left sm:p-9">
            <div className="max-w-2xl space-y-3">
              <div className="flex flex-wrap items-center gap-2">
                <span className="inline-flex items-center gap-1 rounded-full bg-amber-400 px-3 py-1 text-xs font-bold text-[#132320]">
                  <Sparkles className="h-3.5 w-3.5" /> ใหม่ล่าสุด
                </span>
                <span className="font-mono text-[11px] uppercase tracking-[.35em] text-amber-400">
                  Long Case · Ward Round
                </span>
              </div>
              <h2 className="text-2xl font-bold leading-relaxed sm:text-3xl">
                เกม<span className="text-amber-400">เคส</span> — เล่นเป็นแพทย์เจ้าของไข้
              </h2>
              <p className="text-sm leading-7 text-slate-300 sm:text-base">
                ซักประวัติ ตรวจร่างกาย สั่งแลป วินิจฉัยและรักษาภายใต้เวลากดดัน —
                ทุกการตัดสินใจมีผลต่อผู้ป่วย อิงจาก Long Case จริงทุกเคส
              </p>
              <div className="flex flex-wrap items-center gap-2 pt-1 text-xs text-slate-300">
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
              <span
                className="inline-flex min-h-12 items-center gap-2 rounded-xl bg-amber-300 px-6 py-3 text-base font-bold text-[#132320] transition-colors group-hover:bg-amber-200"
              >
                <Play className="h-5 w-5" /> เล่นเกมเคสฟรี
              </span>
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
