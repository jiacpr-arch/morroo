"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import {
  CheckCircle,
  XCircle,
  Clock,
  Loader2,
  Shield,
  ImageIcon,
  BadgeCheck,
} from "lucide-react";

interface PaymentOrder {
  id: string;
  user_id: string;
  plan_type: string;
  amount: number;
  status: string;
  slip_url: string | null;
  note: string | null;
  trans_ref: string | null;
  verified_by_provider: string | null;
  created_at: string;
  profiles?: { email: string; name: string };
  slipSignedUrl?: string;
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
  rejected: { label: "ปฏิเสธ", color: "bg-red-100 text-red-700" },
};

export default function AdminPaymentsPage() {
  const router = useRouter();
  const [orders, setOrders] = useState<PaymentOrder[]>([]);
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [processing, setProcessing] = useState<string | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        router.push("/login");
        return;
      }

      // Check admin
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();

      if (profile?.role !== "admin") {
        setIsAdmin(false);
        setLoading(false);
        return;
      }

      setIsAdmin(true);

      // Fetch orders
      const { data: ordersData } = await supabase
        .from("payment_orders")
        .select("*")
        .order("created_at", { ascending: false });

      if (ordersData && ordersData.length > 0) {
        // Fetch profiles for all user_ids
        const userIds = [...new Set(ordersData.map((o: PaymentOrder) => o.user_id))];
        const { data: profilesData } = await supabase
          .from("profiles")
          .select("id, email, name")
          .in("id", userIds);

        const profileMap: Record<string, { email: string; name: string }> = {};
        if (profilesData) {
          for (const p of profilesData) {
            profileMap[p.id] = { email: p.email, name: p.name };
          }
        }

        // Signed URLs so the slip images are actually viewable (bucket is
        // private; admin SELECT-all storage policy allows signing).
        const slipPaths = ordersData
          .map((o: PaymentOrder) => o.slip_url)
          .filter((p): p is string => Boolean(p && !p.startsWith("pending")));
        const signedMap: Record<string, string> = {};
        if (slipPaths.length > 0) {
          const { data: signed } = await supabase.storage
            .from("slips")
            .createSignedUrls(slipPaths, 3600);
          for (const s of signed ?? []) {
            if (s.signedUrl && s.path) signedMap[s.path] = s.signedUrl;
          }
        }

        setOrders(
          ordersData.map((o: PaymentOrder) => ({
            ...o,
            profiles: profileMap[o.user_id] || { email: o.user_id.slice(0, 8), name: "" },
            slipSignedUrl: o.slip_url ? signedMap[o.slip_url] : undefined,
          }))
        );
      } else {
        setOrders([]);
      }
      setLoading(false);
    }
    load();
  }, [router]);

  const handleAction = async (orderId: string, action: "approve" | "reject") => {
    let note: string | undefined;
    if (action === "reject") {
      const input = window.prompt(
        "เหตุผลที่ปฏิเสธ (ลูกค้าจะเห็นข้อความนี้ทาง LINE/อีเมล):",
        ""
      );
      if (input === null) return; // cancelled
      note = input.trim() || undefined;
    }

    setProcessing(orderId);
    setActionError(null);

    try {
      const res = await fetch("/api/admin/payments/review", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ orderId, action, note }),
      });
      const data = await res.json();

      if (!res.ok) {
        setActionError(data.error || "เกิดข้อผิดพลาด กรุณาลองใหม่");
      } else {
        setOrders((prev) =>
          prev.map((o) =>
            o.id === orderId
              ? { ...o, status: action === "approve" ? "approved" : "rejected", note: note ?? o.note }
              : o
          )
        );
      }
    } catch {
      setActionError("เชื่อมต่อไม่สำเร็จ กรุณาลองใหม่");
    }
    setProcessing(null);
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
        <p className="text-muted-foreground mt-2">
          หน้านี้สำหรับผู้ดูแลระบบเท่านั้น
        </p>
      </div>
    );
  }

  const pendingCount = orders.filter((o) => o.status === "pending").length;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold">จัดการการชำระเงิน</h1>
          <p className="text-muted-foreground mt-1">
            ตรวจสอบสลิปและอนุมัติสมาชิก
          </p>
        </div>
        {pendingCount > 0 && (
          <Badge className="bg-yellow-100 text-yellow-700 text-sm px-3 py-1">
            <Clock className="h-4 w-4 mr-1" />
            รอตรวจ {pendingCount} รายการ
          </Badge>
        )}
      </div>

      {actionError && (
        <div className="mb-4 rounded-lg border border-destructive/30 bg-destructive/5 p-3 text-sm text-destructive">
          {actionError}
        </div>
      )}

      {orders.length === 0 ? (
        <Card className="text-center py-12">
          <CardContent>
            <p className="text-muted-foreground">ยังไม่มีคำสั่งซื้อ</p>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {orders.map((order) => {
            const status = statusConfig[order.status];
            return (
              <Card
                key={order.id}
                className={
                  order.status === "pending" ? "border-yellow-300" : ""
                }
              >
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between flex-wrap gap-2">
                    <div>
                      <p className="font-semibold">
                        {order.profiles?.name || order.profiles?.email || order.user_id.slice(0, 8)}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {order.profiles?.email}
                      </p>
                    </div>
                    <div className="flex items-center gap-2">
                      {order.verified_by_provider && (
                        <Badge className="bg-emerald-100 text-emerald-700">
                          <BadgeCheck className="h-3.5 w-3.5 mr-1" />
                          ตรวจอัตโนมัติ ({order.verified_by_provider})
                        </Badge>
                      )}
                      <Badge className={status.color}>{status.label}</Badge>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-3">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">แพ็กเกจ</span>
                    <span className="font-medium">
                      {planLabels[order.plan_type] || order.plan_type}
                    </span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">จำนวนเงิน</span>
                    <span className="font-bold text-lg">
                      ฿{order.amount.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">วันที่</span>
                    <span>
                      {new Date(order.created_at).toLocaleString("th-TH")}
                    </span>
                  </div>
                  {order.trans_ref && (
                    <div className="flex items-center justify-between text-sm">
                      <span className="text-muted-foreground">เลขอ้างอิงโอน</span>
                      <span className="font-mono text-xs">{order.trans_ref}</span>
                    </div>
                  )}
                  {order.note && (
                    <div className="rounded-lg bg-amber-50 border border-amber-200 p-2 text-sm text-amber-800">
                      {order.note}
                    </div>
                  )}

                  {/* Slip preview */}
                  {order.slip_url && !order.slip_url.startsWith("pending") && (
                    <div className="rounded-lg border bg-muted/30 p-2">
                      <div className="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                        <ImageIcon className="h-4 w-4" />
                        สลิปการโอนเงิน
                      </div>
                      {order.slipSignedUrl ? (
                        <a
                          href={order.slipSignedUrl}
                          target="_blank"
                          rel="noopener noreferrer"
                        >
                          {/* eslint-disable-next-line @next/next/no-img-element -- short-lived signed URL from private bucket, not suitable for next/image optimizer */}
                          <img
                            src={order.slipSignedUrl}
                            alt="สลิปการโอนเงิน"
                            className="max-h-72 rounded-md border object-contain"
                          />
                        </a>
                      ) : (
                        <p className="text-xs text-muted-foreground break-all">
                          {order.slip_url}
                        </p>
                      )}
                    </div>
                  )}

                  {/* Action buttons */}
                  {order.status === "pending" && (
                    <div className="flex gap-2 pt-2">
                      <Button
                        className="flex-1 bg-brand hover:bg-brand-light text-white gap-1"
                        disabled={processing === order.id}
                        onClick={() => handleAction(order.id, "approve")}
                      >
                        {processing === order.id ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <CheckCircle className="h-4 w-4" />
                        )}
                        อนุมัติ
                      </Button>
                      <Button
                        variant="outline"
                        className="flex-1 text-destructive border-destructive/30 gap-1"
                        disabled={processing === order.id}
                        onClick={() => handleAction(order.id, "reject")}
                      >
                        <XCircle className="h-4 w-4" />
                        ปฏิเสธ
                      </Button>
                    </div>
                  )}
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
