"use client";

import { useRef, useState } from "react";
import { Upload, Trash2, Image as ImageIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { apiUpload, apiPatch, apiDelete, errMsg } from "./api-client";

export interface AclsImage {
  id: string;
  src: string;
  alt: string | null;
  caption: string | null;
}

// Generic image manager for a section / qa item / pre-course step.
// Ported from acls-emr's src/components/admin/ImageManager.jsx.
export function ImageManager({
  parentType,
  parentId,
  images,
  onChange,
}: {
  parentType: "section" | "qa" | "precourse-step";
  parentId: string;
  images: AclsImage[];
  onChange: () => void;
}) {
  const [uploading, setUploading] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploading(true);
    try {
      const form = new FormData();
      form.append("file", file);
      form.append("parentType", parentType);
      form.append("parentId", parentId);
      await apiUpload("/api/admin/acls/images", form);
      onChange();
    } catch (err) {
      alert("อัปโหลดไม่สำเร็จ: " + errMsg(err));
    }
    setUploading(false);
    e.target.value = "";
  };

  const handleSaveMeta = async (img: AclsImage, patch: { alt: string; caption: string }) => {
    setBusyId(img.id);
    try {
      await apiPatch(`/api/admin/acls/images/${img.id}`, patch);
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setBusyId(null);
  };

  const handleDelete = async (img: AclsImage) => {
    if (!confirm("ลบรูปนี้?")) return;
    setBusyId(img.id);
    try {
      await apiDelete(`/api/admin/acls/images/${img.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
    setBusyId(null);
  };

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <span className="text-xs font-bold text-muted-foreground inline-flex items-center gap-1">
          <ImageIcon className="h-3 w-3" /> รูปประกอบ ({images.length})
        </span>
        <Button variant="ghost" size="sm" disabled={uploading} onClick={() => fileInputRef.current?.click()}>
          <Upload className="h-3 w-3 mr-1" />
          {uploading ? "อัปโหลด…" : "เพิ่มรูป"}
        </Button>
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          onChange={handleUpload}
          disabled={uploading}
          className="hidden"
        />
      </div>

      {images.length > 0 && (
        <div className="space-y-2">
          {images.map((img) => (
            <ImageRow
              key={img.id}
              img={img}
              busy={busyId === img.id}
              onSave={(patch) => handleSaveMeta(img, patch)}
              onDelete={() => handleDelete(img)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

function ImageRow({
  img,
  busy,
  onSave,
  onDelete,
}: {
  img: AclsImage;
  busy: boolean;
  onSave: (patch: { alt: string; caption: string }) => void;
  onDelete: () => void;
}) {
  const [alt, setAlt] = useState(img.alt || "");
  const [caption, setCaption] = useState(img.caption || "");
  const dirty = alt !== (img.alt || "") || caption !== (img.caption || "");

  return (
    <div className="border rounded-md bg-muted/30 p-2 flex gap-2">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src={img.src} alt={img.alt || ""} className="w-20 h-20 object-cover rounded shrink-0" />
      <div className="flex-1 min-w-0 space-y-1">
        <Input value={alt} onChange={(e) => setAlt(e.target.value)} placeholder="alt text" className="text-xs" />
        <Input value={caption} onChange={(e) => setCaption(e.target.value)} placeholder="caption" className="text-xs" />
        <div className="flex gap-1">
          <Button size="sm" disabled={!dirty || busy} onClick={() => onSave({ alt, caption })}>
            บันทึก
          </Button>
          <Button size="sm" variant="ghost" className="text-destructive" disabled={busy} onClick={onDelete}>
            <Trash2 className="h-3 w-3" />
          </Button>
        </div>
      </div>
    </div>
  );
}
