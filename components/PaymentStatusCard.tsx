"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import { Receipt } from "lucide-react";

interface SlipOrder {
  id: string;
  plan_type: string;
  amount: number;
  status: string;
  note: string | null;
  created_at: string;
}

const planLabels: Record<string, string> = {
  monthly: "รายเดือน",
  yearly: "รายปี",
  bundle: "ชุดข้อสอบ",
  board_monthly: "Board รายเดือน",
  board_yearly: "Board รายปี",
};

const statusConfig: Record<string, { label: string; color: string }> = {
  pending: { label: "รอตรวจสอบ", color: "bg-yellow-100 text-yellow-700" },
  approved: { label: "อนุมัติแล้ว", color: "bg-green-100 text-green-700" },
  rejected: { label: "ไม่ผ่านการตรวจสอบ", color: "bg-red-100 text-red-700" },
};

/**
 * Shows the customer their recent bank-transfer submissions so a pending
 * slip is never invisible again. Renders nothing when the user has no
 * bank-transfer orders (i.e. Stripe-only customers see no extra card).
 */
export default function PaymentStatusCard() {
  const [orders, setOrders] = useState<SlipOrder[]>([]);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) return;

      const { data } = await supabase
        .from("payment_orders")
        .select("id, plan_type, amount, status, note, created_at")
        .eq("user_id", user.id)
        .eq("payment_method", "bank_transfer")
        .order("created_at", { ascending: false })
        .limit(3);

      setOrders(data ?? []);
    }
    load();
  }, []);

  if (orders.length === 0) return null;

  return (
    <Card>
      <CardHeader>
        <h3 className="font-semibold flex items-center gap-2">
          <Receipt className="h-5 w-5 text-brand" /> สถานะการแจ้งโอนเงิน
        </h3>
      </CardHeader>
      <CardContent className="space-y-3">
        {orders.map((order) => {
          const status = statusConfig[order.status] ?? {
            label: order.status,
            color: "bg-gray-100 text-gray-700",
          };
          return (
            <div key={order.id} className="rounded-lg border p-3 space-y-2">
              <div className="flex items-center justify-between gap-2">
                <div className="min-w-0">
                  <p className="text-sm font-medium">
                    {planLabels[order.plan_type] ?? order.plan_type} — ฿
                    {Number(order.amount).toLocaleString()}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {new Date(order.created_at).toLocaleString("th-TH")}
                  </p>
                </div>
                <Badge className={status.color}>{status.label}</Badge>
              </div>
              {order.status === "rejected" && (
                <div className="text-xs text-muted-foreground space-y-1">
                  {order.note && <p>เหตุผล: {order.note}</p>}
                  <Link
                    href={`/payment/${order.plan_type}`}
                    className="text-brand hover:underline font-medium"
                  >
                    ส่งสลิปอีกครั้ง →
                  </Link>
                </div>
              )}
              {order.status === "pending" && (
                <p className="text-xs text-muted-foreground">
                  กำลังตรวจสอบ — แจ้งผลทาง LINE/อีเมลภายใน 24 ชม.
                </p>
              )}
            </div>
          );
        })}
      </CardContent>
    </Card>
  );
}
