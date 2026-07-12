"use client";

import { useCallback, useEffect, useState } from "react";
import { Save, Plus, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { SectionEditor, type AclsSection } from "./SectionEditor";
import { apiGet, apiPatch, apiPost, errMsg } from "./api-client";

interface ChapterDetail {
  id: string;
  title: string;
  icon: string | null;
  sections: AclsSection[];
}

// Chapter detail editor: title/icon + list of sections.
// Ported from acls-emr's src/components/admin/ChapterEditor.jsx.
export function ChapterEditor({ chapterId }: { chapterId: string }) {
  const [chapter, setChapter] = useState<ChapterDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [title, setTitle] = useState("");
  const [icon, setIcon] = useState("");
  const [saving, setSaving] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    try {
      const { chapter } = await apiGet<{ chapter: ChapterDetail }>(`/api/admin/acls/chapters/${chapterId}`);
      setChapter(chapter);
      setTitle(chapter.title || "");
      setIcon(chapter.icon || "");
    } catch (err) {
      alert("โหลดไม่สำเร็จ: " + errMsg(err));
    }
    setLoading(false);
  }, [chapterId]);

  useEffect(() => {
    load();
  }, [load]);

  const handleSaveMeta = async () => {
    setSaving(true);
    try {
      await apiPatch(`/api/admin/acls/chapters/${chapterId}`, { title, icon });
      await load();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  const handleAddSection = async () => {
    try {
      await apiPost("/api/admin/acls/sections", { chapterId });
      await load();
    } catch (err) {
      alert("เพิ่มไม่สำเร็จ: " + errMsg(err));
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-8">
        <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
      </div>
    );
  }
  if (!chapter) return null;

  const metaDirty = title !== (chapter.title || "") || icon !== (chapter.icon || "");

  return (
    <div className="space-y-3">
      <div className="border rounded-md p-3 space-y-2">
        <div className="grid grid-cols-[80px_1fr] gap-2">
          <label>
            <span className="text-xs font-bold text-muted-foreground mb-1 block">Icon</span>
            <Input value={icon} onChange={(e) => setIcon(e.target.value)} placeholder="📚" className="text-center" />
          </label>
          <label>
            <span className="text-xs font-bold text-muted-foreground mb-1 block">ชื่อบท</span>
            <Input value={title} onChange={(e) => setTitle(e.target.value)} />
          </label>
        </div>
        <Button size="sm" disabled={!metaDirty || saving} onClick={handleSaveMeta}>
          <Save className="h-3 w-3 mr-1" /> {saving ? "กำลังบันทึก…" : "บันทึกชื่อบท"}
        </Button>
      </div>

      <div className="space-y-2">
        {chapter.sections.map((s) => (
          <SectionEditor key={s.id} section={s} allSections={chapter.sections} onChange={load} />
        ))}
      </div>

      <Button variant="ghost" className="w-full" onClick={handleAddSection}>
        <Plus className="h-4 w-4 mr-1" /> เพิ่มหัวข้อย่อย
      </Button>
    </div>
  );
}
