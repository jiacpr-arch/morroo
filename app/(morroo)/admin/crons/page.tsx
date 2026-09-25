"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { formatInterval } from "@/lib/cron-jobs";
import type { CronJobHealth } from "@/lib/cron-runs";
import { ChevronLeft, Shield, Loader2, RefreshCw, Timer } from "lucide-react";

const STATUS_LABEL: Record<string, { label: string; className: string }> = {
  ok: { label: "สำเร็จ", className: "bg-emerald-100 text-emerald-700" },
  error: { label: "ล้มเหลว", className: "bg-rose-100 text-rose-700" },
  timeout: { label: "หมดเวลา", className: "bg-rose-100 text-rose-700" },
  running: { label: "กำลังรัน", className: "bg-amber-100 text-amber-700" },
};

function relativeTime(iso: string): string {
  const sec = Math.floor((Date.now() - new Date(iso).getTime()) / 1000);
  if (sec < 60) return `${sec} วิ.ที่แล้ว`;
  const min = Math.floor(sec / 60);
  if (min < 60) return `${min} นาทีที่แล้ว`;
  const hr = Math.floor(min / 60);
  if (hr < 24) return `${hr} ชม.ที่แล้ว`;
  return `${Math.floor(hr / 24)} วันที่แล้ว`;
}

function formatDuration(ms: number | null): string {
  if (ms == null) return "—";
  if (ms < 1000) return `${ms}ms`;
  const sec = ms / 1000;
  if (sec < 60) return `${sec.toFixed(1)}s`;
  return `${Math.floor(sec / 60)}m ${Math.round(sec % 60)}s`;
}

function formatBangkok(iso: string): string {
  return new Date(iso).toLocaleString("th-TH", {
    timeZone: "Asia/Bangkok",
    day: "numeric",
    month: "short",
    hour: "2-digit",
    minute: "2-digit",
  });
}

export default function AdminCronsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [jobs, setJobs] = useState<CronJobHealth[]>([]);
  const [fetching, setFetching] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setFetching(true);
    setError(null);
    try {
      const res = await fetch("/api/admin/crons", { cache: "no-store" });
      const body = (await res.json()) as { ok: boolean; jobs?: CronJobHealth[]; error?: string };
      if (!res.ok || !body.ok) throw new Error(body.error ?? `HTTP ${res.status}`);
      setJobs(body.jobs ?? []);
    } catch (err) {
      setError(err instanceof Error ? err.message : String(err));
    } finally {
      setFetching(false);
    }
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);
      await load();
      setLoading(false);
    }
    init();
  }, [router, load]);

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
        <p className="text-muted-foreground mt-2">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  const failing = jobs.filter((j) => j.failures24h > 0).length;
  const stale = jobs.filter((j) => j.stale).length;
  const neverRun = jobs.filter((j) => !j.lastRun).length;

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-6 flex items-center justify-between gap-2">
        <Link href="/admin">
          <Button variant="ghost" size="sm"><ChevronLeft className="h-4 w-4 mr-1" />Admin</Button>
        </Link>
        <Button variant="outline" size="sm" onClick={load} disabled={fetching}>
          <RefreshCw className={`h-4 w-4 mr-1 ${fetching ? "animate-spin" : ""}`} />
          รีเฟรช
        </Button>
      </div>

      <div className="mb-6">
        <h1 className="text-2xl font-bold flex items-center gap-2">
          <Timer className="h-6 w-6 text-brand" />
          สถานะ Cron
        </h1>
        <p className="text-muted-foreground mt-1">
          ผลการรันล่าสุดของ cron ทุกงานใน vercel.json — ล้มเหลวใน 24 ชม. และงานที่ไม่ได้รันตามรอบ
        </p>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-6">
        <Card><CardContent className="pt-6">
          <p className="text-2xl font-bold">{jobs.length}</p>
          <p className="text-sm text-muted-foreground">งานทั้งหมด</p>
        </CardContent></Card>
        <Card className={failing > 0 ? "border-rose-300" : ""}><CardContent className="pt-6">
          <p className="text-2xl font-bold text-rose-600">{failing}</p>
          <p className="text-sm text-muted-foreground">ล้มเหลวใน 24 ชม.</p>
        </CardContent></Card>
        <Card className={stale > 0 ? "border-amber-300" : ""}><CardContent className="pt-6">
          <p className="text-2xl font-bold text-amber-600">{stale}</p>
          <p className="text-sm text-muted-foreground">ไม่ได้รันตามรอบ</p>
        </CardContent></Card>
        <Card><CardContent className="pt-6">
          <p className="text-2xl font-bold text-muted-foreground">{neverRun}</p>
          <p className="text-sm text-muted-foreground">ยังไม่มีข้อมูล</p>
        </CardContent></Card>
      </div>

      {error && (
        <p className="mb-4 rounded-md bg-rose-50 p-3 text-sm text-rose-700">โหลดข้อมูลไม่สำเร็จ: {error}</p>
      )}

      <div className="overflow-x-auto rounded-lg border">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left">
            <tr>
              <th className="px-3 py-2 font-medium">งาน</th>
              <th className="px-3 py-2 font-medium">รอบ</th>
              <th className="px-3 py-2 font-medium">รันล่าสุด</th>
              <th className="px-3 py-2 font-medium">สถานะ</th>
              <th className="px-3 py-2 font-medium">ใช้เวลา</th>
              <th className="px-3 py-2 font-medium">ล้มเหลว 24 ชม.</th>
            </tr>
          </thead>
          <tbody>
            {jobs.map((j) => {
              const status = j.lastStatus ? STATUS_LABEL[j.lastStatus] : null;
              return (
                <tr key={j.job} className="border-t align-top">
                  <td className="px-3 py-2">
                    <div className="font-medium">{j.job}</div>
                    <div className="text-xs text-muted-foreground">{j.path}</div>
                    {j.lastError && j.failures24h > 0 && (
                      <div className="mt-1 max-w-md text-xs text-rose-600 break-words">{j.lastError}</div>
                    )}
                  </td>
                  <td className="px-3 py-2 whitespace-nowrap">
                    <code className="text-xs">{j.schedule}</code>
                    <div className="text-xs text-muted-foreground">
                      เตือนถ้าเกิน {formatInterval(j.staleAfterMinutes)}
                    </div>
                  </td>
                  <td className="px-3 py-2 whitespace-nowrap">
                    {j.lastRun ? (
                      <>
                        <div>{relativeTime(j.lastRun.started_at)}</div>
                        <div className="text-xs text-muted-foreground">{formatBangkok(j.lastRun.started_at)}</div>
                      </>
                    ) : (
                      <span className="text-muted-foreground">ยังไม่เคยรัน</span>
                    )}
                    {j.stale && (
                      <Badge className="mt-1 bg-amber-100 text-amber-700">ไม่ได้รันตามรอบ</Badge>
                    )}
                  </td>
                  <td className="px-3 py-2 whitespace-nowrap">
                    {status ? <Badge className={status.className}>{status.label}</Badge> : "—"}
                    {j.lastRun?.http_status != null && (
                      <div className="text-xs text-muted-foreground">HTTP {j.lastRun.http_status}</div>
                    )}
                  </td>
                  <td className="px-3 py-2 whitespace-nowrap">{formatDuration(j.lastRun?.duration_ms ?? null)}</td>
                  <td className="px-3 py-2">
                    <span className={j.failures24h > 0 ? "font-bold text-rose-600" : "text-muted-foreground"}>
                      {j.failures24h}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
