"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2, Shield } from "lucide-react";
import { McqForm, type AdminMcqSubject, type AdminBoardTopic } from "../McqForm";

export default function NewMcqPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<AdminMcqSubject[]>([]);
  const [boardTopics, setBoardTopics] = useState<AdminBoardTopic[]>([]);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);
      const [sRes, tRes] = await Promise.all([
        supabase
          .from("mcq_subjects")
          .select("id, name_th, icon, audience, board_specialty, board_subspecialty")
          .order("name_th"),
        supabase
          .from("board_topic_categories")
          .select("slug, name_th, peds_count, adult_count, other_count, board_exam_blueprints!inner(specialty_slug, section_code)")
          .order("display_order"),
      ]);
      setSubjects((sRes.data as AdminMcqSubject[]) || []);
      setBoardTopics(flattenTopics(tRes.data));
      setLoading(false);
    }
    load();
  }, [router]);

  if (loading) return <div className="flex items-center justify-center min-h-[60vh]"><Loader2 className="h-8 w-8 animate-spin text-brand" /></div>;

  if (!isAdmin) return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
      <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
    </div>
  );

  return <McqForm subjects={subjects} boardTopics={boardTopics} />;
}

function flattenTopics(rows: unknown): AdminBoardTopic[] {
  if (!Array.isArray(rows)) return [];
  return rows.flatMap((r) => {
    const row = r as {
      slug: string;
      name_th: string;
      peds_count: number;
      adult_count: number;
      other_count: number;
      board_exam_blueprints:
        | { specialty_slug: string; section_code: string }
        | { specialty_slug: string; section_code: string }[]
        | null;
    };
    const bp = row.board_exam_blueprints;
    if (!bp) return [];
    const bps = Array.isArray(bp) ? bp : [bp];
    return bps.map((b) => ({
      specialty_slug: b.specialty_slug,
      section_code: b.section_code,
      slug: row.slug,
      name_th: row.name_th,
      peds_count: row.peds_count,
      adult_count: row.adult_count,
      other_count: row.other_count,
    }));
  });
}
