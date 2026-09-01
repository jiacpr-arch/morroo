"use client";

import { useMemo, useRef, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";

interface TopicOption {
  id: string;
  year: number;
  term?: number | null;
  name_th: string;
  code?: string | null;
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
interface Classification {
  suggested_topic_id: string | null;
  confidence: number;
  reasoning: string;
}
interface Extracted {
  lesson: ExtractedLesson;
  flashcards: ExtractedFlashcard[];
  quizzes: ExtractedQuiz[];
  classification?: Classification | null;
}

interface SystemOption {
  id: string;
  slug: string;
  name_th: string;
}

interface Props {
  topics: TopicOption[];
  systems: SystemOption[];
}

type ExtractMode = "faithful" | "expand" | "deep";

const MODE_LABEL: Record<ExtractMode, string> = {
  faithful: "ตามต้นฉบับ — ไม่เพิ่มเนื้อหาที่ไม่มีในไฟล์",
  expand: "ขยาย — เติมพื้นฐาน clinical pearls สูตรช่วยจำ (AI แต่งเพิ่ม ต้องตรวจ)",
  deep: "ละเอียดสูงสุด — ขยาย + เคส + จุดที่มักออกสอบ (AI แต่งเพิ่มมาก ต้องตรวจ)",
};

/**
 * How much to generate per depth, and how to slice it. Each batch is a separate
 * request so no single call runs long enough to be killed mid-generation.
 */
const PLAN: Record<ExtractMode, { flashcards: number; quizzes: number }> = {
  faithful: { flashcards: 12, quizzes: 16 },
  expand: { flashcards: 24, quizzes: 24 },
  deep: { flashcards: 36, quizzes: 32 },
};
const FC_PER_BATCH = 12;
const QZ_PER_BATCH = 8;

/** Files above this go through Supabase Storage — the request body can't hold them. */
const DIRECT_UPLOAD_MAX = 4 * 1024 * 1024;
const PDF_MAX = 32 * 1024 * 1024;

/** Give up on a step rather than spin forever if the server side was killed. */
const STEP_TIMEOUT_MS = 240_000;

export default function ImportPanel({ topics: initialTopics, systems }: Props) {
  // Subjects added inline live here until the next server render picks them up.
  const [topics, setTopics] = useState<TopicOption[]>(initialTopics);
  const [year, setYear] = useState<number>(initialTopics[0]?.year ?? 1);
  const [term, setTerm] = useState<number>(1);
  const [topicId, setTopicId] = useState("");
  const [addingTopic, setAddingTopic] = useState(false);
  const [newTopicName, setNewTopicName] = useState("");
  const [newTopicCode, setNewTopicCode] = useState("");
  const [newTopicSystem, setNewTopicSystem] = useState(systems[0]?.id ?? "");
  const [savingTopic, setSavingTopic] = useState(false);
  const [extractMode, setExtractMode] = useState<ExtractMode>("faithful");
  const [file, setFile] = useState<File | null>(null);
  const [dragOver, setDragOver] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [progress, setProgress] = useState<string | null>(null);
  const [result, setResult] = useState<{ kind: "ok" | "err"; msg: string } | null>(null);
  const [data, setData] = useState<Extracted | null>(null);

  // ชั้นปี 1-6 คงที่ ไม่ผูกกับปีที่มีวิชาอยู่ — ปีที่ยังว่างจะขึ้นข้อความบอกให้
  // ไปสร้างวิชาก่อน ดีกว่าซ่อนปีนั้นไปเลยแล้วหาไม่เจอ
  const YEARS = [1, 2, 3, 4, 5, 6];

  // วิชาที่ยังไม่ระบุเทอม (term = null) ให้ขึ้นในทุกเทอม — ไม่งั้นวิชาเดิม
  // ที่ยังไม่ได้กรอกเทอมจะหายไปจาก dropdown ทั้งหมด
  const visibleTopics = useMemo(
    () => topics.filter((t) => t.year === year && (t.term == null || t.term === term)),
    [topics, year, term],
  );

  const selectedTopic = visibleTopics.find((t) => t.id === topicId) ?? null;

  function pickYear(y: number) {
    setYear(y);
    setTopicId("");
  }
  function pickTerm(t: number) {
    setTerm(t);
    setTopicId("");
  }

  function topicLabel(t: TopicOption) {
    return `${t.name_th}${t.code ? ` (${t.code})` : ""}`;
  }

  /**
   * Create a subject right here, so adding one never means leaving the upload
   * screen. slug/name_en aren't shown to students anywhere (their pages address
   * topics by id) — they're only NOT NULL in the table — so derive them from the
   * course code or a timestamp rather than asking for them.
   */
  async function addTopic() {
    const name = newTopicName.trim();
    if (!name) {
      setError("ใส่ชื่อวิชาก่อน");
      return;
    }
    if (!newTopicSystem) {
      setError("ไม่พบหมวดวิชา — สร้าง system ใน Supabase ก่อน");
      return;
    }
    setSavingTopic(true);
    setError(null);
    try {
      const { createClient } = await import("@/lib/supabase/client");
      const supabase = createClient();
      const code = newTopicCode.trim();
      const slug = code
        ? code.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "")
        : `topic-${Date.now()}`;
      const { data, error: insErr } = await supabase
        .from("school_topics")
        .insert({
          system_id: newTopicSystem,
          year,
          term,
          slug,
          name_th: name,
          name_en: name,
          code: code || null,
        })
        .select("id, year, term, name_th, code")
        .single();
      // รหัสวิชามี unique index — ชนแล้วข้อความจาก Postgres อ่านไม่รู้เรื่อง
      if (insErr) {
        if (insErr.code === "23505") {
          throw new Error(
            code
              ? `รหัสวิชา "${code}" มีอยู่แล้ว — เลือกวิชานั้นจาก dropdown หรือใช้รหัสอื่น`
              : "วิชานี้มีอยู่แล้ว — เลือกจาก dropdown ได้เลย",
          );
        }
        throw insErr;
      }
      const created = data as TopicOption;
      setTopics((prev) => [...prev, created]);
      setTopicId(created.id);
      setNewTopicName("");
      setNewTopicCode("");
      setAddingTopic(false);
    } catch (e) {
      setError(e instanceof Error ? e.message : "เพิ่มวิชาไม่สำเร็จ");
    } finally {
      setSavingTopic(false);
    }
  }

  /**
   * POST one import step. Always bounded by a timeout — without one, a request
   * the platform killed server-side leaves the button spinning forever with no
   * hint that anything went wrong.
   */
  async function post(body: FormData | Record<string, unknown>): Promise<Response> {
    const isForm = body instanceof FormData;
    return fetch("/api/admin/school/import", {
      method: "POST",
      headers: isForm ? undefined : { "content-type": "application/json" },
      body: isForm ? body : JSON.stringify(body),
      signal: AbortSignal.timeout(STEP_TIMEOUT_MS),
    });
  }

  /** One import step. Throws with the server's Thai message on failure. */
  async function step<T>(body: Record<string, unknown>): Promise<T> {
    const res = await post(body);
    if (!res.ok) {
      const j = (await res.json().catch(() => ({}))) as { error?: string };
      throw new Error(j.error ?? `ขั้นตอนนี้ล้มเหลว (${res.status})`);
    }
    return (await res.json()) as T;
  }

  /** Upload a file too large for the request body, and return its storage path. */
  async function uploadToStorage(f: File): Promise<string> {
    const urlRes = await fetch("/api/admin/school/import/storage-url", { method: "POST" });
    const urlJson = (await urlRes.json()) as {
      bucket?: string;
      path?: string;
      token?: string;
      error?: string;
    };
    if (!urlRes.ok || !urlJson.path || !urlJson.token) {
      throw new Error(urlJson.error ?? "ขอ upload URL ไม่สำเร็จ");
    }
    const { createClient } = await import("@/lib/supabase/client");
    const supa = createClient();
    const { error: upErr } = await supa.storage
      .from(urlJson.bucket ?? "school-imports")
      .uploadToSignedUrl(urlJson.path, urlJson.token, f, {
        contentType: "application/pdf",
      });
    if (upErr) throw new Error(`อัปโหลดไม่สำเร็จ: ${upErr.message}`);
    return urlJson.path;
  }

  /** Ask for the lesson — the only step that carries the file itself. */
  async function extractLesson(
    f: File,
    hint: string,
  ): Promise<{ lesson: ExtractedLesson; classification?: Classification | null }> {
    if (f.size > DIRECT_UPLOAD_MAX) {
      setProgress("กำลังอัปโหลดไฟล์…");
      const path = await uploadToStorage(f);
      setProgress("AI กำลังอ่านไฟล์และเขียนบทเรียน…");
      return step({ step: "lesson", storage_path: path, hint, extractMode });
    }
    setProgress("AI กำลังอ่านไฟล์และเขียนบทเรียน…");
    const fd = new FormData();
    fd.append("file", f);
    fd.append("hint", hint);
    fd.append("extractMode", extractMode);
    const res = await post(fd);
    if (!res.ok) {
      const j = (await res.json().catch(() => ({}))) as { error?: string };
      throw new Error(j.error ?? `อ่านไฟล์ไม่สำเร็จ (${res.status})`);
    }
    return res.json();
  }

  async function run() {
    if (!file) {
      setError("เลือกไฟล์ก่อน");
      return;
    }
    if (!topicId) {
      setError("เลือกวิชาก่อน");
      return;
    }
    if (file.type === "application/pdf" && file.size > PDF_MAX) {
      setError(
        `PDF ใหญ่เกินไป (${(file.size / 1024 / 1024).toFixed(1)} MB) — สูงสุด 32 MB บีบอัดหรือแยกไฟล์ก่อน`,
      );
      return;
    }
    if (file.type !== "application/pdf" && file.size > DIRECT_UPLOAD_MAX) {
      setError(`รูปภาพใหญ่เกินไป (${(file.size / 1024 / 1024).toFixed(1)} MB) — สูงสุด 4 MB`);
      return;
    }

    setLoading(true);
    setError(null);
    setResult(null);
    setData(null);
    try {
      const hint = selectedTopic
        ? `ปี ${year} เทอม ${term} · วิชา ${topicLabel(selectedTopic)}`
        : `ปี ${year} เทอม ${term}`;

      // 1. Lesson (carries the file).
      const { lesson, classification } = await extractLesson(file, hint);
      setData({ lesson, flashcards: [], quizzes: [], classification });

      const plan = PLAN[extractMode];

      // 2. Flashcards, in batches, each request small enough to finish quickly.
      const flashcards: ExtractedFlashcard[] = [];
      while (flashcards.length < plan.flashcards) {
        const want = Math.min(FC_PER_BATCH, plan.flashcards - flashcards.length);
        setProgress(`สร้าง flashcards… (${flashcards.length}/${plan.flashcards})`);
        const out = await step<{ flashcards: ExtractedFlashcard[] }>({
          step: "flashcards",
          lesson,
          extractMode,
          count: want,
          existing: flashcards.map((c) => c.front),
        });
        if (!out.flashcards?.length) break; // model gave up — stop rather than loop forever
        flashcards.push(...out.flashcards);
        setData({ lesson, flashcards: [...flashcards], quizzes: [], classification });
      }

      // 3. Quizzes, same pattern.
      const quizzes: ExtractedQuiz[] = [];
      while (quizzes.length < plan.quizzes) {
        const want = Math.min(QZ_PER_BATCH, plan.quizzes - quizzes.length);
        setProgress(`สร้างข้อสอบ… (${quizzes.length}/${plan.quizzes})`);
        const out = await step<{ quizzes: ExtractedQuiz[] }>({
          step: "quizzes",
          lesson,
          extractMode,
          count: want,
          existing: quizzes.map((q) => q.stem),
        });
        if (!out.quizzes?.length) break;
        quizzes.push(...out.quizzes);
        setData({ lesson, flashcards, quizzes: [...quizzes], classification });
      }
    } catch (e) {
      const timedOut = e instanceof DOMException && e.name === "TimeoutError";
      setError(
        timedOut
          ? "ขั้นตอนนี้ใช้เวลานานเกินไปแล้วถูกยกเลิก — ลองไฟล์ที่เล็กลง หรือลดระดับการขยายเนื้อหา"
          : e instanceof Error
            ? e.message
            : "เกิดข้อผิดพลาด",
      );
    } finally {
      setLoading(false);
      setProgress(null);
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
          source: file?.name ?? null,
          lesson: data.lesson,
          flashcards: data.flashcards,
          quizzes: data.quizzes,
        }),
      });
      const j = (await res.json()) as {
        lessonInserted?: number;
        fcInserted?: number;
        qzInserted?: number;
        errors?: string[];
        error?: string;
      };
      if (!res.ok || j.error) {
        setResult({ kind: "err", msg: j.error ?? "บันทึกไม่สำเร็จ" });
        return;
      }
      setResult({
        kind: "ok",
        msg: `บันทึกแล้ว: ${j.lessonInserted ?? 0} บทเรียน + ${j.fcInserted ?? 0} flashcards + ${
          j.qzInserted ?? 0
        } ข้อสอบ${j.errors?.length ? ` (มี error บางส่วน: ${j.errors.join(", ")})` : ""}`,
      });
      setData(null);
      setFile(null);
      if (fileInputRef.current) fileInputRef.current.value = "";
    } catch (e) {
      setResult({ kind: "err", msg: e instanceof Error ? e.message : "เกิดข้อผิดพลาด" });
    } finally {
      setSaving(false);
    }
  }

  return (
    <Card>
      <CardContent className="space-y-5 p-4">
        <div>
          <h3 className="font-bold">นำเข้าเนื้อหาด้วย AI</h3>
          <p className="text-xs text-muted-foreground">
            เลือกชั้นปี เทอม วิชา → อัปโหลดไฟล์ → AI สร้างบทเรียน flashcards
            และข้อสอบ → ตรวจแก้ก่อนบันทึก
          </p>
        </div>

        {/* ชั้นปี / เทอม / วิชา */}
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          <label className="block">
            <span className="mb-1 block text-xs font-semibold text-muted-foreground">
              ชั้นปี
            </span>
            <select
              value={year}
              onChange={(e) => pickYear(Number(e.target.value))}
              className="w-full rounded border p-2 text-sm"
            >
              {YEARS.map((y) => (
                <option key={y} value={y}>
                  ปี {y}
                </option>
              ))}
            </select>
          </label>

          <label className="block">
            <span className="mb-1 block text-xs font-semibold text-muted-foreground">
              เทอม
            </span>
            <select
              value={term}
              onChange={(e) => pickTerm(Number(e.target.value))}
              className="w-full rounded border p-2 text-sm"
            >
              <option value={1}>เทอม 1</option>
              <option value={2}>เทอม 2</option>
              <option value={3}>ภาคฤดูร้อน</option>
            </select>
          </label>

          <label className="block sm:col-span-2">
            <span className="mb-1 flex items-baseline justify-between gap-2 text-xs font-semibold text-muted-foreground">
              วิชา
              <button
                type="button"
                onClick={() => setAddingTopic((v) => !v)}
                className="font-normal underline hover:text-foreground"
              >
                {addingTopic ? "ยกเลิก" : "+ เพิ่มวิชาใหม่"}
              </button>
            </span>
            <select
              value={topicId}
              onChange={(e) => setTopicId(e.target.value)}
              className="w-full rounded border p-2 text-sm"
            >
              <option value="">— เลือกวิชา —</option>
              {visibleTopics.map((t) => (
                <option key={t.id} value={t.id}>
                  {topicLabel(t)}
                </option>
              ))}
            </select>
          </label>
        </div>

        {addingTopic && (
          <div className="space-y-2 rounded-lg border bg-muted/30 p-3">
            <p className="text-xs text-muted-foreground">
              วิชาใหม่จะถูกสร้างในปี {year} เทอม {term}
            </p>
            <div className="grid grid-cols-1 gap-2 sm:grid-cols-3">
              <input
                value={newTopicName}
                onChange={(e) => setNewTopicName(e.target.value)}
                placeholder="ชื่อวิชา เช่น ชีววิทยาของเซลล์"
                className="w-full rounded border p-2 text-sm sm:col-span-2"
              />
              <input
                value={newTopicCode}
                onChange={(e) => setNewTopicCode(e.target.value)}
                placeholder="รหัสวิชา (ไม่ใส่ก็ได้)"
                className="w-full rounded border p-2 text-sm"
              />
            </div>
            {systems.length > 1 && (
              <select
                value={newTopicSystem}
                onChange={(e) => setNewTopicSystem(e.target.value)}
                className="w-full rounded border p-2 text-sm"
              >
                {systems.map((s) => (
                  <option key={s.id} value={s.id}>
                    {s.name_th}
                  </option>
                ))}
              </select>
            )}
            <Button size="sm" onClick={addTopic} disabled={savingTopic || !newTopicName.trim()}>
              {savingTopic ? "กำลังเพิ่ม…" : "เพิ่มวิชา"}
            </Button>
          </div>
        )}

        {visibleTopics.length === 0 && !addingTopic && (
          <p className="text-xs text-amber-700">
            ยังไม่มีวิชาสำหรับปี {year} เทอม {term} — กด &quot;+ เพิ่มวิชาใหม่&quot; ด้านบน
          </p>
        )}

        {/* ระดับการขยายเนื้อหา */}
        <label className="block">
          <span className="mb-1 block text-xs font-semibold text-muted-foreground">
            ระดับการขยายเนื้อหา
          </span>
          <select
            value={extractMode}
            onChange={(e) => setExtractMode(e.target.value as ExtractMode)}
            className="w-full rounded border p-2 text-sm"
          >
            {(Object.keys(MODE_LABEL) as ExtractMode[]).map((m) => (
              <option key={m} value={m}>
                {MODE_LABEL[m]}
              </option>
            ))}
          </select>
        </label>

        {/* อัปโหลดไฟล์ */}
        <div>
          <input
            ref={fileInputRef}
            type="file"
            accept="application/pdf,image/png,image/jpeg,image/webp"
            onChange={(e) => setFile(e.target.files?.[0] ?? null)}
            className="sr-only"
          />
          <div
            role="button"
            tabIndex={0}
            onClick={() => fileInputRef.current?.click()}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                fileInputRef.current?.click();
              }
            }}
            onDragOver={(e) => {
              e.preventDefault();
              setDragOver(true);
            }}
            onDragLeave={() => setDragOver(false)}
            onDrop={(e) => {
              e.preventDefault();
              setDragOver(false);
              const dropped = e.dataTransfer.files?.[0];
              if (dropped) setFile(dropped);
            }}
            className={`w-full cursor-pointer rounded-lg border-2 border-dashed p-6 text-center text-sm transition-colors ${
              dragOver
                ? "border-brand bg-muted"
                : file
                  ? "border-emerald-300 bg-emerald-50/50"
                  : "border-muted-foreground/30 hover:border-brand hover:bg-muted/40"
            }`}
          >
            {file ? (
              <div className="flex items-center justify-center gap-2">
                <span className="truncate font-medium">{file.name}</span>
                <span className="shrink-0 text-muted-foreground">
                  ({Math.round(file.size / 1024)} KB)
                </span>
                <button
                  type="button"
                  onClick={(e) => {
                    e.stopPropagation();
                    setFile(null);
                    if (fileInputRef.current) fileInputRef.current.value = "";
                  }}
                  className="shrink-0 text-muted-foreground underline hover:text-rose-600"
                >
                  เอาออก
                </button>
              </div>
            ) : (
              <div className="space-y-1">
                <p className="font-semibold">แตะเพื่อเลือกไฟล์ หรือลากไฟล์มาวาง</p>
                <p className="text-xs text-muted-foreground">
                  PDF สูงสุด 32 MB · รูปภาพสูงสุด 4 MB
                </p>
              </div>
            )}
          </div>
        </div>

        {error && (
          <div className="rounded border border-rose-300 bg-rose-50 p-3 text-sm text-rose-800">
            {error}
          </div>
        )}

        <div className="flex items-center gap-3">
          <Button onClick={run} disabled={loading || !file || !topicId}>
            {loading ? "กำลังสร้าง…" : "เริ่มสร้างเนื้อหา"}
          </Button>
          {progress && <span className="text-xs text-muted-foreground">{progress}</span>}
        </div>

        {data && (
          <div className="space-y-4 border-t pt-4">
            <div className="flex items-center justify-between">
              <p className="font-bold">ตรวจแก้ก่อนบันทึก</p>
              <button
                onClick={() => setData(null)}
                className="text-xs text-muted-foreground underline hover:text-rose-600"
              >
                ทิ้งผลลัพธ์
              </button>
            </div>

            {extractMode !== "faithful" && (
              <p className="rounded border border-amber-300 bg-amber-50 p-2 text-xs text-amber-900">
                โหมดนี้ให้ AI แต่งเนื้อหาเพิ่มจากไฟล์ต้นฉบับ — หัวข้อที่ลงท้ายด้วย
                &quot;(เพิ่มโดย AI)&quot; ไม่ได้มาจากไฟล์ ต้องตรวจความถูกต้องก่อนบันทึก
              </p>
            )}

            {data.classification?.suggested_topic_id &&
              data.classification.suggested_topic_id !== topicId && (
                <div className="rounded border border-amber-300 bg-amber-50 p-2 text-xs text-amber-900">
                  AI คิดว่าไฟล์นี้เป็นวิชา{" "}
                  <b>
                    {topics.find((t) => t.id === data.classification!.suggested_topic_id)
                      ?.name_th ?? "ไม่พบในรายการ"}
                  </b>{" "}
                  ({Math.round(data.classification.confidence * 100)}%) —{" "}
                  {data.classification.reasoning}
                  <button
                    onClick={() => {
                      const s = topics.find(
                        (t) => t.id === data.classification!.suggested_topic_id,
                      );
                      if (!s) return;
                      setYear(s.year);
                      if (s.term) setTerm(s.term);
                      setTopicId(s.id);
                    }}
                    className="ml-1 underline"
                  >
                    เปลี่ยนไปวิชานี้
                  </button>
                </div>
              )}

            {/* บทเรียน */}
            <Card>
              <CardContent className="space-y-2 p-4">
                <p className="text-xs font-semibold text-muted-foreground">
                  บทเรียน · {data.lesson.layer} · {data.lesson.estimated_min} นาที
                </p>
                <input
                  value={data.lesson.title}
                  onChange={(e) =>
                    setData({ ...data, lesson: { ...data.lesson, title: e.target.value } })
                  }
                  className="w-full rounded border p-2 text-sm font-semibold"
                />
                <textarea
                  value={data.lesson.body_md}
                  onChange={(e) =>
                    setData({ ...data, lesson: { ...data.lesson, body_md: e.target.value } })
                  }
                  className="min-h-[200px] w-full rounded border p-2 font-mono text-sm"
                />
              </CardContent>
            </Card>

            {/* Flashcards */}
            <div>
              <p className="mb-2 font-semibold">Flashcards ({data.flashcards.length})</p>
              <div className="space-y-2">
                {data.flashcards.map((fc, i) => (
                  <Card key={i}>
                    <CardContent className="space-y-1 p-3">
                      <div className="flex items-center justify-between text-xs text-muted-foreground">
                        <span>{fc.difficulty}</span>
                        <button
                          onClick={() =>
                            setData({
                              ...data,
                              flashcards: data.flashcards.filter((_, x) => x !== i),
                            })
                          }
                          className="underline hover:text-rose-600"
                        >
                          ลบ
                        </button>
                      </div>
                      <textarea
                        value={fc.front}
                        onChange={(e) => {
                          const f = [...data.flashcards];
                          f[i] = { ...fc, front: e.target.value };
                          setData({ ...data, flashcards: f });
                        }}
                        className="w-full rounded border p-2 text-sm"
                        rows={2}
                      />
                      <textarea
                        value={fc.back}
                        onChange={(e) => {
                          const f = [...data.flashcards];
                          f[i] = { ...fc, back: e.target.value };
                          setData({ ...data, flashcards: f });
                        }}
                        className="w-full rounded border bg-muted/30 p-2 text-sm"
                        rows={2}
                      />
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {/* ข้อสอบ */}
            <div>
              <p className="mb-2 font-semibold">ข้อสอบ ({data.quizzes.length})</p>
              <div className="space-y-2">
                {data.quizzes.map((qz, i) => (
                  <Card key={i}>
                    <CardContent className="space-y-2 p-3">
                      <div className="flex items-center justify-between text-xs text-muted-foreground">
                        <span>
                          {qz.difficulty} · ตอบ {qz.correct_answer}
                        </span>
                        <button
                          onClick={() =>
                            setData({
                              ...data,
                              quizzes: data.quizzes.filter((_, x) => x !== i),
                            })
                          }
                          className="underline hover:text-rose-600"
                        >
                          ลบ
                        </button>
                      </div>
                      <p className="text-sm font-medium">{qz.stem}</p>
                      <ul className="space-y-0.5 text-xs">
                        {qz.choices.map((c) => (
                          <li
                            key={c.label}
                            className={c.label === qz.correct_answer ? "font-bold" : ""}
                          >
                            <span className="mr-1 font-semibold">{c.label}.</span>
                            {c.text}
                          </li>
                        ))}
                      </ul>
                      {qz.explanation && (
                        <p className="text-xs italic text-muted-foreground">{qz.explanation}</p>
                      )}
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {result && (
              <div
                className={`rounded border p-2 text-sm ${
                  result.kind === "ok"
                    ? "border-emerald-200 bg-emerald-50 text-emerald-800"
                    : "border-rose-200 bg-rose-50 text-rose-800"
                }`}
              >
                {result.msg}
              </div>
            )}

            <Button onClick={save} disabled={saving || loading || !topicId}>
              {saving
                ? "กำลังบันทึก…"
                : `บันทึกลงวิชา ${selectedTopic ? topicLabel(selectedTopic) : ""}`}
            </Button>
          </div>
        )}

        {!data && result && (
          <div
            className={`rounded border p-2 text-sm ${
              result.kind === "ok"
                ? "border-emerald-200 bg-emerald-50 text-emerald-800"
                : "border-rose-200 bg-rose-50 text-rose-800"
            }`}
          >
            {result.msg}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
