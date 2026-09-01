import { createAdminClient } from "@/lib/supabase/admin";
import { getPricingPromoLevel } from "@/lib/site-config";
import { ShieldCheck } from "lucide-react";

/**
 * Honest reassurance bar shown on the pricing page when the autopilot turns it
 * on (people view pricing but don't convert). No fake scarcity — just the real
 * value props that reduce purchase anxiety. Reads its on/off flag from
 * app_settings; rendered inside <Suspense> so the DB read streams.
 */
export default async function PricingPromo() {
  const level = await getPricingPromoLevel(createAdminClient());
  if (level === 0) return null;

  return (
    <div className="mb-8 flex flex-wrap items-center justify-center gap-x-6 gap-y-2 rounded-xl border border-brand/20 bg-brand/5 px-4 py-3 text-center text-sm font-medium text-foreground">
      <span className="flex items-center gap-1.5">
        <ShieldCheck className="h-4 w-4 text-brand" /> เริ่มฟรี ไม่ต้องใช้บัตรเครดิต
      </span>
      <span className="flex items-center gap-1.5">
        <ShieldCheck className="h-4 w-4 text-brand" /> ยกเลิกได้ทุกเมื่อ
      </span>
      <span className="flex items-center gap-1.5">
        <ShieldCheck className="h-4 w-4 text-brand" /> เฉลยละเอียดจากผู้เชี่ยวชาญ
      </span>
    </div>
  );
}
