"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { HelpCircle, Loader2, X } from "lucide-react";

interface Props {
  concept: string;
  onClose: () => void;
}

interface Question {
  question: string;
  hint?: string;
}

export default function ElaborateModal({ concept, onClose }: Props) {
  const [question, setQuestion] = useState<Question | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showHint, setShowHint] = useState(false);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      try {
        const res = await fetch("/api/school/elaborate", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ concept }),
        });
        if (!res.ok) {
          const j = await res.json().catch(() => ({}));
          throw new Error(j.error ?? "Failed");
        }
        const data = (await res.json()) as Question;
        if (!cancelled) setQuestion(data);
      } catch (e) {
        if (!cancelled) setError(e instanceof Error ? e.message : "Error");
      } finally {
        if (!cancelled) setLoading(false);
      }
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [concept]);

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4"
      onClick={onClose}
    >
      <div
        className="bg-background rounded-lg max-w-lg w-full p-6"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <HelpCircle className="h-5 w-5 text-amber-600" />
            <h3 className="font-bold">ทำไม / อย่างไร?</h3>
          </div>
          <button onClick={onClose}>
            <X className="h-5 w-5 text-muted-foreground" />
          </button>
        </div>

        <p className="text-sm text-muted-foreground mb-3">
          Elaborative Interrogation — บังคับให้คุณคิดถึง <strong>กลไก</strong>
          ไม่ใช่แค่จำ
        </p>

        {loading && (
          <div className="flex items-center gap-2 text-muted-foreground py-6 justify-center">
            <Loader2 className="h-4 w-4 animate-spin" /> AI กำลังคิดคำถาม…
          </div>
        )}
        {error && <p className="text-sm text-rose-600">{error}</p>}
        {question && (
          <div className="space-y-3">
            <div className="rounded-lg bg-amber-50 border border-amber-200 p-4">
              <p className="font-medium">{question.question}</p>
            </div>
            {question.hint && (
              <div>
                {!showHint ? (
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => setShowHint(true)}
                  >
                    ดูคำใบ้
                  </Button>
                ) : (
                  <p className="text-sm text-amber-700 italic">
                    💡 {question.hint}
                  </p>
                )}
              </div>
            )}
            <p className="text-xs text-muted-foreground">
              ลองตอบในใจหรือพูดออกมา (ไม่ต้องพิมพ์) — แล้วกลับไปดูเฉลย/back ของการ์ด
            </p>
            <Button onClick={onClose} className="w-full">
              เข้าใจแล้ว
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
