"use client";

import { useState } from "react";
import { Share2, Check, Copy } from "lucide-react";
import { Button } from "@/components/ui/button";

interface Props {
  topicName: string;
  score: number;
  total: number;
  xpEarned: number;
}

export default function ShareResult({ topicName, score, total, xpEarned }: Props) {
  const [copied, setCopied] = useState(false);
  const pct = total ? Math.round((score / total) * 100) : 0;

  const text = `📚 ${topicName} — ฉันเพิ่งทำได้ ${pct}% (${score}/${total}) บน Morroo School!\n+${xpEarned} XP 💪\n\nมาเรียนแพทย์แบบ micro-learning ที่ www.morroo.com/school`;

  async function copy() {
    try {
      await navigator.clipboard.writeText(text);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      // Non-blocking
    }
  }

  async function nativeShare() {
    if (navigator.share) {
      try {
        await navigator.share({ text, url: "https://www.morroo.com/school" });
      } catch {
        // user cancelled
      }
    } else {
      copy();
    }
  }

  return (
    <div className="space-y-2">
      <div className="rounded-lg border bg-gradient-to-br from-violet-100 via-amber-100 to-emerald-100 p-4 text-sm">
        <p className="whitespace-pre-line text-foreground">{text}</p>
      </div>
      <div className="grid grid-cols-2 gap-2">
        <Button onClick={copy} variant="outline" className="gap-2">
          {copied ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
          {copied ? "Copied!" : "คัดลอก"}
        </Button>
        <Button onClick={nativeShare} className="gap-2">
          <Share2 className="h-4 w-4" /> แชร์
        </Button>
      </div>
    </div>
  );
}
