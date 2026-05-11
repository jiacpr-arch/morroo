"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import {
  ArrowLeft,
  Loader2,
  Shield,
  TrendingUp,
  Users,
  DollarSign,
  Target,
  ChevronRight,
} from "lucide-react";

type LeadStage =
  | "new"
  | "contacted"
  | "code_issued"
  | "registered"
  | "redeemed"
  | "paid"
  | "dropped";

type StageStat = { stage: LeadStage; count: number };
type SourceStat = { source: string; count: number; paid: number };
type RecentPaidLead = {
  id: string;
  name: string | null;
  email: string | null;
  source: string;
  campaign: string | null;
  created_at: string;
};

const STAGE_ORDER: LeadStage[] = [
  "new",
  "contacted",
  "code_issued",
  "registered",
  "redeemed",
  "paid",
];

const STAGE_LABEL: Record<LeadStage, string> = {
  new: "ใหม่",
  contacted: "ติดต่อแล้ว",
  code_issued: "ออกโค้ด",
  registered: "ลงทะเบียน",
  redeemed: "ใช้โค้ด",
  paid: "ชำระเงิน",
  dropped: "หลุด",
};

const STAGE_COLOR: Record<LeadStage, string> = {
  new: "bg-slate-100 text-slate-700",
  contacted: "bg-blue-100 text-blue-700",
  code_issued: "bg-yellow-100 text-yellow-700",
  registered: "bg-purple-100 text-purple-700",
  redeemed: "bg-teal-100 text-teal-700",
  paid: "bg-green-100 text-green-700",
  dropped: "bg-red-100 text-red-700",
};

const SOURCE_LABEL: Record<string, string> = {
  fb_leadgen_form: "FB Lead Form",
  fb_messenger: "FB Messenger",
  line_oa: "LINE OA",
  landing: "Landing Page",
  organic: "Organic",
  admin: "Admin",
};

export default function CrmDashboard() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [stageStats, setStageStats] = useState<StageStat[]>([]);
  const [sourceStats, setSourceStats] = useState<SourceStat[]>([]);
  const [recentPaid, setRecentPaid] = useState<RecentPaidLead[]>([]);
  const [totalLeads, setTotalLeads] = useState(0);
  const [totalPaid, setTotalPaid] = useState(0);
  const [totalDropped, setTotalDropped] = useState(0);

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

    // Fetch all lead stage counts
    const { data: allLeads } = await supabase
      .from("leads")
      .select("stage, source, campaign, name, email, created_at, id");

    const leads = allLeads ?? [];
    setTotalLeads(leads.length);

    // Stage distribution
    const stageCounts: Record<string, number> = {};
    for (const l of leads) {
      stageCounts[l.stage] = (stageCounts[l.stage] ?? 0) + 1;
    }
    const stages: StageStat[] = Object.entries(stageCounts).map(([stage, count]) => ({
      stage: stage as LeadStage,
      count,
    }));
    setStageStats(stages);
    setTotalPaid(stageCounts["paid"] ?? 0);
    setTotalDropped(stageCounts["dropped"] ?? 0);

    // Source breakdown
    const sourceMap: Record<string, { count: number; paid: number }> = {};
    for (const l of leads) {
      if (!sourceMap[l.source]) sourceMap[l.source] = { count: 0, paid: 0 };
      sourceMap[l.source].count++;
      if (l.stage === "paid") sourceMap[l.source].paid++;
    }
    setSourceStats(
      Object.entries(sourceMap)
        .map(([source, v]) => ({ source, ...v }))
        .sort((a, b) => b.count - a.count)
    );

    // Recent paid leads
    const paid = leads
      .filter((l) => l.stage === "paid")
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      .slice(0, 10);
    setRecentPaid(paid as RecentPaidLead[]);

    setLoading(false);
  }, [router]);

  useEffect(() => {
    load();
  }, [load]);

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

  const paidCount = stageStats.find((s) => s.stage === "paid")?.count ?? 0;
  const overallConversion =
    totalLeads > 0 ? ((paidCount / totalLeads) * 100).toFixed(1) : "0.0";

  // Funnel conversion rates between adjacent stages
  const funnelRates: { from: string; to: string; rate: string }[] = [];
  for (let i = 0; i < STAGE_ORDER.length - 1; i++) {
    const fromStage = STAGE_ORDER[i];
    const toStage = STAGE_ORDER[i + 1];
    const fromCount =
      stageStats
        .filter((s) => STAGE_ORDER.indexOf(s.stage) >= i)
        .reduce((acc, s) => acc + s.count, 0) + (stageStats.find((s) => s.stage === "dropped")?.count ?? 0);
    const toCount =
      stageStats
        .filter((s) => STAGE_ORDER.indexOf(s.stage) >= i + 1)
        .reduce((acc, s) => acc + s.count, 0);
    const rate = fromCount > 0 ? ((toCount / fromCount) * 100).toFixed(0) : "—";
    funnelRates.push({ from: STAGE_LABEL[fromStage], to: STAGE_LABEL[toStage], rate });
  }

  return (
    <div className="min-h-screen bg-gray-50 p-6 space-y-6">
      <div className="flex items-center gap-3">
        <Link href="/admin">
          <Button variant="ghost" size="sm">
            <ArrowLeft className="h-4 w-4 mr-1" />
            Admin
          </Button>
        </Link>
        <h1 className="text-2xl font-bold">CRM Dashboard</h1>
      </div>

      {/* KPI cards */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        <Card>
          <CardContent className="pt-5">
            <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
              <Users className="h-4 w-4" /> Lead ทั้งหมด
            </div>
            <p className="text-3xl font-bold">{totalLeads.toLocaleString()}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
              <DollarSign className="h-4 w-4" /> ชำระเงินแล้ว
            </div>
            <p className="text-3xl font-bold text-green-600">{totalPaid.toLocaleString()}</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
              <TrendingUp className="h-4 w-4" /> Conversion Rate
            </div>
            <p className="text-3xl font-bold text-brand">{overallConversion}%</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="flex items-center gap-2 text-muted-foreground text-sm mb-1">
              <Target className="h-4 w-4" /> หลุด
            </div>
            <p className="text-3xl font-bold text-red-500">{totalDropped.toLocaleString()}</p>
          </CardContent>
        </Card>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Stage funnel */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Lead Pipeline Funnel</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {STAGE_ORDER.map((stage) => {
              const count = stageStats.find((s) => s.stage === stage)?.count ?? 0;
              const pct = totalLeads > 0 ? (count / totalLeads) * 100 : 0;
              return (
                <div key={stage} className="flex items-center gap-3">
                  <span className="w-24 text-sm text-right text-muted-foreground">
                    {STAGE_LABEL[stage]}
                  </span>
                  <div className="flex-1 bg-gray-100 rounded-full h-5 overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all ${
                        stage === "paid"
                          ? "bg-green-500"
                          : stage === "dropped"
                          ? "bg-red-400"
                          : "bg-brand/70"
                      }`}
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <span className="w-12 text-sm font-medium text-right">{count}</span>
                  <span className="w-12 text-xs text-muted-foreground text-right">
                    {pct.toFixed(0)}%
                  </span>
                </div>
              );
            })}
            {/* Dropped separately */}
            {(() => {
              const count = stageStats.find((s) => s.stage === "dropped")?.count ?? 0;
              const pct = totalLeads > 0 ? (count / totalLeads) * 100 : 0;
              return (
                <div className="flex items-center gap-3 opacity-60">
                  <span className="w-24 text-sm text-right text-muted-foreground">หลุด</span>
                  <div className="flex-1 bg-gray-100 rounded-full h-5 overflow-hidden">
                    <div
                      className="h-full rounded-full bg-red-300"
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                  <span className="w-12 text-sm font-medium text-right">{count}</span>
                  <span className="w-12 text-xs text-muted-foreground text-right">
                    {pct.toFixed(0)}%
                  </span>
                </div>
              );
            })()}
          </CardContent>
        </Card>

        {/* Source breakdown */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Lead ตามแหล่งที่มา</CardTitle>
          </CardHeader>
          <CardContent>
            <table className="w-full text-sm">
              <thead>
                <tr className="text-muted-foreground border-b">
                  <th className="text-left pb-2">แหล่งที่มา</th>
                  <th className="text-right pb-2">Lead</th>
                  <th className="text-right pb-2">ชำระ</th>
                  <th className="text-right pb-2">Conv.</th>
                </tr>
              </thead>
              <tbody>
                {sourceStats.map((s) => (
                  <tr key={s.source} className="border-b last:border-0">
                    <td className="py-2">
                      {SOURCE_LABEL[s.source] ?? s.source}
                    </td>
                    <td className="text-right py-2">{s.count}</td>
                    <td className="text-right py-2 text-green-600 font-medium">{s.paid}</td>
                    <td className="text-right py-2 text-muted-foreground">
                      {s.count > 0 ? ((s.paid / s.count) * 100).toFixed(0) : 0}%
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </CardContent>
        </Card>
      </div>

      {/* Stage-to-stage conversion rates */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base">อัตราการแปลงระหว่าง Stage</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-wrap gap-3 items-center">
            {funnelRates.map((r, i) => (
              <div key={i} className="flex items-center gap-2 text-sm">
                <span className="text-muted-foreground">{r.from}</span>
                <ChevronRight className="h-3 w-3 text-muted-foreground" />
                <span className="font-semibold">{r.to}</span>
                <Badge variant="secondary">{r.rate}%</Badge>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Recent paid leads */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-base">Lead ที่ชำระเงินล่าสุด</CardTitle>
          <Link href="/admin/leads">
            <Button variant="outline" size="sm">
              ดูทั้งหมด
            </Button>
          </Link>
        </CardHeader>
        <CardContent>
          {recentPaid.length === 0 ? (
            <p className="text-muted-foreground text-sm">ยังไม่มีข้อมูล</p>
          ) : (
            <div className="space-y-2">
              {recentPaid.map((lead) => (
                <div
                  key={lead.id}
                  className="flex items-center justify-between py-2 border-b last:border-0"
                >
                  <div>
                    <p className="font-medium text-sm">{lead.name ?? lead.email ?? "—"}</p>
                    <p className="text-xs text-muted-foreground">
                      {SOURCE_LABEL[lead.source] ?? lead.source}
                      {lead.campaign ? ` · ${lead.campaign}` : ""}
                    </p>
                  </div>
                  <div className="text-right">
                    <Badge className={STAGE_COLOR["paid"]}>ชำระเงิน</Badge>
                    <p className="text-xs text-muted-foreground mt-1">
                      {new Date(lead.created_at).toLocaleDateString("th-TH")}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
