"use client";

import { useEffect, useRef, useState } from "react";
import {
  Upload, Trash2, Image as ImageIcon, ChevronUp, ChevronDown,
  Save, HelpCircle, Layers, X, ExternalLink,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { apiPatch, apiDelete, apiUpload, errMsg } from "./api-client";

// หน้า Q&A รายข้อฝั่งผู้อ่าน
const PUBLIC_QA_URL_BASE = "https://www.morroo.com/acls/qa-deep/q";

export interface QaDeepChapterOption {
  id: string;
  title: string;
  icon: string | null;
}

export interface QaDeepImage {
  id: string;
  image_type: "cover" | "infographic";
  src: string;
  alt: string | null;
  caption: string | null;
}

export interface QaDeepItem {
  id: string;
  question: string;
  answer: string;
  chapter_id: string | null;
  sort_order: number;
  images?: QaDeepImage[];
}

interface StagedImage {
  tempId: string;
  file: File;
  type: "cover" | "infographic";
  previewUrl: string;
}

// One Q&A Deep item editor: question/answer, chapter assignment, cover +
// infographic images (staged locally, uploaded on save), reorder, delete.
// Ported from acls-emr's src/components/admin/QADeepItemEditor.jsx.
// NOTE: the source's AI "จัดหมวดอัตโนมัติ" (auto-classify) button called
// acls-emr's /api/qa-deep/classify (DeepSeek) — that endpoint lives outside
// this phase's scope (app/api/qa-deep/**, not app/api/admin/acls/**) and
// hasn't been ported to morroo yet, so it's omitted here; chapter assignment
// is manual via the dropdown below.
export function QaDeepItemEditor({
  item,
  allItems,
  chapters,
  onChange,
}: {
  item: QaDeepItem;
  allItems: QaDeepItem[];
  chapters: QaDeepChapterOption[];
  onChange: () => void;
}) {
  const [question, setQuestion] = useState(item.question || "");
  const [answer, setAnswer] = useState(item.answer || "");
  const [chapterId, setChapterId] = useState(item.chapter_id || "");
  const [saving, setSaving] = useState(false);
  const [staged, setStaged] = useState<StagedImage[]>([]);

  useEffect(() => {
    setQuestion(item.question || "");
    setAnswer(item.answer || "");
    setChapterId(item.chapter_id || "");
    setStaged((prev) => {
      prev.forEach((s) => URL.revokeObjectURL(s.previewUrl));
      return [];
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [item.id]);

  const dirty =
    question !== (item.question || "") ||
    answer !== (item.answer || "") ||
    chapterId !== (item.chapter_id || "") ||
    staged.length > 0;

  const stageImage = (file: File, type: "cover" | "infographic") => {
    setStaged((prev) => [
      ...prev,
      { tempId: crypto.randomUUID(), file, type, previewUrl: URL.createObjectURL(file) },
    ]);
  };

  const unstageImage = (tempId: string) => {
    setStaged((prev) => {
      const found = prev.find((s) => s.tempId === tempId);
      if (found) URL.revokeObjectURL(found.previewUrl);
      return prev.filter((s) => s.tempId !== tempId);
    });
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      await apiPatch(`/api/admin/acls/qa-deep/${item.id}`, {
        question,
        answer,
        chapter_id: chapterId || null,
      });
      for (const s of staged) {
        const form = new FormData();
        form.append("file", s.file);
        form.append("imageType", s.type);
        await apiUpload(`/api/admin/acls/qa-deep/${item.id}/images`, form);
      }
      staged.forEach((s) => URL.revokeObjectURL(s.previewUrl));
      setStaged([]);
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  const handleDelete = async () => {
    if (!confirm("ลบ Q&A นี้พร้อมรูปทั้งหมด?")) return;
    try {
      await apiDelete(`/api/admin/acls/qa-deep/${item.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
  };

  const handleMove = async (direction: "up" | "down") => {
    const idx = allItems.findIndex((i) => i.id === item.id);
    if (idx < 0) return;
    const swapIdx = direction === "up" ? idx - 1 : idx + 1;
    if (swapIdx < 0 || swapIdx >= allItems.length) return;
    const a = allItems[idx];
    const b = allItems[swapIdx];
    try {
      await apiPatch(`/api/admin/acls/qa-deep/${a.id}`, { sort_order: b.sort_order });
      await apiPatch(`/api/admin/acls/qa-deep/${b.id}`, { sort_order: a.sort_order });
      onChange();
    } catch (err) {
      alert("ย้ายไม่สำเร็จ: " + errMsg(err));
    }
  };

  const covers = (item.images || []).filter((i) => i.image_type === "cover");
  const infos = (item.images || []).filter((i) => i.image_type === "infographic");
  const stagedCovers = staged.filter((s) => s.type === "cover");
  const stagedInfos = staged.filter((s) => s.type === "infographic");

  return (
    <div className="border rounded-md p-3 space-y-3">
      <div className="flex items-center gap-1">
        <div className="w-7 h-7 inline-flex items-center justify-center bg-blue-100 text-blue-600 rounded shrink-0">
          <HelpCircle className="h-3.5 w-3.5" />
        </div>
        <span className="text-xs font-bold text-muted-foreground uppercase">#{item.sort_order}</span>
        <div className="flex-1" />
        {(item.question || "").trim() && (
          <a
            href={`${PUBLIC_QA_URL_BASE}/${item.id}`}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1 text-xs text-blue-600 hover:underline px-2"
            title="เปิดหน้าที่ผู้อ่านเห็นบนเว็บหมอรู้"
          >
            <ExternalLink className="h-3.5 w-3.5" /> ดูบนเว็บ
          </a>
        )}
        <Button size="icon-sm" variant="ghost" title="ย้ายขึ้น" onClick={() => handleMove("up")}>
          <ChevronUp className="h-3.5 w-3.5" />
        </Button>
        <Button size="icon-sm" variant="ghost" title="ย้ายลง" onClick={() => handleMove("down")}>
          <ChevronDown className="h-3.5 w-3.5" />
        </Button>
        <Button size="icon-sm" variant="ghost" className="text-destructive" title="ลบ" onClick={handleDelete}>
          <Trash2 className="h-3.5 w-3.5" />
        </Button>
      </div>

      <div className="block">
        <div className="flex items-center justify-between gap-2 mb-1">
          <span className="text-xs font-bold text-muted-foreground inline-flex items-center gap-1.5">
            <Layers className="h-3 w-3" /> หมวด (บทใน ALS)
          </span>
        </div>
        <select
          value={chapterId}
          onChange={(e) => setChapterId(e.target.value)}
          className="w-full px-3 py-2 bg-background border rounded-md text-sm"
        >
          <option value="">— ยังไม่จัดหมวด —</option>
          {chapters.map((c) => (
            <option key={c.id} value={c.id}>
              {c.icon ? `${c.icon} ` : ""}
              {c.title}
            </option>
          ))}
        </select>
      </div>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">คำถาม</span>
        <Textarea value={question} onChange={(e) => setQuestion(e.target.value)} rows={2} placeholder="พิมพ์คำถาม…" />
      </label>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">
          คำตอบ <span className="font-normal">(รองรับ Markdown: **bold**, ##, list, ตาราง, &gt; blockquote)</span>
        </span>
        <Textarea
          value={answer}
          onChange={(e) => setAnswer(e.target.value)}
          rows={6}
          placeholder="พิมพ์คำตอบ (Markdown)…"
          className="font-mono text-xs"
        />
      </label>

      <div className="border rounded-md bg-muted/20 p-3 space-y-3">
        <div className="text-xs font-bold text-blue-600 uppercase inline-flex items-center gap-1.5">
          <ImageIcon className="h-3 w-3" /> รูปภาพประกอบ Q&A นี้
        </div>

        <ImageGroup
          label="รูปหน้าปกของ Q&A"
          helper="แสดงเหนือคำถาม · แนะนำ 1 รูป"
          images={covers}
          staged={stagedCovers}
          imageType="cover"
          onStage={stageImage}
          onUnstage={unstageImage}
          onChange={onChange}
        />

        <div className="h-px bg-border" />

        <ImageGroup
          label="Infographic"
          helper="แสดงระหว่างคำถาม–คำตอบ · เพิ่มได้หลายรูป"
          images={infos}
          staged={stagedInfos}
          imageType="infographic"
          onStage={stageImage}
          onUnstage={unstageImage}
          onChange={onChange}
        />
      </div>

      <Button className="w-full" size="sm" disabled={!dirty || saving} onClick={handleSave}>
        <Save className="h-3 w-3 mr-1" />
        {saving ? "กำลังบันทึก…" : staged.length > 0 ? `บันทึกข้อความ + รูป (${staged.length})` : "บันทึก"}
      </Button>
    </div>
  );
}

function ImageGroup({
  label,
  helper,
  images,
  staged,
  imageType,
  onStage,
  onUnstage,
  onChange,
}: {
  label: string;
  helper: string;
  images: QaDeepImage[];
  staged: StagedImage[];
  imageType: "cover" | "infographic";
  onStage: (file: File, type: "cover" | "infographic") => void;
  onUnstage: (tempId: string) => void;
  onChange: () => void;
}) {
  const [busyId, setBusyId] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handlePick = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    files.forEach((f) => onStage(f, imageType));
    e.target.value = "";
  };

  const handleSaveMeta = async (img: QaDeepImage, patch: { alt: string; caption: string }) => {
    setBusyId(img.id);
    try {
      await apiPatch(`/api/admin/acls/qa-deep/images/${img.id}`, patch);
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setBusyId(null);
  };

  const handleDelete = async (img: QaDeepImage) => {
    if (!confirm("ลบรูปนี้?")) return;
    setBusyId(img.id);
    try {
      await apiDelete(`/api/admin/acls/qa-deep/images/${img.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
    setBusyId(null);
  };

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between gap-2">
        <div>
          <div className="text-xs font-bold text-muted-foreground inline-flex items-center gap-1">
            <ImageIcon className="h-3 w-3" /> {label}
            <span className="font-normal">({images.length + staged.length})</span>
          </div>
          <div className="text-[11px] text-muted-foreground">{helper}</div>
        </div>
        <Button size="sm" variant="ghost" className="shrink-0" onClick={() => fileInputRef.current?.click()}>
          <Upload className="h-3 w-3 mr-1" /> เลือกรูป
        </Button>
        <input ref={fileInputRef} type="file" accept="image/*" multiple onChange={handlePick} className="hidden" />
      </div>

      {staged.length > 0 && (
        <div className="space-y-2">
          {staged.map((s) => (
            <div key={s.tempId} className="border border-blue-300 bg-blue-50/50 p-2 flex gap-2 items-center rounded-md">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src={s.previewUrl} alt="" className="w-20 h-20 object-cover rounded shrink-0" />
              <div className="flex-1 min-w-0">
                <div className="text-xs font-bold text-blue-600">รอบันทึก</div>
                <div className="text-[11px] text-muted-foreground truncate">{s.file.name}</div>
                <div className="text-[11px] text-muted-foreground">กด "บันทึก" ด้านล่างเพื่ออัปโหลดพร้อมข้อความ</div>
              </div>
              <Button size="icon-sm" variant="ghost" className="text-destructive shrink-0" title="เอารูปนี้ออก" onClick={() => onUnstage(s.tempId)}>
                <X className="h-3.5 w-3.5" />
              </Button>
            </div>
          ))}
        </div>
      )}

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
  img: QaDeepImage;
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
