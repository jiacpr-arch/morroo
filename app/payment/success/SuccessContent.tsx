"use client";

import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { CheckCircle } from "lucide-react";

export default function SuccessContent() {
  const searchParams = useSearchParams();
  const sessionId = searchParams.get("session_id");

  return (
    <div className="mx-auto max-w-lg px-4 py-16">
      <Card className="text-center">
        <CardContent className="py-12 space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-green-100 flex items-center justify-center">
            <CheckCircle className="h-8 w-8 text-green-600" />
          </div>

          <h1 className="text-2xl font-bold text-green-700">ชำระเงินสำเร็จ!</h1>

          <div className="space-y-2 text-muted-foreground">
            <p>แพ็กเกจของคุณถูกเปิดใช้งานแล้ว</p>
            <p className="text-sm">ระบบอาจใช้เวลาสักครู่ในการอัปเดต</p>
          </div>

          {sessionId && (
            <div className="rounded-lg bg-blue-50 border border-blue-200 p-3 text-sm text-blue-800">
              กรุณารอสักครู่ก่อนดาวน์โหลดใบเสร็จ ระบบกำลังสร้างใบเสร็จให้ท่าน
            </div>
          )}

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
        </CardContent>
      </Card>
    </div>
  );
}
