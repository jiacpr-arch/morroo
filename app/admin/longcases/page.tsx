"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { createClient } from "@/lib/supabase/client";
import {
  Shield,
  Loader2,
  ArrowLeft,
  Plus,
  Stethoscope,
  Star,
  Trash2,
  Eye,
  EyeOff,
} from "lucide-react";

interface LongCaseRow {
  id: string;
  title: string;
  specialty: string;
  difficulty: "easy" | "medium" | "hard";
  is_weekly: boolean;
  week_number: number | null;
  is_published: boolean;
  created_at: string;
}

const difficultyLabel: Record<string, { label: string; color: string }> = {
  easy:   { label: "ง่าย",    color: "bg-green-100 text-green-700" },
  medium: { label: "ปานกลาง", color: "bg-yellow-100 text-yellow-700" },
  hard:   { label: "ยาก",     color: "bg-red-100 text-red-700" },
};

const specialtyColor: Record<string, string> = {
  Medicine:    "bg-blue-100 text-blue-700",
  Surgery:     "bg-red-100 text-red-700",
  Obstetrics:  "bg-pink-100 text-pink-700",
  Pediatrics:  "bg-green-100 text-green-700",
  Emergency:   "bg-orange-100 text-orange-700",
  Cardiology:  "bg-rose-100 text-rose-700",
  Neurology:   "bg-purple-100 text-purple-700",
  Orthopedics: "bg-amber-100 text-amber-700",
};

export default function AdminLongCasesPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [cases, setCases] = useState<LongCaseRow[]>([]);
  const [actionId, setActionId] = useState<string | null>(null);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles")
        .select("role")
        .eq("id", user.id)
        .single();

      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      const { data } = await supabase
        .from("long_cases")
        .select("id, title, specialty, difficulty, is_weekly, week_number, is_published, created_at")
        .order("created_at", { ascending: false });

      setCases((data as LongCaseRow[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  async function togglePublish(id: string, current: boolean) {
    setActionId(id);
    const supabase = createClient();
    await supabase.from("long_cases").update({ is_published: !current }).eq("id", id);
    setCases(prev => prev.map(c => c.id === id ? { ...c, is_published: !current } : c));
    setActionId(null);
  }

  async function toggleWeekly(id: string, current: boolean) {
    setActionId(id);
    const supabase = createClient();
    await supabase.from("long_cases").update({ is_weekly: !current }).eq("id", id);
    setCases(prev => prev.map(c => c.id === id ? { ...c, is_weekly: !current } : c));
    setActionId(null);
  }

  async function deleteCase(id: string) {
    if (!confirm("ลบ Long Case นี้? (ไม่สามารถกู้คืนได้)")) return;
    setActionId(id);
    const supabase = createClient();
    await supabase.from("long_cases").delete().eq("id", id);
    setCases(prev => prev.filter(c => c.id !== id));
    setActionId(null);
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
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

  const weeklyCases = cases.filter(c => c.is_weekly);
  const regularCases = cases.filter(c => !c.is_weekly);

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Link href="/admin">
            <Button variant="ghost" size="sm">
              <ArrowLeft className="h-4 w-4 mr-1" /> กลับ
            </Button>
          </Link>
          <div>
            <h1 className="text-2xl font-bold flex items-center gap-2">
              <Stethoscope className="h-6 w-6 text-amber-600" />
              Long Case Exam
            </h1>
            <p className="text-sm text-muted-foreground">{cases.length} เคสทั้งหมด</p>
          </div>
        </div>
        <Link href="/admin/longcases/new">
          <Button className="bg-amber-500 hover:bg-amber-600 text-white gap-2">
            <Plus className="h-4 w-4" /> เพิ่มเคสใหม่
          </Button>
        </Link>
      </div>

      {/* Weekly Cases */}
      {weeklyCases.length > 0 && (
        <div className="mb-6">
          <div className="flex items-center gap-2 mb-3">
            <Star className="h-4 w-4 text-amber-500 fill-amber-500" />
            <h2 className="font-semibold text-gray-800">Case ประจำสัปดาห์</h2>
          </div>
          <div className="space-y-2">
            {weeklyCases.map(c => (
              <CaseRow
                key={c.id}
                c={c}
                actionId={actionId}
                onTogglePublish={togglePublish}
                onToggleWeekly={toggleWeekly}
                onDelete={deleteCase}
              />
            ))}
          </div>
        </div>
      )}

      {/* Regular Cases */}
      <div>
        <h2 className="font-semibold text-gray-800 mb-3">เคสทั้งหมด ({regularCases.length})</h2>
        {regularCases.length === 0 && (
          <Card>
            <CardContent className="py-12 text-center text-muted-foreground">
              ยังไม่มีเคส — กดเพิ่มเคสใหม่ด้านบน
            </CardContent>
          </Card>
        )}
        <div className="space-y-2">
          {regularCases.map(c => (
            <CaseRow
              key={c.id}
              c={c}
              actionId={actionId}
              onTogglePublish={togglePublish}
              onToggleWeekly={toggleWeekly}
              onDelete={deleteCase}
            />
          ))}
        </div>
      </div>
    </div>
  );
}

function CaseRow({
  c, actionId, onTogglePublish, onToggleWeekly, onDelete,
}: {
  c: LongCaseRow;
  actionId: string | null;
  onTogglePublish: (id: string, current: boolean) => void;
  onToggleWeekly: (id: string, current: boolean) => void;
  onDelete: (id: string) => void;
}) {
  const diff = difficultyLabel[c.difficulty] || difficultyLabel.medium;
  const specColor = specialtyColor[c.specialty] || "bg-gray-100 text-gray-700";
  const isBusy = actionId === c.id;

  return (
    <Card className={`transition-colors ${c.is_weekly ? "border-amber-300" : ""}`}>
      <CardContent className="p-4 flex items-center gap-4 flex-wrap sm:flex-nowrap">
        <div className="flex-1 min-w-0">
          <div className="flex flex-wrap gap-1.5 mb-1">
            <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${specColor}`}>{c.specialty}</span>
            <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${diff.color}`}>{diff.label}</span>
            {c.is_weekly && (
              <Badge className="bg-amber-100 text-amber-700 border-amber-200 text-xs">
                <Star className="h-2.5 w-2.5 mr-0.5 fill-amber-500" />
                Week {c.week_number ?? ""}
              </Badge>
            )}
            {!c.is_published && (
              <Badge variant="secondary" className="text-xs">ซ่อน</Badge>
            )}
          </div>
          <p className="font-semibold text-gray-900 truncate text-sm">{c.title}</p>
          <p className="text-xs text-muted-foreground mt-0.5">
            {new Date(c.created_at).toLocaleDateString("th-TH", { year: "numeric", month: "short", day: "numeric" })}
          </p>
        </div>

        <div className="flex items-center gap-2 shrink-0">
          {/* Toggle Weekly */}
          <Button
            variant="ghost"
            size="sm"
            disabled={isBusy}
            onClick={() => onToggleWeekly(c.id, c.is_weekly)}
            className={`text-xs gap-1 ${c.is_weekly ? "text-amber-600" : "text-gray-400"}`}
            title={c.is_weekly ? "ยกเลิก Weekly" : "ตั้งเป็น Weekly"}
          >
            {isBusy ? <Loader2 className="h-3 w-3 animate-spin" /> : <Star className={`h-3.5 w-3.5 ${c.is_weekly ? "fill-amber-500" : ""}`} />}
          </Button>

          {/* Toggle Publish */}
          <Button
            variant="ghost"
            size="sm"
            disabled={isBusy}
            onClick={() => onTogglePublish(c.id, c.is_published)}
            className={`text-xs gap-1 ${c.is_published ? "text-green-600" : "text-gray-400"}`}
            title={c.is_published ? "ซ่อน" : "เผยแพร่"}
          >
            {isBusy ? <Loader2 className="h-3 w-3 animate-spin" /> : c.is_published ? <Eye className="h-3.5 w-3.5" /> : <EyeOff className="h-3.5 w-3.5" />}
          </Button>

          {/* Delete */}
          <Button
            variant="ghost"
            size="sm"
            disabled={isBusy}
            onClick={() => onDelete(c.id)}
            className="text-red-400 hover:text-red-600 hover:bg-red-50"
          >
            {isBusy ? <Loader2 className="h-3 w-3 animate-spin" /> : <Trash2 className="h-3.5 w-3.5" />}
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
