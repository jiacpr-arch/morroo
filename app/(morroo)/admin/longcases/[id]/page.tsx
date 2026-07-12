"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { use } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { ArrowLeft, Loader2, Save, Pencil, Trash2 } from "lucide-react";

const SPECIALTIES = [
  "Medicine", "Surgery", "Obstetrics", "Pediatrics",
  "Emergency", "Cardiology", "Neurology", "Orthopedics",
];

const JSON_FIELDS = [
  { key: "patient_info", label: "Patient Info (JSON)" },
  { key: "history_script", label: "History Script (JSON)" },
  { key: "pe_findings", label: "PE Findings (JSON)" },
  { key: "lab_results", label: "Lab Results (JSON)" },
  { key: "accepted_ddx", label: "Accepted DDx (JSON array)" },
  { key: "teaching_points", label: "Teaching Points (JSON array)" },
  { key: "examiner_questions", label: "Examiner Questions (JSON array)" },
  { key: "scoring_rubric", label: "Scoring Rubric (JSON)" },
];

type FormState = {
  title: string;
  specialty: string;
  difficulty: string;
  is_weekly: boolean;
  week_number: string;
  is_published: boolean;
  correct_diagnosis: string;
  management_plan: string;
  patient_info: string;
  history_script: string;
  pe_findings: string;
  lab_results: string;
  accepted_ddx: string;
  teaching_points: string;
  examiner_questions: string;
  scoring_rubric: string;
};

function toFormState(data: Record<string, unknown>): FormState {
  const json = (v: unknown) =>
    typeof v === "string" ? v : JSON.stringify(v, null, 2);
  return {
    title: (data.title as string) || "",
    specialty: (data.specialty as string) || "Medicine",
    difficulty: (data.difficulty as string) || "medium",
    is_weekly: Boolean(data.is_weekly),
    week_number: data.week_number != null ? String(data.week_number) : "",
    is_published: data.is_published !== false,
    correct_diagnosis: (data.correct_diagnosis as string) || "",
    management_plan: (data.management_plan as string) || "",
    patient_info: json(data.patient_info),
    history_script: json(data.history_script),
    pe_findings: json(data.pe_findings),
    lab_results: json(data.lab_results),
    accepted_ddx: json(data.accepted_ddx),
    teaching_points: json(data.teaching_points),
    examiner_questions: json(data.examiner_questions),
    scoring_rubric: json(data.scoring_rubric),
  };
}

export default function EditLongCasePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const router = useRouter();
  const [checking, setChecking] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [notFound, setNotFound] = useState(false);
  const [saving, setSaving] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState<FormState | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setChecking(false); return; }

      setIsAdmin(true);

      const { data } = await supabase
        .from("long_cases")
        .select("*")
        .eq("id", id)
        .single();

      if (!data) { setNotFound(true); setChecking(false); return; }

      setForm(toFormState(data as Record<string, unknown>));
      setChecking(false);
    }
    load();
  }, [id, router]);

  function update(field: keyof FormState, value: string | boolean) {
    setForm(prev => prev ? { ...prev, [field]: value } : prev);
  }

  async function handleSave() {
    if (!form) return;
    if (!form.title.trim() || !form.correct_diagnosis.trim()) {
      setError("กรุณากรอก Title และ Correct Diagnosis");
      return;
    }

    for (const { key, label } of JSON_FIELDS) {
      try {
        JSON.parse(form[key as keyof FormState] as string);
      } catch {
        setError(`JSON ไม่ถูกต้องใน field: ${label}`);
        return;
      }
    }

    setSaving(true);
    setError("");
    try {
      const supabase = createClient();
      const payload = {
        title: form.title.trim(),
        specialty: form.specialty,
        difficulty: form.difficulty,
        is_weekly: form.is_weekly,
        week_number: form.is_weekly && form.week_number ? parseInt(form.week_number) : null,
        is_published: form.is_published,
        correct_diagnosis: form.correct_diagnosis.trim(),
        management_plan: form.management_plan.trim(),
        patient_info: JSON.parse(form.patient_info),
        history_script: JSON.parse(form.history_script),
        pe_findings: JSON.parse(form.pe_findings),
        lab_results: JSON.parse(form.lab_results),
        accepted_ddx: JSON.parse(form.accepted_ddx),
        teaching_points: JSON.parse(form.teaching_points),
        examiner_questions: JSON.parse(form.examiner_questions),
        scoring_rubric: JSON.parse(form.scoring_rubric),
      };

      const { error: dbError } = await supabase
        .from("long_cases").update(payload).eq("id", id);
      if (dbError) throw dbError;
      router.push("/admin/longcases");
    } catch (err) {
      setError(String(err));
      setSaving(false);
    }
  }

  async function handleSoftDelete() {
    if (!confirm("ซ่อนเคสนี้? (เปลี่ยน is_published = false)")) return;
    setDeleting(true);
    const supabase = createClient();
    await supabase.from("long_cases").update({ is_published: false }).eq("id", id);
    router.push("/admin/longcases");
  }

  if (checking) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  if (notFound || !form) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <h1 className="text-2xl font-bold mb-4">ไม่พบเคสนี้</h1>
        <Link href="/admin/longcases">
          <Button variant="outline">กลับหน้ารายการ</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      {/* Header */}
      <div className="flex items-center justify-between gap-3 mb-6">
        <div className="flex items-center gap-3">
          <Link href="/admin/longcases">
            <Button variant="ghost" size="sm">
              <ArrowLeft className="h-4 w-4 mr-1" /> กลับ
            </Button>
          </Link>
          <div>
            <h1 className="text-xl font-bold flex items-center gap-2">
              <Pencil className="h-5 w-5 text-amber-500" />
              แก้ไข Long Case
            </h1>
            <p className="text-sm text-muted-foreground truncate max-w-xs">{form.title}</p>
          </div>
        </div>
        <Button
          variant="outline"
          size="sm"
          className="text-destructive border-destructive/30 hover:bg-destructive/5 gap-1"
          onClick={handleSoftDelete}
          disabled={deleting}
        >
          <Trash2 className="h-4 w-4" />
          {deleting ? "กำลังซ่อน..." : "ซ่อนเคส"}
        </Button>
      </div>

      <div className="space-y-5">
        {/* Basic info */}
        <Card>
          <CardHeader><CardTitle className="text-base">ข้อมูลพื้นฐาน</CardTitle></CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="title">Title (ชื่อเคส) *</Label>
              <Input
                id="title"
                value={form.title}
                onChange={e => update("title", e.target.value)}
                className="mt-1"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label>Specialty</Label>
                <select
                  value={form.specialty}
                  onChange={e => update("specialty", e.target.value)}
                  className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                >
                  {SPECIALTIES.map(s => <option key={s} value={s}>{s}</option>)}
                </select>
              </div>
              <div>
                <Label>Difficulty</Label>
                <select
                  value={form.difficulty}
                  onChange={e => update("difficulty", e.target.value)}
                  className="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                >
                  <option value="easy">ง่าย</option>
                  <option value="medium">ปานกลาง</option>
                  <option value="hard">ยาก</option>
                </select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="flex items-center gap-3">
                <input
                  type="checkbox"
                  id="is_weekly"
                  checked={form.is_weekly}
                  onChange={e => update("is_weekly", e.target.checked)}
                  className="h-4 w-4"
                />
                <Label htmlFor="is_weekly">Case ประจำสัปดาห์</Label>
              </div>
              {form.is_weekly && (
                <div>
                  <Label htmlFor="week_number">Week Number</Label>
                  <Input
                    id="week_number"
                    type="number"
                    value={form.week_number}
                    onChange={e => update("week_number", e.target.value)}
                    className="mt-1"
                  />
                </div>
              )}
            </div>
            <div className="flex items-center gap-3">
              <input
                type="checkbox"
                id="is_published"
                checked={form.is_published}
                onChange={e => update("is_published", e.target.checked)}
                className="h-4 w-4"
              />
              <Label htmlFor="is_published">เผยแพร่</Label>
            </div>
          </CardContent>
        </Card>

        {/* Diagnosis */}
        <Card>
          <CardHeader><CardTitle className="text-base">การวินิจฉัยและการรักษา</CardTitle></CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label htmlFor="correct_diagnosis">Correct Diagnosis *</Label>
              <Input
                id="correct_diagnosis"
                value={form.correct_diagnosis}
                onChange={e => update("correct_diagnosis", e.target.value)}
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="management_plan">Management Plan</Label>
              <Input
                id="management_plan"
                value={form.management_plan}
                onChange={e => update("management_plan", e.target.value)}
                className="mt-1"
              />
            </div>
          </CardContent>
        </Card>

        {/* JSON fields */}
        {JSON_FIELDS.map(({ key, label }) => (
          <Card key={key}>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm">{label}</CardTitle>
            </CardHeader>
            <CardContent>
              <textarea
                value={form[key as keyof FormState] as string}
                onChange={e => update(key as keyof FormState, e.target.value)}
                rows={6}
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-xs font-mono resize-y"
              />
            </CardContent>
          </Card>
        ))}

        {error && (
          <div className="rounded-lg bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">
            {error}
          </div>
        )}

        <div className="flex gap-3">
          <Button
            onClick={handleSave}
            disabled={saving}
            className="flex-1 bg-amber-500 hover:bg-amber-600 text-white"
          >
            {saving ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Save className="h-4 w-4 mr-2" />}
            บันทึกการแก้ไข
          </Button>
          <Link href="/admin/longcases">
            <Button variant="outline">ยกเลิก</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
