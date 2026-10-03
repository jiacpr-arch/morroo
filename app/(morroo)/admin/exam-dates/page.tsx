"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { ChevronLeft, Loader2, Lock, Plus, RefreshCw, Shield, Trash2, Eye, EyeOff } from "lucide-react";

type Kind = "nl1" | "nl2" | "part1" | "osce" | "meq";
const KINDS: Kind[] = ["part1", "nl2", "nl1", "osce", "meq"];

interface Round {
  id: string;
  kind: Kind;
  label: string;
  exam_date: string;
  confirmed: boolean;
  is_active: boolean;
  source: "seed" | "manual" | "auto";
  source_url: string | null;
  evidence: string | null;
  locked: boolean;
  previous_date: string | null;
}

interface PageReport {
  url: string;
  linkText: string;
  fetched: boolean;
  error?: string;
  textChars: number;
  pdfs: { url: string; ok: boolean; bytes?: number; error?: string }[];
  aiErrors: string[];
  accepted: string[];
  rejected: { label: string; reason: string }[];
}
interface Report {
  listFetched: boolean;
  listError?: string;
  linksFound: number;
  pages: PageReport[];
  changes: { inserted: number; dateChanges: number; confirms: number };
  lockedConflicts: number;
  suspicious: boolean;
}

const SOURCE_LABEL: Record<Round["source"], string> = { seed: "ตั้งต้น", manual: "แอดมิน", auto: "อัตโนมัติ" };

export default function AdminExamDatesPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [rounds, setRounds] = useState<Round[]>([]);
  const [busy, setBusy] = useState<string | null>(null);
  const [msg, setMsg] = useState<string | null>(null);
  const [scanning, setScanning] = useState(false);
  const [report, setReport] = useState<Report | null>(null);
  const [draft, setDraft] = useState({ kind: "part1" as Kind, label: "", exam_date: "" });

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/exam-dates");
    if (!res.ok) return;
    const json = await res.json();
    setRounds(json.rounds ?? []);
  }, []);

  useEffect(() => {
    (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role === "admin") {
        setIsAdmin(true);
        await load();
      }
      setLoading(false);
    })();
  }, [router, load]);

  async function patch(id: string, body: Record<string, unknown>) {
    setBusy(id);
    setMsg(null);
    const res = await fetch("/api/admin/exam-dates", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id, ...body }),
    });
    if (!res.ok) setMsg((await res.json().catch(() => ({}))).error ?? "บันทึกไม่สำเร็จ");
    await load();
    setBusy(null);
  }

  async function remove(r: Round) {
    if (!confirm(`ลบ "${r.label}" ?`)) return;
    setBusy(r.id);
    await fetch(`/api/admin/exam-dates?id=${r.id}`, { method: "DELETE" });
    await load();
    setBusy(null);
  }

  async function add() {
    setBusy("new");
    setMsg(null);
    const res = await fetch("/api/admin/exam-dates", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ...draft, confirmed: true }),
    });
    if (res.ok) setDraft({ ...draft, label: "", exam_date: "" });
    else setMsg((await res.json().catch(() => ({}))).error ?? "เพิ่มไม่สำเร็จ");
    await load();
    setBusy(null);
  }

  async function scan() {
    setScanning(true);
    setReport(null);
    setMsg(null);
    try {
      const res = await fetch("/api/admin/exam-dates/scan", { method: "POST" });
      const json = await res.json();
      if (!res.ok) setMsg(json.error ?? "สแกนไม่สำเร็จ");
      else setReport(json.report);
    } catch {
      setMsg("สแกนไม่สำเร็จ (เชื่อมต่อไม่ได้/หมดเวลา)");
    }
    await load();
    setScanning(false);
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20">
        <Loader2 className="h-6 w-6 animate-spin" />
      </div>
    );
  }
  if (!isAdmin) {
    return (
      <div className="py-20 text-center text-muted-foreground">
        <Shield className="mx-auto mb-2 h-8 w-8" /> เฉพาะแอดมิน
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-4xl space-y-6 px-4 py-8">
      <div>
        <Link href="/admin" className="inline-flex items-center text-sm text-muted-foreground hover:underline">
          <ChevronLeft className="h-4 w-4" /> แอดมิน
        </Link>
        <h1 className="mt-1 text-2xl font-bold">ปฏิทินสอบ ศรว.</h1>
        <p className="text-sm text-muted-foreground">
          ระบบอ่านประกาศ ศรว. แล้วอัปเดตวันสอบเองทุกวัน — รอบที่แอดมินแก้จะถูกล็อก (ระบบอัตโนมัติไม่ทับ)
          เตือนนับถอยหลังส่งเฉพาะรอบที่ &ldquo;ประกาศแล้ว&rdquo;
        </p>
      </div>

      <Card>
        <CardContent className="flex flex-wrap items-center gap-3 py-4">
          <Button onClick={scan} disabled={scanning} className="gap-2">
            {scanning ? <Loader2 className="h-4 w-4 animate-spin" /> : <RefreshCw className="h-4 w-4" />}
            สแกนประกาศ ศรว. ตอนนี้
          </Button>
          <span className="text-xs text-muted-foreground">อ่านประกาศ/PDF แล้วอัปเดตทันที (ใช้เวลาไม่กี่นาที)</span>
        </CardContent>
      </Card>

      {msg && <p className="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700">{msg}</p>}

      {report && (
        <Card>
          <CardContent className="space-y-2 py-4 text-sm">
            <p className="font-semibold">
              {report.listFetched ? `พบลิงก์ประกาศ ${report.linksFound} รายการ` : `เปิดหน้าข่าวไม่ได้: ${report.listError}`}
              {" · "}เพิ่ม {report.changes.inserted} · เลื่อนวัน {report.changes.dateChanges} · ยืนยัน{" "}
              {report.changes.confirms}
              {report.lockedConflicts > 0 && ` · ชนรอบที่ล็อก ${report.lockedConflicts}`}
            </p>
            {report.suspicious && (
              <p className="text-red-700">AI ตอบเปลี่ยนมากผิดปกติ — ระบบไม่ลงอะไรเลยรอบนี้</p>
            )}
            {report.pages.map((p) => (
              <div key={p.url} className="rounded-lg border p-2">
                <a href={p.url} target="_blank" rel="noopener noreferrer" className="font-medium underline">
                  {p.linkText || p.url}
                </a>
                <p className="text-xs text-muted-foreground">
                  {p.fetched ? `อ่านข้อความ ${p.textChars} ตัวอักษร` : `ดึงไม่สำเร็จ: ${p.error}`}
                  {p.pdfs.map((f) => ` · PDF ${f.ok ? `${f.bytes ?? 0} B` : `ล้มเหลว (${f.error})`}`)}
                </p>
                {p.aiErrors.map((e, i) => (
                  <p key={i} className="text-xs text-red-700">AI: {e}</p>
                ))}
                {p.accepted.map((a) => (
                  <p key={a} className="text-xs text-green-700">✓ {a}</p>
                ))}
                {p.rejected.map((r, i) => (
                  <p key={i} className="text-xs text-amber-700">
                    ✗ {r.label}: {r.reason}
                  </p>
                ))}
              </div>
            ))}
          </CardContent>
        </Card>
      )}

      <Card>
        <CardContent className="space-y-3 py-4">
          <h2 className="font-bold">เพิ่มรอบสอบ</h2>
          <div className="flex flex-wrap gap-2">
            <select
              className="rounded-md border bg-background px-2 py-1 text-sm"
              value={draft.kind}
              onChange={(e) => setDraft({ ...draft, kind: e.target.value as Kind })}
            >
              {KINDS.map((k) => (
                <option key={k} value={k}>
                  {k}
                </option>
              ))}
            </select>
            <input
              className="min-w-[14rem] flex-1 rounded-md border bg-background px-2 py-1 text-sm"
              placeholder="ชื่อรอบ เช่น ส่วนที่ 1 รอบ 1/2570"
              value={draft.label}
              onChange={(e) => setDraft({ ...draft, label: e.target.value })}
            />
            <input
              type="date"
              className="rounded-md border bg-background px-2 py-1 text-sm"
              value={draft.exam_date}
              onChange={(e) => setDraft({ ...draft, exam_date: e.target.value })}
            />
            <Button onClick={add} disabled={busy === "new" || !draft.label || !draft.exam_date} className="gap-1">
              <Plus className="h-4 w-4" /> เพิ่ม
            </Button>
          </div>
        </CardContent>
      </Card>

      <div className="space-y-2">
        {rounds.map((r) => (
          <Card key={r.id} className={r.is_active ? "" : "opacity-60"}>
            <CardContent className="space-y-2 py-3">
              <div className="flex flex-wrap items-center gap-2">
                <Badge variant="secondary">{r.kind}</Badge>
                <span className="font-semibold">{r.label}</span>
                <Badge className={r.confirmed ? "bg-green-100 text-green-700" : "bg-amber-100 text-amber-700"}>
                  {r.confirmed ? "ประกาศแล้ว" : "คาดการณ์"}
                </Badge>
                <Badge variant="outline">{SOURCE_LABEL[r.source]}</Badge>
                {r.locked && (
                  <Badge variant="outline" className="gap-1">
                    <Lock className="h-3 w-3" /> ล็อก
                  </Badge>
                )}
              </div>
              <div className="flex flex-wrap items-center gap-2">
                <input
                  type="date"
                  defaultValue={r.exam_date}
                  key={`${r.id}-${r.exam_date}`}
                  disabled={busy === r.id}
                  className="rounded-md border bg-background px-2 py-1 text-sm"
                  onBlur={(e) => {
                    if (e.target.value && e.target.value !== r.exam_date) patch(r.id, { exam_date: e.target.value });
                  }}
                />
                <Button size="sm" variant="outline" disabled={busy === r.id} onClick={() => patch(r.id, { confirmed: !r.confirmed })}>
                  {r.confirmed ? "ตั้งเป็นคาดการณ์" : "ตั้งเป็นประกาศแล้ว"}
                </Button>
                <Button size="sm" variant="outline" disabled={busy === r.id} onClick={() => patch(r.id, { is_active: !r.is_active })} className="gap-1">
                  {r.is_active ? <EyeOff className="h-3 w-3" /> : <Eye className="h-3 w-3" />}
                  {r.is_active ? "ซ่อน" : "แสดง"}
                </Button>
                {r.locked && (
                  <Button size="sm" variant="outline" disabled={busy === r.id} onClick={() => patch(r.id, { locked: false })}>
                    ปลดล็อก (ให้ระบบอัปเดตได้)
                  </Button>
                )}
                <Button size="sm" variant="ghost" disabled={busy === r.id} onClick={() => remove(r)} className="text-red-600">
                  <Trash2 className="h-4 w-4" />
                </Button>
              </div>
              {(r.previous_date || r.evidence || r.source_url) && (
                <div className="space-y-0.5 text-xs text-muted-foreground">
                  {r.previous_date && <p>วันเดิม: {r.previous_date}</p>}
                  {r.evidence && <p>อ้างอิง: &ldquo;{r.evidence}&rdquo;</p>}
                  {r.source_url && (
                    <a href={r.source_url} target="_blank" rel="noopener noreferrer" className="underline">
                      ต้นทาง
                    </a>
                  )}
                </div>
              )}
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
