import Link from "next/link";
import { Lock } from "lucide-react";
import { PLAN_CATALOG, planIntroAmount, type PlanType } from "@/lib/membership";

export interface ItemUpsellProps {
  /** Card headline, e.g. "ปลดล็อกวิชานี้" */
  title: string;
  /** Plan string of the item (lib/items.ts itemPlanType) */
  itemPlan: string;
  itemLabel: string;
  itemAmount: number;
  /** "ซื้อขาด" / "/ เดือน" */
  itemPeriod?: string;
  /** Whole-product plan shown as the middle option */
  productPlan: PlanType;
  /** Widest plan shown as the recommended option (omit for board) */
  packPlan?: PlanType;
  note?: string;
  className?: string;
}

/**
 * In-context "buy just this / buy the product / buy the pack" card. Rendered
 * on the practice page for one subject, specialty, exam, case or topic when
 * the visitor lacks access — this is where per-item prices are sold, not
 * on /pricing (which stays one decision per track).
 *
 * Plain links only, so it works inside server and client components alike.
 */
export default function ItemUpsell({
  title,
  itemPlan,
  itemLabel,
  itemAmount,
  itemPeriod = "ซื้อขาด",
  productPlan,
  packPlan,
  note,
  className = "",
}: ItemUpsellProps) {
  const product = PLAN_CATALOG[productPlan];
  const pack = packPlan ? PLAN_CATALOG[packPlan] : null;
  const period = (d: "month" | "year" | "lifetime") =>
    d === "month" ? "/ เดือน" : d === "year" ? "/ ปี" : "";

  return (
    <div className={`rounded-xl border border-brand/30 bg-gradient-to-r from-brand/5 to-amber-50/60 p-4 ${className}`}>
      <div className="flex items-center gap-2 mb-3">
        <Lock className="h-4 w-4 text-brand" />
        <span className="text-sm font-semibold">{title}</span>
      </div>
      <div className={`grid gap-2 ${pack ? "sm:grid-cols-3" : "sm:grid-cols-2"}`}>
        <Link
          href={`/payment/${encodeURIComponent(itemPlan)}`}
          className="rounded-lg border bg-background p-3 hover:border-brand transition-colors"
        >
          <p className="text-xs text-muted-foreground">เฉพาะรายการนี้</p>
          <p className="text-sm font-medium leading-snug">{itemLabel}</p>
          <p className="mt-1 text-lg font-bold">
            ฿{itemAmount.toLocaleString()}{" "}
            <span className="text-xs font-normal text-muted-foreground">{itemPeriod}</span>
          </p>
        </Link>
        <Link
          href={`/payment/${productPlan}`}
          className="rounded-lg border bg-background p-3 hover:border-brand transition-colors"
        >
          <p className="text-xs text-muted-foreground">ทั้งระบบ</p>
          <p className="text-sm font-medium leading-snug">{product.label}</p>
          <p className="mt-1 text-lg font-bold">
            ฿{planIntroAmount(productPlan).toLocaleString()}{" "}
            <span className="text-xs font-normal text-muted-foreground">{period(product.duration)}</span>
          </p>
        </Link>
        {pack && packPlan && (
          <Link
            href={`/payment/${packPlan}`}
            className="relative rounded-lg border-2 border-brand bg-background p-3 hover:bg-brand/5 transition-colors"
          >
            <span className="absolute -top-2 right-2 rounded-full bg-brand px-2 py-0.5 text-[10px] font-semibold text-white">
              แนะนำ
            </span>
            <p className="text-xs text-muted-foreground">ครบทุกระบบ</p>
            <p className="text-sm font-medium leading-snug">แพ็ก นศพ. {pack.label}</p>
            <p className="mt-1 text-lg font-bold">
              ฿{planIntroAmount(packPlan).toLocaleString()}{" "}
              <span className="text-xs font-normal text-muted-foreground">{period(pack.duration)}</span>
            </p>
          </Link>
        )}
      </div>
      {note && <p className="mt-2 text-xs text-muted-foreground">{note}</p>}
    </div>
  );
}
