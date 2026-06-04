import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Swords, CheckCircle2, ArrowRight } from "lucide-react";
import type { Quest } from "@/lib/school/quests";

/**
 * Weekly quest board for the School home. Server component — presentational.
 */
export default function WeeklyQuests({ quests }: { quests: Quest[] }) {
  const doneCount = quests.filter((q) => q.done).length;

  return (
    <Card className="mb-6 border-amber-200 bg-amber-50/40">
      <CardContent className="p-4 sm:p-5">
        <div className="flex items-center justify-between gap-2 mb-3">
          <p className="font-semibold flex items-center gap-2">
            <Swords className="h-4 w-4 text-amber-600" /> เควสต์สัปดาห์นี้
          </p>
          <Badge variant="outline">
            {doneCount}/{quests.length} สำเร็จ
          </Badge>
        </div>
        <div className="grid gap-3 sm:grid-cols-3">
          {quests.map((q) => {
            const pct = Math.min(100, Math.round((q.current / q.goal) * 100));
            return (
              <Link key={q.id} href={q.href}>
                <div
                  className={`group h-full rounded-lg border p-3 transition-all hover:shadow-sm ${
                    q.done
                      ? "border-emerald-300 bg-emerald-50/60"
                      : "border-muted bg-background hover:border-amber-300"
                  }`}
                >
                  <div className="flex items-start justify-between gap-2 mb-1">
                    <p className="font-medium text-sm leading-snug">{q.title}</p>
                    {q.done ? (
                      <CheckCircle2 className="h-4 w-4 text-emerald-600 shrink-0" />
                    ) : (
                      <ArrowRight className="h-4 w-4 text-muted-foreground shrink-0 opacity-0 group-hover:opacity-100 transition-opacity" />
                    )}
                  </div>
                  <p className="text-xs text-muted-foreground mb-2">{q.desc}</p>
                  <div className="h-1.5 bg-muted rounded-full overflow-hidden">
                    <div
                      className={`h-full transition-all ${
                        q.done ? "bg-emerald-500" : "bg-amber-500"
                      }`}
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <div className="mt-1.5 flex items-center justify-between">
                    <span className="text-[11px] text-muted-foreground tabular-nums">
                      {q.current}/{q.goal}
                    </span>
                    {q.reward && (
                      <span className="text-[11px] text-amber-700">{q.reward}</span>
                    )}
                  </div>
                </div>
              </Link>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
