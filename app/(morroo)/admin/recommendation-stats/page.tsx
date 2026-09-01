"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Loader2, Shield, ArrowLeft, Sparkles, TrendingUp, TrendingDown, Minus } from "lucide-react";

interface Bucket {
  bucket: "recommended" | "regular";
  total_attempts: number;
  correct_count: number;
  accuracy: number | null;
  unique_users: number;
}

const PRESETS = [7, 30, 90] as const;

export default function RecommendationStatsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [days, setDays] = useState<(typeof PRESETS)[number]>(30);
  const [buckets, setBuckets] = useState<Bucket[]>([]);
  const [fetching, setFetching] = useState(false);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      const admin = (profile as { role?: string } | null)?.role === "admin";
      setIsAdmin(admin);
      setLoading(false);
    }
    init();
  }, [router]);

  useEffect(() => {
    if (!isAdmin) return;
    let cancelled = false;
    async function fetchStats() {
      setFetching(true);
      const res = await fetch(`/api/admin/recommendation-stats?days=${days}`).then((r) => r.json());
      if (cancelled) return;
      setBuckets((res.buckets as Bucket[]) ?? []);
      setFetching(false);
    }
    fetchStats();
    return () => {
      cancelled = true;
    };
  }, [isAdmin, days]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  const recommended = buckets.find((b) => b.bucket === "recommended");
  const regular = buckets.find((b) => b.bucket === "regular");
  const diff =
    recommended?.accuracy != null && regular?.accuracy != null
      ? Math.round((recommended.accuracy - regular.accuracy) * 10) / 10
      : null;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6">
        <Link
          href="/admin"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-4"
        >
          <ArrowLeft className="h-4 w-4" /> กลับหน้า Admin
        </Link>
        <h1 className="text-2xl font-bold flex items-center gap-2">
          <Sparkles className="h-6 w-6 text-brand" />
          Recommendation Effectiveness
        </h1>
        <p className="text-muted-foreground text-sm mt-1">
          เปรียบเทียบ accuracy ระหว่างข้อสอบแบบแนะนำกับแบบเลือกเอง
        </p>
      </div>

      <div className="mb-6 flex items-center gap-2">
        <span className="text-sm text-muted-foreground">ช่วงเวลา:</span>
        {PRESETS.map((d) => (
          <button
            key={d}
            onClick={() => setDays(d)}
            className={`text-sm px-3 py-1.5 rounded-lg ${
              days === d ? "bg-brand text-white" : "bg-muted text-muted-foreground hover:bg-muted/80"
            }`}
          >
            {d} วัน
          </button>
        ))}
        {fetching && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground ml-2" />}
      </div>

      {/* Headline delta */}
      {diff != null && (
        <Card className="mb-6 border-brand/40">
          <CardContent className="py-5 px-5">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">
                  Δ Accuracy (แนะนำ − ปกติ)
                </p>
                <p
                  className={`text-4xl font-bold ${
                    diff > 0.5 ? "text-green-600" : diff < -0.5 ? "text-red-600" : "text-gray-600"
                  }`}
                >
                  {diff > 0 ? "+" : ""}
                  {diff}%
                </p>
              </div>
              <div className="text-right">
                {diff > 0.5 ? (
                  <div className="flex items-center gap-1 text-green-600">
                    <TrendingUp className="h-5 w-5" />
                    <span className="text-sm font-medium">ระบบช่วยได้จริง</span>
                  </div>
                ) : diff < -0.5 ? (
                  <div className="flex items-center gap-1 text-red-600">
                    <TrendingDown className="h-5 w-5" />
                    <span className="text-sm font-medium">ต้องจูน threshold</span>
                  </div>
                ) : (
                  <div className="flex items-center gap-1 text-gray-600">
                    <Minus className="h-5 w-5" />
                    <span className="text-sm font-medium">ผลพอๆ กัน</span>
                  </div>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Buckets */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {[recommended, regular].map((b, i) => {
          const label = i === 0 ? "แนะนำ (recommended)" : "ปกติ (regular)";
          const color = i === 0 ? "text-brand" : "text-gray-700";
          return (
            <Card key={label}>
              <CardHeader className="pb-2">
                <CardTitle className="text-sm text-muted-foreground font-normal">
                  {label}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {b ? (
                  <>
                    <p className={`text-3xl font-bold mb-1 ${color}`}>{b.accuracy ?? 0}%</p>
                    <p className="text-xs text-muted-foreground">
                      {b.correct_count.toLocaleString()} / {b.total_attempts.toLocaleString()} ข้อ
                    </p>
                    <div className="mt-3 pt-3 border-t">
                      <Badge variant="secondary" className="text-xs">
                        {b.unique_users} ผู้ใช้
                      </Badge>
                    </div>
                  </>
                ) : (
                  <p className="text-sm text-muted-foreground">ยังไม่มีข้อมูล</p>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>

      {!recommended && !regular && !fetching && (
        <Card className="mt-6">
          <CardContent className="py-8 text-center text-muted-foreground">
            ยังไม่มี attempt ในช่วง {days} วันล่าสุด
          </CardContent>
        </Card>
      )}
    </div>
  );
}
