"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Loader2, Star, AlertTriangle, Coins, CheckCircle2 } from "lucide-react";

type DifficultyVote = "too_easy" | "just_right" | "too_hard";

const DIFFICULTY_OPTIONS: { value: DifficultyVote; label: string; emoji: string }[] = [
  { value: "too_easy", label: "ง่ายไป", emoji: "😴" },
  { value: "just_right", label: "กำลังดี", emoji: "👍" },
  { value: "too_hard", label: "ยากไป", emoji: "🥵" },
];

interface FeedbackCardProps {
  sessionId: string;
  initialSubmitted?: boolean;
  onSubmitted?: (coinsAwarded: number, totalCoins: number | null) => void;
}

function StarPicker({
  value,
  onChange,
  label,
}: {
  value: number;
  onChange: (v: number) => void;
  label: string;
}) {
  return (
    <div>
      <p className="text-sm font-medium text-gray-700 mb-1.5">{label}</p>
      <div className="flex gap-1">
        {[1, 2, 3, 4, 5].map((n) => {
          const filled = value >= n;
          return (
            <button
              key={n}
              type="button"
              onClick={() => onChange(n)}
              className="p-1 transition-transform hover:scale-110"
              aria-label={`${n} ดาว`}
            >
              <Star
                className={`h-6 w-6 ${
                  filled ? "fill-amber-400 text-amber-400" : "text-gray-300"
                }`}
              />
            </button>
          );
        })}
      </div>
    </div>
  );
}

export default function FeedbackCard({
  sessionId,
  initialSubmitted = false,
  onSubmitted,
}: FeedbackCardProps) {
  const [submitted, setSubmitted] = useState(initialSubmitted);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  // Parent may learn about an already-submitted feedback asynchronously
  // (on page reload) after this component has mounted — keep in sync.
  useEffect(() => {
    if (initialSubmitted) setSubmitted(true);
  }, [initialSubmitted]);

  const [caseRating, setCaseRating] = useState(0);
  const [difficultyVote, setDifficultyVote] = useState<DifficultyVote | null>(null);
  const [examinerFairness, setExaminerFairness] = useState(0);
  const [comment, setComment] = useState("");
  const [flagIssue, setFlagIssue] = useState(false);

  const canSubmit =
    caseRating > 0 && difficultyVote !== null && examinerFairness > 0 && !submitting;

  async function handleSubmit() {
    if (!canSubmit) return;
    setError("");
    setSubmitting(true);

    try {
      const res = await fetch("/api/longcase/feedback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          sessionId,
          case_rating: caseRating,
          difficulty_vote: difficultyVote,
          examiner_fairness: examinerFairness,
          comment: comment.trim() || null,
          flag_issue: flagIssue,
        }),
      });
      const data = await res.json();
      if (!res.ok) {
        setError(data?.error || "ส่ง feedback ไม่สำเร็จ");
        return;
      }
      setSubmitted(true);
      onSubmitted?.(data.coins_awarded ?? 10, data.meq_coins ?? null);
    } catch {
      setError("เกิดข้อผิดพลาด กรุณาลองใหม่");
    } finally {
      setSubmitting(false);
    }
  }

  if (submitted) {
    return (
      <div className="rounded-xl border-2 border-green-300 bg-green-50 p-5 text-center space-y-2">
        <CheckCircle2 className="h-10 w-10 text-green-600 mx-auto" />
        <p className="font-semibold text-green-800">
          ขอบคุณสำหรับ feedback! 🙏
        </p>
        <p className="text-sm text-green-700 inline-flex items-center gap-1.5">
          <Coins className="h-4 w-4" /> ได้รับ +10 coins เข้ากระเป๋าแล้ว
        </p>
      </div>
    );
  }

  return (
    <div className="rounded-xl border-2 border-amber-300 bg-white p-5 space-y-5">
      <div>
        <h3 className="font-bold text-amber-800 flex items-center gap-2">
          <Coins className="h-5 w-5 text-amber-600" />
          ให้ feedback เคสนี้ — รับ +10 coins
        </h3>
        <p className="text-sm text-gray-500 mt-1">
          ช่วยเราปรับปรุงเคส ใช้เวลาแค่ 30 วินาที
        </p>
      </div>

      <StarPicker
        label="เคสนี้ดีแค่ไหน? (เนื้อหา / ความสมจริง)"
        value={caseRating}
        onChange={setCaseRating}
      />

      <div>
        <p className="text-sm font-medium text-gray-700 mb-1.5">ความยากเคสนี้</p>
        <div className="grid grid-cols-3 gap-2">
          {DIFFICULTY_OPTIONS.map((opt) => {
            const selected = difficultyVote === opt.value;
            return (
              <button
                key={opt.value}
                type="button"
                onClick={() => setDifficultyVote(opt.value)}
                className={`rounded-lg border-2 py-2 text-sm font-medium transition-colors ${
                  selected
                    ? "border-amber-500 bg-amber-50 text-amber-800"
                    : "border-gray-200 bg-white text-gray-600 hover:border-amber-200"
                }`}
              >
                <div className="text-xl mb-0.5">{opt.emoji}</div>
                {opt.label}
              </button>
            );
          })}
        </div>
      </div>

      <StarPicker
        label="AI Examiner ให้คะแนนยุติธรรมไหม?"
        value={examinerFairness}
        onChange={setExaminerFairness}
      />

      <div>
        <label
          htmlFor="longcase-feedback-comment"
          className="text-sm font-medium text-gray-700 mb-1.5 block"
        >
          ความเห็นเพิ่มเติม (ถ้ามี)
        </label>
        <Textarea
          id="longcase-feedback-comment"
          rows={3}
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          placeholder="เช่น เคสดีมาก / เฉลยยังไม่ชัดเจน / อยากให้มีแบบนี้อีก..."
          className="resize-none"
        />
      </div>

      <label className="flex items-start gap-2 cursor-pointer select-none">
        <input
          type="checkbox"
          checked={flagIssue}
          onChange={(e) => setFlagIssue(e.target.checked)}
          className="mt-0.5 h-4 w-4 rounded border-gray-300 text-amber-600 focus:ring-amber-500"
        />
        <span className="text-sm text-gray-700 flex items-start gap-1.5">
          <AlertTriangle className="h-4 w-4 text-amber-600 mt-0.5 shrink-0" />
          เคสนี้มีข้อมูลผิดหรือบั๊ก อยากให้ทีมงานตรวจสอบ
        </span>
      </label>

      {error && (
        <p className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2">
          {error}
        </p>
      )}

      <Button onClick={handleSubmit} disabled={!canSubmit} className="w-full">
        {submitting ? (
          <><Loader2 className="h-4 w-4 animate-spin" /> กำลังส่ง...</>
        ) : (
          <><Coins className="h-4 w-4" /> ส่ง feedback + รับ 10 coins</>
        )}
      </Button>
    </div>
  );
}
