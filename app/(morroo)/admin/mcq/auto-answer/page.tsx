"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { createClient } from "@/lib/supabase/client";
import {
  updateMcqQuestion,
  bulkUpdateMcqQuestionStatus,
} from "@/lib/supabase/mutations-mcq-admin";
import { ChevronLeft, Shield, Loader2, Sparkles, CheckCircle2 } from "lucide-react";

// One-click: let AI answer + write a detailed เฉลย for review questions already
// in the DB (imported from PDF), so the admin doesn't do each one by hand.

interface SubjectOpt { id: string; name_th: string; }
interface QRow { id: string; scenario: string; choices: { label: string; text: string }[]; }
interface AiAnswer {
  index: number;
  correct?: string;
  detailed_explanation?: {
    summary: string;
    reason: string;
    choices: { label: string; text: string; is_correct: boolean; explanation: string }[];
    key_takeaway: string;
  };
}

export default function AutoAnswerPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<SubjectOpt[]>([]);
  const [examSources, setExamSources] = useState<string[]>([]);

  const [examSource, setExamSource] = useState("all");
  const [subjectId, setSubjectId] = useState("all");
  const [audience, setAudience] = useState<"student" | "board">("student");
  const [onlyUnanswered, setOnlyUnanswered] = useState(true);
  const [model, setModel] = useState<"haiku" | "sonnet">("haiku");
  const [maxCount, setMaxCount] = useState(100);
  const [activate, setActivate] = useState(false);

  const [running, setRunning] = useState(false);
  const [progress, setProgress] = useState("");
  const [result, setResult] = useState<{ done: number; failed: number; activated: number } | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function checkAdmin() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);
      setLoading(false);
    }
    checkAdmin();
  }, [router]);

  // (Re)load subject + ปี/ชุด filters for the chosen audience (student / board).
  useEffect(() => {
    if (!isAdmin) return;
    setSubjectId("all");
    setExamSource("all");
    async function loadFilters() {
      const supabase = createClient();
      const sRes = await supabase
        .from("mcq_subjects").select("id, name_th").eq("audience", audience).order("name_th");
      setSubjects((sRes.data as SubjectOpt[]) ?? []);

      const sources = new Set<string>();
      const CHUNK = 1000;
      for (let from = 0; ; from += CHUNK) {
        const { data, error } = await supabase
          .from("mcq_questions").select("exam_source")
          .eq("status", "review").eq("audience", audience)
          .range(from, from + CHUNK - 1);
        if (error || !data || data.length === 0) break;
        for (const r of data as { exam_source: string | null }[]) {
          if (r.exam_source) sources.add(r.exam_source);
        }
        if (data.length < CHUNK) break;
      }
      setExamSources([...sources].sort());
    }
    loadFilters();
  }, [isAdmin, audience]);

  async function onRun() {
    setError(null);
    setResult(null);
    setRunning(true);
    const supabase = createClient();

    // Fetch the batch of review questions to answer.
    let q = supabase
      .from("mcq_questions")
      .select("id, scenario, choices")
      .eq("status", "review")
      .eq("audience", audience)
      .order("created_at", { ascending: true })
      .limit(Math.min(Math.max(maxCount, 1), 500));
    if (examSource !== "all") q = q.eq("exam_source", examSource);
    if (subjectId !== "all") q = q.eq("subject_id", subjectId);
    if (onlyUnanswered) q = q.is("detailed_explanation", null);
    const { data, error: qErr } = await q;
    if (qErr) { setError(qErr.message); setRunning(false); return; }
    const rows = (data as unknown as QRow[]) ?? [];
    if (rows.length === 0) {
      setRunning(false);
      setResult({ done: 0, failed: 0, activated: 0 });
      setProgress("ไม่พบข้อที่ต้องเฉลย (ตามตัวกรอง)");
      return;
    }

    let done = 0, failed = 0;
    let firstErr = "";
    const answeredIds: string[] = [];
    // Sonnet writes longer Thai explanations than Haiku, so keep its batch
    // smaller to stay well under the 60s serverless limit on the answer call.
    const BATCH = model === "sonnet" ? 1 : 3;
    for (let start = 0; start < rows.length; start += BATCH) {
      const batch = rows.slice(start, start + BATCH);
      setProgress(`AI กำลังเฉลย… ${Math.min(start + batch.length, rows.length)}/${rows.length} ข้อ`);
      try {
        const res = await fetch("/api/admin/mcq/answer-questions", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({
            questions: batch.map((r) => ({ scenario: r.scenario, choices: r.choices })),
            exam_type: "NL2",
            model,
          }),
        });
        const dat = await res.json().catch(() => ({}));
        if (!res.ok) {
          if (!firstErr) firstErr = String(dat?.error ?? `HTTP ${res.status}`);
          failed += batch.length;
          continue;
        }
        const answers = (dat.answers as AiAnswer[]) ?? [];
        if (answers.length === 0 && !firstErr) firstErr = "AI ไม่ส่งคำเฉลยกลับ (ลองลดจำนวน/เปลี่ยนโมเดล)";
        for (const a of answers) {
          const row = batch[a.index];
          if (!row) continue;
          const labels = row.choices.map((c) => c.label);
          const correct = String(a.correct ?? "").trim().toUpperCase();
          const patch: Record<string, unknown> = { is_ai_enhanced: true };
          if (labels.includes(correct)) patch.correct_answer = correct;
          if (a.detailed_explanation) patch.detailed_explanation = a.detailed_explanation;
          if (a.detailed_explanation || patch.correct_answer) {
            const ok = await updateMcqQuestion(row.id, patch);
            if (ok) { done++; answeredIds.push(row.id); }
            else { failed++; if (!firstErr) firstErr = "เขียนเฉลยกลับ DB ไม่สำเร็จ (RLS?)"; }
          } else failed++;
        }
      } catch (e) {
        if (!firstErr) firstErr = String(e);
        failed += batch.length;
      }
    }

    let activated = 0;
    if (activate && answeredIds.length > 0) {
      setProgress(`กำลังเปิดใช้งาน ${answeredIds.length} ข้อ…`);
      const r = await bulkUpdateMcqQuestionStatus(answeredIds, "active");
      activated = r.ok;
    }

    setRunning(false);
    setResult({ done, failed, activated });
    setProgress(`เสร็จ: เฉลยแล้ว ${done} ข้อ`);
    if (failed > 0 && firstErr) {
      setError(`สาเหตุที่ล้มเหลว: ${firstErr.slice(0, 240)}`);
    }
  }

  const subjectName = useMemo(
    () => subjects.find((s) => s.id === subjectId)?.name_th ?? "ทุกสาขา",
    [subjects, subjectId]
  );

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
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/mcq" className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1">
          <ChevronLeft className="h-4 w-4" /> กลับไป MCQ admin
        </Link>
      </div>

      <h1 className="text-2xl font-bold mb-2">⚡ เฉลยอัตโนมัติด้วย AI</h1>
      <p className="text-sm text-muted-foreground mb-6">
        ให้ AI เฉลย + เขียนเหตุผลรายตัวเลือก ให้ข้อที่อยู่ในสถานะ <strong>review</strong>
        โดยอัตโนมัติ — ไม่ต้องทำทีละข้อ · กดแล้วรอ (อย่าปิดแท็บ) · เสร็จแล้วสุ่มตรวจก่อนเปิดใช้
      </p>

      <Card>
        <CardContent className="p-6 space-y-4">
          <div className="flex gap-2">
            {(["student", "board"] as const).map((a) => (
              <button
                key={a}
                type="button"
                onClick={() => setAudience(a)}
                disabled={running}
                className={`px-4 py-1.5 rounded-md text-sm font-medium border transition-colors ${
                  audience === a
                    ? "bg-brand text-white border-brand"
                    : "bg-white text-muted-foreground border-gray-200 hover:bg-muted"
                }`}
              >
                {a === "student" ? "นศพ. (NL)" : "Board"}
              </button>
            ))}
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="text-xs text-muted-foreground block mb-1">ปี/ชุด</label>
              <select value={examSource} onChange={(e) => setExamSource(e.target.value)}
                className="w-full border rounded-md px-3 py-2 text-sm bg-white">
                <option value="all">ทุกปี/ชุด</option>
                {examSources.map((s) => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground block mb-1">สาขา</label>
              <select value={subjectId} onChange={(e) => setSubjectId(e.target.value)}
                className="w-full border rounded-md px-3 py-2 text-sm bg-white">
                <option value="all">ทุกสาขา</option>
                {subjects.map((s) => <option key={s.id} value={s.id}>{s.name_th}</option>)}
              </select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground block mb-1">โมเดล</label>
              <select value={model} onChange={(e) => setModel(e.target.value as "haiku" | "sonnet")}
                className="w-full border rounded-md px-3 py-2 text-sm bg-white">
                <option value="haiku">Haiku — ถูก/เร็ว (แนะนำสำหรับชุดใหญ่)</option>
                <option value="sonnet">Sonnet — แม่นกว่า/แพงกว่า</option>
              </select>
            </div>
            <div>
              <label className="text-xs text-muted-foreground block mb-1">จำนวนสูงสุดต่อรอบ (1–500)</label>
              <Input type="number" min={1} max={500} value={maxCount}
                onChange={(e) => setMaxCount(Math.min(500, Math.max(1, Number(e.target.value) || 1)))} />
            </div>
          </div>

          <label className="flex items-center gap-2 text-sm cursor-pointer">
            <input type="checkbox" checked={onlyUnanswered} onChange={(e) => setOnlyUnanswered(e.target.checked)} className="h-4 w-4" />
            เฉพาะข้อที่ยังไม่มีเฉลยละเอียด (แนะนำ — กันเฉลยซ้ำ)
          </label>
          <label className="flex items-center gap-2 text-sm cursor-pointer">
            <input type="checkbox" checked={activate} onChange={(e) => setActivate(e.target.checked)} className="h-4 w-4" />
            เปิดใช้งาน (active) หลังเฉลยเสร็จ — ⚠️ ควรสุ่มตรวจก่อน แนะนำยังไม่ติ๊กในรอบแรก
          </label>

          <div className="flex items-center gap-3 pt-1">
            <Button onClick={onRun} disabled={running} className="gap-2" size="lg">
              {running ? <Loader2 className="h-4 w-4 animate-spin" /> : <Sparkles className="h-4 w-4" />}
              เริ่มเฉลยอัตโนมัติ
            </Button>
            {progress && <span className="text-sm text-muted-foreground">{progress}</span>}
          </div>

          <p className="text-xs text-muted-foreground">
            กรอง: {examSource === "all" ? "ทุกปี" : examSource} · {subjectName} · ครั้งละไม่เกิน {maxCount} ข้อ
            (รันซ้ำได้เรื่อยๆ จนหมด)
          </p>

          {error && (
            <div className="rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">{error}</div>
          )}
          {result && (
            <div className="rounded-md border border-emerald-200 bg-emerald-50 p-3 text-sm text-emerald-800 flex items-start gap-2">
              <CheckCircle2 className="h-4 w-4 mt-0.5" />
              <span>
                เฉลยสำเร็จ {result.done} ข้อ
                {result.failed > 0 && ` · ล้มเหลว ${result.failed}`}
                {result.activated > 0 && ` · เปิดใช้งาน ${result.activated}`}
                {" · "}กด &quot;เริ่มเฉลยอัตโนมัติ&quot; อีกครั้งเพื่อทำชุดถัดไป
              </span>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
