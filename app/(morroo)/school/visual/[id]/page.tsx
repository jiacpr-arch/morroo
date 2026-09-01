import Link from "next/link";
import { notFound } from "next/navigation";
import { Button } from "@/components/ui/button";
import { ArrowLeft } from "lucide-react";
import {
  getSchoolVisual,
  getFlashcardsByIds,
} from "@/lib/supabase/queries-school";
import VisualDetail from "@/components/school/VisualDetail";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const v = await getSchoolVisual(id);
  return {
    title: v ? `${v.title} — Visual Summary` : "Visual Summary",
    description: v?.caption ?? undefined,
  };
}

export default async function VisualPage({ params }: PageProps) {
  const { id } = await params;
  const visual = await getSchoolVisual(id);
  if (!visual) notFound();
  const flashcards = await getFlashcardsByIds(visual.linked_flashcard_ids ?? []);

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school/visuals">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> Visuals
        </Button>
      </Link>
      <VisualDetail visual={visual} flashcards={flashcards} />
    </div>
  );
}
