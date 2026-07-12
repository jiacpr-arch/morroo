"use client";

import { useEffect, useState } from "react";
import { MessageCircleQuestion, Send, Loader2, CheckCircle2, AlertTriangle } from "lucide-react";
import { dashCard, btnPrimary, btnGhost, btnMd, inputBase, errorBox } from "@/components/courses/course-ui";
import { cn } from "@/lib/utils";

const STAGES = [
  "กำลังบันทึกคำถาม…",
  "กำลังให้ DeepSeek ตอบคำถามเชิงลึก…",
  "กำลังจัดหมวดและสร้างรูปประกอบ…",
  "เกือบเสร็จแล้ว…",
];

interface SubmitResult {
  id: string;
  status: "draft_ready" | "failed";
  message: string;
}

async function submitStudentQuestion(input: {
  question: string;
  studentName: string;
  studentContact?: string;
}): Promise<SubmitResult> {
  const res = await fetch("/api/acls/student-question", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      question: input.question.trim(),
      studentName: input.studentName.trim() || null,
      studentContact: input.studentContact?.trim() || null,
    }),
  });
  const data = await res.json().catch(() => ({}));
  if (!res.ok && res.status !== 202) {
    throw new Error(data?.error || `เกิดข้อผิดพลาด (${res.status})`);
  }
  return data as SubmitResult;
}

// Q&A submission form embedded at the bottom of the Q&A Deep index — lets a
// student ask a question that isn't already answered. AI drafts an answer
// (DeepSeek) + cover image (OpenAI); an admin reviews before it goes live.
// Ported from acls-emr's src/components/StudentQuestionForm.jsx (as an
// inline card instead of a modal — this lives permanently at the page
// bottom rather than behind a trigger button).
export default function StudentQuestionForm() {
  const [question, setQuestion] = useState("");
  const [name, setName] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<SubmitResult | null>(null);
  const [error, setError] = useState("");
  const [stageIdx, setStageIdx] = useState(0);

  // Cycle through friendly progress messages while waiting (~30s)
  useEffect(() => {
    if (!submitting) return;
    setStageIdx(0);
    const id = setInterval(() => {
      setStageIdx((i) => Math.min(i + 1, STAGES.length - 1));
    }, 7000);
    return () => clearInterval(id);
  }, [submitting]);

  const canSubmit = question.trim().length >= 5 && !submitting;

  const handleSubmit = async (e?: React.FormEvent) => {
    e?.preventDefault();
    if (!canSubmit) return;
    setSubmitting(true);
    setError("");
    setResult(null);
    try {
      const data = await submitStudentQuestion({ question, studentName: name });
      setResult(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "ส่งคำถามไม่สำเร็จ");
    }
    setSubmitting(false);
  };

  const reset = () => {
    setResult(null);
    setQuestion("");
    setName("");
  };

  return (
    <section className={cn(dashCard, "space-y-3")}>
      <div className="inline-flex items-center gap-2">
        <div className="inline-flex h-9 w-9 items-center justify-center rounded-lg bg-blue-500/15 text-blue-600 dark:text-blue-400">
          <MessageCircleQuestion size={18} strokeWidth={2.2} />
        </div>
        <div>
          <div className="text-base font-bold text-foreground">ถามคำถามใหม่</div>
          <div className="text-xs text-muted-foreground">
            ยังไม่เจอคำตอบที่ต้องการ? ถามเลย — AI จะร่างคำตอบเชิงลึก รออาจารย์ตรวจก่อนเผยแพร่
          </div>
        </div>
      </div>

      {result ? (
        <ResultPanel result={result} onReset={reset} />
      ) : (
        <form onSubmit={handleSubmit} className="space-y-3">
          <label className="block">
            <span className="mb-1 block text-xs font-semibold text-foreground/80">
              คำถามของคุณ <span className="text-red-500">*</span>
            </span>
            <textarea
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              rows={5}
              maxLength={2000}
              placeholder="เช่น  Epinephrine ให้ทุกกี่นาทีใน asystole และเพราะอะไรจึงให้ทุก 3-5 นาที?"
              disabled={submitting}
              className={cn(inputBase, "resize-y disabled:opacity-60")}
            />
            <div className="mt-1 flex justify-between text-[11px] text-muted-foreground">
              <span>อย่างน้อย 5 ตัวอักษร</span>
              <span>{question.length}/2000</span>
            </div>
          </label>

          <label className="block">
            <span className="mb-1 block text-xs font-semibold text-foreground/80">
              ชื่อ <span className="font-normal text-muted-foreground">(ไม่บังคับ)</span>
            </span>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              maxLength={80}
              placeholder="ชื่อ-ห้องเรียน-รุ่น"
              disabled={submitting}
              className={cn(inputBase, "disabled:opacity-60")}
            />
          </label>

          {error && (
            <div className={errorBox}>
              <AlertTriangle size={14} strokeWidth={2.2} className="shrink-0" /> {error}
            </div>
          )}

          {submitting && (
            <div
              className="flex items-start gap-2 rounded-lg border-l-4 border-l-blue-500 bg-blue-500/5 p-2.5"
              aria-live="polite"
            >
              <Loader2 size={14} strokeWidth={2.2} className="mt-0.5 shrink-0 animate-spin text-blue-600 dark:text-blue-400" />
              <div className="space-y-1">
                <div className="text-xs font-bold text-foreground">{STAGES[stageIdx]}</div>
                <div className="text-[11px] text-muted-foreground">
                  ระบบกำลังให้ DeepSeek ตอบและสร้างรูป — โดยปกติใช้เวลาประมาณ 15-40 วินาที กรุณาอย่าปิดหน้าจอ
                </div>
              </div>
            </div>
          )}

          <button type="submit" disabled={!canSubmit} className={cn(btnPrimary, btnMd, "w-full")}>
            {submitting ? (
              <>
                <Loader2 size={14} strokeWidth={2.2} className="animate-spin" /> กำลังประมวลผล…
              </>
            ) : (
              <>
                <Send size={14} strokeWidth={2.2} /> ส่งคำถาม
              </>
            )}
          </button>

          <p className="text-center text-[11px] text-muted-foreground">
            คำตอบที่ได้เป็นการสร้างจาก AI — อาจารย์จะตรวจสอบก่อนนำขึ้นแสดงในหน้า Q&amp;A
          </p>
        </form>
      )}
    </section>
  );
}

function ResultPanel({ result, onReset }: { result: SubmitResult; onReset: () => void }) {
  const isFailed = result.status === "failed";
  return (
    <div className="space-y-3 py-1">
      <div
        className={cn(
          "flex items-start gap-2 rounded-lg border-l-4 p-3",
          isFailed ? "border-l-amber-500 bg-amber-500/5" : "border-l-emerald-500 bg-emerald-500/5",
        )}
      >
        {isFailed ? (
          <AlertTriangle size={16} strokeWidth={2.2} className="mt-0.5 shrink-0 text-amber-600 dark:text-amber-400" />
        ) : (
          <CheckCircle2 size={16} strokeWidth={2.2} className="mt-0.5 shrink-0 text-emerald-600 dark:text-emerald-400" />
        )}
        <div className="space-y-1">
          <div className="text-sm font-bold text-foreground">
            {isFailed ? "บันทึกคำถามแล้ว" : "ส่งคำถามสำเร็จ"}
          </div>
          <div className="text-xs leading-relaxed text-foreground/80">{result.message}</div>
          <div className="break-all pt-1 font-mono text-[10px] text-muted-foreground">รหัสคำถาม: {result.id}</div>
        </div>
      </div>
      <button onClick={onReset} className={cn(btnGhost, btnMd, "w-full")}>
        ถามคำถามใหม่
      </button>
    </div>
  );
}
