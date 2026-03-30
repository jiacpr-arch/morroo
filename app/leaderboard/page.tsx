"use client";

import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { Trophy, Medal, Loader2, Crown, Clock } from "lucide-react";
import type { LeaderboardEntry, Challenge } from "@/lib/types-standard";

export default function LeaderboardPage() {
  const [tab, setTab] = useState<"weekly" | "monthly">("weekly");
  const [loading, setLoading] = useState(true);
  const [entries, setEntries] = useState<LeaderboardEntry[]>([]);
  const [challenges, setChallenges] = useState<Challenge[]>([]);
  const [selectedChallenge, setSelectedChallenge] = useState<string>("");

  const supabase = createClient();

  useEffect(() => {
    async function load() {
      setLoading(true);

      // Fetch active challenges
      const { data: cData } = await supabase
        .from("challenges")
        .select("*")
        .eq("is_active", true)
        .eq("challenge_type", tab)
        .order("start_date", { ascending: false })
        .limit(10);

      const challs = (cData as Challenge[]) || [];
      setChallenges(challs);

      const targetId = selectedChallenge || challs[0]?.id || "";

      if (targetId) {
        const viewName = tab === "weekly" ? "leaderboard_weekly" : "leaderboard_monthly";
        const { data: lData } = await supabase
          .from(viewName)
          .select("*")
          .eq("challenge_id", targetId)
          .order("rank", { ascending: true })
          .limit(50);

        setEntries((lData as LeaderboardEntry[]) || []);
      } else {
        setEntries([]);
      }

      setLoading(false);
    }
    load();
  }, [tab, selectedChallenge]);

  const getRankIcon = (rank: number) => {
    if (rank === 1) return <Crown className="h-5 w-5 text-yellow-500" />;
    if (rank === 2) return <Medal className="h-5 w-5 text-gray-400" />;
    if (rank === 3) return <Medal className="h-5 w-5 text-amber-600" />;
    return <span className="text-sm font-bold text-muted-foreground w-5 text-center">{rank}</span>;
  };

  const getRankBg = (rank: number) => {
    if (rank === 1) return "bg-yellow-50 border-yellow-200";
    if (rank === 2) return "bg-gray-50 border-gray-200";
    if (rank === 3) return "bg-amber-50 border-amber-200";
    return "";
  };

  const formatTime = (seconds: number | null) => {
    if (!seconds) return "-";
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min}:${sec.toString().padStart(2, "0")}`;
  };

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="text-center mb-8">
        <div className="mx-auto w-16 h-16 rounded-full bg-yellow-100 flex items-center justify-center mb-4">
          <Trophy className="h-8 w-8 text-yellow-600" />
        </div>
        <h1 className="text-3xl font-bold">Leaderboard</h1>
        <p className="text-muted-foreground mt-2">
          กระดานคะแนนผู้เข้าแข่งขัน
        </p>
      </div>

      {/* Tab selector */}
      <div className="flex justify-center gap-2 mb-6">
        {(["weekly", "monthly"] as const).map((t) => (
          <button
            key={t}
            onClick={() => { setTab(t); setSelectedChallenge(""); }}
            className={`px-6 py-2 rounded-full text-sm font-medium transition-colors ${
              tab === t
                ? "bg-brand text-white"
                : "bg-muted text-muted-foreground hover:bg-muted/80"
            }`}
          >
            {t === "weekly" ? "รายสัปดาห์" : "รายเดือน"}
          </button>
        ))}
      </div>

      {/* Challenge selector */}
      {challenges.length > 1 && (
        <div className="flex justify-center mb-6">
          <select
            className="rounded-md border px-3 py-2 text-sm"
            value={selectedChallenge || challenges[0]?.id || ""}
            onChange={(e) => setSelectedChallenge(e.target.value)}
          >
            {challenges.map((c) => (
              <option key={c.id} value={c.id}>
                {c.title}
              </option>
            ))}
          </select>
        </div>
      )}

      {loading ? (
        <div className="flex justify-center py-16">
          <Loader2 className="h-8 w-8 animate-spin text-brand" />
        </div>
      ) : entries.length === 0 ? (
        <Card>
          <CardContent className="py-16 text-center">
            <Trophy className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-semibold">ยังไม่มีข้อมูล</h3>
            <p className="text-sm text-muted-foreground mt-1">
              {challenges.length === 0
                ? "ยังไม่มี Challenge ในขณะนี้"
                : "ยังไม่มีผู้เข้าร่วม Challenge นี้"}
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-2">
          {/* Header */}
          <div className="grid grid-cols-12 gap-2 px-4 py-2 text-xs font-medium text-muted-foreground uppercase">
            <div className="col-span-1">อันดับ</div>
            <div className="col-span-5">ผู้เข้าแข่งขัน</div>
            <div className="col-span-2 text-center">คะแนน</div>
            <div className="col-span-2 text-center">ถูก/ทั้งหมด</div>
            <div className="col-span-2 text-center">เวลา</div>
          </div>

          {entries.map((entry) => (
            <Card
              key={entry.user_id}
              className={getRankBg(entry.rank)}
            >
              <CardContent className="py-3">
                <div className="grid grid-cols-12 gap-2 items-center">
                  <div className="col-span-1 flex justify-center">
                    {getRankIcon(entry.rank)}
                  </div>
                  <div className="col-span-5 flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-brand/10 flex items-center justify-center text-sm font-bold text-brand">
                      {(entry.display_name || entry.name || "?").charAt(0)}
                    </div>
                    <span className="font-medium truncate">
                      {entry.display_name || entry.name || "ผู้เข้าแข่งขัน"}
                    </span>
                  </div>
                  <div className="col-span-2 text-center">
                    <Badge className="bg-brand/10 text-brand font-bold">
                      {entry.score}
                    </Badge>
                  </div>
                  <div className="col-span-2 text-center text-sm">
                    {entry.correct_answers}/{entry.total_questions}
                  </div>
                  <div className="col-span-2 text-center text-sm text-muted-foreground flex items-center justify-center gap-1">
                    <Clock className="h-3 w-3" />
                    {formatTime(entry.time_taken_seconds)}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
