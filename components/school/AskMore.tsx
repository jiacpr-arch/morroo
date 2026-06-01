"use client";

import { useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { MessageCircleQuestion, Loader2, Sparkles } from "lucide-react";
import { XP, awardXp } from "@/lib/school/xp";

interface Props {
  topicId: string;
  chapterId?: string;
}

/**
 * "ถามเพิ่ม" — lets a student ask a free-form question about the topic. The
 * answer is grounded in the topic's full-text book; the question is stored so
 * the enrich job can later expand the content where students struggle.
 */
export default function AskMore({ topicId, chapterId }: Props) {
  const [question, setQuestion] = useState("");
  const [answer, setAnswer] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function submit() {
    const q = question.trim();
    if (!q || loading) return;
    setLoading(true);
    setError(null);
    setAnswer(null);
    try {
      const res = await fetch("/api/school/ask", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ question: q, topicId, chapterId }),
      });
      if (res.status === 401) {
        setError("กรุณาเข้าสู่ระบบก่อนถามคำถาม");
        return;
      }
      if (!res.ok) {
        setError("ขออภัย ระบบมีปัญหา ลองใหม่อีกครั้ง");
        return;
      }
      const data = (await res.json()) as { answer: string };
      setAnswer(data.answer);
      awardXp(XP.askQuestion, `ask:${topicId}`);
    } catch {
      setError("ขออภัย ระบบมีปัญหา ลองใหม่อีกครั้ง");
    } finally {
      setLoading(false);
    }
  }

  return (
    <Card className="border-sky-200 bg-sky-50/40">
      <CardContent className="space-y-3 p-5">
        <p className="flex items-center gap-2 text-sm font-bold text-sky-700">
          <MessageCircleQuestion className="h-4 w-4" /> ถามเพิ่ม
        </p>
        <p className="text-xs text-muted-foreground">
          สงสัยตรงไหน ถามได้เลย — ระบบตอบจากเนื้อหาในบทนี้
          และนำคำถามไปพัฒนาเนื้อหาให้ละเอียดขึ้น
        </p>
        <Textarea
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
          placeholder="เช่น ทำไม Na+/K+ ATPase ถึงสำคัญต่อ resting membrane potential?"
          rows={3}
          onKeyDown={(e) => {
            if ((e.metaKey || e.ctrlKey) && e.key === "Enter") submit();
          }}
        />
        <div className="flex justify-end">
          <Button onClick={submit} disabled={loading || !question.trim()} className="gap-2">
            {loading ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" /> กำลังตอบ…
              </>
            ) : (
              <>
                <Sparkles className="h-4 w-4" /> ถาม
              </>
            )}
          </Button>
        </div>

        {error && <p className="text-sm text-rose-600">{error}</p>}

        {answer && (
          <div className="rounded-lg border bg-background p-4">
            <article className="prose prose-sm prose-slate dark:prose-invert max-w-none">
              <ReactMarkdown remarkPlugins={[remarkGfm]}>{answer}</ReactMarkdown>
            </article>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
