"use client";

import Link from "next/link";
import { Sparkles, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { track } from "@/lib/analytics";

type Props = {
  surface: string;
};

// Promotes the free-trial signup on key landing pages for non-authenticated
// visitors. The parent decides when to render it (typically only when
// !user), so this component itself is presentational + click tracking.
export default function FreeTrialBanner({ surface }: Props) {
  return (
    <div className="mb-6 rounded-2xl border border-brand/20 bg-gradient-to-r from-brand/10 via-brand/5 to-brand-light/10 p-5 sm:p-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center gap-4 sm:gap-6">
        <div className="flex items-center gap-3 flex-1">
          <div className="shrink-0 h-12 w-12 rounded-full bg-brand/10 flex items-center justify-center">
            <Sparkles className="h-6 w-6 text-brand" />
          </div>
          <div>
            <div className="text-base sm:text-lg font-bold text-foreground">
              ทดลองฟรี ไม่ต้องใส่บัตรเครดิต
            </div>
            <div className="text-sm text-muted-foreground mt-0.5">
              MCQ 5 ข้อ/สาขา · MEQ 2 เคส · Long Case 1 เคส · ใช้ AI ตรวจคำตอบ
            </div>
          </div>
        </div>
        <Link
          href="/register"
          onClick={() => track("free_trial_cta_click", { surface })}
          className="shrink-0 w-full sm:w-auto"
        >
          <Button
            size="lg"
            className="w-full sm:w-auto bg-brand hover:bg-brand-light text-white"
          >
            สมัครฟรี <ArrowRight className="ml-2 h-4 w-4" />
          </Button>
        </Link>
      </div>
    </div>
  );
}
