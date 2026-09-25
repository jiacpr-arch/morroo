import { notFound, redirect } from "next/navigation";
import type { Metadata } from "next";
import SimRunner from "@/components/sim/SimRunner";
import {
  getMyDoctorProfile,
  getScenarioSpecialty,
  getSimCharacters,
  getSimScenario,
} from "@/lib/supabase/queries-sim";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ slug: string }>;
  searchParams: Promise<{ [key: string]: string | string[] | undefined }>;
}

/** ค่าเดียวจาก query — array (พารามิเตอร์ซ้ำ) ถือว่าไม่ถูกต้อง */
function firstParam(value: string | string[] | undefined): string | null {
  return typeof value === "string" && value ? value : null;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const scenario = await getSimScenario(slug);
  if (!scenario) return { title: "Code Blue Sim" };
  return {
    title: `${scenario.title} — Code Blue Sim`,
    description: scenario.subtitle,
  };
}

export default async function SimPlayPage({ params, searchParams }: PageProps) {
  const { slug } = await params;
  const [scenario, characters, specialty, doctor, sp] = await Promise.all([
    getSimScenario(slug),
    getSimCharacters(),
    getScenarioSpecialty(slug),
    getMyDoctorProfile(),
    searchParams,
  ]);
  if (!scenario) notFound();
  // slug เดิมที่ตอนนี้เสิร์ฟเกมอีกตัว (เช่น เกม AI รุ่นเก่า → เวอร์ชันสังเคราะห์ lc-<caseId>)
  // ย้ายไป URL หลักให้ผลการเล่น/สถิติไปรวมที่ slug เดียว
  if (scenario.slug !== slug) {
    const qs = new URLSearchParams();
    for (const [k, v] of Object.entries(sp)) if (typeof v === "string") qs.set(k, v);
    const q = qs.toString();
    redirect(`/sim/${scenario.slug}${q ? `?${q}` : ""}`);
  }

  return (
    <SimRunner
      scenario={scenario}
      characters={characters}
      specialty={specialty}
      playerXp={doctor?.xp ?? null}
      isPremium={doctor?.isPremium ?? false}
      autostart={firstParam(sp.start) === "1"}
    />
  );
}
