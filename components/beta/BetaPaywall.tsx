"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Lock, Sparkles } from "lucide-react";
import { formatThaiDate } from "@/lib/beta";
import type { BetaStatus } from "@/lib/beta";

interface Props {
  status: BetaStatus;
  // When true, user was blocked because the 21 days expired (not quota).
  reason?: "quota" | "expired";
}

export default function BetaPaywall({ status, reason = "quota" }: Props) {
  const hasCoupon = Boolean(status.couponCode);
  const pricingHref = hasCoupon
    ? `/pricing?coupon=${encodeURIComponent(status.couponCode!)}`
    : "/pricing";

  if (hasCoupon) {
    return (
      <Card className="border-brand bg-brand/5">
        <CardContent className="p-6 text-center space-y-4">
          <div className="mx-auto w-12 h-12 rounded-full bg-brand/10 flex items-center justify-center">
            <Sparkles className="h-6 w-6 text-brand" />
          </div>
          <h3 className="text-lg font-bold">🎉 คุณมีคูปองส่วนลด 50%!</h3>
          <div className="inline-flex items-center gap-2 rounded-lg border border-dashed border-brand/40 bg-white px-4 py-2 font-mono font-bold text-brand">
            {status.couponCode}
          </div>
          {status.expiresAt && (
            <p className="text-xs text-muted-foreground">
              คูปองหมดอายุ:{" "}
              {formatThaiDate(
                new Date(status.expiresAt.getTime() + 14 * 86_400_000)
              )}
            </p>
          )}
          <p className="text-sm">ลด 50% สำหรับเดือนแรก</p>
          <ul className="text-sm text-left max-w-xs mx-auto space-y-1">
            <li>✅ ทำข้อสอบ unlimited</li>
            <li>✅ เฉลยละเอียดทุกข้อ</li>
            <li>✅ ถาม AI ได้ไม่จำกัด</li>
            <li>✅ MEQ + Long Case (ในแพ็กเกจเต็ม)</li>
          </ul>
          <Link href={pricingHref}>
            <Button className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white">
              ใช้คูปองและสมัคร
            </Button>
          </Link>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="border-brand/30 bg-brand/5">
      <CardContent className="p-6 text-center space-y-4">
        <div className="mx-auto w-12 h-12 rounded-full bg-brand/10 flex items-center justify-center">
          <Lock className="h-6 w-6 text-brand" />
        </div>
        <h3 className="text-lg font-bold">
          {reason === "expired"
            ? "สิทธิ์ Beta หมดเวลาแล้ว"
            : "คุณใช้สิทธิ์ Beta ครบแล้ว"}
        </h3>
        <ul className="text-sm text-left max-w-xs mx-auto space-y-1">
          <li>✅ ทำข้อสอบ unlimited</li>
          <li>✅ เฉลยละเอียดทุกข้อ</li>
          <li>✅ ถาม AI ได้ไม่จำกัด</li>
          <li>✅ MEQ + Long Case (ในแพ็กเกจเต็ม)</li>
        </ul>
        <p className="text-sm font-medium">เริ่มต้น 199 บาท/เดือน</p>
        <div className="flex flex-col sm:flex-row gap-2 justify-center items-center">
          <Link href={pricingHref}>
            <Button className="bg-brand hover:bg-brand-light text-white">
              ดูแพ็กเกจ
            </Button>
          </Link>
          <Link href="/" className="text-xs text-muted-foreground hover:underline">
            กลับหน้าหลัก
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
