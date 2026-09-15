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
import {
  Ban,
  Check,
  ChevronLeft,
  Copy,
  Loader2,
  Plus,
  RotateCcw,
  Search,
  Shield,
  Ticket,
  Trash2,
} from "lucide-react";

type VoucherStatus = "active" | "redeemed" | "void";

interface Voucher {
  code: string;
  chapter: number;
  status: VoucherStatus;
  price_thb: number | null;
  redeemed_by: string | null;
  redeemed_at: string | null;
  created_by: string | null;
  created_at: string;
  redeemer: { display_name: string | null; email: string | null } | null;
}

// Mirrors lib/firstaid/content/lessons.js chapters + COURSE_BUNDLE_CHAPTER (0).
const CHAPTER_LABEL: Record<number, string> = {
  0: "ทั้งคอร์ส (bundle)",
  1: "หมวด 1 · ความรู้พื้นฐาน (ฟรี)",
  2: "หมวด 2 · เจ็บป่วยฉุกเฉิน",
  3: "หมวด 3 · บาดเจ็บฉุกเฉิน",
  4: "หมวด 4 · อุบัติเหตุรอบตัวและสารเคมี",
};
// Default price per lib/firstaid/config/pricing.js
const DEFAULT_PRICE: Record<number, number | ""> = {
  0: 249,
  1: "",
  2: 99,
  3: 99,
  4: 99,
};

const STATUS_LABEL: Record<VoucherStatus, string> = {
  active: "ยังไม่ใช้",
  redeemed: "ใช้แล้ว",
  void: "ยกเลิก",
};
const STATUS_COLOR: Record<VoucherStatus, string> = {
  active: "bg-emerald-100 text-emerald-700",
  redeemed: "bg-blue-100 text-blue-700",
  void: "bg-gray-200 text-gray-600",
};

function fmtDate(iso: string | null) {
  if (!iso) return "-";
  return new Date(iso).toLocaleString("th-TH", {
    dateStyle: "short",
    timeStyle: "short",
  });
}

export default function AdminFirstAidVouchersPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [items, setItems] = useState<Voucher[]>([]);
  const [counts, setCounts] = useState<Record<VoucherStatus, number>>({
    active: 0,
    redeemed: 0,
    void: 0,
  });
  const [filter, setFilter] = useState<VoucherStatus | "all">("all");
  const [search, setSearch] = useState("");
  const [busy, setBusy] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Create form
  const [chapter, setChapter] = useState<number>(0);
  const [count, setCount] = useState<number>(5);
  const [price, setPrice] = useState<string>(String(DEFAULT_PRICE[0]));
  const [creating, setCreating] = useState(false);
  const [justCreated, setJustCreated] = useState<Voucher[]>([]);
  const [copied, setCopied] = useState<string | null>(null);

  const load = useCallback(async (status: VoucherStatus | "all") => {
    const qs = status === "all" ? "" : `?status=${status}`;
    const res = await fetch(`/api/admin/firstaid/vouchers${qs}`);
    if (!res.ok) {
      setError("โหลดรายการไม่สำเร็จ");
      return;
    }
    const json = await res.json();
    setItems(json.items ?? []);
    setCounts(json.counts ?? { active: 0, redeemed: 0, void: 0 });
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login?next=/admin/firstaid/vouchers");
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
      await load("all");
      setLoading(false);
    }
    init();
  }, [router, load]);

  useEffect(() => {
    if (isAdmin) load(filter);
  }, [filter, isAdmin, load]);

  const visible = useMemo(() => {
    const q = search.trim().toUpperCase();
    if (!q) return items;
    return items.filter(
      (v) =>
        v.code.includes(q) ||
        (v.redeemer?.display_name ?? "").toUpperCase().includes(q) ||
        (v.redeemer?.email ?? "").toUpperCase().includes(q),
    );
  }, [items, search]);

  function onChapterChange(next: number) {
    setChapter(next);
    setPrice(String(DEFAULT_PRICE[next] ?? ""));
  }

  async function create() {
    setCreating(true);
    setError(null);
    try {
      const res = await fetch("/api/admin/firstaid/vouchers", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          chapter,
          count,
          price_thb: price.trim() === "" ? null : Number(price),
        }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(json.error ?? "สร้างโค้ดไม่สำเร็จ");
        return;
      }
      setJustCreated(json.items ?? []);
      await load(filter);
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
      // clipboard unavailable (non-secure context) — user can select manually
    }
  }

  async function setStatus(v: Voucher, status: "void" | "active") {
    if (
      status === "void" &&
      !confirm(`ยกเลิกโค้ด ${v.code}? ผู้เรียนจะใช้โค้ดนี้ไม่ได้อีก`)
    )
      return;
    setBusy(v.code);
    setError(null);
    const res = await fetch(
      `/api/admin/firstaid/vouchers/${encodeURIComponent(v.code)}`,
      {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status }),
      },
    );
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      setError(json.error ?? "อัปเดตไม่สำเร็จ");
    }
    await load(filter);
    setBusy(null);
  }

  async function remove(v: Voucher) {
    if (!confirm(`ลบโค้ด ${v.code} ถาวร?`)) return;
    setBusy(v.code);
    setError(null);
    const res = await fetch(
      `/api/admin/firstaid/vouchers/${encodeURIComponent(v.code)}`,
      { method: "DELETE" },
    );
    if (!res.ok) {
      const json = await res.json().catch(() => ({}));
      setError(json.error ?? "ลบไม่สำเร็จ");
    }
    setJustCreated((list) => list.filter((x) => x.code !== v.code));
    await load(filter);
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
        <p className="mt-2 text-muted-foreground">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  const createdText = justCreated.map((v) => v.code).join("\n");

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <Link
        href="/admin"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับ Dashboard
      </Link>

      <div className="mb-6">
        <h1 className="flex items-center gap-2 text-2xl font-bold">
          <Ticket className="h-6 w-6 text-emerald-600" /> Voucher คอร์สปฐมพยาบาล
        </h1>
        <p className="mt-1 text-sm text-muted-foreground">
          สร้างโค้ดปลดล็อกบทเรียน firstaid.morroo.com — ลูกค้าจ่าย PromptPay/LINE
          แล้วนำโค้ดไปกรอกในแอป (ใช้ได้ครั้งเดียวต่อโค้ด)
        </p>
      </div>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-2 text-sm text-red-700">
          {error}
        </div>
      )}

      {/* Stats */}
      <div className="mb-6 grid grid-cols-3 gap-3">
        {(["active", "redeemed", "void"] as VoucherStatus[]).map((s) => (
          <button
            key={s}
            type="button"
            onClick={() => setFilter(filter === s ? "all" : s)}
            className="text-left"
          >
            <Card
              className={
                filter === s ? "border-brand shadow-sm" : "hover:shadow-sm"
              }
            >
              <CardContent className="pt-5 pb-4">
                <p className="text-2xl font-bold">{counts[s]}</p>
                <p className="text-sm text-muted-foreground">
                  {STATUS_LABEL[s]}
                </p>
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
        <CardContent>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-[1fr_120px_140px_auto] sm:items-end">
            <div>
              <Label htmlFor="v-chapter">ปลดล็อก</Label>
              <select
                id="v-chapter"
                value={chapter}
                onChange={(e) => onChapterChange(Number(e.target.value))}
                className="mt-1 flex h-9 w-full rounded-md border border-input bg-background px-3 py-1 text-sm shadow-sm focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
              >
                {[0, 2, 3, 4, 1].map((c) => (
                  <option key={c} value={c}>
                    {CHAPTER_LABEL[c]}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <Label htmlFor="v-count">จำนวน</Label>
              <Input
                id="v-count"
                type="number"
                min={1}
                max={100}
                value={count}
                onChange={(e) =>
                  setCount(
                    Math.min(100, Math.max(1, Number(e.target.value) || 1)),
                  )
                }
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="v-price">ราคา (฿)</Label>
              <Input
                id="v-price"
                type="number"
                min={0}
                placeholder="ไม่ระบุ"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                className="mt-1"
              />
            </div>
            <Button onClick={create} disabled={creating} className="gap-2">
              {creating ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Plus className="h-4 w-4" />
              )}
              สร้าง {count} โค้ด
            </Button>
          </div>

          {justCreated.length > 0 && (
            <div className="mt-4 rounded-md border border-emerald-200 bg-emerald-50 p-3">
              <div className="mb-2 flex items-center justify-between">
                <p className="text-sm font-semibold text-emerald-800">
                  สร้างแล้ว {justCreated.length} โค้ด ·{" "}
                  {CHAPTER_LABEL[justCreated[0].chapter]}
                </p>
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => copyText(createdText, "__all__")}
                >
                  {copied === "__all__" ? (
                    <Check className="mr-1 h-4 w-4" />
                  ) : (
                    <Copy className="mr-1 h-4 w-4" />
                  )}
                  คัดลอกทั้งหมด
                </Button>
              </div>
              <div className="flex flex-wrap gap-2">
                {justCreated.map((v) => (
                  <button
                    key={v.code}
                    type="button"
                    onClick={() => copyText(v.code, v.code)}
                    className="rounded border border-emerald-300 bg-white px-2 py-1 font-mono text-sm hover:bg-emerald-100"
                    title="คลิกเพื่อคัดลอก"
                  >
                    {copied === v.code ? "✓ " : ""}
                    {v.code}
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
          <Input
            placeholder="ค้นหาโค้ด / ชื่อผู้ใช้"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-8"
          />
        </div>
        <p className="text-sm text-muted-foreground">
          แสดง {visible.length} รายการ
          {filter !== "all" && ` (${STATUS_LABEL[filter]})`}
          {filter !== "all" && (
            <button
              type="button"
              className="ml-2 underline"
              onClick={() => setFilter("all")}
            >
              ดูทั้งหมด
            </button>
          )}
        </p>
      </div>

      {visible.length === 0 ? (
        <Card>
          <CardContent className="py-12 text-center text-muted-foreground">
            ยังไม่มีโค้ด
          </CardContent>
        </Card>
      ) : (
        <Card>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead className="border-b bg-muted/40 text-left text-xs uppercase text-muted-foreground">
                <tr>
                  <th className="px-4 py-2">โค้ด</th>
                  <th className="px-4 py-2">ปลดล็อก</th>
                  <th className="px-4 py-2">ราคา</th>
                  <th className="px-4 py-2">สถานะ</th>
                  <th className="px-4 py-2">ผู้ใช้ / เวลาใช้</th>
                  <th className="px-4 py-2">สร้างเมื่อ</th>
                  <th className="px-4 py-2 text-right"></th>
                </tr>
              </thead>
              <tbody>
                {visible.map((v) => (
                  <tr key={v.code} className="border-b last:border-0">
                    <td className="px-4 py-2 font-mono">
                      <button
                        type="button"
                        onClick={() => copyText(v.code, v.code)}
                        className="inline-flex items-center gap-1 hover:text-brand"
                        title="คลิกเพื่อคัดลอก"
                      >
                        {v.code}
                        {copied === v.code ? (
                          <Check className="h-3.5 w-3.5 text-emerald-600" />
                        ) : (
                          <Copy className="h-3.5 w-3.5 text-muted-foreground" />
                        )}
                      </button>
                    </td>
                    <td className="px-4 py-2">
                      {v.chapter === 0 ? (
                        <Badge className="bg-amber-100 text-amber-800">
                          ทั้งคอร์ส
                        </Badge>
                      ) : (
                        `หมวด ${v.chapter}`
                      )}
                    </td>
                    <td className="px-4 py-2">
                      {v.price_thb != null ? `฿${v.price_thb}` : "-"}
                    </td>
                    <td className="px-4 py-2">
                      <Badge className={STATUS_COLOR[v.status]}>
                        {STATUS_LABEL[v.status]}
                      </Badge>
                    </td>
                    <td className="px-4 py-2">
                      {v.status === "redeemed" ? (
                        <div>
                          <p>
                            {v.redeemer?.display_name ??
                              v.redeemer?.email ??
                              v.redeemed_by?.slice(0, 8)}
                          </p>
                          <p className="text-xs text-muted-foreground">
                            {fmtDate(v.redeemed_at)}
                          </p>
                        </div>
                      ) : (
                        <span className="text-muted-foreground">-</span>
                      )}
                    </td>
                    <td className="px-4 py-2 text-muted-foreground">
                      {fmtDate(v.created_at)}
                    </td>
                    <td className="px-4 py-2 text-right whitespace-nowrap">
                      {v.status === "active" && (
                        <Button
                          size="sm"
                          variant="ghost"
                          className="text-amber-700"
                          disabled={busy === v.code}
                          onClick={() => setStatus(v, "void")}
                          title="ยกเลิกโค้ด"
                        >
                          <Ban className="h-4 w-4" />
                        </Button>
                      )}
                      {v.status === "void" && (
                        <>
                          <Button
                            size="sm"
                            variant="ghost"
                            className="text-emerald-700"
                            disabled={busy === v.code}
                            onClick={() => setStatus(v, "active")}
                            title="เปิดใช้อีกครั้ง"
                          >
                            <RotateCcw className="h-4 w-4" />
                          </Button>
                          <Button
                            size="sm"
                            variant="ghost"
                            className="text-red-600"
                            disabled={busy === v.code}
                            onClick={() => remove(v)}
                            title="ลบถาวร"
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Card>
      )}
    </div>
  );
}
