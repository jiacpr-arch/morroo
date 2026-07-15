import { notFound } from "next/navigation";
import type { Metadata } from "next";
import SurgeryRunner from "@/components/surgery/SurgeryRunner";
import { getOperation } from "@/lib/supabase/queries-surgery";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const operation = await getOperation(slug);
  if (!operation) return { title: "Operation MorRoo" };
  return {
    title: `${operation.title} — Operation MorRoo`,
    description: operation.subtitle,
  };
}

export default async function SurgeryPlayPage({ params }: PageProps) {
  const { slug } = await params;
  const operation = await getOperation(slug);
  if (!operation) notFound();

  return <SurgeryRunner operation={operation} />;
}
