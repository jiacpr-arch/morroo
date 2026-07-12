"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, ChevronDown, Plus, Archive, ExternalLink, FilePlus2, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { QaDeepCoverEditor } from "@/components/admin/acls/QaDeepCoverEditor";
import { QaDeepItemEditor, type QaDeepItem, type QaDeepChapterOption } from "@/components/admin/acls/QaDeepItemEditor";
import { apiGet, apiPost, errMsg } from "@/components/admin/acls/api-client";

// Q&A ACLS Deep — "add new" admin page: cover/intro editor + create-new-item
// form + drafts (items whose question is still blank) inline for immediate
// filling. Already-posted items live on /admin/acls/qa-deep/posted.
// Ported from acls-emr's src/pages/AdminQADeep.jsx.
export default function AdminQaDeepPage() {
  const status = useAdminGate();
  const [items, setItems] = useState<QaDeepItem[]>([]);
  const [chapters, setChapters] = useState<QaDeepChapterOption[]>([]);
  const [loading, setLoading] = useState(true);
  const [creating, setCreating] = useState(false);
  const [newItemChapter, setNewItemChapter] = useState("");

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

  const draftItems = useMemo(() => items.filter((i) => !(i.question || "").trim()), [items]);
  const postedCount = items.length - draftItems.length;

  const handleAdd = async () => {
    setCreating(true);
    try {
      await apiPost("/api/admin/acls/qa-deep", { chapterId: newItemChapter || null });
      await load();
    } catch (err) {
      alert("เพิ่มไม่สำเร็จ: " + errMsg(err));
    }
    setCreating(false);
  };

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ChevronLeft className="h-4 w-4" /> กลับไป Admin
        </Link>
        <Link href="/acls/qa-deep" target="_blank" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ExternalLink className="h-4 w-4" /> ดูหน้า
        </Link>
      </div>

      <div>
        <h1 className="text-2xl font-bold">Admin — เพิ่ม Q&A ACLS เชิงลึก</h1>
        <p className="text-muted-foreground mt-1">เพิ่มคำถาม-คำตอบใหม่ · รายการที่โพสต์แล้วอยู่ในหน้า "จัดเก็บ"</p>
      </div>

      <QaDeepCoverEditor onChange={load} />

      <div className="border-2 border-blue-500 rounded-md p-4 space-y-3">
        <div className="flex items-center justify-between gap-2">
          <div className="text-xs font-bold text-blue-600 uppercase inline-flex items-center gap-1.5">
            <FilePlus2 className="h-3 w-3" /> เพิ่มคำถามใหม่
          </div>
          <Button size="sm" disabled={creating} onClick={handleAdd}>
            <Plus className="h-3.5 w-3.5 mr-1" /> {creating ? "กำลังเพิ่ม…" : "เพิ่ม Q&A"}
          </Button>
        </div>

        <label className="block">
          <span className="text-sm font-bold text-muted-foreground mb-1 block">
            หมวดสำหรับ Q&A ที่จะเพิ่มใหม่ <span className="font-normal text-muted-foreground">(เลือกก่อนกด "เพิ่ม Q&A")</span>
          </span>
          <div className="relative">
            <select
              value={newItemChapter}
              onChange={(e) => setNewItemChapter(e.target.value)}
              className="w-full pl-3 pr-10 py-2 bg-background border rounded-md text-sm appearance-none"
            >
              <option value="">— ยังไม่จัดหมวด —</option>
              {chapters.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.icon ? `${c.icon} ` : ""}
                  {c.title}
                </option>
              ))}
            </select>
            <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
          </div>
        </label>

        {loading ? (
          <div className="flex items-center justify-center py-4">
            <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
          </div>
        ) : draftItems.length > 0 ? (
          <div className="space-y-3">
            <p className="text-xs text-muted-foreground">
              ฉบับร่างที่ยังไม่ได้กรอกคำถาม — กรอกคำถาม–คำตอบแล้วกด "บันทึก" รายการจะย้ายไปอยู่ในหน้า "จัดเก็บ"
            </p>
            {draftItems.map((item) => (
              <QaDeepItemEditor key={item.id} item={item} allItems={items} chapters={chapters} onChange={load} />
            ))}
          </div>
        ) : (
          <p className="text-xs text-muted-foreground">
            กด "เพิ่ม Q&A" เพื่อสร้างคำถามใหม่ — รายการใหม่จะปรากฏที่นี่ให้กรอกทันที
          </p>
        )}
      </div>

      <Link href="/admin/acls/qa-deep/posted" className="block">
        <div className="border rounded-md p-4 flex items-center justify-between gap-2 hover:border-blue-400 transition-colors">
          <div className="inline-flex items-center gap-2">
            <div className="w-9 h-9 rounded-md bg-blue-100 text-blue-600 flex items-center justify-center shrink-0">
              <Archive className="h-4 w-4" />
            </div>
            <div>
              <div className="text-sm font-bold">จัดเก็บ Q&A ที่โพสต์แล้ว</div>
              <div className="text-xs text-muted-foreground">
                {loading ? "กำลังนับ…" : `${postedCount} รายการ`} — แก้ไข จัดหมวด เรียงลำดับ และลบ
              </div>
            </div>
          </div>
          <ExternalLink className="h-4 w-4 text-muted-foreground shrink-0" />
        </div>
      </Link>

      <p className="text-xs text-muted-foreground text-center pt-2">
        เนื้อหาจะ refresh ในแอป end-user ภายใน 10 นาที (revalidate)
      </p>
    </div>
  );
}
