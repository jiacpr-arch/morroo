"use client";

import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2, Shield } from "lucide-react";
import { McqForm } from "../McqForm";

interface McqSubject { id: string; name_th: string; icon: string; }

export default function EditMcqPage() {
  const router = useRouter();
  const params = useParams();
  const questionId = params.id as string;

  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<McqSubject[]>([]);
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

      const [qRes, sRes] = await Promise.all([
        supabase
          .from("mcq_questions")
          .select("id, subject_id, exam_type, exam_source, scenario, choices, correct_answer, explanation, difficulty, topic, status")
          .eq("id", questionId)
          .single(),
        supabase.from("mcq_subjects").select("id, name_th, icon").order("name_th"),
      ]);

      setInitial(qRes.data as Record<string, unknown> | null);
      setSubjects((sRes.data as McqSubject[]) || []);
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

  return (
    <McqForm
      subjects={subjects}
      initial={{
        id: initial.id as string,
        subject_id: initial.subject_id as string,
        exam_type: initial.exam_type as "NL1" | "NL2",
        exam_source: (initial.exam_source as string) || "",
        scenario: initial.scenario as string,
        choices: initial.choices as { label: string; text: string }[],
        correct_answer: initial.correct_answer as string,
        explanation: (initial.explanation as string) || "",
        difficulty: initial.difficulty as "easy" | "medium" | "hard",
        topic: (initial.topic as string) || "",
        status: initial.status as "active" | "review" | "disabled",
      }}
    />
  );
}
