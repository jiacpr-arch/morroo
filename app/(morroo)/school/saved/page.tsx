import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Bookmark, StickyNote } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Saved — School",
  description: "การ์ด/lesson ที่บันทึกไว้ + Note ส่วนตัว",
};

export default async function SavedPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/school/saved");

  const [bookmarksRes, notesRes] = await Promise.all([
    supabase
      .from("school_user_bookmarks")
      .select("unit_type, unit_id, created_at")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(100),
    supabase
      .from("school_user_notes")
      .select("id, unit_type, unit_id, body, updated_at")
      .eq("user_id", user.id)
      .order("updated_at", { ascending: false })
      .limit(50),
  ]);

  type Bookmark = { unit_type: string; unit_id: string; created_at: string };
  type Note = { id: string; unit_type: string; unit_id: string; body: string; updated_at: string };
  const bookmarks = (bookmarksRes.data as Bookmark[]) ?? [];
  const notes = (notesRes.data as Note[]) ?? [];

  // Resolve titles for bookmarked items
  const fcIds = bookmarks.filter((b) => b.unit_type === "flashcard").map((b) => b.unit_id);
  const lessonIds = bookmarks.filter((b) => b.unit_type === "lesson").map((b) => b.unit_id);
  const quizIds = bookmarks.filter((b) => b.unit_type === "quiz").map((b) => b.unit_id);

  const [fcRes, lsRes, qzRes] = await Promise.all([
    fcIds.length
      ? supabase.from("school_flashcards").select("id, front").in("id", fcIds)
      : Promise.resolve({ data: [] }),
    lessonIds.length
      ? supabase.from("school_lessons").select("id, title").in("id", lessonIds)
      : Promise.resolve({ data: [] }),
    quizIds.length
      ? supabase.from("school_quizzes").select("id, stem").in("id", quizIds)
      : Promise.resolve({ data: [] }),
  ]);
  type FC = { id: string; front: string };
  type LS = { id: string; title: string };
  type QZ = { id: string; stem: string };
  const fcMap = new Map<string, string>(
    ((fcRes.data as FC[]) ?? []).map((r) => [r.id, r.front])
  );
  const lsMap = new Map<string, string>(
    ((lsRes.data as LS[]) ?? []).map((r) => [r.id, r.title])
  );
  const qzMap = new Map<string, string>(
    ((qzRes.data as QZ[]) ?? []).map((r) => [r.id, r.stem])
  );

  function titleOf(b: { unit_type: string; unit_id: string }) {
    if (b.unit_type === "flashcard") return fcMap.get(b.unit_id) ?? "(ลบแล้ว)";
    if (b.unit_type === "lesson") return lsMap.get(b.unit_id) ?? "(ลบแล้ว)";
    if (b.unit_type === "quiz") return qzMap.get(b.unit_id) ?? "(ลบแล้ว)";
    return "(?)";
  }
  function linkOf(b: { unit_type: string; unit_id: string }) {
    if (b.unit_type === "lesson") return `/school/lesson/${b.unit_id}`;
    return "#"; // flashcards/quizzes have no detail page; user can re-encounter in deck
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-amber-100 text-amber-700">Saved</Badge>
        <Badge variant="outline">{bookmarks.length} bookmarks</Badge>
        <Badge variant="outline">{notes.length} notes</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Bookmark className="h-6 w-6 text-amber-600" /> ที่บันทึกไว้
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        Bookmark + Personal notes ของคุณ
      </p>

      {bookmarks.length > 0 && (
        <section className="mb-8">
          <h2 className="font-bold mb-2 flex items-center gap-1">
            <Bookmark className="h-4 w-4" /> Bookmarks ({bookmarks.length})
          </h2>
          <ul className="space-y-2">
            {bookmarks.map((b) => (
              <li key={`${b.unit_type}-${b.unit_id}`}>
                <Link
                  href={linkOf(b)}
                  className="flex items-center gap-2 p-3 rounded border hover:bg-muted/50 text-sm"
                >
                  <Badge variant="outline" className="text-xs capitalize">
                    {b.unit_type}
                  </Badge>
                  <span className="flex-1 line-clamp-1">{titleOf(b)}</span>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      )}

      {notes.length > 0 && (
        <section className="mb-8">
          <h2 className="font-bold mb-2 flex items-center gap-1">
            <StickyNote className="h-4 w-4" /> Notes ({notes.length})
          </h2>
          <div className="space-y-2">
            {notes.map((n) => (
              <Card key={n.id}>
                <CardContent className="p-3 space-y-1">
                  <div className="flex items-center gap-1">
                    <Badge variant="outline" className="text-xs capitalize">
                      {n.unit_type}
                    </Badge>
                    <p className="text-xs text-muted-foreground line-clamp-1">
                      {titleOf({ unit_type: n.unit_type, unit_id: n.unit_id })}
                    </p>
                  </div>
                  <p className="text-sm whitespace-pre-wrap">{n.body}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>
      )}

      {bookmarks.length + notes.length === 0 && (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่ได้ bookmark หรือเขียน note ใดๆ
        </div>
      )}
    </div>
  );
}
