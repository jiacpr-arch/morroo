"use client";

import { useState, useCallback } from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import {
  Plus,
  Search,
  FileText,
  Clock,
  Heart,
  Trash2,
} from "lucide-react";
import type { AclsRecord } from "@/lib/types-acls";

const STORAGE_KEY = "acls-emr-records";

function loadRecords(): AclsRecord[] {
  if (typeof window === "undefined") return [];
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch {
    return [];
  }
}

function deleteRecord(id: string) {
  const records = loadRecords().filter((r) => r.id !== id);
  localStorage.setItem(STORAGE_KEY, JSON.stringify(records));
  return records;
}

export default function AclsEmrListPage() {
  const [records, setRecords] = useState<AclsRecord[]>(loadRecords);
  const [search, setSearch] = useState("");

  const handleDelete = useCallback((id: string) => {
    if (!confirm("ลบบันทึกนี้?")) return;
    setRecords(deleteRecord(id));
  }, []);

  const filtered = records.filter(
    (r) =>
      r.patient_name.toLowerCase().includes(search.toLowerCase()) ||
      r.patient_hn?.toLowerCase().includes(search.toLowerCase()) ||
      r.team_leader.toLowerCase().includes(search.toLowerCase())
  );

  const outcomeBadge = (outcome: string) => {
    switch (outcome) {
      case "ROSC":
        return <Badge className="bg-green-100 text-green-700">ROSC</Badge>;
      case "Death":
        return <Badge className="bg-red-100 text-red-700">เสียชีวิต</Badge>;
      case "Transfer":
        return <Badge className="bg-blue-100 text-blue-700">ส่งต่อ</Badge>;
      default:
        return <Badge className="bg-yellow-100 text-yellow-700">CPR ต่อ</Badge>;
    }
  };

  return (
    <>
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Heart className="h-6 w-6 text-red-500" />
            ACLS EMR
          </h1>
          <p className="text-muted-foreground mt-1">
            บันทึกการกู้ชีพขั้นสูง (Advanced Cardiac Life Support)
          </p>
        </div>
        <Link href="/acls-emr/new">
          <Button className="bg-brand hover:bg-brand-light text-white gap-1.5">
            <Plus className="h-4 w-4" />
            บันทึกใหม่
          </Button>
        </Link>
      </div>

      {/* Search */}
      {records.length > 0 && (
        <div className="relative mb-6">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="ค้นหาชื่อผู้ป่วย, HN, หรือ Team Leader..."
            className="pl-9"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
      )}

      {/* Empty state */}
      {records.length === 0 && (
        <Card>
          <CardContent className="py-16 text-center">
            <FileText className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
            <h2 className="text-xl font-semibold mb-2">
              ยังไม่มีบันทึกการกู้ชีพ
            </h2>
            <p className="text-muted-foreground mb-6">
              เริ่มสร้างบันทึก ACLS EMR เพื่อจัดเก็บข้อมูลการกู้ชีพ
            </p>
            <Link href="/acls-emr/new">
              <Button className="bg-brand hover:bg-brand-light text-white gap-1.5">
                <Plus className="h-4 w-4" />
                สร้างบันทึกแรก
              </Button>
            </Link>
          </CardContent>
        </Card>
      )}

      {/* Record list */}
      {filtered.length > 0 && (
        <div className="space-y-3">
          {filtered
            .sort(
              (a, b) =>
                new Date(b.created_at).getTime() -
                new Date(a.created_at).getTime()
            )
            .map((record) => (
              <Card
                key={record.id}
                className="hover:ring-2 hover:ring-brand/30 transition-all"
              >
                <CardContent className="py-4">
                  <div className="flex items-start justify-between gap-4">
                    <Link
                      href={`/acls-emr/${record.id}`}
                      className="flex-1 min-w-0"
                    >
                      <div className="flex items-center gap-3 mb-2">
                        <h3 className="font-semibold truncate">
                          {record.patient_name}
                        </h3>
                        {record.patient_hn && (
                          <span className="text-xs text-muted-foreground">
                            HN: {record.patient_hn}
                          </span>
                        )}
                        {outcomeBadge(record.outcome)}
                      </div>
                      <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm text-muted-foreground">
                        <span className="flex items-center gap-1">
                          <Clock className="h-3.5 w-3.5" />
                          {new Date(record.arrest_date).toLocaleDateString(
                            "th-TH",
                            {
                              day: "numeric",
                              month: "short",
                              year: "2-digit",
                            }
                          )}{" "}
                          {record.arrest_time}
                        </span>
                        <span>
                          Initial rhythm:{" "}
                          <strong>{record.initial_rhythm}</strong>
                        </span>
                        <span>
                          Team Leader: {record.team_leader}
                        </span>
                        {record.total_duration_min != null && (
                          <span>{record.total_duration_min} นาที</span>
                        )}
                      </div>
                    </Link>
                    <button
                      onClick={() => handleDelete(record.id)}
                      className="shrink-0 p-2 rounded-lg text-muted-foreground hover:text-red-600 hover:bg-red-50 transition-colors"
                      title="ลบ"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </div>
                </CardContent>
              </Card>
            ))}
        </div>
      )}

      {/* No results */}
      {records.length > 0 && filtered.length === 0 && (
        <Card>
          <CardContent className="py-12 text-center">
            <Search className="h-12 w-12 text-muted-foreground mx-auto mb-3" />
            <p className="text-muted-foreground">
              ไม่พบผลลัพธ์สำหรับ &quot;{search}&quot;
            </p>
          </CardContent>
        </Card>
      )}

      {/* Stats */}
      {records.length > 0 && (
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mt-8">
          <Card>
            <CardHeader className="pb-1">
              <CardTitle className="text-xs text-muted-foreground font-normal">
                บันทึกทั้งหมด
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold">{records.length}</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-1">
              <CardTitle className="text-xs text-muted-foreground font-normal">
                ROSC
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-green-600">
                {records.filter((r) => r.outcome === "ROSC").length}
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-1">
              <CardTitle className="text-xs text-muted-foreground font-normal">
                เสียชีวิต
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-red-600">
                {records.filter((r) => r.outcome === "Death").length}
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="pb-1">
              <CardTitle className="text-xs text-muted-foreground font-normal">
                อัตรา ROSC
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-brand">
                {records.length > 0
                  ? Math.round(
                      (records.filter((r) => r.outcome === "ROSC").length /
                        records.length) *
                        100
                    )
                  : 0}
                %
              </p>
            </CardContent>
          </Card>
        </div>
      )}
    </>
  );
}
