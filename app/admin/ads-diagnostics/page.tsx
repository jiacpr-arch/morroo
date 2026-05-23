"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  Loader2,
  RefreshCw,
  PauseCircle,
  AlertTriangle,
  AlertCircle,
  CheckCircle2,
} from "lucide-react";

type Finding = {
  id: number;
  run_id: number | null;
  severity: "info" | "warn" | "critical";
  category: string;
  entity_type: "page" | "ad" | "adset" | "campaign";
  entity_id: string;
  entity_label: string | null;
  metric_snapshot: Record<string, unknown>;
  recommendation: string;
  auto_action_taken: string | null;
  resolved: boolean;
  created_at: string;
};

type Run = {
  id: number;
  started_at: string;
  finished_at: string | null;
  ok: boolean;
  pages_scanned: number;
  ads_scanned: number;
  findings_count: number;
  actions_count: number;
  error: string | null;
};

const SEVERITY_RANK: Record<Finding["severity"], number> = {
  critical: 0,
  warn: 1,
  info: 2,
};

function timeAgo(iso: string): string {
  const diff = Date.now() - new Date(iso).getTime();
  const mins = Math.round(diff / 60000);
  if (mins < 60) return `${mins}m`;
  const hrs = Math.round(mins / 60);
  if (hrs < 24) return `${hrs}h`;
  const days = Math.round(hrs / 24);
  return `${days}d`;
}

export default function AdsDiagnosticsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [findings, setFindings] = useState<Finding[]>([]);
  const [runs, setRuns] = useState<Run[]>([]);
  const [showResolved, setShowResolved] = useState(false);
  const [actingId, setActingId] = useState<number | null>(null);

  const load = useCallback(async () => {
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
    if (profile?.role !== "admin") {
      setLoading(false);
      return;
    }
    setIsAdmin(true);

    const [findingsRes, runsRes] = await Promise.all([
      supabase
        .from("ad_diagnostics_findings")
        .select(
          "id,run_id,severity,category,entity_type,entity_id,entity_label,metric_snapshot,recommendation,auto_action_taken,resolved,created_at"
        )
        .order("created_at", { ascending: false })
        .limit(200),
      supabase
        .from("ad_diagnostics_runs")
        .select(
          "id,started_at,finished_at,ok,pages_scanned,ads_scanned,findings_count,actions_count,error"
        )
        .order("started_at", { ascending: false })
        .limit(10),
    ]);

    setFindings((findingsRes.data as Finding[] | null) ?? []);
    setRuns((runsRes.data as Run[] | null) ?? []);
    setLoading(false);
  }, [router]);

  useEffect(() => {
    load();
  }, [load]);

  async function resolveFinding(id: number) {
    setActingId(id);
    const res = await fetch("/api/admin/ads-diagnostics/resolve", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id }),
    });
    if (res.ok) {
      setFindings((curr) =>
        curr.map((f) => (f.id === id ? { ...f, resolved: true } : f))
      );
    }
    setActingId(null);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }
  if (!isAdmin) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-12 text-center">
        <p className="text-muted-foreground">ไม่มีสิทธิ์เข้าถึงหน้านี้</p>
      </div>
    );
  }

  const visible = findings
    .filter((f) => (showResolved ? true : !f.resolved))
    .sort(
      (a, b) =>
        SEVERITY_RANK[a.severity] - SEVERITY_RANK[b.severity] ||
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    );

  const openCounts = findings.reduce(
    (acc, f) => {
      if (f.resolved) return acc;
      acc[f.severity] = (acc[f.severity] ?? 0) + 1;
      return acc;
    },
    { critical: 0, warn: 0, info: 0 } as Record<Finding["severity"], number>
  );

  const lastRun = runs[0];

  return (
    <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div>
          <Link
            href="/admin"
            className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground mb-2"
          >
            <ArrowLeft className="h-4 w-4 mr-1" /> กลับ Admin
          </Link>
          <h1 className="text-2xl font-bold">Ads Autofix</h1>
          <p className="text-sm text-muted-foreground">
            ตรวจ landing pages + Meta ads ทุกวัน · auto-pause underperformers
          </p>
        </div>
        <button
          onClick={() => load()}
          className="inline-flex items-center gap-2 rounded-md border px-3 py-1.5 text-sm hover:bg-muted"
        >
          <RefreshCw className="h-4 w-4" /> Refresh
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Stat
          icon={<AlertCircle className="text-red-600" />}
          label="Critical (open)"
          value={openCounts.critical}
        />
        <Stat
          icon={<AlertTriangle className="text-amber-500" />}
          label="Warn (open)"
          value={openCounts.warn}
        />
        <Stat
          icon={<PauseCircle className="text-purple-600" />}
          label="Auto-paused (24h)"
          value={
            findings.filter(
              (f) =>
                f.auto_action_taken &&
                Date.now() - new Date(f.created_at).getTime() < 86400000
            ).length
          }
        />
        <Stat
          icon={<CheckCircle2 className="text-emerald-600" />}
          label="Last run"
          value={lastRun ? timeAgo(lastRun.started_at) : "—"}
        />
      </div>

      {lastRun?.error && (
        <Card className="border-red-300">
          <CardContent className="py-3 text-sm text-red-700">
            <span className="font-semibold">Last run error:</span> {lastRun.error}
          </CardContent>
        </Card>
      )}

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-base">Findings</CardTitle>
          <label className="flex items-center gap-2 text-xs text-muted-foreground">
            <input
              type="checkbox"
              checked={showResolved}
              onChange={(e) => setShowResolved(e.target.checked)}
            />
            แสดงที่ resolved แล้ว
          </label>
        </CardHeader>
        <CardContent className="space-y-3">
          {visible.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              ยังไม่มี finding ที่ค้างอยู่ — โฆษณาดูสะอาด ✨
            </p>
          ) : (
            visible.map((f) => <FindingCard key={f.id} f={f} onResolve={resolveFinding} acting={actingId === f.id} />)
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-base">Recent runs</CardTitle>
        </CardHeader>
        <CardContent>
          {runs.length === 0 ? (
            <p className="text-sm text-muted-foreground">ยังไม่มี run</p>
          ) : (
            <ul className="space-y-2 text-sm">
              {runs.map((r) => (
                <li
                  key={r.id}
                  className="flex items-center justify-between border-b py-2 last:border-b-0"
                >
                  <span>
                    <span className="font-mono text-xs text-muted-foreground">
                      #{r.id}
                    </span>{" "}
                    {new Date(r.started_at).toLocaleString("th-TH")}
                  </span>
                  <span className="flex items-center gap-3 text-xs">
                    <span>{r.pages_scanned}p</span>
                    <span>{r.ads_scanned}a</span>
                    <span className="font-semibold">{r.findings_count} findings</span>
                    <span className="text-purple-600">{r.actions_count} actions</span>
                    {r.ok ? (
                      <Badge variant="secondary">ok</Badge>
                    ) : (
                      <Badge variant="destructive">error</Badge>
                    )}
                  </span>
                </li>
              ))}
            </ul>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

function Stat({
  icon,
  label,
  value,
}: {
  icon: React.ReactNode;
  label: string;
  value: number | string;
}) {
  return (
    <Card>
      <CardContent className="py-4 flex items-center gap-3">
        <div className="h-8 w-8 flex items-center justify-center [&>svg]:h-5 [&>svg]:w-5">
          {icon}
        </div>
        <div>
          <p className="text-xs text-muted-foreground">{label}</p>
          <p className="text-xl font-bold">{value}</p>
        </div>
      </CardContent>
    </Card>
  );
}

function FindingCard({
  f,
  onResolve,
  acting,
}: {
  f: Finding;
  onResolve: (id: number) => void;
  acting: boolean;
}) {
  const severityClass =
    f.severity === "critical"
      ? "border-red-300 bg-red-50/50"
      : f.severity === "warn"
        ? "border-amber-300 bg-amber-50/40"
        : "border-slate-200";

  return (
    <div className={`rounded-lg border ${severityClass} p-3`}>
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2 mb-1">
            <Badge
              variant={
                f.severity === "critical"
                  ? "destructive"
                  : f.severity === "warn"
                    ? "secondary"
                    : "outline"
              }
              className="uppercase text-[10px]"
            >
              {f.severity}
            </Badge>
            <span className="text-xs font-mono text-muted-foreground">
              {f.category}
            </span>
            {f.auto_action_taken && (
              <Badge variant="secondary" className="text-[10px] gap-1">
                <PauseCircle className="h-3 w-3" /> {f.auto_action_taken}
              </Badge>
            )}
            {f.resolved && (
              <Badge variant="outline" className="text-[10px]">resolved</Badge>
            )}
          </div>
          <p className="font-medium text-sm break-words">
            {f.entity_label ?? f.entity_id}{" "}
            <span className="text-xs text-muted-foreground">
              ({f.entity_type})
            </span>
          </p>
          <p className="text-sm text-muted-foreground mt-1">
            {f.recommendation}
          </p>
          <details className="mt-2">
            <summary className="text-xs text-muted-foreground cursor-pointer">
              metrics
            </summary>
            <pre className="mt-1 text-[11px] bg-muted/60 rounded p-2 overflow-x-auto">
              {JSON.stringify(f.metric_snapshot, null, 2)}
            </pre>
          </details>
        </div>
        {!f.resolved && (
          <button
            onClick={() => onResolve(f.id)}
            disabled={acting}
            className="shrink-0 inline-flex items-center gap-1 rounded-md border px-2.5 py-1 text-xs hover:bg-muted disabled:opacity-50"
          >
            {acting ? (
              <Loader2 className="h-3 w-3 animate-spin" />
            ) : (
              <CheckCircle2 className="h-3 w-3" />
            )}
            Resolve
          </button>
        )}
      </div>
    </div>
  );
}
