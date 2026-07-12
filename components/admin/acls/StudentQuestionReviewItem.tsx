"use client";

import { useEffect, useState } from "react";
import {
  RefreshCw, Send, Trash2, Save, X, AlertTriangle,
  CheckCircle2, Clock, Sparkles, Image as ImageIcon, Layers, MessageSquare,
} from "lucide-react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { apiPatch, apiDelete, apiPost, errMsg } from "./api-client";

export interface StudentQuestionChapterOption {
  id: string;
  title: string;
  icon: string | null;
}

export interface StudentQuestionRow {
  id: string;
  question: string;
  student_name: string | null;
  student_contact: string | null;
  status: "pending" | "processing" | "draft_ready" | "published" | "rejected" | "failed";
  deepseek_answer: string | null;
  suggested_chapter_id: string | null;
  classification_reason: string | null;
  generated_image_url: string | null;
  admin_notes: string | null;
  error_message: string | null;
  published_item_id: string | null;
  created_at: string;
  published_at: string | null;
}

const STATUS_META: Record<
  StudentQuestionRow["status"],
  { label: string; color: string; icon: typeof Clock }
> = {
  pending: { label: "รอประมวลผล", color: "text-muted-foreground", icon: Clock },
  processing: { label: "กำลังประมวลผล", color: "text-blue-600", icon: RefreshCw },
  draft_ready: { label: "พร้อมตรวจ", color: "text-amber-600", icon: Sparkles },
  published: { label: "เผยแพร่แล้ว", color: "text-green-600", icon: CheckCircle2 },
  rejected: { label: "ปฏิเสธ", color: "text-muted-foreground", icon: X },
  failed: { label: "ประมวลผลล้มเหลว", color: "text-destructive", icon: AlertTriangle },
};

// Review one student-submitted question: edit draft fields, publish,
// reprocess, reject, or permanently delete.
// Ported from acls-emr's src/components/admin/StudentQuestionReviewItem.jsx.
export function StudentQuestionReviewItem({
  item,
  chapters,
  onChange,
}: {
  item: StudentQuestionRow;
  chapters: StudentQuestionChapterOption[];
  onChange: () => void;
}) {
  const [question, setQuestion] = useState(item.question || "");
  const [answer, setAnswer] = useState(item.deepseek_answer || "");
  const [chapterId, setChapterId] = useState(item.suggested_chapter_id || "");
  const [adminNotes, setAdminNotes] = useState(item.admin_notes || "");
  const [busy, setBusy] = useState("");

  useEffect(() => {
    setQuestion(item.question || "");
    setAnswer(item.deepseek_answer || "");
    setChapterId(item.suggested_chapter_id || "");
    setAdminNotes(item.admin_notes || "");
  }, [item.id, item.question, item.deepseek_answer, item.suggested_chapter_id, item.admin_notes]);

  const dirty =
    question !== (item.question || "") ||
    answer !== (item.deepseek_answer || "") ||
    chapterId !== (item.suggested_chapter_id || "") ||
    adminNotes !== (item.admin_notes || "");

  const meta = STATUS_META[item.status] || STATUS_META.pending;
  const StatusIcon = meta.icon;

  const handleSave = async () => {
    setBusy("save");
    try {
      await apiPatch(`/api/admin/acls/student-question/${item.id}`, {
        question,
        deepseek_answer: answer,
        suggested_chapter_id: chapterId || null,
        admin_notes: adminNotes,
      });
      onChange();
    } catch (err) {
      alert("บันทึกไม่สำเร็จ: " + errMsg(err));
    }
    setBusy("");
  };

  const handleReprocess = async () => {
    if (!confirm("สั่ง AI สร้างคำตอบและรูปใหม่ (ทับของเดิม)?")) return;
    setBusy("reprocess");
    try {
      await apiPost(`/api/admin/acls/student-question/${item.id}/reprocess`);
      onChange();
    } catch (err) {
      alert("สั่งใหม่ไม่สำเร็จ: " + errMsg(err));
    }
    setBusy("");
  };

  const handlePublish = async () => {
    if (!confirm("เผยแพร่คำถาม-คำตอบนี้เข้าสู่หน้า Q&A?")) return;
    setBusy("publish");
    try {
      if (dirty) {
        await apiPatch(`/api/admin/acls/student-question/${item.id}`, {
          question,
          deepseek_answer: answer,
          suggested_chapter_id: chapterId || null,
          admin_notes: adminNotes,
        });
      }
      await apiPost(`/api/admin/acls/student-question/${item.id}/publish`, {
        question,
        answer,
        chapterId: chapterId || null,
      });
      onChange();
    } catch (err) {
      alert("เผยแพร่ไม่สำเร็จ: " + errMsg(err));
    }
    setBusy("");
  };

  const handleReject = async () => {
    const reason = prompt("เหตุผลที่ปฏิเสธ (ไม่บังคับ):", "");
    if (reason === null) return;
    setBusy("reject");
    try {
      await apiPatch(`/api/admin/acls/student-question/${item.id}`, { status: "rejected", admin_notes: reason || null });
      onChange();
    } catch (err) {
      alert("ปฏิเสธไม่สำเร็จ: " + errMsg(err));
    }
    setBusy("");
  };

  const handleDelete = async () => {
    if (!confirm("ลบคำถามนี้ถาวร? (ไม่สามารถกู้คืนได้)")) return;
    setBusy("delete");
    try {
      await apiDelete(`/api/admin/acls/student-question/${item.id}`);
      onChange();
    } catch (err) {
      alert("ลบไม่สำเร็จ: " + errMsg(err));
    }
    setBusy("");
  };

  const canEdit = item.status === "draft_ready" || item.status === "failed";
  const canPublish = item.status === "draft_ready" && answer.trim().length > 0;

  return (
    <div className="border rounded-md p-4 space-y-3">
      <div className="flex items-center justify-between gap-2 flex-wrap">
        <div className="inline-flex items-center gap-2">
          <span className={`inline-flex items-center gap-1 text-xs font-bold ${meta.color}`}>
            <StatusIcon className="h-3 w-3" />
            {meta.label}
          </span>
          <span className="text-xs text-muted-foreground">
            {new Date(item.created_at).toLocaleString("th-TH", { dateStyle: "short", timeStyle: "short" })}
          </span>
          {item.student_name && <span className="text-xs text-muted-foreground">· {item.student_name}</span>}
        </div>
        <div className="flex items-center gap-1">
          {item.status !== "published" && (
            <Button size="sm" variant="ghost" disabled={!!busy} onClick={handleReprocess} title="สั่ง AI สร้างใหม่">
              <RefreshCw className={`h-3 w-3 mr-1 ${busy === "reprocess" ? "animate-spin" : ""}`} />
              สร้างใหม่
            </Button>
          )}
          <Button size="sm" variant="ghost" className="text-destructive" disabled={!!busy} onClick={handleDelete} title="ลบถาวร">
            <Trash2 className="h-3 w-3" />
          </Button>
        </div>
      </div>

      {item.error_message && (
        <div className="border-l-4 border-l-amber-500 bg-amber-50/50 rounded flex items-start gap-2 py-2 px-2">
          <AlertTriangle className="h-3 w-3 text-amber-600 shrink-0 mt-0.5" />
          <div className="text-xs text-muted-foreground leading-relaxed font-mono break-all">{item.error_message}</div>
        </div>
      )}

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 inline-flex items-center gap-1">
          <MessageSquare className="h-3 w-3" /> คำถาม
        </span>
        <Textarea value={question} onChange={(e) => setQuestion(e.target.value)} rows={2} disabled={!canEdit} />
      </label>

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 inline-flex items-center gap-1">
          <Layers className="h-3 w-3" /> หมวด
          {item.suggested_chapter_id && (
            <span className="font-normal">
              · AI แนะนำ: {chapters.find((c) => c.id === item.suggested_chapter_id)?.title || item.suggested_chapter_id}
            </span>
          )}
        </span>
        <select
          value={chapterId}
          onChange={(e) => setChapterId(e.target.value)}
          disabled={!canEdit}
          className="w-full px-3 py-2 bg-background border rounded-md text-sm disabled:opacity-60"
        >
          <option value="">— ยังไม่จัดหมวด —</option>
          {chapters.map((c) => (
            <option key={c.id} value={c.id}>
              {c.icon ? `${c.icon} ` : ""}
              {c.title}
            </option>
          ))}
        </select>
        {item.classification_reason && (
          <div className="text-xs text-muted-foreground mt-1 italic">เหตุผล AI: {item.classification_reason}</div>
        )}
      </label>

      {item.generated_image_url && (
        <div className="space-y-1">
          <div className="text-xs font-bold text-muted-foreground inline-flex items-center gap-1">
            <ImageIcon className="h-3 w-3" /> รูปประกอบที่ AI สร้าง
          </div>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={item.generated_image_url} alt={question.slice(0, 80)} className="w-full max-w-sm border rounded-md" />
        </div>
      )}

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">คำตอบ (Markdown — แก้ไขได้ก่อนเผยแพร่)</span>
        <Textarea
          value={answer}
          onChange={(e) => setAnswer(e.target.value)}
          rows={10}
          disabled={!canEdit}
          placeholder={item.status === "pending" ? "กำลังรอ AI สร้างคำตอบ…" : ""}
          className="font-mono text-xs"
        />
      </label>

      {answer && (
        <details className="border rounded-md p-2">
          <summary className="cursor-pointer text-xs font-bold text-muted-foreground">ดูตัวอย่าง preview</summary>
          <div className="prose prose-sm max-w-none mt-2">
            <ReactMarkdown remarkPlugins={[remarkGfm]}>{answer}</ReactMarkdown>
          </div>
        </details>
      )}

      <label className="block">
        <span className="text-xs font-bold text-muted-foreground mb-1 block">
          บันทึก admin <span className="font-normal">(ไม่แสดงให้นักเรียน)</span>
        </span>
        <Input value={adminNotes} onChange={(e) => setAdminNotes(e.target.value)} disabled={item.status === "published"} />
      </label>

      <div className="flex flex-wrap gap-2 pt-1">
        {canEdit && (
          <Button size="sm" variant="ghost" disabled={!dirty || !!busy} onClick={handleSave}>
            <Save className="h-3 w-3 mr-1" /> {busy === "save" ? "กำลังบันทึก…" : "บันทึกร่าง"}
          </Button>
        )}
        {canPublish && (
          <Button size="sm" disabled={!!busy} onClick={handlePublish}>
            <Send className="h-3 w-3 mr-1" /> {busy === "publish" ? "กำลังเผยแพร่…" : "เผยแพร่เข้า Q&A"}
          </Button>
        )}
        {item.status !== "rejected" && item.status !== "published" && (
          <Button size="sm" variant="ghost" className="text-muted-foreground" disabled={!!busy} onClick={handleReject}>
            <X className="h-3 w-3 mr-1" /> ปฏิเสธ
          </Button>
        )}
        {item.status === "published" && item.published_item_id && (
          <span className="text-xs text-green-600 inline-flex items-center gap-1 px-2 py-1">
            <CheckCircle2 className="h-3 w-3" />
            เผยแพร่แล้ว
            {item.published_at && (
              <span className="text-muted-foreground">
                · {new Date(item.published_at).toLocaleString("th-TH", { dateStyle: "short", timeStyle: "short" })}
              </span>
            )}
          </span>
        )}
      </div>
    </div>
  );
}
