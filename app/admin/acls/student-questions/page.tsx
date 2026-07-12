"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, ChevronDown, ExternalLink, Filter, RefreshCw, Loader2, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import {
  StudentQuestionReviewItem,
  type StudentQuestionRow,
  type StudentQuestionChapterOption,
} from "@/components/admin/acls/StudentQuestionReviewItem";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";

const STATUS_FILTERS: { value: string; label: string }[] = [
  { value: "all", label: "ทั้งหมด" },
  { value: "draft_ready", label: "🟡 พร้อมตรวจ" },
  { value: "pending", label: "⏳ รอประมวลผล" },
  { value: "processing", label: "⚙️ กำลังประมวลผล" },
  { value: "failed", label: "❌ ล้มเหลว" },
  { value: "published", label: "✅ เผยแพร่แล้ว" },
  { value: "rejected", label: "🚫 ปฏิเสธ" },
];

// Review student-submitted questions: filter by status, edit AI drafts,
// publish/reprocess/reject/delete.
// Ported from acls-emr's src/pages/AdminStudentQuestions.jsx.
export default function AdminStudentQuestionsPage() {
  const status = useAdminGate();
  const [items, setItems] = useState<StudentQuestionRow[]>([]);
  const [chapters, setChapters] = useState<StudentQuestionChapterOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("draft_ready");

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [itemsRes, chaptersRes] = await Promise.all([
        apiGet<{ items: StudentQuestionRow[] }>("/api/admin/acls/student-question"),
        apiGet<{ chapters: StudentQuestionChapterOption[] }>("/api/admin/acls/chapters"),
      ]);
      setItems(itemsRes.items);
      setChapters(chaptersRes.chapters);
    } catch (err) {
      alert("โหลดไม่สำเร็จ: " + errMsg(err));
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    if (status === "ok") load();
  }, [status, load]);

  const counts = useMemo(() => {
    const map: Record<string, number> = {};
    for (const it of items) map[it.status] = (map[it.status] || 0) + 1;
    return map;
  }, [items]);

  const filtered = useMemo(() => (filter === "all" ? items : items.filter((i) => i.status === filter)), [items, filter]);

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ChevronLeft className="h-4 w-4" /> กลับไป Admin
        </Link>
        <div className="flex items-center gap-3">
          <Link href="/admin/acls/qa-deep" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
            <Shield className="h-4 w-4" /> Q&A
          </Link>
          <Link href="/acls/qa-deep" target="_blank" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
            <ExternalLink className="h-4 w-4" /> ดูหน้า
          </Link>
        </div>
      </div>

      <div>
        <h1 className="text-2xl font-bold">คำถามจากนักเรียน</h1>
        <p className="text-muted-foreground mt-1">ตรวจสอบคำตอบที่ AI ร่าง · แก้ไข · เผยแพร่เข้า Q&A</p>
      </div>

      <div className="border rounded-md p-4 space-y-3">
        <div className="text-xs font-bold text-blue-600 uppercase inline-flex items-center gap-1.5">
          <Filter className="h-3 w-3" /> ตัวกรองสถานะ
        </div>
        <div className="relative">
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="w-full pl-3 pr-10 py-2 bg-background border rounded-md text-sm appearance-none"
          >
            {STATUS_FILTERS.map((s) => {
              const n = s.value === "all" ? items.length : counts[s.value] || 0;
              return (
                <option key={s.value} value={s.value}>
                  {s.label} ({n})
                </option>
              );
            })}
          </select>
          <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
        </div>
      </div>

      <div className="flex items-center justify-between gap-2">
        <h2 className="text-base font-bold">รายการ ({filtered.length})</h2>
        <Button size="sm" variant="ghost" disabled={loading} onClick={load}>
          <RefreshCw className={`h-3.5 w-3.5 mr-1 ${loading ? "animate-spin" : ""}`} /> รีเฟรช
        </Button>
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-8">
          <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
        </div>
      ) : filtered.length === 0 ? (
        <div className="border rounded-md text-center text-sm text-muted-foreground py-6">ไม่มีคำถามในสถานะนี้</div>
      ) : (
        <div className="space-y-3">
          {filtered.map((item) => (
            <StudentQuestionReviewItem key={item.id} item={item} chapters={chapters} onChange={load} />
          ))}
        </div>
      )}
    </div>
  );
}
