"use client";

import { useEffect, useMemo, useState } from "react";
import Link from "next/link";
import { ChevronLeft, School, Search, RefreshCw, Copy, Check, Archive, ArchiveRestore } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAdminGate, AdminGateScreen } from "@/components/admin/acls/useAdminGate";
import { apiGet, apiPatch, errMsg } from "@/components/admin/acls/api-client";

interface ClassRow {
  id: string;
  code: string;
  instructor_code: string | null;
  name: string;
  course_mode: string;
  created_at: string;
  archived_at: string | null;
  student_count: number;
}

function fmtDate(iso: string | null): string {
  if (!iso) return "-";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "-";
  return d.toLocaleDateString("th-TH", { day: "2-digit", month: "short", year: "numeric" });
}

// Every cohort class with both codes + student count — recovery path when an
// instructor loses their codes, and where finished classes get archived.
// Ported from acls-emr's src/pages/AdminClasses.jsx.
export default function AdminAclsClassesPage() {
  const status = useAdminGate();
  const [rows, setRows] = useState<ClassRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [query, setQuery] = useState("");
  const [copied, setCopied] = useState<string | null>(null);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [showArchived, setShowArchived] = useState(false);

  const load = async () => {
    setLoading(true);
    setError(null);
    try {
      const { classes } = await apiGet<{ classes: ClassRow[] }>("/api/admin/acls/classes");
      setRows(classes || []);
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
    let list = showArchived ? rows : rows.filter((r) => !r.archived_at);
    if (q) {
      list = list.filter((r) => [r.name, r.code, r.instructor_code, r.course_mode].some((v) => String(v || "").toLowerCase().includes(q)));
    }
    return list;
  }, [rows, query, showArchived]);

  const copy = (key: string, text: string | null) => {
    if (!text) return;
    navigator.clipboard?.writeText(text);
    setCopied(key);
    setTimeout(() => setCopied((c) => (c === key ? null : c)), 1500);
  };

  const toggleArchive = async (r: ClassRow) => {
    const archiving = !r.archived_at;
    if (archiving && !confirm(`ปิดคลาส "${r.name}"?\nรหัสเข้าคลาสและรหัสอาจารย์จะใช้ไม่ได้จนกว่าจะเปิดคลาสอีกครั้ง (ข้อมูลไม่หาย)`)) {
      return;
    }
    setBusyId(r.id);
    try {
      await apiPatch(`/api/admin/acls/classes/${r.id}`, { archived: archiving });
      await load();
    } catch (err) {
      alert("ไม่สำเร็จ: " + errMsg(err));
    }
    setBusyId(null);
  };

  const CodeCell = ({ id, kind, value }: { id: string; kind: string; value: string | null }) => {
    const key = `${id}:${kind}`;
    if (!value) return <span className="text-muted-foreground">-</span>;
    return (
      <button onClick={() => copy(key, value)} className="inline-flex items-center gap-1 font-mono hover:text-blue-600" title="คัดลอก">
        {value}
        {copied === key ? <Check className="h-3 w-3 text-green-600" /> : <Copy className="h-3 w-3 text-muted-foreground" />}
      </button>
    );
  };

  if (status !== "ok") return <AdminGateScreen status={status} />;

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8 space-y-5">
      <Link href="/admin/acls" className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ChevronLeft className="h-4 w-4" /> กลับไป Admin
      </Link>

      <div className="flex items-center gap-3">
        <div className="w-11 h-11 rounded-md bg-blue-100 text-blue-600 flex items-center justify-center">
          <School className="h-5 w-5" />
        </div>
        <div className="flex-1">
          <h1 className="text-2xl font-bold">คลาสทั้งหมด</h1>
          <p className="text-sm text-muted-foreground">{loading ? "กำลังโหลด…" : `รวม ${rows.length} คลาส · กู้รหัสให้อาจารย์ได้จากหน้านี้`}</p>
        </div>
        <Button size="sm" variant="ghost" disabled={loading} onClick={load}>
          <RefreshCw className={`h-3.5 w-3.5 mr-1 ${loading ? "animate-spin" : ""}`} /> รีเฟรช
        </Button>
      </div>

      {error && <div className="border rounded-md text-sm text-destructive p-3">โหลดไม่สำเร็จ: {error}</div>}

      <div className="flex items-center gap-2">
        <div className="border rounded-md flex items-center gap-2 py-1.5 px-3 flex-1">
          <Search className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder="ค้นหา ชื่อคลาส / รหัส"
            className="w-full bg-transparent text-sm outline-none"
          />
        </div>
        <label className="text-sm text-muted-foreground inline-flex items-center gap-1.5 shrink-0">
          <input type="checkbox" checked={showArchived} onChange={(e) => setShowArchived(e.target.checked)} />
          แสดงคลาสที่ปิดแล้ว
        </label>
      </div>

      <div className="border rounded-md overflow-x-auto">
        <table className="w-full text-sm whitespace-nowrap">
          <thead className="bg-muted/50 text-muted-foreground">
            <tr>
              <th className="px-3 py-2 text-left">คลาส</th>
              <th className="px-3 py-2 text-left">คอร์ส</th>
              <th className="px-3 py-2 text-left">รหัสเข้าคลาส</th>
              <th className="px-3 py-2 text-left">รหัสอาจารย์</th>
              <th className="px-3 py-2 text-center">นักเรียน</th>
              <th className="px-3 py-2 text-left">สร้างเมื่อ</th>
              <th className="px-3 py-2 text-center">สถานะ</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={7} className="px-3 py-6 text-center text-muted-foreground">กำลังโหลด…</td>
              </tr>
            ) : filtered.length === 0 ? (
              <tr>
                <td colSpan={7} className="px-3 py-6 text-center text-muted-foreground">ไม่พบคลาส</td>
              </tr>
            ) : (
              filtered.map((r) => (
                <tr key={r.id} className={`border-t ${r.archived_at ? "opacity-60" : ""}`}>
                  <td className="px-3 py-2 max-w-[180px] truncate" title={r.name}>{r.name}</td>
                  <td className="px-3 py-2 text-muted-foreground uppercase">{r.course_mode}</td>
                  <td className="px-3 py-2"><CodeCell id={r.id} kind="code" value={r.code} /></td>
                  <td className="px-3 py-2"><CodeCell id={r.id} kind="instructor" value={r.instructor_code} /></td>
                  <td className="px-3 py-2 text-center text-muted-foreground">{r.student_count}</td>
                  <td className="px-3 py-2 text-muted-foreground">{fmtDate(r.created_at)}</td>
                  <td className="px-3 py-2 text-center">
                    <Button size="sm" variant="ghost" disabled={busyId === r.id} onClick={() => toggleArchive(r)}>
                      {r.archived_at ? (
                        <>
                          <ArchiveRestore className="h-3.5 w-3.5 mr-1" /> เปิดอีกครั้ง
                        </>
                      ) : (
                        <>
                          <Archive className="h-3.5 w-3.5 mr-1" /> ปิดคลาส
                        </>
                      )}
                    </Button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <p className="text-xs text-muted-foreground px-1">
        คลาสรุ่นเก่า (สร้างก่อนมีรหัสอาจารย์) จะไม่มีรหัสอาจารย์ — รหัสเข้าคลาสใช้ดูผลรวมได้ตามเดิม
        · ปิดคลาสแล้วรหัสทั้งคู่จะใช้ไม่ได้ แต่ข้อมูลยังอยู่ครบ เปิดอีกครั้งได้ตลอด
      </p>
    </div>
  );
}
