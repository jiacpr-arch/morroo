"use client";

import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import {
  AUTO_HIDE_REPORT_THRESHOLD,
  COMMENT_REPORT_REASON_LABELS,
  type CommentReportReason,
} from "@/lib/mcq-comments";
import {
  Shield,
  Loader2,
  ChevronLeft,
  MessageCircle,
  Eye,
  EyeOff,
  Trash2,
  Pencil,
  ThumbsUp,
} from "lucide-react";

type ModComment = {
  id: string;
  question_id: string;
  parent_id: string | null;
  body: string;
  created_at: string;
  edited_at: string | null;
  status: "visible" | "hidden";
  upvotes: number;
  moderated_at: string | null;
  question_scenario: string | null;
  author: { name: string | null; email: string | null } | null;
  report_count: number;
  open_report_count: number;
  open_reasons: Record<string, number>;
  last_reported_at: string | null;
};

const FILTERS = ["open", "hidden", "all"] as const;
type Filter = (typeof FILTERS)[number];
const FILTER_LABELS: Record<Filter, string> = {
  open: "รอตรวจ",
  hidden: "ถูกซ่อน",
  all: "ทั้งหมด",
};

export default function McqCommentsModerationPage() {
  const router = useRouter();
  const [isAdmin, setIsAdmin] = useState(false);
  const [loading, setLoading] = useState(true);
  const [comments, setComments] = useState<ModComment[]>([]);
  const [filter, setFilter] = useState<Filter>("open");
  const [busyId, setBusyId] = useState<string | null>(null);
  const [toast, setToast] = useState("");

  const loadData = useCallback(async () => {
    const res = await fetch("/api/admin/mcq/comments");
    if (!res.ok) {
      console.error("Failed to load comments");
      return;
    }
    const json = (await res.json()) as { comments: ModComment[] };
    setComments(json.comments ?? []);
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

  async function act(id: string, action: "visible" | "hidden" | "delete") {
    if (action === "delete" && !window.confirm("ลบความคิดเห็นนี้ถาวร? (คำตอบกลับจะถูกลบด้วย)")) {
      return;
    }
    setBusyId(id);
    setToast("");
    try {
      const res = await fetch(`/api/admin/mcq/comments/${id}`, {
        method: action === "delete" ? "DELETE" : "PATCH",
        headers: { "Content-Type": "application/json" },
        body: action === "delete" ? undefined : JSON.stringify({ status: action }),
      });
      const json = (await res.json()) as { error?: string };
      if (!res.ok) {
        setToast(`ทำรายการไม่สำเร็จ: ${json.error ?? "unknown"}`);
        return;
      }
      setToast(
        action === "delete"
          ? "ลบแล้ว"
          : action === "visible"
            ? "เปิดให้เห็นแล้ว — รายงานก่อนหน้านี้ถือว่าตรวจแล้ว"
            : "ซ่อนแล้ว"
      );
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

  const filtered = comments.filter((c) =>
    filter === "all"
      ? true
      : filter === "hidden"
        ? c.status === "hidden"
        : c.open_report_count > 0
  );
  const openCount = comments.filter((c) => c.open_report_count > 0).length;
  const hiddenCount = comments.filter((c) => c.status === "hidden").length;

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <Link
        href="/admin"
        className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4"
      >
        <ChevronLeft className="h-4 w-4" /> กลับหน้า Admin
      </Link>

      <div className="flex items-center gap-2 mb-1">
        <MessageCircle className="h-6 w-6 text-sky-600" />
        <h1 className="text-2xl font-bold">อภิปรายข้อสอบ — Moderation</h1>
      </div>
      <p className="text-sm text-muted-foreground mb-6">
        ความคิดเห็นที่ถูกรายงานครบ {AUTO_HIDE_REPORT_THRESHOLD} ครั้งจะถูกซ่อนอัตโนมัติ —
        กด “เปิดให้เห็น” เพื่อยืนยันว่าไม่ผิด (รายงานเดิมจะไม่นับอีก) ·{" "}
        <Link href="/admin/mcq/reports" className="underline underline-offset-2">
          รายงานข้อสอบ (Bug Hunter)
        </Link>
      </p>

      {toast && (
        <div className="mb-4 rounded-lg border border-green-200 bg-green-50 px-3 py-2 text-sm text-green-800">
          {toast}
        </div>
      )}

      <div className="flex flex-wrap gap-2 mb-4">
        {FILTERS.map((f) => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className={`px-3 py-1.5 rounded-full text-sm border transition-colors ${
              filter === f
                ? "bg-sky-600 border-sky-600 text-white"
                : "bg-white border-border text-muted-foreground hover:border-sky-400"
            }`}
          >
            {FILTER_LABELS[f]}
            {f === "open" && openCount > 0 && (
              <span className="ml-1.5 font-semibold">({openCount})</span>
            )}
            {f === "hidden" && hiddenCount > 0 && (
              <span className="ml-1.5 font-semibold">({hiddenCount})</span>
            )}
          </button>
        ))}
      </div>

      {filtered.length === 0 ? (
        <p className="text-center text-muted-foreground py-12">ไม่มีความคิดเห็นในหมวดนี้</p>
      ) : (
        <div className="space-y-3">
          {filtered.map((c) => (
            <Card key={c.id}>
              <CardContent className="p-4 space-y-3">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex flex-wrap items-center gap-2">
                    <Badge
                      className={
                        c.status === "hidden"
                          ? "bg-red-100 text-red-700"
                          : "bg-green-100 text-green-700"
                      }
                    >
                      {c.status === "hidden" ? "ถูกซ่อน" : "แสดงอยู่"}
                    </Badge>
                    {c.open_report_count > 0 && (
                      <Badge className="bg-yellow-100 text-yellow-700">
                        รอตรวจ {c.open_report_count} รายงาน
                      </Badge>
                    )}
                    {Object.entries(c.open_reasons).map(([reason, n]) => (
                      <Badge key={reason} variant="outline">
                        {COMMENT_REPORT_REASON_LABELS[reason as CommentReportReason] ?? reason}
                        {n > 1 ? ` ×${n}` : ""}
                      </Badge>
                    ))}
                    {c.parent_id && <Badge variant="outline">คำตอบกลับ</Badge>}
                    <span className="inline-flex items-center gap-1 text-xs text-muted-foreground">
                      <ThumbsUp className="h-3 w-3" /> {c.upvotes}
                    </span>
                  </div>
                  <span className="text-xs text-muted-foreground shrink-0">
                    {new Date(c.created_at).toLocaleDateString("th-TH")}
                  </span>
                </div>

                <p className="text-sm whitespace-pre-wrap break-words bg-muted/50 rounded px-3 py-2">
                  {c.body}
                </p>

                <p className="text-xs text-muted-foreground">
                  ข้อสอบ:{" "}
                  {c.question_scenario
                    ? c.question_scenario.slice(0, 160) +
                      (c.question_scenario.length > 160 ? "…" : "")
                    : "(ไม่พบโจทย์)"}
                </p>

                <div className="flex flex-wrap items-center justify-between gap-2 pt-1">
                  <span className="text-xs text-muted-foreground">
                    ผู้เขียน: {c.author?.name || c.author?.email || "—"}
                    {c.report_count > c.open_report_count && (
                      <> · ตรวจแล้ว {c.report_count - c.open_report_count} รายงาน</>
                    )}
                  </span>

                  <div className="flex flex-wrap gap-2">
                    <Link href={`/admin/mcq/${c.question_id}`}>
                      <Button size="sm" variant="outline" className="gap-1">
                        <Pencil className="h-3.5 w-3.5" /> ดูข้อสอบ
                      </Button>
                    </Link>
                    {c.status === "hidden" || c.open_report_count > 0 ? (
                      <Button
                        size="sm"
                        disabled={busyId === c.id}
                        onClick={() => act(c.id, "visible")}
                        className="bg-green-600 hover:bg-green-700 text-white gap-1"
                      >
                        {busyId === c.id ? (
                          <Loader2 className="h-3.5 w-3.5 animate-spin" />
                        ) : (
                          <Eye className="h-3.5 w-3.5" />
                        )}
                        {c.status === "hidden" ? "เปิดให้เห็น" : "ไม่ผิด (ปิดรายงาน)"}
                      </Button>
                    ) : null}
                    {c.status === "visible" && (
                      <Button
                        size="sm"
                        variant="outline"
                        disabled={busyId === c.id}
                        onClick={() => act(c.id, "hidden")}
                        className="gap-1"
                      >
                        <EyeOff className="h-3.5 w-3.5" /> ซ่อน
                      </Button>
                    )}
                    <Button
                      size="sm"
                      variant="outline"
                      disabled={busyId === c.id}
                      onClick={() => act(c.id, "delete")}
                      className="gap-1 text-red-600 hover:text-red-700"
                    >
                      <Trash2 className="h-3.5 w-3.5" /> ลบ
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
