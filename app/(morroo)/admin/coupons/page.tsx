"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { COUPON_TYPE_LABELS, type CouponCode, type CouponPlatform, type CouponType } from "@/lib/types-standard";
import { couponRewardLabel } from "@/lib/coupons";
import { PLAN_CATALOG, PLAN_TYPES } from "@/lib/membership";
import {
  Ban,
  Check,
  ChevronDown,
  ChevronLeft,
  ChevronUp,
  Copy,
  Loader2,
  Plus,
  RotateCcw,
  Search,
  Shield,
  Ticket,
  Trash2,
} from "lucide-react";

type Redemption = { user_id: string; email: string | null; name: string | null; redeemed_at: string };
type Coupon = CouponCode & { redemptions: Redemption[] };
type Derived = "active" | "inactive" | "expired" | "exhausted" | "scheduled";

const DERIVED_LABEL: Record<Derived, string> = {
  active: "ใช้ได้",
  scheduled: "ยังไม่เริ่ม",
  inactive: "ปิดใช้",
  expired: "หมดอายุ",
  exhausted: "ใช้ครบแล้ว",
};
const DERIVED_COLOR: Record<Derived, string> = {
  active: "bg-emerald-100 text-emerald-700",
  scheduled: "bg-sky-100 text-sky-700",
  inactive: "bg-gray-200 text-gray-600",
  expired: "bg-red-100 text-red-700",
  exhausted: "bg-amber-100 text-amber-700",
};
const PLATFORM_LABEL: Record<CouponPlatform, string> = {
  all: "ทุกแพลตฟอร์ม",
  medical: "Morroo (แพทย์)",
  pharmacy: "เภสัช",
};
const VALUE_LABEL: Record<CouponType, string> = {
  free_trial: "จำนวนวัน",
  free_month: "จำนวนเดือน",
  discount_percent: "ส่วนลด %",
  discount_fixed: "ส่วนลด (บาท)",
};

function derive(c: Coupon): Derived {
  const now = Date.now();
  if (!c.is_active) return "inactive";
  if (c.expires_at && new Date(c.expires_at).getTime() <= now) return "expired";
  if (c.max_uses != null && (c.current_uses ?? 0) >= c.max_uses) return "exhausted";
  if (c.starts_at && new Date(c.starts_at).getTime() > now) return "scheduled";
  return "active";
}

function fmtDate(iso: string | null | undefined) {
  if (!iso) return "-";
  return new Date(iso).toLocaleString("th-TH", { dateStyle: "short", timeStyle: "short" });
}

function defaultExpiry(): string {
  const d = new Date(Date.now() + 30 * 86_400_000);
  d.setHours(23, 59, 0, 0);
  const pad = (n: number) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

export default function AdminCouponsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [items, setItems] = useState<Coupon[]>([]);
  const [filter, setFilter] = useState<Derived | "all">("all");
  const [search, setSearch] = useState("");
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [expanded, setExpanded] = useState<string | null>(null);
  const [copied, setCopied] = useState<string | null>(null);

  // Create form
  const [couponType, setCouponType] = useState<CouponType>("free_trial");
  const [value, setValue] = useState<string>("7");
  const [platform, setPlatform] = useState<CouponPlatform>("all");
  const [mode, setMode] = useState<"auto" | "custom">("auto");
  const [customCode, setCustomCode] = useState("");
  const [count, setCount] = useState<number>(1);
  const [maxUses, setMaxUses] = useState<string>("1");
  const [expiresAt, setExpiresAt] = useState<string>(defaultExpiry);
  const [description, setDescription] = useState("");
  const [source, setSource] = useState("");
  // free_*: what to grant (default = student pack monthly); discount_*: limit to a plan ("" = any)
  const [planType, setPlanType] = useState<string>("");
  const [customPlan, setCustomPlan] = useState<string>("");
  const [creating, setCreating] = useState(false);
  const [justCreated, setJustCreated] = useState<CouponCode[]>([]);

  const load = useCallback(async () => {
    const res = await fetch("/api/admin/coupons");
    if (!res.ok) {
      setError("โหลดรายการไม่สำเร็จ");
      return;
    }
    const json = await res.json();
    setItems(json.items ?? []);
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login?next=/admin/coupons");
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

  const counts = useMemo(() => {
    const c: Record<Derived, number> = { active: 0, scheduled: 0, inactive: 0, expired: 0, exhausted: 0 };
    for (const it of items) c[derive(it)]++;
    return c;
  }, [items]);

  const visible = useMemo(() => {
    const q = search.trim().toUpperCase();
    return items.filter((c) => {
      if (filter !== "all" && derive(c) !== filter) return false;
      if (!q) return true;
      return (
        c.code.includes(q) ||
        (c.description ?? "").toUpperCase().includes(q) ||
        (c.source ?? "").toUpperCase().includes(q) ||
        c.redemptions.some((r) => (r.email ?? "").toUpperCase().includes(q) || (r.name ?? "").toUpperCase().includes(q))
      );
    });
  }, [items, filter, search]);

  function onTypeChange(t: CouponType) {
    setCouponType(t);
    setValue(t === "free_trial" ? "7" : t === "free_month" ? "1" : t === "discount_percent" ? "50" : "100");
  }

  async function create() {
    setCreating(true);
    setError(null);
    try {
      const res = await fetch("/api/admin/coupons", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          coupon_type: couponType,
          value: Number(value),
          platform,
          code: mode === "custom" ? customCode : undefined,
          count: mode === "auto" ? count : 1,
          max_uses: maxUses.trim() === "" ? null : Number(maxUses),
          max_uses_per_user: 1,
          expires_at: expiresAt ? new Date(expiresAt).toISOString() : null,
          description,
          source,
          plan_type: planType === "__item__" ? customPlan.trim() : planType || undefined,
        }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(json.error ?? "สร้างโค้ดไม่สำเร็จ");
        return;
      }
      setJustCreated(json.items ?? []);
      setCustomCode("");
      await load();
    } finally {
      setCreating(false);
    }
  }

  async function copyText(text: string, key: string) {
    try {
      await navigator.clipboard.writeText(text);
      setCopied(key);
      setTimeout(() => setCopied((c) => (c === key ? null : c)), 1500);
    } catch {
      // clipboard unavailable — user can select manually
    }
  }

  async function patch(c: Coupon, body: Record<string, unknown>) {
    setBusy(c.id);
    setError(null);
    const res = await fetch(`/api/admin/coupons/${c.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      setError(json.error ?? "อัปเดตไม่สำเร็จ");
    }
    await load();
    setBusy(null);
  }

  async function remove(c: Coupon) {
    if (!confirm(`ลบโค้ด ${c.code} ถาวร?`)) return;
    setBusy(c.id);
    setError(null);
    const res = await fetch(`/api/admin/coupons/${c.id}`, { method: "DELETE" });
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      setError(json.error ?? "ลบไม่สำเร็จ");
    }
    setJustCreated((list) => list.filter((x) => x.id !== c.id));
    await load();
    setBusy(null);
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
  const siteUrl = typeof window !== "undefined" ? window.location.origin : "https://www.morroo.com";
  const isDiscount = couponType === "discount_percent" || couponType === "discount_fixed";

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <Link href="/admin" className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับ Dashboard
      </Link>

      <div className="mb-6">
        <h1 className="flex items-center gap-2 text-2xl font-bold">
          <Ticket className="h-6 w-6 text-emerald-600" /> Voucher / คูปอง
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          สร้างโค้ดให้สมาชิกฟรี (ทดลอง X วัน / ฟรี X เดือน) ผู้ใช้กรอกโค้ดที่{" "}
          <span className="font-mono">{siteUrl}/redeem/&lt;โค้ด&gt;</span> แล้วได้สิทธิ์ทันที
        </p>
      </div>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-2 text-sm text-red-700">{error}</div>
      )}

      {/* Stats */}
      <div className="mb-6 grid grid-cols-2 gap-3 sm:grid-cols-5">
        {(Object.keys(DERIVED_LABEL) as Derived[]).map((s) => (
          <button key={s} type="button" onClick={() => setFilter(filter === s ? "all" : s)} className="text-left">
            <Card className={filter === s ? "border-brand shadow-sm" : "hover:shadow-sm"}>
              <CardContent className="pt-5 pb-4">
                <p className="text-2xl font-bold">{counts[s]}</p>
                <p className="text-sm text-muted-foreground">{DERIVED_LABEL[s]}</p>
              </CardContent>
            </Card>
          </button>
        ))}
      </div>

      {/* Create */}
      <Card className="mb-6">
        <CardHeader className="pb-3">
          <CardTitle className="text-base">สร้างโค้ดใหม่</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-5">
            <div>
              <Label htmlFor="c-type">ประเภท</Label>
              <select id="c-type" value={couponType} onChange={(e) => onTypeChange(e.target.value as CouponType)} className={selectCls}>
                {(Object.keys(COUPON_TYPE_LABELS) as CouponType[]).map((t) => (
                  <option key={t} value={t}>{COUPON_TYPE_LABELS[t]}</option>
                ))}
              </select>
            </div>
            <div>
              <Label htmlFor="c-value">{VALUE_LABEL[couponType]}</Label>
              <Input id="c-value" type="number" min={1} value={value} onChange={(e) => setValue(e.target.value)} className="mt-1" />
            </div>
            <div>
              <Label htmlFor="c-plan">
                {couponType.startsWith("free") ? "ให้แพ็ก / รายการ" : "ใช้กับแพ็ก (ว่าง = ทุกแพ็ก)"}
              </Label>
              <select id="c-plan" value={planType} onChange={(e) => setPlanType(e.target.value)} className={selectCls}>
                <option value="">
                  {couponType.startsWith("free") ? "แพ็ก นศพ. (ค่าเริ่มต้น)" : "ทุกแพ็ก"}
                </option>
                {PLAN_TYPES.map((pl) => (
                  <option key={pl} value={pl}>
                    {PLAN_CATALOG[pl].label} — ฿{PLAN_CATALOG[pl].amount.toLocaleString()}
                  </option>
                ))}
                <option value="__item__">รายการเดี่ยว (ระบุ plan string)</option>
              </select>
              {planType === "__item__" && (
                <Input
                  className="mt-1 font-mono text-xs"
                  placeholder="item:board_specialty:internal_medicine:month"
                  value={customPlan}
                  onChange={(e) => setCustomPlan(e.target.value)}
                />
              )}
            </div>
            <div>
              <Label htmlFor="c-platform">แพลตฟอร์ม</Label>
              <select id="c-platform" value={platform} onChange={(e) => setPlatform(e.target.value as CouponPlatform)} className={selectCls}>
                {(Object.keys(PLATFORM_LABEL) as CouponPlatform[]).map((p) => (
                  <option key={p} value={p}>{PLATFORM_LABEL[p]}</option>
                ))}
              </select>
            </div>
            <div>
              <Label htmlFor="c-expires">หมดอายุ</Label>
              <Input id="c-expires" type="datetime-local" value={expiresAt} onChange={(e) => setExpiresAt(e.target.value)} className="mt-1" />
            </div>
          </div>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-4">
            <div>
              <Label htmlFor="c-mode">รูปแบบโค้ด</Label>
              <select id="c-mode" value={mode} onChange={(e) => setMode(e.target.value as "auto" | "custom")} className={selectCls}>
                <option value="auto">สุ่ม MORROO-XXXXXX</option>
                <option value="custom">กำหนดเอง</option>
              </select>
            </div>
            {mode === "custom" ? (
              <div>
                <Label htmlFor="c-code">โค้ด</Label>
                <Input
                  id="c-code"
                  placeholder="เช่น SIRIRAJ2026"
                  value={customCode}
                  onChange={(e) => setCustomCode(e.target.value.toUpperCase())}
                  className="mt-1 font-mono"
                />
              </div>
            ) : (
              <div>
                <Label htmlFor="c-count">จำนวนโค้ด</Label>
                <Input
                  id="c-count"
                  type="number"
                  min={1}
                  max={100}
                  value={count}
                  onChange={(e) => setCount(Math.min(100, Math.max(1, Number(e.target.value) || 1)))}
                  className="mt-1"
                />
              </div>
            )}
            <div>
              <Label htmlFor="c-max">ใช้ได้กี่ครั้ง / โค้ด</Label>
              <Input id="c-max" type="number" min={1} placeholder="ว่าง = ไม่จำกัด" value={maxUses} onChange={(e) => setMaxUses(e.target.value)} className="mt-1" />
            </div>
            <div>
              <Label htmlFor="c-source">แคมเปญ / ที่มา</Label>
              <Input id="c-source" placeholder="เช่น siriraj, fb_ads" value={source} onChange={(e) => setSource(e.target.value)} className="mt-1" />
            </div>
          </div>

          <div className="grid grid-cols-1 gap-4 sm:grid-cols-[1fr_auto] sm:items-end">
            <div>
              <Label htmlFor="c-desc">หมายเหตุ (เห็นเฉพาะ admin)</Label>
              <Input id="c-desc" value={description} onChange={(e) => setDescription(e.target.value)} className="mt-1" />
            </div>
            <Button onClick={create} disabled={creating || (mode === "custom" && !customCode.trim())} className="gap-2">
              {creating ? <Loader2 className="h-4 w-4 animate-spin" /> : <Plus className="h-4 w-4" />}
              สร้าง{mode === "auto" && count > 1 ? ` ${count} โค้ด` : "โค้ด"}
            </Button>
          </div>

          {isDiscount && (
            <p className="rounded-md border border-amber-200 bg-amber-50 px-3 py-2 text-xs text-amber-800">
              โค้ดส่วนลดยังไม่ผูกกับหน้าชำระเงิน — ผู้ใช้กรอกที่ /redeem ไม่ได้ ใช้เป็นโค้ดอ้างอิงตอนตรวจสลิปเท่านั้น
            </p>
          )}

          {justCreated.length > 0 && (
            <div className="rounded-md border border-emerald-200 bg-emerald-50 p-3">
              <div className="mb-2 flex items-center justify-between">
                <p className="text-sm font-semibold text-emerald-800">
                  สร้างแล้ว {justCreated.length} โค้ด · {couponRewardLabel(justCreated[0].coupon_type, justCreated[0].value, justCreated[0].plan_type)}
                </p>
                <Button size="sm" variant="outline" onClick={() => copyText(justCreated.map((c) => `${siteUrl}/redeem/${c.code}`).join("\n"), "__all__")}>
                  {copied === "__all__" ? <Check className="mr-1 h-4 w-4" /> : <Copy className="mr-1 h-4 w-4" />}
                  คัดลอกลิงก์ทั้งหมด
                </Button>
              </div>
              <div className="flex flex-wrap gap-2">
                {justCreated.map((c) => (
                  <button
                    key={c.id}
                    type="button"
                    onClick={() => copyText(c.code, c.code)}
                    className="rounded border border-emerald-300 bg-white px-2 py-1 font-mono text-sm hover:bg-emerald-100"
                    title="คลิกเพื่อคัดลอกโค้ด"
                  >
                    {copied === c.code ? "✓ " : ""}{c.code}
                  </button>
                ))}
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* List */}
      <div className="mb-3 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
        <div className="relative w-full sm:max-w-xs">
          <Search className="pointer-events-none absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input placeholder="ค้นหาโค้ด / แคมเปญ / อีเมลผู้ใช้" value={search} onChange={(e) => setSearch(e.target.value)} className="pl-8" />
        </div>
        <p className="text-sm text-muted-foreground">
          แสดง {visible.length} จาก {items.length} โค้ด
          {filter !== "all" && (
            <button type="button" className="ml-2 underline" onClick={() => setFilter("all")}>ดูทั้งหมด</button>
          )}
        </p>
      </div>

      {visible.length === 0 ? (
        <Card><CardContent className="py-12 text-center text-muted-foreground">ยังไม่มีโค้ด</CardContent></Card>
      ) : (
        <Card>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="border-b bg-muted/40 text-left text-xs uppercase text-muted-foreground">
                <tr>
                  <th className="px-4 py-2">โค้ด</th>
                  <th className="px-4 py-2">สิทธิ์</th>
                  <th className="px-4 py-2">สถานะ</th>
                  <th className="px-4 py-2">ใช้แล้ว</th>
                  <th className="px-4 py-2">หมดอายุ</th>
                  <th className="px-4 py-2">แคมเปญ</th>
                  <th className="px-4 py-2 text-right"></th>
                </tr>
              </thead>
              <tbody>
                {visible.map((c) => {
                  const d = derive(c);
                  const open = expanded === c.id;
                  return (
                    <RowGroup key={c.id}>
                      <tr className="border-b">
                        <td className="px-4 py-2 font-mono">
                          <button type="button" onClick={() => copyText(c.code, c.code)} className="inline-flex items-center gap-1 hover:text-brand" title="คลิกเพื่อคัดลอก">
                            {c.code}
                            {copied === c.code ? <Check className="h-3.5 w-3.5 text-emerald-600" /> : <Copy className="h-3.5 w-3.5 text-muted-foreground" />}
                          </button>
                          {c.description && <p className="mt-0.5 font-sans text-xs text-muted-foreground">{c.description}</p>}
                        </td>
                        <td className="px-4 py-2">
                          {couponRewardLabel(c.coupon_type, c.value, c.plan_type)}
                          {c.platform !== "all" && <Badge variant="outline" className="ml-1">{PLATFORM_LABEL[c.platform]}</Badge>}
                        </td>
                        <td className="px-4 py-2"><Badge className={DERIVED_COLOR[d]}>{DERIVED_LABEL[d]}</Badge></td>
                        <td className="px-4 py-2">
                          <button
                            type="button"
                            className="inline-flex items-center gap-1 hover:text-brand disabled:opacity-60"
                            disabled={c.redemptions.length === 0}
                            onClick={() => setExpanded(open ? null : c.id)}
                          >
                            {c.current_uses ?? 0} / {c.max_uses ?? "∞"}
                            {c.redemptions.length > 0 && (open ? <ChevronUp className="h-3.5 w-3.5" /> : <ChevronDown className="h-3.5 w-3.5" />)}
                          </button>
                        </td>
                        <td className="px-4 py-2 text-muted-foreground">{c.expires_at ? fmtDate(c.expires_at) : "ไม่หมดอายุ"}</td>
                        <td className="px-4 py-2 text-muted-foreground">{c.source ?? "-"}</td>
                        <td className="px-4 py-2 text-right whitespace-nowrap">
                          {c.is_active ? (
                            <Button size="sm" variant="ghost" className="text-amber-700" disabled={busy === c.id} onClick={() => patch(c, { is_active: false })} title="ปิดใช้โค้ด">
                              <Ban className="h-4 w-4" />
                            </Button>
                          ) : (
                            <Button size="sm" variant="ghost" className="text-emerald-700" disabled={busy === c.id} onClick={() => patch(c, { is_active: true })} title="เปิดใช้อีกครั้ง">
                              <RotateCcw className="h-4 w-4" />
                            </Button>
                          )}
                          {c.redemptions.length === 0 && (
                            <Button size="sm" variant="ghost" className="text-red-600" disabled={busy === c.id} onClick={() => remove(c)} title="ลบถาวร">
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          )}
                        </td>
                      </tr>
                      {open && (
                        <tr className="border-b bg-muted/20">
                          <td colSpan={7} className="px-4 py-2">
                            <p className="mb-1 text-xs font-semibold text-muted-foreground">ผู้ใช้โค้ดนี้</p>
                            <ul className="space-y-0.5 text-sm">
                              {c.redemptions.map((r) => (
                                <li key={r.user_id} className="flex flex-wrap gap-x-3">
                                  <Link href={`/admin/students/${r.user_id}`} className="hover:underline">
                                    {r.name ?? r.email ?? r.user_id.slice(0, 8)}
                                  </Link>
                                  {r.email && r.name && <span className="text-muted-foreground">{r.email}</span>}
                                  <span className="text-xs text-muted-foreground">{fmtDate(r.redeemed_at)}</span>
                                </li>
                              ))}
                            </ul>
                          </td>
                        </tr>
                      )}
                    </RowGroup>
                  );
                })}
              </tbody>
            </table>
          </div>
        </Card>
      )}
    </div>
  );
}

// <tbody> children must be <tr>; a fragment keeps the pair together without extra DOM.
function RowGroup({ children }: { children: React.ReactNode }) {
  return <>{children}</>;
}
