"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Share2, Check, Copy, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface Props {
  userId: string;
  correctCount: number;
  totalAttempts: number;
  accuracy: number;
  streak: number;
}

function currentWeekStart(): string {
  const now = new Date();
  const day = (now.getDay() + 6) % 7; // ISO week (Mon = 0)
  const monday = new Date(now);
  monday.setDate(now.getDate() - day);
  monday.setHours(0, 0, 0, 0);
  return monday.toISOString().slice(0, 10);
}

export default function ShareToEarnCard({
  userId,
  correctCount,
  totalAttempts,
  accuracy,
  streak,
}: Props) {
  const [claimedThisWeek, setClaimedThisWeek] = useState<boolean | null>(null);
  const [claiming, setClaiming] = useState(false);
  const [justAwarded, setJustAwarded] = useState(false);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    let cancelled = false;
    async function check() {
      const supabase = createClient();
      const { data } = await supabase
        .from("meq_coin_transactions")
        .select("id, meta")
        .eq("user_id", userId)
        .eq("source", "share_weekly_result")
        .order("created_at", { ascending: false })
        .limit(1);

      if (cancelled) return;
      const row = (data as Array<{ meta: { week_start?: string } }> | null)?.[0];
      const ws = row?.meta?.week_start;
      setClaimedThisWeek(!!ws && ws === currentWeekStart());
    }
    check();
    return () => {
      cancelled = true;
    };
  }, [userId]);

  const shareText = `สัปดาห์นี้ผม/ดิฉันทำ MCQ ${correctCount}/${totalAttempts} ข้อ (${accuracy}%) 🔥 streak ${streak} วัน — ฝึกด้วย morroo.com 🩺`;
  const shareUrl = "https://www.morroo.com";

  const fbShare = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}&quote=${encodeURIComponent(shareText)}`;
  const lineShare = `https://line.me/R/msg/text/?${encodeURIComponent(`${shareText}\n${shareUrl}`)}`;

  async function copyCaption() {
    await navigator.clipboard.writeText(`${shareText}\n${shareUrl}`);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  }

  async function claim() {
    setClaiming(true);
    const res = await fetch("/api/share/claim", { method: "POST" });
    const json = await res.json();
    setClaiming(false);
    if (json.awarded > 0) {
      setJustAwarded(true);
      setClaimedThisWeek(true);
    } else if (json.already_claimed) {
      setClaimedThisWeek(true);
    }
  }

  if (totalAttempts === 0) return null;

  return (
    <Card className="mb-6 border-brand/30 bg-gradient-to-br from-brand/5 to-amber-50/40">
      <CardHeader className="pb-3">
        <CardTitle className="text-base flex items-center gap-2">
          <Share2 className="h-5 w-5 text-brand" />
          แชร์แลก MEQ coins
        </CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-gray-700 mb-3">
          แชร์ผลการฝึกสัปดาห์นี้ให้เพื่อนๆ รับ <strong>+5 MEQ coins</strong> (สัปดาห์ละ 1 ครั้ง)
        </p>
        <div className="bg-white rounded-lg p-3 border text-sm text-gray-700 mb-3">
          {shareText}
        </div>

        <div className="flex flex-wrap gap-2 mb-3">
          <a href={fbShare} target="_blank" rel="noopener noreferrer">
            <Button size="sm" variant="outline" className="gap-1.5">
              Facebook
            </Button>
          </a>
          <a href={lineShare} target="_blank" rel="noopener noreferrer">
            <Button size="sm" variant="outline" className="gap-1.5">
              LINE
            </Button>
          </a>
          <Button size="sm" variant="outline" onClick={copyCaption} className="gap-1.5">
            {copied ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
            {copied ? "คัดลอกแล้ว" : "คัดลอกข้อความ"}
          </Button>
        </div>

        {claimedThisWeek === null ? (
          <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
        ) : claimedThisWeek ? (
          <div className="flex items-center gap-2 text-sm text-green-700 bg-green-50 rounded-lg px-3 py-2 border border-green-100">
            <Check className="h-4 w-4" />
            {justAwarded
              ? "รับ 5 MEQ coins แล้ว! กลับมาสัปดาห์หน้านะครับ"
              : "สัปดาห์นี้รับรางวัลไปแล้ว — กลับมาสัปดาห์หน้า"}
          </div>
        ) : (
          <Button
            onClick={claim}
            disabled={claiming}
            size="sm"
            className="bg-brand hover:bg-brand-light text-white gap-1.5"
          >
            {claiming ? <Loader2 className="h-4 w-4 animate-spin" /> : null}
            แชร์แล้ว รับ 5 coins
          </Button>
        )}
      </CardContent>
    </Card>
  );
}
