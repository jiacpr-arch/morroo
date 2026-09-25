"use client";

import { useState } from "react";
import Link from "next/link";
import { Check, Copy, Share2, Trophy, Users } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  mockRankCohortLabel,
  mockRankHeadline,
  mockShareText,
  type MockRank,
} from "@/lib/mcq-mock-percentile";

export type MockRankState =
  | { status: "loading" }
  | { status: "guest" }
  | { status: "unavailable" }
  /** server ตรวจแล้วแต่รอบนี้ไม่นับอันดับ (ดู /api/mcq/mock/submit) */
  | { status: "unranked"; reason: "too_fast" | "expired" | "already_submitted" }
  | { status: "done"; rank: MockRank };

const UNRANKED_MESSAGE: Record<Extract<MockRankState, { status: "unranked" }>["reason"], string> = {
  too_fast: "รอบนี้ส่งเร็วเกินกว่าจะอ่านข้อสอบครบ จึงไม่นำไปจัดอันดับ — ลองทำชุดใหม่แบบตั้งใจอีกครั้ง",
  expired: "รอบนี้ส่งหลังหมดเวลาสอบนานเกินไป จึงไม่นำไปจัดอันดับ",
  already_submitted: "ชุดข้อสอบนี้ส่งไปแล้ว — นับอันดับจากการส่งครั้งแรกเท่านั้น",
};

interface Props {
  state: MockRankState;
  label: string;
  shareUrl: string;
  correct: number;
  total: number;
  loginNext: string;
}

/**
 * การ์ด "ดีกว่า X% ของผู้ที่ทำชุดนี้" บนหน้าผล Mock Exam + ปุ่มแชร์แบบข้อความ
 * (แพทเทิร์นเดียวกับ components/school/ShareResult.tsx — copy / navigator.share)
 */
export default function MockRankCard({ state, label, shareUrl, correct, total, loginNext }: Props) {
  const [copied, setCopied] = useState(false);

  // RPC ยังไม่ deploy / เน็ตพลาด — ซ่อนทั้งการ์ด ไม่ให้หน้าผลดูพัง
  if (state.status === "unavailable") return null;

  if (state.status === "guest") {
    return (
      <Card className="border-dashed">
        <CardContent className="p-4 text-sm text-center text-muted-foreground">
          <Users className="h-4 w-4 inline mr-1 -mt-0.5" />
          <Link href={`/login?next=${encodeURIComponent(loginNext)}`} className="font-semibold text-brand underline">
            เข้าสู่ระบบ
          </Link>{" "}
          เพื่อบันทึกผลและดูว่าคุณทำได้ดีกว่ากี่ % ของผู้ที่ทำชุดนี้
        </CardContent>
      </Card>
    );
  }

  if (state.status === "unranked") {
    return (
      <Card className="border-dashed">
        <CardContent className="p-4 text-sm text-center text-muted-foreground">
          <Users className="h-4 w-4 inline mr-1 -mt-0.5" />
          {UNRANKED_MESSAGE[state.reason]}
        </CardContent>
      </Card>
    );
  }

  if (state.status === "loading") {
    return (
      <Card>
        <CardContent className="p-4 text-sm text-center text-muted-foreground animate-pulse">
          กำลังเทียบคะแนนกับผู้ที่ทำชุดนี้...
        </CardContent>
      </Card>
    );
  }

  const { rank } = state;
  const cohortLabel = mockRankCohortLabel(rank, { label, totalQuestions: total });
  const text = mockShareText({ label, correct, total, rank, url: shareUrl });

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
        await navigator.share({ text, url: shareUrl });
      } catch {
        // user cancelled
      }
    } else {
      copy();
    }
  }

  return (
    <Card className={rank.status === "ranked" ? "border-amber-200 bg-amber-50/50" : ""}>
      <CardContent className="p-6 space-y-4">
        <div className="flex items-start gap-3">
          {rank.status === "ranked" ? (
            <Trophy className="h-6 w-6 text-amber-600 flex-shrink-0 mt-0.5" />
          ) : (
            <Users className="h-6 w-6 text-muted-foreground flex-shrink-0 mt-0.5" />
          )}
          <div className="space-y-1">
            {rank.status === "ranked" && (
              <p className="text-3xl font-bold text-amber-700">
                Top {Math.max(1, 100 - rank.percentile)}%
              </p>
            )}
            <p className={rank.status === "ranked" ? "font-semibold" : "text-sm text-muted-foreground"}>
              {mockRankHeadline(rank)}
            </p>
            {cohortLabel && <p className="text-xs text-muted-foreground">{cohortLabel}</p>}
          </div>
        </div>

        <div className="grid grid-cols-2 gap-2">
          <Button onClick={copy} variant="outline" size="sm" className="gap-2">
            {copied ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
            {copied ? "คัดลอกแล้ว" : "คัดลอกผล"}
          </Button>
          <Button onClick={nativeShare} size="sm" className="gap-2 bg-brand hover:bg-brand-light text-white">
            <Share2 className="h-4 w-4" /> แชร์ผล
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
