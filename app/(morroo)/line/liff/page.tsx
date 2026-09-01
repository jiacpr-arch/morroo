"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";

const LIFF_ID = process.env.NEXT_PUBLIC_LIFF_ID;

type Status = "loading" | "linked" | "added" | "error";

export default function LiffLandingPage() {
  const [status, setStatus] = useState<Status>("loading");
  const [displayName, setDisplayName] = useState<string>("");
  const [errorMsg, setErrorMsg] = useState<string>("");

  useEffect(() => {
    let cancelled = false;

    (async () => {
      try {
        if (!LIFF_ID) {
          throw new Error("NEXT_PUBLIC_LIFF_ID ยังไม่ได้ตั้งค่า");
        }

        const liff = (await import("@line/liff")).default;
        await liff.init({ liffId: LIFF_ID });

        if (!liff.isLoggedIn()) {
          liff.login();
          return;
        }

        const idToken = liff.getIDToken();
        if (!idToken) {
          throw new Error("ไม่พบ LINE ID token");
        }

        try {
          const profile = await liff.getProfile();
          if (!cancelled) setDisplayName(profile.displayName ?? "");
        } catch {
          // Profile is non-critical for linking
        }

        const res = await fetch("/api/line/liff-link", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ idToken }),
        });
        const json = (await res.json()) as {
          linked?: boolean;
          error?: string;
        };

        if (!res.ok) {
          throw new Error(json.error ?? "เชื่อมบัญชีล้มเหลว");
        }

        if (cancelled) return;
        setStatus(json.linked ? "linked" : "added");
      } catch (e) {
        if (cancelled) return;
        setErrorMsg(e instanceof Error ? e.message : String(e));
        setStatus("error");
      }
    })();

    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <main className="flex min-h-screen items-center justify-center bg-gradient-to-b from-green-50 to-white px-4 py-12">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex h-14 w-14 items-center justify-center rounded-full bg-[#06C755] text-white text-2xl">
            ✓
          </div>
          <h1 className="text-xl font-semibold">หมอรู้ × LINE</h1>
        </CardHeader>
        <CardContent className="space-y-4 text-center">
          {status === "loading" && (
            <p className="text-sm text-muted-foreground">
              กำลังเชื่อมต่อกับ LINE...
            </p>
          )}

          {status === "linked" && (
            <>
              <p className="text-base font-medium">
                ขอบคุณ {displayName || "คุณ"} 🎉
              </p>
              <p className="text-sm text-muted-foreground">
                เชื่อมบัญชี morroo กับ LINE สำเร็จ
                <br />
                เราจะแจ้งเตือนข่าวสารและโปรโมชั่นผ่าน LINE OA หมอรู้
              </p>
              <div className="flex flex-col gap-2 pt-2">
                <Link href="/dashboard">
                  <Button className="w-full bg-[#06C755] hover:bg-[#05a548]">
                    ไปหน้าแดชบอร์ด
                  </Button>
                </Link>
              </div>
            </>
          )}

          {status === "added" && (
            <>
              <p className="text-base font-medium">
                ยินดีต้อนรับ {displayName || "คุณ"} 👋
              </p>
              <p className="text-sm text-muted-foreground">
                เพิ่ม LINE OA หมอรู้เป็นเพื่อนเรียบร้อย
                <br />
                เข้าสู่ระบบ morroo เพื่อเชื่อมบัญชีและรับแจ้งเตือนส่วนตัว
              </p>
              <div className="flex flex-col gap-2 pt-2">
                <Link href="/login?next=/line/liff">
                  <Button className="w-full bg-[#06C755] hover:bg-[#05a548]">
                    เข้าสู่ระบบ
                  </Button>
                </Link>
                <Link href="/register">
                  <Button variant="outline" className="w-full">
                    สมัครสมาชิก
                  </Button>
                </Link>
              </div>
            </>
          )}

          {status === "error" && (
            <>
              <p className="text-sm text-red-600">เกิดข้อผิดพลาด</p>
              <p className="text-xs text-muted-foreground break-words">
                {errorMsg}
              </p>
              <Button
                variant="outline"
                onClick={() => window.location.reload()}
              >
                ลองใหม่
              </Button>
            </>
          )}
        </CardContent>
      </Card>
    </main>
  );
}
