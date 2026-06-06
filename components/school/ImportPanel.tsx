"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  Upload,
  Link as LinkIcon,
  Type,
  Loader2,
  Sparkles,
  Save,
  Trash2,
  X,
  Check,
} from "lucide-react";

interface TopicOption {
  id: string;
  year: number;
  name_th: string;
  school_systems?: { name_th: string; icon?: string } | null;
}

interface ExtractedLesson {
  title: string;
  body_md: string;
  layer: string;
  estimated_min: number;
}
interface ExtractedFlashcard {
  front: string;
  back: string;
  difficulty: string;
}
interface ExtractedQuiz {
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string;
  difficulty: string;
}
interface Extracted {
  lesson: ExtractedLesson;
  flashcards: ExtractedFlashcard[];
  quizzes: ExtractedQuiz[];
}

interface Props {
  topics: TopicOption[];
}

type Mode = "file" | "url" | "text";
type ExtractMode = "faithful" | "expand" | "deep";

export default function ImportPanel({ topics }: Props) {
  const [mode, setMode] = useState<Mode>("file");
  const [extractMode, setExtractMode] = useState<ExtractMode>("expand");
  const [file, setFile] = useState<File | null>(null);
  const [url, setUrl] = useState("");
  const [text, setText] = useState("");
  const [hint, setHint] = useState("");
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [source, setSource] = useState("");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<{
    kind: "ok" | "err";
    msg: string;
  } | null>(null);
  const [data, setData] = useState<Extracted | null>(null);

  async function extract() {
    setLoading(true);
    setError(null);
    setData(null);
    try {
      let res: Response;
      if (mode === "file") {
        if (!file) throw new Error("เลือกไฟล์ก่อน");
        const fd = new FormData();
        fd.append("file", file);
        if (hint) fd.append("hint", hint);
        fd.append("mode", extractMode);
        res = await fetch("/api/admin/school/import", {
          method: "POST",
          body: fd,
        });
      } else if (mode === "url") {
        if (!url) throw new Error("ใส่ URL");
        res = await fetch("/api/admin/school/import", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ mode: "url", url, hint, extractMode }),
        });
      } else {
        if (!text) throw new Error("ใส่ text");
        res = await fetch("/api/admin/school/import", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ mode: "text", text, hint, extractMode }),
        });
      }
      if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.error ?? "Extract failed");
      }
      const d = (await res.json()) as Extracted;
      setData(d);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Error");
    } finally {
      setLoading(false);
    }
  }

  async function save() {
    if (!data || !topicId) return;
    setSaving(true);
    setResult(null);
    try {
      const res = await fetch("/api/admin/school/import/save", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({
          topic_id: topicId,
          source: source || (mode === "url" ? url : file?.name) || null,
          lesson: data.lesson,
          flashcards: data.flashcards,
          quizzes: data.quizzes,
        }),
      });
      const j = (await res.json()) as {
        ok?: boolean;
        lessonInserted?: number;
        fcInserted?: number;
        qzInserted?: number;
        errors?: string[];
        error?: string;
      };
      if (!res.ok || j.error) {
        setResult({ kind: "err", msg: j.error ?? "Save failed" });
        return;
      }
      setResult({
        kind: "ok",
        msg: `บันทึก: ${j.lessonInserted ?? 0} lesson + ${j.fcInserted ?? 0} cards + ${j.qzInserted ?? 0} quizzes${
          j.errors?.length ? " (มี errors บางส่วน: " + j.errors.join(", ") + ")" : ""
        }`,
      });
      setData(null);
      setText("");
      setUrl("");
      setFile(null);
    } catch (e) {
      setResult({ kind: "err", msg: e instanceof Error ? e.message : "Error" });
    } finally {
      setSaving(false);
    }
  }

  function removeFlashcard(i: number) {
    if (!data) return;
    setData({
      ...data,
      flashcards: data.flashcards.filter((_, x) => x !== i),
    });
  }
  function removeQuiz(i: number) {
    if (!data) return;
    setData({ ...data, quizzes: data.quizzes.filter((_, x) => x !== i) });
  }

  return (
    <Card>
      <CardContent className="p-4 space-y-4">
        <div>
          <h3 className="font-bold flex items-center gap-2">
            <Sparkles className="h-4 w-4 text-violet-600" /> Import + AI Generate
          </h3>
          <p className="text-xs text-muted-foreground">
            Upload PDF / Image / URL / text → AI สรุป (และขยาย) เป็น lesson + flashcards + quizzes → preview + แก้ + กดบันทึก
          </p>
        </div>

        {/* Extract depth */}
        <div className="rounded-lg border bg-violet-50/30 p-3 space-y-2">
          <p className="text-xs font-semibold text-violet-900">
            ✨ ระดับการขยายเนื้อหา
          </p>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
            {(
              [
                {
                  key: "faithful",
                  label: "📋 ตามต้นฉบับ",
                  desc: "ไม่เพิ่มเนื้อหา ใช้กับ lecture/ตำรา",
                },
                {
                  key: "expand",
                  label: "✨ ขยาย (แนะนำ)",
                  desc: "เพิ่ม foundation, clinical pearls, mnemonics — เหมาะกับสรุปจากรุ่นพี่",
                },
                {
                  key: "deep",
                  label: "🔬 ละเอียดสูงสุด",
                  desc: "Deep dive + cases + pitfalls (ใช้เวลา 40-90s)",
                },
              ] as const
            ).map((opt) => (
              <button
                key={opt.key}
                type="button"
                onClick={() => setExtractMode(opt.key)}
                className={`text-left rounded border p-2 text-xs transition ${
                  extractMode === opt.key
                    ? "border-violet-500 bg-violet-100 ring-1 ring-violet-300"
                    : "border-border bg-card hover:border-violet-300"
                }`}
              >
                <div className="font-semibold">{opt.label}</div>
                <div className="text-muted-foreground mt-0.5 leading-tight">
                  {opt.desc}
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Mode tabs */}
        <div className="flex border rounded-lg overflow-hidden">
          {(
            [
              ["file", "📎 File", Upload],
              ["url", "🔗 URL", LinkIcon],
              ["text", "📝 Text", Type],
            ] as const
          ).map(([k, label]) => (
            <button
              key={k}
              onClick={() => setMode(k as Mode)}
              className={`flex-1 px-3 py-2 text-sm font-medium ${
                mode === k
                  ? "bg-violet-100 text-violet-700"
                  : "text-muted-foreground hover:bg-muted/50"
              }`}
            >
              {label}
            </button>
          ))}
        </div>

        {/* Input */}
        {mode === "file" && (
          <div>
            <input
              type="file"
              accept="application/pdf,image/png,image/jpeg,image/webp"
              onChange={(e) => setFile(e.target.files?.[0] ?? null)}
              className="text-sm"
            />
            <p className="text-xs text-muted-foreground mt-1">
              PDF / PNG / JPG / WebP — รวม GoodNotes export
            </p>
            {file && (
              <p className="text-xs mt-1">
                ✓ {file.name} ({Math.round(file.size / 1024)} KB)
              </p>
            )}
          </div>
        )}
        {mode === "url" && (
          <input
            value={url}
            onChange={(e) => setUrl(e.target.value)}
            placeholder="https://..."
            className="w-full border rounded p-2 text-sm"
          />
        )}
        {mode === "text" && (
          <textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            placeholder="paste lecture notes / textbook excerpt / etc."
            className="w-full border rounded p-2 text-sm min-h-[160px] font-mono"
          />
        )}

        <input
          value={hint}
          onChange={(e) => setHint(e.target.value)}
          placeholder="Hint (optional) — เช่น 'Y1 CVS — Cardiac Cycle'"
          className="w-full border rounded p-2 text-sm"
        />

        {error && (
          <div className="border border-rose-300 bg-rose-50 text-rose-800 rounded p-3 text-sm">
            {error}
          </div>
        )}

        <Button onClick={extract} disabled={loading} className="gap-2">
          {loading ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" />
              {extractMode === "deep"
                ? "AI กำลัง deep-dive… (60-120s)"
                : extractMode === "expand"
                  ? "AI กำลังขยายเนื้อหา… (30-60s)"
                  : "AI กำลังสรุป… (20-40s)"}
            </>
          ) : (
            <>
              <Sparkles className="h-4 w-4" />
              {extractMode === "faithful"
                ? "Extract"
                : extractMode === "expand"
                  ? "Extract + ขยายเนื้อหา"
                  : "Extract + Deep Dive"}
            </>
          )}
        </Button>

        {data && (
          <div className="space-y-4 border-t pt-4">
            <div className="flex items-center justify-between">
              <p className="font-bold flex items-center gap-2">
                ✨ Preview — แก้ได้ก่อนบันทึก
              </p>
              <button
                onClick={() => setData(null)}
                className="text-xs text-muted-foreground hover:text-rose-600 flex items-center gap-1"
              >
                <X className="h-3 w-3" /> ทิ้ง
              </button>
            </div>

            {/* Lesson */}
            <Card>
              <CardContent className="p-4 space-y-2">
                <div className="flex items-center gap-2">
                  <Badge className="bg-teal-100 text-teal-700">Lesson</Badge>
                  <Badge variant="outline">{data.lesson.layer}</Badge>
                  <Badge variant="outline">{data.lesson.estimated_min} นาที</Badge>
                </div>
                <input
                  value={data.lesson.title}
                  onChange={(e) =>
                    setData({
                      ...data,
                      lesson: { ...data.lesson, title: e.target.value },
                    })
                  }
                  className="w-full border rounded p-2 text-sm font-semibold"
                />
                <textarea
                  value={data.lesson.body_md}
                  onChange={(e) =>
                    setData({
                      ...data,
                      lesson: { ...data.lesson, body_md: e.target.value },
                    })
                  }
                  className="w-full border rounded p-2 text-sm font-mono min-h-[200px]"
                />
              </CardContent>
            </Card>

            {/* Flashcards */}
            <div>
              <p className="font-semibold mb-2">
                Flashcards ({data.flashcards.length})
              </p>
              <div className="space-y-2">
                {data.flashcards.map((fc, i) => (
                  <Card key={i}>
                    <CardContent className="p-3 space-y-1">
                      <div className="flex items-center justify-between">
                        <Badge variant="outline" className="text-xs">
                          {fc.difficulty}
                        </Badge>
                        <button
                          onClick={() => removeFlashcard(i)}
                          className="text-muted-foreground hover:text-rose-600"
                        >
                          <Trash2 className="h-3 w-3" />
                        </button>
                      </div>
                      <textarea
                        value={fc.front}
                        onChange={(e) => {
                          const f = [...data.flashcards];
                          f[i] = { ...fc, front: e.target.value };
                          setData({ ...data, flashcards: f });
                        }}
                        className="w-full border rounded p-2 text-sm"
                        rows={2}
                      />
                      <textarea
                        value={fc.back}
                        onChange={(e) => {
                          const f = [...data.flashcards];
                          f[i] = { ...fc, back: e.target.value };
                          setData({ ...data, flashcards: f });
                        }}
                        className="w-full border rounded p-2 text-sm bg-muted/30"
                        rows={2}
                      />
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {/* Quizzes */}
            <div>
              <p className="font-semibold mb-2">Quizzes ({data.quizzes.length})</p>
              <div className="space-y-2">
                {data.quizzes.map((qz, i) => (
                  <Card key={i}>
                    <CardContent className="p-3 space-y-2">
                      <div className="flex items-center justify-between">
                        <div className="flex gap-1">
                          <Badge variant="outline" className="text-xs">
                            {qz.difficulty}
                          </Badge>
                          <Badge className="bg-emerald-100 text-emerald-700 text-xs">
                            Ans: {qz.correct_answer}
                          </Badge>
                        </div>
                        <button
                          onClick={() => removeQuiz(i)}
                          className="text-muted-foreground hover:text-rose-600"
                        >
                          <Trash2 className="h-3 w-3" />
                        </button>
                      </div>
                      <p className="text-sm font-medium">{qz.stem}</p>
                      <ul className="text-xs space-y-0.5">
                        {qz.choices.map((c) => (
                          <li
                            key={c.label}
                            className={
                              c.label === qz.correct_answer ? "font-bold" : ""
                            }
                          >
                            <span className="font-semibold mr-1">{c.label}.</span>
                            {c.text}
                          </li>
                        ))}
                      </ul>
                      {qz.explanation && (
                        <p className="text-xs italic text-muted-foreground">
                          {qz.explanation}
                        </p>
                      )}
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {/* Save form */}
            <Card className="border-violet-300 bg-violet-50/30">
              <CardContent className="p-4 space-y-3">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <label className="block">
                    <span className="text-xs font-semibold text-muted-foreground block mb-1">
                      Topic
                    </span>
                    <select
                      value={topicId}
                      onChange={(e) => setTopicId(e.target.value)}
                      className="w-full border rounded p-2 text-sm"
                    >
                      {topics.map((t) => (
                        <option key={t.id} value={t.id}>
                          Y{t.year} · {t.school_systems?.icon} {t.name_th}
                        </option>
                      ))}
                    </select>
                  </label>
                  <label className="block">
                    <span className="text-xs font-semibold text-muted-foreground block mb-1">
                      Source (optional)
                    </span>
                    <input
                      value={source}
                      onChange={(e) => setSource(e.target.value)}
                      placeholder="auto จาก file/url"
                      className="w-full border rounded p-2 text-sm"
                    />
                  </label>
                </div>
                {result && (
                  <div
                    className={`rounded p-2 text-sm flex items-center gap-2 ${
                      result.kind === "ok"
                        ? "bg-emerald-50 text-emerald-800 border border-emerald-200"
                        : "bg-rose-50 text-rose-800 border border-rose-200"
                    }`}
                  >
                    {result.kind === "ok" ? <Check className="h-4 w-4" /> : <X className="h-4 w-4" />}
                    {result.msg}
                  </div>
                )}
                <Button onClick={save} disabled={saving || !topicId} className="gap-2">
                  {saving ? <Loader2 className="h-4 w-4 animate-spin" /> : <Save className="h-4 w-4" />}
                  บันทึกทั้งหมด
                </Button>
              </CardContent>
            </Card>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
