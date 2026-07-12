"use client";

import { useState } from "react";
import { Plus, Trash2, Video, Play } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { getYouTubeId } from "@/lib/courses/youtube";
import { apiPost, apiPatch, apiDelete, errMsg } from "./api-client";

export interface PreCourseVideo {
  id: string;
  src: string;
  alt: string | null; // orientation
  caption: string | null; // label
}

// Manages YouTube video links attached to a pre-course read step (stored as
// acls_images rows with parent_type='precourse-video').
// Ported from acls-emr's src/components/admin/VideoManager.jsx.
export function VideoManager({
  stepId,
  videos,
  onChange,
}: {
  stepId: string;
  videos: PreCourseVideo[];
  onChange: () => void;
}) {
  const [url, setUrl] = useState("");
  const [orientation, setOrientation] = useState<"portrait" | "landscape">("portrait");
  const [label, setLabel] = useState("");
  const [adding, setAdding] = useState(false);

  const validId = getYouTubeId(url.trim());

  const handleAdd = async () => {
    const trimmed = url.trim();
    if (!trimmed) return;
    if (!validId) {
      alert("ลิงก์ YouTube ไม่ถูกต้อง — รองรับ youtu.be/, watch?v= และ shorts/");
      return;
    }
    setAdding(true);
    try {
      await apiPost("/api/admin/acls/images", {
        parentType: "precourse-video",
        parentId: stepId,
        src: trimmed,
        alt: orientation,
        caption: label.trim() || "ดูคลิป",
      });
      setUrl("");
      setLabel("");
      setOrientation("portrait");
      onChange();
    } catch (err) {
      alert("เพิ่มวิดีโอไม่สำเร็จ: " + errMsg(err));
    }
    setAdding(false);
  };

  return (
    <div className="space-y-2">
      <span className="text-xs font-bold text-muted-foreground inline-flex items-center gap-1">
        <Video className="h-3 w-3" /> วิดีโอประกอบ ({videos.length})
      </span>

      <div className="border rounded-md bg-muted/30 p-2 space-y-1.5">
        <Input
          type="url"
          value={url}
          onChange={(e) => setUrl(e.target.value)}
          placeholder="ลิงก์ YouTube (youtu.be/ · watch?v= · shorts/)"
          className="text-xs"
        />
        <Input
          value={label}
          onChange={(e) => setLabel(e.target.value)}
          placeholder="ชื่อคลิป (ไม่ใส่ได้ → 'ดูคลิป')"
          className="text-xs"
        />
        <div className="flex items-center gap-2">
          <div className="inline-flex gap-1">
            <OrientationButton active={orientation === "portrait"} onClick={() => setOrientation("portrait")} label="แนวตั้ง 9:16" />
            <OrientationButton active={orientation === "landscape"} onClick={() => setOrientation("landscape")} label="แนวนอน 16:9" />
          </div>
          <div className="flex-1" />
          <Button size="sm" disabled={adding || !url.trim()} onClick={handleAdd}>
            <Plus className="h-3 w-3 mr-1" /> {adding ? "กำลังเพิ่ม…" : "เพิ่มวิดีโอ"}
          </Button>
        </div>
      </div>

      {videos.length > 0 && (
        <div className="space-y-2">
          {videos.map((v) => (
            <VideoRow key={v.id} video={v} onChange={onChange} />
          ))}
        </div>
      )}
    </div>
  );
}

function OrientationButton({ active, onClick, label }: { active: boolean; onClick: () => void; label: string }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`text-[10px] font-bold px-2 py-1 border rounded transition-colors ${
        active ? "border-blue-500 bg-blue-50 text-blue-600" : "border-border bg-background text-muted-foreground"
      }`}
    >
      {label}
    </button>
  );
}

function VideoRow({ video, onChange }: { video: PreCourseVideo; onChange: () => void }) {
  const [label, setLabel] = useState(video.caption || "");
  const [orientation, setOrientation] = useState<"portrait" | "landscape">(
    video.alt === "landscape" ? "landscape" : "portrait",
  );
  const [busy, setBusy] = useState(false);
  const dirty = label !== (video.caption || "") || orientation !== (video.alt || "portrait");
  const ytId = getYouTubeId(video.src);
  const thumb = ytId ? `https://i.ytimg.com/vi/${ytId}/hqdefault.jpg` : null;

  const handleSave = async () => {
    setBusy(true);
    try {
      await apiPatch(`/api/admin/acls/images/${video.id}`, { caption: label, alt: orientation });
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setBusy(false);
  };

  const handleDelete = async () => {
    if (!confirm("ลบวิดีโอนี้?")) return;
    setBusy(true);
    try {
      await apiDelete(`/api/admin/acls/images/${video.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
    setBusy(false);
  };

  return (
    <div className="border rounded-md bg-muted/30 p-2 flex gap-2">
      <div className="w-16 h-16 shrink-0 bg-muted rounded flex items-center justify-center overflow-hidden">
        {thumb ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={thumb} alt="" className="w-full h-full object-cover" />
        ) : (
          <Play className="h-4 w-4 text-muted-foreground" />
        )}
      </div>
      <div className="flex-1 min-w-0 space-y-1">
        <Input value={label} onChange={(e) => setLabel(e.target.value)} placeholder="ชื่อคลิป" className="text-xs" />
        <div className="flex items-center gap-1">
          <OrientationButton active={orientation === "portrait"} onClick={() => setOrientation("portrait")} label="9:16" />
          <OrientationButton active={orientation === "landscape"} onClick={() => setOrientation("landscape")} label="16:9" />
          <div className="flex-1" />
          <Button size="sm" disabled={!dirty || busy} onClick={handleSave}>
            บันทึก
          </Button>
          <Button size="sm" variant="ghost" className="text-destructive" disabled={busy} onClick={handleDelete}>
            <Trash2 className="h-3 w-3" />
          </Button>
        </div>
      </div>
    </div>
  );
}
