"use client";

import { useState, useEffect, useMemo } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  Shield,
  Loader2,
  Users,
  Target,
  Activity,
  TrendingDown,
  Search,
  Download,
  ArrowUpDown,
  ChevronLeft,
  Eye,
  WifiOff,
} from "lucide-react";

interface AdminOverallStats {
  total_students: number;
  active_students_7d: number;
  avg_accuracy: number;
  total_attempts: number;
  weakest_subject_name_th: string | null;
  weakest_subject_icon: string | null;
  weakest_subject_accuracy: number | null;
}

interface StudentOverview {
  user_id: string;
  user_name: string;
  user_email: string;
  membership_type: string;
  total_attempts: number;
  correct_count: number;
  accuracy: number;
  last_active: string;
}

type SortKey = "user_name" | "total_attempts" | "accuracy" | "last_active";
type MembershipFilter = "all" | "free" | "monthly" | "yearly" | "bundle";

const INACTIVE_DAYS = 7;

function isInactive(last_active: string): boolean {
  const diff =
    (Date.now() - new Date(last_active).getTime()) / (1000 * 60 * 60 * 24);
  return diff > INACTIVE_DAYS;
}

export default function AdminStudentsPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [overallStats, setOverallStats] = useState<AdminOverallStats | null>(null);
  const [students, setStudents] = useState<StudentOverview[]>([]);

  // Filters
  const [search, setSearch] = useState("");
  const [membershipFilter, setMembershipFilter] = useState<MembershipFilter>("all");
  const [activeOnly, setActiveOnly] = useState(false);
  const [inactiveOnly, setInactiveOnly] = useState(false);
  const [minAccuracy, setMinAccuracy] = useState(0);
  const [maxAccuracy, setMaxAccuracy] = useState(100);

  // Sort
  const [sortKey, setSortKey] = useState<SortKey>("last_active");
  const [sortAsc, setSortAsc] = useState(false);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);
      const [statsRes, studentsRes] = await Promise.all([
        supabase.rpc("get_admin_overall_stats"),
        supabase.rpc("get_admin_students_overview"),
      ]);
      const statsRows = statsRes.data as AdminOverallStats[];
      setOverallStats(statsRows?.[0] || null);
      setStudents((studentsRes.data as StudentOverview[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  const filtered = useMemo(() => {
    let list = students;

    if (search) {
      const q = search.toLowerCase();
      list = list.filter(
        (s) =>
          s.user_name?.toLowerCase().includes(q) ||
          s.user_email?.toLowerCase().includes(q)
      );
    }
    if (membershipFilter !== "all") {
      list = list.filter((s) => s.membership_type === membershipFilter);
    }
    if (activeOnly) {
      list = list.filter((s) => !isInactive(s.last_active));
    }
    if (inactiveOnly) {
      list = list.filter((s) => isInactive(s.last_active));
    }
    list = list.filter(
      (s) => s.accuracy >= minAccuracy && s.accuracy <= maxAccuracy
    );

    list = [...list].sort((a, b) => {
      let va: string | number = a[sortKey] ?? "";
      let vb: string | number = b[sortKey] ?? "";
      if (sortKey === "last_active") {
        va = new Date(va as string).getTime();
        vb = new Date(vb as string).getTime();
      }
      if (va < vb) return sortAsc ? -1 : 1;
      if (va > vb) return sortAsc ? 1 : -1;
      return 0;
    });
    return list;
  }, [students, search, membershipFilter, activeOnly, inactiveOnly, minAccuracy, maxAccuracy, sortKey, sortAsc]);

  function handleSort(key: SortKey) {
    if (sortKey === key) setSortAsc(!sortAsc);
    else { setSortKey(key); setSortAsc(false); }
  }

  function exportCSV() {
    const header = ["ชื่อ", "อีเมล", "สมาชิก", "ข้อที่ทำ", "ถูกต้อง", "Accuracy%", "ใช้งานล่าสุด", "สถานะ"];
    const rows = filtered.map((s) => [
      s.user_name || "-",
      s.user_email || "-",
      s.membership_type,
      s.total_attempts,
      s.correct_count,
      s.accuracy,
      s.last_active ? new Date(s.last_active).toLocaleDateString("th-TH") : "-",
      isInactive(s.last_active) ? "Inactive" : "Active",
    ]);
    const csv = "\uFEFF" + [header, ...rows].map((r) => r.join(",")).join("\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `morroo-students-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

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

  const membershipLabel: Record<string, string> = {
    free: "Free", monthly: "Monthly", yearly: "Yearly", bundle: "Bundle",
  };
  const membershipOptions: MembershipFilter[] = ["all", "free", "monthly", "yearly", "bundle"];

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin">
          <Button variant="ghost" size="sm">
            <ChevronLeft className="h-4 w-4 mr-1" />Admin
          </Button>
        </Link>
      </div>

      <div className="mb-8">
        <h1 className="text-2xl font-bold">ติดตามนักเรียน</h1>
        <p className="text-muted-foreground mt-1">ดูสถิติและผลการเรียนของนักเรียนทุกคน</p>
      </div>

      {/* Overall Stats */}
      {overallStats && (
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-blue-100 flex items-center justify-center">
                  <Users className="h-5 w-5 text-blue-600" />
                </div>
                <div>
                  <p className="text-2xl font-bold">{overallStats.total_students}</p>
                  <p className="text-xs text-muted-foreground">นักเรียนที่ทำข้อสอบ</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-green-100 flex items-center justify-center">
                  <Activity className="h-5 w-5 text-green-600" />
                </div>
                <div>
                  <p className="text-2xl font-bold">{overallStats.active_students_7d}</p>
                  <p className="text-xs text-muted-foreground">Active 7 วัน</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="pt-6">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-purple-100 flex items-center justify-center">
                  <Target className="h-5 w-5 text-purple-600" />
                </div>
                <div>
                  <p className="text-2xl font-bold">{overallStats.avg_accuracy ?? 0}%</p>
                  <p className="text-xs text-muted-foreground">Accuracy เฉลี่ย</p>
                </div>
              </div>
            </CardContent>
          </Card>
          {overallStats.weakest_subject_name_th && (
            <Card className="border-red-200">
              <CardContent className="pt-6">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-red-100 flex items-center justify-center">
                    <TrendingDown className="h-5 w-5 text-red-600" />
                  </div>
                  <div>
                    <p className="text-sm font-bold">
                      {overallStats.weakest_subject_icon} {overallStats.weakest_subject_accuracy}%
                    </p>
                    <p className="text-xs text-muted-foreground truncate">
                      {overallStats.weakest_subject_name_th}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      )}

      {/* Filter bar */}
      <div className="flex flex-wrap items-center gap-3 mb-4">
        {/* Search */}
        <div className="relative flex-1 min-w-[180px] max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="ค้นหาชื่อหรืออีเมล..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-9 h-9"
          />
        </div>

        {/* Membership filter */}
        <div className="flex rounded-md border overflow-hidden">
          {membershipOptions.map((m) => (
            <button
              key={m}
              onClick={() => setMembershipFilter(m)}
              className={`px-3 py-1.5 text-xs font-medium transition-colors ${
                membershipFilter === m
                  ? "bg-brand text-white"
                  : "bg-white text-muted-foreground hover:bg-muted"
              }`}
            >
              {m === "all" ? "ทั้งหมด" : membershipLabel[m]}
            </button>
          ))}
        </div>

        {/* Active / Inactive toggle */}
        <div className="flex rounded-md border overflow-hidden">
          <button
            onClick={() => { setActiveOnly(!activeOnly); setInactiveOnly(false); }}
            className={`px-3 py-1.5 text-xs font-medium transition-colors ${
              activeOnly ? "bg-green-600 text-white" : "bg-white text-muted-foreground hover:bg-muted"
            }`}
          >
            Active
          </button>
          <button
            onClick={() => { setInactiveOnly(!inactiveOnly); setActiveOnly(false); }}
            className={`px-3 py-1.5 text-xs font-medium transition-colors ${
              inactiveOnly ? "bg-red-600 text-white" : "bg-white text-muted-foreground hover:bg-muted"
            }`}
          >
            Inactive
          </button>
        </div>

        {/* Accuracy range */}
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <span>Acc:</span>
          <input
            type="number"
            min={0} max={100} value={minAccuracy}
            onChange={(e) => setMinAccuracy(Number(e.target.value))}
            className="w-12 border rounded px-1 py-1 text-xs text-center"
          />
          <span>–</span>
          <input
            type="number"
            min={0} max={100} value={maxAccuracy}
            onChange={(e) => setMaxAccuracy(Number(e.target.value))}
            className="w-12 border rounded px-1 py-1 text-xs text-center"
          />
          <span>%</span>
        </div>

        <Button variant="outline" size="sm" onClick={exportCSV} className="ml-auto">
          <Download className="h-4 w-4 mr-1" />Export CSV
        </Button>
      </div>

      {/* Students Table */}
      <div className="rounded-lg border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b bg-muted/50">
                <th className="text-left p-3 text-xs font-medium text-muted-foreground">
                  <button onClick={() => handleSort("user_name")} className="flex items-center gap-1 hover:text-foreground">
                    ชื่อ <ArrowUpDown className="h-3 w-3" />
                  </button>
                </th>
                <th className="text-left p-3 text-xs font-medium text-muted-foreground hidden sm:table-cell">สมาชิก</th>
                <th className="text-right p-3 text-xs font-medium text-muted-foreground">
                  <button onClick={() => handleSort("total_attempts")} className="flex items-center gap-1 ml-auto hover:text-foreground">
                    ข้อที่ทำ <ArrowUpDown className="h-3 w-3" />
                  </button>
                </th>
                <th className="text-right p-3 text-xs font-medium text-muted-foreground">
                  <button onClick={() => handleSort("accuracy")} className="flex items-center gap-1 ml-auto hover:text-foreground">
                    Accuracy <ArrowUpDown className="h-3 w-3" />
                  </button>
                </th>
                <th className="text-right p-3 text-xs font-medium text-muted-foreground hidden md:table-cell">
                  <button onClick={() => handleSort("last_active")} className="flex items-center gap-1 ml-auto hover:text-foreground">
                    ใช้งานล่าสุด <ArrowUpDown className="h-3 w-3" />
                  </button>
                </th>
                <th className="p-3 w-10" />
              </tr>
            </thead>
            <tbody>
              {filtered.map((student) => {
                const inactive = isInactive(student.last_active);
                return (
                  <tr key={student.user_id} className="border-b last:border-0 hover:bg-muted/30">
                    <td className="p-3">
                      <div className="flex items-center gap-2">
                        <div>
                          <p className="text-sm font-medium">{student.user_name || "-"}</p>
                          <p className="text-xs text-muted-foreground">{student.user_email}</p>
                        </div>
                        {inactive && (
                          <Badge variant="outline" className="text-[10px] border-red-200 text-red-500 gap-1 py-0">
                            <WifiOff className="h-2.5 w-2.5" />Inactive
                          </Badge>
                        )}
                      </div>
                    </td>
                    <td className="p-3 hidden sm:table-cell">
                      <Badge
                        variant={student.membership_type === "free" ? "secondary" : "default"}
                        className="text-xs"
                      >
                        {membershipLabel[student.membership_type] || student.membership_type}
                      </Badge>
                    </td>
                    <td className="p-3 text-right text-sm">{student.total_attempts}</td>
                    <td className="p-3 text-right">
                      <span className={`text-sm font-bold ${
                        student.accuracy >= 80 ? "text-green-600"
                        : student.accuracy >= 60 ? "text-yellow-600"
                        : "text-red-600"
                      }`}>
                        {student.accuracy}%
                      </span>
                    </td>
                    <td className="p-3 text-right text-xs text-muted-foreground hidden md:table-cell">
                      {student.last_active
                        ? new Date(student.last_active).toLocaleDateString("th-TH", {
                            day: "numeric", month: "short",
                          })
                        : "-"}
                    </td>
                    <td className="p-3">
                      <Link href={`/admin/students/${student.user_id}`}>
                        <Button size="icon" variant="ghost" className="h-8 w-8">
                          <Eye className="h-4 w-4" />
                        </Button>
                      </Link>
                    </td>
                  </tr>
                );
              })}
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={6} className="p-8 text-center text-muted-foreground">ไม่พบนักเรียน</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <p className="text-xs text-muted-foreground mt-3 text-right">
        แสดง {filtered.length} / {students.length} คน
      </p>
    </div>
  );
}
