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
  HelpCircle,
} from "lucide-react";
import { COUPON_TYPE_LABELS, type CouponCode } from "@/lib/types-standard";

function generateCode(prefix: string, length = 6): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
  let result = prefix ? prefix.toUpperCase() + "-" : "";
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

  const [showHelp, setShowHelp] = useState(false);

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
            <div className="flex items-center justify-between">
              <h3 className="font-bold">สร้างคูปองใหม่</h3>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setShowHelp(!showHelp)}
                className="text-muted-foreground gap-1.5"
              >
                <HelpCircle className="h-4 w-4" />
                {showHelp ? "ซ่อนคำอธิบาย" : "ดูคำอธิบาย"}
              </Button>
            </div>
          </CardHeader>
          <CardContent className="space-y-4">
            {showHelp && (
              <div className="rounded-lg bg-blue-50 border border-blue-200 p-4 text-sm space-y-3">
                <p className="font-semibold text-blue-900">คู่มือสร้างคูปอง</p>
                <div className="space-y-2 text-blue-800">
                  <div>
                    <span className="font-medium">ประเภทคูปอง:</span>
                    <ul className="list-disc list-inside mt-1 ml-2 space-y-1">
                      <li><strong>ทดลองใช้ฟรี</strong> — ให้ผู้ใช้เป็นสมาชิก Premium ชั่วคราว ใส่จำนวน &quot;วัน&quot; ที่ต้องการให้ใช้ฟรี เช่น 7 = ใช้ฟรี 7 วัน</li>
                      <li><strong>ฟรีสมาชิก X เดือน</strong> — ให้สมาชิกฟรีตามจำนวนเดือน เช่น 1 = ฟรี 1 เดือน</li>
                      <li><strong>ส่วนลด %</strong> — ลดราคาตอนซื้อแพ็กเกจ เช่น 20 = ลด 20%</li>
                      <li><strong>ส่วนลดบาท</strong> — ลดราคาตอนซื้อแพ็กเกจ เช่น 50 = ลด 50 บาท</li>
                    </ul>
                  </div>
                  <div>
                    <span className="font-medium">สร้างทีละเยอะ (Bulk):</span>
                    <p className="ml-2 mt-1">ใส่จำนวนโค้ดที่ต้องการ + คำนำหน้า เช่น จำนวน 100, คำนำหน้า SIMSET → ได้โค้ด SIMSET-XXXXXX จำนวน 100 โค้ด (แต่ละโค้ดใช้ได้ 1 ครั้ง)</p>
                  </div>
                </div>
              </div>
            )}

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium">โค้ดคูปอง</label>
                <Input
                  placeholder="เว้นว่างเพื่อสุ่มอัตโนมัติ"
                  value={form.code}
                  onChange={(e) => setForm({ ...form, code: e.target.value })}
                  className="uppercase"
                />
                <p className="text-xs text-muted-foreground mt-1">โค้ดที่ผู้ใช้จะกรอก เช่น BOOTH-EMS2026</p>
              </div>
              <div>
                <label className="text-sm font-medium">ประเภทคูปอง</label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.coupon_type}
                  onChange={(e) =>
                    setForm({ ...form, coupon_type: e.target.value as CouponCode["coupon_type"] })
                  }
                >
                  <option value="free_trial">ทดลองใช้ฟรี (กี่วัน)</option>
                  <option value="free_month">ฟรีสมาชิก (กี่เดือน)</option>
                  <option value="discount_percent">ส่วนลด %</option>
                  <option value="discount_fixed">ส่วนลดบาท</option>
                </select>
                <p className="text-xs text-muted-foreground mt-1">
                  {form.coupon_type === "free_trial" && "ผู้ใช้จะได้ Premium ฟรีตามจำนวนวันที่กำหนด"}
                  {form.coupon_type === "free_month" && "ผู้ใช้จะได้สมาชิกฟรีตามจำนวนเดือน"}
                  {form.coupon_type === "discount_percent" && "ลดราคาเป็น % ตอนซื้อแพ็กเกจ"}
                  {form.coupon_type === "discount_fixed" && "ลดราคาเป็นบาทตอนซื้อแพ็กเกจ"}
                </p>
              </div>
              <div>
                <label className="text-sm font-medium">
                  {form.coupon_type === "free_trial" && "จำนวนวันที่ให้ใช้ฟรี"}
                  {form.coupon_type === "free_month" && "จำนวนเดือนที่ให้ฟรี"}
                  {form.coupon_type === "discount_percent" && "เปอร์เซ็นต์ส่วนลด"}
                  {form.coupon_type === "discount_fixed" && "จำนวนเงินที่ลด (บาท)"}
                </label>
                <Input
                  type="number"
                  value={form.value}
                  onChange={(e) => setForm({ ...form, value: parseInt(e.target.value) || 0 })}
                />
                <p className="text-xs text-muted-foreground mt-1">
                  {form.coupon_type === "free_trial" && `เช่น 7 = ใช้ฟรี 7 วัน, 30 = ใช้ฟรี 30 วัน`}
                  {form.coupon_type === "free_month" && `เช่น 1 = ฟรี 1 เดือน, 3 = ฟรี 3 เดือน`}
                  {form.coupon_type === "discount_percent" && `เช่น 20 = ลด 20%, 50 = ลด 50%`}
                  {form.coupon_type === "discount_fixed" && `เช่น 50 = ลด 50 บาท, 100 = ลด 100 บาท`}
                </p>
              </div>
              <div>
                <label className="text-sm font-medium">ใช้ได้กับเว็บไหน</label>
                <select
                  className="w-full rounded-md border px-3 py-2 text-sm"
                  value={form.platform}
                  onChange={(e) =>
                    setForm({ ...form, platform: e.target.value as CouponCode["platform"] })
                  }
                >
                  <option value="all">ทั้งสองเว็บ</option>
                  <option value="medical">morroo.com (แพทย์)</option>
                  <option value="pharmacy">pharma.morroo.com (เภสัช)</option>
                </select>
              </div>
              <div>
                <label className="text-sm font-medium">ใช้ได้กี่ครั้ง (รวมทุกคน)</label>
                <Input
                  type="number"
                  placeholder="ไม่จำกัด"
                  value={form.max_uses}
                  onChange={(e) => setForm({ ...form, max_uses: e.target.value })}
                />
                <p className="text-xs text-muted-foreground mt-1">เว้นว่าง = ไม่จำกัดจำนวนครั้ง (แต่ละคนใช้ได้ 1 ครั้ง)</p>
              </div>
              <div>
                <label className="text-sm font-medium">คูปองหมดอายุใน (วัน)</label>
                <Input
                  type="number"
                  placeholder="30"
                  value={form.expires_days}
                  onChange={(e) => setForm({ ...form, expires_days: e.target.value })}
                />
                <p className="text-xs text-muted-foreground mt-1">นับจากวันที่สร้าง เช่น 30 = ใช้ได้ภายใน 30 วัน</p>
              </div>
              <div>
                <label className="text-sm font-medium">คำอธิบาย (ไม่บังคับ)</label>
                <Input
                  placeholder="เช่น คูปองจากงาน EMS Forum 2026"
                  value={form.description}
                  onChange={(e) => setForm({ ...form, description: e.target.value })}
                />
                <p className="text-xs text-muted-foreground mt-1">โน้ตสำหรับ admin ดูเอง ผู้ใช้ไม่เห็น</p>
              </div>
              <div>
                <label className="text-sm font-medium">แหล่งที่มา (ไม่บังคับ)</label>
                <Input
                  placeholder="เช่น booth_ems2026"
                  value={form.source}
                  onChange={(e) => setForm({ ...form, source: e.target.value })}
                />
                <p className="text-xs text-muted-foreground mt-1">ใช้ติดตามว่าคูปองมาจากแคมเปญไหน</p>
              </div>
            </div>

            <div className="border-t pt-4">
              <h4 className="text-sm font-medium mb-1">
                สร้างทีละเยอะ (Bulk)
              </h4>
              <p className="text-xs text-muted-foreground mb-3">สำหรับแจกหน้างาน/อีเวนท์ — ระบบจะสุ่มโค้ดให้อัตโนมัติ แต่ละโค้ดใช้ได้ 1 ครั้ง</p>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                  <label className="text-sm text-muted-foreground">จำนวนโค้ดที่ต้องการ</label>
                  <Input
                    type="number"
                    placeholder="เว้นว่าง = สร้างทีละ 1"
                    value={form.bulk_count}
                    onChange={(e) => setForm({ ...form, bulk_count: e.target.value })}
                  />
                </div>
                <div>
                  <label className="text-sm text-muted-foreground">คำนำหน้าโค้ด</label>
                  <Input
                    placeholder="เช่น SIMSET, BOOTH"
                    value={form.bulk_prefix}
                    onChange={(e) => setForm({ ...form, bulk_prefix: e.target.value })}
                    className="uppercase"
                  />
                  <p className="text-xs text-muted-foreground mt-1">โค้ดจะเป็น: คำนำหน้า-XXXXXXXX</p>
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
                        {coupon.coupon_type === "free_trial" ? " วัน" : ""}
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
