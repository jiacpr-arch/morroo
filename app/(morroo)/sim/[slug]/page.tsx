import { notFound } from "next/navigation";
import type { Metadata } from "next";
import SimRunner from "@/components/sim/SimRunner";
import { getSimScenario } from "@/lib/supabase/queries-sim";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ slug: string }>;
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

export default async function SimPlayPage({ params }: PageProps) {
  const { slug } = await params;
  const scenario = await getSimScenario(slug);
  if (!scenario) notFound();

  return <SimRunner scenario={scenario} />;
}
