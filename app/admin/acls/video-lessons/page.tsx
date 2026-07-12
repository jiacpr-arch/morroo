"use client";

import { useCallback, useEffect, useState } from "react";
import Link from "next/link";
import { ChevronLeft, ChevronUp, ChevronDown, Pencil, Trash2, Plus, Video, Loader2, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import {
  VideoLessonEditor,
  blankVideoLessonForm,
  type VideoLessonForm,
} from "@/components/admin/acls/VideoLessonEditor";
import { apiGet, apiPost, apiPatch, apiDelete, errMsg } from "@/components/admin/acls/api-client";
import { VIDEO_TOPICS } from "@/lib/courses/video-topics";
import { getYouTubeId } from "@/lib/courses/youtube";

interface VideoLessonRow {
  id: string;
  topic: string;
  title: string;
  youtube_id: string;
  orientation: string;
  start_sec: number | null;
  end_sec: number | null;
  required: boolean;
  key_points: string;
  chapters: VideoLessonForm["chapters"];
  quiz: VideoLessonForm["quiz"];
  related_path: string | null;
  related_label: string | null;
  sort_order: number;
}

function rowToForm(item: VideoLessonRow): VideoLessonForm {
  return {
    id: item.id,
    topic: item.topic,
    title: item.title,
    youtubeId: item.youtube_id,
    orientation: item.orientation === "landscape" ? "landscape" : "portrait",
    startSec: item.start_sec ?? "",
    endSec: item.end_sec ?? "",
    required: item.required !== false,
    keyPoints: item.key_points || "",
    chapters: item.chapters || [],
    quiz: item.quiz || [],
    relatedPath: item.related_path || "",
    relatedLabel: item.related_label || "",
  };
}

// Video lessons (YouTube-based) admin — CRUD + reorder within topic.
// Ported from acls-emr's src/pages/AdminVideoLessons.jsx.
export default function AdminVideoLessonsPage() {
  const status = useAdminGate();
  const [items, setItems] = useState<VideoLessonRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [editing, setEditing] = useState<VideoLessonForm | null>(null);
  const [saving, setSaving] = useState(false);

  const reload = useCallback(async () => {
    setLoading(true);
    try {
      const { items } = await apiGet<{ items: VideoLessonRow[] }>("/api/admin/acls/video-lessons");
      setItems(items);
    } catch (err) {
      alert("โหลดไม่สำเร็จ: " + errMsg(err));
    }
    setLoading(false);
  }, []);

  useEffect(() => {
    if (status === "ok") reload();
  }, [status, reload]);

  const startCreate = (topic: string) => setEditing(blankVideoLessonForm(topic));
  const startEdit = (item: VideoLessonRow) => setEditing(rowToForm(item));

  const save = async () => {
    const f = editing;
    if (!f) return;
    const ytId = getYouTubeId(f.youtubeId) || (/^[\w-]{11}$/.test(f.youtubeId.trim()) ? f.youtubeId.trim() : "");
    if (!f.title.trim()) return alert("กรุณาใส่ชื่อคลิป");
    if (!ytId) return alert("ลิงก์ YouTube ไม่ถูกต้อง (ต้องเป็นลิงก์ youtu.be / youtube.com หรือ video id 11 ตัว)");
    setSaving(true);
    try {
      const payload = { ...f, youtubeId: ytId, chapters: f.chapters.map((c) => ({ ...c, t: Number(c.t) || 0 })) };
      if (f.id) await apiPatch(`/api/admin/acls/video-lessons/${f.id}`, payload);
      else await apiPost("/api/admin/acls/video-lessons", payload);
      setEditing(null);
      await reload();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setSaving(false);
  };

  const remove = async (item: VideoLessonRow) => {
    if (!confirm(`ลบคลิป "${item.title}"?`)) return;
    try {
      await apiDelete(`/api/admin/acls/video-lessons/${item.id}`);
      await reload();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
  };

  const move = async (clips: VideoLessonRow[], index: number, dir: 1 | -1) => {
    const other = clips[index + dir];
    if (!other) return;
    const a = clips[index];
    try {
      await apiPatch(`/api/admin/acls/video-lessons/${a.id}`, { sortOrder: other.sort_order });
      await apiPatch(`/api/admin/acls/video-lessons/${other.id}`, { sortOrder: a.sort_order });
      await reload();
    } catch (err) {
      alert("เรียงลำดับไม่สำเร็จ: " + errMsg(err));
    }
  };

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8 space-y-4 pb-24">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="flex items-center gap-2">
        <Shield className="h-5 w-5 text-purple-600" />
        <h1 className="text-2xl font-bold">จัดการวิดีโอบทเรียน</h1>
      </div>

      {loading && (
        <div className="flex items-center justify-center py-8">
          <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
        </div>
      )}

      {!loading &&
        VIDEO_TOPICS.map((tpc) => {
          const clips = items.filter((i) => i.topic === tpc.id);
          return (
            <div key={tpc.id} className="space-y-2">
              <div className="flex items-center justify-between px-1">
                <div className="text-xs font-bold text-muted-foreground uppercase">
                  {tpc.emoji} {tpc.label} ({clips.length})
                </div>
                <Button size="sm" variant="ghost" className="text-purple-600" onClick={() => startCreate(tpc.id)}>
                  <Plus className="h-3.5 w-3.5 mr-1" /> เพิ่มคลิป
                </Button>
              </div>
              {clips.map((item, i) => (
                <div key={item.id} className="border rounded-md p-3 flex items-center gap-3">
                  <Video className="h-4 w-4 text-purple-600 shrink-0" />
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-bold truncate">{item.title}</div>
                    <div className="text-xs text-muted-foreground">
                      {item.youtube_id} · {item.quiz?.length || 0} ควิซ · {item.chapters?.length || 0} สารบัญ
                      {!item.required && " · เสริม"}
                    </div>
                  </div>
                  <div className="flex flex-col shrink-0">
                    <Button size="icon-xs" variant="ghost" disabled={i === 0} onClick={() => move(clips, i, -1)}>
                      <ChevronUp className="h-3.5 w-3.5" />
                    </Button>
                    <Button size="icon-xs" variant="ghost" disabled={i === clips.length - 1} onClick={() => move(clips, i, 1)}>
                      <ChevronDown className="h-3.5 w-3.5" />
                    </Button>
                  </div>
                  <Button size="icon-sm" variant="ghost" onClick={() => startEdit(item)}>
                    <Pencil className="h-3.5 w-3.5" />
                  </Button>
                  <Button size="icon-sm" variant="ghost" className="text-destructive" onClick={() => remove(item)}>
                    <Trash2 className="h-3.5 w-3.5" />
                  </Button>
                </div>
              ))}
            </div>
          );
        })}

      {editing && (
        <VideoLessonEditor form={editing} setForm={(fn) => setEditing((f) => (f ? fn(f) : f))} onSave={save} onClose={() => setEditing(null)} saving={saving} />
      )}
    </div>
  );
}
