import Link from "next/link";
import { redirect } from "next/navigation";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Database } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import {
  getSchoolSystems,
  getSchoolConcepts,
} from "@/lib/supabase/queries-school";
import SchoolAdminPanel from "@/components/school/SchoolAdminPanel";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Admin · School Content",
  description: "เพิ่ม / แก้ไข topic / lesson / flashcard / quiz / case",
};

export default async function SchoolAdminPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login?next=/admin/school");

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .maybeSingle();
  if (profile?.role !== "admin") redirect("/school");

  const [systems, concepts] = await Promise.all([
    getSchoolSystems(),
    getSchoolConcepts(),
  ]);

  // Recent counts for dashboard
  const [topicsRes, fcRes, lsRes, qzRes, csRes] = await Promise.all([
    supabase.from("school_topics").select("id", { count: "exact", head: true }),
    supabase.from("school_flashcards").select("id", { count: "exact", head: true }),
    supabase.from("school_lessons").select("id", { count: "exact", head: true }),
    supabase.from("school_quizzes").select("id", { count: "exact", head: true }),
    supabase.from("school_cases").select("id", { count: "exact", head: true }),
  ]);
  const counts = {
    topics: topicsRes.count ?? 0,
    flashcards: fcRes.count ?? 0,
    lessons: lsRes.count ?? 0,
    quizzes: qzRes.count ?? 0,
    cases: csRes.count ?? 0,
  };

  // Recent topics for picker
  const { data: topicsRecent } = await supabase
    .from("school_topics")
    .select("id, year, slug, name_th, school_systems(slug, name_th, icon)")
    .order("created_at", { ascending: false })
    .limit(50);
  type TopicPick = {
    id: string;
    year: number;
    slug: string;
    name_th: string;
    school_systems?: { slug: string; name_th: string; icon?: string } | null;
  };

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ School
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-slate-200 text-slate-700">Admin</Badge>
        <Badge variant="outline">School content</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Database className="h-6 w-6" /> School Content Management
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        เพิ่มเนื้อหาเองได้ — หรือ paste JSON bulk import (รูปแบบเหมือน manifest)
      </p>

      <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 mb-6">
        {(
          [
            ["Topics", counts.topics, "📚"],
            ["Lessons", counts.lessons, "📖"],
            ["Flashcards", counts.flashcards, "🎴"],
            ["Quizzes", counts.quizzes, "🧠"],
            ["Cases", counts.cases, "🩺"],
          ] as const
        ).map(([label, n, icon]) => (
          <div
            key={label}
            className="rounded border p-3 text-center bg-card"
          >
            <p className="text-2xl">{icon}</p>
            <p className="text-2xl font-bold">{n}</p>
            <p className="text-xs text-muted-foreground">{label}</p>
          </div>
        ))}
      </div>

      <SchoolAdminPanel
        systems={systems.map((s) => ({ id: s.id, slug: s.slug, name_th: s.name_th, icon: s.icon }))}
        concepts={concepts.map((c) => ({ id: c.id, slug: c.slug, name_th: c.name_th, icon: c.icon }))}
        topics={(topicsRecent as TopicPick[] | null) ?? []}
      />
    </div>
  );
}
