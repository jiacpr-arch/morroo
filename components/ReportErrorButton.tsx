"use client";

import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import {
  Flag,
  CheckCircle2,
  Loader2,
  AlertTriangle,
  Sparkles,
  X,
} from "lucide-react";

type Reason =
  | "wrong_answer"
  | "unclear_question"
  | "typo"
  | "outdated"
  | "duplicate"
  | "other";

const REASON_OPTIONS: { value: Reason; label: string; icon: string }[] = [
  { value: "wrong_answer", label: "เฉลยผิด / ไม่ตรงกับคำตอบที่ถูก", icon: "❌" },
  { value: "unclear_question", label: "โจทย์กำกวม / ไม่ชัดเจน", icon: "❓" },
  { value: "typo", label: "พิมพ์ผิด / คำสะกดผิด", icon: "✏️" },
  { value: "outdated", label: "ข้อมูลล้าสมัย (guideline ใหม่)", icon: "📅" },
  { value: "duplicate", label: "ซ้ำกับข้ออื่น", icon: "📑" },
  { value: "other", label: "อื่น ๆ", icon: "💬" },
];

interface ReportErrorButtonProps {
  questionId: string;
  /** A/B/C/D/E choice labels available for "suggested answer" dropdown. */
  choiceLabels?: string[];
  /** Pre-select a reason when user clicks the button. Defaults to wrong_answer. */
  defaultReason?: Reason;
}

export default function ReportErrorButton({
  questionId,
  choiceLabels,
  defaultReason = "wrong_answer",
}: ReportErrorButtonProps) {
  const [open, setOpen] = useState(false);
  const [reason, setReason] = useState<Reason>(defaultReason);
  const [note, setNote] = useState("");
  const [suggested, setSuggested] = useState<string>("");
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [pointsTotal, setPointsTotal] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  const resetAndClose = () => {
    setOpen(false);
    // Keep submitted-state so the pill stays visible; but clear form
    setNote("");
    setSuggested("");
    setReason(defaultReason);
    setError(null);
  };

  const handleSubmit = async () => {
    setSubmitting(true);
    setError(null);
    try {
      const res = await fetch("/api/mcq/report-error", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          question_id: questionId,
          reason,
          note: note.trim() || undefined,
          suggested_answer:
            reason === "wrong_answer" && suggested ? suggested : undefined,
        }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data?.error || "แจ้งไม่สำเร็จ กรุณาลองใหม่");
        return;
      }
      setSubmitted(true);
      setPointsTotal(
        typeof data?.reporter_points === "number" ? data.reporter_points : null
      );
      setTimeout(resetAndClose, 150);
    } catch {
      setError("เกิดข้อผิดพลาดในการเชื่อมต่อ");
    } finally {
      setSubmitting(false);
    }
  };

  // Already reported — show a compact success pill
  if (submitted && !open) {
    return (
      <div className="flex items-center gap-2 text-xs">
        <Badge className="bg-green-100 text-green-700 gap-1">
          <CheckCircle2 className="h-3.5 w-3.5" /> แจ้งเฉลยแล้ว ขอบคุณ!
        </Badge>
        {pointsTotal !== null && (
          <span className="text-muted-foreground inline-flex items-center gap-1">
            <Sparkles className="h-3 w-3 text-amber-500" />
            คะแนน Bug Hunter ของคุณ:{" "}
            <span className="font-semibold text-amber-700">{pointsTotal}</span>
          </span>
        )}
      </div>
    );
  }

  if (!open) {
    return (
      <button
        onClick={() => setOpen(true)}
        type="button"
        className="inline-flex items-center gap-1.5 text-xs text-muted-foreground hover:text-red-600 hover:underline"
      >
        <Flag className="h-3.5 w-3.5" />
        เฉลยไม่ถูก? แจ้งให้เราแก้ไข (รับแต้ม Bug Hunter)
      </button>
    );
  }

  return (
    <Card className="border-amber-200 bg-amber-50/40">
      <CardContent className="p-4 space-y-3">
        <div className="flex items-start justify-between gap-2">
          <h4 className="text-sm font-bold flex items-center gap-1.5 text-amber-800">
            <AlertTriangle className="h-4 w-4" />
            แจ้งปัญหาของข้อสอบข้อนี้
          </h4>
          <button
            type="button"
            onClick={resetAndClose}
            disabled={submitting}
            aria-label="ปิด"
            className="text-muted-foreground hover:text-foreground"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
        <p className="text-xs text-muted-foreground">
          คนแรกที่แจ้งแต่ละข้อจะได้รับ <span className="font-semibold">+1 คะแนน</span>{" "}
          ทันที และถ้าแอดมินยืนยันว่าเฉลยผิดจริงจะได้{" "}
          <span className="font-semibold">+10 คะแนน Bug Hunter</span> เพิ่ม
        </p>

        {/* Reason radios */}
        <div className="space-y-1.5">
          {REASON_OPTIONS.map((opt) => (
            <label
              key={opt.value}
              className={`flex items-start gap-2 p-2 rounded-lg border cursor-pointer text-sm transition-colors ${
                reason === opt.value
                  ? "border-amber-400 bg-white"
                  : "border-transparent hover:bg-white/60"
              }`}
            >
              <input
                type="radio"
                name="mcq-report-reason"
                className="mt-1"
                value={opt.value}
                checked={reason === opt.value}
                onChange={() => setReason(opt.value)}
              />
              <span>
                <span className="mr-1">{opt.icon}</span>
                {opt.label}
              </span>
            </label>
          ))}
        </div>

        {/* Suggested answer (only when reason = wrong_answer) */}
        {reason === "wrong_answer" && choiceLabels && choiceLabels.length > 0 && (
          <div>
            <label className="text-xs font-medium text-muted-foreground mb-1 block">
              ตามคุณ คำตอบที่ถูกน่าจะเป็น (ไม่บังคับ)
            </label>
            <div className="flex flex-wrap gap-1.5">
              {choiceLabels.map((label) => (
                <button
                  key={label}
                  type="button"
                  onClick={() =>
                    setSuggested((prev) => (prev === label ? "" : label))
                  }
                  className={`w-9 h-9 rounded-full border text-sm font-semibold transition-colors ${
                    suggested === label
                      ? "bg-amber-500 border-amber-500 text-white"
                      : "bg-white border-border text-foreground hover:border-amber-400"
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>
        )}

        {/* Note */}
        <div>
          <label
            className="text-xs font-medium text-muted-foreground mb-1 block"
            htmlFor="mcq-report-note"
          >
            รายละเอียดเพิ่มเติม (ไม่บังคับ)
          </label>
          <Textarea
            id="mcq-report-note"
            value={note}
            onChange={(e) => setNote(e.target.value)}
            placeholder="เช่น เฉลยเขียน A แต่ตามคำอธิบายควรเป็น C เพราะ..."
            maxLength={1000}
            className="min-h-[70px] text-sm bg-white"
          />
          <p className="text-[10px] text-right text-muted-foreground mt-1">
            {note.length}/1000
          </p>
        </div>

        {error && (
          <div className="text-xs text-red-600 bg-red-50 border border-red-200 rounded px-2 py-1.5">
            {error}
          </div>
        )}

        <div className="flex gap-2 justify-end pt-1">
          <Button
            variant="outline"
            size="sm"
            onClick={resetAndClose}
            disabled={submitting}
          >
            ยกเลิก
          </Button>
          <Button
            size="sm"
            onClick={handleSubmit}
            disabled={submitting}
            className="bg-amber-500 hover:bg-amber-600 text-white gap-1.5"
          >
            {submitting ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" /> กำลังส่ง...
              </>
            ) : (
              <>
                <Flag className="h-4 w-4" /> ส่งรายงาน
              </>
            )}
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
