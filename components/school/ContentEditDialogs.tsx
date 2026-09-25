"use client";

import { useEffect, useMemo, useState } from "react";
import { Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogBody, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { createClient } from "@/lib/supabase/client";
import type { SchoolDifficulty } from "@/lib/types-school";

/**
 * Edit / move dialogs for the admin content library. Each one is mounted only
 * while open, so its form state starts fresh from the row it edits. They only
 * collect and validate input; the library panel does the writes (and the
 * reload) through `onSubmit`, the same way it already handles delete/reorder.
 */

export interface TopicOption {
  id: string;
  year: number;
  term?: number | null;
  name_th: string;
  code?: string | null;
  school_systems?: { name_th: string; icon?: string } | null;
}

const DIFFICULTIES: { value: SchoolDifficulty; label: string }[] = [
  { value: "easy", label: "ง่าย" },
  { value: "medium", label: "กลาง" },
  { value: "hard", label: "ยาก" },
];

const INPUT = "w-full rounded border p-2 text-sm";

function termText(term: number | null | undefined) {
  if (term === 3) return "ภาคฤดูร้อน";
  if (term) return `เทอม ${term}`;
  return null;
}

function Field({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-semibold text-muted-foreground">{label}</span>
      {children}
    </label>
  );
}

/** Subject picker grouped by ชั้นปี, labelled the way the admin reads the curriculum. */
export function TopicSelect({
  topics,
  value,
  onChange,
  currentTopicId,
  placeholder,
}: {
  topics: TopicOption[];
  value: string;
  onChange: (id: string) => void;
  currentTopicId: string;
  placeholder?: string;
}) {
  const byYear = useMemo(() => {
    const map = new Map<number, TopicOption[]>();
    for (const t of topics) {
      const list = map.get(t.year) ?? [];
      list.push(t);
      map.set(t.year, list);
    }
    return Array.from(map.entries()).sort(([a], [b]) => a - b);
  }, [topics]);

  return (
    <select value={value} onChange={(e) => onChange(e.target.value)} className={INPUT}>
      {placeholder && <option value="">{placeholder}</option>}
      {byYear.map(([year, list]) => (
        <optgroup key={year} label={`ปี ${year}`}>
          {list.map((t) => {
            const term = termText(t.term);
            const parts = [t.code, t.name_th, term].filter(Boolean).join(" · ");
            return (
              <option key={t.id} value={t.id}>
                {t.school_systems?.icon ? `${t.school_systems.icon} ` : ""}
                {parts}
                {t.id === currentTopicId ? " (วิชาปัจจุบัน)" : ""}
              </option>
            );
          })}
        </optgroup>
      ))}
    </select>
  );
}

function Footer({
  busy,
  disabled,
  onClose,
  submitLabel,
}: {
  busy: boolean;
  disabled?: boolean;
  onClose: () => void;
  submitLabel: string;
}) {
  return (
    <DialogFooter>
      <Button type="button" variant="outline" onClick={onClose} disabled={busy}>
        ยกเลิก
      </Button>
      <Button type="submit" disabled={busy || disabled}>
        {busy && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {submitLabel}
      </Button>
    </DialogFooter>
  );
}

function ErrorLine({ msg }: { msg: string | null }) {
  if (!msg) return null;
  return <p className="text-sm text-rose-700">{msg}</p>;
}

// ---------------------------------------------------------------------------
// Move a whole uploaded file (batch) to another subject
// ---------------------------------------------------------------------------

export function MoveBatchDialog({
  topics,
  fromTopicId,
  sourceLabel,
  summary,
  busy,
  onClose,
  onSubmit,
}: {
  topics: TopicOption[];
  fromTopicId: string;
  sourceLabel: string;
  summary: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (toTopicId: string) => void;
}) {
  const [toTopicId, setToTopicId] = useState("");
  const invalid = !toTopicId || toTopicId === fromTopicId;

  return (
    <Dialog open onClose={busy ? undefined : onClose} dismissible={!busy}>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (!invalid) onSubmit(toTopicId);
        }}
      >
        <DialogHeader>
          <DialogTitle>ย้ายทั้งชุดไปวิชาอื่น</DialogTitle>
        </DialogHeader>
        <DialogBody>
          <div className="rounded border bg-muted/40 p-3 text-sm">
            <p className="font-medium break-all">{sourceLabel}</p>
            <p className="text-xs text-muted-foreground">{summary}</p>
          </div>
          <Field label="ย้ายไปวิชา">
            <TopicSelect
              topics={topics}
              value={toTopicId}
              onChange={setToTopicId}
              currentTopicId={fromTopicId}
              placeholder="— เลือกวิชาที่ถูกต้อง —"
            />
          </Field>
          {toTopicId === fromTopicId && (
            <ErrorLine msg="นี่คือวิชาเดิม — เลือกวิชาอื่น" />
          )}
          <p className="text-xs text-muted-foreground">
            บทเรียน flashcards ข้อสอบ และรูปสรุปของบท ที่มาจากไฟล์นี้จะย้ายไปทั้งหมด
            บทเรียนจะต่อท้ายลำดับบทของวิชาใหม่ ความคืบหน้าของนักเรียนยังอยู่ครบ
          </p>
        </DialogBody>
        <Footer busy={busy} disabled={invalid} onClose={onClose} submitLabel="ย้ายวิชา" />
      </form>
    </Dialog>
  );
}

// ---------------------------------------------------------------------------
// Lesson: title, reading time, subject (+ jump to the body/image editor)
// ---------------------------------------------------------------------------

export interface LessonEdit {
  title: string;
  estimated_min: number;
  toTopicId: string;
}

export function LessonEditDialog({
  lesson,
  topics,
  fromTopicId,
  busy,
  onClose,
  onSubmit,
  onEditBody,
}: {
  lesson: { id: string; title: string; estimated_min: number };
  topics: TopicOption[];
  fromTopicId: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (edit: LessonEdit) => void;
  onEditBody?: () => void;
}) {
  const [title, setTitle] = useState(lesson.title);
  const [minutes, setMinutes] = useState(String(lesson.estimated_min));
  const [toTopicId, setToTopicId] = useState(fromTopicId);

  const mins = Number(minutes);
  const error = !title.trim()
    ? "ชื่อบทต้องไม่ว่าง"
    : !Number.isInteger(mins) || mins < 1
      ? "เวลาอ่านต้องเป็นจำนวนเต็มตั้งแต่ 1 นาที"
      : null;
  const moving = toTopicId !== fromTopicId;

  return (
    <Dialog open onClose={busy ? undefined : onClose} dismissible={!busy}>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (!error) onSubmit({ title: title.trim(), estimated_min: mins, toTopicId });
        }}
      >
        <DialogHeader>
          <DialogTitle>แก้ไขบทเรียน</DialogTitle>
        </DialogHeader>
        <DialogBody>
          <Field label="ชื่อบท">
            <input value={title} onChange={(e) => setTitle(e.target.value)} className={INPUT} />
          </Field>
          <Field label="เวลาอ่าน (นาที)">
            <input
              type="number"
              min={1}
              step={1}
              value={minutes}
              onChange={(e) => setMinutes(e.target.value)}
              className={INPUT}
            />
          </Field>
          <Field label="วิชา">
            <TopicSelect
              topics={topics}
              value={toTopicId}
              onChange={setToTopicId}
              currentTopicId={fromTopicId}
            />
          </Field>
          {moving && (
            <p className="rounded border border-amber-300 bg-amber-50 p-2 text-xs text-amber-900">
              ย้ายเฉพาะบทนี้ (พร้อมรูปสรุปของบท) ไปต่อท้ายวิชาใหม่ — flashcards และข้อสอบจากไฟล์เดียวกัน
              ไม่ย้ายตาม ถ้าต้องการย้ายทั้งไฟล์ ใช้ปุ่ม &quot;ย้ายวิชา&quot; ที่ชุดไฟล์ด้านบน
            </p>
          )}
          <ErrorLine msg={error} />
          {onEditBody && (
            <Button type="button" variant="outline" size="sm" onClick={onEditBody} disabled={busy}>
              แก้เนื้อหา + รูป ของบทนี้ →
            </Button>
          )}
        </DialogBody>
        <Footer
          busy={busy}
          disabled={!!error}
          onClose={onClose}
          submitLabel={moving ? "บันทึก + ย้ายวิชา" : "บันทึก"}
        />
      </form>
    </Dialog>
  );
}

// ---------------------------------------------------------------------------
// Flashcard / quiz: full content + subject, loaded fresh when the dialog opens
// ---------------------------------------------------------------------------

type LoadState<T> = { status: "loading" } | { status: "error"; msg: string } | { status: "ready"; row: T };

function useRow<T>(table: string, id: string, columns: string): LoadState<T> {
  const [state, setState] = useState<LoadState<T>>({ status: "loading" });
  useEffect(() => {
    let cancelled = false;
    (async () => {
      const { data, error } = await createClient().from(table).select(columns).eq("id", id).maybeSingle();
      if (cancelled) return;
      if (error) setState({ status: "error", msg: error.message });
      else if (!data) setState({ status: "error", msg: "ไม่พบรายการนี้ (อาจถูกลบไปแล้ว)" });
      else setState({ status: "ready", row: data as T });
    })();
    return () => {
      cancelled = true;
    };
  }, [table, id, columns]);
  return state;
}

function Loading({ state }: { state: LoadState<unknown> }) {
  if (state.status === "loading") {
    return (
      <div className="flex justify-center py-8">
        <Loader2 className="h-6 w-6 animate-spin text-brand" />
      </div>
    );
  }
  if (state.status === "error") return <ErrorLine msg={state.msg} />;
  return null;
}

export interface FlashcardEdit {
  front: string;
  back: string;
  difficulty: SchoolDifficulty;
  topic_id: string;
}

interface FlashcardRow {
  front: string;
  back: string;
  difficulty: SchoolDifficulty | null;
}

export function FlashcardEditDialog({
  id,
  topics,
  fromTopicId,
  busy,
  onClose,
  onSubmit,
}: {
  id: string;
  topics: TopicOption[];
  fromTopicId: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (edit: FlashcardEdit) => void;
}) {
  const state = useRow<FlashcardRow>("school_flashcards", id, "front, back, difficulty");
  return (
    <Dialog open onClose={busy ? undefined : onClose} dismissible={!busy}>
      <DialogHeader>
        <DialogTitle>แก้ไข Flashcard</DialogTitle>
      </DialogHeader>
      {state.status === "ready" ? (
        <FlashcardForm
          row={state.row}
          topics={topics}
          fromTopicId={fromTopicId}
          busy={busy}
          onClose={onClose}
          onSubmit={onSubmit}
        />
      ) : (
        <DialogBody>
          <Loading state={state} />
        </DialogBody>
      )}
    </Dialog>
  );
}

function FlashcardForm({
  row,
  topics,
  fromTopicId,
  busy,
  onClose,
  onSubmit,
}: {
  row: FlashcardRow;
  topics: TopicOption[];
  fromTopicId: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (edit: FlashcardEdit) => void;
}) {
  const [front, setFront] = useState(row.front);
  const [back, setBack] = useState(row.back);
  const [difficulty, setDifficulty] = useState<SchoolDifficulty>(row.difficulty ?? "medium");
  const [topicId, setTopicId] = useState(fromTopicId);
  const error = !front.trim() || !back.trim() ? "ด้านหน้าและด้านหลังต้องไม่ว่าง" : null;

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        if (!error) onSubmit({ front: front.trim(), back: back.trim(), difficulty, topic_id: topicId });
      }}
    >
      <DialogBody>
        <Field label="ด้านหน้า (คำถาม)">
          <textarea value={front} onChange={(e) => setFront(e.target.value)} className={`${INPUT} min-h-[80px]`} />
        </Field>
        <Field label="ด้านหลัง (คำตอบ)">
          <textarea value={back} onChange={(e) => setBack(e.target.value)} className={`${INPUT} min-h-[100px]`} />
        </Field>
        <DifficultyField value={difficulty} onChange={setDifficulty} />
        <Field label="วิชา">
          <TopicSelect topics={topics} value={topicId} onChange={setTopicId} currentTopicId={fromTopicId} />
        </Field>
        <ErrorLine msg={error} />
      </DialogBody>
      <Footer
        busy={busy}
        disabled={!!error}
        onClose={onClose}
        submitLabel={topicId !== fromTopicId ? "บันทึก + ย้ายวิชา" : "บันทึก"}
      />
    </form>
  );
}

export interface QuizEdit {
  stem: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string | null;
  difficulty: SchoolDifficulty;
  topic_id: string;
}

interface QuizRow {
  stem: string;
  choices: { label: string; text: string }[] | null;
  correct_answer: string;
  explanation: string | null;
  difficulty: SchoolDifficulty | null;
}

export function QuizEditDialog({
  id,
  topics,
  fromTopicId,
  busy,
  onClose,
  onSubmit,
}: {
  id: string;
  topics: TopicOption[];
  fromTopicId: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (edit: QuizEdit) => void;
}) {
  const state = useRow<QuizRow>(
    "school_quizzes",
    id,
    "stem, choices, correct_answer, explanation, difficulty",
  );
  return (
    <Dialog open onClose={busy ? undefined : onClose} dismissible={!busy} className="max-w-2xl">
      <DialogHeader>
        <DialogTitle>แก้ไขข้อสอบ</DialogTitle>
      </DialogHeader>
      {state.status === "ready" ? (
        <QuizForm
          row={state.row}
          topics={topics}
          fromTopicId={fromTopicId}
          busy={busy}
          onClose={onClose}
          onSubmit={onSubmit}
        />
      ) : (
        <DialogBody>
          <Loading state={state} />
        </DialogBody>
      )}
    </Dialog>
  );
}

function QuizForm({
  row,
  topics,
  fromTopicId,
  busy,
  onClose,
  onSubmit,
}: {
  row: QuizRow;
  topics: TopicOption[];
  fromTopicId: string;
  busy: boolean;
  onClose: () => void;
  onSubmit: (edit: QuizEdit) => void;
}) {
  const [stem, setStem] = useState(row.stem);
  // Labels (A–E) stay as imported; only the choice text is editable.
  const [choices, setChoices] = useState(row.choices ?? []);
  const [correct, setCorrect] = useState(row.correct_answer);
  const [explanation, setExplanation] = useState(row.explanation ?? "");
  const [difficulty, setDifficulty] = useState<SchoolDifficulty>(row.difficulty ?? "medium");
  const [topicId, setTopicId] = useState(fromTopicId);

  const error = !stem.trim()
    ? "โจทย์ต้องไม่ว่าง"
    : choices.length === 0 || choices.some((c) => !c.text.trim())
      ? "ตัวเลือกทุกข้อต้องมีข้อความ"
      : !choices.some((c) => c.label === correct)
        ? "เลือกคำตอบที่ถูกต้อง"
        : null;

  function setChoiceText(i: number, text: string) {
    setChoices((prev) => prev.map((c, x) => (x === i ? { ...c, text } : c)));
  }

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        if (error) return;
        onSubmit({
          stem: stem.trim(),
          choices: choices.map((c) => ({ label: c.label, text: c.text.trim() })),
          correct_answer: correct,
          explanation: explanation.trim() || null,
          difficulty,
          topic_id: topicId,
        });
      }}
    >
      <DialogBody>
        <Field label="โจทย์">
          <textarea value={stem} onChange={(e) => setStem(e.target.value)} className={`${INPUT} min-h-[100px]`} />
        </Field>
        <div className="space-y-2">
          <span className="block text-xs font-semibold text-muted-foreground">
            ตัวเลือก — กดวงกลมหน้าข้อที่ถูก
          </span>
          {choices.map((c, i) => (
            <div key={c.label} className="flex items-center gap-2">
              <input
                type="radio"
                name="correct"
                aria-label={`คำตอบที่ถูกคือ ${c.label}`}
                checked={correct === c.label}
                onChange={() => setCorrect(c.label)}
              />
              <span className="w-5 shrink-0 text-sm font-bold">{c.label}.</span>
              <input value={c.text} onChange={(e) => setChoiceText(i, e.target.value)} className={INPUT} />
            </div>
          ))}
        </div>
        <Field label="คำอธิบายเฉลย">
          <textarea
            value={explanation}
            onChange={(e) => setExplanation(e.target.value)}
            className={`${INPUT} min-h-[80px]`}
          />
        </Field>
        <DifficultyField value={difficulty} onChange={setDifficulty} />
        <Field label="วิชา">
          <TopicSelect topics={topics} value={topicId} onChange={setTopicId} currentTopicId={fromTopicId} />
        </Field>
        <ErrorLine msg={error} />
      </DialogBody>
      <Footer
        busy={busy}
        disabled={!!error}
        onClose={onClose}
        submitLabel={topicId !== fromTopicId ? "บันทึก + ย้ายวิชา" : "บันทึก"}
      />
    </form>
  );
}

function DifficultyField({
  value,
  onChange,
}: {
  value: SchoolDifficulty;
  onChange: (d: SchoolDifficulty) => void;
}) {
  return (
    <Field label="ความยาก">
      <select
        value={value}
        onChange={(e) => onChange(e.target.value as SchoolDifficulty)}
        className={INPUT}
      >
        {DIFFICULTIES.map((d) => (
          <option key={d.value} value={d.value}>
            {d.label}
          </option>
        ))}
      </select>
    </Field>
  );
}
