import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import {
  scenarios,
  scenariosById,
} from "@/lib/firstaid/content/scenarios";
import SimulationRunClient from "./SimulationRunClient";

export function generateStaticParams() {
  return (scenarios as Array<{ id: string }>).map((s) => ({
    scenarioId: s.id,
  }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ scenarioId: string }>;
}): Promise<Metadata> {
  const { scenarioId } = await params;
  const scenario = (scenariosById as Record<string, any>)[scenarioId];
  return {
    title: scenario
      ? `${scenario.title} — ฝึกสถานการณ์จำลอง | ปฐมพยาบาลเบื้องต้น`
      : "ไม่พบฉากจำลอง | ปฐมพยาบาลเบื้องต้น",
    alternates: { canonical: faUrl(`/simulation/${scenarioId}`) },
  };
}

export default async function Page({
  params,
}: {
  params: Promise<{ scenarioId: string }>;
}) {
  const { scenarioId } = await params;
  return <SimulationRunClient scenarioId={scenarioId} />;
}
