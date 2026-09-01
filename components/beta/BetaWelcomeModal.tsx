"use client";

import Link from "next/link";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogBody,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useBeta } from "./BetaProvider";

export default function BetaWelcomeModal() {
  const { status, markWelcomeSeen } = useBeta();

  if (!status || !status.isBeta || status.hasSeenWelcome || status.isExpired) {
    return null;
  }

  const isExisting = status.betaEnrolledVia === "existing_user_upgrade";

  return (
    <Dialog open onClose={markWelcomeSeen}>
      <DialogHeader>
        <DialogTitle>
          {isExisting ? "🎉 คุณได้สิทธิ์ Beta Tester ฟรี!" : "ยินดีต้อนรับสู่ MorRoo 👋"}
        </DialogTitle>
      </DialogHeader>
      <DialogBody className="text-sm leading-relaxed">
        {isExisting ? (
          <>
            <p>
              ขอบคุณที่เป็นผู้ใช้รุ่นแรกของ MorRoo 🙏
              <br />
              เราอัปเกรดบัญชีของคุณเป็น Beta Tester แล้ว
            </p>
            <ul className="space-y-1 pt-1">
              <li>✅ ทำข้อสอบได้อีก 25 ข้อ (รีเซ็ตใหม่จาก 0)</li>
              <li>⏰ ใช้ได้ 21 วัน นับจากวันนี้</li>
              <li>🎁 ตอบ feedback สั้นๆ → รับคูปองส่วนลด 50% สำหรับเดือนแรก</li>
            </ul>
          </>
        ) : (
          <>
            <p>คุณได้รับสิทธิ์ Beta Tester</p>
            <ul className="space-y-1 pt-1">
              <li>✅ ทำข้อสอบฟรี 25 ข้อ (แทนที่ 5 ข้อของบัญชีทั่วไป)</li>
              <li>⏰ ใช้ได้ 21 วัน นับจากวันนี้</li>
              <li>🎁 ตอบ feedback → รับส่วนลด 50% เดือนแรก</li>
            </ul>
            <p className="text-muted-foreground text-xs pt-2">
              หมายเหตุ: ช่วง Beta ยังไม่มีเฉลยละเอียดและ AI ถามตอบ
              สมัคร Paid เพื่อปลดล็อคฟีเจอร์เต็ม
            </p>
          </>
        )}
      </DialogBody>
      <DialogFooter>
        <Link href="/nl/practice" onClick={() => void markWelcomeSeen()}>
          <Button className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white">
            เริ่มทำข้อสอบ
          </Button>
        </Link>
      </DialogFooter>
    </Dialog>
  );
}
