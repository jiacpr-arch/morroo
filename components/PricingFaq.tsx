"use client";

import { track } from "@/lib/analytics";
import { PRICING_FAQ_ITEMS } from "@/lib/pricing-faq";

type Props = {
  surface: string;
};

export default function PricingFaq({ surface }: Props) {
  return (
    <div className="mx-auto max-w-3xl">
      <h2 className="text-2xl sm:text-3xl font-bold text-center mb-2">
        คำถามที่พบบ่อย
      </h2>
      <p className="text-center text-muted-foreground mb-8">
        คำตอบสั้นๆ สำหรับเรื่องที่คนสงสัยก่อนตัดสินใจ
      </p>
      <div className="space-y-3">
        {PRICING_FAQ_ITEMS.map((f, i) => (
          <details
            key={f.q}
            className="group rounded-xl border bg-card p-4 sm:p-5"
            onToggle={(e) => {
              if ((e.currentTarget as HTMLDetailsElement).open) {
                track("pricing_faq_expand", { surface, index: i });
              }
            }}
          >
            <summary className="cursor-pointer list-none flex items-start justify-between gap-3 font-semibold text-foreground">
              <span className="flex-1">{f.q}</span>
              <span className="shrink-0 mt-0.5 text-muted-foreground text-sm group-open:rotate-180 transition-transform">
                ▾
              </span>
            </summary>
            <p className="mt-3 text-sm text-muted-foreground leading-relaxed">
              {f.a}
            </p>
          </details>
        ))}
      </div>
    </div>
  );
}
