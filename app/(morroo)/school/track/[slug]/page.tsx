import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Route, Layers, BookOpen, Brain, Stethoscope, ArrowRight } from "lucide-react";
import { createClient } from "@/lib/supabase/server";

export const revalidate = 60;

interface PageProps {
  params: Promise<{ slug: string }>;
}

interface TrackRow {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  icon: string;
  audience_years: number[];
}

interface ItemRow {
  id: string;
  item_order: number;
  unit_type: "flashcard" | "quiz" | "lesson" | "case";
  unit_id: string;
}

export async function generateMetadata({ params }: PageProps) {
  const { slug } = await params;
  const supabase = await createClient();
  const { data } = await supabase
    .from("school_tracks")
    .select("title, description")
    .eq("slug", slug)
    .maybeSingle();
  return {
    title: data ? `${data.title} — Track` : "Track",
    description: data?.description ?? undefined,
  };
}

export default async function TrackPage({ params }: PageProps) {
  const { slug } = await params;
  const supabase = await createClient();
  const { data: track } = await supabase
    .from("school_tracks")
    .select("*")
    .eq("slug", slug)
    .eq("status", "active")
    .maybeSingle();
  if (!track) notFound();
  const trackRow = track as TrackRow;

  const { data: items } = await supabase
    .from("school_track_items")
    .select("*")
    .eq("track_id", trackRow.id)
    .order("item_order");
  const itemRows = (items as ItemRow[]) ?? [];

  // Resolve titles per type in bulk
  const fcIds = itemRows.filter((i) => i.unit_type === "flashcard").map((i) => i.unit_id);
  const qzIds = itemRows.filter((i) => i.unit_type === "quiz").map((i) => i.unit_id);
  const lsIds = itemRows.filter((i) => i.unit_type === "lesson").map((i) => i.unit_id);
  const csIds = itemRows.filter((i) => i.unit_type === "case").map((i) => i.unit_id);

  const [fcRes, qzRes, lsRes, csRes] = await Promise.all([
    fcIds.length
      ? supabase.from("school_flashcards").select("id, front").in("id", fcIds)
      : Promise.resolve({ data: [] }),
    qzIds.length
      ? supabase.from("school_quizzes").select("id, stem").in("id", qzIds)
      : Promise.resolve({ data: [] }),
    lsIds.length
      ? supabase.from("school_lessons").select("id, title").in("id", lsIds)
      : Promise.resolve({ data: [] }),
    csIds.length
      ? supabase.from("school_cases").select("id, title").in("id", csIds)
      : Promise.resolve({ data: [] }),
  ]);
  const titleMap = new Map<string, string>();
  for (const r of (fcRes.data as { id: string; front: string }[] | null) ?? []) titleMap.set(`flashcard:${r.id}`, r.front);
  for (const r of (qzRes.data as { id: string; stem: string }[] | null) ?? []) titleMap.set(`quiz:${r.id}`, r.stem);
  for (const r of (lsRes.data as { id: string; title: string }[] | null) ?? []) titleMap.set(`lesson:${r.id}`, r.title);
  for (const r of (csRes.data as { id: string; title: string }[] | null) ?? []) titleMap.set(`case:${r.id}`, r.title);

  function iconFor(t: ItemRow["unit_type"]) {
    if (t === "lesson") return BookOpen;
    if (t === "flashcard") return Layers;
    if (t === "quiz") return Brain;
    return Stethoscope;
  }
  function hrefFor(i: ItemRow) {
    if (i.unit_type === "lesson") return `/school/lesson/${i.unit_id}`;
    if (i.unit_type === "case") return `/school/case/${i.unit_id}`;
    return `#`;
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school/tracks">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> Tracks
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2 flex-wrap">
        <Badge className="bg-lime-100 text-lime-700">Track</Badge>
        <Badge variant="outline">{itemRows.length} steps</Badge>
        <Badge variant="outline">Y{trackRow.audience_years.join(", Y")}</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <span className="text-3xl">{trackRow.icon}</span>
        {trackRow.title}
      </h1>
      {trackRow.description && (
        <p className="text-sm text-muted-foreground mb-6">{trackRow.description}</p>
      )}

      {itemRows.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          Track นี้ยังไม่มี items
        </div>
      ) : (
        <div className="space-y-2">
          {itemRows.map((item, i) => {
            const Icon = iconFor(item.unit_type);
            const title = titleMap.get(`${item.unit_type}:${item.unit_id}`) ?? "(ลบแล้ว)";
            return (
              <Link key={item.id} href={hrefFor(item)}>
                <Card className="hover:border-lime-300 transition-all cursor-pointer">
                  <CardContent className="p-3 flex items-center gap-3">
                    <span className="font-bold text-muted-foreground w-6 text-center">
                      {i + 1}
                    </span>
                    <Icon className="h-4 w-4 text-lime-600 shrink-0" />
                    <Badge variant="outline" className="text-xs capitalize">
                      {item.unit_type}
                    </Badge>
                    <span className="flex-1 text-sm line-clamp-1">{title}</span>
                    <ArrowRight className="h-4 w-4 text-muted-foreground shrink-0" />
                  </CardContent>
                </Card>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
