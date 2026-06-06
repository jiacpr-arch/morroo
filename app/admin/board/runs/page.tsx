"use client";

import { Fragment, useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { requeueBoardGenJob } from "@/lib/supabase/mutations-board-gen";
import {
  ChevronLeft, Shield, Loader2, History, RefreshCw, ChevronDown,
  ChevronUp,
} from "lucide-react";

interface BoardGenJob {
  id: string;
  trigger: string;
  specialty_slug: string;
  target_count: number;
  status: string;
  generated_count: number | null;
  drafted_count: number | null;
  error: string | null;
  attempts: number;
  created_at: string;
  started_at: string | null;
  completed_at: string | null;
}

interface SpecialtyRef {
  slug: string;
  name_th: string;
}

const PAGE_SIZE = 20;

const STATUS_COLOR: Record<string, string> = {
  queued: "bg-blue-100 text-blue-700",
  running: "bg-amber-100 text-amber-700",
  done: "bg-emerald-100 text-emerald-700",
  error: "bg-rose-100 text-rose-700",
  skipped: "bg-gray-100 text-gray-600",
};

const TRIGGER_COLOR: Record<string, string> = {
  daily: "bg-purple-100 text-purple-700",
  subscription: "bg-blue-100 text-blue-700",
  admin: "bg-amber-100 text-amber-700",
};

function relativeTime(iso: string): string {
  const d = new Date(iso);
  const diffMs = Date.now() - d.getTime();
  const sec = Math.floor(diffMs / 1000);
  if (sec < 60) return `${sec}s ago`;
  const min = Math.floor(sec / 60);
  if (min < 60) return `${min}m ago`;
  const hr = Math.floor(min / 60);
  if (hr < 24) return `${hr}h ago`;
  const day = Math.floor(hr / 24);
  if (day < 30) return `${day}d ago`;
  return d.toLocaleDateString();
}

function duration(start: string | null, end: string | null): string {
  if (!start || !end) return "—";
  const ms = new Date(end).getTime() - new Date(start).getTime();
  if (ms < 0) return "—";
  if (ms < 1000) return `${ms}ms`;
  const sec = Math.floor(ms / 1000);
  if (sec < 60) return `${sec}s`;
  return `${Math.floor(sec / 60)}m ${sec % 60}s`;
}

export default function BoardRunsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [specialties, setSpecialties] = useState<SpecialtyRef[]>([]);
  const [rows, setRows] = useState<BoardGenJob[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(0);
  const [trigger, setTrigger] = useState("");
  const [status, setStatus] = useState("");
  const [specialty, setSpecialty] = useState("");
  const [fetching, setFetching] = useState(false);
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [requeuing, setRequeuing] = useState<string | null>(null);

  const load = useCallback(
    async (pageNum: number, t: string, s: string, sp: string) => {
      const supabase = createClient();
      setFetching(true);
      let q = supabase
        .from("board_gen_jobs")
        .select("*", { count: "exact" })
        .order("created_at", { ascending: false })
        .range(pageNum * PAGE_SIZE, pageNum * PAGE_SIZE + PAGE_SIZE - 1);
      if (t) q = q.eq("trigger", t);
      if (s) q = q.eq("status", s);
      if (sp) q = q.eq("specialty_slug", sp);
      const { data, count, error } = await q;
      if (error) {
        console.error("Failed to load runs:", error);
        setRows([]);
        setTotal(0);
      } else {
        setRows((data ?? []) as BoardGenJob[]);
        setTotal(count ?? 0);
      }
      setFetching(false);
    },
    []
  );

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      const { data: specs } = await supabase
        .from("board_specialties")
        .select("slug, name_th")
        .eq("is_active", true)
        .order("slug");
      setSpecialties((specs ?? []) as SpecialtyRef[]);

      await load(0, "", "", "");
      setLoading(false);
    }
    init();
  }, [router, load]);

  function applyFilters(t: string, s: string, sp: string) {
    setTrigger(t);
    setStatus(s);
    setSpecialty(sp);
    setPage(0);
    load(0, t, s, sp);
  }

  function toggleExpand(id: string) {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  async function retry(row: BoardGenJob) {
    if (!confirm(`Re-queue ${row.specialty_slug}?`)) return;
    setRequeuing(row.id);
    const result = await requeueBoardGenJob(row.id);
    setRequeuing(null);
    if (!result) {
      alert("Re-queue ไม่สำเร็จ");
      return;
    }
    load(page, trigger, status, specialty);
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
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      </div>
    );
  }

  const lastPage = Math.max(0, Math.ceil(total / PAGE_SIZE) - 1);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/board">
          <Button variant="ghost" size="sm">
            <ChevronLeft className="h-4 w-4 mr-1" /> Board dashboard
          </Button>
        </Link>
      </div>

      <div className="flex items-center justify-between mb-6 flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <History className="h-6 w-6 text-blue-700" />
            Run history
          </h1>
          <p className="text-muted-foreground mt-1 text-sm">
            ประวัติการ generate board MCQ (daily cron + on-demand queue)
          </p>
        </div>
        <Badge variant="secondary">{total} รายการ</Badge>
      </div>

      {/* Filter bar */}
      <div className="flex flex-wrap items-end gap-3 mb-4 rounded-lg border bg-muted/30 p-3">
        <div>
          <label className="block text-xs text-muted-foreground mb-1">Trigger</label>
          <select
            value={trigger}
            onChange={(e) => applyFilters(e.target.value, status, specialty)}
            className="h-8 rounded-md border border-input bg-background px-2 text-sm"
          >
            <option value="">All</option>
            <option value="daily">daily</option>
            <option value="subscription">subscription</option>
            <option value="admin">admin</option>
          </select>
        </div>
        <div>
          <label className="block text-xs text-muted-foreground mb-1">Status</label>
          <select
            value={status}
            onChange={(e) => applyFilters(trigger, e.target.value, specialty)}
            className="h-8 rounded-md border border-input bg-background px-2 text-sm"
          >
            <option value="">All</option>
            <option value="queued">queued</option>
            <option value="running">running</option>
            <option value="done">done</option>
            <option value="error">error</option>
            <option value="skipped">skipped</option>
          </select>
        </div>
        <div>
          <label className="block text-xs text-muted-foreground mb-1">Specialty</label>
          <select
            value={specialty}
            onChange={(e) => applyFilters(trigger, status, e.target.value)}
            className="h-8 rounded-md border border-input bg-background px-2 text-sm"
          >
            <option value="">All</option>
            {specialties.map((s) => (
              <option key={s.slug} value={s.slug}>{s.slug}</option>
            ))}
          </select>
        </div>
        {(trigger || status || specialty) && (
          <Button variant="ghost" size="sm" onClick={() => applyFilters("", "", "")}>
            Clear
          </Button>
        )}
        {fetching && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
      </div>

      {/* Table */}
      <div className="rounded-lg border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-2.5 w-8"></th>
                <th className="text-left p-2.5">When</th>
                <th className="text-left p-2.5">Trigger</th>
                <th className="text-left p-2.5">Specialty</th>
                <th className="text-left p-2.5">Status</th>
                <th className="text-right p-2.5 hidden sm:table-cell">Counts</th>
                <th className="text-right p-2.5 hidden md:table-cell">Attempts</th>
                <th className="text-right p-2.5 hidden md:table-cell">Duration</th>
                <th className="text-right p-2.5">Action</th>
              </tr>
            </thead>
            <tbody>
              {rows.length === 0 ? (
                <tr>
                  <td colSpan={9} className="p-8 text-center text-muted-foreground">
                    ไม่มีข้อมูล
                  </td>
                </tr>
              ) : (
                rows.map((r) => {
                  const canRetry =
                    r.status === "error" &&
                    (r.trigger === "subscription" || r.trigger === "admin");
                  const isExpanded = expanded.has(r.id);
                  return (
                    <Fragment key={r.id}>
                      <tr className="border-t hover:bg-muted/30">
                        <td className="p-2.5">
                          {r.error && (
                            <button
                              type="button"
                              onClick={() => toggleExpand(r.id)}
                              className="p-0.5 rounded hover:bg-muted"
                              aria-label="Toggle error details"
                            >
                              {isExpanded ? (
                                <ChevronUp className="h-3.5 w-3.5" />
                              ) : (
                                <ChevronDown className="h-3.5 w-3.5" />
                              )}
                            </button>
                          )}
                        </td>
                        <td className="p-2.5 text-xs text-muted-foreground">
                          {relativeTime(r.created_at)}
                        </td>
                        <td className="p-2.5">
                          <Badge className={TRIGGER_COLOR[r.trigger] ?? "bg-gray-100 text-gray-600"}>
                            {r.trigger}
                          </Badge>
                        </td>
                        <td className="p-2.5 font-mono text-xs">
                          {r.specialty_slug}
                        </td>
                        <td className="p-2.5">
                          <Badge className={STATUS_COLOR[r.status] ?? "bg-gray-100 text-gray-600"}>
                            {r.status}
                          </Badge>
                        </td>
                        <td className="p-2.5 text-right hidden sm:table-cell font-mono text-xs">
                          {r.generated_count ?? 0} / {r.drafted_count ?? 0}
                          <span className="text-muted-foreground"> /{r.target_count}</span>
                        </td>
                        <td className="p-2.5 text-right hidden md:table-cell font-mono text-xs">
                          {r.attempts}
                        </td>
                        <td className="p-2.5 text-right hidden md:table-cell text-xs text-muted-foreground">
                          {duration(r.started_at, r.completed_at)}
                        </td>
                        <td className="p-2.5 text-right">
                          {canRetry && (
                            <Button
                              size="sm"
                              variant="outline"
                              disabled={requeuing === r.id}
                              onClick={() => retry(r)}
                            >
                              {requeuing === r.id ? (
                                <Loader2 className="h-3 w-3 animate-spin" />
                              ) : (
                                <RefreshCw className="h-3 w-3" />
                              )}
                            </Button>
                          )}
                        </td>
                      </tr>
                      {isExpanded && r.error && (
                        <tr className="border-t bg-rose-50/40">
                          <td colSpan={9} className="p-3 text-xs font-mono text-rose-900 whitespace-pre-wrap break-words">
                            {r.error}
                          </td>
                        </tr>
                      )}
                    </Fragment>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pagination */}
      {total > PAGE_SIZE && (
        <div className="flex items-center justify-between mt-4">
          <div className="text-xs text-muted-foreground">
            Page {page + 1} / {lastPage + 1} · {total} total
          </div>
          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              disabled={page === 0 || fetching}
              onClick={() => {
                const next = page - 1;
                setPage(next);
                load(next, trigger, status, specialty);
              }}
            >
              Prev
            </Button>
            <Button
              variant="outline"
              size="sm"
              disabled={page >= lastPage || fetching}
              onClick={() => {
                const next = page + 1;
                setPage(next);
                load(next, trigger, status, specialty);
              }}
            >
              Next
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
