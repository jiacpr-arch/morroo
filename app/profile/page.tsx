"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { User, Mail, Crown, Calendar, LogOut, Gift, Copy, Check, Users, MessageSquare, Link2, Loader2, Flag, Coins } from "lucide-react";
import type { Profile } from "@/lib/types";

const membershipLabels: Record<string, string> = {
  free: "ฟรี",
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
};

const membershipColors: Record<string, string> = {
  free: "bg-gray-100 text-gray-700",
  monthly: "bg-brand/10 text-brand",
  yearly: "bg-amber-100 text-amber-700",
  bundle: "bg-blue-100 text-blue-700",
};

export default function ProfilePage() {
  const router = useRouter();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);
  const [userEmail, setUserEmail] = useState("");
  const [referralCode, setReferralCode] = useState<string | null>(null);
  const [referralStats, setReferralStats] = useState({ total: 0, rewarded: 0 });
  const [copied, setCopied] = useState(false);
  const [generatingCode, setGeneratingCode] = useState(false);
  const [lineLinked, setLineLinked] = useState(false);
  const [lineCode, setLineCode] = useState<string | null>(null);
  const [lineCopied, setLineCopied] = useState(false);
  const [generatingLine, setGeneratingLine] = useState(false);

  useEffect(() => {
    async function loadProfile() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      setUserEmail(user.email || "");

      const { data } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", user.id)
        .single();

      setProfile(data);
      if (data?.line_user_id) setLineLinked(true);
      if (data?.referral_code) {
        setReferralCode(data.referral_code);
        // fetch stats
        const res = await fetch(`/api/referral/apply?userId=${user.id}`);
        if (res.ok) {
          const stats = await res.json();
          setReferralStats(stats);
        }
      }
      setLoading(false);
    }
    loadProfile();
  }, [router]);

  const handleLogout = async () => {
    const supabase = createClient();
    await supabase.auth.signOut();
    router.push("/");
    router.refresh();
  };

  const handleGenerateCode = async () => {
    setGeneratingCode(true);
    const res = await fetch("/api/referral/generate", { method: "POST" });
    if (res.ok) {
      const { code } = await res.json();
      setReferralCode(code);
      // fetch stats after generating
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const statsRes = await fetch(`/api/referral/apply?userId=${user.id}`);
        if (statsRes.ok) setReferralStats(await statsRes.json());
      }
    }
    setGeneratingCode(false);
  };

  const handleGenerateLine = async () => {
    setGeneratingLine(true);
    const supabase = createClient();
    const { data: { session } } = await supabase.auth.getSession();
    const res = await fetch("/api/line/generate-code", {
      method: "POST",
      headers: { Authorization: `Bearer ${session?.access_token}` },
    });
    if (res.ok) {
      const { code } = await res.json();
      setLineCode(code);
    }
    setGeneratingLine(false);
  };

  const handleCopyLineCode = async () => {
    if (!lineCode) return;
    await navigator.clipboard.writeText(lineCode);
    setLineCopied(true);
    setTimeout(() => setLineCopied(false), 2000);
  };

  const handleCopy = async () => {
    if (!referralCode) return;
    const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || window.location.origin;
    await navigator.clipboard.writeText(`${siteUrl}/register?ref=${referralCode}`);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[calc(100vh-12rem)]">
        <p className="text-muted-foreground">กำลังโหลด...</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8">
      <h1 className="text-3xl font-bold mb-8">โปรไฟล์</h1>

      <div className="space-y-6">
        {/* Profile Info */}
        <Card>
          <CardHeader>
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center">
                <User className="h-8 w-8 text-brand" />
              </div>
              <div>
                <h2 className="text-xl font-bold">
                  {profile?.name || "ผู้ใช้งาน"}
                </h2>
                <p className="text-sm text-muted-foreground flex items-center gap-1">
                  <Mail className="h-3.5 w-3.5" />
                  {profile?.email || userEmail}
                </p>
              </div>
            </div>
          </CardHeader>
        </Card>

        {/* Membership */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Crown className="h-5 w-5 text-brand" /> สถานะสมาชิก
            </h3>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">แพ็กเกจ</span>
              <Badge
                className={membershipColors[profile?.membership_type || "free"]}
              >
                {membershipLabels[profile?.membership_type || "free"]}
              </Badge>
            </div>
            {profile?.membership_expires_at && (
              <div className="flex items-center justify-between">
                <span className="text-muted-foreground flex items-center gap-1">
                  <Calendar className="h-4 w-4" /> วันหมดอายุ
                </span>
                <span className="text-sm font-medium">
                  {new Date(profile.membership_expires_at).toLocaleDateString("th-TH", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </span>
              </div>
            )}
            {(!profile || profile.membership_type === "free") && (
              <Link href="/pricing">
                <Button className="w-full bg-brand hover:bg-brand-light text-white mt-2">
                  อัปเกรดแพ็กเกจ
                </Button>
              </Link>
            )}
          </CardContent>
        </Card>

        {/* MEQ Coins — earned from long case exams */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Coins className="h-5 w-5 text-amber-600" /> MEQ Coins — รางวัลจากการฝึก Long Case
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              ทำ Long Case จบ +20 · คะแนน ≥70% +10 · ส่ง feedback +10
            </p>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between rounded-lg bg-amber-50 border border-amber-200 p-4">
              <span className="text-sm text-amber-800">เหรียญสะสมของคุณ</span>
              <span className="text-2xl font-bold text-amber-700">
                {profile?.meq_coins ?? 0}
              </span>
            </div>
          </CardContent>
        </Card>

        {/* Bug Hunter / reporter points */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Flag className="h-5 w-5 text-amber-600" /> Bug Hunter — ช่วยตรวจเฉลย
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              เจอข้อสอบที่เฉลยไม่ตรง หรือโจทย์กำกวม? กดปุ่ม
              <span className="inline-flex items-center gap-1 mx-1 px-1.5 rounded bg-amber-100 text-amber-800 text-xs">
                <Flag className="h-3 w-3" /> เฉลยไม่ถูก?
              </span>
              ใต้เฉลยแต่ละข้อ รับ +1 คะแนนทันที และ +10 คะแนนเมื่อแอดมินยืนยัน
            </p>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between rounded-lg bg-amber-50 border border-amber-200 p-4">
              <span className="text-sm text-amber-800">คะแนน Bug Hunter ของคุณ</span>
              <span className="text-2xl font-bold text-amber-700">
                {profile?.reporter_points ?? 0}
              </span>
            </div>
          </CardContent>
        </Card>

        {/* Referral */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <Gift className="h-5 w-5 text-brand" /> ชวนเพื่อน รับ 30 วันฟรี
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              เพื่อนสมัครสมาชิกผ่านลิงก์คุณ → คุณได้สิทธิ์ใช้งานเพิ่ม 30 วันทันที
            </p>
          </CardHeader>
          <CardContent className="space-y-4">
            {referralCode ? (
              <>
                {/* Stats */}
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-lg bg-muted/50 p-3 text-center">
                    <p className="text-2xl font-bold text-brand">{referralStats.total}</p>
                    <p className="text-xs text-muted-foreground flex items-center justify-center gap-1 mt-1">
                      <Users className="h-3 w-3" /> เพื่อนที่ชวนมา
                    </p>
                  </div>
                  <div className="rounded-lg bg-muted/50 p-3 text-center">
                    <p className="text-2xl font-bold text-green-600">{referralStats.rewarded * 30}</p>
                    <p className="text-xs text-muted-foreground mt-1">วันที่ได้รับแล้ว</p>
                  </div>
                </div>

                {/* Code display */}
                <div>
                  <p className="text-xs text-muted-foreground mb-1">รหัสของคุณ</p>
                  <div className="flex items-center gap-2">
                    <code className="flex-1 bg-muted px-3 py-2 rounded-lg text-sm font-mono font-semibold tracking-wider">
                      {referralCode}
                    </code>
                    <Button size="sm" variant="outline" onClick={handleCopy} className="gap-1.5 shrink-0">
                      {copied ? (
                        <><Check className="h-4 w-4 text-green-600" /> คัดลอกแล้ว</>
                      ) : (
                        <><Copy className="h-4 w-4" /> คัดลอกลิงก์</>
                      )}
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground mt-2">
                    กด "คัดลอกลิงก์" เพื่อแชร์ลิงก์สมัครที่ฝังรหัสไว้แล้ว
                  </p>
                </div>
              </>
            ) : (
              <div className="text-center py-2">
                <p className="text-sm text-muted-foreground mb-3">
                  สร้างรหัสชวนเพื่อนของคุณ เพื่อเริ่มรับสิทธิ์พิเศษ
                </p>
                <Button
                  onClick={handleGenerateCode}
                  disabled={generatingCode}
                  className="bg-brand hover:bg-brand-light text-white"
                >
                  {generatingCode ? "กำลังสร้าง..." : "สร้างรหัสชวนเพื่อน"}
                </Button>
              </div>
            )}
          </CardContent>
        </Card>

        {/* LINE Notification */}
        <Card>
          <CardHeader>
            <h3 className="font-semibold flex items-center gap-2">
              <MessageSquare className="h-5 w-5 text-green-600" /> เชื่อมต่อ LINE
            </h3>
            <p className="text-sm text-muted-foreground mt-1">
              รับข้อสอบประจำวัน + การแจ้งเตือนจาก MorRoo ผ่าน LINE
            </p>
          </CardHeader>
          <CardContent className="space-y-3">
            {/* Add Friend — always visible */}
            <a
              href="https://line.me/R/ti/p/@508srmcr"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-center gap-2 w-full rounded-lg bg-[#06C755] hover:bg-[#05b34c] text-white font-semibold py-2.5 px-4 text-sm transition-colors"
            >
              <svg className="h-5 w-5" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.02 2 11c0 3.39 1.9 6.35 4.75 8.07L6 22l3.29-1.72C10.15 20.73 11.06 21 12 21c5.52 0 10-4.02 10-9S17.52 2 12 2z"/>
              </svg>
              เพิ่มเพื่อน LINE OA (@508srmcr)
            </a>

            {/* Linking status */}
            {lineLinked ? (
              <div className="flex items-center gap-2 text-green-700 bg-green-50 rounded-lg px-4 py-3">
                <Link2 className="h-4 w-4 shrink-0" />
                <span className="text-sm font-medium">เชื่อมต่อ LINE แล้ว ✓ — รับข้อสอบทุกเช้า 7 โมง</span>
              </div>
            ) : lineCode ? (
              <div className="space-y-2 rounded-lg border border-green-200 bg-green-50/50 p-3">
                <p className="text-sm font-medium text-green-800">ขั้นตอนที่ 2 — ส่งรหัสนี้ใน LINE OA:</p>
                <div className="flex items-center gap-2">
                  <code className="flex-1 bg-white px-3 py-2 rounded-lg text-sm font-mono font-bold tracking-widest text-center border">
                    {lineCode}
                  </code>
                  <Button size="sm" variant="outline" onClick={handleCopyLineCode} className="shrink-0 gap-1">
                    {lineCopied ? <Check className="h-4 w-4 text-green-600" /> : <Copy className="h-4 w-4" />}
                  </Button>
                </div>
                <p className="text-xs text-muted-foreground">รหัสหมดอายุใน 24 ชั่วโมง</p>
              </div>
            ) : (
              <Button
                onClick={handleGenerateLine}
                disabled={generatingLine}
                variant="outline"
                className="w-full gap-2 border-green-300 text-green-700 hover:bg-green-50"
              >
                {generatingLine ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <Link2 className="h-4 w-4" />
                )}
                สร้างรหัสเชื่อมต่อบัญชี (ขั้นตอนที่ 2)
              </Button>
            )}
          </CardContent>
        </Card>

        {/* Logout */}
        <Button
          variant="outline"
          className="w-full gap-2 text-destructive border-destructive/30 hover:bg-destructive/5"
          onClick={handleLogout}
        >
          <LogOut className="h-4 w-4" /> ออกจากระบบ
        </Button>
      </div>
    </div>
  );
}
