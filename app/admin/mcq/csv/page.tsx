"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { updateMcqQuestion } from "@/lib/supabase/mutations-mcq-admin";
import { parseCsv } from "@/lib/board-import";
import {
  ChevronLeft, Shield, Loader2, Download, Upload, CheckCircle2, AlertCircle,
} from "lucide-react";

// PDF → DB(review) is done elsewhere. This page completes the pipeline:
// Export review questions → CSV → (cowork/Opus fills เฉลย) → upload back →
// update by id (+ optionally activate) → live student MCQ.

interface SubjectOpt { id: string; name_th: string; }

const EXPORT_HEADERS = [
  "id", "exam_source", "subject", "exam_type", "scenario",
  "choice_a", "choice_b", "choice_c", "choice_d", "choice_e",
  "correct", "explanation", "detailed_explanation",
] as const;

interface DbRow {
  id: string;
  exam_source: string | null;
  exam_type: string | null;
  scenario: string;
  choices: { label: string; text: string }[];
  correct_answer: string;
  explanation: string | null;
  detailed_explanation: unknown;
  mcq_subjects: { name_th: string } | null;
}

function csvCell(v: string): string {
  return /[",\n\r]/.test(v) ? `"${v.replace(/"/g, '""')}"` : v;
}

export default function CsvRoundtripPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<SubjectOpt[]>([]);
  const [examSources, setExamSources] = useState<string[]>([]);

  const [examSource, setExamSource] = useState("all");
  const [subjectId, setSubjectId] = useState("all");
  const [exporting, setExporting] = useState(false);
  const [exportInfo, setExportInfo] = useState<string | null>(null);

  const [activateOnApply, setActivateOnApply] = useState(false);
  const [applyText, setApplyText] = useState("");
  const [applying, setApplying] = useState(false);
  const [applyResult, setApplyResult] = useState<{ ok: number; fail: number; errors: string[] } | null>(null);

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
        .from("mcq_subjects").select("id, name_th").eq("audience", "student").order("name_th");
      setSubjects((sRes.data as SubjectOpt[]) ?? []);

      // distinct exam_source of review questions (paginate)
      const sources = new Set<string>();
      const CHUNK = 1000;
      for (let from = 0; ; from += CHUNK) {
        const { data, error } = await supabase
          .from("mcq_questions").select("exam_source")
          .eq("status", "review").eq("audience", "student")
          .range(from, from + CHUNK - 1);
        if (error || !data || data.length === 0) break;
        for (const r of data as { exam_source: string | null }[]) {
          if (r.exam_source) sources.add(r.exam_source);
        }
        if (data.length < CHUNK) break;
      }
      setExamSources([...sources].sort());
      setLoading(false);
    }
    load();
  }, [router]);

  async function onExport() {
    setExporting(true);
    setExportInfo(null);
    const supabase = createClient();
    const all: DbRow[] = [];
    const CHUNK = 1000;
    for (let from = 0; ; from += CHUNK) {
      let q = supabase
        .from("mcq_questions")
        .select("id, exam_source, exam_type, scenario, choices, correct_answer, explanation, detailed_explanation, mcq_subjects(name_th)")
        .eq("status", "review").eq("audience", "student")
        .order("created_at", { ascending: true })
        .range(from, from + CHUNK - 1);
      if (examSource !== "all") q = q.eq("exam_source", examSource);
      if (subjectId !== "all") q = q.eq("subject_id", subjectId);
      const { data, error } = await q;
      if (error) { setExporting(false); setExportInfo(`error: ${error.message}`); return; }
      if (!data || data.length === 0) break;
      all.push(...(data as unknown as DbRow[]));
      if (data.length < CHUNK) break;
    }

    const lines = [EXPORT_HEADERS.join(",")];
    for (const r of all) {
      const byLabel: Record<string, string> = {};
      for (const c of r.choices ?? []) byLabel[c.label] = c.text;
      const de = r.detailed_explanation ? JSON.stringify(r.detailed_explanation) : "";
      lines.push([
        r.id,
        r.exam_source ?? "",
        r.mcq_subjects?.name_th ?? "",
        r.exam_type ?? "",
        r.scenario ?? "",
        byLabel.A ?? "", byLabel.B ?? "", byLabel.C ?? "", byLabel.D ?? "", byLabel.E ?? "",
        r.correct_answer ?? "",
        r.explanation ?? "",
        de,
      ].map((v) => csvCell(String(v))).join(","));
    }
    const csv = "﻿" + lines.join("\r\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    const tag = examSource !== "all" ? examSource.replace(/[^\w฀-๿]+/g, "-") : "all";
    a.href = url;
    a.download = `mcq-review-${tag}.csv`;
    a.click();
    URL.revokeObjectURL(url);
    setExporting(false);
    setExportInfo(`ดาวน์โหลดแล้ว ${all.length} ข้อ`);
  }

  function onFileUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const f = e.target.files?.[0];
    if (!f) return;
    const reader = new FileReader();
    reader.onload = () => setApplyText(typeof reader.result === "string" ? reader.result : "");
    reader.readAsText(f, "utf-8");
  }

  async function onApply() {
    setApplyResult(null);
    const rows = parseCsv(applyText);
    if (rows.length < 2) { setApplyResult({ ok: 0, fail: 0, errors: ["ไม่พบข้อมูล (ต้องมี header + อย่างน้อย 1 แถว)"] }); return; }
    const header = rows[0].map((h) => h.trim().toLowerCase());
    const col = (name: string) => header.indexOf(name);
    const idIdx = col("id");
    if (idIdx < 0) { setApplyResult({ ok: 0, fail: 0, errors: ["CSV ต้องมีคอลัมน์ id"] }); return; }
    const correctIdx = col("correct");
    const explIdx = col("explanation");
    const deIdx = col("detailed_explanation");

    setApplying(true);
    let ok = 0, fail = 0;
    const errors: string[] = [];
    for (let r = 1; r < rows.length; r++) {
      const cells = rows[r];
      const id = (cells[idIdx] ?? "").trim();
      if (!id) { continue; }
      const patch: Record<string, unknown> = {};
      const correct = correctIdx >= 0 ? (cells[correctIdx] ?? "").trim().toUpperCase() : "";
      if ("ABCDE".includes(correct) && correct) patch.correct_answer = correct;
      const expl = explIdx >= 0 ? (cells[explIdx] ?? "").trim() : "";
      if (expl) patch.explanation = expl;
      const deRaw = deIdx >= 0 ? (cells[deIdx] ?? "").trim() : "";
      if (deRaw) {
        try { patch.detailed_explanation = JSON.parse(deRaw); }
        catch { errors.push(`แถว ${r}: detailed_explanation ไม่ใช่ JSON`); }
      }
      if (patch.correct_answer || patch.explanation || patch.detailed_explanation) {
        patch.is_ai_enhanced = true;
      }
      if (activateOnApply) patch.status = "active";
      if (Object.keys(patch).length === 0) { continue; }
      const success = await updateMcqQuestion(id, patch);
      if (success) ok++; else { fail++; errors.push(`แถว ${r}: อัปเดต id ${id} ไม่สำเร็จ`); }
    }
    setApplying(false);
    setApplyResult({ ok, fail, errors: errors.slice(0, 20) });
  }

  const applyRowCount = useMemo(() => {
    const rows = parseCsv(applyText);
    return rows.length > 1 ? rows.length - 1 : 0;
  }, [applyText]);

  if (loading) {
    return <div className="flex items-center justify-center min-h-[60vh]"><Loader2 className="h-8 w-8 animate-spin text-brand" /></div>;
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
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/mcq" className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1">
          <ChevronLeft className="h-4 w-4" /> กลับไป MCQ admin
        </Link>
      </div>

      <h1 className="text-2xl font-bold mb-2">📑 CSV ทั้งคลัง: Export → เฉลย → Seed</h1>
      <p className="text-sm text-muted-foreground mb-6">
        ดึงข้อ <strong>review</strong> เป็น CSV (เปิด Excel/Sheets ได้) → ให้ cowork เติม
        เฉลย+เหตุผล (ช่อง explanation / detailed_explanation) → อัปโหลดกลับ → ระบบอัปเดต
        เข้าข้อเดิมตาม <code>id</code> (ติ๊กเปิดใช้งานเพื่อให้เป็นข้อสอบนักเรียนทันที)
      </p>

      {/* Export */}
      <Card className="mb-6">
        <CardContent className="p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Badge className="bg-blue-100 text-blue-700">ขั้น 1</Badge>
            <h2 className="font-semibold">Export → ดาวน์โหลด CSV</h2>
          </div>
          <div className="flex flex-wrap items-end gap-3">
            <div>
              <label className="text-xs text-muted-foreground block mb-1">ปี/ชุด</label>
              <select value={examSource} onChange={(e) => setExamSource(e.target.value)}
                className="border rounded-md px-3 py-2 text-sm bg-white max-w-[260px]">
                <option value="all">ทุกปี/ชุด</option>
                {examSources.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground block mb-1">สาขา (ออปชัน)</label>
              <select value={subjectId} onChange={(e) => setSubjectId(e.target.value)}
                className="border rounded-md px-3 py-2 text-sm bg-white">
                <option value="all">ทุกสาขา</option>
                {subjects.map((s) => <option key={s.id} value={s.id}>{s.name_th}</option>)}
              </select>
            </div>
            <Button onClick={onExport} disabled={exporting} className="gap-1">
              {exporting ? <Loader2 className="h-4 w-4 animate-spin" /> : <Download className="h-4 w-4" />}
              ดาวน์โหลด CSV
            </Button>
            {exportInfo && <span className="text-sm text-muted-foreground">{exportInfo}</span>}
          </div>
          <p className="text-xs text-muted-foreground">
            คอลัมน์: {EXPORT_HEADERS.join(", ")} · เติมเฉพาะ <strong>correct / explanation /
            detailed_explanation</strong> (เป็น JSON) — ห้ามแก้คอลัมน์ <code>id</code>
          </p>
        </CardContent>
      </Card>

      {/* Apply */}
      <Card>
        <CardContent className="p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Badge className="bg-emerald-100 text-emerald-700">ขั้น 2</Badge>
            <h2 className="font-semibold">Seed กลับ: อัปโหลด CSV ที่เฉลยแล้ว</h2>
          </div>
          <label className="inline-flex">
            <input type="file" accept=".csv,text/csv" className="hidden" onChange={onFileUpload} />
            <span className="inline-flex items-center gap-1 px-3 py-1.5 text-sm rounded-md border bg-background hover:bg-muted cursor-pointer">
              <Upload className="h-4 w-4" /> เลือกไฟล์ CSV
            </span>
          </label>
          {applyText && (
            <p className="text-xs text-muted-foreground">โหลด CSV แล้ว ({applyRowCount} แถว)</p>
          )}
          <label className="flex items-center gap-2 text-sm cursor-pointer">
            <input type="checkbox" checked={activateOnApply} onChange={(e) => setActivateOnApply(e.target.checked)} className="h-4 w-4" />
            เปิดใช้งานเลย (active) — ให้เป็นข้อสอบนักเรียนทันที (ไม่ติ๊ก = คง review ไว้ตรวจก่อน)
          </label>
          <div className="flex items-center gap-3">
            <Button onClick={onApply} disabled={applying || applyRowCount === 0} className="gap-1">
              {applying ? <Loader2 className="h-4 w-4 animate-spin" /> : <CheckCircle2 className="h-4 w-4" />}
              เขียนเฉลยกลับ {applyRowCount > 0 ? `${applyRowCount} ข้อ` : ""}
            </Button>
            {applyResult && (
              <span className="text-sm text-muted-foreground">
                ✓ สำเร็จ {applyResult.ok}{applyResult.fail > 0 && ` · ล้มเหลว ${applyResult.fail}`}
              </span>
            )}
          </div>
          {applyResult && applyResult.errors.length > 0 && (
            <div className="rounded-md border border-red-200 bg-red-50 p-3 text-xs text-red-700 space-y-0.5">
              {applyResult.errors.map((e, i) => (
                <div key={i} className="flex items-start gap-1"><AlertCircle className="h-3 w-3 mt-0.5 shrink-0" />{e}</div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
