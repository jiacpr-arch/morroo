"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Gift, Copy, Check, Users } from "lucide-react";
import { getReferralCode, getReferralLink, REFERRAL_REWARD_DAYS } from "@/lib/referral";

interface ReferralCardProps {
  userId: string;
}

export default function ReferralCard({ userId }: ReferralCardProps) {
  const [copied, setCopied] = useState(false);
  const [referralCount, setReferralCount] = useState<number | null>(null);

  const code = getReferralCode(userId);
  const link = getReferralLink(userId, typeof window !== "undefined" ? window.location.origin : "https://www.morroo.com");

  useEffect(() => {
    fetch("/api/referral/stats")
      .then((r) => r.json())
      .then((d) => setReferralCount(d.count ?? 0))
      .catch(() => {});
  }, []);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(link);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      // fallback
      const el = document.createElement("textarea");
      el.value = link;
      document.body.appendChild(el);
      el.select();
      document.execCommand("copy");
      document.body.removeChild(el);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  const handleShare = () => {
    if (navigator.share) {
      navigator.share({
        title: "หมอรู้ — เตรียมสอบแพทย์ด้วย AI",
        text: `ลองใช้หมอรู้เพื่อเตรียมสอบ NL ครับ สมัครผ่านลิงก์นี้ได้เลย`,
        url: link,
      });
    } else {
      handleCopy();
    }
  };

  return (
    <Card>
      <CardHeader>
        <h3 className="font-semibold flex items-center gap-2">
          <Gift className="h-5 w-5 text-brand" /> แนะนำเพื่อน
        </h3>
      </CardHeader>
      <CardContent className="space-y-4">
        <p className="text-sm text-muted-foreground">
          ชวนเพื่อนมาสมัครหมอรู้ คุณจะได้รับ{" "}
          <strong className="text-foreground">{REFERRAL_REWARD_DAYS} วันฟรี</strong>{" "}
          ต่อทุก 1 คนที่สมัครผ่านลิงก์ของคุณ
        </p>

        {/* Stats */}
        {referralCount !== null && (
          <div className="flex items-center gap-2 rounded-lg bg-brand/5 border border-brand/10 px-4 py-3">
            <Users className="h-4 w-4 text-brand" />
            <span className="text-sm">
              คุณแนะนำไปแล้ว{" "}
              <strong className="text-brand">{referralCount} คน</strong>
              {referralCount > 0 && (
                <span className="text-muted-foreground">
                  {" "}(+{referralCount * REFERRAL_REWARD_DAYS} วัน)
                </span>
              )}
            </span>
          </div>
        )}

        {/* Code */}
        <div>
          <p className="text-xs text-muted-foreground mb-1">รหัสแนะนำของคุณ</p>
          <div className="flex items-center gap-2 rounded-lg border bg-muted/50 px-3 py-2">
            <code className="flex-1 text-sm font-mono font-semibold tracking-widest text-brand">
              {code}
            </code>
          </div>
        </div>

        {/* Link */}
        <div>
          <p className="text-xs text-muted-foreground mb-1">ลิงก์แนะนำ</p>
          <div className="flex items-center gap-2 rounded-lg border bg-muted/50 px-3 py-2">
            <span className="flex-1 text-xs text-muted-foreground truncate">{link}</span>
          </div>
        </div>

        {/* Actions */}
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="sm"
            className="flex-1 gap-2"
            onClick={handleCopy}
          >
            {copied ? (
              <>
                <Check className="h-4 w-4 text-green-600" />
                คัดลอกแล้ว!
              </>
            ) : (
              <>
                <Copy className="h-4 w-4" />
                คัดลอกลิงก์
              </>
            )}
          </Button>
          <Button
            size="sm"
            className="flex-1 bg-brand hover:bg-brand/90 text-white gap-2"
            onClick={handleShare}
          >
            <Gift className="h-4 w-4" />
            แชร์เลย
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
