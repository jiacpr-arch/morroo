"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Trophy, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

interface BoardRow {
  rank: number;
  user_id: string;
  display_name: string;
  correct_count: number;
  total_count: number;
  accuracy: number | null;
  streak: number;
}

interface MyRank {
  rank: number;
  correct_count: number;
  total_count: number;
  accuracy: number | null;
  total_participants: number;
}

export default function LeaderboardCard({ currentUserId }: { currentUserId: string }) {
  const [period, setPeriod] = useState<"weekly" | "alltime">("weekly");
  const [board, setBoard] = useState<BoardRow[]>([]);
  const [me, setMe] = useState<MyRank | null>(null);
  const [optIn, setOptIn] = useState<boolean | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    let cancelled = false;
    async function load() {
      setLoading(true);
      const supabase = createClient();
      const [boardRes, profileRes] = await Promise.all([
        fetch(`/api/leaderboard?period=${period}&limit=10`).then((r) => r.json()),
        supabase.from("profiles").select("leaderboard_opt_in").eq("id", currentUserId).single(),
      ]);
      if (cancelled) return;
      setBoard((boardRes.board as BoardRow[]) ?? []);
      setMe((boardRes.me as MyRank | null) ?? null);
      setOptIn(!!profileRes.data?.leaderboard_opt_in);
      setLoading(false);
    }
    load();
    return () => {
      cancelled = true;
    };
  }, [period, currentUserId]);

  async function toggleOptIn() {
    if (optIn === null) return;
    setSaving(true);
    const supabase = createClient();
    const next = !optIn;
    const { error } = await supabase
      .from("profiles")
      .update({ leaderboard_opt_in: next })
      .eq("id", currentUserId);
    if (!error) {
      setOptIn(next);
      // Refetch so the user sees themselves appear/disappear.
      const boardRes = await fetch(`/api/leaderboard?period=${period}&limit=10`).then((r) => r.json());
      setBoard((boardRes.board as BoardRow[]) ?? []);
      setMe((boardRes.me as MyRank | null) ?? null);
    }
    setSaving(false);
  }

  return (
    <Card className="mb-8">
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <CardTitle className="text-base flex items-center gap-2">
            <Trophy className="h-5 w-5 text-amber-500" />
            อันดับผู้ฝึก
          </CardTitle>
          <div className="flex gap-1">
            <button
              onClick={() => setPeriod("weekly")}
              className={`text-xs px-2 py-1 rounded ${
                period === "weekly" ? "bg-brand text-white" : "text-muted-foreground hover:bg-muted"
              }`}
            >
              สัปดาห์นี้
            </button>
            <button
              onClick={() => setPeriod("alltime")}
              className={`text-xs px-2 py-1 rounded ${
                period === "alltime" ? "bg-brand text-white" : "text-muted-foreground hover:bg-muted"
              }`}
            >
              ทั้งหมด
            </button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex justify-center py-6">
            <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
          </div>
        ) : board.length === 0 ? (
          <p className="text-sm text-muted-foreground text-center py-6">
            ยังไม่มีใครขึ้นกระดานในช่วงนี้ — ฝึกอย่างน้อย 5 ข้อเพื่อเข้าร่วม
          </p>
        ) : (
          <div className="space-y-1.5">
            {board.map((row) => {
              const isMe = row.user_id === currentUserId;
              const medal = row.rank === 1 ? "🥇" : row.rank === 2 ? "🥈" : row.rank === 3 ? "🥉" : null;
              return (
                <div
                  key={row.user_id}
                  className={`flex items-center gap-3 rounded-lg px-3 py-2 ${
                    isMe ? "bg-brand/10 border border-brand/30" : "border"
                  }`}
                >
                  <span className="w-8 text-center text-sm font-semibold">
                    {medal ?? `#${row.rank}`}
                  </span>
                  <span className="flex-1 text-sm font-medium truncate">
                    {row.display_name}
                    {isMe && <span className="text-brand ml-1">(คุณ)</span>}
                  </span>
                  {row.streak > 0 && (
                    <span className="text-xs text-orange-600 shrink-0">🔥 {row.streak}</span>
                  )}
                  <span className="text-sm font-bold shrink-0">
                    {row.correct_count}
                    <span className="text-xs font-normal text-muted-foreground">
                      /{row.total_count}
                    </span>
                  </span>
                </div>
              );
            })}
          </div>
        )}

        {/* Show current user's rank if they're outside the top 10 */}
        {me && board.every((r) => r.user_id !== currentUserId) && (
          <div className="mt-3 rounded-lg px-3 py-2 bg-brand/10 border border-brand/30 flex items-center gap-3">
            <span className="w-8 text-center text-sm font-semibold">#{me.rank}</span>
            <span className="flex-1 text-sm font-medium">
              คุณ <span className="text-xs text-muted-foreground">/ {me.total_participants} คน</span>
            </span>
            <span className="text-sm font-bold">
              {me.correct_count}
              <span className="text-xs font-normal text-muted-foreground">/{me.total_count}</span>
            </span>
          </div>
        )}

        {/* Opt-in toggle */}
        {optIn !== null && (
          <div className="mt-4 pt-3 border-t">
            {optIn ? (
              <div className="flex items-center justify-between gap-3">
                <p className="text-xs text-muted-foreground">
                  ชื่อคุณแสดงบนกระดานเป็น &ldquo;ชื่อ + อักษรแรกของนามสกุล&rdquo;
                </p>
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={toggleOptIn}
                  disabled={saving}
                  className="text-xs shrink-0"
                >
                  ซ่อนชื่อ
                </Button>
              </div>
            ) : (
              <div className="flex items-center justify-between gap-3">
                <p className="text-xs text-muted-foreground">
                  ร่วมขึ้นกระดานอันดับ? โชว์ชื่อย่อของคุณให้เพื่อนๆ เห็น
                </p>
                <Button
                  size="sm"
                  onClick={toggleOptIn}
                  disabled={saving}
                  className="text-xs shrink-0 bg-brand hover:bg-brand-light text-white"
                >
                  เข้าร่วม
                </Button>
              </div>
            )}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
