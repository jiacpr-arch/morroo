"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { ChevronLeft, Users, GraduationCap, Award, ClipboardCheck, RefreshCw, BarChart3 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";

interface ModeCount {
  course_mode: string;
  [key: string]: unknown;
}
interface AdminStats {
  students_total: number;
  classes_total: number;
  classes_active: number;
  students_by_mode: ModeCount[];
  classes_by_mode: ModeCount[];
  pre_test_passed: number;
  post_test_passed: number;
  certs_total: number;
  certs_by_mode: ModeCount[];
}

const MODES = [
  { key: "acls", label: "ACLS" },
  { key: "bls", label: "BLS" },
];

function byMode(arr: ModeCount[] | undefined, mode: string, field: string): number {
  const row = (arr || []).find((r) => r.course_mode === mode);
  return row ? Number(row[field] ?? 0) : 0;
}

// Overview stats for the ACLS/BLS course — totals + breakdown by course mode.
// Ported from acls-emr's src/pages/AdminStats.jsx.
export default function AdminAclsStatsPage() {
  const status = useAdminGate();
  const [stats, setStats] = useState<AdminStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await apiGet<AdminStats>("/api/admin/acls/stats");
      setStats(data);
    } catch (err) {
      setError(errMsg(err));
      setStats(null);
    }
    setLoading(false);
  };

  useEffect(() => {
    if (status === "ok") load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [status]);

  if (status !== "ok") return <AdminGateScreen status={status} />;

  const cards = [
    { label: "นักเรียนทั้งหมด", value: stats?.students_total, Icon: Users, tone: "text-blue-600" },
    {
      label: "คลาสทั้งหมด",
      value: stats?.classes_total,
      sub: stats != null ? `กำลังเปิด ${stats.classes_active}` : null,
      Icon: GraduationCap,
      tone: "text-foreground",
    },
    { label: "ผ่าน Post-test", value: stats?.post_test_passed, Icon: ClipboardCheck, tone: "text-green-600" },
    { label: "ใบประกาศนียบัตรที่ออก", value: stats?.certs_total, Icon: Award, tone: "text-amber-600" },
  ];

  return (
    <div className="mx-auto max-w-2xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="flex items-center gap-3">
        <div className="w-11 h-11 rounded-md bg-blue-100 text-blue-600 flex items-center justify-center">
          <BarChart3 className="h-5 w-5" />
        </div>
        <div className="flex-1">
          <h1 className="text-2xl font-bold">สถิติผู้เรียน</h1>
          <p className="text-sm text-muted-foreground">ภาพรวมทุกคลาส (ACLS + BLS)</p>
        </div>
        <Button size="sm" variant="ghost" disabled={loading} onClick={load}>
          <RefreshCw className={`h-3.5 w-3.5 mr-1 ${loading ? "animate-spin" : ""}`} /> รีเฟรช
        </Button>
      </div>

      {error && <div className="border rounded-md bg-destructive/10 border-destructive/30 text-sm text-destructive p-3">โหลดสถิติไม่สำเร็จ: {error}</div>}

      <div className="grid grid-cols-2 gap-2">
        {cards.map(({ label, value, sub, Icon, tone }) => (
          <div key={label} className="border rounded-md p-4">
            <div className="flex items-center gap-1.5 text-muted-foreground">
              <Icon className="h-3.5 w-3.5" />
              <span className="text-xs">{label}</span>
            </div>
            <div className={`text-3xl font-bold tabular-nums mt-1 ${tone}`}>{loading || value == null ? "—" : value}</div>
            {sub && <div className="text-xs text-muted-foreground mt-0.5">{sub}</div>}
          </div>
        ))}
      </div>

      <div className="border rounded-md overflow-x-auto">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-muted-foreground">
            <tr>
              <th className="px-3 py-2 text-left">คอร์ส</th>
              <th className="px-3 py-2 text-center">นักเรียน</th>
              <th className="px-3 py-2 text-center">คลาส</th>
              <th className="px-3 py-2 text-center">ใบประกาศนียบัตร</th>
            </tr>
          </thead>
          <tbody>
            {MODES.map(({ key, label }) => (
              <tr key={key} className="border-t">
                <td className="px-3 py-2 font-bold">{label}</td>
                <td className="px-3 py-2 text-center text-muted-foreground">{loading ? "—" : byMode(stats?.students_by_mode, key, "students")}</td>
                <td className="px-3 py-2 text-center text-muted-foreground">{loading ? "—" : byMode(stats?.classes_by_mode, key, "classes")}</td>
                <td className="px-3 py-2 text-center text-muted-foreground">{loading ? "—" : byMode(stats?.certs_by_mode, key, "certs")}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="border rounded-md bg-blue-50/50 border-blue-200 text-sm text-muted-foreground p-3">
        นับเฉพาะนักเรียนที่เข้าคลาสด้วยรหัสคลาส (class code) — คนที่เรียนโดยไม่กรอกรหัสจะไม่ถูกนับ
        ส่วน &quot;ใบประกาศนียบัตรที่ออก&quot; นับทุกใบที่ออกในแอป ไม่ว่าจะเข้าคลาสหรือไม่
      </div>
    </div>
  );
}
