"use client";

import { useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { PLAN_CATALOG, PRODUCT_INFO } from "@/lib/membership";
import { isOrgActive, joinPath, orgPlan, seatsRemaining, toCsv } from "@/lib/organizations";
import type { OrgDashboardData, OrgMemberDetail } from "@/lib/organizations-server";
import { ArrowUpDown, Check, Copy, Download, Flame, Loader2, Trash2, Users } from "lucide-react";

type SortKey = "name" | "attempts" | "accuracy" | "lastActive" | "streak";

const INACTIVE_DAYS = 7;

function fmtDate(iso: string | null) {
  if (!iso) return "-";
  return new Date(iso).toLocaleDateString("th-TH", { dateStyle: "medium" });
}

function daysSince(iso: string | null): number | null {
  if (!iso) return null;
  return Math.floor((Date.now() - new Date(iso).getTime()) / 86_400_000);
}

function sortValue(m: OrgMemberDetail, key: SortKey): string | number {
  switch (key) {
    case "name":
      return (m.name || m.email || "").toLowerCase();
    case "attempts":
      return m.progress.attempts;
    case "accuracy":
      return m.progress.accuracy;
    case "lastActive":
      return m.progress.lastActive ? new Date(m.progress.lastActive).getTime() : 0;
    case "streak":
      return m.progress.streak;
  }
}

export default function OrgDashboard({
  data,
  currentUserId,
}: {
  data: OrgDashboardData;
  currentUserId: string;
}) {
  const router = useRouter();
  const { org, members } = data;
  const [sortKey, setSortKey] = useState<SortKey>("lastActive");
  const [sortAsc, setSortAsc] = useState(false);
  const [copied, setCopied] = useState(false);
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const plan = PLAN_CATALOG[orgPlan(org.plan)];
  const active = isOrgActive(org);
  const remaining = seatsRemaining(org.seats, members.length);

  const sorted = useMemo(() => {
    return [...members].sort((a, b) => {
      const va = sortValue(a, sortKey);
      const vb = sortValue(b, sortKey);
      if (va < vb) return sortAsc ? -1 : 1;
      if (va > vb) return sortAsc ? 1 : -1;
      return 0;
    });
  }, [members, sortKey, sortAsc]);

  const totals = useMemo(() => {
    const attempts = members.reduce((s, m) => s + m.progress.attempts, 0);
    const correct = members.reduce((s, m) => s + m.progress.correct, 0);
    const active7d = members.filter((m) => {
      const d = daysSince(m.progress.lastActive);
      return d !== null && d <= INACTIVE_DAYS;
    }).length;
    return {
      attempts,
      accuracy: attempts ? Math.round((correct / attempts) * 1000) / 10 : 0,
      active7d,
    };
  }, [members]);

  function inviteUrl() {
    return `${window.location.origin}${joinPath(org.join_code)}`;
  }

  async function copyInvite() {
    try {
      await navigator.clipboard.writeText(inviteUrl());
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } catch {
      setError("คัดลอกไม่สำเร็จ — กรุณาคัดลอกลิงก์ด้วยตนเอง");
    }
  }

  function handleSort(key: SortKey) {
    if (sortKey === key) setSortAsc(!sortAsc);
    else {
      setSortKey(key);
      setSortAsc(key === "name");
    }
  }

  async function remove(m: OrgMemberDetail) {
    if (!confirm(`ลบ ${m.name || m.email || "สมาชิกนี้"} ออกจากกลุ่ม? สิทธิ์พรีเมียมผ่านกลุ่มจะสิ้นสุดทันที`)) return;
    setBusy(m.user_id);
    setError(null);
    try {
      const res = await fetch("/api/org/members", {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ org_id: org.id, user_id: m.user_id }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) setError(json.error ?? "ลบสมาชิกไม่สำเร็จ");
      else router.refresh();
    } catch {
      setError("เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่");
    }
    setBusy(null);
  }

  function exportCsv() {
    const csv = toCsv(
      ["ชื่อ", "อีเมล", "บทบาท", "วันที่เข้าร่วม", "MCQ ที่ทำ", "ตอบถูก", "ความแม่นยำ (%)", "ใช้งานล่าสุด", "Streak (วัน)"],
      sorted.map((m) => [
        m.name,
        m.email,
        m.role === "owner" ? "ผู้ดูแล" : "สมาชิก",
        m.joined_at.slice(0, 10),
        m.progress.attempts,
        m.progress.correct,
        m.progress.accuracy,
        m.progress.lastActive ? m.progress.lastActive.slice(0, 10) : "",
        m.progress.streak,
      ])
    );
    // BOM so Excel opens Thai text as UTF-8.
    const blob = new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `morroo-${org.name.replace(/[\\/:*?"<>|\s]+/g, "-")}-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

  const th = (key: SortKey, label: string, align = "text-right") => (
    <th className={`px-3 py-2 font-medium ${align}`}>
      <button type="button" onClick={() => handleSort(key)} className="inline-flex items-center gap-1 hover:text-foreground">
        {label}
        <ArrowUpDown className={`h-3 w-3 ${sortKey === key ? "text-brand" : "opacity-40"}`} />
      </button>
    </th>
  );

  return (
    <div>
      <div className="mb-6 flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="flex items-center gap-2 text-2xl font-bold">
            <Users className="h-6 w-6 text-brand" /> {org.name}
          </h1>
          <div className="mt-2 flex flex-wrap items-center gap-1.5 text-sm text-muted-foreground">
            {plan.products.map((p) => (
              <Badge key={p} className={`text-[10px] ${PRODUCT_INFO[p].color}`}>
                {PRODUCT_INFO[p].short}
              </Badge>
            ))}
            <span className={active ? "" : "font-medium text-red-600"}>
              {active ? `ใช้ได้ถึง ${fmtDate(org.expires_at)}` : `หมดอายุแล้ว (${fmtDate(org.expires_at)})`}
            </span>
          </div>
        </div>
        <div className="flex flex-wrap gap-2">
          <Button variant="outline" size="sm" onClick={copyInvite} className="gap-1.5">
            {copied ? <Check className="h-4 w-4" /> : <Copy className="h-4 w-4" />}
            {copied ? "คัดลอกแล้ว" : "คัดลอกลิงก์เชิญ"}
          </Button>
          <Button variant="outline" size="sm" onClick={exportCsv} className="gap-1.5">
            <Download className="h-4 w-4" /> Export CSV
          </Button>
        </div>
      </div>

      <p className="mb-4 text-sm text-muted-foreground">
        รหัสกลุ่ม <span className="font-mono font-semibold text-foreground">{org.join_code}</span> — ส่งลิงก์เชิญให้สมาชิกกดเข้าร่วม
        (ต้องสมัคร / เข้าสู่ระบบ MorRoo ก่อน)
      </p>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-2 text-sm text-red-700">{error}</div>
      )}

      <div className="mb-6 grid grid-cols-2 gap-3 sm:grid-cols-4">
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-2xl font-bold">
              {members.length}/{org.seats}
            </p>
            <p className="text-sm text-muted-foreground">ที่นั่งที่ใช้ (เหลือ {remaining})</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-2xl font-bold">{totals.active7d}</p>
            <p className="text-sm text-muted-foreground">ใช้งานใน {INACTIVE_DAYS} วัน</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-2xl font-bold">{totals.attempts.toLocaleString()}</p>
            <p className="text-sm text-muted-foreground">MCQ ที่ทำรวม</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5 pb-4">
            <p className="text-2xl font-bold">{totals.accuracy}%</p>
            <p className="text-sm text-muted-foreground">ความแม่นยำเฉลี่ย</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardContent className="overflow-x-auto p-0">
          <table className="w-full text-sm">
            <thead className="border-b bg-muted/50 text-muted-foreground">
              <tr>
                {th("name", "สมาชิก", "text-left")}
                {th("attempts", "MCQ ที่ทำ")}
                {th("accuracy", "ความแม่นยำ")}
                {th("lastActive", "ใช้งานล่าสุด")}
                {th("streak", "Streak")}
                <th className="px-3 py-2" />
              </tr>
            </thead>
            <tbody>
              {sorted.length === 0 && (
                <tr>
                  <td colSpan={6} className="px-3 py-8 text-center text-muted-foreground">
                    ยังไม่มีสมาชิก — คัดลอกลิงก์เชิญแล้วส่งให้กลุ่มได้เลย
                  </td>
                </tr>
              )}
              {sorted.map((m) => {
                const idle = daysSince(m.progress.lastActive);
                return (
                  <tr key={m.user_id} className="border-b last:border-0">
                    <td className="px-3 py-2">
                      <div className="font-medium">
                        {m.name || "-"}
                        {m.role === "owner" && (
                          <Badge className="ml-2 bg-brand/10 text-[10px] text-brand">ผู้ดูแล</Badge>
                        )}
                      </div>
                      <div className="text-xs text-muted-foreground">{m.email}</div>
                    </td>
                    <td className="px-3 py-2 text-right tabular-nums">{m.progress.attempts.toLocaleString()}</td>
                    <td className="px-3 py-2 text-right tabular-nums">
                      {m.progress.attempts ? `${m.progress.accuracy}%` : "-"}
                    </td>
                    <td
                      className={`px-3 py-2 text-right ${
                        idle === null || idle > INACTIVE_DAYS ? "text-amber-600" : ""
                      }`}
                    >
                      {fmtDate(m.progress.lastActive)}
                    </td>
                    <td className="px-3 py-2 text-right tabular-nums">
                      {m.progress.streak > 0 ? (
                        <span className="inline-flex items-center gap-0.5 text-orange-600">
                          <Flame className="h-3.5 w-3.5" />
                          {m.progress.streak}
                        </span>
                      ) : (
                        "0"
                      )}
                    </td>
                    <td className="px-3 py-2 text-right">
                      {m.role === "member" && m.user_id !== currentUserId && (
                        <Button
                          variant="ghost"
                          size="sm"
                          onClick={() => remove(m)}
                          disabled={busy === m.user_id}
                          aria-label="ลบสมาชิก"
                          className="text-red-600 hover:bg-red-50 hover:text-red-700"
                        >
                          {busy === m.user_id ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
                        </Button>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </CardContent>
      </Card>
      <p className="mt-3 text-xs text-muted-foreground">
        สถิติจากข้อสอบ MCQ ทั้งหมดของสมาชิก · Streak = จำนวนวันติดต่อกันที่ทำ MCQ (นับถึงวันนี้หรือเมื่อวาน)
      </p>
    </div>
  );
}
