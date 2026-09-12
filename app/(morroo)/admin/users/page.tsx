"use client";

import { useState, useEffect, useCallback, useMemo } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  PLAN_CATALOG,
  PLAN_TYPES,
  PRODUCTS,
  PRODUCT_INFO,
  planLabel,
  resolveAccess,
  type EntitlementLike,
  type Product,
} from "@/lib/membership";
import {
  Loader2,
  Shield,
  ArrowLeft,
  Users,
  Crown,
  Search,
  Save,
  UserCheck,
  UserX,
  Plus,
  Ban,
  CalendarClock,
} from "lucide-react";

// NOTE: ต้องมี RLS policies ใน Supabase:
// - "Admins can view all profiles" (SELECT) — auth.uid() in (select id from profiles where role = 'admin')
// - "Admins can update profiles" (UPDATE) — auth.uid() in (select id from profiles where role = 'admin')
// สิทธิ์รายระบบ (school / mcq / meq / longcase / board) เขียนผ่าน /api/admin/membership เท่านั้น

interface Profile {
  id: string;
  email: string;
  name: string;
  role: string;
  membership_type: string;
  membership_expires_at: string | null;
  created_at: string;
}

interface EntitlementRow extends EntitlementLike {
  user_id: string;
  product: string;
  expires_at: string | null;
  source: string | null;
  reference: string | null;
  updated_at: string;
}

type ProductFilter = "all" | "free" | Product;

const PRODUCT_FILTERS: ProductFilter[] = ["all", ...PRODUCTS, "free"];

function fmtDate(iso: string | null | undefined): string {
  if (!iso) return "-";
  return new Date(iso).toLocaleDateString("th-TH");
}

function isActive(row: EntitlementLike | undefined): boolean {
  if (!row) return false;
  if (!row.expires_at) return true;
  return new Date(row.expires_at) > new Date();
}

export default function AdminUsersPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [users, setUsers] = useState<Profile[]>([]);
  const [entitlements, setEntitlements] = useState<Record<string, EntitlementRow[]>>({});
  const [searchQuery, setSearchQuery] = useState("");
  const [productFilter, setProductFilter] = useState<ProductFilter>("all");
  const [savingId, setSavingId] = useState<string | null>(null);
  const [busyKey, setBusyKey] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Role edits (profile column, saved directly via RLS)
  const [roleEdits, setRoleEdits] = useState<Record<string, string>>({});
  // Per-user product editor state
  const [productEdits, setProductEdits] = useState<
    Record<string, { product: Product; expiresAt: string; planType: string }>
  >({});

  const loadUsers = useCallback(async () => {
    const supabase = createClient();
    const [{ data }, entRes] = await Promise.all([
      supabase
        .from("profiles")
        .select("id, email, name, role, membership_type, membership_expires_at, created_at")
        .order("created_at", { ascending: false }),
      fetch("/api/admin/membership").then((r) => (r.ok ? r.json() : { entitlements: {} })),
    ]);

    if (data) {
      setUsers(data);
      const roles: Record<string, string> = {};
      const edits: typeof productEdits = {};
      for (const u of data) {
        roles[u.id] = u.role || "user";
        edits[u.id] = { product: "mcq", expiresAt: "", planType: "monthly" };
      }
      setRoleEdits(roles);
      setProductEdits((prev) => ({ ...edits, ...prev }));
    }
    setEntitlements((entRes?.entitlements ?? {}) as Record<string, EntitlementRow[]>);
  }, []);

  useEffect(() => {
    async function checkAdmin() {
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
      await loadUsers();
      setLoading(false);
    }
    checkAdmin();
  }, [router, loadUsers]);

  // ---- role ----
  const handleSaveRole = async (userId: string) => {
    const role = roleEdits[userId];
    if (!role) return;
    setSavingId(userId);
    const supabase = createClient();
    await supabase.from("profiles").update({ role }).eq("id", userId);
    setUsers((prev) => prev.map((u) => (u.id === userId ? { ...u, role } : u)));
    setSavingId(null);
  };

  // ---- entitlements ----
  const applyMembership = async (
    userId: string,
    key: string,
    body: Record<string, unknown>
  ) => {
    setBusyKey(`${userId}:${key}`);
    setError(null);
    try {
      const res = await fetch("/api/admin/membership", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ userId, ...body }),
      });
      const json = await res.json();
      if (!res.ok) {
        setError(`บันทึกไม่สำเร็จ: ${json.error ?? res.status}`);
        return;
      }
      setEntitlements((prev) => ({ ...prev, [userId]: json.entitlements ?? [] }));
      if (json.profile) {
        setUsers((prev) =>
          prev.map((u) =>
            u.id === userId
              ? {
                  ...u,
                  membership_type: json.profile.membership_type,
                  membership_expires_at: json.profile.membership_expires_at,
                }
              : u
          )
        );
      }
    } catch (e) {
      setError(`บันทึกไม่สำเร็จ: ${e instanceof Error ? e.message : String(e)}`);
    } finally {
      setBusyKey(null);
    }
  };

  const grantDays = (userId: string, product: Product, days: number) =>
    applyMembership(userId, `grant:${product}`, { action: "grant", product, days });

  const revoke = (userId: string, product: Product) => {
    if (!confirm(`ยกเลิกสิทธิ์ ${PRODUCT_INFO[product].label} ของผู้ใช้นี้ทันที?`)) return;
    return applyMembership(userId, `revoke:${product}`, { action: "revoke", product });
  };

  const setExpiry = (userId: string) => {
    const edit = productEdits[userId];
    if (!edit) return;
    const expiresAt = edit.expiresAt
      ? new Date(`${edit.expiresAt}T23:59:59`).toISOString()
      : null; // empty = ไม่มีวันหมดอายุ
    return applyMembership(userId, `set:${edit.product}`, {
      action: "set",
      product: edit.product,
      expiresAt,
    });
  };

  const grantPlan = (userId: string) => {
    const edit = productEdits[userId];
    if (!edit) return;
    return applyMembership(userId, `plan:${edit.planType}`, {
      action: "grant_plan",
      planType: edit.planType,
    });
  };

  const accessOf = useCallback(
    (u: Profile) => resolveAccess(u, entitlements[u.id] ?? []),
    [entitlements]
  );

  // ---- stats ----
  const stats = useMemo(() => {
    const perProduct: Record<Product, number> = { school: 0, mcq: 0, meq: 0, longcase: 0, board: 0 };
    let paid = 0;
    for (const u of users) {
      const a = accessOf(u);
      if (a.anyPaid) paid++;
      for (const p of a.products) perProduct[p]++;
    }
    return { total: users.length, paid, free: users.length - paid, perProduct };
  }, [users, accessOf]);

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
        <p className="text-muted-foreground mt-2">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  // Filter users by search query + product
  const filtered = users.filter((u) => {
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const hit =
        (u.email && u.email.toLowerCase().includes(q)) ||
        (u.name && u.name.toLowerCase().includes(q));
      if (!hit) return false;
    }
    if (productFilter === "all") return true;
    const a = accessOf(u);
    if (productFilter === "free") return !a.anyPaid;
    return a[productFilter];
  });

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <Link
            href="/admin"
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-2"
          >
            <ArrowLeft className="h-4 w-4" /> Admin Dashboard
          </Link>
          <h1 className="text-2xl font-bold">จัดการสมาชิก</h1>
          <p className="text-muted-foreground mt-1">
            สิทธิ์แยกรายระบบ — School · MCQ · MEQ · Long Case · Board — ถือพร้อมกันได้ หมดอายุแยกกัน
          </p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-4">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center">
                <Users className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{stats.total}</p>
                <p className="text-sm text-muted-foreground">สมาชิกทั้งหมด</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-brand/10 flex items-center justify-center">
                <UserCheck className="h-6 w-6 text-brand" />
              </div>
              <div>
                <p className="text-2xl font-bold">{stats.paid}</p>
                <p className="text-sm text-muted-foreground">มีสิทธิ์อย่างน้อย 1 ระบบ</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-gray-100 flex items-center justify-center">
                <UserX className="h-6 w-6 text-gray-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{stats.free}</p>
                <p className="text-sm text-muted-foreground">สมาชิกฟรี</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Per-product counts */}
      <div className="grid grid-cols-2 sm:grid-cols-5 gap-3 mb-8">
        {PRODUCTS.map((p) => (
          <Card key={p} className="py-0">
            <CardContent className="py-3">
              <p className="text-xl font-bold">{stats.perProduct[p]}</p>
              <Badge className={`text-xs ${PRODUCT_INFO[p].color}`}>{PRODUCT_INFO[p].label}</Badge>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Search + filter */}
      <div className="flex flex-col sm:flex-row gap-3 mb-6">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="ค้นหาด้วยอีเมลหรือชื่อ..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10"
          />
        </div>
        <select
          className="rounded-md border px-3 py-2 text-sm"
          value={productFilter}
          onChange={(e) => setProductFilter(e.target.value as ProductFilter)}
          aria-label="กรองตามระบบ"
        >
          {PRODUCT_FILTERS.map((f) => (
            <option key={f} value={f}>
              {f === "all" ? "ทุกระบบ" : f === "free" ? "ฟรี (ไม่มีสิทธิ์)" : `มีสิทธิ์ ${PRODUCT_INFO[f].label}`}
            </option>
          ))}
        </select>
      </div>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-2 text-sm text-red-700">
          {error}
        </div>
      )}

      {/* Users List */}
      {filtered.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <p className="text-muted-foreground">
              {searchQuery || productFilter !== "all" ? "ไม่พบสมาชิกที่ตรงกับเงื่อนไข" : "ยังไม่มีสมาชิก"}
            </p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {filtered.map((user) => {
            const rows = entitlements[user.id] ?? [];
            const byProduct = new Map(rows.map((r) => [r.product, r]));
            const access = accessOf(user);
            const edit = productEdits[user.id] ?? { product: "mcq" as Product, expiresAt: "", planType: "monthly" };
            const roleChanged = (roleEdits[user.id] ?? "user") !== (user.role || "user");

            return (
              <Card key={user.id}>
                <CardContent className="py-4">
                  <div className="flex flex-col gap-4">
                    {/* User info row */}
                    <div className="flex items-start justify-between flex-wrap gap-2">
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 flex-wrap mb-1">
                          <h3 className="font-semibold truncate">
                            {user.name || "(ไม่มีชื่อ)"}
                          </h3>
                          {user.role === "admin" && (
                            <Badge className="bg-red-100 text-red-700 text-xs">
                              <Crown className="h-3 w-3 mr-1" />
                              แอดมิน
                            </Badge>
                          )}
                          {!access.anyPaid && (
                            <Badge className="bg-gray-100 text-gray-700 text-xs">ฟรี</Badge>
                          )}
                        </div>
                        <p className="text-sm text-muted-foreground">{user.email}</p>
                        <div className="flex items-center gap-4 mt-1 text-xs text-muted-foreground flex-wrap">
                          <span>สมัคร: {fmtDate(user.created_at)}</span>
                          <span>
                            แพ็กหลัก: {planLabel(user.membership_type)}
                            {user.membership_expires_at && ` (ถึง ${fmtDate(user.membership_expires_at)})`}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Product entitlements */}
                    <div className="grid grid-cols-1 sm:grid-cols-5 gap-2">
                      {PRODUCTS.map((p) => {
                        const row = byProduct.get(p);
                        const active = isActive(row);
                        const busy = busyKey === `${user.id}:grant:${p}` || busyKey === `${user.id}:revoke:${p}`;
                        return (
                          <div
                            key={p}
                            className={`rounded-lg border p-2 text-xs ${
                              active ? "border-brand/40 bg-brand/5" : "border-dashed"
                            }`}
                          >
                            <div className="flex items-center justify-between gap-1">
                              <Badge className={`text-[10px] ${active ? PRODUCT_INFO[p].color : "bg-gray-100 text-gray-500"}`}>
                                {PRODUCT_INFO[p].short}
                              </Badge>
                              {busy && <Loader2 className="h-3 w-3 animate-spin" />}
                            </div>
                            <p className="mt-1 text-muted-foreground">
                              {active
                                ? row?.expires_at
                                  ? `ถึง ${fmtDate(row.expires_at)}`
                                  : "ไม่มีวันหมดอายุ"
                                : row
                                  ? `หมดอายุ ${fmtDate(row.expires_at)}`
                                  : "ไม่มีสิทธิ์"}
                            </p>
                            {row?.source && (
                              <p className="text-[10px] text-muted-foreground/70">{row.source}</p>
                            )}
                            <div className="mt-1 flex gap-1">
                              <button
                                type="button"
                                className="inline-flex items-center gap-0.5 rounded border px-1.5 py-0.5 hover:bg-muted disabled:opacity-50"
                                disabled={!!busyKey}
                                onClick={() => grantDays(user.id, p, 30)}
                                title="+30 วัน (ต่อจากวันหมดอายุเดิม)"
                              >
                                <Plus className="h-3 w-3" />30d
                              </button>
                              <button
                                type="button"
                                className="inline-flex items-center gap-0.5 rounded border px-1.5 py-0.5 hover:bg-muted disabled:opacity-50"
                                disabled={!!busyKey}
                                onClick={() => grantDays(user.id, p, 365)}
                                title="+365 วัน"
                              >
                                <Plus className="h-3 w-3" />1y
                              </button>
                              {active && (
                                <button
                                  type="button"
                                  className="inline-flex items-center gap-0.5 rounded border border-red-200 px-1.5 py-0.5 text-red-600 hover:bg-red-50 disabled:opacity-50"
                                  disabled={!!busyKey}
                                  onClick={() => revoke(user.id, p)}
                                  title="ยกเลิกสิทธิ์ทันที"
                                >
                                  <Ban className="h-3 w-3" />
                                </button>
                              )}
                            </div>
                          </div>
                        );
                      })}
                    </div>

                    {/* Edit controls row */}
                    <div className="flex items-end gap-3 flex-wrap">
                      <div className="min-w-[130px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          ตั้งวันหมดอายุ (ระบบ)
                        </label>
                        <select
                          className="w-full rounded-md border px-3 py-2 text-sm"
                          value={edit.product}
                          onChange={(e) =>
                            setProductEdits((prev) => ({
                              ...prev,
                              [user.id]: { ...edit, product: e.target.value as Product },
                            }))
                          }
                        >
                          {PRODUCTS.map((p) => (
                            <option key={p} value={p}>
                              {PRODUCT_INFO[p].label}
                            </option>
                          ))}
                        </select>
                      </div>
                      <div className="min-w-[160px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          วันหมดอายุ (ว่าง = ไม่หมดอายุ)
                        </label>
                        <Input
                          type="date"
                          value={edit.expiresAt}
                          onChange={(e) =>
                            setProductEdits((prev) => ({
                              ...prev,
                              [user.id]: { ...edit, expiresAt: e.target.value },
                            }))
                          }
                        />
                      </div>
                      <Button
                        variant="outline"
                        size="sm"
                        className="gap-1"
                        disabled={!!busyKey}
                        onClick={() => setExpiry(user.id)}
                      >
                        {busyKey === `${user.id}:set:${edit.product}` ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <CalendarClock className="h-4 w-4" />
                        )}
                        ตั้งวันหมดอายุ
                      </Button>

                      <div className="min-w-[170px]">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          ให้แพ็ก (เหมือนซื้อ)
                        </label>
                        <select
                          className="w-full rounded-md border px-3 py-2 text-sm"
                          value={edit.planType}
                          onChange={(e) =>
                            setProductEdits((prev) => ({
                              ...prev,
                              [user.id]: { ...edit, planType: e.target.value },
                            }))
                          }
                        >
                          {PLAN_TYPES.map((plan) => (
                            <option key={plan} value={plan}>
                              {PLAN_CATALOG[plan].label} — ฿{PLAN_CATALOG[plan].amount.toLocaleString()}
                            </option>
                          ))}
                        </select>
                      </div>
                      <Button
                        className="bg-brand hover:bg-brand-light text-white gap-1"
                        size="sm"
                        disabled={!!busyKey}
                        onClick={() => grantPlan(user.id)}
                      >
                        {busyKey === `${user.id}:plan:${edit.planType}` ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Plus className="h-4 w-4" />
                        )}
                        ให้แพ็ก
                      </Button>

                      <div className="min-w-[110px] ml-auto">
                        <label className="text-xs text-muted-foreground mb-1 block">
                          สิทธิ์ระบบ
                        </label>
                        <select
                          className="w-full rounded-md border px-3 py-2 text-sm"
                          value={roleEdits[user.id] ?? "user"}
                          onChange={(e) =>
                            setRoleEdits((prev) => ({ ...prev, [user.id]: e.target.value }))
                          }
                        >
                          <option value="user">user</option>
                          <option value="admin">admin</option>
                        </select>
                      </div>
                      <Button
                        variant="outline"
                        size="sm"
                        className="gap-1"
                        disabled={!roleChanged || savingId === user.id}
                        onClick={() => handleSaveRole(user.id)}
                      >
                        {savingId === user.id ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Save className="h-4 w-4" />
                        )}
                        บันทึก role
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
