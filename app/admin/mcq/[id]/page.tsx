"use client";

import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2, Shield } from "lucide-react";
import { McqForm, type AdminMcqSubject, type AdminBoardTopic } from "../McqForm";
import type { McqDetailedExplanation } from "@/lib/supabase/mutations-mcq-admin";

export default function EditMcqPage() {
  const router = useRouter();
  const params = useParams();
  const questionId = params.id as string;

  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<AdminMcqSubject[]>([]);
  const [boardTopics, setBoardTopics] = useState<AdminBoardTopic[]>([]);
  const [initial, setInitial] = useState<Record<string, unknown> | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);

      const [qRes, sRes, tRes] = await Promise.all([
        supabase
          .from("mcq_questions")
          .select("id, subject_id, exam_type, exam_source, scenario, choices, correct_answer, explanation, detailed_explanation, difficulty, topic, status, audience, board_section, board_topic, board_age_group, board_level, reference_source")
          .eq("id", questionId)
          .single(),
        supabase
          .from("mcq_subjects")
          .select("id, name_th, icon, audience, board_specialty, board_subspecialty")
          .order("name_th"),
        supabase
          .from("board_topic_categories")
          .select("slug, name_th, peds_count, adult_count, other_count, board_exam_blueprints!inner(specialty_slug, section_code)")
          .order("display_order"),
      ]);

      setInitial(qRes.data as Record<string, unknown> | null);
      setSubjects((sRes.data as AdminMcqSubject[]) || []);
      setBoardTopics(flattenTopics(tRes.data));
      setLoading(false);
    }
    load();
  }, [router, questionId]);

  if (loading) return <div className="flex items-center justify-center min-h-[60vh]"><Loader2 className="h-8 w-8 animate-spin text-brand" /></div>;

  if (!isAdmin) return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
      <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
    </div>
  );

  if (!initial) return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <h1 className="text-2xl font-bold">ไม่พบข้อสอบ</h1>
    </div>
  );

  const level = initial.board_level as number | null | undefined;
  return (
    <McqForm
      subjects={subjects}
      boardTopics={boardTopics}
      initialDetailed={
        (initial.detailed_explanation as McqDetailedExplanation | null) ?? null
      }
      initial={{
        id: initial.id as string,
        subject_id: initial.subject_id as string,
        exam_type: ((initial.exam_type as "NL1" | "NL2" | null) ?? "NL2"),
        exam_source: (initial.exam_source as string) || "",
        scenario: initial.scenario as string,
        choices: initial.choices as { label: string; text: string }[],
        correct_answer: initial.correct_answer as string,
        explanation: (initial.explanation as string) || "",
        difficulty: initial.difficulty as "easy" | "medium" | "hard",
        topic: (initial.topic as string) || "",
        status: initial.status as "active" | "review" | "disabled",
        board_section: (initial.board_section as string) || "",
        board_topic: (initial.board_topic as string) || "",
        board_age_group:
          (initial.board_age_group as "peds" | "adult" | "mixed" | null) ?? "",
        board_level: level === 1 || level === 2 || level === 3
          ? (String(level) as "1" | "2" | "3")
          : "",
        reference_source: (initial.reference_source as string) || "",
      }}
    />
  );
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
