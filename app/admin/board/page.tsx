"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import {
  ChevronLeft, Shield, Loader2, GraduationCap, Eye, EyeOff,
  Upload, BookOpen, Mic, Sparkles, ClipboardCheck, History,
} from "lucide-react";

interface BoardStats {
  slug: string;
  name_th: string;
  is_published: boolean;
  mcq_count: number;
  oral_count: number;
}

// Heuristic: a specialty is "ready to publish" once it has enough content for
// a meaningful first user session. Tuned conservatively — adjust as needed.
const READY_MCQ_THRESHOLD = 30;
const READY_ORAL_THRESHOLD = 2;

function readinessLevel(mcq: number, oral: number): {
  label: string;
  color: string;
} {
  if (mcq >= READY_MCQ_THRESHOLD && oral >= READY_ORAL_THRESHOLD) {
    return { label: "พร้อม publish", color: "bg-emerald-100 text-emerald-700" };
  }
  if (mcq >= READY_MCQ_THRESHOLD / 2 || oral >= 1) {
    return { label: "เริ่มมีเนื้อหา", color: "bg-amber-100 text-amber-700" };
  }
  return { label: "รอ content", color: "bg-gray-100 text-gray-600" };
}

export default function AdminBoardPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [stats, setStats] = useState<BoardStats[]>([]);
  const [flipping, setFlipping] = useState<string | null>(null);

  async function load() {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) { router.push("/login"); return; }

    const { data: profile } = await supabase
      .from("profiles").select("role").eq("id", user.id).single();
    if (profile?.role !== "admin") { setLoading(false); return; }
    setIsAdmin(true);

    const [specRes, mcqRes, oralRes] = await Promise.all([
      supabase
        .from("board_specialties")
        .select("slug, name_th, is_published, is_active")
        .eq("is_active", true)
        .order("slug"),
      supabase
        .from("mcq_questions")
        .select("board_specialty")
        .eq("audience", "board")
        .eq("status", "active"),
      supabase
        .from("long_cases")
        .select("board_specialty")
        .eq("audience", "board")
        .eq("is_published", true),
    ]);

    const mcqCounts = new Map<string, number>();
    for (const r of (mcqRes.data ?? []) as { board_specialty: string }[]) {
      mcqCounts.set(r.board_specialty, (mcqCounts.get(r.board_specialty) ?? 0) + 1);
    }
    const oralCounts = new Map<string, number>();
    for (const r of (oralRes.data ?? []) as { board_specialty: string }[]) {
      oralCounts.set(r.board_specialty, (oralCounts.get(r.board_specialty) ?? 0) + 1);
    }

    const rows: BoardStats[] = ((specRes.data ?? []) as {
      slug: string; name_th: string; is_published: boolean;
    }[]).map((s) => ({
      slug: s.slug,
      name_th: s.name_th,
      is_published: s.is_published,
      mcq_count: mcqCounts.get(s.slug) ?? 0,
      oral_count: oralCounts.get(s.slug) ?? 0,
    }));
    setStats(rows);
    setLoading(false);
  }

  useEffect(() => {
    load();
  }, [router]); // eslint-disable-line react-hooks/exhaustive-deps

  async function togglePublish(slug: string, currentlyPublished: boolean) {
    if (flipping) return;
    const action = currentlyPublished ? "unpublish" : "publish";
    if (!confirm(`ยืนยัน ${action} สาขา ${slug}?`)) return;
    setFlipping(slug);
    const supabase = createClient();
    const { error } = await supabase
      .from("board_specialties")
      .update({ is_published: !currentlyPublished })
      .eq("slug", slug);
    if (error) {
      alert(`ผิดพลาด: ${error.message}`);
    } else {
      setStats((prev) =>
        prev.map((r) =>
          r.slug === slug ? { ...r, is_published: !currentlyPublished } : r
        )
      );
    }
    setFlipping(null);
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

  const totalMcq = stats.reduce((a, s) => a + s.mcq_count, 0);
  const totalOral = stats.reduce((a, s) => a + s.oral_count, 0);
  const publishedCount = stats.filter((s) => s.is_published).length;
  const readyCount = stats.filter(
    (s) => !s.is_published && s.mcq_count >= READY_MCQ_THRESHOLD && s.oral_count >= READY_ORAL_THRESHOLD
  ).length;

  return (
    <div className="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin">
          <Button variant="ghost" size="sm">
            <ChevronLeft className="h-4 w-4 mr-1" /> Admin
          </Button>
        </Link>
      </div>

      <div className="flex items-center justify-between mb-6 flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <GraduationCap className="h-6 w-6 text-purple-700" />
            Board content dashboard
          </h1>
          <p className="text-muted-foreground mt-1 text-sm">
            ดู content velocity ของแต่ละสาขา + ตัดสินใจ publish
          </p>
        </div>
        <div className="flex gap-2 flex-wrap">
          <Link href="/admin/board/review">
            <Button variant="outline" className="gap-2">
              <ClipboardCheck className="h-4 w-4" /> Review queue
            </Button>
          </Link>
          <Link href="/admin/board/runs">
            <Button variant="outline" className="gap-2">
              <History className="h-4 w-4" /> Run history
            </Button>
          </Link>
          <Link href="/admin/board/import">
            <Button variant="outline" className="gap-2">
              <Upload className="h-4 w-4" /> Bulk import MCQ
            </Button>
          </Link>
        </div>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <Card>
          <CardContent className="pt-5">
            <div className="text-2xl font-bold">{publishedCount}/{stats.length}</div>
            <div className="text-xs text-muted-foreground">สาขา published</div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="text-2xl font-bold flex items-center gap-1">
              {readyCount} <Sparkles className="h-4 w-4 text-amber-500" />
            </div>
            <div className="text-xs text-muted-foreground">พร้อม publish</div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="text-2xl font-bold">{totalMcq}</div>
            <div className="text-xs text-muted-foreground">
              MCQ board ทั้งหมด <BookOpen className="inline h-3 w-3" />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="pt-5">
            <div className="text-2xl font-bold">{totalOral}</div>
            <div className="text-xs text-muted-foreground">
              Oral cases ทั้งหมด <Mic className="inline h-3 w-3" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Per-specialty table */}
      <div className="rounded-lg border overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-muted/50">
              <tr>
                <th className="text-left p-3">สาขา</th>
                <th className="text-right p-3 hidden sm:table-cell">MCQ</th>
                <th className="text-right p-3 hidden sm:table-cell">Oral</th>
                <th className="text-left p-3">Status</th>
                <th className="text-right p-3">Action</th>
              </tr>
            </thead>
            <tbody>
              {stats.map((s) => {
                const r = readinessLevel(s.mcq_count, s.oral_count);
                return (
                  <tr key={s.slug} className="border-t">
                    <td className="p-3">
                      <div className="font-medium">{s.name_th}</div>
                      <div className="text-xs text-muted-foreground font-mono">
                        {s.slug}
                      </div>
                      <div className="sm:hidden text-xs text-muted-foreground mt-1">
                        MCQ {s.mcq_count} · Oral {s.oral_count}
                      </div>
                    </td>
                    <td className="p-3 text-right hidden sm:table-cell font-mono">
                      {s.mcq_count}
                    </td>
                    <td className="p-3 text-right hidden sm:table-cell font-mono">
                      {s.oral_count}
                    </td>
                    <td className="p-3">
                      <div className="flex flex-col gap-1">
                        <Badge className={r.color}>{r.label}</Badge>
                        {s.is_published ? (
                          <Badge className="bg-emerald-100 text-emerald-700 gap-1">
                            <Eye className="h-3 w-3" /> Published
                          </Badge>
                        ) : (
                          <Badge variant="secondary" className="gap-1">
                            <EyeOff className="h-3 w-3" /> Hidden
                          </Badge>
                        )}
                      </div>
                    </td>
                    <td className="p-3 text-right">
                      <Button
                        size="sm"
                        variant={s.is_published ? "outline" : "default"}
                        disabled={flipping === s.slug}
                        onClick={() => togglePublish(s.slug, s.is_published)}
                      >
                        {flipping === s.slug ? (
                          <Loader2 className="h-3 w-3 animate-spin" />
                        ) : s.is_published ? (
                          "Unpublish"
                        ) : (
                          "Publish"
                        )}
                      </Button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      <p className="text-xs text-muted-foreground mt-4">
        Heuristic: พร้อม publish เมื่อมี MCQ ≥ {READY_MCQ_THRESHOLD} ข้อ + Oral ≥ {READY_ORAL_THRESHOLD} เคส
        — ปรับ threshold ในไฟล์ <code className="font-mono text-[10px]">app/admin/board/page.tsx</code>
      </p>
    </div>
  );
}
