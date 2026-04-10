"use client";

import { useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle, Loader2, AlertCircle } from "lucide-react";

type VerifyStatus = "verifying" | "ok" | "pending" | "error";

export default function SuccessContent() {
  const searchParams = useSearchParams();
  const sessionId = searchParams.get("session_id");
  // If there's no session_id on the URL the user navigated here directly —
  // nothing to verify, just show the generic success state.
  const [status, setStatus] = useState<VerifyStatus>(() =>
    sessionId ? "verifying" : "ok"
  );
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Self-healing fallback: call /api/billing/verify on mount. This
  // guarantees the user gets their membership even if the Stripe webhook
  // never arrived. The backend helper is idempotent so this is safe to
  // call even when the webhook already fulfilled the session.
  useEffect(() => {
    if (!sessionId) return;

    let cancelled = false;

    async function verify() {
      try {
        const res = await fetch("/api/billing/verify", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ sessionId }),
        });
        const data = (await res.json()) as {
          status?: string;
          error?: string;
        };
        if (cancelled) return;

        if (!res.ok) {
          setStatus("error");
          setErrorMessage(data.error ?? "ไม่สามารถยืนยันการชำระเงินได้");
          return;
        }

        if (data.status === "pending") {
          setStatus("pending");
        } else {
          setStatus("ok");
        }
      } catch (err) {
        if (cancelled) return;
        setStatus("error");
        setErrorMessage(err instanceof Error ? err.message : String(err));
      }
    }

    verify();
    return () => {
      cancelled = true;
    };
  }, [sessionId]);

  return (
    <div className="mx-auto max-w-lg px-4 py-16">
      <Card className="text-center">
        <CardContent className="py-12 space-y-4">
          {status === "verifying" && (
            <>
              <div className="mx-auto w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center">
                <Loader2 className="h-8 w-8 text-blue-600 animate-spin" />
              </div>
              <h1 className="text-2xl font-bold text-blue-700">กำลังยืนยันการชำระเงิน...</h1>
              <p className="text-sm text-muted-foreground">
                ระบบกำลังเปิดใช้งานแพ็กเกจให้คุณ กรุณารอสักครู่
              </p>
            </>
          )}

          {status === "ok" && (
            <>
              <div className="mx-auto w-16 h-16 rounded-full bg-green-100 flex items-center justify-center">
                <CheckCircle className="h-8 w-8 text-green-600" />
              </div>
              <h1 className="text-2xl font-bold text-green-700">ชำระเงินสำเร็จ!</h1>
              <div className="space-y-2 text-muted-foreground">
                <p>แพ็กเกจของคุณถูกเปิดใช้งานแล้ว</p>
              </div>
              <div className="pt-4 space-y-2">
                <Link href="/exams">
                  <Button className="w-full bg-brand hover:bg-brand-light text-white">
                    ดูข้อสอบ
                  </Button>
                </Link>
                {sessionId && (
                  <Link href={`/invoice?session_id=${sessionId}`}>
                    <Button variant="outline" className="w-full">
                      ดูใบเสร็จ
                    </Button>
                  </Link>
                )}
              </div>
            </>
          )}

          {status === "pending" && (
            <>
              <div className="mx-auto w-16 h-16 rounded-full bg-yellow-100 flex items-center justify-center">
                <Loader2 className="h-8 w-8 text-yellow-600 animate-spin" />
              </div>
              <h1 className="text-2xl font-bold text-yellow-700">กำลังรอการยืนยันจากธนาคาร</h1>
              <p className="text-sm text-muted-foreground">
                Stripe ยังไม่ยืนยันการชำระเงิน กรุณารอสักครู่แล้วรีเฟรชหน้านี้
              </p>
              <div className="pt-4">
                <Button
                  variant="outline"
                  className="w-full"
                  onClick={() => window.location.reload()}
                >
                  รีเฟรช
                </Button>
              </div>
            </>
          )}

          {status === "error" && (
            <>
              <div className="mx-auto w-16 h-16 rounded-full bg-red-100 flex items-center justify-center">
                <AlertCircle className="h-8 w-8 text-red-600" />
              </div>
              <h1 className="text-2xl font-bold text-red-700">ไม่สามารถยืนยันการชำระเงินได้</h1>
              <p className="text-sm text-muted-foreground">
                {errorMessage ?? "กรุณาติดต่อ support@morroo.com"}
              </p>
              <p className="text-xs text-muted-foreground">
                หากคุณถูกตัดเงินแล้ว ทีมงานจะตรวจสอบและเปิดใช้งานแพ็กเกจให้คุณโดยเร็วที่สุด
              </p>
              <div className="pt-4 space-y-2">
                <Button
                  className="w-full bg-brand hover:bg-brand-light text-white"
                  onClick={() => window.location.reload()}
                >
                  ลองอีกครั้ง
                </Button>
                <Link href="/exams">
                  <Button variant="outline" className="w-full">
                    ไปหน้าข้อสอบ
                  </Button>
                </Link>
              </div>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
