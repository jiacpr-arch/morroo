"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import { createMcqQuestion } from "@/lib/supabase/mutations-mcq-admin";
import {
  validateMcqRows,
  type AdminStudentSubject,
  type ParsedMcqRow,
  type RawMcqRow,
} from "@/lib/mcq-import";
import {
  NL_BROAD_SUBJECTS,
  cleanPdfText,
  chunkText,
} from "@/lib/nl-subjects";
import {
  ChevronLeft, Shield, Loader2, Upload, Sparkles,
  CheckCircle2, AlertCircle, FileText,
} from "lucide-react";

// Minimal shapes for the bits of pdfjs / the API we use (keeps eslint happy
// without pulling pdfjs types into the bundle).
interface PdfTextItem { str?: string }
interface AiChoice { label?: string; text?: string }
interface AiQuestion {
  subject?: string;
  scenario?: string;
  choices?: AiChoice[];
  correct?: string | null;
}

type Phase = "idle" | "reading" | "extracting" | "done";

export default function ImportPdfPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<AdminStudentSubject[]>([]);

  const [examType, setExamType] = useState<"NL1" | "NL2">("NL2");
  const [examSource, setExamSource] = useState("");
  const [files, setFiles] = useState<File[]>([]);

  const [phase, setPhase] = useState<Phase>("idle");
  const [progress, setProgress] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [parsed, setParsed] = useState<ParsedMcqRow[]>([]);
  const [importing, setImporting] = useState(false);
  const [result, setResult] = useState<{ inserted: number; failed: number } | null>(null);

  // Load: admin check → auto-create broad subjects → fetch student subjects.
  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      // Ensure the broad subjects exist (no manual SQL needed). Ignore conflicts
      // on the unique `name`. RLS allows admins to insert into mcq_subjects.
      await supabase
        .from("mcq_subjects")
        .upsert(
          NL_BROAD_SUBJECTS.map((s) => ({ ...s, audience: "student" as const })),
          { onConflict: "name", ignoreDuplicates: true }
        );

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

  function onFile(e: React.ChangeEvent<HTMLInputElement>) {
    const fs = Array.from(e.target.files ?? []);
    setFiles(fs);
    setParsed([]);
    setResult(null);
    setError(null);
    if (fs.length === 1 && !examSource) {
      setExamSource(fs[0].name.replace(/\.pdf$/i, ""));
    }
  }

  async function extractPdfText(f: File, prefix: string): Promise<string> {
    const pdfjs = await import("pdfjs-dist");
    pdfjs.GlobalWorkerOptions.workerSrc = "/pdf.worker.min.mjs";
    const buf = new Uint8Array(await f.arrayBuffer());
    const doc = await pdfjs.getDocument({ data: buf }).promise;
    const parts: string[] = [];
    for (let p = 1; p <= doc.numPages; p++) {
      setProgress(`${prefix}อ่านข้อความจาก PDF… หน้า ${p}/${doc.numPages}`);
      const page = await doc.getPage(p);
      const content = await page.getTextContent();
      const line = (content.items as PdfTextItem[])
        .map((it) => it.str ?? "")
        .join(" ");
      parts.push(line);
    }
    return cleanPdfText(parts.join("\n"));
  }

  async function handleProcess() {
    if (files.length === 0) { setError("กรุณาเลือกไฟล์ PDF ก่อน"); return; }
    setError(null);
    setResult(null);
    setParsed([]);

    // dedupe + accumulate across ALL selected files → one preview/import
    const seen = new Set<string>();
    const raws: RawMcqRow[] = [];
    let failedChunks = 0;

    try {
      for (let fi = 0; fi < files.length; fi++) {
        const f = files[fi];
        const prefix = files.length > 1 ? `ไฟล์ ${fi + 1}/${files.length} · ` : "";
        // per-file source: filename when batching; the input field when single
        const src =
          files.length === 1 && examSource
            ? examSource
            : f.name.replace(/\.pdf$/i, "");

        setPhase("reading");
        setProgress(`${prefix}กำลังโหลดไฟล์…`);
        const text = await extractPdfText(f, prefix);
        const chunks = chunkText(text);

        setPhase("extracting");
        for (let i = 0; i < chunks.length; i++) {
          setProgress(`${prefix}AI กำลังแกะ… ส่วน ${i + 1}/${chunks.length} (รวมได้แล้ว ${raws.length} ข้อ)`);
          let questions: AiQuestion[] = [];
          try {
            const res = await fetch("/api/admin/mcq/extract-pdf", {
              method: "POST",
              headers: { "content-type": "application/json" },
              body: JSON.stringify({ text: chunks[i], exam_type: examType }),
            });
            const data = await res.json();
            if (!res.ok) { failedChunks++; continue; }
            questions = (data.questions as AiQuestion[]) ?? [];
          } catch {
            failedChunks++;
            continue;
          }

          for (const q of questions) {
            const scenario = (q.scenario ?? "").trim();
            const choices = Array.isArray(q.choices) ? q.choices : [];
            if (scenario.length < 5 || choices.length < 2) continue;
            const key = scenario.toLowerCase().replace(/\s+/g, " ").slice(0, 80);
            if (seen.has(key)) continue;
            seen.add(key);

            const byLabel: Record<string, string> = {};
            for (const c of choices) {
              const lab = String(c.label ?? "").trim().toUpperCase();
              if ("ABCDE".includes(lab) && lab) byLabel[lab] = (c.text ?? "").trim();
            }
            const correct = String(q.correct ?? "").trim().toUpperCase();
            raws.push({
              subject: (q.subject ?? "").trim(),
              exam_type: examType,
              exam_source: src,
              question_number: String(raws.length + 1),
              scenario,
              choice_a: byLabel.A ?? "",
              choice_b: byLabel.B ?? "",
              choice_c: byLabel.C ?? "",
              choice_d: byLabel.D ?? "",
              choice_e: byLabel.E ?? "",
              correct: "ABCDE".includes(correct) ? correct : "",
              difficulty: "medium",
              status: "review",
            });
          }
        }
      }

      const rows = validateMcqRows(raws, subjects);
      setParsed(rows);
      setPhase("done");
      setProgress(
        `แกะเสร็จ ${files.length} ไฟล์: ${rows.length} ข้อ` +
        (failedChunks ? ` (มี ${failedChunks} ส่วนที่ AI อ่านไม่สำเร็จ ข้ามไป)` : "")
      );
    } catch (e) {
      setError(`อ่าน/แกะ PDF ไม่สำเร็จ: ${String(e)}`);
      setPhase("idle");
    }
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

  const busy = phase === "reading" || phase === "extracting";

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

      <h1 className="text-2xl font-bold mb-2">🤖 Import จาก PDF (AI)</h1>
      <p className="text-sm text-muted-foreground mb-6">
        อัปโหลดไฟล์ข้อสอบ PDF (ทั้งฉบับ) → AI แกะเป็นข้อสอบให้อัตโนมัติ (แยกสาขาให้)
        → ตรวจ preview → นำเข้า ทุกข้อเข้าเป็นสถานะ <strong>review</strong> (ซ่อนจากผู้เรียน)
        ให้ไปเฉลยในหน้า admin ก่อน · ไม่ต้องใช้ Terminal/คีย์/SQL
      </p>

      <Card className="mb-6">
        <CardContent className="p-6 space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="text-sm font-medium mb-1.5 block">ประเภทสอบ</label>
              <select
                value={examType}
                onChange={(e) => setExamType(e.target.value as "NL1" | "NL2")}
                disabled={busy}
                className="w-full border rounded-md px-3 py-2 text-sm bg-white"
              >
                <option value="NL2">NL2 (คลินิก)</option>
                <option value="NL1">NL1 (พรีคลินิก)</option>
              </select>
            </div>
            <div>
              <label className="text-sm font-medium mb-1.5 block">แหล่งที่มา (ปี/ชุด)</label>
              <Input
                value={examSource}
                onChange={(e) => setExamSource(e.target.value)}
                placeholder="เช่น NL2 2024"
                disabled={busy}
              />
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <label className="inline-flex">
              <input type="file" accept="application/pdf,.pdf" multiple className="hidden" onChange={onFile} disabled={busy} />
              <span className="inline-flex items-center gap-1 px-3 py-1.5 text-sm rounded-md border bg-background hover:bg-muted cursor-pointer">
                <Upload className="h-4 w-4" /> เลือกไฟล์ PDF (เลือกหลายไฟล์ได้)
              </span>
            </label>
            {files.length === 1 && <span className="text-sm text-muted-foreground">{files[0].name}</span>}
            {files.length > 1 && <span className="text-sm text-muted-foreground">{files.length} ไฟล์</span>}
          </div>

          <div className="flex items-center gap-3">
            <Button onClick={handleProcess} disabled={files.length === 0 || busy} className="gap-2">
              {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
              แกะข้อสอบด้วย AI
            </Button>
            {progress && <span className="text-sm text-muted-foreground">{progress}</span>}
          </div>

          {error && (
            <div className="rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700 flex items-start gap-2">
              <AlertCircle className="h-4 w-4 mt-0.5" />
              <span>{error}</span>
            </div>
          )}
        </CardContent>
      </Card>

      {parsed.length > 0 && (
        <>
          <div className="flex items-center gap-2 mb-2">
            <h2 className="text-lg font-semibold">Preview</h2>
            <Badge className="bg-green-100 text-green-700">✓ {validRows.length} ใช้ได้</Badge>
            {invalidRows.length > 0 && (
              <Badge className="bg-red-100 text-red-700">✗ {invalidRows.length} ต้องแก้</Badge>
            )}
          </div>
          <div className="rounded-lg border overflow-hidden mb-4">
            <div className="overflow-x-auto max-h-[480px]">
              <table className="w-full text-sm">
                <thead className="bg-muted/50 sticky top-0">
                  <tr>
                    <th className="text-left p-2 w-12">#</th>
                    <th className="text-left p-2 w-16">สถานะ</th>
                    <th className="text-left p-2">สาขา/ตอบ</th>
                    <th className="text-left p-2">scenario (snippet)</th>
                    <th className="text-left p-2">errors</th>
                  </tr>
                </thead>
                <tbody>
                  {parsed.map((p) => (
                    <tr key={p.rowNum} className="border-t">
                      <td className="p-2 text-muted-foreground">{p.rowNum}</td>
                      <td className="p-2">
                        {p.errors.length === 0
                          ? <CheckCircle2 className="h-4 w-4 text-green-600" />
                          : <AlertCircle className="h-4 w-4 text-red-600" />}
                      </td>
                      <td className="p-2 font-mono text-xs">
                        {p.raw.subject || "—"}/{p.raw.correct || "?"}
                      </td>
                      <td className="p-2 text-xs text-muted-foreground max-w-md truncate">
                        {p.raw.scenario}
                      </td>
                      <td className="p-2 text-xs text-red-600">{p.errors.join("; ")}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          <div className="flex items-center gap-3 mb-6">
            <Button onClick={onImport} disabled={validRows.length === 0 || importing} size="lg">
              {importing
                ? <><Loader2 className="h-4 w-4 mr-1 animate-spin" /> กำลังนำเข้า…</>
                : <>นำเข้า {validRows.length} ข้อ</>}
            </Button>
            {invalidRows.length > 0 && (
              <span className="text-xs text-muted-foreground">
                * {invalidRows.length} ข้อที่ error จะถูกข้าม
              </span>
            )}
          </div>

          {result && (
            <Card>
              <CardContent className="p-4">
                <div className="font-semibold mb-1 flex items-center gap-1">
                  <FileText className="h-4 w-4" /> ผลการนำเข้า
                </div>
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
