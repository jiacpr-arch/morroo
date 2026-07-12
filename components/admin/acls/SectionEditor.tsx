"use client";

import { useState } from "react";
import { Trash2, Save, Plus, ChevronUp, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { ImageManager, type AclsImage } from "./ImageManager";
import { QaEditor, type AclsQaItem } from "./QaEditor";
import { apiPatch, apiDelete, apiPost, errMsg } from "./api-client";

export interface AclsSection {
  id: string;
  heading: string | null;
  body: string | null;
  sort_order: number;
  images?: AclsImage[];
  qa?: AclsQaItem[];
}

// One section within a chapter (heading + body + images + nested Q&A).
// Ported from acls-emr's src/components/admin/SectionEditor.jsx.
export function SectionEditor({
  section,
  allSections,
  onChange,
}: {
  section: AclsSection;
  allSections: AclsSection[];
  onChange: () => void;
}) {
  const [heading, setHeading] = useState(section.heading || "");
  const [body, setBody] = useState(section.body || "");
  const [saving, setSaving] = useState(false);
  const dirty = heading !== (section.heading || "") || body !== (section.body || "");

  const handleSave = async () => {
    setSaving(true);
    try {
      await apiPatch(`/api/admin/acls/sections/${section.id}`, { heading, body });
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  const handleDelete = async () => {
    if (!confirm("ลบหัวข้อนี้ทั้งหมด (รวม Q&A และรูป)?")) return;
    try {
      await apiDelete(`/api/admin/acls/sections/${section.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
  };

  const handleMove = async (direction: "up" | "down") => {
    const idx = allSections.findIndex((s) => s.id === section.id);
    if (idx < 0) return;
    const swapIdx = direction === "up" ? idx - 1 : idx + 1;
    if (swapIdx < 0 || swapIdx >= allSections.length) return;
    const a = allSections[idx];
    const b = allSections[swapIdx];
    try {
      await apiPatch(`/api/admin/acls/sections/${a.id}`, { sort_order: b.sort_order });
      await apiPatch(`/api/admin/acls/sections/${b.id}`, { sort_order: a.sort_order });
      onChange();
    } catch (err) {
      alert("ย้ายไม่สำเร็จ: " + errMsg(err));
    }
  };

  const handleAddQa = async () => {
    try {
      await apiPost("/api/admin/acls/qa-items", { sectionId: section.id });
      onChange();
    } catch (err) {
      alert("เพิ่มไม่สำเร็จ: " + errMsg(err));
    }
  };

  const idx = allSections.findIndex((s) => s.id === section.id);
  const isFirst = idx === 0;
  const isLast = idx === allSections.length - 1;

  return (
    <div className="border rounded-md bg-muted/20 p-3 space-y-3">
      <div className="flex items-center justify-between gap-2">
        <span className="text-xs font-bold text-muted-foreground uppercase">หัวข้อย่อย #{idx + 1}</span>
        <div className="flex gap-1">
          <Button size="icon-sm" variant="ghost" disabled={isFirst} onClick={() => handleMove("up")}>
            <ChevronUp className="h-3.5 w-3.5" />
          </Button>
          <Button size="icon-sm" variant="ghost" disabled={isLast} onClick={() => handleMove("down")}>
            <ChevronDown className="h-3.5 w-3.5" />
          </Button>
          <Button size="icon-sm" variant="ghost" className="text-destructive" onClick={handleDelete}>
            <Trash2 className="h-3 w-3" />
          </Button>
        </div>
      </div>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">หัวข้อ (heading)</span>
        <Input
          value={heading}
          onChange={(e) => setHeading(e.target.value)}
          placeholder="(ปล่อยว่างได้ ถ้าเป็นหัวข้อ Q&A ล้วน)"
        />
      </label>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">เนื้อหา (body — plain text)</span>
        <Textarea value={body} onChange={(e) => setBody(e.target.value)} rows={4} placeholder="(ปล่อยว่างได้)" />
      </label>

      <Button size="sm" disabled={!dirty || saving} onClick={handleSave}>
        <Save className="h-3 w-3 mr-1" /> {saving ? "กำลังบันทึก…" : "บันทึกหัวข้อ"}
      </Button>

      <div className="pt-2 border-t">
        <ImageManager parentType="section" parentId={section.id} images={section.images || []} onChange={onChange} />
      </div>

      <div className="pt-2 border-t space-y-2">
        <div className="flex items-center justify-between">
          <span className="text-sm font-bold text-muted-foreground">Q&A ({section.qa?.length || 0})</span>
          <Button size="sm" variant="ghost" onClick={handleAddQa}>
            <Plus className="h-3 w-3 mr-1" /> เพิ่ม Q&A
          </Button>
        </div>
        {section.qa?.map((qa) => (
          <QaEditor key={qa.id} qa={qa} onChange={onChange} />
        ))}
      </div>
    </div>
  );
}
