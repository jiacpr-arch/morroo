"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  Loader2,
  Shield,
  Plus,
  Tag,
  Copy,
  CheckCheck,
} from "lucide-react";

type Coupon = {
  id: string;
  code: string;
  description: string | null;
  discount_type: "percent" | "fixed";
  discount_value: number;
  max_uses: number | null;
  uses_count: number;
  applicable_plans: string[] | null;
  valid_from: string;
  valid_until: string | null;
  is_active: boolean;
  created_at: string;
};

const PLAN_LABEL: Record<string, string> = {
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "Bundle",
};

export default function CouponsAdmin() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [coupons, setCoupons] = useState<Coupon[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);
  const [copiedId, setCopiedId] = useState<string | null>(null);

  const [form, setForm] = useState({
    code: "",
    description: "",
    discount_type: "percent" as "percent" | "fixed",
    discount_value: "",
    max_uses: "",
    applicable_plans: [] as string[],
    valid_from: new Date().toISOString().slice(0, 16),
    valid_until: "",
  });

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

    const { data } = await supabase
      .from("coupons")
      .select("*")
      .order("created_at", { ascending: false });
    setCoupons((data as Coupon[]) ?? []);
    setLoading(false);
  }, [router]);

  useEffect(() => {
    load();
  }, [load]);

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const supabase = createClient();

    const { error } = await supabase.from("coupons").insert({
      code: form.code.trim().toUpperCase(),
      description: form.description || null,
      discount_type: form.discount_type,
      discount_value: parseFloat(form.discount_value),
      max_uses: form.max_uses ? parseInt(form.max_uses) : null,
      applicable_plans: form.applicable_plans.length > 0 ? form.applicable_plans : null,
      valid_from: new Date(form.valid_from).toISOString(),
      valid_until: form.valid_until ? new Date(form.valid_until).toISOString() : null,
      is_active: true,
    });

    if (error) {
      alert(`เกิดข้อผิดพลาด: ${error.message}`);
    } else {
      setShowForm(false);
      setForm({
        code: "",
        description: "",
        discount_type: "percent",
        discount_value: "",
        max_uses: "",
        applicable_plans: [],
        valid_from: new Date().toISOString().slice(0, 16),
        valid_until: "",
      });
      await load();
    }
    setSaving(false);
  }

  async function toggleActive(id: string, current: boolean) {
    const supabase = createClient();
    await supabase.from("coupons").update({ is_active: !current }).eq("id", id);
    await load();
  }

  function copyCode(code: string, id: string) {
    navigator.clipboard.writeText(code);
    setCopiedId(id);
    setTimeout(() => setCopiedId(null), 2000);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen gap-4">
        <Shield className="h-12 w-12 text-red-500" />
        <p className="text-lg font-medium">ไม่มีสิทธิ์เข้าถึง</p>
        <Button variant="outline" onClick={() => router.push("/")}>
          กลับหน้าหลัก
        </Button>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Link href="/admin">
            <Button variant="ghost" size="sm">
              <ArrowLeft className="h-4 w-4 mr-1" />
              Admin
            </Button>
          </Link>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Tag className="h-6 w-6 text-orange-600" />
            Coupons
          </h1>
        </div>
        <Button onClick={() => setShowForm(!showForm)}>
          <Plus className="h-4 w-4 mr-1" />
          สร้างโค้ดใหม่
        </Button>
      </div>

      {/* Create form */}
      {showForm && (
        <Card className="border-orange-200">
          <CardHeader>
            <CardTitle className="text-base">สร้างโค้ดส่วนลด</CardTitle>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleCreate} className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-1">
                <label className="text-sm font-medium">โค้ด *</label>
                <Input
                  placeholder="SAVE20"
                  value={form.code}
                  onChange={(e) => setForm((f) => ({ ...f, code: e.target.value.toUpperCase() }))}
                  required
                />
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">คำอธิบาย</label>
                <Input
                  placeholder="ลด 20% สำหรับนักศึกษา"
                  value={form.description}
                  onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                />
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">ประเภทส่วนลด *</label>
                <select
                  className="w-full border rounded-md px-3 py-2 text-sm bg-white"
                  value={form.discount_type}
                  onChange={(e) =>
                    setForm((f) => ({
                      ...f,
                      discount_type: e.target.value as "percent" | "fixed",
                    }))
                  }
                >
                  <option value="percent">เปอร์เซ็นต์ (%)</option>
                  <option value="fixed">จำนวนเงิน (THB)</option>
                </select>
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">
                  ค่าส่วนลด * {form.discount_type === "percent" ? "(0–100)" : "(THB)"}
                </label>
                <Input
                  type="number"
                  min="0"
                  max={form.discount_type === "percent" ? "100" : undefined}
                  step="0.01"
                  placeholder={form.discount_type === "percent" ? "20" : "200"}
                  value={form.discount_value}
                  onChange={(e) => setForm((f) => ({ ...f, discount_value: e.target.value }))}
                  required
                />
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">จำนวนใช้สูงสุด (ว่าง = ไม่จำกัด)</label>
                <Input
                  type="number"
                  min="1"
                  placeholder="100"
                  value={form.max_uses}
                  onChange={(e) => setForm((f) => ({ ...f, max_uses: e.target.value }))}
                />
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">แพ็กเกจที่ใช้ได้ (ว่าง = ทุกแพ็กเกจ)</label>
                <div className="flex gap-2 flex-wrap">
                  {["monthly", "yearly", "bundle"].map((plan) => (
                    <label key={plan} className="flex items-center gap-1 text-sm cursor-pointer">
                      <input
                        type="checkbox"
                        checked={form.applicable_plans.includes(plan)}
                        onChange={(e) =>
                          setForm((f) => ({
                            ...f,
                            applicable_plans: e.target.checked
                              ? [...f.applicable_plans, plan]
                              : f.applicable_plans.filter((p) => p !== plan),
                          }))
                        }
                      />
                      {PLAN_LABEL[plan]}
                    </label>
                  ))}
                </div>
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">เริ่มใช้ได้</label>
                <Input
                  type="datetime-local"
                  value={form.valid_from}
                  onChange={(e) => setForm((f) => ({ ...f, valid_from: e.target.value }))}
                />
              </div>
              <div className="space-y-1">
                <label className="text-sm font-medium">หมดอายุ (ว่าง = ไม่จำกัด)</label>
                <Input
                  type="datetime-local"
                  value={form.valid_until}
                  onChange={(e) => setForm((f) => ({ ...f, valid_until: e.target.value }))}
                />
              </div>
              <div className="sm:col-span-2 flex gap-2 justify-end">
                <Button type="button" variant="outline" onClick={() => setShowForm(false)}>
                  ยกเลิก
                </Button>
                <Button type="submit" disabled={saving}>
                  {saving ? <Loader2 className="h-4 w-4 animate-spin mr-1" /> : null}
                  สร้างโค้ด
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>
      )}

      {/* Coupon list */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">โค้ดส่วนลดทั้งหมด ({coupons.length})</CardTitle>
        </CardHeader>
        <CardContent>
          {coupons.length === 0 ? (
            <p className="text-muted-foreground text-sm text-center py-8">
              ยังไม่มีโค้ดส่วนลด กดสร้างโค้ดใหม่ด้านบน
            </p>
          ) : (
            <div className="space-y-3">
              {coupons.map((c) => {
                const isExpired = c.valid_until && new Date(c.valid_until) < new Date();
                const isMaxed = c.max_uses !== null && c.uses_count >= c.max_uses;
                return (
                  <div
                    key={c.id}
                    className={`flex items-start justify-between p-3 border rounded-lg ${
                      !c.is_active || isExpired || isMaxed ? "opacity-60 bg-gray-50" : "bg-white"
                    }`}
                  >
                    <div className="space-y-1">
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => copyCode(c.code, c.id)}
                          className="font-mono font-bold text-lg hover:text-brand transition-colors flex items-center gap-1"
                        >
                          {c.code}
                          {copiedId === c.id ? (
                            <CheckCheck className="h-4 w-4 text-green-500" />
                          ) : (
                            <Copy className="h-4 w-4 text-muted-foreground" />
                          )}
                        </button>
                        <Badge variant={c.is_active && !isExpired && !isMaxed ? "default" : "secondary"}>
                          {!c.is_active ? "ปิด" : isExpired ? "หมดอายุ" : isMaxed ? "ใช้ครบ" : "ใช้งาน"}
                        </Badge>
                      </div>
                      {c.description && (
                        <p className="text-sm text-muted-foreground">{c.description}</p>
                      )}
                      <div className="flex flex-wrap gap-x-4 gap-y-1 text-xs text-muted-foreground">
                        <span>
                          ส่วนลด:{" "}
                          <strong>
                            {c.discount_type === "percent"
                              ? `${c.discount_value}%`
                              : `฿${c.discount_value.toLocaleString()}`}
                          </strong>
                        </span>
                        <span>
                          ใช้แล้ว: <strong>{c.uses_count}</strong>
                          {c.max_uses ? ` / ${c.max_uses}` : " (ไม่จำกัด)"}
                        </span>
                        {c.applicable_plans && c.applicable_plans.length > 0 && (
                          <span>
                            แพ็กเกจ:{" "}
                            {c.applicable_plans.map((p) => PLAN_LABEL[p] ?? p).join(", ")}
                          </span>
                        )}
                        {c.valid_until && (
                          <span>
                            หมดอายุ:{" "}
                            {new Date(c.valid_until).toLocaleDateString("th-TH")}
                          </span>
                        )}
                      </div>
                    </div>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => toggleActive(c.id, c.is_active)}
                    >
                      {c.is_active ? "ปิด" : "เปิด"}
                    </Button>
                  </div>
                );
              })}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
