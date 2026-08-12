import { notFound } from "next/navigation";
import type { Metadata } from "next";
import ResusRunner from "@/components/resus/ResusRunner";
import { getResusCase } from "@/lib/supabase/queries-resus";

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
  const operation = await getResusCase(slug);
  if (!operation) return { title: "Resus Hero" };
  return {
    title: `${operation.title} — Resus Hero`,
    description: operation.subtitle,
  };
}

export default async function ResusPlayPage({ params, searchParams }: PageProps) {
  const { slug } = await params;
  const [operation, sp] = await Promise.all([getResusCase(slug), searchParams]);
  if (!operation) notFound();

  return <ResusRunner operation={operation} autostart={firstParam(sp.start) === "1"} />;
}
