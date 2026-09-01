"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";

interface ConceptChip {
  id: string;
  slug: string;
  name_th: string;
  icon: string;
}

interface Props {
  unitType: "flashcard" | "quiz" | "lesson";
  unitId: string;
}

/**
 * Renders inline chips for concepts linked to this unit. Client-side fetch
 * keeps the server pages cheap and avoids hydration mismatch.
 */
export default function RelatedConcepts({ unitType, unitId }: Props) {
  const [concepts, setConcepts] = useState<ConceptChip[]>([]);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      const supabase = createClient();
      const { data } = await supabase
        .from("school_concept_links")
        .select("school_concepts(id, slug, name_th, icon)")
        .eq("unit_type", unitType)
        .eq("unit_id", unitId);
      if (cancelled) return;
      type Row = { school_concepts: ConceptChip | null };
      const list = ((data as Row[]) ?? [])
        .map((r) => r.school_concepts)
        .filter((c): c is ConceptChip => !!c);
      setConcepts(list);
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [unitType, unitId]);

  if (concepts.length === 0) return null;
  return (
    <div className="flex flex-wrap gap-1 mt-2">
      <span className="text-xs text-muted-foreground mr-1">เชื่อม:</span>
      {concepts.map((c) => (
        <Link
          key={c.id}
          href={`/school/concept/${c.slug}`}
          className="text-xs px-2 py-0.5 rounded-full border bg-cyan-50 text-cyan-700 hover:bg-cyan-100"
        >
          {c.icon} {c.name_th}
        </Link>
      ))}
    </div>
  );
}
