"use client";

import { useState, useEffect } from "react";
import { use } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createClient } from "@/lib/supabase/client";
import { track } from "@/lib/analytics";
import { trackInitiateCheckout } from "@/lib/analytics/conversions";
import LandingPageTracker from "@/components/LandingPageTracker";
import PaymentTrustSignals from "@/components/PaymentTrustSignals";
import {
  ArrowLeft,
  Loader2,
  AlertCircle,
  CreditCard,
} from "lucide-react";
import type { User } from "@supabase/supabase-js";

const PLANS: Record<string, { name: string; price: number; period: string }> = {
  monthly: { name: "รายเดือน", price: 199, period: "/ เดือน" },
  yearly: { name: "รายปี", price: 1490, period: "/ ปี" },
  bundle: { name: "ชุดข้อสอบ 10 ข้อ", price: 299, period: "" },
  board_monthly: { name: "Board รายเดือน", price: 499, period: "/ เดือน" },
  board_yearly: { name: "Board รายปี", price: 4990, period: "/ ปี" },
};

// Mirror of NEXT_PUBLIC_STRIPE_PROMPTPAY_ENABLED used by the Stripe checkout
// route. When on, the Stripe option also offers an instant PromptPay QR, so we
// advertise it.
const PROMPTPAY_ENABLED =
  process.env.NEXT_PUBLIC_STRIPE_PROMPTPAY_ENABLED === "true";

export default function PaymentPage({
  params,
}: {
  params: Promise<{ plan: string }>;
}) {
  const { plan } = use(params);
  const router = useRouter();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  // Invoice / tax form
  const [wantInvoice, setWantInvoice] = useState(false);
  const [invoiceName, setInvoiceName] = useState("");
  const [invoiceTaxId, setInvoiceTaxId] = useState("");
  const [invoiceAddress, setInvoiceAddress] = useState("");

  // Stripe loading
  const [stripeLoading, setStripeLoading] = useState(false);

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

  // Canonical InitiateCheckout: fires once per payment-page visit so Meta/TikTok
  // get the signal before the user reaches Stripe checkout.
  useEffect(() => {
    const info = PLANS[plan];
    if (!info) return;
    trackInitiateCheckout({ plan, value: info.price, currency: "THB" });
  }, [plan]);

  const handleStripeCheckout = async () => {
    if (!user) return;
    setStripeLoading(true);
    setError("");
    const price = planInfo?.price ?? 0;
    track("stripe_checkout_click", { plan, price, wantInvoice });
    try {
      const res = await fetch("/api/billing/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          planType: plan,
          invoiceData: wantInvoice
            ? { name: invoiceName, taxId: invoiceTaxId, address: invoiceAddress }
            : null,
        }),
      });
      const data = await res.json();
      if (data.url) {
        window.location.href = data.url;
      } else {
        setError(data.error || "เกิดข้อผิดพลาด");
      }
    } catch {
      setError("เกิดข้อผิดพลาด กรุณาลองใหม่");
    }
    setStripeLoading(false);
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

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6">
      <LandingPageTracker
        event="payment_view"
        properties={{ plan }}
      />
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

        <PaymentTrustSignals />

        {/* Stripe payment section */}
        <Card className="border-brand/20">
          <CardHeader>
            <h2 className="font-semibold flex items-center gap-2">
              <CreditCard className="h-5 w-5 text-brand" />
              {PROMPTPAY_ENABLED
                ? "ชำระด้วย PromptPay หรือบัตร"
                : "ชำระผ่านบัตรเครดิต/เดบิต"}
            </h2>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Optional tax invoice toggle */}
            <div className="flex items-center gap-3">
              <input
                type="checkbox"
                id="wantInvoice"
                checked={wantInvoice}
                onChange={(e) => setWantInvoice(e.target.checked)}
                className="h-4 w-4 rounded border-gray-300 text-brand"
              />
              <Label htmlFor="wantInvoice" className="cursor-pointer font-medium">
                ต้องการใบกำกับภาษี
              </Label>
            </div>

            {wantInvoice && (
              <div className="rounded-lg border bg-muted/30 p-4 space-y-3">
                <div>
                  <Label htmlFor="invoiceName" className="text-sm">
                    ชื่อ / บริษัท <span className="text-destructive">*</span>
                  </Label>
                  <Input
                    id="invoiceName"
                    value={invoiceName}
                    onChange={(e) => setInvoiceName(e.target.value)}
                    placeholder="ชื่อบุคคลหรือบริษัท"
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="invoiceTaxId" className="text-sm">
                    เลขประจำตัวผู้เสียภาษี (13 หลัก) <span className="text-destructive">*</span>
                  </Label>
                  <Input
                    id="invoiceTaxId"
                    value={invoiceTaxId}
                    onChange={(e) => setInvoiceTaxId(e.target.value)}
                    placeholder="0-0000-00000-00-0"
                    maxLength={13}
                    className="mt-1"
                  />
                </div>
                <div>
                  <Label htmlFor="invoiceAddress" className="text-sm">
                    ที่อยู่ <span className="text-destructive">*</span>
                  </Label>
                  <Input
                    id="invoiceAddress"
                    value={invoiceAddress}
                    onChange={(e) => setInvoiceAddress(e.target.value)}
                    placeholder="ที่อยู่สำหรับออกใบกำกับภาษี"
                    className="mt-1"
                  />
                </div>
              </div>
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
              disabled={stripeLoading}
              onClick={handleStripeCheckout}
            >
              {stripeLoading ? (
                <>
                  <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                  กำลังเชื่อมต่อ...
                </>
              ) : (
                <>
                  <CreditCard className="h-4 w-4 mr-2" />
                  ชำระผ่าน Stripe ฿{planInfo.price.toLocaleString()}
                </>
              )}
            </Button>

            <p className="text-xs text-center text-muted-foreground">
              {PROMPTPAY_ENABLED
                ? "สแกน PromptPay หรือจ่ายด้วยบัตร • อัปเกรดอัตโนมัติทันที • ปลอดภัยด้วย Stripe"
                : "ระบบจะอัปเกรดอัตโนมัติหลังชำระเงิน • ปลอดภัยด้วย Stripe"}
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
