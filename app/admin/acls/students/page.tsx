"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, Users, Search, Download, RefreshCw, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { apiGet, errMsg } from "@/components/admin/acls/api-client";

interface RosterRow {
  id: string;
  name: string | null;
  phone: string | null;
  email: string | null;
  student_id: string | null;
  class_name: string | null;
  class_code: string | null;
  course_mode: string | null;
  created_at: string | null;
  pre_test_passed: boolean;
  post_test_passed: boolean;
}

function fmtDate(iso: string | null): string {
  if (!iso) return "-";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "-";
  return d.toLocaleDateString("th-TH", { day: "2-digit", month: "short", year: "numeric" });
}

// Full ACLS/BLS student roster across all classes — search + CSV export.
// Distinct from morroo's own /admin/students (main product students).
// Ported from acls-emr's src/pages/AdminStudents.jsx.
export default function AdminAclsStudentsPage() {
  const status = useAdminGate();
  const [rows, setRows] = useState<RosterRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const { students } = await apiGet<{ students: RosterRow[] }>("/api/admin/acls/students");
      setRows(students || []);
    } catch (err) {
      setError(errMsg(err));
      setRows([]);
    }
    setLoading(false);
  };

  useEffect(() => {
    if (status === "ok") load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [status]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return rows;
    return rows.filter((r) =>
      [r.name, r.phone, r.email, r.class_name, r.class_code, r.student_id].some((v) => String(v || "").toLowerCase().includes(q)),
    );
  }, [rows, query]);

  const downloadCSV = () => {
    const header = ["ชื่อ", "เบอร์โทร", "อีเมล", "รหัสนักเรียน", "คลาส", "รหัสคลาส", "คอร์ส", "Pre-test", "Post-test", "เข้าเมื่อ"];
    const lines = filtered.map((r) => [
      r.name, r.phone, r.email, r.student_id, r.class_name, r.class_code,
      String(r.course_mode || "").toUpperCase(),
      r.pre_test_passed ? "ผ่าน" : "-",
      r.post_test_passed ? "ผ่าน" : "-",
      r.created_at ? r.created_at.slice(0, 10) : "",
    ]);
    const csv = [header, ...lines].map((row) => row.map((cell) => `"${String(cell ?? "").replace(/"/g, '""')}"`).join(",")).join("\n");
    const blob = new Blob(["﻿" + csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `acls-students-${new Date().toISOString().slice(0, 10)}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  };

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="flex items-center gap-3">
        <div className="w-11 h-11 rounded-md bg-blue-100 text-blue-600 flex items-center justify-center">
          <Users className="h-5 w-5" />
        </div>
        <div className="flex-1">
          <h1 className="text-2xl font-bold">รายชื่อนักเรียน (ACLS/BLS)</h1>
          <p className="text-sm text-muted-foreground">{loading ? "กำลังโหลด…" : `รวม ${rows.length} คน ทุกคลาส`}</p>
        </div>
        <Button size="sm" variant="ghost" disabled={loading} onClick={load}>
          <RefreshCw className={`h-3.5 w-3.5 mr-1 ${loading ? "animate-spin" : ""}`} /> รีเฟรช
        </Button>
      </div>

      {error && <div className="border rounded-md bg-destructive/10 border-destructive/30 text-sm text-destructive p-3">โหลดรายชื่อไม่สำเร็จ: {error}</div>}

      <div className="flex items-center gap-2">
        <div className="flex-1 inline-flex items-center gap-2 border rounded-md py-1.5 px-3">
          <Search className="h-4 w-4 text-muted-foreground shrink-0" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="ค้นหา ชื่อ / เบอร์ / คลาส"
            className="w-full bg-transparent text-sm outline-none"
          />
        </div>
        <Button size="sm" disabled={!filtered.length} onClick={downloadCSV}>
          <Download className="h-3.5 w-3.5 mr-1" /> CSV
        </Button>
      </div>

      <div className="border rounded-md overflow-x-auto">
        <table className="w-full text-sm whitespace-nowrap">
          <thead className="bg-muted/50 text-muted-foreground">
            <tr>
              <th className="px-3 py-2 text-left">ชื่อ</th>
              <th className="px-3 py-2 text-left">เบอร์โทร</th>
              <th className="px-3 py-2 text-left">คลาส</th>
              <th className="px-3 py-2 text-center">คอร์ส</th>
              <th className="px-3 py-2 text-center">Post-test</th>
              <th className="px-3 py-2 text-left">เข้าเมื่อ</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={6} className="px-3 py-6 text-center text-muted-foreground">กำลังโหลด…</td>
              </tr>
            ) : filtered.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-3 py-6 text-center text-muted-foreground">
                  {rows.length === 0 ? "ยังไม่มีนักเรียน" : "ไม่พบรายการที่ค้นหา"}
                </td>
              </tr>
            ) : (
              filtered.map((r) => (
                <tr key={r.id} className="border-t">
                  <td className="px-3 py-2">{r.name || "-"}</td>
                  <td className="px-3 py-2 font-mono text-muted-foreground">{r.phone || "-"}</td>
                  <td className="px-3 py-2 text-muted-foreground">{r.class_name || "-"}</td>
                  <td className="px-3 py-2 text-center text-muted-foreground">{String(r.course_mode || "").toUpperCase()}</td>
                  <td className="px-3 py-2 text-center">
                    {r.post_test_passed ? <Check className="h-4 w-4 text-green-600 inline" /> : <span className="text-muted-foreground">—</span>}
                  </td>
                  <td className="px-3 py-2 text-muted-foreground">{fmtDate(r.created_at)}</td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <div className="border rounded-md bg-amber-50/50 border-amber-200 text-sm text-muted-foreground p-3">
        ข้อมูลส่วนบุคคล (ชื่อ–เบอร์โทร–อีเมล) — ใช้ภายในเพื่อการอบรมเท่านั้น (PDPA)
        · รวมนักเรียนทุกคน ทั้งที่เข้าคลาสด้วยรหัสคลาส และที่ทำ Pre/Post-test แบบเดี่ยว
      </div>
    </div>
  );
}
