"use client";

import { useState } from "react";
import { Trash2, Save } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { ImageManager, type AclsImage } from "./ImageManager";
import { apiPatch, apiDelete, errMsg } from "./api-client";

export interface AclsQaItem {
  id: string;
  q: string;
  a: string | null;
  sort_order: number;
  images?: AclsImage[];
}

// One Q&A pair within a section. Ported from acls-emr's
// src/components/admin/QaEditor.jsx.
export function QaEditor({ qa, onChange }: { qa: AclsQaItem; onChange: () => void }) {
  const [q, setQ] = useState(qa.q || "");
  const [a, setA] = useState(qa.a || "");
  const [saving, setSaving] = useState(false);
  const dirty = q !== (qa.q || "") || a !== (qa.a || "");

  const handleSave = async () => {
    setSaving(true);
    try {
      await apiPatch(`/api/admin/acls/qa-items/${qa.id}`, { q, a });
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  const handleDelete = async () => {
    if (!confirm("ลบ Q&A นี้?")) return;
    try {
      await apiDelete(`/api/admin/acls/qa-items/${qa.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
  };

  return (
    <div className="border rounded-md bg-blue-50/40 p-3 space-y-2">
      <div className="flex items-center justify-between">
        <span className="text-xs font-bold text-blue-600 uppercase">Q&A</span>
        <Button size="sm" variant="ghost" className="text-destructive" onClick={handleDelete}>
          <Trash2 className="h-3 w-3 mr-1" /> ลบ
        </Button>
      </div>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">คำถาม</span>
        <Input value={q} onChange={(e) => setQ(e.target.value)} />
      </label>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">คำตอบ (Markdown)</span>
        <Textarea value={a} onChange={(e) => setA(e.target.value)} rows={10} className="font-mono text-xs" />
      </label>

      <Button size="sm" disabled={!dirty || saving} onClick={handleSave}>
        <Save className="h-3 w-3 mr-1" /> {saving ? "กำลังบันทึก…" : "บันทึก Q&A"}
      </Button>

      <div className="pt-2 border-t">
        <ImageManager parentType="qa" parentId={qa.id} images={qa.images || []} onChange={onChange} />
      </div>
    </div>
  );
}
