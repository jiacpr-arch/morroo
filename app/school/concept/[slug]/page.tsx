import Link from "next/link";
import { notFound } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Layers, Brain, BookOpen, Network } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolConceptBySlug,
  getConceptLinkedUnits,
} from "@/lib/supabase/queries-school";

export const revalidate = 60;

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { slug } = await params;
  const concept = await getSchoolConceptBySlug(slug);
  return {
    title: concept ? `${concept.name_th} — Concept Hub` : "Concept",
    description: concept?.description ?? "เนื้อหาทุกวิชาที่เชื่อมโยงกับ concept นี้",
  };
}

export default async function ConceptPage({ params }: PageProps) {
  const { slug } = await params;
  const concept = await getSchoolConceptBySlug(slug);
  if (!concept) notFound();

  const linked = await getConceptLinkedUnits(concept.id);
  const fcIds = linked.filter((l) => l.unit_type === "flashcard").map((l) => l.unit_id);
  const qzIds = linked.filter((l) => l.unit_type === "quiz").map((l) => l.unit_id);
  const lsIds = linked.filter((l) => l.unit_type === "lesson").map((l) => l.unit_id);

  const supabase = await createClient();
  const [fcRes, qzRes, lsRes] = await Promise.all([
    fcIds.length
      ? supabase
          .from("school_flashcards")
          .select("id, front, layer, school_topics(year, name_th, name_en, school_systems(icon, name_th))")
          .in("id", fcIds)
      : Promise.resolve({ data: [] }),
    qzIds.length
      ? supabase
          .from("school_quizzes")
          .select("id, stem, layer, difficulty, school_topics(year, name_th)")
          .in("id", qzIds)
      : Promise.resolve({ data: [] }),
    lsIds.length
      ? supabase
          .from("school_lessons")
          .select("id, title, layer, estimated_min, school_topics(year, name_th)")
          .in("id", lsIds)
      : Promise.resolve({ data: [] }),
  ]);

  type FcRow = { id: string; front: string; layer: string; school_topics?: { year: number; name_th: string; school_systems?: { icon?: string; name_th?: string } | null } };
  type QzRow = { id: string; stem: string; layer: string; difficulty: string; school_topics?: { year: number; name_th: string } };
  type LsRow = { id: string; title: string; layer: string; estimated_min: number; school_topics?: { year: number; name_th: string } };
  const flashcards = (fcRes.data as FcRow[]) ?? [];
  const quizzes = (qzRes.data as QzRow[]) ?? [];
  const lessons = (lsRes.data as LsRow[]) ?? [];

  // Group by year
  const yearGroups = new Map<number, { fc: number; qz: number; ls: number }>();
  for (const c of flashcards) {
    const y = c.school_topics?.year ?? 0;
    const g = yearGroups.get(y) ?? { fc: 0, qz: 0, ls: 0 };
    g.fc++;
    yearGroups.set(y, g);
  }
  for (const q of quizzes) {
    const y = q.school_topics?.year ?? 0;
    const g = yearGroups.get(y) ?? { fc: 0, qz: 0, ls: 0 };
    g.qz++;
    yearGroups.set(y, g);
  }
  for (const l of lessons) {
    const y = l.school_topics?.year ?? 0;
    const g = yearGroups.get(y) ?? { fc: 0, qz: 0, ls: 0 };
    g.ls++;
    yearGroups.set(y, g);
  }
  const yearsSorted = [...yearGroups.entries()].sort(([a], [b]) => a - b);

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school/concepts">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> Concept index
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2 flex-wrap">
        <Badge className="bg-cyan-100 text-cyan-700">Concept</Badge>
        <Badge variant="outline">{flashcards.length} cards</Badge>
        <Badge variant="outline">{quizzes.length} quiz</Badge>
        <Badge variant="outline">{lessons.length} lessons</Badge>
      </div>
      <h1 className="text-3xl font-bold mb-2 flex items-center gap-2">
        <span className="text-4xl">{concept.icon}</span>
        {concept.name_th}
      </h1>
      <p className="text-muted-foreground mb-1">{concept.name_en}</p>
      {concept.description && (
        <p className="text-sm text-muted-foreground mb-6">{concept.description}</p>
      )}

      {/* Cross-year overview */}
      {yearsSorted.length > 0 && (
        <Card className="mb-6 border-cyan-200 bg-cyan-50/50">
          <CardContent className="p-5">
            <p className="font-bold text-cyan-700 flex items-center gap-2 mb-3">
              <Network className="h-4 w-4" /> เชื่อมข้ามปี
            </p>
            <div className="grid grid-cols-3 sm:grid-cols-6 gap-2">
              {yearsSorted.map(([y, g]) => (
                <div
                  key={y}
                  className="border rounded p-2 text-center bg-background"
                >
                  <p className="text-xs text-muted-foreground">ปี {y}</p>
                  <p className="text-sm font-semibold">
                    {g.fc + g.qz + g.ls}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {g.ls}📖 · {g.fc}🎴 · {g.qz}🧠
                  </p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {/* Lessons */}
      {lessons.length > 0 && (
        <div className="mb-6">
          <h2 className="font-bold mb-3 flex items-center gap-2">
            <BookOpen className="h-4 w-4 text-teal-600" /> Lessons
          </h2>
          <ul className="space-y-1">
            {lessons.map((l) => (
              <li key={l.id}>
                <Link
                  href={`/school/lesson/${l.id}`}
                  className="flex items-center gap-2 p-2 rounded hover:bg-muted/50 text-sm"
                >
                  <Badge variant="outline" className="text-xs">
                    Y{l.school_topics?.year}
                  </Badge>
                  <span className="flex-1">{l.title}</span>
                  <span className="text-xs text-muted-foreground">
                    {l.estimated_min} นาที
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}

      {/* Flashcards */}
      {flashcards.length > 0 && (
        <div className="mb-6">
          <h2 className="font-bold mb-3 flex items-center gap-2">
            <Layers className="h-4 w-4 text-sky-600" /> Flashcards
          </h2>
          <ul className="space-y-1">
            {flashcards.slice(0, 20).map((c) => (
              <li
                key={c.id}
                className="flex items-center gap-2 p-2 rounded border bg-card text-sm"
              >
                <Badge variant="outline" className="text-xs">
                  Y{c.school_topics?.year}
                </Badge>
                <Badge variant="outline" className="text-xs">
                  {c.layer}
                </Badge>
                <span className="flex-1 line-clamp-1">{c.front}</span>
              </li>
            ))}
          </ul>
          {flashcards.length > 20 && (
            <p className="text-xs text-muted-foreground mt-2 italic">
              +{flashcards.length - 20} more
            </p>
          )}
        </div>
      )}

      {/* Quizzes */}
      {quizzes.length > 0 && (
        <div className="mb-6">
          <h2 className="font-bold mb-3 flex items-center gap-2">
            <Brain className="h-4 w-4 text-emerald-600" /> Quizzes
          </h2>
          <ul className="space-y-1">
            {quizzes.slice(0, 20).map((q) => (
              <li
                key={q.id}
                className="flex items-center gap-2 p-2 rounded border bg-card text-sm"
              >
                <Badge variant="outline" className="text-xs">
                  Y{q.school_topics?.year}
                </Badge>
                <Badge variant="outline" className="text-xs">
                  {q.difficulty}
                </Badge>
                <span className="flex-1 line-clamp-1">{q.stem}</span>
              </li>
            ))}
          </ul>
        </div>
      )}

      {flashcards.length + quizzes.length + lessons.length === 0 && (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มี content ที่ tag concept นี้
        </div>
      )}
    </div>
  );
}
