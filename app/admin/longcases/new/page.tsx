"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { ArrowLeft, Loader2, Save, Sparkles } from "lucide-react";

const SPECIALTIES = [
  "Medicine", "Surgery", "Obstetrics", "Pediatrics",
  "Emergency", "Cardiology", "Neurology", "Orthopedics",
];

const EMPTY_CASE = {
  title: "",
  specialty: "Medicine",
  difficulty: "medium",
  is_weekly: false,
  week_number: "",
  is_published: true,
  patient_info: `{
  "name": "นายทดสอบ ใจดี",
  "age": 45,
  "gender": "ชาย",
  "underlying": [],
  "vitals": { "bp": "130/80", "pr": 88, "temp": 37.2, "rr": 18, "o2sat": 98 }
}`,
  history_script: `{
  "cc": "อาการหลักที่นำมาพบแพทย์",
  "pi": "รายละเอียดอาการปัจจุบัน",
  "onset": "ลักษณะการเกิดอาการ ระยะเวลา",
  "pmh": "โรคประจำตัว",
  "fh": "ประวัติครอบครัว",
  "sh": "ประวัติสังคม การทำงาน สูบบุหรี่/ดื่มสุรา",
  "ros": "ระบบอื่นๆ ที่เกี่ยวข้อง"
}`,
  pe_findings: `{
  "General Appearance": "Alert, no acute distress",
  "Heart": "Regular rate, no murmur",
  "Lung": "Clear to auscultation bilaterally",
  "Abdomen": "Soft, non-tender"
}`,
  lab_results: `{
  "CBC": { "value": "WBC 8.5, Hgb 13.2, Plt 220", "isAbnormal": false },
  "BMP": { "value": "Na 138, K 4.0, Cr 0.9, Glucose 95", "isAbnormal": false }
}`,
  correct_diagnosis: "",
  accepted_ddx: `["การวินิจฉัยที่ถูกต้อง", "Differential 1", "Differential 2"]`,
  management_plan: "แผนการรักษาที่ถูกต้อง",
  teaching_points: `["Teaching point 1", "Teaching point 2", "Teaching point 3"]`,
  examiner_questions: `[
  { "question": "What is your diagnosis?", "modelAnswer": "Model answer here", "points": 10 },
  { "question": "How would you manage this patient?", "modelAnswer": "Management answer", "points": 10 }
]`,
  scoring_rubric: `{
  "history": 25,
  "pe": 20,
  "lab": 15,
  "ddx": 20,
  "management": 20
}`,
};

export default function NewLongCasePage() {
  const router = useRouter();
  const [checking, setChecking] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [form, setForm] = useState(EMPTY_CASE);

  useEffect(() => {
    async function check() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("users").select("role").eq("id", user.id).single();
      setIsAdmin(profile?.role === "admin");
      setChecking(false);
    }
    check();
  }, [router]);

  function update(field: string, value: string | boolean) {
    setForm(prev => ({ ...prev, [field]: value }));
  }

  async function handleSave() {
    if (!form.title.trim() || !form.correct_diagnosis.trim()) {
      setError("กรุณากรอก Title และ Correct Diagnosis");
      return;
    }

    // Validate JSON fields
    const jsonFields = [
      "patient_info", "history_script", "pe_findings", "lab_results",
      "accepted_ddx", "teaching_points", "examiner_questions", "scoring_rubric",
    ];
    for (const f of jsonFields) {
      try {
        JSON.parse(form[f as keyof typeof form] as string);
      } catch {
        setError(`JSON ไม่ถูกต้องใน field: ${f}`);
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
        patient_info: JSON.parse(form.patient_info),
        history_script: JSON.parse(form.history_script),
        pe_findings: JSON.parse(form.pe_findings),
        lab_results: JSON.parse(form.lab_results),
        correct_diagnosis: form.correct_diagnosis.trim(),
        accepted_ddx: JSON.parse(form.accepted_ddx),
        management_plan: form.management_plan.trim(),
        teaching_points: JSON.parse(form.teaching_points),
        examiner_questions: JSON.parse(form.examiner_questions),
        scoring_rubric: JSON.parse(form.scoring_rubric),
      };

      const { error: dbError } = await supabase.from("long_cases").insert(payload);
      if (dbError) throw dbError;
      router.push("/admin/longcases");
    } catch (err) {
      setError(String(err));
      setSaving(false);
    }
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

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <Link href="/admin/longcases">
          <Button variant="ghost" size="sm">
            <ArrowLeft className="h-4 w-4 mr-1" /> กลับ
          </Button>
        </Link>
        <div>
          <h1 className="text-xl font-bold flex items-center gap-2">
            <Sparkles className="h-5 w-5 text-amber-500" />
            เพิ่ม Long Case ใหม่
          </h1>
          <p className="text-sm text-muted-foreground">กรอกข้อมูลเคสในรูปแบบ JSON</p>
        </div>
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
                placeholder="เช่น Acute Appendicitis"
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
                    placeholder="เช่น 1"
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
              <Label htmlFor="is_published">เผยแพร่ทันที</Label>
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
                placeholder="เช่น Acute Appendicitis (K35.9)"
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
        {[
          { key: "patient_info", label: "Patient Info (JSON)" },
          { key: "history_script", label: "History Script (JSON)" },
          { key: "pe_findings", label: "PE Findings (JSON)" },
          { key: "lab_results", label: "Lab Results (JSON)" },
          { key: "accepted_ddx", label: "Accepted DDx (JSON array)" },
          { key: "teaching_points", label: "Teaching Points (JSON array)" },
          { key: "examiner_questions", label: "Examiner Questions (JSON array)" },
          { key: "scoring_rubric", label: "Scoring Rubric (JSON)" },
        ].map(({ key, label }) => (
          <Card key={key}>
            <CardHeader className="pb-2"><CardTitle className="text-sm">{label}</CardTitle></CardHeader>
            <CardContent>
              <textarea
                value={form[key as keyof typeof form] as string}
                onChange={e => update(key, e.target.value)}
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
            บันทึกเคส
          </Button>
          <Link href="/admin/longcases">
            <Button variant="outline">ยกเลิก</Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
