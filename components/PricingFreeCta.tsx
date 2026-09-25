"use client";

import Link from "next/link";
import { track } from "@/lib/analytics";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

/**
 * Most pricing-page visitors look at the plans and click nothing (in the last
 * 30 days only ~1 in 5 pricing viewers pressed any plan CTA). This gives the
 * undecided majority an obvious low-commitment next step — start free, no card —
 * instead of leaving with no action. Tracked separately so its lift on the
 * pricing → register step is measurable.
 */
export default function PricingFreeCta({ align = "center" }: { align?: "left" | "center" }) {
  return (
    <div className={cn("mt-6 flex flex-col gap-2", align === "left" ? "items-start" : "items-center")}>
      <Link
        href="/register"
        onClick={() =>
          track("pricing_free_cta_click", { surface: "pricing_hero" })
        }
      >
        <Button
          size="lg"
          className="bg-brand hover:bg-brand-light text-white px-8"
        >
          เริ่มใช้ฟรี — ไม่ต้องใส่บัตร
        </Button>
      </Link>
      <span className="text-xs text-muted-foreground">
        ลองทำข้อสอบตัวอย่างฟรีทุกวิชา ก่อนตัดสินใจสมัครแพ็กเกจ
      </span>
    </div>
  );
}
