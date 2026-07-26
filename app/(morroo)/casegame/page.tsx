import type { Metadata } from "next";
import Link from "next/link";
import { BookOpen, Stethoscope, Zap } from "lucide-react";
import {
  getLongcaseGameCards,
  getMeqGameCards,
  getMyDoctorProfile,
  getMySimBests,
  getPolishedLongcaseCards,
  getSimScenariosByCategory,
} from "@/lib/supabase/queries-sim";
import DoctorCard from "@/components/casegame/DoctorCard";
import LocalDoctorCard from "@/components/casegame/LocalDoctorCard";
import {
  normalizeDifficulty,
  normalizeSpecialty,
  type CaseCard,
} from "@/lib/casegame/normalize";
import CaseGameBrowser from "@/components/casegame/CaseGameBrowser";
import { getBuiltinScenario } from "@/lib/sim/scenarios";

export const metadata: Metadata = {
  title: "เกมเคส — Long Case Decision Game",
  description:
    "เล่นเคสผู้ป่วยแบบเกมตัดสินใจ ซักประวัติ ตรวจร่างกาย สั่งแลป วินิจฉัยและรักษาภายใต้เวลากดดัน อิงจาก Long Case จริงทุกเคส เก็บ XP ขึ้น Leaderboard",
  alternates: { canonical: "https://www.morroo.com/casegame" },
};

export const dynamic = "force-dynamic";

/**
 * ส่ง utm ต่อไปยังหน้าเล่นเกม — คนที่มาจากโฆษณาแล้วคลิกเลือกเคสจากหน้านี้
 * ต้องยังผูกกับแคมเปญได้ตอนกรอกอีเมลท้ายเกม ไม่งั้นเทียบปลายทางโฆษณาสองแบบ
 * (หน้ารวม vs ยิงเข้าเคสตรง) ไม่ได้เลย
 */
function utmQuery(sp: { [key: string]: string | string[] | undefined }): string {
  // `start` ส่งต่อด้วย เพื่อให้คนที่มาจากโฆษณาแล้วเลือกเคสจากหน้านี้เข้าเกมทันที
  // เหมือนกับคนที่โฆษณายิงเข้าเคสตรงๆ
  const carry = new URLSearchParams();
  for (const key of ["utm_source", "utm_medium", "utm_campaign", "utm_content", "start"]) {
    const value = sp[key];
    if (typeof value === "string" && value) carry.set(key, value);
  }
  const qs = carry.toString();
  return qs ? `?${qs}` : "";
}

interface PageProps {
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}

export default async function CaseGameHubPage({ searchParams }: PageProps) {
  const [polished, polishedCards, longcaseCards, meqCards, bests, doctor, sp] =
    await Promise.all([
      getSimScenariosByCategory("longcase"),
      getPolishedLongcaseCards(),
      getLongcaseGameCards(),
      getMeqGameCards(),
      getMySimBests(),
      getMyDoctorProfile(),
      searchParams,
    ]);

  // "เคสแนะนำ" = เคสคัดมือที่เขียนเองในโค้ด (built-in) เท่านั้น
  // เคสที่ AI แปลงไว้มีเป็นร้อย ถ้าเอามาไว้ตรงนี้ทั้งหมดหน้าจะยาวมากและกรอง
  // ตามสาขาไม่ได้ — ย้ายลงลิสต์หลักที่จัดกลุ่ม/พับ/กรองได้แทน
  //
  // เช็คจาก built-in list ไม่ใช่ sourceCaseId เพราะเคสคัดมือก็ชี้ sourceCaseId
  // ไปเคสต้นทางเหมือนกัน (เพื่อซ่อนเวอร์ชันสังเคราะห์)
  const featured: CaseCard[] = polished
    .filter((s) => getBuiltinScenario(s.slug))
    .map((s) => ({
      slug: s.slug,
      title: s.title,
      subtitle: s.subtitle,
      specialty: normalizeSpecialty(null),
      difficulty: normalizeDifficulty(s.difficultyTag),
      type: "featured" as const,
    }));

  const cards: CaseCard[] = [
    // กันซ้ำกับเคสแนะนำ ถ้าใน DB มี slug เดียวกับ built-in
    ...polishedCards
      .filter((c) => !getBuiltinScenario(c.slug))
      .map((c) => ({
      slug: c.slug,
      title: c.title,
      subtitle: c.subtitle,
      specialty: normalizeSpecialty(c.specialty),
      difficulty: normalizeDifficulty(c.difficulty),
      type: "longcase" as const,
      audience: c.audience,
    })),
    ...longcaseCards.map((c) => ({
      slug: c.slug,
      title: c.title,
      specialty: normalizeSpecialty(c.specialty),
      difficulty: normalizeDifficulty(c.difficulty),
      type: "longcase" as const,
      audience: c.audience,
    })),
    ...meqCards.map((c) => ({
      slug: c.slug,
      title: c.title,
      subtitle: c.subtitle,
      specialty: normalizeSpecialty(c.specialty),
      difficulty: normalizeDifficulty(c.difficulty),
      type: "meq" as const,
    })),
  ];

  const isEmpty = featured.length + cards.length === 0;

  return (
    <div className="mx-auto max-w-4xl px-4 py-10 sm:px-6">
      {/* Hero โทน ward (amber/teal) */}
      <section className="relative overflow-hidden rounded-2xl bg-[#132320] px-6 py-10 text-center text-white sm:px-10">
        <div
          className="pointer-events-none absolute inset-0 opacity-60"
          style={{
            background:
              "radial-gradient(ellipse 130% 60% at 50% -10%, rgba(217,138,43,.35), transparent 60%), radial-gradient(ellipse 120% 60% at 50% 115%, rgba(26,188,156,.28), transparent 55%)",
          }}
        />
        <div className="relative space-y-3">
          <p className="font-mono text-[11px] uppercase tracking-[.4em] text-amber-400">
            Long Case · Ward Round
          </p>
          <h1 className="text-3xl font-black sm:text-4xl">
            เกม<span className="text-amber-400">เคส</span>
          </h1>
          <p className="mx-auto max-w-md text-sm leading-7 text-slate-300">
            คุณคือ <b className="text-white">แพทย์เจ้าของไข้</b> — ซักประวัติ ตรวจร่างกาย
            สั่งแลป วินิจฉัยและรักษา ทุกการตัดสินใจมีผลต่อผู้ป่วยจริง
          </p>
          <div className="flex flex-wrap items-center justify-center gap-2 pt-1 text-xs text-slate-300">
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Stethoscope className="h-3.5 w-3.5 text-teal-400" /> เล่นไล่จากง่ายไปยาก
            </span>
            <span className="inline-flex items-center gap-1 rounded-full border border-white/20 px-3 py-1">
              <Zap className="h-3.5 w-3.5 text-amber-400" /> เก็บ XP + Badge
            </span>
          </div>
        </div>
      </section>

      <div className="mt-6">
        {doctor ? (
          <DoctorCard
            xp={doctor.xp}
            specialties={doctor.specialties}
            totalWins={doctor.totalWins}
          />
        ) : (
          /* ยังไม่ล็อกอิน — โชว์ความคืบหน้าที่เก็บไว้ในเครื่อง (ถ้ามี) */
          <LocalDoctorCard />
        )}
      </div>

      {isEmpty ? (
        <div className="mt-8 rounded-xl border bg-white py-16 text-center text-muted-foreground">
          <BookOpen className="mx-auto mb-3 h-12 w-12 opacity-30" />
          <p>กำลังเพิ่มเกมเคสใหม่ เร็วๆ นี้</p>
        </div>
      ) : (
        <CaseGameBrowser
          featured={featured}
          cards={cards}
          bests={bests}
          utm={utmQuery(sp)}
        />
      )}

      <p className="mt-8 text-center text-sm text-muted-foreground">
        เล่นฟรีทุกเคส · ล็อกอินเพื่อเก็บ XP และขึ้น{" "}
        <Link href="/school/leaderboard" className="font-semibold text-brand underline">
          Leaderboard
        </Link>{" "}
        · อยากฝึกสอบเต็มรูปแบบกับ AI Examiner ลอง{" "}
        <Link href="/longcase" className="font-semibold text-brand underline">
          ฝึกสอบ Long Case
        </Link>{" "}
        · เกมกู้ชีพ ACLS ที่{" "}
        <Link href="/sim" className="font-semibold text-brand underline">
          Code Blue Sim
        </Link>
      </p>
    </div>
  );
}
