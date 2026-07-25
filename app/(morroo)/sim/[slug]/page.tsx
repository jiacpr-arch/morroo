import { notFound } from "next/navigation";
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

/** utm ที่ส่งต่อไปติดกับ lead ที่เก็บได้ท้ายเกม — array จาก query ซ้ำถือว่าไม่ถูกต้อง */
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

  return (
    <SimRunner
      scenario={scenario}
      characters={characters}
      specialty={specialty}
      playerXp={doctor?.xp ?? null}
      campaign={firstParam(sp.utm_campaign) ?? firstParam(sp.campaign)}
      adSet={firstParam(sp.utm_content) ?? firstParam(sp.ad_set)}
      autostart={firstParam(sp.start) === "1"}
    />
  );
}
