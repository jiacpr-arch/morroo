import type { Metadata } from "next";
import { faUrl } from "@/lib/firstaid/urls";
import {
  algorithms,
  algorithmsById,
} from "@/lib/firstaid/content/algorithms";
import AlgorithmDetailClient from "./AlgorithmDetailClient";

export function generateStaticParams() {
  return (algorithms as Array<{ id: string }>).map((a) => ({ topic: a.id }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ topic: string }>;
}): Promise<Metadata> {
  const { topic } = await params;
  const algorithm = (algorithmsById as Record<string, any>)[topic];
  return {
    title: algorithm
      ? `${algorithm.title} — ผังช่วยชีวิตฉุกเฉิน | ปฐมพยาบาลเบื้องต้น`
      : "ไม่พบ Algorithm | ปฐมพยาบาลเบื้องต้น",
    alternates: { canonical: faUrl(`/algorithms/${topic}`) },
  };
}

export default async function Page({
  params,
}: {
  params: Promise<{ topic: string }>;
}) {
  const { topic } = await params;
  return <AlgorithmDetailClient topic={topic} />;
}
