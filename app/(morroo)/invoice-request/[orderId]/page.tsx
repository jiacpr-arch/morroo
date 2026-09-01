"use client";

import { useState, useEffect } from "react";
import { use } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Loader2, CheckCircle, AlertCircle, FileText } from "lucide-react";

interface InvoiceInfo {
  invoice_number: string;
  plan_type: string;
  total_amount: number;
  buyer_name: string | null;
  buyer_tax_id: string | null;
  buyer_address: string | null;
  buyer_email: string | null;
  status: string;
}

const PLAN_NAMES: Record<string, string> = {
  monthly: "MorRoo รายเดือน",
  yearly: "MorRoo รายปี",
  bundle: "MorRoo ชุดข้อสอบ",
  mcq_monthly: "MorRoo MCQ รายเดือน",
  mcq_yearly: "MorRoo MCQ รายปี",
  meq_monthly: "MorRoo MEQ รายเดือน",
  meq_yearly: "MorRoo MEQ รายปี",
  longcase_monthly: "MorRoo Long Case รายเดือน",
  longcase_yearly: "MorRoo Long Case รายปี",
};

export default function InvoiceRequestPage({
  params,
}: {
  params: Promise<{ orderId: string }>;
}) {
  const { orderId } = use(params);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [invoice, setInvoice] = useState<InvoiceInfo | null>(null);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);
  const [alreadyFilled, setAlreadyFilled] = useState(false);

  // Form fields
  const [buyerName, setBuyerName] = useState("");
  const [buyerTaxId, setBuyerTaxId] = useState("");
  const [buyerAddress, setBuyerAddress] = useState("");
  const [buyerEmail, setBuyerEmail] = useState("");

  useEffect(() => {
    async function loadInvoice() {
      try {
        const res = await fetch(`/api/invoice-request/${orderId}`);
        if (!res.ok) {
          const data = await res.json();
          setError(data.error ?? "ไม่พบข้อมูลคำสั่งซื้อ");
          setLoading(false);
          return;
        }
        const data = await res.json() as InvoiceInfo;
        setInvoice(data);

        // Pre-fill if data exists
        if (data.buyer_name) setBuyerName(data.buyer_name);
        if (data.buyer_tax_id) setBuyerTaxId(data.buyer_tax_id);
        if (data.buyer_address) setBuyerAddress(data.buyer_address);
        if (data.buyer_email) setBuyerEmail(data.buyer_email);

        // Already submitted before
        if (data.buyer_name && data.buyer_tax_id) {
          setAlreadyFilled(true);
        }
      } catch {
        setError("เกิดข้อผิดพลาดในการโหลดข้อมูล");
      } finally {
        setLoading(false);
      }
    }
    loadInvoice();
  }, [orderId]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!buyerName.trim()) {
      setError("กรุณาระบุชื่อ/บริษัท");
      return;
    }
    setError("");
    setSubmitting(true);

    try {
      const res = await fetch(`/api/invoice-request/${orderId}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          buyerName: buyerName.trim(),
          buyerTaxId: buyerTaxId.trim(),
          buyerAddress: buyerAddress.trim(),
          buyerEmail: buyerEmail.trim(),
        }),
      });

      if (!res.ok) {
        const data = await res.json();
        setError(data.error ?? "เกิดข้อผิดพลาด");
        return;
      }

      setSuccess(true);
    } catch {
      setError("เกิดข้อผิดพลาดในการส่งข้อมูล");
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-[#16A085]" />
      </div>
    );
  }

  if (error && !invoice) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardContent className="pt-6 text-center">
            <AlertCircle className="h-12 w-12 text-red-500 mx-auto mb-4" />
            <p className="text-lg font-medium">{error}</p>
            <p className="text-sm text-gray-500 mt-2">
              กรุณาตรวจสอบลิงก์อีกครั้ง หรือติดต่อเราทาง LINE @jiacpr
            </p>
          </CardContent>
        </Card>
      </div>
    );
  }

  if (success) {
    return (
      <div className="min-h-screen flex items-center justify-center p-4">
        <Card className="max-w-md w-full">
          <CardContent className="pt-6 text-center">
            <CheckCircle className="h-12 w-12 text-[#16A085] mx-auto mb-4" />
            <h2 className="text-xl font-semibold mb-2">บันทึกข้อมูลเรียบร้อย</h2>
            <p className="text-gray-600 mb-1">
              ระบบจะออกใบกำกับภาษีและส่งให้ทาง email
            </p>
            {buyerEmail && (
              <p className="text-sm text-gray-500">({buyerEmail})</p>
            )}
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <Card className="max-w-lg w-full">
        <CardHeader className="text-center pb-2">
          <FileText className="h-10 w-10 text-[#16A085] mx-auto mb-2" />
          <h1 className="text-xl font-semibold">ขอใบกำกับภาษี</h1>
          <p className="text-sm text-gray-500">กรอกข้อมูลเพื่อออกใบกำกับภาษี/ใบเสร็จรับเงิน</p>
        </CardHeader>

        <CardContent>
          {/* Order summary */}
          {invoice && (
            <div className="bg-gray-50 rounded-lg p-3 mb-6 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-500">เลขที่</span>
                <span className="font-medium">{invoice.invoice_number}</span>
              </div>
              <div className="flex justify-between mt-1">
                <span className="text-gray-500">แพ็กเกจ</span>
                <span>{PLAN_NAMES[invoice.plan_type] ?? invoice.plan_type}</span>
              </div>
              <div className="flex justify-between mt-1">
                <span className="text-gray-500">ยอดรวม</span>
                <span className="font-semibold">
                  {"\u0E3F"}{invoice.total_amount.toLocaleString()}
                </span>
              </div>
            </div>
          )}

          {alreadyFilled && (
            <div className="bg-amber-50 border border-amber-200 rounded-lg p-3 mb-4 text-sm text-amber-800">
              คุณเคยกรอกข้อมูลไว้แล้ว สามารถแก้ไขและส่งใหม่ได้
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label htmlFor="buyerName">
                ชื่อ-นามสกุล / บริษัท <span className="text-red-500">*</span>
              </Label>
              <Input
                id="buyerName"
                value={buyerName}
                onChange={(e) => setBuyerName(e.target.value)}
                placeholder="เช่น บริษัท ABC จำกัด"
                required
              />
            </div>

            <div>
              <Label htmlFor="buyerTaxId">
                เลขประจำตัวผู้เสียภาษี (13 หลัก)
              </Label>
              <Input
                id="buyerTaxId"
                value={buyerTaxId}
                onChange={(e) => setBuyerTaxId(e.target.value.replace(/\D/g, "").slice(0, 13))}
                placeholder="0000000000000"
                inputMode="numeric"
                maxLength={13}
              />
            </div>

            <div>
              <Label htmlFor="buyerAddress">ที่อยู่</Label>
              <textarea
                id="buyerAddress"
                value={buyerAddress}
                onChange={(e) => setBuyerAddress(e.target.value)}
                placeholder="ที่อยู่สำหรับออกใบกำกับภาษี"
                rows={3}
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm shadow-sm placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring"
              />
            </div>

            <div>
              <Label htmlFor="buyerEmail">
                Email (สำหรับส่งใบกำกับภาษี)
              </Label>
              <Input
                id="buyerEmail"
                type="email"
                value={buyerEmail}
                onChange={(e) => setBuyerEmail(e.target.value)}
                placeholder="email@example.com"
              />
            </div>

            {error && (
              <p className="text-sm text-red-600">{error}</p>
            )}

            <Button
              type="submit"
              disabled={submitting}
              className="w-full bg-[#16A085] hover:bg-[#138D75] text-white"
            >
              {submitting ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin mr-2" />
                  กำลังบันทึก...
                </>
              ) : alreadyFilled ? (
                "อัพเดทข้อมูล"
              ) : (
                "ขอใบกำกับภาษี"
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
