"use client";

import Link from "next/link";
import Image from "next/image";
import { useEffect, useState } from "react";
import { ArrowRight, BookOpen, Check, Sparkles, Users } from "lucide-react";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { track } from "@/lib/analytics";
import { getVariant, type Variant } from "@/lib/ab";
import type { HomeExamStats } from "@/lib/supabase/queries";
import HeroPriceLine from "@/components/HeroPriceLine";

const EXPERIMENT = "hero";

// เปลือก pill เดียวกันทั้งแถว แล้วให้เฉพาะไอคอนเป็นตัวแบกสี — เดิมพื้น pill
// เป็นม่วง/อำพัน/มรกต ซึ่งเป็นสามโทนที่ไม่เกี่ยวกันวางบนแบรนด์ teal
const PILL =
  "inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/[0.07] px-3.5 py-1.5 text-sm font-medium text-white/85";

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
    <div className="mt-5 flex flex-wrap items-center justify-center gap-x-4 gap-y-1.5 text-xs text-white/75 sm:text-sm lg:justify-start">
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
    <section className="relative isolate overflow-hidden bg-brand-dark py-10 sm:py-14 lg:py-20">
      <div className="pointer-events-none absolute inset-0 hero-glow" aria-hidden="true" />
      <div className="relative mx-auto grid max-w-7xl items-center gap-10 px-4 sm:px-6 lg:grid-cols-[1.05fr_1fr] lg:gap-12 lg:px-8">
        <div className="min-w-0 text-center lg:text-left">
          <div className="flex items-center justify-center gap-3 lg:justify-start">
            <Image
              src="/images/logo-morroo.png"
              alt="MorRoo.com หมอรู้ — ติวสอบแพทย์"
              width={64}
              height={64}
              className="h-14 w-14 shrink-0 object-contain"
            />
            <p className="text-left text-sm leading-relaxed text-white/80">
              <span className="block font-semibold text-emerald-200">พื้นที่เรียนรู้ของว่าที่คุณหมอ</span>
              ค่อย ๆ เก่งขึ้น ในทุกวัน
            </p>
          </div>
          <div className="mt-6 inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/[0.07] px-3 py-2 text-xs text-white/85 sm:text-sm">
            <Sparkles className="h-4 w-4 shrink-0 text-brand-light" aria-hidden="true" />
            {copy.badge}
          </div>
          <h1 className="mt-5 text-[1.9rem] font-bold leading-[1.4] text-white sm:text-[2.75rem] lg:text-[2.6rem] xl:text-5xl">
            {copy.headlineTop}
            <br />
            <span className="text-emerald-300">{copy.headlineAccent}</span>
          </h1>
          <p className="mx-auto mt-4 max-w-xl text-base leading-relaxed text-white/80 lg:mx-0">
            {copy.subline}
          </p>

          {/* Keep the existing single primary CTA, experiment and pricing events. */}
          <div className="mt-7 flex flex-col items-center gap-3 lg:items-start">
            <Link
              href="/nl/practice"
              onClick={() => trackHeroCta(variant, "try_free")}
              className={cn(
                buttonVariants({ size: "xl" }),
                "h-auto min-h-12 max-w-full whitespace-normal bg-emerald-300 px-5 py-3 text-center text-brand-dark shadow-lg shadow-black/10 hover:bg-emerald-200",
              )}
            >
              ลองทำข้อสอบฟรี — ไม่ต้องสมัคร <ArrowRight className="h-5 w-5 shrink-0" aria-hidden="true" />
            </Link>
            <HeroPriceLine surface="hero" />
          </div>
          <div className="mt-6 flex flex-wrap items-center justify-center gap-2 lg:justify-start">
            <span className={PILL}>
              <Users className="h-4 w-4 text-brand-light" aria-hidden="true" />
              1,000+ แพทย์ใช้งาน
            </span>
            {totalBuilding > 0 && (
              <span className={PILL}>
                <span className="h-2 w-2 shrink-0 rounded-full bg-emerald-300" aria-hidden="true" />
                อีก {totalBuilding.toLocaleString("en-US")} ข้อกำลังสร้าง
              </span>
            )}
          </div>
          <SecondaryLinks variant={variant} casegameCount={casegameCount} />
        </div>

        <div className="min-w-0">
          <figure className="overflow-hidden rounded-[1.75rem] border border-white/15 bg-[#f6f4eb] shadow-2xl shadow-black/20">
            <div className="relative">
              <Image
                src="/images/home/medical-study-together.webp"
                width={1440}
                height={960}
                blurDataURL="data:image/webp;base64,UklGRlQAAABXRUJQVlA4IEgAAADwAQCdASoMAAgAA4BaJZACdAEVu7JBnGgA3i8bsHGrKJSncXxGVsXuRK3M1gTHIaq90vBdPAB4q3rjacXuintYd4PoyBUMAAA="
                alt="ภาพประกอบนักศึกษาแพทย์ทบทวนบทเรียนด้วยกันในบรรยากาศอบอุ่น"
                sizes="(max-width: 639px) calc(100vw - 32px), (max-width: 1023px) calc(100vw - 48px), (max-width: 1279px) 46vw, 568px"
                preload
                placeholder="blur"
                className="aspect-[3/2] w-full object-cover"
              />
              <span className="absolute right-3 bottom-3 rounded-full bg-black/50 px-2.5 py-1 text-[10px] text-white">ภาพประกอบ</span>
            </div>
            <figcaption className="flex items-center gap-4 p-5 sm:p-6">
              <span className="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-[#e2ebe0] text-brand-dark" aria-hidden="true">
                <BookOpen className="h-5 w-5" />
              </span>
              <div>
                <p className="text-lg font-bold leading-relaxed text-brand-dark">เส้นทางสู่การเป็นหมอ เริ่มทีละก้าว</p>
                <p className="mt-1 text-sm leading-relaxed text-[#536557]">อ่านให้เข้าใจ ฝึกให้มั่นใจ ไปกับหมอรู้</p>
              </div>
            </figcaption>
          </figure>
          <div className="mt-5 flex flex-wrap justify-center gap-x-5 gap-y-2 text-xs text-white/80 sm:text-sm">
            {["เรียนตามจังหวะของคุณ", "ฝึกได้ทุกที่", "เริ่มต้นได้ฟรี"].map((label) => (
              <span key={label} className="inline-flex items-center gap-1.5">
                <Check className="h-3.5 w-3.5 text-emerald-300" aria-hidden="true" /> {label}
              </span>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
