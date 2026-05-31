import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Trophy, Flame, Zap } from "lucide-react";
import { createClient } from "@/lib/supabase/server";
import { xpToLevel } from "@/lib/school/xp";

export const dynamic = "force-dynamic";

export const metadata = {
  title: "Leaderboard — School",
  description: "อันดับ XP สูงสุด — แข่งกันเล็กๆ น้อยๆ",
};

interface LeaderRow {
  id: string;
  name: string | null;
  school_xp: number | null;
  current_year: number | null;
}

export default async function LeaderboardPage() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();

  const { data } = await supabase
    .from("profiles")
    .select("id, name, school_xp, current_year")
    .gt("school_xp", 0)
    .order("school_xp", { ascending: false })
    .limit(50);
  const rows = (data as LeaderRow[]) ?? [];

  // Find current user's rank
  let myRank: number | null = null;
  let myRow: LeaderRow | null = null;
  if (user) {
    const idx = rows.findIndex((r) => r.id === user.id);
    if (idx >= 0) {
      myRank = idx + 1;
      myRow = rows[idx];
    } else {
      // user not in top 50 — fetch own row separately
      const { data: own } = await supabase
        .from("profiles")
        .select("id, name, school_xp, current_year")
        .eq("id", user.id)
        .maybeSingle();
      myRow = (own as LeaderRow) ?? null;
      if (myRow?.school_xp) {
        const { count } = await supabase
          .from("profiles")
          .select("id", { count: "exact", head: true })
          .gt("school_xp", myRow.school_xp);
        myRank = (count ?? 0) + 1;
      }
    }
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link href="/school">
        <Button variant="ghost" size="sm" className="gap-2 -ml-2 mb-4">
          <ArrowLeft className="h-4 w-4" /> กลับ
        </Button>
      </Link>
      <div className="mb-4 flex items-center gap-2">
        <Badge className="bg-yellow-100 text-yellow-700">Leaderboard</Badge>
        <Badge variant="outline">{rows.length} คน</Badge>
      </div>
      <h1 className="text-2xl font-bold mb-1 flex items-center gap-2">
        <Trophy className="h-6 w-6 text-yellow-600" /> อันดับ XP
      </h1>
      <p className="text-sm text-muted-foreground mb-6">
        ทำ flashcard / quiz / lesson เพื่อสะสม XP — เป็นการแข่งกันเบาๆ
      </p>

      {myRow && myRank && (
        <Card className="mb-4 border-brand bg-brand/5">
          <CardContent className="p-4 flex items-center gap-3">
            <span className="text-2xl font-bold text-brand">#{myRank}</span>
            <div className="flex-1">
              <p className="font-semibold">{myRow.name ?? "คุณ"} (You)</p>
              <p className="text-xs text-muted-foreground">
                Level {xpToLevel(myRow.school_xp ?? 0).level}
              </p>
            </div>
            <div className="flex items-center gap-1 text-amber-600 font-bold">
              <Zap className="h-4 w-4" /> {myRow.school_xp ?? 0}
            </div>
          </CardContent>
        </Card>
      )}

      {rows.length === 0 ? (
        <div className="border rounded-lg p-8 text-center text-muted-foreground">
          ยังไม่มีใครสะสม XP — เป็นคนแรกสิ!
        </div>
      ) : (
        <div className="space-y-2">
          {rows.map((r, i) => {
            const me = r.id === user?.id;
            const { level } = xpToLevel(r.school_xp ?? 0);
            const rank = i + 1;
            const medal = rank === 1 ? "🥇" : rank === 2 ? "🥈" : rank === 3 ? "🥉" : `#${rank}`;
            return (
              <Card key={r.id} className={me ? "border-brand" : ""}>
                <CardContent className="p-3 flex items-center gap-3">
                  <span className="text-xl font-bold w-12 text-center">{medal}</span>
                  <div className="flex-1 min-w-0">
                    <p className="font-medium truncate">
                      {r.name ?? "Anonymous"}
                      {me && <Badge variant="outline" className="ml-2 text-xs">You</Badge>}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      Level {level}
                      {r.current_year && ` · ปี ${r.current_year}`}
                    </p>
                  </div>
                  <div className="flex items-center gap-1 text-amber-600 font-bold text-sm">
                    <Zap className="h-3 w-3" /> {r.school_xp ?? 0}
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
