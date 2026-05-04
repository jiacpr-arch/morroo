"use client";

import { useState, useEffect, useMemo } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import { updateMcqQuestionStatus } from "@/lib/supabase/mutations-mcq-admin";
import {
  Shield, Loader2, ChevronLeft, Plus, Search,
  Pencil, Eye, EyeOff, AlertCircle, CheckCircle,
} from "lucide-react";

interface McqQuestion {
  id: string;
  subject_id: string;
  exam_type: string;
  scenario: string;
  correct_answer: string;
  difficulty: string;
  status: string;
  topic: string | null;
  created_at: string;
  mcq_subjects: { name_th: string; icon: string } | null;
}

interface McqSubject { id: string; name_th: string; icon: string; }

const STATUS_COLORS: Record<string, string> = {
  active: "bg-green-100 text-green-700",
  review: "bg-yellow-100 text-yellow-700",
  disabled: "bg-gray-100 text-gray-500",
};

const DIFFICULTY_COLORS: Record<string, string> = {
  easy: "bg-blue-100 text-blue-700",
  medium: "bg-orange-100 text-orange-700",
  hard: "bg-red-100 text-red-700",
};

export default function AdminMcqPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [questions, setQuestions] = useState<McqQuestion[]>([]);
  const [subjects, setSubjects] = useState<McqSubject[]>([]);

  const [search, setSearch] = useState("");
  const [subjectFilter, setSubjectFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [difficultyFilter, setDifficultyFilter] = useState("all");
  const [page, setPage] = useState(1);
  const PAGE_SIZE = 100;

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);

      const CHUNK = 1000;
      const all: McqQuestion[] = [];
      for (let from = 0; ; from += CHUNK) {
        const { data, error } = await supabase
          .from("mcq_questions")
          .select("id, subject_id, exam_type, scenario, correct_answer, difficulty, status, topic, created_at, mcq_subjects(name_th, icon)")
          .order("created_at", { ascending: false })
          .range(from, from + CHUNK - 1);
        if (error || !data || data.length === 0) break;
        all.push(...(data as unknown as McqQuestion[]));
        if (data.length < CHUNK) break;
      }

      const sRes = await supabase.from("mcq_subjects").select("id, name_th, icon").order("name_th");

      setQuestions(all);
      setSubjects((sRes.data as McqSubject[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  async function handleStatusChange(id: string, status: "active" | "review" | "disabled") {
    const ok = await updateMcqQuestionStatus(id, status);
    if (ok) {
      setQuestions((prev) =>
        prev.map((q) => (q.id === id ? { ...q, status } : q))
      );
    }
  }

  const filtered = useMemo(() => {
    let list = questions;
    if (search) {
      const q = search.toLowerCase();
      list = list.filter((x) => x.scenario.toLowerCase().includes(q) || x.topic?.toLowerCase().includes(q));
    }
    if (subjectFilter !== "all") list = list.filter((x) => x.subject_id === subjectFilter);
    if (statusFilter !== "all") list = list.filter((x) => x.status === statusFilter);
    if (difficultyFilter !== "all") list = list.filter((x) => x.difficulty === difficultyFilter);
    return list;
  }, [questions, search, subjectFilter, statusFilter, difficultyFilter]);

  useEffect(() => { setPage(1); }, [search, subjectFilter, statusFilter, difficultyFilter]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
  const currentPage = Math.min(page, totalPages);
  const pageStart = (currentPage - 1) * PAGE_SIZE;
  const pageItems = filtered.slice(pageStart, pageStart + PAGE_SIZE);

  if (loading) return <div className="flex items-center justify-center min-h-[60vh]"><Loader2 className="h-8 w-8 animate-spin text-brand" /></div>;

  if (!isAdmin) return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
      <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
    </div>
  );

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin"><Button variant="ghost" size="sm"><ChevronLeft className="h-4 w-4 mr-1" />Admin</Button></Link>
      </div>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">จัดการข้อสอบ MCQ/NL</h1>
          <p className="text-muted-foreground mt-1">เพิ่ม แก้ไข และจัดการสถานะข้อสอบ</p>
        </div>
        <Link href="/admin/mcq/new">
          <Button className="bg-brand hover:bg-brand-light text-white gap-2">
            <Plus className="h-4 w-4" />เพิ่มข้อสอบ
          </Button>
        </Link>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 mb-4">
        <div className="relative flex-1 min-w-[180px] max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="ค้นหาคำถาม / topic..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9 h-9" />
        </div>
        <select
          value={subjectFilter}
          onChange={(e) => setSubjectFilter(e.target.value)}
          className="border rounded-md px-3 py-1.5 text-sm bg-white"
        >
          <option value="all">ทุกสาขา</option>
          {subjects.map((s) => <option key={s.id} value={s.id}>{s.icon} {s.name_th}</option>)}
        </select>
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="border rounded-md px-3 py-1.5 text-sm bg-white"
        >
          <option value="all">ทุกสถานะ</option>
          <option value="active">Active</option>
          <option value="review">Review</option>
          <option value="disabled">Disabled</option>
        </select>
        <select
          value={difficultyFilter}
          onChange={(e) => setDifficultyFilter(e.target.value)}
          className="border rounded-md px-3 py-1.5 text-sm bg-white"
        >
          <option value="all">ทุกระดับ</option>
          <option value="easy">Easy</option>
          <option value="medium">Medium</option>
          <option value="hard">Hard</option>
        </select>
      </div>

      <div className="flex items-center justify-between mb-3">
        <p className="text-xs text-muted-foreground">
          แสดง {filtered.length === 0 ? 0 : pageStart + 1}–{pageStart + pageItems.length} จาก {filtered.length} ข้อ (ทั้งหมด {questions.length})
        </p>
        {totalPages > 1 && (
          <div className="flex items-center gap-2">
            <Button size="sm" variant="outline" disabled={currentPage <= 1} onClick={() => setPage((p) => Math.max(1, p - 1))}>
              ก่อนหน้า
            </Button>
            <span className="text-xs text-muted-foreground">หน้า {currentPage} / {totalPages}</span>
            <Button size="sm" variant="outline" disabled={currentPage >= totalPages} onClick={() => setPage((p) => Math.min(totalPages, p + 1))}>
              ถัดไป
            </Button>
          </div>
        )}
      </div>

      {/* Table */}
      <Card>
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b bg-muted/50">
                  <th className="text-left p-3 text-xs font-medium text-muted-foreground">คำถาม</th>
                  <th className="text-left p-3 text-xs font-medium text-muted-foreground hidden sm:table-cell">สาขา</th>
                  <th className="text-left p-3 text-xs font-medium text-muted-foreground hidden md:table-cell">Topic</th>
                  <th className="text-left p-3 text-xs font-medium text-muted-foreground">ระดับ</th>
                  <th className="text-left p-3 text-xs font-medium text-muted-foreground">สถานะ</th>
                  <th className="p-3 text-xs font-medium text-muted-foreground text-right">Actions</th>
                </tr>
              </thead>
              <tbody>
                {pageItems.map((q) => (
                  <tr key={q.id} className="border-b last:border-0 hover:bg-muted/20">
                    <td className="p-3 max-w-xs">
                      <p className="text-sm line-clamp-2">{q.scenario}</p>
                      <p className="text-xs text-muted-foreground mt-0.5">{q.exam_type} · ตอบ {q.correct_answer}</p>
                    </td>
                    <td className="p-3 hidden sm:table-cell">
                      <span className="text-sm">
                        {q.mcq_subjects?.icon} {q.mcq_subjects?.name_th}
                      </span>
                    </td>
                    <td className="p-3 hidden md:table-cell">
                      {q.topic ? (
                        <Badge variant="outline" className="text-xs">{q.topic}</Badge>
                      ) : (
                        <span className="text-xs text-muted-foreground">—</span>
                      )}
                    </td>
                    <td className="p-3">
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${DIFFICULTY_COLORS[q.difficulty] || ""}`}>
                        {q.difficulty}
                      </span>
                    </td>
                    <td className="p-3">
                      <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${STATUS_COLORS[q.status] || ""}`}>
                        {q.status}
                      </span>
                    </td>
                    <td className="p-3">
                      <div className="flex items-center justify-end gap-1">
                        {/* Quick status toggle */}
                        {q.status === "active" ? (
                          <Button size="icon" variant="ghost" className="h-7 w-7" title="ปิดใช้งาน"
                            onClick={() => handleStatusChange(q.id, "disabled")}>
                            <EyeOff className="h-3.5 w-3.5 text-muted-foreground" />
                          </Button>
                        ) : q.status === "disabled" ? (
                          <Button size="icon" variant="ghost" className="h-7 w-7" title="เปิดใช้งาน"
                            onClick={() => handleStatusChange(q.id, "active")}>
                            <Eye className="h-3.5 w-3.5 text-green-600" />
                          </Button>
                        ) : (
                          <Button size="icon" variant="ghost" className="h-7 w-7" title="อนุมัติ (Active)"
                            onClick={() => handleStatusChange(q.id, "active")}>
                            <CheckCircle className="h-3.5 w-3.5 text-green-600" />
                          </Button>
                        )}
                        {q.status !== "review" && (
                          <Button size="icon" variant="ghost" className="h-7 w-7" title="ส่ง Review"
                            onClick={() => handleStatusChange(q.id, "review")}>
                            <AlertCircle className="h-3.5 w-3.5 text-yellow-600" />
                          </Button>
                        )}
                        <Link href={`/admin/mcq/${q.id}`}>
                          <Button size="icon" variant="ghost" className="h-7 w-7">
                            <Pencil className="h-3.5 w-3.5" />
                          </Button>
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
                {pageItems.length === 0 && (
                  <tr><td colSpan={6} className="p-8 text-center text-muted-foreground">ไม่พบข้อสอบ</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {totalPages > 1 && (
        <div className="flex items-center justify-end gap-2 mt-3">
          <Button size="sm" variant="outline" disabled={currentPage <= 1} onClick={() => setPage((p) => Math.max(1, p - 1))}>
            ก่อนหน้า
          </Button>
          <span className="text-xs text-muted-foreground">หน้า {currentPage} / {totalPages}</span>
          <Button size="sm" variant="outline" disabled={currentPage >= totalPages} onClick={() => setPage((p) => Math.min(totalPages, p + 1))}>
            ถัดไป
          </Button>
        </div>
      )}
    </div>
  );
}
