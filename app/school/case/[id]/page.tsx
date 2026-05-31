import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Sparkles, Stethoscope } from "lucide-react";
import {
  getSchoolCase,
  getSchoolCaseStages,
} from "@/lib/supabase/queries-school";
import CaseWalker from "@/components/school/CaseWalker";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const c = await getSchoolCase(id);
  return {
    title: c ? `${c.title} — Integrated Case` : "Case",
    description: c?.presentation,
  };
}

export default async function CasePage({ params }: PageProps) {
  const { id } = await params;
  const c = await getSchoolCase(id);
  if (!c) notFound();
  const stages = await getSchoolCaseStages(id);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school/cases">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> Cases
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2 flex-wrap">
        <Badge className="bg-orange-100 text-orange-700">Integrated Case</Badge>
        <Badge variant="outline">{c.difficulty}</Badge>
        {c.school_systems && (
          <Badge variant="outline">
            {c.school_systems.icon} {c.school_systems.name_th}
          </Badge>
        )}
      </div>
      <h1 className="text-2xl font-bold mb-2 flex items-center gap-2">
        <Stethoscope className="h-6 w-6 text-orange-600" /> {c.title}
      </h1>
      <div className="rounded-lg border bg-orange-50/40 p-4 mb-6">
        <p className="text-xs font-semibold uppercase text-orange-700 mb-1">
          Presentation
        </p>
        <p className="text-sm whitespace-pre-wrap">{c.presentation}</p>
      </div>

      {stages.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี stage สำหรับ case นี้
        </div>
      ) : (
        <>
          <p className="text-xs text-muted-foreground mb-2 flex items-center gap-1">
            <Sparkles className="h-3 w-3" /> {stages.length} stage — เดินผ่าน Y1→Y6
          </p>
          <CaseWalker caseId={c.id} caseTitle={c.title} stages={stages} />
        </>
      )}
    </div>
  );
}
