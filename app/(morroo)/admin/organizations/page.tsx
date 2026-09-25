"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { PLAN_CATALOG, PLAN_TYPES } from "@/lib/membership";
import { DEFAULT_ORG_PLAN, isOrgActive, joinPath, orgPlan, type Organization } from "@/lib/organizations";
import {
  Building2,
  Check,
  ChevronLeft,
  Copy,
  ExternalLink,
  Loader2,
  Plus,
  RefreshCw,
  Save,
  Shield,
  Trash2,
  UserPlus,
} from "lucide-react";

type OrgItem = Organization & {
  note: string | null;
  member_count: number;
  owners: { user_id: string; email: string | null; name: string | null }[];
};

type Draft = { name: string; seats: string; plan: string; expires: string; note: string; owner: string };

function toDateInput(iso: string | null | undefined): string {
  if (!iso) return "";
  const d = new Date(iso);
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

/** Date input → end of that day, local time. */
function fromDateInput(v: string): string | null {
  if (!v) return null;
  const d = new Date(`${v}T23:59:59`);
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

function defaultExpiry(): string {
  const d = new Date();
  d.setFullYear(d.getFullYear() + 1);
  return toDateInput(d.toISOString());
}

function draftFrom(o: OrgItem): Draft {
  return {
    name: o.name,
    seats: String(o.seats),
    plan: orgPlan(o.plan),
    expires: toDateInput(o.expires_at),
    note: o.note ?? "",
    owner: "",
  };
}

export default function AdminOrganizationsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [items, setItems] = useState<OrgItem[]>([]);
  const [drafts, setDrafts] = useState<Record<string, Draft>>({});
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [copied, setCopied] = useState<string | null>(null);

  // Create form
  const [name, setName] = useState("");
  const [seats, setSeats] = useState("30");
  const [plan, setPlan] = useState<string>(DEFAULT_ORG_PLAN);
  const [expires, setExpires] = useState(defaultExpiry);
  const [ownerEmail, setOwnerEmail] = useState("");
  const [note, setNote] = useState("");
  const [creating, setCreating] = useState(false);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/organizations");
    if (!res.ok) {
      setError("โหลดรายการไม่สำเร็จ (รัน migration 20260925_organizations.sql แล้วหรือยัง?)");
      return;
    }
    const json = (await res.json()) as { items?: OrgItem[] };
    const list = json.items ?? [];
    setItems(list);
    setDrafts(Object.fromEntries(list.map((o) => [o.id, draftFrom(o)])));
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login?next=/admin/organizations");
        return;
      }
      const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      await load();
      setLoading(false);
    }
    init();
  }, [router, load]);

  async function create() {
    setCreating(true);
    setError(null);
    setNotice(null);
    try {
      const res = await fetch("/api/admin/organizations", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name,
          seats: Number(seats),
          plan,
          expires_at: fromDateInput(expires),
          owner_email: ownerEmail.trim() || undefined,
          note,
        }),
      });
      const json = (await res.json()) as { error?: string; warning?: string; item?: Organization };
      if (!res.ok) {
        setError(json.error ?? "สร้างกลุ่มไม่สำเร็จ");
        return;
      }
      setNotice(json.warning ?? `สร้างกลุ่ม "${json.item?.name}" แล้ว — รหัส ${json.item?.join_code}`);
      setName("");
      setOwnerEmail("");
      setNote("");
      await load();
    } finally {
      setCreating(false);
    }
  }

  async function patch(id: string, body: Record<string, unknown>, key: string) {
    setBusy(`${id}:${key}`);
    setError(null);
    setNotice(null);
    try {
      const res = await fetch(`/api/admin/organizations/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });
      const json = (await res.json()) as { error?: string; warning?: string; join_code?: string };
      if (!res.ok) {
        setError(json.error ?? "บันทึกไม่สำเร็จ");
        return;
      }
      setNotice(json.warning ?? (json.join_code ? `รหัสใหม่: ${json.join_code} (ลิงก์เดิมใช้ไม่ได้แล้ว)` : "บันทึกแล้ว"));
      await load();
    } finally {
      setBusy(null);
    }
  }

  function save(o: OrgItem) {
    const d = drafts[o.id];
    if (!d) return;
    const exp = fromDateInput(d.expires);
    if (!exp) {
      setError("วันหมดอายุไม่ถูกต้อง");
      return;
    }
    patch(o.id, { name: d.name, seats: Number(d.seats), plan: d.plan, expires_at: exp, note: d.note }, "save");
  }

  function regenerate(o: OrgItem) {
    if (!confirm(`สร้างรหัสใหม่ให้ "${o.name}"? ลิงก์เชิญเดิมจะใช้ไม่ได้ (สมาชิกเดิมยังอยู่)`)) return;
    patch(o.id, { regenerate_code: true }, "code");
  }

  function addOwner(o: OrgItem) {
    const email = drafts[o.id]?.owner.trim();
    if (!email) return;
    patch(o.id, { owner_email: email }, "owner");
  }

  async function remove(o: OrgItem) {
    if (!confirm(`ลบกลุ่ม "${o.name}"? สมาชิก ${o.member_count} คนจะเสียสิทธิ์ทันที (แนะนำให้ตั้งวันหมดอายุแทน)`)) return;
    setBusy(`${o.id}:delete`);
    setError(null);
    const res = await fetch(`/api/admin/organizations/${o.id}`, { method: "DELETE" });
    if (!res.ok) setError("ลบไม่สำเร็จ");
    await load();
    setBusy(null);
  }

  async function copyLink(o: OrgItem) {
    await navigator.clipboard.writeText(`${window.location.origin}${joinPath(o.join_code)}`);
    setCopied(o.id);
    setTimeout(() => setCopied(null), 2000);
  }

  function setDraft(id: string, patchDraft: Partial<Draft>) {
    setDrafts((prev) => ({ ...prev, [id]: { ...prev[id], ...patchDraft } }));
  }

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }
  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="mx-auto mb-4 h-12 w-12 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  const selectCls =
    "mt-1 flex h-9 w-full rounded-md border border-input bg-background px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring";

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <Link href="/admin" className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับ Dashboard
      </Link>

      <div className="mb-6">
        <h1 className="flex items-center gap-2 text-2xl font-bold">
          <Building2 className="h-6 w-6 text-brand" /> กลุ่ม / สถาบัน
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          แพ็กเกจกลุ่ม (คณะแพทย์ · ติวเตอร์ · กลุ่มเพื่อน) — ชำระเงินนอกระบบ / ออกใบแจ้งหนี้แล้วสร้างกลุ่มที่นี่
          สมาชิกทุกคน (รวมผู้ดูแล) นับ 1 ที่นั่ง และได้สิทธิ์ตามแพ็กจนถึงวันหมดอายุของกลุ่ม
        </p>
      </div>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-2 text-sm text-red-700">{error}</div>
      )}
      {notice && (
        <div className="mb-4 rounded-md border border-emerald-200 bg-emerald-50 px-4 py-2 text-sm text-emerald-700">{notice}</div>
      )}

      <Card className="mb-6">
        <CardHeader className="pb-3">
          <CardTitle className="text-base">สร้างกลุ่มใหม่</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
            <div className="sm:col-span-2">
              <Label htmlFor="o-name">ชื่อกลุ่ม / สถาบัน</Label>
              <Input id="o-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="เช่น แพทย์ มข. รุ่น 50" className="mt-1" />
            </div>
            <div>
              <Label htmlFor="o-seats">จำนวนที่นั่ง</Label>
              <Input id="o-seats" type="number" min={1} value={seats} onChange={(e) => setSeats(e.target.value)} className="mt-1" />
            </div>
            <div>
              <Label htmlFor="o-plan">สิทธิ์ที่ได้ (แพ็ก)</Label>
              <select id="o-plan" value={plan} onChange={(e) => setPlan(e.target.value)} className={selectCls}>
                {PLAN_TYPES.map((pl) => (
                  <option key={pl} value={pl}>
                    {PLAN_CATALOG[pl].label} — {PLAN_CATALOG[pl].products.join(", ")}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <Label htmlFor="o-exp">หมดอายุ</Label>
              <Input id="o-exp" type="date" value={expires} onChange={(e) => setExpires(e.target.value)} className="mt-1" />
            </div>
            <div>
              <Label htmlFor="o-owner">อีเมลผู้ดูแลกลุ่ม (ไม่บังคับ)</Label>
              <Input id="o-owner" type="email" value={ownerEmail} onChange={(e) => setOwnerEmail(e.target.value)} placeholder="teacher@example.com" className="mt-1" />
            </div>
            <div className="sm:col-span-3">
              <Label htmlFor="o-note">หมายเหตุ (เลขใบแจ้งหนี้ / ผู้ติดต่อ)</Label>
              <Input id="o-note" value={note} onChange={(e) => setNote(e.target.value)} className="mt-1" />
            </div>
          </div>
          <Button onClick={create} disabled={creating || !name.trim()} className="gap-1.5">
            {creating ? <Loader2 className="h-4 w-4 animate-spin" /> : <Plus className="h-4 w-4" />} สร้างกลุ่ม
          </Button>
        </CardContent>
      </Card>

      {items.length === 0 && <p className="text-center text-sm text-muted-foreground">ยังไม่มีกลุ่ม</p>}

      <div className="space-y-4">
        {items.map((o) => {
          const d = drafts[o.id] ?? draftFrom(o);
          const active = isOrgActive(o);
          const isBusy = (k: string) => busy === `${o.id}:${k}`;
          return (
            <Card key={o.id}>
              <CardContent className="space-y-4 pt-5">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <div className="flex flex-wrap items-center gap-2">
                    <h2 className="text-lg font-semibold">{o.name}</h2>
                    <Badge className={active ? "bg-emerald-100 text-emerald-700" : "bg-red-100 text-red-700"}>
                      {active ? "ใช้งานอยู่" : "หมดอายุ"}
                    </Badge>
                    <Badge className={o.member_count >= o.seats ? "bg-amber-100 text-amber-700" : "bg-gray-100 text-gray-700"}>
                      {o.member_count}/{o.seats} ที่นั่ง
                    </Badge>
                  </div>
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="font-mono text-sm">{o.join_code}</span>
                    <Button variant="outline" size="sm" onClick={() => copyLink(o)} className="gap-1">
                      {copied === o.id ? <Check className="h-3.5 w-3.5" /> : <Copy className="h-3.5 w-3.5" />} ลิงก์เชิญ
                    </Button>
                    <Button variant="outline" size="sm" onClick={() => regenerate(o)} disabled={isBusy("code")} className="gap-1">
                      <RefreshCw className={`h-3.5 w-3.5 ${isBusy("code") ? "animate-spin" : ""}`} /> รหัสใหม่
                    </Button>
                    <Link href={`/org?id=${o.id}`}>
                      <Button variant="outline" size="sm" className="gap-1">
                        <ExternalLink className="h-3.5 w-3.5" /> แดชบอร์ด
                      </Button>
                    </Link>
                  </div>
                </div>

                <div className="grid grid-cols-1 gap-3 sm:grid-cols-6">
                  <div className="sm:col-span-2">
                    <Label className="text-xs">ชื่อ</Label>
                    <Input value={d.name} onChange={(e) => setDraft(o.id, { name: e.target.value })} className="mt-1" />
                  </div>
                  <div>
                    <Label className="text-xs">ที่นั่ง</Label>
                    <Input type="number" min={Math.max(1, o.member_count)} value={d.seats} onChange={(e) => setDraft(o.id, { seats: e.target.value })} className="mt-1" />
                  </div>
                  <div>
                    <Label className="text-xs">แพ็ก</Label>
                    <select value={d.plan} onChange={(e) => setDraft(o.id, { plan: e.target.value })} className={selectCls}>
                      {PLAN_TYPES.map((pl) => (
                        <option key={pl} value={pl}>{PLAN_CATALOG[pl].label}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <Label className="text-xs">หมดอายุ</Label>
                    <Input type="date" value={d.expires} onChange={(e) => setDraft(o.id, { expires: e.target.value })} className="mt-1" />
                  </div>
                  <div className="flex items-end">
                    <Button size="sm" onClick={() => save(o)} disabled={isBusy("save")} className="w-full gap-1">
                      {isBusy("save") ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Save className="h-3.5 w-3.5" />} บันทึก
                    </Button>
                  </div>
                  <div className="sm:col-span-6">
                    <Label className="text-xs">หมายเหตุ</Label>
                    <Input value={d.note} onChange={(e) => setDraft(o.id, { note: e.target.value })} className="mt-1" />
                  </div>
                </div>

                <div className="flex flex-wrap items-end justify-between gap-3 border-t pt-3">
                  <div className="text-sm">
                    <span className="text-muted-foreground">ผู้ดูแล: </span>
                    {o.owners.length === 0
                      ? <span className="text-amber-600">ยังไม่มี</span>
                      : o.owners.map((ow) => ow.email || ow.name || ow.user_id).join(", ")}
                  </div>
                  <div className="flex flex-wrap items-center gap-2">
                    <Input
                      type="email"
                      value={d.owner}
                      onChange={(e) => setDraft(o.id, { owner: e.target.value })}
                      placeholder="อีเมลผู้ดูแลเพิ่ม"
                      className="h-8 w-56"
                    />
                    <Button variant="outline" size="sm" onClick={() => addOwner(o)} disabled={!d.owner.trim() || isBusy("owner")} className="gap-1">
                      <UserPlus className="h-3.5 w-3.5" /> ตั้งเป็นผู้ดูแล
                    </Button>
                    <Button variant="ghost" size="sm" onClick={() => remove(o)} disabled={isBusy("delete")} className="gap-1 text-red-600 hover:bg-red-50 hover:text-red-700">
                      <Trash2 className="h-3.5 w-3.5" /> ลบกลุ่ม
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
