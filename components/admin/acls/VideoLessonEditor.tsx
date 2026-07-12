"use client";

import { useState } from "react";
import { Plus, Trash2, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { VIDEO_TOPICS } from "@/lib/courses/video-topics";
import { getYouTubeId, parseClipTime, formatClipTime } from "@/lib/courses/youtube";

const LETTERS = ["a", "b", "c", "d", "e"];
const blankChoice = (i: number) => ({ id: LETTERS[i] || `o${i}`, text: "" });
export const blankQuizQuestion = () => ({
  id: (crypto.randomUUID?.() || String(Math.random())).slice(0, 8),
  question: "",
  choices: [blankChoice(0), blankChoice(1)],
  correctId: "a",
  explanation: "",
});

export interface VideoLessonChapterMark {
  t: number | string;
  label: string;
}
export interface VideoLessonQuizChoice {
  id: string;
  text: string;
}
export interface VideoLessonQuizQuestion {
  id: string;
  question: string;
  choices: VideoLessonQuizChoice[];
  correctId: string;
  explanation: string;
}
export interface VideoLessonForm {
  id?: string;
  topic: string;
  title: string;
  youtubeId: string;
  orientation: "portrait" | "landscape";
  startSec: number | "";
  endSec: number | "";
  required: boolean;
  keyPoints: string;
  chapters: VideoLessonChapterMark[];
  quiz: VideoLessonQuizQuestion[];
  relatedPath: string;
  relatedLabel: string;
}

export const blankVideoLessonForm = (topic?: string): VideoLessonForm => ({
  topic: topic || VIDEO_TOPICS[0].id,
  title: "",
  youtubeId: "",
  orientation: "portrait",
  startSec: "",
  endSec: "",
  required: true,
  keyPoints: "",
  chapters: [],
  quiz: [],
  relatedPath: "",
  relatedLabel: "",
});

// ช่องกรอกเวลาแบบ นาที:วินาที
function TimeInput({
  value,
  onChange,
  className,
  placeholder,
}: {
  value: number | "";
  onChange: (v: number | "") => void;
  className?: string;
  placeholder?: string;
}) {
  const toText = (v: number | "") => (v === "" || v == null ? "" : formatClipTime(v));
  const [text, setText] = useState(() => toText(value));
  const [prevValue, setPrevValue] = useState(value);
  if (value !== prevValue) {
    setPrevValue(value);
    const parsed = parseClipTime(text) ?? "";
    if (parsed !== (value === "" || value == null ? "" : Number(value))) setText(toText(value));
  }
  return (
    <input
      inputMode="numeric"
      value={text}
      onChange={(e) => {
        setText(e.target.value);
        const sec = parseClipTime(e.target.value);
        onChange(sec == null ? "" : sec);
      }}
      onBlur={() => setText(toText(parseClipTime(text) ?? ""))}
      className={className}
      placeholder={placeholder}
    />
  );
}

const inputCls =
  "w-full bg-background border rounded-md px-3 py-2 text-sm h-9";

// Modal editor for one video lesson clip — YouTube link, key points (B),
// chapter markers (A), quiz (C), and related-link (D).
// Ported from acls-emr's src/pages/AdminVideoLessons.jsx (inline VideoLessonEditor).
export function VideoLessonEditor({
  form,
  setForm,
  onSave,
  onClose,
  saving,
}: {
  form: VideoLessonForm;
  setForm: (updater: (f: VideoLessonForm) => VideoLessonForm) => void;
  onSave: () => void;
  onClose: () => void;
  saving: boolean;
}) {
  const upd = (patch: Partial<VideoLessonForm>) => setForm((f) => ({ ...f, ...patch }));
  const ytId = getYouTubeId(form.youtubeId) || (/^[\w-]{11}$/.test((form.youtubeId || "").trim()) ? form.youtubeId.trim() : "");

  const addChapter = () => upd({ chapters: [...form.chapters, { t: "", label: "" }] });
  const setChapter = (i: number, patch: Partial<VideoLessonChapterMark>) =>
    upd({ chapters: form.chapters.map((c, j) => (j === i ? { ...c, ...patch } : c)) });
  const delChapter = (i: number) => upd({ chapters: form.chapters.filter((_, j) => j !== i) });

  const addQuestion = () => upd({ quiz: [...form.quiz, blankQuizQuestion()] });
  const setQuestion = (i: number, patch: Partial<VideoLessonQuizQuestion>) =>
    upd({ quiz: form.quiz.map((q, j) => (j === i ? { ...q, ...patch } : q)) });
  const delQuestion = (i: number) => upd({ quiz: form.quiz.filter((_, j) => j !== i) });
  const addChoice = (qi: number) =>
    setQuestion(qi, { choices: [...form.quiz[qi].choices, blankChoice(form.quiz[qi].choices.length)] });
  const setChoice = (qi: number, ci: number, text: string) =>
    setQuestion(qi, { choices: form.quiz[qi].choices.map((c, j) => (j === ci ? { ...c, text } : c)) });
  const delChoice = (qi: number, ci: number) => {
    const q = form.quiz[qi];
    if (q.choices.length <= 2) return;
    setQuestion(qi, { choices: q.choices.filter((_, j) => j !== ci) });
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/50 flex items-end sm:items-center justify-center p-0 sm:p-4" onClick={onClose}>
      <div
        className="bg-background w-full max-w-lg max-h-[92vh] overflow-y-auto p-4 space-y-3 rounded-t-xl sm:rounded-xl"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between sticky -top-4 bg-background py-2 -mt-2 z-10">
          <h2 className="text-lg font-bold">{form.id ? "แก้ไขคลิป" : "เพิ่มคลิป"}</h2>
          <Button size="icon-sm" variant="ghost" onClick={onClose}>
            <X className="h-4 w-4" />
          </Button>
        </div>

        <label className="block">
          <span className="text-sm font-bold text-muted-foreground">หัวข้อ</span>
          <select value={form.topic} onChange={(e) => upd({ topic: e.target.value })} className={inputCls}>
            {VIDEO_TOPICS.map((t) => (
              <option key={t.id} value={t.id}>
                {t.emoji} {t.label}
              </option>
            ))}
          </select>
        </label>

        <label className="block">
          <span className="text-sm font-bold text-muted-foreground">ชื่อคลิป</span>
          <Input value={form.title} onChange={(e) => upd({ title: e.target.value })} placeholder="เช่น การใช้ BVM" />
        </label>

        <label className="block">
          <span className="text-sm font-bold text-muted-foreground">🔗 ลิงก์ YouTube (วางลิงก์ ไม่ต้องอัปไฟล์)</span>
          <Input value={form.youtubeId} onChange={(e) => upd({ youtubeId: e.target.value })} placeholder="https://youtu.be/xxxxxxxxxxx" />
          {form.youtubeId && (
            <span className={`text-xs ${ytId ? "text-green-600" : "text-destructive"}`}>{ytId ? `id: ${ytId}` : "ลิงก์ไม่ถูกต้อง"}</span>
          )}
        </label>

        <div className="grid grid-cols-3 gap-2">
          <label className="block">
            <span className="text-sm font-bold text-muted-foreground">เริ่ม (นาที:วิ)</span>
            <TimeInput value={form.startSec} onChange={(v) => upd({ startSec: v })} className={inputCls} placeholder="0:00" />
          </label>
          <label className="block">
            <span className="text-sm font-bold text-muted-foreground">จบ (นาที:วิ)</span>
            <TimeInput value={form.endSec} onChange={(v) => upd({ endSec: v })} className={inputCls} placeholder="—" />
          </label>
          <label className="block">
            <span className="text-sm font-bold text-muted-foreground">แนว</span>
            <select
              value={form.orientation}
              onChange={(e) => upd({ orientation: e.target.value as "portrait" | "landscape" })}
              className={inputCls}
            >
              <option value="portrait">ตั้ง 9:16</option>
              <option value="landscape">นอน 16:9</option>
            </select>
          </label>
        </div>

        <label className="flex items-center gap-2 cursor-pointer py-1">
          <input type="checkbox" checked={form.required} onChange={(e) => upd({ required: e.target.checked })} className="w-4 h-4" />
          <span className="text-sm font-bold text-muted-foreground">บังคับเพื่อใบประกาศนียบัตร (required)</span>
        </label>

        <label className="block">
          <span className="text-sm font-bold text-purple-600">📝 B · สรุปประเด็น (markdown bullet)</span>
          <Textarea value={form.keyPoints} onChange={(e) => upd({ keyPoints: e.target.value })} rows={3} placeholder={"- ประเด็นที่ 1\n- ประเด็นที่ 2"} />
        </label>

        <div className="space-y-2">
          <div className="text-sm font-bold text-purple-600">📍 A · สารบัญช่วงเวลา</div>
          {form.chapters.map((ch, i) => (
            <div key={i} className="flex items-center gap-2">
              <TimeInput value={ch.t as number | ""} onChange={(v) => setChapter(i, { t: v })} className={`${inputCls} !w-20`} placeholder="0:00" />
              <Input value={ch.label} onChange={(e) => setChapter(i, { label: e.target.value })} placeholder="ชื่อช่วง" />
              <Button size="icon-sm" variant="ghost" className="text-destructive shrink-0" onClick={() => delChapter(i)}>
                <Trash2 className="h-3.5 w-3.5" />
              </Button>
            </div>
          ))}
          <Button variant="ghost" className="w-full text-purple-600" onClick={addChapter}>
            <Plus className="h-3.5 w-3.5 mr-1" /> เพิ่มช่วงเวลา
          </Button>
        </div>

        <div className="space-y-3">
          <div className="text-sm font-bold text-green-600">✅ C · ควิซ</div>
          {form.quiz.map((q, qi) => (
            <div key={q.id || qi} className="border rounded-md p-3 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-xs font-bold text-muted-foreground">ข้อ {qi + 1}</span>
                <Button size="icon-sm" variant="ghost" className="text-destructive" onClick={() => delQuestion(qi)}>
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              </div>
              <Input value={q.question} onChange={(e) => setQuestion(qi, { question: e.target.value })} placeholder="คำถาม" />
              {q.choices.map((c, ci) => (
                <div key={c.id} className="flex items-center gap-2">
                  <input
                    type="radio"
                    name={`correct-${qi}`}
                    checked={q.correctId === c.id}
                    onChange={() => setQuestion(qi, { correctId: c.id })}
                    className="w-4 h-4 shrink-0"
                    title="ตอบถูก"
                  />
                  <span className="text-xs font-mono text-muted-foreground w-4">{c.id}</span>
                  <Input value={c.text} onChange={(e) => setChoice(qi, ci, e.target.value)} placeholder={`ตัวเลือก ${c.id}`} />
                  <Button
                    size="icon-sm"
                    variant="ghost"
                    className="text-destructive shrink-0"
                    disabled={q.choices.length <= 2}
                    onClick={() => delChoice(qi, ci)}
                  >
                    <X className="h-3.5 w-3.5" />
                  </Button>
                </div>
              ))}
              <Button size="sm" variant="ghost" className="text-purple-600" onClick={() => addChoice(qi)}>
                <Plus className="h-3.5 w-3.5 mr-1" /> เพิ่มตัวเลือก
              </Button>
              <Input value={q.explanation} onChange={(e) => setQuestion(qi, { explanation: e.target.value })} placeholder="คำอธิบายเฉลย (ไม่บังคับ)" />
            </div>
          ))}
          <Button variant="ghost" className="w-full text-green-600" onClick={addQuestion}>
            <Plus className="h-3.5 w-3.5 mr-1" /> เพิ่มข้อ
          </Button>
        </div>

        <div className="grid grid-cols-2 gap-2">
          <label className="block">
            <span className="text-sm font-bold text-blue-600">📖 D · ลิงก์ (path)</span>
            <Input value={form.relatedPath} onChange={(e) => upd({ relatedPath: e.target.value })} placeholder="/pre-course/pc09" />
          </label>
          <label className="block">
            <span className="text-sm font-bold text-blue-600">ป้ายลิงก์</span>
            <Input value={form.relatedLabel} onChange={(e) => upd({ relatedLabel: e.target.value })} placeholder="บทที่ 9" />
          </label>
        </div>

        <div className="flex gap-2 pt-2 sticky -bottom-4 bg-background py-3 -mb-4">
          <Button variant="ghost" className="flex-1" onClick={onClose}>
            ยกเลิก
          </Button>
          <Button className="flex-1" disabled={saving} onClick={onSave}>
            {saving ? "กำลังบันทึก…" : "💾 บันทึก"}
          </Button>
        </div>
      </div>
    </div>
  );
}
