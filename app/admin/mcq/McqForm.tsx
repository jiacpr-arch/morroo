"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { createMcqQuestion, updateMcqQuestion } from "@/lib/supabase/mutations-mcq-admin";
import { ChevronLeft, Save, Loader2 } from "lucide-react";

interface McqSubject { id: string; name_th: string; icon: string; }

interface FormData {
  id?: string;
  subject_id: string;
  exam_type: "NL1" | "NL2";
  exam_source: string;
  scenario: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string;
  difficulty: "easy" | "medium" | "hard";
  topic: string;
  status: "active" | "review" | "disabled";
}

const EMPTY_FORM: FormData = {
  subject_id: "",
  exam_type: "NL2",
  exam_source: "",
  scenario: "",
  choices: [
    { label: "A", text: "" },
    { label: "B", text: "" },
    { label: "C", text: "" },
    { label: "D", text: "" },
    { label: "E", text: "" },
  ],
  correct_answer: "A",
  explanation: "",
  difficulty: "medium",
  topic: "",
  status: "active",
};

export function McqForm({
  initial,
  subjects,
}: {
  initial?: Partial<FormData> & { id?: string };
  subjects: McqSubject[];
}) {
  const router = useRouter();
  const [form, setForm] = useState<FormData>({ ...EMPTY_FORM, ...initial });
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  function setField<K extends keyof FormData>(key: K, value: FormData[K]) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  function setChoice(index: number, text: string) {
    const choices = [...form.choices];
    choices[index] = { ...choices[index], text };
    setForm((prev) => ({ ...prev, choices }));
  }

  async function handleSave() {
    if (!form.subject_id) { setError("กรุณาเลือกสาขา"); return; }
    if (!form.scenario.trim()) { setError("กรุณาใส่โจทย์"); return; }
    if (form.choices.some((c) => !c.text.trim())) { setError("กรุณาใส่ตัวเลือกให้ครบ 5 ข้อ"); return; }

    setSaving(true);
    setError(null);

    const payload = {
      subject_id: form.subject_id,
      exam_type: form.exam_type,
      exam_source: form.exam_source || null,
      scenario: form.scenario.trim(),
      choices: form.choices,
      correct_answer: form.correct_answer,
      explanation: form.explanation || null,
      difficulty: form.difficulty,
      topic: form.topic || null,
      status: form.status,
    };

    if (form.id) {
      const ok = await updateMcqQuestion(form.id, payload);
      if (!ok) { setError("บันทึกไม่สำเร็จ กรุณาลองใหม่"); setSaving(false); return; }
    } else {
      const row = await createMcqQuestion(payload);
      if (!row) { setError("เพิ่มข้อสอบไม่สำเร็จ กรุณาลองใหม่"); setSaving(false); return; }
    }

    router.push("/admin/mcq");
    router.refresh();
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/mcq">
          <Button variant="ghost" size="sm"><ChevronLeft className="h-4 w-4 mr-1" />รายการข้อสอบ</Button>
        </Link>
      </div>

      <h1 className="text-2xl font-bold mb-6">{form.id ? "แก้ไขข้อสอบ" : "เพิ่มข้อสอบใหม่"}</h1>

      <div className="space-y-6">
        {/* Meta */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium mb-1.5 block">สาขา *</label>
            <select
              value={form.subject_id}
              onChange={(e) => setField("subject_id", e.target.value)}
              className="w-full border rounded-md px-3 py-2 text-sm bg-white"
            >
              <option value="">-- เลือกสาขา --</option>
              {subjects.map((s) => (
                <option key={s.id} value={s.id}>{s.icon} {s.name_th}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="text-sm font-medium mb-1.5 block">ประเภทสอบ</label>
            <select
              value={form.exam_type}
              onChange={(e) => setField("exam_type", e.target.value as "NL1" | "NL2")}
              className="w-full border rounded-md px-3 py-2 text-sm bg-white"
            >
              <option value="NL1">NL1</option>
              <option value="NL2">NL2</option>
            </select>
          </div>
          <div>
            <label className="text-sm font-medium mb-1.5 block">แหล่งที่มา</label>
            <Input
              value={form.exam_source}
              onChange={(e) => setField("exam_source", e.target.value)}
              placeholder="เช่น ศรว 2010, NL2-CU 2558"
            />
          </div>
          <div>
            <label className="text-sm font-medium mb-1.5 block">Topic (ย่อย)</label>
            <Input
              value={form.topic}
              onChange={(e) => setField("topic", e.target.value)}
              placeholder="เช่น HF, Sepsis, ACS"
            />
          </div>
        </div>

        {/* Scenario */}
        <div>
          <label className="text-sm font-medium mb-1.5 block">โจทย์ (Scenario) *</label>
          <textarea
            value={form.scenario}
            onChange={(e) => setField("scenario", e.target.value)}
            rows={5}
            className="w-full border rounded-md px-3 py-2 text-sm resize-y"
            placeholder="ผู้ป่วยชาย อายุ 50 ปี มาด้วยอาการ..."
          />
        </div>

        {/* Choices */}
        <div>
          <label className="text-sm font-medium mb-2 block">ตัวเลือก *</label>
          <div className="space-y-2">
            {form.choices.map((c, i) => (
              <div key={c.label} className="flex items-center gap-3">
                <button
                  type="button"
                  onClick={() => setField("correct_answer", c.label)}
                  className={`w-8 h-8 rounded-full border-2 flex items-center justify-center text-sm font-bold shrink-0 transition-colors ${
                    form.correct_answer === c.label
                      ? "bg-green-500 border-green-500 text-white"
                      : "border-gray-300 text-muted-foreground hover:border-green-400"
                  }`}
                  title="คลิกเพื่อเลือกเป็นคำตอบที่ถูก"
                >
                  {c.label}
                </button>
                <Input
                  value={c.text}
                  onChange={(e) => setChoice(i, e.target.value)}
                  placeholder={`ตัวเลือก ${c.label}`}
                  className="flex-1"
                />
              </div>
            ))}
          </div>
          <p className="text-xs text-muted-foreground mt-2">
            คลิกที่วงกลมตัวอักษรเพื่อเลือกเป็นคำตอบที่ถูกต้อง (ปัจจุบัน: <strong>{form.correct_answer}</strong>)
          </p>
        </div>

        {/* Explanation */}
        <div>
          <label className="text-sm font-medium mb-1.5 block">เฉลย (Explanation)</label>
          <textarea
            value={form.explanation}
            onChange={(e) => setField("explanation", e.target.value)}
            rows={3}
            className="w-full border rounded-md px-3 py-2 text-sm resize-y"
            placeholder="อธิบายเหตุผลที่ตอบ..."
          />
        </div>

        {/* Difficulty + Status */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="text-sm font-medium mb-1.5 block">ความยาก</label>
            <div className="flex gap-2">
              {(["easy", "medium", "hard"] as const).map((d) => (
                <button
                  key={d}
                  type="button"
                  onClick={() => setField("difficulty", d)}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium border transition-colors ${
                    form.difficulty === d
                      ? d === "easy" ? "bg-blue-500 text-white border-blue-500"
                        : d === "medium" ? "bg-orange-500 text-white border-orange-500"
                        : "bg-red-500 text-white border-red-500"
                      : "bg-white text-muted-foreground border-gray-200 hover:bg-muted"
                  }`}
                >
                  {d === "easy" ? "Easy" : d === "medium" ? "Medium" : "Hard"}
                </button>
              ))}
            </div>
          </div>
          <div>
            <label className="text-sm font-medium mb-1.5 block">สถานะ</label>
            <div className="flex gap-2">
              {(["active", "review", "disabled"] as const).map((s) => (
                <button
                  key={s}
                  type="button"
                  onClick={() => setField("status", s)}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium border transition-colors ${
                    form.status === s
                      ? s === "active" ? "bg-green-500 text-white border-green-500"
                        : s === "review" ? "bg-yellow-500 text-white border-yellow-500"
                        : "bg-gray-400 text-white border-gray-400"
                      : "bg-white text-muted-foreground border-gray-200 hover:bg-muted"
                  }`}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>
        </div>

        {error && (
          <div className="rounded-md bg-red-50 border border-red-200 px-4 py-3 text-sm text-red-700">
            {error}
          </div>
        )}

        <div className="flex items-center justify-between pt-2">
          <Link href="/admin/mcq">
            <Button variant="outline">ยกเลิก</Button>
          </Link>
          <Button
            onClick={handleSave}
            disabled={saving}
            className="bg-brand hover:bg-brand-light text-white gap-2"
          >
            {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
            บันทึก
          </Button>
        </div>
      </div>
    </div>
  );
}
