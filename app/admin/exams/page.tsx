"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
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
  BookOpen,
  ArrowLeft,
  Eye,
  FileText,
} from "lucide-react";

interface Exam {
  id: string;
  title: string;
  category: string;
  difficulty: string;
  status: string;
  is_free: boolean;
  publish_date: string | null;
  created_at: string;
  part_count?: number;
}

const categories = [
  "อายุรศาสตร์",
  "ศัลยศาสตร์",
  "กุมารเวชศาสตร์",
  "สูติศาสตร์-นรีเวชวิทยา",
  "ออร์โธปิดิกส์",
  "จิตเวชศาสตร์",
];

export default function AdminExamsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [exams, setExams] = useState<Exam[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);
  const [form, setForm] = useState({
    title: "",
    category: categories[0],
    difficulty: "medium" as "easy" | "medium" | "hard",
    status: "draft" as "draft" | "scheduled" | "published",
    is_free: false,
    publish_date: "",
  });

  const loadExams = useCallback(async () => {
    const supabase = createClient();
    const { data } = await supabase
      .from("exams")
      .select("*")
      .order("created_at", { ascending: false });

    if (data) {
      // Get part counts
      const { data: parts } = await supabase
        .from("exam_parts")
        .select("exam_id");

      const counts: Record<string, number> = {};
      if (parts) {
        for (const p of parts) {
          counts[p.exam_id] = (counts[p.exam_id] || 0) + 1;
        }
      }

      setExams(
        data.map((e: Exam) => ({ ...e, part_count: counts[e.id] || 0 }))
      );
    }
  }, []);

  useEffect(() => {
    async function checkAdmin() {
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
      await loadExams();
      setLoading(false);
    }
    checkAdmin();
  }, [router, loadExams]);

  const resetForm = () => {
    setForm({
      title: "",
      category: categories[0],
      difficulty: "medium",
      status: "draft",
      is_free: false,
      publish_date: "",
    });
    setEditingId(null);
    setShowForm(false);
  };

  const startEdit = (exam: Exam) => {
    setForm({
      title: exam.title,
      category: exam.category,
      difficulty: exam.difficulty as "easy" | "medium" | "hard",
      status: exam.status as "draft" | "scheduled" | "published",
      is_free: exam.is_free,
      publish_date: exam.publish_date || "",
    });
    setEditingId(exam.id);
    setShowForm(true);
  };

  const handleSave = async () => {
    if (!form.title.trim()) return;
    setSaving(true);
    const supabase = createClient();

    const examData = {
      title: form.title,
      category: form.category,
      difficulty: form.difficulty,
      status: form.status,
      is_free: form.is_free,
      publish_date: form.publish_date || null,
    };

    if (editingId) {
      await supabase.from("exams").update(examData).eq("id", editingId);
    } else {
      await supabase.from("exams").insert(examData);
    }

    await loadExams();
    resetForm();
    setSaving(false);
  };

  const handleDelete = async (id: string, title: string) => {
    if (!confirm(`ลบข้อสอบ "${title}" และตอนย่อยทั้งหมด?`)) return;
    const supabase = createClient();
    await supabase.from("exams").delete().eq("id", id);
    await loadExams();
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

  const difficultyLabels: Record<string, string> = {
    easy: "ง่าย",
    medium: "ปานกลาง",
    hard: "ยาก",
  };

  const statusLabels: Record<string, { label: string; color: string }> = {
    draft: { label: "แบบร่าง", color: "bg-gray-100 text-gray-700" },
    scheduled: { label: "กำหนดเผยแพร่", color: "bg-blue-100 text-blue-700" },
    published: { label: "เผยแพร่แล้ว", color: "bg-green-100 text-green-700" },
  };

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <Link
            href="/admin"
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-2"
          >
            <ArrowLeft className="h-4 w-4" /> Admin Dashboard
          </Link>
          <h1 className="text-2xl font-bold">จัดการข้อสอบ</h1>
        </div>
        <Button
          className="bg-brand hover:bg-brand-light text-white gap-1"
          onClick={() => {
            resetForm();
            setShowForm(true);
          }}
        >
          <Plus className="h-4 w-4" /> เพิ่มข้อสอบ
        </Button>
      </div>

      {/* Add/Edit Form */}
      {showForm && (
        <Card className="mb-8 border-brand/30">
          <CardHeader className="pb-3">
            <h2 className="font-bold">
              {editingId ? "แก้ไขข้อสอบ" : "เพิ่มข้อสอบใหม่"}
            </h2>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <Label>ชื่อข้อสอบ</Label>
              <Input
                value={form.title}
                onChange={(e) => setForm({ ...form, title: e.target.value })}
                placeholder="เช่น ภาวะเลือดออกในทางเดินอาหารส่วนบน"
              />
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              <div>
                <Label>สาขาวิชา</Label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.category}
                  onChange={(e) =>
                    setForm({ ...form, category: e.target.value })
                  }
                >
                  {categories.map((c) => (
                    <option key={c} value={c}>
                      {c}
                    </option>
                  ))}
                </select>
              </div>
              <div>
                <Label>ความยาก</Label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.difficulty}
                  onChange={(e) =>
                    setForm({
                      ...form,
                      difficulty: e.target.value as "easy" | "medium" | "hard",
                    })
                  }
                >
                  <option value="easy">ง่าย</option>
                  <option value="medium">ปานกลาง</option>
                  <option value="hard">ยาก</option>
                </select>
              </div>
              <div>
                <Label>สถานะ</Label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.status}
                  onChange={(e) =>
                    setForm({
                      ...form,
                      status: e.target.value as "draft" | "scheduled" | "published",
                    })
                  }
                >
                  <option value="draft">แบบร่าง</option>
                  <option value="scheduled">กำหนดเผยแพร่</option>
                  <option value="published">เผยแพร่</option>
                </select>
              </div>
              <div>
                <Label>วันที่เผยแพร่</Label>
                <Input
                  type="date"
                  value={form.publish_date}
                  onChange={(e) =>
                    setForm({ ...form, publish_date: e.target.value })
                  }
                />
              </div>
            </div>
            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id="is_free"
                checked={form.is_free}
                onChange={(e) =>
                  setForm({ ...form, is_free: e.target.checked })
                }
                className="rounded"
              />
              <Label htmlFor="is_free">ข้อสอบฟรี</Label>
            </div>
            <div className="flex gap-2">
              <Button
                className="bg-brand hover:bg-brand-light text-white"
                onClick={handleSave}
                disabled={saving}
              >
                {saving ? (
                  <Loader2 className="h-4 w-4 animate-spin mr-1" />
                ) : null}
                {editingId ? "บันทึกการแก้ไข" : "สร้างข้อสอบ"}
              </Button>
              <Button variant="outline" onClick={resetForm}>
                ยกเลิก
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Exams List */}
      <div className="space-y-3">
        {exams.map((exam) => {
          const status = statusLabels[exam.status] || statusLabels.draft;
          return (
            <Card key={exam.id}>
              <CardContent className="py-4">
                <div className="flex items-center justify-between flex-wrap gap-3">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap mb-1">
                      <h3 className="font-semibold truncate">{exam.title}</h3>
                    </div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <Badge variant="secondary" className="text-xs">
                        {exam.category}
                      </Badge>
                      <Badge className={`text-xs ${status.color}`}>
                        {status.label}
                      </Badge>
                      <Badge
                        className={`text-xs ${
                          exam.difficulty === "hard"
                            ? "bg-red-100 text-red-700"
                            : exam.difficulty === "medium"
                            ? "bg-yellow-100 text-yellow-700"
                            : "bg-green-100 text-green-700"
                        }`}
                      >
                        {difficultyLabels[exam.difficulty]}
                      </Badge>
                      {exam.is_free && (
                        <Badge className="bg-brand/10 text-brand text-xs">
                          ฟรี
                        </Badge>
                      )}
                      <span className="text-xs text-muted-foreground flex items-center gap-1">
                        <FileText className="h-3 w-3" />
                        {exam.part_count} ตอน
                      </span>
                    </div>
                  </div>
                  <div className="flex items-center gap-1">
                    <Link href={`/admin/exams/${exam.id}`}>
                      <Button variant="ghost" size="sm" className="gap-1">
                        <FileText className="h-4 w-4" /> จัดการตอน
                      </Button>
                    </Link>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => startEdit(exam)}
                    >
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      className="text-destructive hover:text-destructive"
                      onClick={() => handleDelete(exam.id, exam.title)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
