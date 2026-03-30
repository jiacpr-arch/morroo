"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  Ticket,
  Plus,
  Loader2,
  Shield,
  Copy,
  ToggleLeft,
  ToggleRight,
} from "lucide-react";
import { COUPON_TYPE_LABELS, type CouponCode } from "@/lib/types-standard";

function generateCode(prefix: string, length = 6): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let result = prefix ? prefix + "-" : "";
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

export default function AdminCouponsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [coupons, setCoupons] = useState<CouponCode[]>([]);
  const [showForm, setShowForm] = useState(false);
  const [saving, setSaving] = useState(false);

  // Form state
  const [form, setForm] = useState({
    code: "",
    description: "",
    coupon_type: "free_trial" as CouponCode["coupon_type"],
    value: 20,
    platform: "all" as CouponCode["platform"],
    max_uses: "",
    expires_days: "30",
    source: "",
    bulk_count: "",
    bulk_prefix: "",
  });

  const supabase = createClient();

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      const { data } = await supabase
        .from("coupon_codes").select("*").order("created_at", { ascending: false });
      setCoupons((data as CouponCode[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  const handleCreate = async () => {
    setSaving(true);
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;

    const bulkCount = parseInt(form.bulk_count) || 0;
    const maxUses = form.max_uses ? parseInt(form.max_uses) : null;
    const expiresAt = form.expires_days
      ? new Date(Date.now() + parseInt(form.expires_days) * 86400000).toISOString()
      : null;

    const couponsToCreate = [];

    if (bulkCount > 0) {
      for (let i = 0; i < bulkCount; i++) {
        couponsToCreate.push({
          code: generateCode(form.bulk_prefix || "BULK", 8),
          description: form.description || null,
          coupon_type: form.coupon_type,
          value: form.value,
          platform: form.platform,
          max_uses: 1,
          max_uses_per_user: 1,
          current_uses: 0,
          expires_at: expiresAt,
          source: form.source || null,
          is_active: true,
          created_by: user.id,
        });
      }
    } else {
      couponsToCreate.push({
        code: form.code.toUpperCase().trim() || generateCode("MORROO"),
        description: form.description || null,
        coupon_type: form.coupon_type,
        value: form.value,
        platform: form.platform,
        max_uses: maxUses,
        max_uses_per_user: 1,
        current_uses: 0,
        expires_at: expiresAt,
        source: form.source || null,
        is_active: true,
        created_by: user.id,
      });
    }

    const { data, error } = await supabase
      .from("coupon_codes")
      .insert(couponsToCreate)
      .select();

    if (!error && data) {
      setCoupons([...(data as CouponCode[]), ...coupons]);
      setShowForm(false);
      setForm({
        code: "", description: "", coupon_type: "free_trial", value: 20,
        platform: "all", max_uses: "", expires_days: "30", source: "",
        bulk_count: "", bulk_prefix: "",
      });
    }
    setSaving(false);
  };

  const toggleCoupon = async (coupon: CouponCode) => {
    const { error } = await supabase
      .from("coupon_codes")
      .update({ is_active: !coupon.is_active })
      .eq("id", coupon.id);

    if (!error) {
      setCoupons(coupons.map((c) =>
        c.id === coupon.id ? { ...c, is_active: !c.is_active } : c
      ));
    }
  };

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

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold">จัดการคูปอง</h1>
          <p className="text-muted-foreground mt-1">
            สร้างและจัดการโค้ดคูปองสำหรับโปรโมชั่น
          </p>
        </div>
        <Button
          onClick={() => setShowForm(!showForm)}
          className="bg-brand hover:bg-brand-light text-white gap-2"
        >
          <Plus className="h-4 w-4" /> สร้างคูปอง
        </Button>
      </div>

      {/* Create form */}
      {showForm && (
        <Card className="mb-8">
          <CardHeader>
            <h3 className="font-bold">สร้างคูปองใหม่</h3>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium">โค้ด (เว้นว่างเพื่อสุ่ม)</label>
                <Input
                  placeholder="BOOTH-EMS2026"
                  value={form.code}
                  onChange={(e) => setForm({ ...form, code: e.target.value })}
                  className="uppercase"
                />
              </div>
              <div>
                <label className="text-sm font-medium">ประเภท</label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.coupon_type}
                  onChange={(e) =>
                    setForm({ ...form, coupon_type: e.target.value as CouponCode["coupon_type"] })
                  }
                >
                  <option value="free_trial">ทดลองฟรี (จำนวนข้อ)</option>
                  <option value="discount_percent">ลดเป็น %</option>
                  <option value="discount_fixed">ลดเป็นบาท</option>
                  <option value="free_month">ฟรี X เดือน</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">มูลค่า</label>
                <Input
                  type="number"
                  value={form.value}
                  onChange={(e) => setForm({ ...form, value: parseInt(e.target.value) || 0 })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">แพลตฟอร์ม</label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.platform}
                  onChange={(e) =>
                    setForm({ ...form, platform: e.target.value as CouponCode["platform"] })
                  }
                >
                  <option value="all">ทั้งสองเว็บ</option>
                  <option value="medical">morroo.com (แพทย์)</option>
                  <option value="pharmacy">pharmru.com (เภสัช)</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">จำนวนครั้งที่ใช้ได้ (เว้นว่าง = ไม่จำกัด)</label>
                <Input
                  type="number"
                  placeholder="ไม่จำกัด"
                  value={form.max_uses}
                  onChange={(e) => setForm({ ...form, max_uses: e.target.value })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">หมดอายุ (วัน)</label>
                <Input
                  type="number"
                  placeholder="30"
                  value={form.expires_days}
                  onChange={(e) => setForm({ ...form, expires_days: e.target.value })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">คำอธิบาย</label>
                <Input
                  placeholder="คูปองจากงาน EMS Forum 2026"
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                />
              </div>
              <div>
                <label className="text-sm font-medium">Source</label>
                <Input
                  placeholder="booth_ems2026"
                  value={form.source}
                  onChange={(e) => setForm({ ...form, source: e.target.value })}
                />
              </div>
            </div>

            <div className="border-t pt-4">
              <h4 className="text-sm font-medium mb-2">
                Bulk Generate (สร้างหลายโค้ดพร้อมกัน)
              </h4>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="text-sm text-muted-foreground">จำนวนโค้ด (เว้นว่าง = สร้างทีละ 1)</label>
                  <Input
                    type="number"
                    placeholder="100"
                    value={form.bulk_count}
                    onChange={(e) => setForm({ ...form, bulk_count: e.target.value })}
                  />
                </div>
                <div>
                  <label className="text-sm text-muted-foreground">Prefix</label>
                  <Input
                    placeholder="BOOTH"
                    value={form.bulk_prefix}
                    onChange={(e) => setForm({ ...form, bulk_prefix: e.target.value })}
                    className="uppercase"
                  />
                </div>
              </div>
            </div>

            <div className="flex justify-end gap-2">
              <Button variant="outline" onClick={() => setShowForm(false)}>
                ยกเลิก
              </Button>
              <Button
                onClick={handleCreate}
                disabled={saving}
                className="bg-brand hover:bg-brand-light text-white"
              >
                {saving ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                สร้างคูปอง
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Coupons table */}
      <div className="space-y-3">
        {coupons.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <Ticket className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <p className="text-muted-foreground">ยังไม่มีคูปอง</p>
            </CardContent>
          </Card>
        ) : (
          coupons.map((coupon) => (
            <Card
              key={coupon.id}
              className={!coupon.is_active ? "opacity-50" : ""}
            >
              <CardContent className="py-4">
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <code className="text-lg font-mono font-bold text-brand">
                        {coupon.code}
                      </code>
                      <Badge variant="secondary">
                        {COUPON_TYPE_LABELS[coupon.coupon_type]}
                      </Badge>
                      <Badge
                        className={
                          coupon.is_active
                            ? "bg-green-100 text-green-700"
                            : "bg-gray-100 text-gray-500"
                        }
                      >
                        {coupon.is_active ? "ใช้งานได้" : "ปิดใช้งาน"}
                      </Badge>
                    </div>
                    <div className="text-sm text-muted-foreground mt-1 flex flex-wrap gap-x-4 gap-y-1">
                      <span>
                        มูลค่า: {coupon.value}
                        {coupon.coupon_type === "discount_percent" ? "%" : ""}
                        {coupon.coupon_type === "discount_fixed" ? " บาท" : ""}
                        {coupon.coupon_type === "free_trial" ? " ข้อ" : ""}
                        {coupon.coupon_type === "free_month" ? " เดือน" : ""}
                      </span>
                      <span>
                        ใช้แล้ว: {coupon.current_uses}/{coupon.max_uses ?? "ไม่จำกัด"}
                      </span>
                      {coupon.expires_at && (
                        <span>
                          หมดอายุ: {new Date(coupon.expires_at).toLocaleDateString("th-TH")}
                        </span>
                      )}
                      {coupon.source && <span>Source: {coupon.source}</span>}
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => navigator.clipboard.writeText(coupon.code)}
                    >
                      <Copy className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={() => toggleCoupon(coupon)}
                    >
                      {coupon.is_active ? (
                        <ToggleRight className="h-5 w-5 text-green-600" />
                      ) : (
                        <ToggleLeft className="h-5 w-5 text-gray-400" />
                      )}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
