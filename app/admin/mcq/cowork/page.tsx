"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { createClient } from "@/lib/supabase/client";
import { updateMcqQuestion } from "@/lib/supabase/mutations-mcq-admin";
import {
  ChevronLeft, Shield, Loader2, Download, Copy, CheckCircle2, Upload,
} from "lucide-react";

// "Answer with cowork" workflow:
//   1. Export a batch of review questions as JSON → copy → paste to the Claude
//      (cowork) chat, which writes accurate เฉลย (Opus).
//   2. Paste the returned JSON of answers here → Apply → writes correct_answer +
//      detailed_explanation back into those questions (status stays review).

interface SubjectOpt { id: string; name_th: string; }
interface ExportQuestion {
  id: string;
  subject: string | null;
  scenario: string;
  choices: { label: string; text: string }[];
}
interface AnswerIn {
  id: string;
  correct?: string;
  detailed_explanation?: {
    summary: string;
    reason: string;
    choices: { label: string; text: string; is_correct: boolean; explanation: string }[];
    key_takeaway: string;
  };
}

export default function CoworkAnswerPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<SubjectOpt[]>([]);

  const [subjectId, setSubjectId] = useState("all");
  const [batchSize, setBatchSize] = useState(40);
  const [exporting, setExporting] = useState(false);
  const [exportJson, setExportJson] = useState("");
  const [exportCount, setExportCount] = useState<number | null>(null);
  const [copied, setCopied] = useState(false);

  const [applyText, setApplyText] = useState("");
  const [applying, setApplying] = useState(false);
  const [applyResult, setApplyResult] = useState<{ ok: number; fail: number } | null>(null);
  const [applyError, setApplyError] = useState<string | null>(null);

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
        .select("id, name_th")
        .eq("audience", "student")
        .order("name_th");
      setSubjects((sRes.data as SubjectOpt[]) ?? []);
      setLoading(false);
    }
    load();
  }, [router]);

  async function onExport() {
    setExporting(true);
    setCopied(false);
    setExportJson("");
    setExportCount(null);
    const supabase = createClient();
    let q = supabase
      .from("mcq_questions")
      .select("id, scenario, choices, mcq_subjects(name_th)")
      .eq("status", "review")
      .eq("audience", "student")
      .order("created_at", { ascending: true })
      .limit(batchSize);
    if (subjectId !== "all") q = q.eq("subject_id", subjectId);
    const { data, error } = await q;
    setExporting(false);
    if (error) { setExportJson(`// error: ${error.message}`); return; }
    const rows = (data ?? []) as unknown as {
      id: string;
      scenario: string;
      choices: { label: string; text: string }[];
      mcq_subjects: { name_th: string } | null;
    }[];
    const out: ExportQuestion[] = rows.map((r) => ({
      id: r.id,
      subject: r.mcq_subjects?.name_th ?? null,
      scenario: r.scenario,
      choices: r.choices,
    }));
    setExportCount(out.length);
    setExportJson(JSON.stringify(out, null, 2));
  }

  async function onCopy() {
    try {
      await navigator.clipboard.writeText(exportJson);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch {
      /* clipboard may be blocked — user can select manually */
    }
  }

  async function onApply() {
    setApplyError(null);
    setApplyResult(null);
    let parsed: AnswerIn[];
    try {
      const v = JSON.parse(applyText);
      parsed = Array.isArray(v) ? v : [];
    } catch {
      setApplyError("JSON ไม่ถูกต้อง — วางให้เป็น array ของ {id, correct, detailed_explanation}");
      return;
    }
    if (parsed.length === 0) { setApplyError("ไม่พบข้อมูลใน JSON"); return; }

    setApplying(true);
    let ok = 0, fail = 0;
    for (const a of parsed) {
      if (!a?.id) { fail++; continue; }
      const patch: Record<string, unknown> = { is_ai_enhanced: true };
      const correct = String(a.correct ?? "").trim().toUpperCase();
      if ("ABCDE".includes(correct) && correct) patch.correct_answer = correct;
      if (a.detailed_explanation) patch.detailed_explanation = a.detailed_explanation;
      const success = await updateMcqQuestion(a.id, patch);
      if (success) ok++; else fail++;
    }
    setApplying(false);
    setApplyResult({ ok, fail });
  }

  const applyCount = useMemo(() => {
    try {
      const v = JSON.parse(applyText);
      return Array.isArray(v) ? v.length : 0;
    } catch {
      return 0;
    }
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

      <h1 className="text-2xl font-bold mb-2">🤝 เฉลยด้วย cowork (Opus)</h1>
      <p className="text-sm text-muted-foreground mb-6">
        ดึงข้อ <strong>review</strong> ออกมาเป็น JSON → ก็อปไปวางในแชต cowork ให้เขียนเฉลย →
        เอา JSON เฉลยกลับมาวางช่อง Apply → ระบบเขียนเฉลยเข้าข้อนั้นๆ (ยังเป็น review ให้ตรวจก่อน Active)
      </p>

      {/* STEP 1: Export */}
      <Card className="mb-6">
        <CardContent className="p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Badge className="bg-blue-100 text-blue-700">ขั้น 1</Badge>
            <h2 className="font-semibold">Export ข้อ review</h2>
          </div>
          <div className="flex flex-wrap items-end gap-3">
            <div>
              <label className="text-xs text-muted-foreground block mb-1">สาขา</label>
              <select
                value={subjectId}
                onChange={(e) => setSubjectId(e.target.value)}
                className="border rounded-md px-3 py-2 text-sm bg-white"
              >
                <option value="all">ทุกสาขา</option>
                {subjects.map((s) => <option key={s.id} value={s.id}>{s.name_th}</option>)}
              </select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground block mb-1">จำนวน/ชุด</label>
              <Input
                type="number"
                min={1}
                max={100}
                value={batchSize}
                onChange={(e) => setBatchSize(Math.min(100, Math.max(1, Number(e.target.value) || 1)))}
                className="w-24"
              />
            </div>
            <Button onClick={onExport} disabled={exporting} className="gap-1">
              {exporting ? <Loader2 className="h-4 w-4 animate-spin" /> : <Download className="h-4 w-4" />}
              ดึงข้อสอบ
            </Button>
            {exportCount !== null && (
              <Badge variant="secondary">ได้ {exportCount} ข้อ</Badge>
            )}
          </div>
          {exportJson && (
            <>
              <Textarea readOnly value={exportJson} className="min-h-[160px] font-mono text-xs" />
              <Button variant="outline" size="sm" onClick={onCopy} className="gap-1">
                {copied ? <CheckCircle2 className="h-4 w-4 text-green-600" /> : <Copy className="h-4 w-4" />}
                {copied ? "คัดลอกแล้ว" : "คัดลอก JSON"}
              </Button>
              <p className="text-xs text-muted-foreground">
                วาง JSON นี้ในแชต cowork แล้วบอกให้ &quot;เฉลย + เขียน detailed_explanation&quot; →
                จะได้ JSON กลับมาเป็น array ของ <code>{`{id, correct, detailed_explanation}`}</code>
              </p>
            </>
          )}
        </CardContent>
      </Card>

      {/* STEP 2: Apply */}
      <Card>
        <CardContent className="p-6 space-y-4">
          <div className="flex items-center gap-2">
            <Badge className="bg-emerald-100 text-emerald-700">ขั้น 2</Badge>
            <h2 className="font-semibold">Apply เฉลยกลับเข้าระบบ</h2>
          </div>
          <Textarea
            value={applyText}
            onChange={(e) => setApplyText(e.target.value)}
            placeholder='วาง JSON เฉลย: [{"id":"...","correct":"C","detailed_explanation":{...}}]'
            className="min-h-[160px] font-mono text-xs"
          />
          <div className="flex items-center gap-3">
            <Button onClick={onApply} disabled={applying || applyCount === 0} className="gap-1">
              {applying ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
              เขียนเฉลย {applyCount > 0 ? `${applyCount} ข้อ` : ""}
            </Button>
            {applyResult && (
              <span className="text-sm text-muted-foreground">
                ✓ สำเร็จ {applyResult.ok}{applyResult.fail > 0 && ` · ล้มเหลว ${applyResult.fail}`}
              </span>
            )}
          </div>
          {applyError && (
            <div className="rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">{applyError}</div>
          )}
          <p className="text-xs text-muted-foreground">
            เขียนเสร็จข้อยังเป็น <strong>review</strong> — ไปตรวจที่ MCQ admin แล้วกด Active เมื่อพร้อม
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
