import { Badge } from "@/components/ui/badge";
import { BookOpenCheck, CircleCheckBig, Loader2, Layers } from "lucide-react";
import type { BoardSpecialtyMetrics } from "@/lib/types-board";

/** Inline count badges for the specialty card row on /board.
 *  Shows live "พร้อมฝึก" + "กำลังจัดทำ" counts so customers can judge how much
 *  content really exists. Falls back to the static `total_mcq_count` badge when
 *  live metrics aren't available yet (RPC missing / no rows). */
export function BoardCountBadges({
  metrics,
  fallbackTotal,
}: {
  metrics?: BoardSpecialtyMetrics;
  fallbackTotal?: number | null;
}) {
  const hasLive = !!metrics && metrics.projectedTotal > 0;

  if (!hasLive) {
    return (
      <Badge variant="outline" className="gap-1 text-xs">
        <BookOpenCheck className="h-3 w-3" />
        MCQ {fallbackTotal ?? "?"} ข้อ
      </Badge>
    );
  }

  return (
    <>
      <Badge className="gap-1 text-xs bg-emerald-100 text-emerald-700">
        <CircleCheckBig className="h-3 w-3" />
        พร้อมฝึก {metrics.active.toLocaleString("th-TH")} ข้อ
      </Badge>
      {metrics.pending > 0 && (
        <Badge className="gap-1 text-xs bg-amber-100 text-amber-700">
          <Loader2 className="h-3 w-3 animate-spin" />
          กำลังจัดทำ +{metrics.pending.toLocaleString("th-TH")}
        </Badge>
      )}
    </>
  );
}

/** Full transparency panel for the specialty detail page header.
 *  Lays out the three numbers the customer asked to see: how many questions
 *  exist now, how many are being built, and the projected total. */
export function BoardCountPanel({
  metrics,
  fallbackTotal,
}: {
  metrics?: BoardSpecialtyMetrics;
  fallbackTotal?: number | null;
}) {
  const active = metrics?.active ?? fallbackTotal ?? 0;
  const pending = metrics?.pending ?? 0;
  const projected = metrics?.projectedTotal ?? fallbackTotal ?? 0;

  if (projected === 0) return null;

  const fmt = (n: number) => n.toLocaleString("th-TH");

  return (
    <div className="rounded-lg border bg-muted/30 p-4">
      <div className="grid grid-cols-3 divide-x text-center">
        <div className="px-2">
          <div className="flex items-center justify-center gap-1 text-emerald-700">
            <CircleCheckBig className="h-4 w-4" />
            <span className="text-2xl font-bold tabular-nums">{fmt(active)}</span>
          </div>
          <div className="text-xs text-muted-foreground mt-0.5">พร้อมฝึกแล้ว</div>
        </div>
        <div className="px-2">
          <div className="flex items-center justify-center gap-1 text-amber-700">
            {pending > 0 && <Loader2 className="h-4 w-4 animate-spin" />}
            <span className="text-2xl font-bold tabular-nums">{fmt(pending)}</span>
          </div>
          <div className="text-xs text-muted-foreground mt-0.5">กำลังจัดทำ</div>
        </div>
        <div className="px-2">
          <div className="flex items-center justify-center gap-1 text-foreground">
            <Layers className="h-4 w-4" />
            <span className="text-2xl font-bold tabular-nums">{fmt(projected)}</span>
          </div>
          <div className="text-xs text-muted-foreground mt-0.5">รวมทั้งหมด</div>
        </div>
      </div>
      {pending > 0 && (
        <p className="mt-3 text-center text-xs text-muted-foreground">
          ทีมงานกำลังเพิ่มข้อสอบใหม่อีก {fmt(pending)} ข้อ — คลังจะอัปเดตอัตโนมัติเมื่อตรวจเสร็จ
        </p>
      )}
    </div>
  );
}
