import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Search } from "lucide-react";
import { createClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Search — School",
  description: "ค้นหา flashcard / lesson / quiz / concept",
};

interface PageProps {
  searchParams: Promise<{ q?: string }>;
}

interface CardRow {
  id: string;
  front: string;
  back: string;
  layer: string;
  school_topics?: { year: number; name_th: string } | null;
}
interface QuizRow {
  id: string;
  stem: string;
  layer: string;
  difficulty: string;
  school_topics?: { year: number; name_th: string } | null;
}
interface LessonRow {
  id: string;
  title: string;
  body_md: string;
  layer: string;
  school_topics?: { year: number; name_th: string } | null;
}
interface ConceptRow {
  id: string;
  slug: string;
  name_th: string;
  name_en: string;
  icon: string;
}

export default async function SearchPage({ searchParams }: PageProps) {
  const { q = "" } = await searchParams;
  const query = q.trim();
  const supabase = await createClient();

  let flashcards: CardRow[] = [];
  let quizzes: QuizRow[] = [];
  let lessons: LessonRow[] = [];
  let concepts: ConceptRow[] = [];

  if (query.length >= 2) {
    const like = `%${query}%`;
    const [fc, qz, ls, cn] = await Promise.all([
      supabase
        .from("school_flashcards")
        .select("id, front, back, layer, school_topics(year, name_th)")
        .or(`front.ilike.${like},back.ilike.${like}`)
        .eq("status", "active")
        .limit(20),
      supabase
        .from("school_quizzes")
        .select("id, stem, layer, difficulty, school_topics(year, name_th)")
        .ilike("stem", like)
        .eq("status", "active")
        .limit(20),
      supabase
        .from("school_lessons")
        .select("id, title, body_md, layer, school_topics(year, name_th)")
        .or(`title.ilike.${like},body_md.ilike.${like}`)
        .eq("status", "active")
        .limit(10),
      supabase
        .from("school_concepts")
        .select("id, slug, name_th, name_en, icon")
        .or(`name_th.ilike.${like},name_en.ilike.${like},description.ilike.${like}`)
        .limit(10),
    ]);
    flashcards = (fc.data as CardRow[]) ?? [];
    quizzes = (qz.data as QuizRow[]) ?? [];
    lessons = (ls.data as LessonRow[]) ?? [];
    concepts = (cn.data as ConceptRow[]) ?? [];
  }

  const total = flashcards.length + quizzes.length + lessons.length + concepts.length;

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-slate-100 text-slate-700">Search</Badge>
        {query && <Badge variant="outline">{total} ผลลัพธ์</Badge>}
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Search className="h-6 w-6 text-slate-600" /> ค้นหาเนื้อหา
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ค้น flashcard / quiz / lesson / concept ทั้งหมด
      </p>

      <form method="get" className="flex gap-2 mb-6">
        <input
          name="q"
          defaultValue={query}
          placeholder="พิมพ์คำที่ต้องการค้นหา..."
          autoFocus
          className="flex-1 border rounded-md px-4 py-2"
        />
        <Button type="submit">ค้น</Button>
      </form>

      {query.length >= 2 && total === 0 && (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ไม่พบผลลัพธ์
        </div>
      )}

      {concepts.length > 0 && (
        <section className="mb-6">
          <h2 className="font-bold mb-2">Concepts ({concepts.length})</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
            {concepts.map((c) => (
              <Link key={c.id} href={`/school/concept/${c.slug}`}>
                <Card className="hover:border-cyan-300">
                  <CardContent className="p-3 flex items-center gap-2">
                    <span className="text-2xl">{c.icon}</span>
                    <div className="flex-1 min-w-0">
                      <p className="font-semibold">{c.name_th}</p>
                      <p className="text-xs text-muted-foreground">{c.name_en}</p>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        </section>
      )}

      {lessons.length > 0 && (
        <section className="mb-6">
          <h2 className="font-bold mb-2">Lessons ({lessons.length})</h2>
          <ul className="space-y-2">
            {lessons.map((l) => (
              <li key={l.id}>
                <Link
                  href={`/school/lesson/${l.id}`}
                  className="flex items-center gap-2 p-3 rounded border hover:bg-muted/50 text-sm"
                >
                  <Badge variant="outline" className="text-xs">
                    Y{l.school_topics?.year}
                  </Badge>
                  <Badge variant="outline" className="text-xs">
                    {l.layer}
                  </Badge>
                  <span className="flex-1 font-medium">{l.title}</span>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      )}

      {flashcards.length > 0 && (
        <section className="mb-6">
          <h2 className="font-bold mb-2">Flashcards ({flashcards.length})</h2>
          <ul className="space-y-1">
            {flashcards.map((c) => (
              <li key={c.id} className="p-2 rounded border text-sm">
                <div className="flex items-center gap-1 mb-1">
                  <Badge variant="outline" className="text-xs">
                    Y{c.school_topics?.year}
                  </Badge>
                  <Badge variant="outline" className="text-xs">
                    {c.layer}
                  </Badge>
                </div>
                <p className="font-medium line-clamp-1">{c.front}</p>
              </li>
            ))}
          </ul>
        </section>
      )}

      {quizzes.length > 0 && (
        <section className="mb-6">
          <h2 className="font-bold mb-2">Quizzes ({quizzes.length})</h2>
          <ul className="space-y-1">
            {quizzes.map((q) => (
              <li key={q.id} className="p-2 rounded border text-sm">
                <div className="flex items-center gap-1 mb-1">
                  <Badge variant="outline" className="text-xs">
                    Y{q.school_topics?.year}
                  </Badge>
                  <Badge variant="outline" className="text-xs">
                    {q.difficulty}
                  </Badge>
                </div>
                <p className="line-clamp-2">{q.stem}</p>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}
