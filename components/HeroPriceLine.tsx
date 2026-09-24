"use client";

import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { track } from "@/lib/analytics";
import { PRICING_PLANS } from "@/lib/types";
import { cn } from "@/lib/utils";

/**
 * บรรทัดราคาสั้นๆ ใต้ CTA หลัก — เดิมราคาสมาชิกอยู่ที่ section 9 ของหน้าแรก
 * (เลื่อนลง ~5 จอ) ทำให้คนที่มาจากโฆษณาเห็นราคาแค่ 1% (362 คนเข้า เห็นราคา
 * แค่ 3 คน) บรรทัดนี้ดึงราคาที่ใช้งานจริงมาโชว์ตั้งแต่จอแรก อ่านจาก
 * PRICING_PLANS ตัวเดียวกับที่ PricingCard ใช้ — ไม่ hard-code ราคาไว้สองที่
 *
 * คลิกแล้วเลื่อนไปที่ #pricing (หรือ href ที่ส่งมา) ซึ่งจะทำให้
 * PricingViewTracker ที่วางไว้ตรงนั้นยิง pricing_view ให้เองตามปกติ — บรรทัด
 * นี้ยิงแค่ pricing_cta_click (ตัวหารของ "เห็นราคาแล้วสนใจกดดูต่อ") ไม่ยิง
 * pricing_view ซ้ำ ไม่งั้นตัวเลข 10% ที่ตั้งเป้าไว้จะเฟ้อเทียบกับ pageview เฉยๆ
 */
export default function HeroPriceLine({
  surface,
  href = "#pricing",
  dark = false,
}: {
  surface: string;
  href?: string;
  dark?: boolean;
}) {
  const monthly = PRICING_PLANS.find((p) => p.type === "monthly");
  if (!monthly) return null;

  return (
    <Link
      href={href}
      onClick={() => track("pricing_cta_click", { surface, target: href, plan: monthly.type, price: monthly.price })}
      className={cn(
        "inline-flex items-center gap-1.5 text-sm font-medium underline-offset-4 hover:underline",
        dark ? "text-white/80 hover:text-white" : "text-white/85 hover:text-white",
      )}
    >
      สมาชิกใหม่ ฿{monthly.price.toLocaleString()}{monthly.period} · ยกเลิกได้ทุกเมื่อ · ดูแพ็กเกจ
      <ArrowRight className="h-3.5 w-3.5" />
    </Link>
  );
}
