"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Sparkles, Loader2, X } from "lucide-react";

interface Props {
  concept: string;
  onClose: () => void;
}

interface Feedback {
  score: number;
  feedback: string;
  strengths: string[];
  missing_points: string[];
}

export default function SelfExplainModal({ concept, onClose }: Props) {
  const [text, setText] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<Feedback | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function submit() {
    if (!text.trim()) return;
    setSubmitting(true);
    setError(null);
    try {
      const res = await fetch("/api/school/explain", {
        method: "POST",
        headers: { "content-type": "application/json" },
        body: JSON.stringify({ concept, userExplanation: text }),
      });
      if (!res.ok) {
        const j = await res.json().catch(() => ({}));
        throw new Error(j.error ?? "Failed to grade");
      }
      const data = (await res.json()) as Feedback;
      setResult(data);
      // Award XP + detect feynman_5 badge
      try {
        const { awardXp, detectBadges } = await import("@/lib/school/xp");
        await awardXp(15, "feynman:complete");
        await detectBadges({ feynmanCompleted: true });
      } catch {
        // Non-blocking
      }
    } catch (e) {
      setError(e instanceof Error ? e.message : "Error");
    } finally {
      setSubmitting(false);
    }
  }

  const scoreColor =
    result && result.score >= 4
      ? "text-emerald-600"
      : result && result.score >= 3
        ? "text-amber-600"
        : "text-rose-600";

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4"
      onClick={onClose}
    >
      <div
        className="bg-background rounded-lg max-w-lg w-full p-6 max-h-[90vh] overflow-y-auto"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Sparkles className="h-5 w-5 text-violet-600" />
            <h3 className="font-bold">อธิบายให้คนอื่นฟัง (Feynman)</h3>
          </div>
          <button onClick={onClose}>
            <X className="h-5 w-5 text-muted-foreground" />
          </button>
        </div>

        <p className="text-sm text-muted-foreground mb-2">
          ลองอธิบาย concept นี้ด้วยคำพูดของตัวเอง — AI จะตรวจให้คะแนน + บอกจุดที่ขาด
        </p>
        <div className="rounded-lg bg-muted/30 p-3 text-sm mb-3">
          <span className="font-semibold">Concept: </span>
          {concept}
        </div>

        {!result ? (
          <>
            <textarea
              value={text}
              onChange={(e) => setText(e.target.value)}
              placeholder="พิมพ์คำอธิบายของคุณที่นี่ ใช้คำง่ายๆ เหมือนอธิบายให้เพื่อนฟัง…"
              className="w-full border rounded-md p-3 text-sm min-h-[140px]"
              disabled={submitting}
            />
            {error && <p className="text-sm text-rose-600 mt-2">{error}</p>}
            <div className="flex gap-2 mt-3">
              <Button onClick={submit} disabled={submitting || !text.trim()} className="flex-1">
                {submitting ? (
                  <>
                    <Loader2 className="h-4 w-4 mr-2 animate-spin" /> กำลังตรวจ…
                  </>
                ) : (
                  <>ส่งให้ AI ตรวจ</>
                )}
              </Button>
              <Button variant="outline" onClick={onClose}>
                ปิด
              </Button>
            </div>
          </>
        ) : (
          <div className="space-y-3">
            <div className={`text-2xl font-bold ${scoreColor}`}>
              คะแนน {result.score} / 5
            </div>
            <p className="text-sm">{result.feedback}</p>
            {result.strengths.length > 0 && (
              <div>
                <p className="font-semibold text-emerald-700 text-sm mb-1">✓ จุดดี</p>
                <ul className="list-disc pl-5 text-sm space-y-1">
                  {result.strengths.map((s, i) => (
                    <li key={i}>{s}</li>
                  ))}
                </ul>
              </div>
            )}
            {result.missing_points.length > 0 && (
              <div>
                <p className="font-semibold text-amber-700 text-sm mb-1">! ที่ขาด/แก้</p>
                <ul className="list-disc pl-5 text-sm space-y-1">
                  {result.missing_points.map((m, i) => (
                    <li key={i}>{m}</li>
                  ))}
                </ul>
              </div>
            )}
            <Button onClick={onClose} className="w-full">
              เข้าใจแล้ว
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
