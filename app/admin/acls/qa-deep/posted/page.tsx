"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, ChevronDown, ArrowLeft, ExternalLink, Filter, ListChecks, Loader2 } from "lucide-react";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { QaDeepItemEditor, type QaDeepItem, type QaDeepChapterOption } from "@/components/admin/acls/QaDeepItemEditor";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";

const UNCATEGORIZED_FILTER = "_uncategorized";
const ALL_FILTER = "_all";

// Q&A ACLS Deep — "posted" archive: every item that already has a question,
// with a chapter filter, edit/reorder/delete via QaDeepItemEditor.
// Ported from acls-emr's src/pages/AdminQADeepPosted.jsx.
// NOTE: the source's "จัดหมวดอัตโนมัติทั้งหมด" (AI bulk-classify) button is
// omitted here — it depends on the DeepSeek classify endpoint
// (app/api/qa-deep/classify), which is outside this phase's scope (see
// QaDeepItemEditor.tsx for the same note on the per-item auto-classify).
export default function AdminQaDeepPostedPage() {
  const status = useAdminGate();
  const [items, setItems] = useState<QaDeepItem[]>([]);
  const [chapters, setChapters] = useState<QaDeepChapterOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState(ALL_FILTER);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const [itemsRes, chaptersRes] = await Promise.all([
        apiGet<{ items: QaDeepItem[] }>("/api/admin/acls/qa-deep"),
        apiGet<{ chapters: QaDeepChapterOption[] }>("/api/admin/acls/chapters"),
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

  const postedItems = useMemo(() => items.filter((i) => (i.question || "").trim()), [items]);

  const counts = useMemo(() => {
    const map = new Map<string, number>();
    let uncategorized = 0;
    for (const it of postedItems) {
      if (it.chapter_id) map.set(it.chapter_id, (map.get(it.chapter_id) ?? 0) + 1);
      else uncategorized += 1;
    }
    return { byChapter: map, uncategorized };
  }, [postedItems]);

  const filteredItems = useMemo(() => {
    if (filter === ALL_FILTER) return postedItems;
    if (filter === UNCATEGORIZED_FILTER) return postedItems.filter((i) => !i.chapter_id);
    return postedItems.filter((i) => i.chapter_id === filter);
  }, [postedItems, filter]);

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ChevronLeft className="h-4 w-4" /> กลับไป Admin
        </Link>
        <div className="flex items-center gap-3">
          <Link href="/admin/acls/qa-deep" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
            <ArrowLeft className="h-4 w-4" /> เพิ่มคำถาม
          </Link>
          <Link href="/acls/qa-deep" target="_blank" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
            <ExternalLink className="h-4 w-4" /> ดูหน้า
          </Link>
        </div>
      </div>

      <div>
        <h1 className="text-2xl font-bold">Admin — จัดเก็บ Q&A ที่โพสต์แล้ว</h1>
        <p className="text-muted-foreground mt-1">แก้ไขคำถาม-คำตอบ จัดหมวด เรียงลำดับ และลบ</p>
      </div>

      <div className="border rounded-md p-4 space-y-3">
        <div className="text-xs font-bold text-blue-600 uppercase inline-flex items-center gap-1.5">
          <Filter className="h-3 w-3" /> ตัวกรองหมวด
        </div>
        <div className="relative">
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="w-full pl-3 pr-10 py-2 bg-background border rounded-md text-sm appearance-none"
          >
            <option value={ALL_FILTER}>ทั้งหมด ({postedItems.length})</option>
            <option value={UNCATEGORIZED_FILTER}>📌 ยังไม่จัดหมวด ({counts.uncategorized})</option>
            {chapters.map((c) => (
              <option key={c.id} value={c.id}>
                {c.icon ? `${c.icon} ` : ""}
                {c.title} ({counts.byChapter.get(c.id) ?? 0})
              </option>
            ))}
          </select>
          <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
        </div>
      </div>

      <div className="space-y-3">
        <h2 className="text-base font-bold inline-flex items-center gap-1.5">
          <ListChecks className="h-4 w-4 text-muted-foreground" />
          รายการที่โพสต์แล้ว ({filteredItems.length})
        </h2>

        {loading ? (
          <div className="flex items-center justify-center py-8">
            <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
          </div>
        ) : filteredItems.length === 0 ? (
          <div className="border rounded-md text-center text-sm text-muted-foreground py-6">
            {filter === ALL_FILTER ? 'ยังไม่มี Q&A ที่โพสต์ — เพิ่มคำถามใหม่ในหน้า "เพิ่มคำถาม"' : "ยังไม่มี Q&A ที่โพสต์ในหมวดนี้"}
          </div>
        ) : (
          <div className="space-y-3">
            {filteredItems.map((item) => (
              <QaDeepItemEditor key={item.id} item={item} allItems={postedItems} chapters={chapters} onChange={load} />
            ))}
          </div>
        )}
      </div>

      <p className="text-xs text-muted-foreground text-center pt-2">
        เนื้อหาจะ refresh ในแอป end-user ภายใน 10 นาที (revalidate)
      </p>
    </div>
  );
}
