"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import {
  REPORT_REASON_LABELS,
  REPORT_STATUS_LABELS,
  availableReporterPoints,
} from "@/lib/bug-hunter";
import {
  Shield,
  Loader2,
  ChevronLeft,
  Flag,
  CheckCircle2,
  XCircle,
  Copy,
  Trophy,
  Pencil,
  ExternalLink,
} from "lucide-react";

type Reporter = {
  id: string;
  name: string | null;
  email: string | null;
  reporter_points: number;
  reporter_points_spent: number;
};

type Report = {
  id: string;
  question_id: string;
  reason: string;
  note: string | null;
  suggested_answer: string | null;
  status: string;
  points_awarded: number;
  created_at: string;
  reviewed_at: string | null;
  user_id: string | null;
  mcq_questions: {
    scenario: string;
    correct_answer: string;
    status: string;
  } | null;
  reporter: Reporter | null;
};

const STATUS_COLORS: Record<string, string> = {
  pending: "bg-yellow-100 text-yellow-700",
  confirmed: "bg-green-100 text-green-700",
  rejected: "bg-gray-100 text-gray-500",
  duplicate: "bg-blue-100 text-blue-700",
};

const STATUS_FILTERS = ["pending", "confirmed", "rejected", "duplicate", "all"] as const;
type StatusFilter = (typeof STATUS_FILTERS)[number];

export default function McqReportsPage() {
  const router = useRouter();
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);
  const [reports, setReports] = useState<Report[]>([]);
  const [leaderboard, setLeaderboard] = useState<Reporter[]>([]);
  const [filter, setFilter] = useState<StatusFilter>("pending");
  const [busyId, setBusyId] = useState<string | null>(null);
  const [toast, setToast] = useState("");

  const loadData = useCallback(async () => {
    const res = await fetch("/api/admin/mcq/reports");
    if (!res.ok) {
      console.error("Failed to load reports");
      return;
    }
    const json = (await res.json()) as {
      reports: Report[];
      leaderboard: Reporter[];
    };
    setReports(json.reports ?? []);
    setLeaderboard(json.leaderboard ?? []);
  }, []);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();
      if (profile?.role !== "admin") {
        setLoading(false);
        return;
      }
      setIsAdmin(true);
      await loadData();
      setLoading(false);
    }
    init();
  }, [router, loadData]);

  async function setStatus(reportId: string, status: string) {
    setBusyId(reportId);
    setToast("");
    try {
      const res = await fetch(`/api/admin/mcq/reports/${reportId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        setToast(`อัปเดตไม่สำเร็จ: ${json.error ?? "unknown"}`);
        return;
      }
      if (status === "confirmed") {
        setToast("ยืนยันแล้ว — ให้ +10 คะแนน Bug Hunter กับผู้แจ้งเรียบร้อย");
      }
      await loadData();
    } finally {
      setBusyId(null);
    }
  }

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="h-12 w-12 mx-auto mb-4 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  const filtered =
    filter === "all" ? reports : reports.filter((r) => r.status === filter);
  const pendingCount = reports.filter((r) => r.status === "pending").length;

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <Link
        href="/admin/mcq"
        className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4"
      >
        <ChevronLeft className="h-4 w-4" /> กลับไปจัดการ MCQ
      </Link>

      <div className="flex items-center gap-2 mb-1">
        <Flag className="h-6 w-6 text-amber-600" />
        <h1 className="text-2xl font-bold">รายงานข้อสอบจากนักเรียน (Bug Hunter)</h1>
      </div>
      <p className="text-sm text-muted-foreground mb-6">
        ยืนยันรายงานที่ถูกต้องเพื่อให้ <span className="font-semibold">+10 คะแนน</span>{" "}
        กับผู้แจ้ง — แล้วแก้เฉลยในข้อนั้นได้เลย
      </p>

      {toast && (
        <div className="mb-4 rounded-lg border border-green-200 bg-green-50 px-3 py-2 text-sm text-green-800">
          {toast}
        </div>
      )}

      {/* Leaderboard */}
      {leaderboard.length > 0 && (
        <Card className="mb-6 border-amber-200">
          <CardHeader className="pb-2">
            <h2 className="font-semibold flex items-center gap-2 text-amber-800">
              <Trophy className="h-5 w-5" /> อันดับ Bug Hunter (คะแนนสะสมรวม)
            </h2>
            <p className="text-xs text-muted-foreground">
              ใช้เลือกคนที่จะให้รางวัลพิเศษ/จ่ายเองนอกระบบได้
            </p>
          </CardHeader>
          <CardContent>
            <ol className="space-y-1.5">
              {leaderboard.map((u, i) => (
                <li
                  key={u.id}
                  className="flex items-center justify-between text-sm rounded-md px-2 py-1.5 odd:bg-muted/40"
                >
                  <span className="flex items-center gap-2 min-w-0">
                    <span className="w-6 text-center font-bold text-amber-700">
                      {i + 1}
                    </span>
                    <span className="truncate">
                      {u.name || u.email || u.id.slice(0, 8)}
                    </span>
                  </span>
                  <span className="flex items-center gap-3 shrink-0 tabular-nums">
                    <span className="text-muted-foreground text-xs">
                      เหลือใช้ {availableReporterPoints(u)}
                    </span>
                    <span className="font-semibold text-amber-700">
                      {u.reporter_points} คะแนน
                    </span>
                  </span>
                </li>
              ))}
            </ol>
          </CardContent>
        </Card>
      )}

      {/* Status filter */}
      <div className="flex flex-wrap gap-2 mb-4">
        {STATUS_FILTERS.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={`px-3 py-1.5 rounded-full text-sm border transition-colors ${
              filter === s
                ? "bg-amber-500 border-amber-500 text-white"
                : "bg-white border-border text-muted-foreground hover:border-amber-400"
            }`}
          >
            {s === "all" ? "ทั้งหมด" : REPORT_STATUS_LABELS[s] ?? s}
            {s === "pending" && pendingCount > 0 && (
              <span className="ml-1.5 font-semibold">({pendingCount})</span>
            )}
          </button>
        ))}
      </div>

      {filtered.length === 0 ? (
        <p className="text-center text-muted-foreground py-12">ไม่มีรายงานในหมวดนี้</p>
      ) : (
        <div className="space-y-3">
          {filtered.map((r) => (
            <Card key={r.id}>
              <CardContent className="p-4 space-y-3">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge className={STATUS_COLORS[r.status] ?? ""}>
                      {REPORT_STATUS_LABELS[r.status] ?? r.status}
                    </Badge>
                    <Badge variant="outline">
                      {REPORT_REASON_LABELS[r.reason] ?? r.reason}
                    </Badge>
                    {r.suggested_answer && (
                      <Badge className="bg-amber-100 text-amber-800">
                        เสนอเฉลย: {r.suggested_answer}
                      </Badge>
                    )}
                    {r.mcq_questions && (
                      <span className="text-xs text-muted-foreground">
                        เฉลยปัจจุบัน: <b>{r.mcq_questions.correct_answer}</b>
                      </span>
                    )}
                  </div>
                  <span className="text-xs text-muted-foreground shrink-0">
                    {new Date(r.created_at).toLocaleDateString("th-TH")}
                  </span>
                </div>

                <p className="text-sm">
                  {r.mcq_questions?.scenario
                    ? r.mcq_questions.scenario.slice(0, 240) +
                      (r.mcq_questions.scenario.length > 240 ? "…" : "")
                    : "(ไม่พบโจทย์ — อาจถูกลบไปแล้ว)"}
                </p>

                {r.note && (
                  <p className="text-sm bg-muted/50 rounded px-3 py-2">
                    <span className="text-muted-foreground">หมายเหตุผู้แจ้ง: </span>
                    {r.note}
                  </p>
                )}

                <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                  <span className="text-xs text-muted-foreground">
                    ผู้แจ้ง: {r.reporter?.name || r.reporter?.email || "—"}
                    {r.reporter && (
                      <> · มี {r.reporter.reporter_points} คะแนน</>
                    )}
                  </span>

                  <div className="flex flex-wrap gap-2">
                    <Link href={`/admin/mcq/${r.question_id}`}>
                      <Button size="sm" variant="outline" className="gap-1">
                        <Pencil className="h-3.5 w-3.5" /> แก้ข้อสอบ
                      </Button>
                    </Link>
                    {r.status !== "confirmed" && (
                      <Button
                        size="sm"
                        disabled={busyId === r.id}
                        onClick={() => setStatus(r.id, "confirmed")}
                        className="bg-green-600 hover:bg-green-700 text-white gap-1"
                      >
                        {busyId === r.id ? (
                          <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        ) : (
                          <CheckCircle2 className="h-3.5 w-3.5" />
                        )}
                        ยืนยัน (+10)
                      </Button>
                    )}
                    {r.status !== "duplicate" && (
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={busyId === r.id}
                        onClick={() => setStatus(r.id, "duplicate")}
                        className="gap-1"
                      >
                        <Copy className="h-3.5 w-3.5" /> ซ้ำ
                      </Button>
                    )}
                    {r.status !== "rejected" && (
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={busyId === r.id}
                        onClick={() => setStatus(r.id, "rejected")}
                        className="gap-1 text-red-600 hover:text-red-700"
                      >
                        <XCircle className="h-3.5 w-3.5" /> ปฏิเสธ
                      </Button>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <p className="mt-6 text-xs text-muted-foreground flex items-center gap-1">
        <ExternalLink className="h-3 w-3" />
        นักเรียนแลกคะแนนเป็นสมาชิกฟรีได้เองที่หน้าโปรไฟล์
      </p>
    </div>
  );
}
