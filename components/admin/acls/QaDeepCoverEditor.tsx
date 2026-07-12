"use client";

import { useEffect, useRef, useState } from "react";
import { Upload, Save, Image as ImageIcon, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { apiGet, apiPatch, apiUpload, errMsg } from "./api-client";

interface QaDeepPage {
  id: string;
  title: string;
  intro: string | null;
  cover_image_url: string | null;
}

// Cover image + intro text editor for the Q&A ACLS Deep landing page
// (singleton acls_qa_deep_page row).
// Ported from acls-emr's src/components/admin/QADeepCoverEditor.jsx.
export function QaDeepCoverEditor({ onChange }: { onChange: () => void }) {
  const [row, setRow] = useState<QaDeepPage | null>(null);
  const [title, setTitle] = useState("");
  const [intro, setIntro] = useState("");
  const [uploading, setUploading] = useState(false);
  const [saving, setSaving] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const load = async () => {
    try {
      const { page } = await apiGet<{ page: QaDeepPage }>("/api/admin/acls/qa-deep/page-settings");
      setRow(page);
      setTitle(page.title || "");
      setIntro(page.intro || "");
    } catch (err) {
      alert("โหลดไม่สำเร็จ: " + errMsg(err));
    }
  };

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !row) return;
    setUploading(true);
    try {
      const form = new FormData();
      form.append("file", file);
      const { url } = await apiUpload<{ url: string }>("/api/admin/acls/qa-deep/cover-upload", form);
      await apiPatch("/api/admin/acls/qa-deep/page-settings", { id: row.id, cover_image_url: url });
      await load();
      onChange();
    } catch (err) {
      alert("อัปโหลดไม่สำเร็จ: " + errMsg(err));
    }
    setUploading(false);
    e.target.value = "";
  };

  const handleClearCover = async () => {
    if (!row) return;
    if (!confirm("ลบรูปหน้าปก?")) return;
    try {
      await apiPatch("/api/admin/acls/qa-deep/page-settings", { id: row.id, cover_image_url: null });
      await load();
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
  };

  const handleSave = async () => {
    if (!row) return;
    setSaving(true);
    try {
      await apiPatch("/api/admin/acls/qa-deep/page-settings", { id: row.id, title, intro });
      await load();
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  if (!row) {
    return <div className="border rounded-md p-4 text-center text-sm text-muted-foreground">กำลังโหลด…</div>;
  }

  const dirty = title !== (row.title || "") || intro !== (row.intro || "");

  return (
    <div className="border rounded-md p-4 space-y-3">
      <div className="text-xs font-bold text-blue-600 uppercase inline-flex items-center gap-1.5">
        <ImageIcon className="h-3 w-3" /> หน้าปกและข้อความนำ
      </div>

      {row.cover_image_url ? (
        <div className="relative">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={row.cover_image_url} alt={row.title || "cover"} className="w-full max-h-48 object-cover border rounded-md" />
          <Button
            size="icon-sm"
            variant="outline"
            className="absolute top-2 right-2 text-destructive"
            onClick={handleClearCover}
            title="ลบรูปหน้าปก"
          >
            <X className="h-3.5 w-3.5" />
          </Button>
        </div>
      ) : (
        <div className="w-full py-6 text-center border border-dashed rounded-md text-sm text-muted-foreground">
          ยังไม่มีรูปหน้าปก
        </div>
      )}

      <Button variant="ghost" className="w-full" disabled={uploading} onClick={() => fileInputRef.current?.click()}>
        <Upload className="h-3 w-3 mr-1" />
        {uploading ? "กำลังอัปโหลด…" : row.cover_image_url ? "เปลี่ยนรูปหน้าปก" : "อัปโหลดหน้าปก"}
      </Button>
      <input ref={fileInputRef} type="file" accept="image/*" onChange={handleUpload} disabled={uploading} className="hidden" />

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">ชื่อหน้า</span>
        <Input value={title} onChange={(e) => setTitle(e.target.value)} />
      </label>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">คำอธิบายนำ (intro)</span>
        <Textarea value={intro} onChange={(e) => setIntro(e.target.value)} rows={3} />
      </label>

      <Button size="sm" disabled={!dirty || saving} onClick={handleSave}>
        <Save className="h-3 w-3 mr-1" /> {saving ? "กำลังบันทึก…" : "บันทึก"}
      </Button>
    </div>
  );
}
