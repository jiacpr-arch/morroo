"use client";

import { useState, useEffect, useCallback, Fragment } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  Loader2,
  Shield,
  ArrowLeft,
  Filter,
  Mail,
  Phone,
  Search,
} from "lucide-react";

type Lead = {
  id: string;
  source: string;
  campaign: string | null;
  email: string | null;
  phone: string | null;
  name: string | null;
  status_year: string | null;
  exam_target: string | null;
  reward_choice: string | null;
  stage: string;
  created_at: string;
  user_id: string | null;
};

type Code = {
  code: string;
  reward_type: string;
  lead_id: string | null;
  redeemed_at: string | null;
  expires_at: string;
  created_at: string;
};

type MessageSent = {
  lead_id: string;
  day: number;
  channel: string;
  sent_at: string;
};

const STAGE_LABEL: Record<string, string> = {
  new: "ใหม่",
  contacted: "ติดต่อแล้ว",
  code_issued: "ออกโค้ดแล้ว",
  registered: "ลงทะเบียน",
  redeemed: "ใช้โค้ดแล้ว",
  paid: "ชำระเงิน",
  dropped: "หลุด",
};

const STAGE_COLOR: Record<string, string> = {
  new: "bg-gray-100 text-gray-700",
  contacted: "bg-blue-100 text-blue-700",
  code_issued: "bg-amber-100 text-amber-700",
  registered: "bg-purple-100 text-purple-700",
  redeemed: "bg-teal-100 text-teal-700",
  paid: "bg-emerald-100 text-emerald-700",
  dropped: "bg-red-100 text-red-700",
};

const SOURCE_LABEL: Record<string, string> = {
  fb_leadgen_form: "FB Lead Ads",
  fb_messenger: "Messenger",
  landing: "Landing Page",
  organic: "Organic",
  admin: "Admin",
};

export default function AdminLeadsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [leads, setLeads] = useState<Lead[]>([]);
  const [codesByLead, setCodesByLead] = useState<Record<string, Code[]>>({});
  const [messagesByLead, setMessagesByLead] = useState<
    Record<string, MessageSent[]>
  >({});
  const [stageFilter, setStageFilter] = useState<string>("all");
  const [sourceFilter, setSourceFilter] = useState<string>("all");
  const [dateRange, setDateRange] = useState<"7" | "30" | "90" | "all">("30");
  const [search, setSearch] = useState("");
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [toast, setToast] = useState<string>("");

  const loadData = useCallback(async () => {
    const supabase = createClient();
    let query = supabase
      .from("leads")
      .select(
        "id, source, campaign, email, phone, name, status_year, exam_target, reward_choice, stage, created_at, user_id"
      )
      .order("created_at", { ascending: false })
      .limit(500);

    if (dateRange !== "all") {
      const days = parseInt(dateRange, 10);
      const cutoff = new Date(
        Date.now() - days * 24 * 60 * 60 * 1000
      ).toISOString();
      query = query.gte("created_at", cutoff);
    }
    const { data: leadsData, error: leadsErr } = await query;

    if (leadsErr) {
      console.error("Failed to load leads:", leadsErr);
      return;
    }
    setLeads((leadsData ?? []) as Lead[]);

    if ((leadsData?.length ?? 0) > 0) {
      const ids = (leadsData as Lead[]).map((l) => l.id);
      const [codesRes, messagesRes] = await Promise.all([
        supabase
          .from("redeem_codes")
          .select("code, reward_type, lead_id, redeemed_at, expires_at, created_at")
          .in("lead_id", ids),
        supabase
          .from("lead_messages_sent")
          .select("lead_id, day, channel, sent_at")
          .in("lead_id", ids),
      ]);
      const codesGrouped: Record<string, Code[]> = {};
      for (const c of (codesRes.data ?? []) as Code[]) {
        if (!c.lead_id) continue;
        (codesGrouped[c.lead_id] ??= []).push(c);
      }
      const messagesGrouped: Record<string, MessageSent[]> = {};
      for (const m of (messagesRes.data ?? []) as MessageSent[]) {
        (messagesGrouped[m.lead_id] ??= []).push(m);
      }
      // Sort each lead's messages by sent_at desc for nicer display.
      for (const k of Object.keys(messagesGrouped)) {
        messagesGrouped[k].sort(
          (a, b) =>
            new Date(b.sent_at).getTime() - new Date(a.sent_at).getTime()
        );
      }
      setCodesByLead(codesGrouped);
      setMessagesByLead(messagesGrouped);
    }
  }, [dateRange]);

  async function issueNewCode(leadId: string) {
    setBusyId(leadId);
    setToast("");
    try {
      const res = await fetch(`/api/admin/leads/${leadId}/issue-code`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: "{}",
      });
      const json = (await res.json()) as { code?: string; error?: string };
      if (!res.ok) {
        setToast(`ออกโค้ดไม่สำเร็จ: ${json.error ?? "unknown"}`);
        return;
      }
      setToast(`ออกโค้ด ${json.code} + ส่งอีเมลแล้ว`);
      await loadData();
    } finally {
      setBusyId(null);
    }
  }

  async function changeStage(leadId: string, stage: string) {
    setBusyId(leadId);
    setToast("");
    try {
      const res = await fetch(`/api/admin/leads/${leadId}/stage`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ stage }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        setToast(`เปลี่ยน stage ไม่สำเร็จ: ${json.error ?? "unknown"}`);
        return;
      }
      setToast(`เปลี่ยน stage เป็น "${STAGE_LABEL[stage] ?? stage}"`);
      await loadData();
    } finally {
      setBusyId(null);
    }
  }

  // Reload when date range changes (after admin auth confirmed).
  useEffect(() => {
    if (isAdmin) loadData();
  }, [isAdmin, loadData]);

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
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      setLoading(false);
    }
    init();
  }, [router]);

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 mx-auto mb-4 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  // Stage funnel counts (derived from full lead list, not the filtered view).
  const funnel = {
    total: leads.length,
    new: leads.filter((l) => l.stage === "new").length,
    code_issued: leads.filter((l) => l.stage === "code_issued").length,
    redeemed: leads.filter((l) => l.stage === "redeemed").length,
    paid: leads.filter((l) => l.stage === "paid").length,
    dropped: leads.filter((l) => l.stage === "dropped").length,
  };
  const conversionRate =
    funnel.total > 0
      ? ((funnel.redeemed + funnel.paid) / funnel.total) * 100
      : 0;

  // Source funnel — last 30 days, useful for ROAS-by-channel.
  const cutoff = Date.now() - 30 * 24 * 60 * 60 * 1000;
  const recentLeads = leads.filter(
    (l) => new Date(l.created_at).getTime() >= cutoff
  );
  const sourceBreakdown: Record<string, number> = {};
  for (const l of recentLeads) {
    sourceBreakdown[l.source] = (sourceBreakdown[l.source] ?? 0) + 1;
  }

  const filtered = leads.filter((l) => {
    if (stageFilter !== "all" && l.stage !== stageFilter) return false;
    if (sourceFilter !== "all" && l.source !== sourceFilter) return false;
    if (search.trim()) {
      const q = search.toLowerCase();
      if (
        !(
          (l.email ?? "").toLowerCase().includes(q) ||
          (l.name ?? "").toLowerCase().includes(q) ||
          (l.phone ?? "").includes(q) ||
          (l.campaign ?? "").toLowerCase().includes(q)
        )
      ) {
        return false;
      }
    }
    return true;
  });

  return (
    <div className="container mx-auto max-w-7xl px-4 py-8">
      <Link
        href="/admin"
        className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground"
      >
        <ArrowLeft className="h-4 w-4" /> กลับ Admin
      </Link>
      <h1 className="mt-4 text-3xl font-bold">Lead Pipeline</h1>
      <p className="mt-1 text-muted-foreground">
        Total {funnel.total.toLocaleString()} leads · Conversion rate{" "}
        <span className="font-semibold text-teal-700">
          {conversionRate.toFixed(1)}%
        </span>
      </p>

      <section className="mt-6 grid gap-3 sm:grid-cols-3 lg:grid-cols-6">
        <FunnelCard label="ทั้งหมด" value={funnel.total} />
        <FunnelCard label="ออกโค้ด" value={funnel.code_issued} accent="amber" />
        <FunnelCard label="ใช้โค้ดแล้ว" value={funnel.redeemed} accent="teal" />
        <FunnelCard label="ชำระเงิน" value={funnel.paid} accent="emerald" />
        <FunnelCard label="หลุด" value={funnel.dropped} accent="red" />
        <FunnelCard label="30 วัน" value={recentLeads.length} accent="blue" />
      </section>

      {Object.keys(sourceBreakdown).length > 0 && (
        <section className="mt-4 flex flex-wrap gap-2 text-sm">
          <span className="text-muted-foreground">30 วันล่าสุดตาม source:</span>
          {Object.entries(sourceBreakdown)
            .sort((a, b) => b[1] - a[1])
            .map(([src, n]) => (
              <Badge key={src} variant="outline">
                {SOURCE_LABEL[src] ?? src}: {n}
              </Badge>
            ))}
        </section>
      )}

      <section className="mt-6 flex flex-wrap items-center gap-2">
        <div className="flex items-center gap-2">
          <Filter className="h-4 w-4 text-muted-foreground" />
          <select
            value={stageFilter}
            onChange={(e) => setStageFilter(e.target.value)}
            className="rounded-md border bg-background px-3 py-2 text-sm"
          >
            <option value="all">ทุก stage</option>
            {Object.entries(STAGE_LABEL).map(([k, v]) => (
              <option key={k} value={k}>
                {v}
              </option>
            ))}
          </select>
          <select
            value={sourceFilter}
            onChange={(e) => setSourceFilter(e.target.value)}
            className="rounded-md border bg-background px-3 py-2 text-sm"
          >
            <option value="all">ทุก source</option>
            {Object.entries(SOURCE_LABEL).map(([k, v]) => (
              <option key={k} value={k}>
                {v}
              </option>
            ))}
          </select>
          <select
            value={dateRange}
            onChange={(e) =>
              setDateRange(e.target.value as "7" | "30" | "90" | "all")
            }
            className="rounded-md border bg-background px-3 py-2 text-sm"
          >
            <option value="7">7 วัน</option>
            <option value="30">30 วัน</option>
            <option value="90">90 วัน</option>
            <option value="all">ทั้งหมด</option>
          </select>
        </div>
        <div className="relative ml-auto">
          <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="ค้นหา email / ชื่อ / phone / campaign"
            className="w-72 pl-9"
          />
        </div>
        <Button variant="outline" onClick={loadData}>
          Refresh
        </Button>
        <Button variant="outline" onClick={() => exportCsv(filtered, codesByLead)}>
          Export CSV
        </Button>
      </section>

      {toast && (
        <div className="mt-3 rounded-md border border-teal-200 bg-teal-50 px-3 py-2 text-sm text-teal-800">
          {toast}
        </div>
      )}

      <Card className="mt-4">
        <CardHeader>
          <CardTitle className="text-base">
            Leads ({filtered.length} / {leads.length})
          </CardTitle>
        </CardHeader>
        <CardContent className="overflow-x-auto p-0">
          <table className="w-full text-sm">
            <thead className="border-b bg-muted/40 text-left text-xs uppercase tracking-wider text-muted-foreground">
              <tr>
                <th className="px-4 py-3">Created</th>
                <th className="px-4 py-3">Contact</th>
                <th className="px-4 py-3">Source / Campaign</th>
                <th className="px-4 py-3">Stage</th>
                <th className="px-4 py-3">Reward</th>
                <th className="px-4 py-3">Code</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((l) => {
                const codes = codesByLead[l.id] ?? [];
                const activeCode =
                  codes.find((c) => !c.redeemed_at) ?? codes[0];
                const isExpanded = expandedId === l.id;
                return (
                  <Fragment key={l.id}>
                  <tr
                    className="cursor-pointer border-b hover:bg-muted/20"
                    onClick={() =>
                      setExpandedId((prev) => (prev === l.id ? null : l.id))
                    }
                  >
                    <td className="px-4 py-3 text-xs text-muted-foreground">
                      {new Date(l.created_at).toLocaleDateString("th-TH", {
                        year: "2-digit",
                        month: "short",
                        day: "numeric",
                      })}
                    </td>
                    <td className="px-4 py-3">
                      <div className="font-medium">{l.name ?? "—"}</div>
                      <div className="mt-0.5 flex flex-col gap-0.5 text-xs text-muted-foreground">
                        {l.email && (
                          <span className="inline-flex items-center gap-1">
                            <Mail className="h-3 w-3" />
                            {l.email}
                          </span>
                        )}
                        {l.phone && (
                          <span className="inline-flex items-center gap-1">
                            <Phone className="h-3 w-3" />
                            {l.phone}
                          </span>
                        )}
                      </div>
                    </td>
                    <td className="px-4 py-3 text-xs">
                      <div>{SOURCE_LABEL[l.source] ?? l.source}</div>
                      {l.campaign && (
                        <div className="text-muted-foreground">
                          {l.campaign}
                        </div>
                      )}
                    </td>
                    <td className="px-4 py-3">
                      <Badge
                        className={STAGE_COLOR[l.stage] ?? "bg-gray-100 text-gray-700"}
                      >
                        {STAGE_LABEL[l.stage] ?? l.stage}
                      </Badge>
                    </td>
                    <td className="px-4 py-3 text-xs">
                      {l.reward_choice === "monthly_1m"
                        ? "1 เดือน"
                        : l.reward_choice === "bundle_10q"
                          ? "Bundle 10"
                          : "—"}
                    </td>
                    <td className="px-4 py-3 font-mono text-xs">
                      {activeCode ? (
                        <div>
                          <div>{activeCode.code}</div>
                          <div className="text-muted-foreground">
                            {activeCode.redeemed_at
                              ? "✓ used"
                              : new Date(activeCode.expires_at) < new Date()
                                ? "expired"
                                : "active"}
                          </div>
                        </div>
                      ) : (
                        <span className="text-muted-foreground">—</span>
                      )}
                    </td>
                  </tr>
                  {isExpanded && (
                    <tr className="border-b bg-muted/10">
                      <td colSpan={6} className="px-4 py-4">
                        <div className="space-y-3">
                          <div>
                            <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                              Codes
                            </div>
                            <div className="mt-2 space-y-1 font-mono text-xs">
                              {codes.length === 0 && (
                                <div className="text-muted-foreground">
                                  ยังไม่มีโค้ดสำหรับ lead นี้
                                </div>
                              )}
                              {codes.map((c) => {
                                const expired =
                                  new Date(c.expires_at) < new Date();
                                const status = c.redeemed_at
                                  ? "✓ used"
                                  : expired
                                    ? "expired"
                                    : "active";
                                return (
                                  <div
                                    key={c.code}
                                    className="flex items-center gap-3"
                                  >
                                    <span>{c.code}</span>
                                    <Badge variant="outline" className="text-[10px]">
                                      {c.reward_type === "monthly_1m"
                                        ? "1 เดือน"
                                        : "Bundle 10"}
                                    </Badge>
                                    <span className="text-muted-foreground">
                                      {status}
                                    </span>
                                    <span className="text-muted-foreground">
                                      หมดอายุ{" "}
                                      {new Date(c.expires_at).toLocaleDateString("th-TH")}
                                    </span>
                                  </div>
                                );
                              })}
                            </div>
                          </div>

                          <div>
                            <div className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
                              Follow-up messages
                            </div>
                            <div className="mt-2 space-y-1 text-xs">
                              {(messagesByLead[l.id] ?? []).length === 0 && (
                                <div className="text-muted-foreground">
                                  ยังไม่ส่งข้อความติดตาม
                                </div>
                              )}
                              {(messagesByLead[l.id] ?? []).map((m) => (
                                <div
                                  key={`${m.day}-${m.channel}-${m.sent_at}`}
                                  className="flex items-center gap-3"
                                >
                                  <Badge variant="outline" className="text-[10px]">
                                    D{m.day}
                                  </Badge>
                                  <span>{m.channel}</span>
                                  <span className="text-muted-foreground">
                                    {new Date(m.sent_at).toLocaleString("th-TH", {
                                      year: "2-digit",
                                      month: "short",
                                      day: "numeric",
                                      hour: "2-digit",
                                      minute: "2-digit",
                                    })}
                                  </span>
                                </div>
                              ))}
                            </div>
                          </div>

                          <div
                            className="flex flex-wrap items-center gap-2"
                            onClick={(e) => e.stopPropagation()}
                          >
                            <Button
                              size="sm"
                              variant="outline"
                              disabled={busyId === l.id}
                              onClick={() => issueNewCode(l.id)}
                            >
                              {busyId === l.id ? "กำลังออกโค้ด..." : "ออกโค้ดใหม่ + ส่งอีเมล"}
                            </Button>
                            <select
                              value={l.stage}
                              disabled={busyId === l.id}
                              onChange={(e) =>
                                changeStage(l.id, e.target.value)
                              }
                              className="rounded-md border bg-background px-2 py-1 text-xs"
                            >
                              {Object.entries(STAGE_LABEL).map(([k, v]) => (
                                <option key={k} value={k}>
                                  {v}
                                </option>
                              ))}
                            </select>
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                  </Fragment>
                );
              })}
              {filtered.length === 0 && (
                <tr>
                  <td
                    colSpan={6}
                    className="px-4 py-12 text-center text-sm text-muted-foreground"
                  >
                    ไม่มี leads ตามเงื่อนไขที่กรอง
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </div>
  );
}

function exportCsv(rows: Lead[], codesByLead: Record<string, Code[]>) {
  const headers = [
    "id",
    "created_at",
    "source",
    "campaign",
    "ad_set",
    "stage",
    "name",
    "email",
    "phone",
    "status_year",
    "exam_target",
    "reward_choice",
    "active_code",
    "code_status",
    "code_expires_at",
  ];
  const cells: string[][] = [headers];
  for (const l of rows) {
    const codes = codesByLead[l.id] ?? [];
    const active = codes.find((c) => !c.redeemed_at) ?? codes[0];
    const expired = active && new Date(active.expires_at) < new Date();
    const codeStatus = !active
      ? ""
      : active.redeemed_at
        ? "used"
        : expired
          ? "expired"
          : "active";
    cells.push([
      l.id,
      l.created_at,
      l.source,
      l.campaign ?? "",
      // ad_set lives only in DB, not on the page; leave blank rather than over-fetch.
      "",
      l.stage,
      l.name ?? "",
      l.email ?? "",
      l.phone ?? "",
      l.status_year ?? "",
      l.exam_target ?? "",
      l.reward_choice ?? "",
      active?.code ?? "",
      codeStatus,
      active?.expires_at ?? "",
    ]);
  }

  // RFC-4180-style escape: wrap fields containing comma/quote/newline in
  // double quotes and double any inner quotes.
  const csv = cells
    .map((row) =>
      row
        .map((v) => {
          const s = String(v ?? "");
          if (/[",\n\r]/.test(s)) return `"${s.replace(/"/g, '""')}"`;
          return s;
        })
        .join(",")
    )
    .join("\n");

  // BOM so Excel opens the UTF-8 Thai characters correctly.
  const blob = new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `morroo-leads-${new Date().toISOString().slice(0, 10)}.csv`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

function FunnelCard({
  label,
  value,
  accent,
}: {
  label: string;
  value: number;
  accent?: "teal" | "amber" | "emerald" | "red" | "blue";
}) {
  const accentClasses: Record<string, string> = {
    teal: "text-teal-700",
    amber: "text-amber-700",
    emerald: "text-emerald-700",
    red: "text-red-700",
    blue: "text-blue-700",
  };
  return (
    <Card>
      <CardContent className="p-4">
        <div className="text-xs text-muted-foreground">{label}</div>
        <div
          className={`mt-1 text-2xl font-bold ${accent ? accentClasses[accent] : ""}`}
        >
          {value.toLocaleString()}
        </div>
      </CardContent>
    </Card>
  );
}
