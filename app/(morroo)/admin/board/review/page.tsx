"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { createClient } from "@/lib/supabase/client";
import { bulkUpdateMcqQuestionStatus } from "@/lib/supabase/mutations-mcq-admin";
import {
  ChevronLeft, Shield, Loader2, ClipboardCheck, CheckCircle2,
} from "lucide-react";
import { BOARD_SECTIONS } from "@/lib/types-board";
import { ReviewQuestionCard } from "@/components/admin/ReviewQuestionCard";
import type { McqQuestion } from "@/lib/types-mcq";

interface SpecialtyRef {
  slug: string;
  name_th: string;
}

const PAGE_LIMIT = 100;

export default function BoardReviewPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [specialties, setSpecialties] = useState<SpecialtyRef[]>([]);
  const [questions, setQuestions] = useState<McqQuestion[]>([]);
  const [fetching, setFetching] = useState(false);
  const [specialty, setSpecialty] = useState<string>("");
  const [section, setSection] = useState<string>("");
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [bulkBusy, setBulkBusy] = useState(false);

  async function loadQuestions(
    specFilter: string,
    sectionFilter: string
  ): Promise<McqQuestion[]> {
    const supabase = createClient();
    let q = supabase
      .from("mcq_questions")
      .select("*")
      .eq("audience", "board")
      .eq("status", "review")
      .order("created_at", { ascending: false })
      .limit(PAGE_LIMIT);
    if (specFilter) q = q.eq("board_specialty", specFilter);
    if (sectionFilter) q = q.eq("board_section", sectionFilter);
    const { data, error } = await q;
    if (error) {
      console.error("Failed to load review queue:", error);
      return [];
    }
    return (data ?? []) as McqQuestion[];
  }

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }
      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }
      setIsAdmin(true);

      const { data: specs } = await supabase
        .from("board_specialties")
        .select("slug, name_th")
        .eq("is_active", true)
        .order("slug");
      setSpecialties((specs ?? []) as SpecialtyRef[]);

      const rows = await loadQuestions("", "");
      setQuestions(rows);
      setLoading(false);
    }
    init();
  }, [router]);

  async function refilter(s: string, sec: string) {
    setSpecialty(s);
    setSection(sec);
    setFetching(true);
    setSelectedIds(new Set());
    const rows = await loadQuestions(s, sec);
    setQuestions(rows);
    setFetching(false);
  }

  function toggleSelect(id: string) {
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  function selectAllVisible() {
    if (selectedIds.size === questions.length) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(questions.map((q) => q.id)));
    }
  }

  function removeFromList(id: string) {
    setQuestions((prev) => prev.filter((q) => q.id !== id));
    setSelectedIds((prev) => {
      const next = new Set(prev);
      next.delete(id);
      return next;
    });
  }

  async function bulkApprove() {
    if (selectedIds.size === 0) return;
    if (!confirm(`Approve ${selectedIds.size} ข้อ?`)) return;
    setBulkBusy(true);
    const ids = Array.from(selectedIds);
    const { ok, failed } = await bulkUpdateMcqQuestionStatus(ids, "active");
    setBulkBusy(false);
    if (failed > 0) {
      alert(`Approve สำเร็จ ${ok} ข้อ, ล้มเหลว ${failed} ข้อ`);
    }
    if (ok > 0) {
      setQuestions((prev) => prev.filter((q) => !selectedIds.has(q.id)));
      setSelectedIds(new Set());
    }
  }

  const allSelected = useMemo(
    () => questions.length > 0 && selectedIds.size === questions.length,
    [questions.length, selectedIds.size]
  );

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
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/board">
          <Button variant="ghost" size="sm">
            <ChevronLeft className="h-4 w-4 mr-1" /> Board dashboard
          </Button>
        </Link>
      </div>

      <div className="flex items-center justify-between mb-6 flex-wrap gap-3">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <ClipboardCheck className="h-6 w-6 text-amber-700" />
            Review queue
          </h1>
          <p className="text-muted-foreground mt-1 text-sm">
            ข้อสอบ board ที่รอ admin review/approve
          </p>
        </div>
        <Badge variant="secondary" className="text-sm">
          {questions.length} ข้อ
          {questions.length === PAGE_LIMIT ? "+" : ""}
        </Badge>
      </div>

      {/* Filter bar */}
      <div className="flex flex-wrap items-end gap-3 mb-4 rounded-lg border bg-muted/30 p-3">
        <div>
          <label className="block text-xs text-muted-foreground mb-1">Specialty</label>
          <select
            value={specialty}
            onChange={(e) => refilter(e.target.value, section)}
            className="h-8 rounded-md border border-input bg-background px-2 text-sm"
          >
            <option value="">All</option>
            {specialties.map((s) => (
              <option key={s.slug} value={s.slug}>{s.name_th} ({s.slug})</option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-xs text-muted-foreground mb-1">Section</label>
          <select
            value={section}
            onChange={(e) => refilter(specialty, e.target.value)}
            className="h-8 rounded-md border border-input bg-background px-2 text-sm"
          >
            <option value="">All</option>
            {BOARD_SECTIONS.map((s) => (
              <option key={s.code} value={s.code}>{s.label_th}</option>
            ))}
          </select>
        </div>
        {(specialty || section) && (
          <Button
            variant="ghost"
            size="sm"
            onClick={() => refilter("", "")}
          >
            Clear
          </Button>
        )}
        {fetching && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
      </div>

      {/* Bulk action bar */}
      {questions.length > 0 && (
        <div className="sticky top-2 z-10 mb-4 rounded-lg border bg-white px-3 py-2 shadow-sm flex items-center gap-3 flex-wrap">
          <label className="flex items-center gap-2 text-sm cursor-pointer">
            <input
              type="checkbox"
              checked={allSelected}
              onChange={selectAllVisible}
              className="h-4 w-4"
            />
            Select all ({questions.length})
          </label>
          <div className="ml-auto flex items-center gap-2">
            <span className="text-sm text-muted-foreground">
              {selectedIds.size} selected
            </span>
            <Button
              size="sm"
              disabled={selectedIds.size === 0 || bulkBusy}
              onClick={bulkApprove}
              className="bg-emerald-600 hover:bg-emerald-700"
            >
              {bulkBusy ? (
                <Loader2 className="h-3 w-3 animate-spin mr-1" />
              ) : (
                <CheckCircle2 className="h-3 w-3 mr-1" />
              )}
              Approve selected
            </Button>
          </div>
        </div>
      )}

      {/* List */}
      {questions.length === 0 ? (
        <div className="rounded-lg border bg-emerald-50/50 p-8 text-center">
          <CheckCircle2 className="h-10 w-10 text-emerald-600 mx-auto mb-2" />
          <p className="text-sm text-muted-foreground">
            ไม่มีข้อค้างใน review queue
          </p>
        </div>
      ) : (
        <div className="space-y-4">
          {questions.map((q) => (
            <ReviewQuestionCard
              key={q.id}
              question={q}
              selected={selectedIds.has(q.id)}
              onToggleSelect={() => toggleSelect(q.id)}
              onRemove={() => removeFromList(q.id)}
            />
          ))}
        </div>
      )}
    </div>
  );
}
