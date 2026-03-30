"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { Swords, Clock, Trophy, ArrowRight, Loader2 } from "lucide-react";
import type { Challenge } from "@/lib/types-standard";

export default function ChallengesPage() {
  const [loading, setLoading] = useState(true);
  const [challenges, setChallenges] = useState<Challenge[]>([]);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data } = await supabase
        .from("challenges")
        .select("*")
        .eq("is_active", true)
        .order("start_date", { ascending: false });

      setChallenges((data as Challenge[]) || []);
      setLoading(false);
    }
    load();
  }, []);

  const now = new Date();

  const activeChallenges = challenges.filter(
    (c) => new Date(c.start_date) <= now && new Date(c.end_date) >= now
  );
  const upcomingChallenges = challenges.filter(
    (c) => new Date(c.start_date) > now
  );
  const pastChallenges = challenges.filter(
    (c) => new Date(c.end_date) < now
  );

  const formatDateRange = (start: string, end: string) => {
    const s = new Date(start).toLocaleDateString("th-TH", { day: "numeric", month: "short" });
    const e = new Date(end).toLocaleDateString("th-TH", { day: "numeric", month: "short", year: "numeric" });
    return `${s} - ${e}`;
  };

  const getTimeRemaining = (end: string) => {
    const diff = new Date(end).getTime() - now.getTime();
    if (diff <= 0) return "หมดเวลาแล้ว";
    const days = Math.floor(diff / 86400000);
    const hours = Math.floor((diff % 86400000) / 3600000);
    if (days > 0) return `เหลือ ${days} วัน ${hours} ชม.`;
    return `เหลือ ${hours} ชม.`;
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="text-center mb-10">
        <div className="mx-auto w-16 h-16 rounded-full bg-purple-100 flex items-center justify-center mb-4">
          <Swords className="h-8 w-8 text-purple-600" />
        </div>
        <h1 className="text-3xl font-bold">Challenge</h1>
        <p className="text-muted-foreground mt-2">
          แข่งขันทำข้อสอบ ลุ้นอันดับ Leaderboard และรางวัล
        </p>
      </div>

      {/* Active Challenges */}
      {activeChallenges.length > 0 && (
        <div className="mb-10">
          <h2 className="text-lg font-bold mb-4 flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-green-500" />
            กำลังแข่งขัน
          </h2>
          <div className="space-y-4">
            {activeChallenges.map((c) => (
              <Card key={c.id} className="border-green-200 bg-green-50/50">
                <CardContent className="py-5">
                  <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <Badge className={c.challenge_type === "weekly"
                          ? "bg-blue-100 text-blue-700"
                          : "bg-purple-100 text-purple-700"
                        }>
                          {c.challenge_type === "weekly" ? "Weekly" : "Monthly"}
                        </Badge>
                        <Badge className="bg-green-100 text-green-700">LIVE</Badge>
                      </div>
                      <h3 className="text-lg font-bold">{c.title}</h3>
                      {c.description && (
                        <p className="text-sm text-muted-foreground mt-1">{c.description}</p>
                      )}
                      <div className="flex items-center gap-4 mt-2 text-sm text-muted-foreground">
                        <span className="flex items-center gap-1">
                          <Clock className="h-3.5 w-3.5" />
                          {getTimeRemaining(c.end_date)}
                        </span>
                        <span>{c.question_ids.length} ข้อ</span>
                      </div>
                    </div>
                    <div className="flex gap-2">
                      <Link href="/leaderboard">
                        <Button variant="outline" size="sm" className="gap-1">
                          <Trophy className="h-4 w-4" /> Leaderboard
                        </Button>
                      </Link>
                      <Link href={`/challenges/${c.id}`}>
                        <Button size="sm" className="bg-brand hover:bg-brand-light text-white gap-1">
                          เข้าร่วม <ArrowRight className="h-4 w-4" />
                        </Button>
                      </Link>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* Upcoming */}
      {upcomingChallenges.length > 0 && (
        <div className="mb-10">
          <h2 className="text-lg font-bold mb-4 flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-yellow-500" />
            เร็วๆ นี้
          </h2>
          <div className="space-y-3">
            {upcomingChallenges.map((c) => (
              <Card key={c.id}>
                <CardContent className="py-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <Badge variant="secondary">
                          {c.challenge_type === "weekly" ? "Weekly" : "Monthly"}
                        </Badge>
                      </div>
                      <h3 className="font-semibold">{c.title}</h3>
                      <p className="text-sm text-muted-foreground mt-1">
                        {formatDateRange(c.start_date, c.end_date)} ({c.question_ids.length} ข้อ)
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      )}

      {/* Past */}
      {pastChallenges.length > 0 && (
        <div>
          <h2 className="text-lg font-bold mb-4 flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-gray-400" />
            ที่ผ่านมา
          </h2>
          <div className="space-y-3">
            {pastChallenges.map((c) => (
              <Card key={c.id} className="opacity-60">
                <CardContent className="py-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-semibold">{c.title}</h3>
                      <p className="text-sm text-muted-foreground mt-1">
                        {formatDateRange(c.start_date, c.end_date)}
                      </p>
                    </div>
                    <Link href="/leaderboard">
                      <Button variant="ghost" size="sm" className="gap-1">
                        <Trophy className="h-4 w-4" /> ดูผล
                      </Button>
                    </Link>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      )}

      {challenges.length === 0 && (
        <Card>
          <CardContent className="py-16 text-center">
            <Swords className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-semibold">ยังไม่มี Challenge</h3>
            <p className="text-sm text-muted-foreground mt-1">
              กลับมาเร็วๆ นี้เพื่อเข้าร่วมการแข่งขัน
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
