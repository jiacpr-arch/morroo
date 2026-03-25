"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { use } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import {
  Plus,
  Pencil,
  Trash2,
  Loader2,
  Shield,
  ArrowLeft,
  Save,
  X,
} from "lucide-react";

interface ExamPart {
  id: string;
  exam_id: string;
  part_number: number;
  title: string;
  scenario: string;
  question: string;
  answer: string;
  key_points: string[];
  time_minutes: number;
}

interface Exam {
  id: string;
  title: string;
  category: string;
}

export default function AdminExamPartsPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id: examId } = use(params);
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [exam, setExam] = useState<Exam | null>(null);
  const [parts, setParts] = useState<ExamPart[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({
    title: "",
    scenario: "",
    question: "",
    answer: "",
    key_points: "",
    time_minutes: 10,
  });

  const loadParts = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("exam_parts")
      .select("*")
      .eq("exam_id", examId)
      .order("part_number", { ascending: true });
    setParts((data as ExamPart[]) || []);
  }, [examId]);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();

      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }

      setIsAdmin(true);

      const { data: examData } = await supabase
        .from("exams")
        .select("id, title, category")
        .eq("id", examId)
        .single();

      setExam(examData as Exam);
      await loadParts();
      setLoading(false);
    }
    init();
  }, [examId, router, loadParts]);

  const resetForm = () => {
    setForm({
      title: "",
      scenario: "",
      question: "",
      answer: "",
      key_points: "",
      time_minutes: 10,
    });
    setEditingId(null);
    setShowForm(false);
  };

  const startEdit = (part: ExamPart) => {
    setForm({
      title: part.title,
      scenario: part.scenario,
      question: part.question,
      answer: part.answer,
      key_points: part.key_points.join("\n"),
      time_minutes: part.time_minutes,
    });
    setEditingId(part.id);
    setShowForm(true);
  };

  const handleSave = async () => {
    if (!form.title.trim() || !form.question.trim()) return;
    setSaving(true);
    const supabase = createClient();

    const partData = {
      exam_id: examId,
      title: form.title,
      scenario: form.scenario,
      question: form.question,
      answer: form.answer,
      key_points: form.key_points
        .split("\n")
        .map((s) => s.trim())
        .filter(Boolean),
      time_minutes: form.time_minutes,
    };

    if (editingId) {
      await supabase.from("exam_parts").update(partData).eq("id", editingId);
    } else {
      const nextNumber = parts.length + 1;
      await supabase
        .from("exam_parts")
        .insert({ ...partData, part_number: nextNumber });
    }

    await loadParts();
    resetForm();
    setSaving(false);
  };

  const handleDelete = async (id: string, title: string) => {
    if (!confirm(`ลบ "${title}"?`)) return;
    const supabase = createClient();
    await supabase.from("exam_parts").delete().eq("id", id);
    await loadParts();
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <Link
          href="/admin/exams"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-2"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้าจัดการข้อสอบ
        </Link>
        <h1 className="text-2xl font-bold">
          {exam?.title || "ข้อสอบ"}
        </h1>
        <p className="text-muted-foreground">
          {exam?.category} &bull; {parts.length} ตอน
        </p>
      </div>

      <div className="flex justify-end mb-4">
        <Button
          className="bg-brand hover:bg-brand-light text-white gap-1"
          onClick={() => {
            resetForm();
            setShowForm(true);
          }}
        >
          <Plus className="h-4 w-4" /> เพิ่มตอน
        </Button>
      </div>

      {/* Add/Edit Form */}
      {showForm && (
        <Card className="mb-6 border-brand/30">
          <CardHeader className="pb-3 flex flex-row items-center justify-between">
            <h2 className="font-bold">
              {editingId ? "แก้ไขตอน" : `เพิ่มตอนที่ ${parts.length + 1}`}
            </h2>
            <Button variant="ghost" size="sm" onClick={resetForm}>
              <X className="h-4 w-4" />
            </Button>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label>ชื่อตอน</Label>
                <Input
                  value={form.title}
                  onChange={(e) => setForm({ ...form, title: e.target.value })}
                  placeholder="เช่น ตอนที่ 1: ประวัติและการตรวจเบื้องต้น"
                />
              </div>
              <div>
                <Label>เวลา (นาที)</Label>
                <Input
                  type="number"
                  value={form.time_minutes}
                  onChange={(e) =>
                    setForm({ ...form, time_minutes: parseInt(e.target.value) || 10 })
                  }
                />
              </div>
            </div>
            <div>
              <Label>สถานการณ์ (Scenario)</Label>
              <textarea
                className="w-full rounded-md border px-3 py-2 text-sm min-h-[100px]"
                value={form.scenario}
                onChange={(e) => setForm({ ...form, scenario: e.target.value })}
                placeholder="รายละเอียดสถานการณ์ของผู้ป่วย..."
              />
            </div>
            <div>
              <Label>คำถาม</Label>
              <textarea
                className="w-full rounded-md border px-3 py-2 text-sm min-h-[60px]"
                value={form.question}
                onChange={(e) => setForm({ ...form, question: e.target.value })}
                placeholder="คำถามสำหรับตอนนี้..."
              />
            </div>
            <div>
              <Label>เฉลย</Label>
              <textarea
                className="w-full rounded-md border px-3 py-2 text-sm min-h-[120px]"
                value={form.answer}
                onChange={(e) => setForm({ ...form, answer: e.target.value })}
                placeholder="เฉลยละเอียด..."
              />
            </div>
            <div>
              <Label>Key Points (บรรทัดละ 1 ข้อ)</Label>
              <textarea
                className="w-full rounded-md border px-3 py-2 text-sm min-h-[80px]"
                value={form.key_points}
                onChange={(e) =>
                  setForm({ ...form, key_points: e.target.value })
                }
                placeholder={"Key Point 1\nKey Point 2\nKey Point 3"}
              />
            </div>
            <div className="flex gap-2">
              <Button
                className="bg-brand hover:bg-brand-light text-white gap-1"
                onClick={handleSave}
                disabled={saving}
              >
                {saving ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <Save className="h-4 w-4" />
                )}
                {editingId ? "บันทึก" : "เพิ่มตอน"}
              </Button>
              <Button variant="outline" onClick={resetForm}>
                ยกเลิก
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Parts List */}
      {parts.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <p className="text-muted-foreground">
              ยังไม่มีตอนย่อย กด &quot;เพิ่มตอน&quot; เพื่อเริ่มสร้าง
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {parts.map((part) => (
            <Card key={part.id}>
              <CardContent className="py-4">
                <div className="flex items-start justify-between gap-3">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      <Badge variant="secondary" className="text-xs">
                        ตอนที่ {part.part_number}
                      </Badge>
                      <Badge variant="outline" className="text-xs">
                        {part.time_minutes} นาที
                      </Badge>
                    </div>
                    <h3 className="font-semibold">{part.title}</h3>
                    <p className="text-sm text-muted-foreground mt-1 line-clamp-2">
                      {part.scenario.substring(0, 150)}...
                    </p>
                    <p className="text-xs text-muted-foreground mt-1">
                      Key Points: {part.key_points.length} ข้อ
                    </p>
                  </div>
                  <div className="flex gap-1">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => startEdit(part)}
                    >
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      className="text-destructive hover:text-destructive"
                      onClick={() => handleDelete(part.id, part.title)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
