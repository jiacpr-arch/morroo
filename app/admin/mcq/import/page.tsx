"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Textarea } from "@/components/ui/textarea";
import { createClient } from "@/lib/supabase/client";
import { createMcqQuestion } from "@/lib/supabase/mutations-mcq-admin";
import {
  ChevronLeft, Shield, Loader2, Upload, Download,
  CheckCircle2, AlertCircle, FileText,
} from "lucide-react";
import {
  parseCsv, validateAndMapMcq, buildMcqSampleCsv, MCQ_CSV_HEADERS,
  type AdminStudentSubject, type ParsedMcqRow,
} from "@/lib/mcq-import";

export default function McqImportPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<AdminStudentSubject[]>([]);

  const [csvText, setCsvText] = useState("");
  const [headerError, setHeaderError] = useState<string | null>(null);
  const [parsed, setParsed] = useState<ParsedMcqRow[]>([]);
  const [importing, setImporting] = useState(false);
  const [result, setResult] = useState<{ inserted: number; failed: number } | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);

      const sRes = await supabase
        .from("mcq_subjects")
        .select("id, name, name_th")
        .eq("audience", "student")
        .order("name_th");

      setSubjects((sRes.data as AdminStudentSubject[]) ?? []);
      setLoading(false);
    }
    load();
  }, [router]);

  function onParse() {
    setResult(null);
    if (!csvText.trim()) {
      setHeaderError("กรุณาวาง CSV หรืออัปโหลดไฟล์");
      setParsed([]);
      return;
    }
    const rows = parseCsv(csvText);
    const { headerError, parsed } = validateAndMapMcq(rows, subjects);
    setHeaderError(headerError);
    setParsed(parsed);
  }

  function onFileUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const f = e.target.files?.[0];
    if (!f) return;
    const reader = new FileReader();
    reader.onload = () => {
      const text = typeof reader.result === "string" ? reader.result : "";
      setCsvText(text);
    };
    reader.readAsText(f, "utf-8");
  }

  function downloadSample() {
    const csv = "﻿" + buildMcqSampleCsv();
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "nl-mcq-sample.csv";
    a.click();
    URL.revokeObjectURL(url);
  }

  const validRows = useMemo(() => parsed.filter((p) => p.insert), [parsed]);
  const invalidRows = useMemo(() => parsed.filter((p) => p.errors.length > 0), [parsed]);

  async function onImport() {
    if (validRows.length === 0) return;
    setImporting(true);
    let inserted = 0;
    let failed = 0;
    for (const row of validRows) {
      if (!row.insert) continue;
      const res = await createMcqQuestion(row.insert);
      if (res) inserted++;
      else failed++;
    }
    setImporting(false);
    setResult({ inserted, failed });
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

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/mcq" className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1">
          <ChevronLeft className="h-4 w-4" /> กลับไป MCQ admin
        </Link>
      </div>

      <h1 className="text-2xl font-bold mb-2">📦 Bulk import — NL MCQ (นศพ.)</h1>
      <p className="text-sm text-muted-foreground mb-6">
        นำเข้าข้อสอบ NL จาก CSV (เช่น CSV ที่แกะจาก PDF ด้วย scripts/pdf-to-mcq-csv.py)
        — มี dry-run preview ก่อนยืนยัน ทุกข้อจะเข้าเป็นสถานะ <strong>review</strong>{" "}
        (ซ่อนจากผู้เรียน) เพื่อให้ตรวจเฉลยก่อนเปิดใช้
      </p>

      <Card className="mb-6">
        <CardContent className="p-6 space-y-4">
          <div className="flex flex-wrap items-center gap-2">
            <Button variant="outline" size="sm" onClick={downloadSample}>
              <Download className="h-4 w-4 mr-1" /> ดาวน์โหลด template
            </Button>
            <label className="inline-flex">
              <input
                type="file"
                accept=".csv,text/csv"
                className="hidden"
                onChange={onFileUpload}
              />
              <span className="inline-flex items-center gap-1 px-3 py-1.5 text-sm rounded-md border bg-background hover:bg-muted cursor-pointer">
                <Upload className="h-4 w-4" /> อัปโหลด CSV
              </span>
            </label>
            <div className="text-xs text-muted-foreground ml-auto">
              คอลัมน์: {MCQ_CSV_HEADERS.join(", ")}
            </div>
          </div>

          <Textarea
            value={csvText}
            onChange={(e) => setCsvText(e.target.value)}
            placeholder="หรือวางเนื้อหา CSV ตรงนี้..."
            className="min-h-[160px] font-mono text-xs"
          />

          <div className="flex items-center gap-2">
            <Button onClick={onParse}>
              <FileText className="h-4 w-4 mr-1" /> Parse & preview
            </Button>
            {parsed.length > 0 && (
              <>
                <Badge variant="default" className="bg-green-100 text-green-700">
                  ✓ {validRows.length} ใช้ได้
                </Badge>
                {invalidRows.length > 0 && (
                  <Badge variant="default" className="bg-red-100 text-red-700">
                    ✗ {invalidRows.length} error
                  </Badge>
                )}
              </>
            )}
          </div>

          {headerError && (
            <div className="rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700 flex items-start gap-2">
              <AlertCircle className="h-4 w-4 mt-0.5" />
              <span>{headerError}</span>
            </div>
          )}
        </CardContent>
      </Card>

      {parsed.length > 0 && (
        <>
          <h2 className="text-lg font-semibold mb-2">Preview</h2>
          <div className="rounded-lg border overflow-hidden mb-4">
            <div className="overflow-x-auto max-h-[480px]">
              <table className="w-full text-sm">
                <thead className="bg-muted/50 sticky top-0">
                  <tr>
                    <th className="text-left p-2 w-12">#</th>
                    <th className="text-left p-2 w-16">สถานะ</th>
                    <th className="text-left p-2">subject/exam/ตอบ</th>
                    <th className="text-left p-2">scenario (snippet)</th>
                    <th className="text-left p-2">errors</th>
                  </tr>
                </thead>
                <tbody>
                  {parsed.map((p) => (
                    <tr key={p.rowNum} className="border-t">
                      <td className="p-2 text-muted-foreground">{p.rowNum}</td>
                      <td className="p-2">
                        {p.errors.length === 0 ? (
                          <CheckCircle2 className="h-4 w-4 text-green-600" />
                        ) : (
                          <AlertCircle className="h-4 w-4 text-red-600" />
                        )}
                      </td>
                      <td className="p-2 font-mono text-xs">
                        {p.raw.subject || "—"}/{p.raw.exam_type || "—"}/{p.raw.correct || "—"}
                      </td>
                      <td className="p-2 text-xs text-muted-foreground max-w-md truncate">
                        {p.raw.scenario}
                      </td>
                      <td className="p-2 text-xs text-red-600">
                        {p.errors.join("; ")}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          <div className="flex items-center gap-3 mb-6">
            <Button
              onClick={onImport}
              disabled={validRows.length === 0 || importing}
              size="lg"
            >
              {importing ? (
                <><Loader2 className="h-4 w-4 mr-1 animate-spin" /> กำลังนำเข้า…</>
              ) : (
                <>นำเข้า {validRows.length} ข้อ</>
              )}
            </Button>
            {invalidRows.length > 0 && (
              <span className="text-xs text-muted-foreground">
                * {invalidRows.length} แถวที่ error จะถูกข้ามอัตโนมัติ
              </span>
            )}
          </div>

          {result && (
            <Card>
              <CardContent className="p-4">
                <div className="font-semibold mb-1">ผลการนำเข้า</div>
                <div className="text-sm text-muted-foreground">
                  สำเร็จ {result.inserted} ข้อ
                  {result.failed > 0 && ` · ล้มเหลว ${result.failed} ข้อ (ดู console)`}
                </div>
                <div className="mt-3">
                  <Link href="/admin/mcq" className="text-sm text-brand hover:underline">
                    → ไป MCQ admin (กรองสถานะ &quot;Review&quot; เพื่อไล่เฉลย)
                  </Link>
                </div>
              </CardContent>
            </Card>
          )}
        </>
      )}
    </div>
  );
}
