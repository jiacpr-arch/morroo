"use client";

import { useEffect, useState, use } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { CheckCircle, Gift, Loader2, AlertCircle } from "lucide-react";
import type { User } from "@supabase/supabase-js";

type Phase = "loading" | "preview" | "redeeming" | "success" | "error";

interface RedeemResult {
  rewardType: "monthly_1m" | "bundle_10q";
  expiresAt: string;
}

const REWARD_LABEL: Record<string, string> = {
  monthly_1m: "Premium รายเดือน — ฟรี 30 วัน",
  bundle_10q: "Bundle 10 ข้อ — ใช้งานถาวร",
};

export default function RedeemPage({
  params,
}: {
  params: Promise<{ code: string }>;
}) {
  const { code } = use(params);
  const router = useRouter();
  const [phase, setPhase] = useState<Phase>("loading");
  const [user, setUser] = useState<User | null>(null);
  const [result, setResult] = useState<RedeemResult | null>(null);
  const [errorMsg, setErrorMsg] = useState("");

  useEffect(() => {
    const supabase = createClient();
    supabase.auth.getUser().then(({ data }) => {
      setUser(data.user);
      setPhase("preview");
    });
  }, []);

  async function handleRedeem() {
    setPhase("redeeming");
    try {
      const res = await fetch("/api/redeem", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      });
      const data = await res.json();
      if (!data.ok) {
        setErrorMsg(data.error || "ไม่สามารถใช้โค้ดได้");
        setPhase("error");
        return;
      }
      setResult({ rewardType: data.rewardType, expiresAt: data.expiresAt });
      setPhase("success");
      setTimeout(() => router.push("/dashboard?welcome=redeem"), 2500);
    } catch (e) {
      setErrorMsg(e instanceof Error ? e.message : "เกิดข้อผิดพลาด");
      setPhase("error");
    }
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-emerald-50 via-white to-teal-50 px-4 py-16">
      <Card className="mx-auto max-w-md">
        <CardHeader className="space-y-2 text-center">
          <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-emerald-100 text-emerald-700">
            <Gift className="h-7 w-7" />
          </div>
          <h1 className="text-2xl font-bold text-emerald-900">รับสิทธิ์ฟรีของคุณ</h1>
          <p className="font-mono text-sm text-emerald-700">{code}</p>
        </CardHeader>
        <CardContent className="space-y-4 text-center">
          {phase === "loading" && (
            <div className="flex justify-center py-6">
              <Loader2 className="h-6 w-6 animate-spin text-emerald-600" />
            </div>
          )}

          {phase === "preview" && !user && (
            <>
              <p className="text-sm text-gray-700">
                กรุณาเข้าสู่ระบบหรือสมัครสมาชิกก่อน เพื่อรับสิทธิ์รางวัล
              </p>
              <div className="flex flex-col gap-2">
                <Button asChild>
                  <Link
                    href={`/login?redirect=${encodeURIComponent(`/redeem/${code}`)}`}
                  >
                    เข้าสู่ระบบ
                  </Link>
                </Button>
                <Button asChild variant="outline">
                  <Link
                    href={`/register?redirect=${encodeURIComponent(`/redeem/${code}`)}`}
                  >
                    สมัครใหม่ (ฟรี)
                  </Link>
                </Button>
              </div>
            </>
          )}

          {phase === "preview" && user && (
            <>
              <p className="text-sm text-gray-700">
                กดปุ่มด้านล่างเพื่อรับสิทธิ์ทันที
              </p>
              <Button className="w-full" onClick={handleRedeem}>
                ใช้โค้ดเลย
              </Button>
              <p className="text-xs text-gray-500">
                บัญชี: {user.email}
              </p>
            </>
          )}

          {phase === "redeeming" && (
            <div className="flex items-center justify-center gap-2 py-6 text-emerald-700">
              <Loader2 className="h-5 w-5 animate-spin" />
              กำลังเปิดสิทธิ์...
            </div>
          )}

          {phase === "success" && result && (
            <>
              <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-emerald-500 text-white">
                <CheckCircle className="h-7 w-7" />
              </div>
              <h2 className="text-lg font-semibold text-emerald-900">
                สำเร็จ! 🎉
              </h2>
              <p className="text-sm text-gray-700">
                คุณได้รับ <strong>{REWARD_LABEL[result.rewardType]}</strong>
              </p>
              <p className="text-xs text-gray-500">
                ใช้งานได้ถึง {new Date(result.expiresAt).toLocaleDateString("th-TH")}
              </p>
              <p className="pt-2 text-xs text-gray-400">
                กำลังพาไปหน้าหลัก...
              </p>
            </>
          )}

          {phase === "error" && (
            <>
              <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-full bg-red-100 text-red-600">
                <AlertCircle className="h-7 w-7" />
              </div>
              <p className="text-sm text-gray-700">{errorMsg}</p>
              <Button variant="outline" asChild>
                <Link href="/">กลับหน้าหลัก</Link>
              </Button>
            </>
          )}
        </CardContent>
      </Card>
    </main>
  );
}
