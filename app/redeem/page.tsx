"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Ticket, CheckCircle, XCircle, Loader2 } from "lucide-react";

const ERROR_MESSAGES: Record<string, string> = {
  not_found: "ไม่พบโค้ดนี้ กรุณาตรวจสอบอีกครั้ง",
  expired: "โค้ดนี้หมดอายุแล้ว",
  max_uses: "โค้ดนี้ถูกใช้ครบจำนวนแล้ว",
  already_used: "คุณใช้โค้ดนี้ไปแล้ว",
  inactive: "โค้ดนี้ไม่พร้อมใช้งาน",
  unauthorized: "กรุณาเข้าสู่ระบบก่อนใช้โค้ด",
  wrong_platform: "โค้ดนี้ไม่สามารถใช้กับแพลตฟอร์มนี้ได้",
  not_started: "โค้ดนี้ยังไม่เริ่มใช้งาน",
  no_code: "กรุณากรอกโค้ด",
};

export default function RedeemPage() {
  const [code, setCode] = useState("");
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{
    success: boolean;
    benefit?: string;
    reason?: string;
  } | null>(null);

  const handleRedeem = async () => {
    if (!code.trim()) return;
    setLoading(true);
    setResult(null);

    try {
      const res = await fetch("/api/coupon/redeem", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code: code.trim() }),
      });
      const data = await res.json();

      if (data.success) {
        setResult({ success: true, benefit: data.benefit });
      } else {
        setResult({ success: false, reason: data.reason || "server_error" });
      }
    } catch {
      setResult({ success: false, reason: "server_error" });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-lg px-4 py-16">
      <div className="text-center mb-8">
        <div className="mx-auto w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center mb-4">
          <Ticket className="h-8 w-8 text-brand" />
        </div>
        <h1 className="text-2xl font-bold">ใช้โค้ดคูปอง</h1>
        <p className="text-muted-foreground mt-2">
          กรอกโค้ดที่ได้รับเพื่อรับสิทธิพิเศษ
        </p>
      </div>

      <Card>
        <CardHeader />
        <CardContent className="space-y-4">
          <div className="flex gap-2">
            <Input
              placeholder="กรอกโค้ด เช่น BOOTH-EMS2026"
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              onKeyDown={(e) => e.key === "Enter" && handleRedeem()}
              className="text-center text-lg font-mono tracking-wider uppercase"
              disabled={loading}
            />
            <Button
              onClick={handleRedeem}
              disabled={loading || !code.trim()}
              className="bg-brand hover:bg-brand-light text-white shrink-0"
            >
              {loading ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                "ใช้โค้ด"
              )}
            </Button>
          </div>

          {result && (
            <div
              className={`p-4 rounded-lg flex items-start gap-3 ${
                result.success
                  ? "bg-green-50 border border-green-200"
                  : "bg-red-50 border border-red-200"
              }`}
            >
              {result.success ? (
                <>
                  <CheckCircle className="h-5 w-5 text-green-600 shrink-0 mt-0.5" />
                  <div>
                    <p className="font-semibold text-green-800">
                      ใช้โค้ดสำเร็จ!
                    </p>
                    <p className="text-sm text-green-700 mt-1">
                      สิทธิ์ที่ได้รับ: {result.benefit}
                    </p>
                  </div>
                </>
              ) : (
                <>
                  <XCircle className="h-5 w-5 text-red-600 shrink-0 mt-0.5" />
                  <div>
                    <p className="font-semibold text-red-800">
                      ไม่สามารถใช้โค้ดได้
                    </p>
                    <p className="text-sm text-red-700 mt-1">
                      {ERROR_MESSAGES[result.reason || ""] ||
                        "เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง"}
                    </p>
                  </div>
                </>
              )}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
