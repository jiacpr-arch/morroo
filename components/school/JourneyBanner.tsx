import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ArrowRight, Sparkles, Lock } from "lucide-react";
import {
  STAGES,
  getUnlockState,
  nextRecommendedAction,
  type JourneyContext,
} from "@/lib/school/journey";

/**
 * Replaces the old "เริ่มยังไง 3 ขั้น" + "เริ่มเรียนวันนี้" blocks with a single
 * focused next-step banner driven by the progressive-unlock journey. Server
 * component — purely presentational.
 */
export default function JourneyBanner(props: JourneyContext) {
  const state = getUnlockState(props);
  const next = nextRecommendedAction(props);
  const totalStages = STAGES.length;

  return (
    <Card className="mb-8 border-brand/20 bg-brand/5">
      <CardContent className="p-4 sm:p-5">
        {/* Stage header + progress */}
        <div className="flex items-center justify-between gap-2 mb-3">
          <div className="flex items-center gap-2">
            <Sparkles className="h-4 w-4 text-brand" />
            <span className="font-semibold">
              ด่าน {state.stageIndex + 1}/{totalStages} · {state.stage.title}
            </span>
            <Badge variant="outline">Level {state.level}</Badge>
          </div>
        </div>
        <p className="text-sm text-muted-foreground mb-3">{state.stage.desc}</p>

        {/* Stage dots */}
        <div className="flex gap-1.5 mb-4">
          {STAGES.map((s, i) => (
            <div
              key={s.id}
              title={s.title}
              className={`h-1.5 flex-1 rounded-full transition-colors ${
                i <= state.stageIndex ? "bg-brand" : "bg-brand/15"
              }`}
            />
          ))}
        </div>

        {/* Single recommended next action */}
        <Link href={next.href}>
          <div className="group flex items-center gap-4 rounded-lg border border-brand/30 bg-background p-4 transition-all hover:border-brand hover:shadow-sm cursor-pointer">
            <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-brand text-white">
              <ArrowRight className="h-5 w-5" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-bold">ก้าวต่อไป: {next.label}</p>
              <p className="text-xs text-muted-foreground mt-0.5">{next.hint}</p>
            </div>
            <Button className="gap-2 shrink-0">
              ไปเลย <ArrowRight className="h-4 w-4" />
            </Button>
          </div>
        </Link>

        {/* Teaser of what unlocks next */}
        {state.nextStage && (
          <p className="mt-3 flex items-center gap-1.5 text-xs text-muted-foreground">
            <Lock className="h-3.5 w-3.5" />
            อีกนิดจะปลดล็อก <b className="text-foreground">{state.nextStage.title}</b> —{" "}
            {state.nextStage.unlockLabel}
          </p>
        )}
      </CardContent>
    </Card>
  );
}
