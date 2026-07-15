import { notFound } from "next/navigation";
import type { Metadata } from "next";
import ResusRunner from "@/components/resus/ResusRunner";
import { getResusCase } from "@/lib/supabase/queries-resus";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const operation = await getResusCase(slug);
  if (!operation) return { title: "Operation MorRoo" };
  return {
    title: `${operation.title} — Operation MorRoo`,
    description: operation.subtitle,
  };
}

export default async function ResusPlayPage({ params }: PageProps) {
  const { slug } = await params;
  const operation = await getResusCase(slug);
  if (!operation) notFound();

  return <ResusRunner operation={operation} />;
}
