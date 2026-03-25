"use client";

import { useState, useEffect } from "react";
import { use } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  Building2,
  Copy,
  Check,
  Upload,
  ImageIcon,
  Loader2,
  CheckCircle,
  AlertCircle,
} from "lucide-react";
import type { User } from "@supabase/supabase-js";

const PLANS: Record<string, { name: string; price: number; period: string }> = {
  monthly: { name: "รายเดือน", price: 199, period: "/ เดือน" },
  yearly: { name: "รายปี", price: 1490, period: "/ ปี" },
  bundle: { name: "ชุดข้อสอบ 10 ข้อ", price: 299, period: "" },
};

const BANK_INFO = {
  bank: "ธนาคารกสิกรไทย",
  accountNumber: "134-3-11564-0",
  accountName: "บริษัท โรจน์รุ่งธุรกิจ จำกัด",
};

export default function PaymentPage({
  params,
}: {
  params: Promise<{ plan: string }>;
}) {
  const { plan } = use(params);
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [error, setError] = useState("");
  const [copied, setCopied] = useState(false);
  const [slipFile, setSlipFile] = useState<File | null>(null);
  const [slipPreview, setSlipPreview] = useState<string | null>(null);

  const planInfo = PLANS[plan];

  useEffect(() => {
    async function checkAuth() {
      const supabase = createClient();
      const { data } = await supabase.auth.getUser();
      if (!data.user) {
        router.push(`/login?redirect=/payment/${plan}`);
        return;
      }
      setUser(data.user);
      setLoading(false);
    }
    checkAuth();
  }, [plan, router]);

  const copyAccountNumber = () => {
    navigator.clipboard.writeText("1343115640");
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith("image/")) {
      setError("กรุณาเลือกไฟล์รูปภาพเท่านั้น");
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setError("ไฟล์ต้องมีขนาดไม่เกิน 5MB");
      return;
    }

    setError("");
    setSlipFile(file);
    const reader = new FileReader();
    reader.onload = (ev) => setSlipPreview(ev.target?.result as string);
    reader.readAsDataURL(file);
  };

  const handleSubmit = async () => {
    if (!slipFile || !user) return;

    setSubmitting(true);
    setError("");

    try {
      const supabase = createClient();

      // Upload slip to Supabase Storage
      const fileExt = slipFile.name.split(".").pop();
      const fileName = `${user.id}/${Date.now()}.${fileExt}`;

      const { error: uploadError } = await supabase.storage
        .from("slips")
        .upload(fileName, slipFile);

      if (uploadError) {
        // If storage not set up, save order without slip URL
        console.warn("Storage upload failed:", uploadError.message);
      }

      const slipUrl = uploadError
        ? `pending-upload-${Date.now()}`
        : fileName;

      // Create payment order
      const { error: orderError } = await supabase
        .from("payment_orders")
        .insert({
          user_id: user.id,
          plan_type: plan,
          amount: planInfo.price,
          slip_url: slipUrl,
          status: "pending",
        });

      if (orderError) {
        setError("เกิดข้อผิดพลาด: " + orderError.message);
        setSubmitting(false);
        return;
      }

      setSubmitted(true);
    } catch {
      setError("เกิดข้อผิดพลาด กรุณาลองใหม่");
    }
    setSubmitting(false);
  };

  if (!planInfo) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <h1 className="text-2xl font-bold">ไม่พบแพ็กเกจนี้</h1>
        <Link href="/pricing" className="text-brand hover:underline mt-4 inline-block">
          กลับไปเลือกแพ็กเกจ
        </Link>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  // Success state
  if (submitted) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16">
        <Card className="text-center">
          <CardContent className="py-12 space-y-4">
            <div className="mx-auto w-16 h-16 rounded-full bg-brand/10 flex items-center justify-center">
              <CheckCircle className="h-8 w-8 text-brand" />
            </div>
            <h1 className="text-2xl font-bold">ส่งหลักฐานเรียบร้อย!</h1>
            <p className="text-muted-foreground">
              เราจะตรวจสอบการชำระเงินและอัปเกรดบัญชีของคุณ
              <br />
              ภายใน <strong>1-2 ชั่วโมง</strong> ในเวลาทำการ
            </p>
            <div className="pt-4 space-y-2">
              <Link href="/exams">
                <Button className="w-full bg-brand hover:bg-brand-light text-white">
                  กลับไปดูข้อสอบ
                </Button>
              </Link>
              <Link href="/profile">
                <Button variant="outline" className="w-full">
                  ดูสถานะคำสั่งซื้อ
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <Link
        href="/pricing"
        className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-6"
      >
        <ArrowLeft className="h-4 w-4" /> กลับไปเลือกแพ็กเกจ
      </Link>

      <h1 className="text-2xl font-bold mb-6">ชำระเงิน</h1>

      <div className="space-y-6">
        {/* Order summary */}
        <Card>
          <CardHeader>
            <h2 className="font-semibold">สรุปคำสั่งซื้อ</h2>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between">
              <div>
                <p className="font-medium">{planInfo.name}</p>
                <p className="text-sm text-muted-foreground">
                  แพ็กเกจ{planInfo.name}
                </p>
              </div>
              <div className="text-right">
                <p className="text-2xl font-bold">
                  ฿{planInfo.price.toLocaleString()}
                </p>
                {planInfo.period && (
                  <p className="text-sm text-muted-foreground">
                    {planInfo.period}
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Bank transfer info */}
        <Card className="border-brand/20">
          <CardHeader>
            <h2 className="font-semibold flex items-center gap-2">
              <Building2 className="h-5 w-5 text-brand" />
              ข้อมูลการโอนเงิน
            </h2>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="rounded-lg bg-green-50 border border-green-200 p-4 space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">ธนาคาร</span>
                <span className="font-medium text-green-800">
                  {BANK_INFO.bank}
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">
                  เลขที่บัญชี
                </span>
                <div className="flex items-center gap-2">
                  <span className="font-mono font-bold text-lg text-green-800">
                    {BANK_INFO.accountNumber}
                  </span>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="h-8 w-8"
                    onClick={copyAccountNumber}
                  >
                    {copied ? (
                      <Check className="h-4 w-4 text-green-600" />
                    ) : (
                      <Copy className="h-4 w-4" />
                    )}
                  </Button>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">ชื่อบัญชี</span>
                <span className="font-medium text-green-800">
                  {BANK_INFO.accountName}
                </span>
              </div>
              <div className="flex items-center justify-between pt-2 border-t border-green-200">
                <span className="text-sm font-medium text-green-700">
                  ยอดที่ต้องโอน
                </span>
                <span className="text-xl font-bold text-green-800">
                  ฿{planInfo.price.toLocaleString()}.00
                </span>
              </div>
            </div>

            <div className="rounded-lg bg-amber-50 border border-amber-200 p-3">
              <p className="text-sm text-amber-800">
                <strong>สำคัญ:</strong> กรุณาโอนเงินตามยอดที่ระบุ
                แล้วแนบสลิปการโอนด้านล่าง
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Upload slip */}
        <Card>
          <CardHeader>
            <h2 className="font-semibold flex items-center gap-2">
              <Upload className="h-5 w-5 text-brand" />
              แนบสลิปการโอนเงิน
            </h2>
          </CardHeader>
          <CardContent className="space-y-4">
            {slipPreview ? (
              <div className="space-y-3">
                <div className="relative rounded-lg overflow-hidden border bg-muted">
                  <img
                    src={slipPreview}
                    alt="สลิปการโอนเงิน"
                    className="w-full max-h-80 object-contain"
                  />
                </div>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => {
                    setSlipFile(null);
                    setSlipPreview(null);
                  }}
                >
                  เปลี่ยนรูป
                </Button>
              </div>
            ) : (
              <label className="flex flex-col items-center justify-center h-48 rounded-lg border-2 border-dashed border-muted-foreground/30 bg-muted/30 cursor-pointer hover:bg-muted/50 transition-colors">
                <ImageIcon className="h-10 w-10 text-muted-foreground/50 mb-2" />
                <span className="text-sm font-medium text-muted-foreground">
                  คลิกเพื่อเลือกรูปสลิป
                </span>
                <span className="text-xs text-muted-foreground/60 mt-1">
                  PNG, JPG ขนาดไม่เกิน 5MB
                </span>
                <input
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={handleFileChange}
                />
              </label>
            )}

            {error && (
              <div className="flex items-center gap-2 text-sm text-destructive">
                <AlertCircle className="h-4 w-4" />
                {error}
              </div>
            )}

            <Button
              className="w-full bg-brand hover:bg-brand-light text-white"
              size="lg"
              disabled={!slipFile || submitting}
              onClick={handleSubmit}
            >
              {submitting ? (
                <>
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                  กำลังส่ง...
                </>
              ) : (
                "ยืนยันการชำระเงิน"
              )}
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
