"use client";

import Link from "next/link";
import { Sparkles, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";

type Props = {
  surface: string;
  /**
   * ปลายทางของ "สิ่งที่ลองได้ทันทีบนหน้านี้ โดยไม่ต้องสมัคร"
   *
   * เดิมแบนเนอร์นี้มีปุ่มเดียวคือ "สมัครฟรี" แล้ววางไว้บนสุดของหน้า — คนที่เพิ่ง
   * เข้ามายังไม่ทันเห็นว่าเรามีอะไร ก็โดนขอให้ลงทะเบียนก่อนแล้ว (2026-07-25
   * เจ้าของสั่งว่า "อยากจะโชว์ของก่อน... ค่อยให้ลงทะเบียนทีหลัง") เมื่อส่ง prop
   * นี้มา ปุ่มหลักจะกลายเป็นทางลองฟรี ส่วนการสมัครลดเป็นลิงก์ข้อความรอง
   */
  tryHref?: string;
  tryLabel?: string;
};

// Promotes what a guest can try right now on key landing pages. The parent
// decides when to render it (typically only when !user), so this component
// itself is presentational + click tracking.
export default function FreeTrialBanner({ surface, tryHref, tryLabel }: Props) {
  return (
    <div className="mb-6 rounded-2xl border border-brand/20 bg-gradient-to-r from-brand/10 via-brand/5 to-brand-light/10 p-5 sm:p-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4 sm:gap-6">
        <div className="flex items-center gap-3 flex-1">
          <div className="shrink-0 h-12 w-12 rounded-full bg-brand/10 flex items-center justify-center">
            <Sparkles className="h-6 w-6 text-brand" />
          </div>
          <div>
            <div className="text-base sm:text-lg font-bold text-foreground">
              {tryHref ? "ลองได้เลย ไม่ต้องสมัคร ไม่ต้องใส่บัตร" : "ทดลองฟรี ไม่ต้องใส่บัตรเครดิต"}
            </div>
            <div className="text-sm text-muted-foreground mt-0.5">
              MCQ 5 ข้อ/สาขา · MEQ 2 เคส · Long Case 1 เคส · ใช้ AI ตรวจคำตอบ
            </div>
          </div>
        </div>

        <div className="flex w-full shrink-0 flex-col items-stretch gap-2 sm:w-auto sm:items-end">
          {tryHref ? (
            <>
              <Link
                href={tryHref}
                onClick={() => track("free_try_cta_click", { surface })}
                className="w-full sm:w-auto"
              >
                <Button
                  size="lg"
                  className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white"
                >
                  {tryLabel ?? "ลองฟรีตอนนี้"} <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </Link>
              <Link
                href="/register"
                onClick={() => track("free_trial_cta_click", { surface })}
                className="text-center text-sm font-medium text-brand underline underline-offset-4 hover:text-brand-light sm:text-right"
              >
                หรือสมัครฟรี เก็บความคืบหน้าไว้
              </Link>
            </>
          ) : (
            <Link
              href="/register"
              onClick={() => track("free_trial_cta_click", { surface })}
              className="w-full sm:w-auto"
            >
              <Button
                size="lg"
                className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white"
              >
                สมัครฟรี <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          )}
        </div>
      </div>
    </div>
  );
}
