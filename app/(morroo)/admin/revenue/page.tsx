"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import {
  Shield,
  Loader2,
  ArrowLeft,
  TrendingUp,
  Users,
  DollarSign,
  Calendar,
} from "lucide-react";

interface DailyRevenue {
  date: string;
  amount: number;
  count: number;
}

interface PlanBreakdown {
  plan_type: string;
  count: number;
  total: number;
}

export default function RevenueDashboard() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [period, setPeriod] = useState<"7d" | "30d" | "90d">("30d");

  const [totalRevenue, setTotalRevenue] = useState(0);
  const [totalOrders, setTotalOrders] = useState(0);
  const [newMembers, setNewMembers] = useState(0);
  const [dailyData, setDailyData] = useState<DailyRevenue[]>([]);
  const [planBreakdown, setPlanBreakdown] = useState<PlanBreakdown[]>([]);

  const periodDays = period === "7d" ? 7 : period === "30d" ? 30 : 90;

  const loadData = useCallback(async () => {
    const supabase = createClient();
    const since = new Date(Date.now() - periodDays * 86400_000).toISOString();

    // Total revenue & orders in period
    const { data: orders } = await supabase
      .from("payment_orders")
      .select("amount, plan_type, created_at")
      .eq("status", "approved")
      .gte("created_at", since);

    if (orders) {
      setTotalRevenue(orders.reduce((sum: number, o: { amount: number }) => sum + Number(o.amount), 0));
      setTotalOrders(orders.length);

      // Daily breakdown
      const byDate: Record<string, { amount: number; count: number }> = {};
      for (const o of orders) {
        const d = o.created_at.slice(0, 10);
        if (!byDate[d]) byDate[d] = { amount: 0, count: 0 };
        byDate[d].amount += Number(o.amount);
        byDate[d].count++;
      }
      const daily = Object.entries(byDate)
        .map(([date, v]) => ({ date, ...v }))
        .sort((a, b) => a.date.localeCompare(b.date));
      setDailyData(daily);

      // Plan breakdown
      const byPlan: Record<string, { count: number; total: number }> = {};
      for (const o of orders) {
        const p = o.plan_type;
        if (!byPlan[p]) byPlan[p] = { count: 0, total: 0 };
        byPlan[p].count++;
        byPlan[p].total += Number(o.amount);
      }
      setPlanBreakdown(
        Object.entries(byPlan)
          .map(([plan_type, v]) => ({ plan_type, ...v }))
          .sort((a, b) => b.total - a.total)
      );
    }

    // New members
    const { count } = await supabase
      .from("profiles")
      .select("id", { count: "exact", head: true })
      .neq("membership_type", "free")
      .gte("created_at", since);
    setNewMembers(count ?? 0);
  }, [periodDays]);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);
      await loadData();
      setLoading(false);
    }
    init();
  }, [router, loadData]);

  // Reload data when period changes — loadData is already called
  // inside the init effect on first mount. This handles subsequent
  // period changes without triggering the eslint set-state-in-effect rule.
  const [prevPeriod, setPrevPeriod] = useState(period);
  if (period !== prevPeriod) {
    setPrevPeriod(period);
    if (isAdmin) loadData();
  }

  const fmt = (n: number) => n.toLocaleString("th-TH", { minimumFractionDigits: 0 });

  const planLabels: Record<string, string> = {
    monthly: "รายเดือน",
    yearly: "รายปี",
    bundle: "ชุดข้อสอบ",
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

  const maxAmount = Math.max(...dailyData.map((d) => d.amount), 1);

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="mb-8">
        <Link
          href="/admin"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-brand mb-2"
        >
          <ArrowLeft className="h-4 w-4" /> Admin Dashboard
        </Link>
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold">รายได้</h1>
          <div className="flex gap-2">
            {(["7d", "30d", "90d"] as const).map((p) => (
              <button
                key={p}
                onClick={() => setPeriod(p)}
                className={`px-3 py-1 rounded-md text-sm ${
                  period === p
                    ? "bg-brand text-white"
                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                }`}
              >
                {p === "7d" ? "7 วัน" : p === "30d" ? "30 วัน" : "90 วัน"}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8">
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-green-100 flex items-center justify-center">
                <DollarSign className="h-6 w-6 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">฿{fmt(totalRevenue)}</p>
                <p className="text-sm text-muted-foreground">รายได้รวม</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-blue-100 flex items-center justify-center">
                <TrendingUp className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{totalOrders}</p>
                <p className="text-sm text-muted-foreground">ออเดอร์</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-6">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-lg bg-purple-100 flex items-center justify-center">
                <Users className="h-6 w-6 text-purple-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{newMembers}</p>
                <p className="text-sm text-muted-foreground">สมาชิกใหม่</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Daily Revenue Chart (simple bar chart) */}
      <Card className="mb-8">
        <CardContent className="pt-6">
          <h2 className="font-semibold mb-4 flex items-center gap-2">
            <Calendar className="h-5 w-5" /> รายได้รายวัน
          </h2>
          {dailyData.length === 0 ? (
            <p className="text-muted-foreground text-center py-8">ไม่มีข้อมูลในช่วงนี้</p>
          ) : (
            <div className="space-y-2">
              {dailyData.map((d) => (
                <div key={d.date} className="flex items-center gap-3 text-sm">
                  <span className="w-24 text-muted-foreground shrink-0">
                    {new Date(d.date).toLocaleDateString("th-TH", { month: "short", day: "numeric" })}
                  </span>
                  <div className="flex-1 bg-gray-100 rounded-full h-6 overflow-hidden">
                    <div
                      className="bg-brand h-6 rounded-full flex items-center justify-end px-2"
                      style={{ width: `${Math.max((d.amount / maxAmount) * 100, 8)}%` }}
                    >
                      <span className="text-xs text-white font-medium whitespace-nowrap">
                        ฿{fmt(d.amount)}
                      </span>
                    </div>
                  </div>
                  <span className="text-muted-foreground w-16 text-right shrink-0">
                    {d.count} รายการ
                  </span>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Plan Breakdown */}
      <Card>
        <CardContent className="pt-6">
          <h2 className="font-semibold mb-4">สัดส่วนแพ็กเกจ</h2>
          {planBreakdown.length === 0 ? (
            <p className="text-muted-foreground text-center py-8">ไม่มีข้อมูล</p>
          ) : (
            <div className="space-y-4">
              {planBreakdown.map((p) => (
                <div key={p.plan_type} className="flex items-center justify-between">
                  <div>
                    <p className="font-medium">{planLabels[p.plan_type] ?? p.plan_type}</p>
                    <p className="text-sm text-muted-foreground">{p.count} ออเดอร์</p>
                  </div>
                  <p className="text-lg font-bold text-brand">฿{fmt(p.total)}</p>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
