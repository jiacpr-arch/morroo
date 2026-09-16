"use client";

import Link from "next/link";
import Image from "next/image";
import { useEffect, useState } from "react";
import { ArrowRight, Sparkles, Users } from "lucide-react";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";
import { getVariant, type Variant } from "@/lib/ab";
import type { HomeExamStats } from "@/lib/supabase/queries";
import HeroPriceLine from "@/components/HeroPriceLine";

const EXPERIMENT = "hero";

// เปลือก pill เดียวกันทั้งแถว แล้วให้เฉพาะไอคอนเป็นตัวแบกสี — เดิมพื้น pill
// เป็นม่วง/อำพัน/มรกต ซึ่งเป็นสามโทนที่ไม่เกี่ยวกันวางบนแบรนด์ teal
const PILL =
  "inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/[0.07] px-3.5 py-1.5 text-sm font-medium text-white/85";

const DOT_PATTERN =
  "PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGRlZnM+PHBhdHRlcm4gaWQ9ImciIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCIgcGF0dGVyblVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGggZD0iTTAgMGg2MHY2MEgweiIgZmlsbD0ibm9uZSIvPjxjaXJjbGUgY3g9IjMwIiBjeT0iMzAiIHI9IjEiIGZpbGw9InJnYmEoMjU1LDI1NSwyNTUsMC4wNSkiLz48L3BhdHRlcm4+PC9kZWZzPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9InVybCgjZykiLz48L3N2Zz4=";

type Copy = {
  badge: string;
  headlineTop: string;
  headlineAccent: string;
  subline: string;
};

// Conservative floors used only when live counts are unavailable (e.g. a build
// with Supabase not configured). The real numbers come from the DB at runtime,
// so these are deliberately just below the current bank size — never above it.
const FALLBACK_TOTAL = "6,000+";
const FALLBACK_NL = "3,500+";

function buildCopy(totalStr: string, nlStr: string): Record<Variant, Copy> {
  return {
    A: {
      badge: "แพลตฟอร์มข้อสอบ MEQ + NL + Long Case ออนไลน์",
      headlineTop: "เตรียมสอบแพทย์",
      headlineAccent: "ด้วย AI ที่เข้าใจคุณ",
      subline: `ข้อสอบ MEQ แบบ Progressive Case + ข้อสอบ NL ใบประกอบวิชาชีพ ${nlStr} ข้อ + ฝึกสอบ Long Case กับ AI Patient & Examiner`,
    },
    B: {
      badge: `${totalStr} ข้อ • MEQ • NL Step 2 • Long Case`,
      headlineTop: "สอบผ่านครั้งแรก",
      headlineAccent: `ด้วยข้อสอบ AI ${totalStr} ข้อ`,
      subline:
        "ฝึก NL Step 2 + MEQ Progressive Case + Long Case กับ AI Patient ที่ตอบโต้เหมือนคนไข้จริง — เริ่มฟรีไม่ต้องใช้บัตรเครดิต",
    },
  };
}

function trackHeroCta(variant: Variant | null, cta: string) {
  track("hero_variant_convert", {
    variant: variant ?? "unknown",
    cta,
  });
}

// ลิงก์รองใต้ CTA หลัก — เดิมเป็นปุ่มขนาดเท่ากันสามปุ่มแข่งกันเอง (MEQ /
// Long Case / MCQ) ทำให้คนลังเลว่าจะกดอันไหน ลดเหลือ CTA หลักเดียว
// ("ลองทำข้อสอบฟรี") ส่วนที่เหลือลงมาเป็น text link เล็กแทน — ยังกดถึงได้
// เหมือนเดิม แต่ไม่แย่งความสนใจจากปุ่มหลัก
function SecondaryLinks({
  variant,
  casegameCount,
}: {
  variant: Variant | null;
  casegameCount: number;
}) {
  const links: { href: string; label: string; cta: string }[] = [
    { href: "/exams", label: "ข้อสอบ MEQ", cta: "meq" },
    { href: "/longcase", label: "Long Case", cta: "longcase" },
    { href: "/nl", label: "MCQ", cta: "mcq" },
    {
      href: "/casegame",
      label: casegameCount > 0 ? `เกมเคส ${casegameCount.toLocaleString("en-US")} เคส — เล่นฟรี` : "เกมเคส — เล่นฟรี",
      cta: "casegame",
    },
  ];
  return (
    <div className="mt-5 flex flex-wrap items-center justify-center gap-x-4 gap-y-1.5 text-xs text-white/60 sm:text-sm">
      {links.map((link, i) => (
        <span key={link.cta} className="flex items-center gap-x-4">
          <Link
            href={link.href}
            onClick={() => trackHeroCta(variant, link.cta)}
            className="underline-offset-4 transition-colors hover:text-white hover:underline"
          >
            {link.label}
          </Link>
          {i < links.length - 1 && <span className="text-white/25" aria-hidden>·</span>}
        </span>
      ))}
    </div>
  );
}

export default function HeroAB({
  forced = null,
  stats = null,
}: {
  forced?: Variant | null;
  stats?: HomeExamStats | null;
}) {
  const [variant, setVariant] = useState<Variant | null>(forced);

  useEffect(() => {
    // `forced` is set by the autopilot once an A/B winner is locked in; skip
    // randomisation but keep logging views so we can still watch performance.
    if (forced) {
      track("hero_variant_view", { variant: forced });
      return;
    }
    const v = getVariant(EXPERIMENT);
    setVariant(v);
    if (v) track("hero_variant_view", { variant: v });
  }, [forced]);

  // Live numbers from the DB (refreshed every revalidate window on the server).
  const totalReady = stats?.totalReady ?? 0;
  const totalBuilding = stats?.totalBuilding ?? 0;
  const nlReady = stats?.nlReady ?? 0;
  const casegameCount = stats?.casegameCount ?? 0;
  const totalStr = totalReady > 0 ? totalReady.toLocaleString("en-US") : FALLBACK_TOTAL;
  const nlStr = nlReady > 0 ? nlReady.toLocaleString("en-US") : FALLBACK_NL;

  const copy = buildCopy(totalStr, nlStr)[variant ?? "A"];

  return (
    <section className="relative isolate overflow-hidden bg-brand-dark py-10 sm:py-16 lg:py-20">
      {/* ชั้นตกแต่งทุกชั้นเป็น absolute inset-0 — ไม่มีชิ้นไหนกว้างเกินคอนเทนเนอร์
          จึงไม่ทำให้หน้าเกิด scroll แนวนอน */}
      <div className="pointer-events-none absolute inset-0 hero-glow" />
      <div
        className={`pointer-events-none absolute inset-0 bg-[url('data:image/svg+xml;base64,${DOT_PATTERN}')] opacity-25 [mask-image:radial-gradient(ellipse_75%_65%_at_50%_35%,black,transparent)]`}
      />
      <div className="pointer-events-none absolute inset-x-0 bottom-0 h-8 bg-gradient-to-b from-transparent to-background sm:h-12 lg:h-16" />

      <div className="relative mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          {/* โลโก้ + badge อยู่แถวเดียวกัน — เดิมโลโก้ 208px กินพื้นที่ครึ่งจอบน
              จนหัวเรื่องไม่ได้เป็นพระเอก */}
          <div className="flex items-center justify-center gap-3 sm:gap-4">
            <Image
              src="/images/logo-morroo.png"
              alt="MorRoo.com หมอรู้ — ติวสอบแพทย์"
              width={208}
              height={208}
              sizes="(max-width: 639px) 64px, 88px"
              loading="eager"
              className="h-16 w-16 shrink-0 object-contain drop-shadow-[0_6px_20px_rgba(26,188,156,0.25)] sm:h-22 sm:w-22"
            />
            <span className="hidden items-center gap-2 rounded-full border border-white/15 bg-white/10 px-4 py-1.5 text-sm font-semibold text-white/90 backdrop-blur-sm sm:inline-flex">
              <Sparkles className="h-3.5 w-3.5 text-brand-light" /> {copy.badge}
            </span>
          </div>

          {/* ห้ามใช้ tracking-tight/leading-tight กับหัวเรื่องไทยขนาดนี้ —
              สระบนกับวรรณยุกต์จะชนตัวอักษรบรรทัดล่าง */}
          <h1 className="mx-auto mt-6 max-w-4xl text-[2rem] font-extrabold leading-[1.2] text-white sm:mt-8 sm:text-5xl lg:text-6xl">
            {copy.headlineTop}
            <br />
            <span className="bg-gradient-to-r from-brand-light via-emerald-300 to-brand-light bg-clip-text text-transparent">
              {copy.headlineAccent}
            </span>
          </h1>
          <p className="mx-auto mt-4 max-w-2xl text-base leading-relaxed text-white/75 sm:mt-5 sm:text-lg">
            {copy.subline}
          </p>

          {/* CTA หลักเดียว — เดิมมี 3 ปุ่มขนาดเท่ากันแข่งกันเอง (MEQ/Long Case/
              MCQ) เปลี่ยนเหลือปุ่มเดียวที่ตรงกับหลักการ "โชว์ของก่อน ค่อยขอ
              สมัคร" (ตัดสินใจไว้ 2026-07-25) — /nl/practice ทำข้อสอบได้ทันที
              ไม่ต้องสมัคร แล้วค่อยเจอกำแพงหลัง 5 ข้อซึ่งเป็นทางลัดสู่ pricing */}
          <div className="mt-8 flex flex-col items-center gap-3 sm:mt-9">
            <Link href="/nl/practice" onClick={() => trackHeroCta(variant, "try_free")}>
              <Button
                size="xl"
                className="bg-brand text-white shadow-lg shadow-brand/30 ring-1 ring-brand-light/40 hover:-translate-y-0.5 hover:bg-brand-light hover:shadow-xl hover:shadow-brand/40"
              >
                ลองทำข้อสอบฟรี — ไม่ต้องสมัคร <ArrowRight className="ml-1 h-5 w-5" />
              </Button>
            </Link>
            <HeroPriceLine surface="hero" />
          </div>

          {/* แถบพิสูจน์ — เหลือเฉพาะตัวเลขที่ไม่ถูกพูดซ้ำที่อื่นในหน้า ส่วนสถิติ
              MCQ / MEQ / Long Case / เฉลยผู้เชี่ยวชาญ ที่เคยอยู่ตรงนี้ซ้ำกับ stat
              tile ใน SocialProofSection ถัดลงไปสองจอแทบคำต่อคำ จึงตัดออกให้เหลือ
              ที่เดียว (2026-09-16) */}
          <div className="mx-auto mt-9 flex max-w-3xl flex-wrap items-center justify-center gap-2 sm:mt-10">
            <span className={PILL}>
              <Users className="h-4 w-4 text-brand-light" />
              1,000+ แพทย์ใช้งาน
            </span>
            {/* ตัวนับสดของข้อที่กำลังถูกสร้าง/ตรวจอยู่ตอนนี้ */}
            {totalBuilding > 0 && (
              <span className={PILL}>
                <span className="relative flex h-2.5 w-2.5">
                  <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-300 opacity-75" />
                  <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-emerald-300" />
                </span>
                อีก {totalBuilding.toLocaleString("en-US")} ข้อกำลังสร้าง — เพิ่มเข้าคลังเรื่อยๆ ทุกวัน
              </span>
            )}
          </div>

          <SecondaryLinks variant={variant} casegameCount={casegameCount} />
        </div>
      </div>
    </section>
  );
}
