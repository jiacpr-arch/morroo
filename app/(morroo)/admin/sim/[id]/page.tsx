"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { createClient } from "@/lib/supabase/client";
import { ChevronLeft, Loader2, Shield, Trash2 } from "lucide-react";
import SimScenarioForm, { type SimFormValues } from "../SimScenarioForm";

export default function AdminSimEditPage() {
  const router = useRouter();
  const params = useParams<{ id: string }>();
  const id = params.id;
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [initial, setInitial] = useState<SimFormValues | null>(null);
  const [notFoundMsg, setNotFoundMsg] = useState<string | null>(null);
  const [deleting, setDeleting] = useState(false);

  useEffect(() => {
    async function init() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
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

      const res = await fetch(`/api/admin/sim/${id}`);
      if (!res.ok) {
        const json = await res.json().catch(() => ({}));
        setNotFoundMsg(json.error ?? "โหลดเคสไม่สำเร็จ");
        setLoading(false);
        return;
      }
      const { scenario } = await res.json();
      setInitial({
        slug: scenario.slug,
        title: scenario.title,
        subtitle: scenario.subtitle ?? "",
        difficultyTag: scenario.difficulty_tag ?? "basic",
        category: scenario.category ?? "acls",
        sourceCaseId: scenario.source_case_id ?? undefined,
        status: scenario.status,
        storyJson: JSON.stringify(scenario.story, null, 2),
      });
      setLoading(false);
    }
    init();
  }, [router, id]);

  async function save(values: SimFormValues, story: unknown) {
    const res = await fetch(`/api/admin/sim/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        slug: values.slug,
        title: values.title,
        subtitle: values.subtitle,
        difficulty_tag: values.difficultyTag,
        category: values.category,
        source_case_id: values.sourceCaseId ?? null,
        status: values.status,
        story,
      }),
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.error ?? "บันทึกไม่สำเร็จ");
    router.push("/admin/sim");
  }

  async function remove() {
    if (!initial) return;
    if (!confirm(`ลบเคส "${initial.title}"? การลบย้อนกลับไม่ได้`)) return;
    setDeleting(true);
    await fetch(`/api/admin/sim/${id}`, { method: "DELETE" });
    router.push("/admin/sim");
  }

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (!isAdmin) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <Shield className="mx-auto mb-4 h-12 w-12 text-muted-foreground" />
        <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="mt-2 text-muted-foreground">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6">
      <Link
        href="/admin/sim"
        className="mb-4 inline-flex items-center text-sm text-muted-foreground hover:text-foreground"
      >
        <ChevronLeft className="h-4 w-4" /> กลับรายการเคส
      </Link>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="text-2xl font-bold">แก้ไขเคส</h1>
        <Button variant="outline" className="gap-1 text-red-600" onClick={remove} disabled={deleting}>
          {deleting ? <Loader2 className="h-4 w-4 animate-spin" /> : <Trash2 className="h-4 w-4" />}
          ลบเคส
        </Button>
      </div>
      {notFoundMsg ? (
        <div className="rounded-md bg-red-50 p-4 text-red-700">{notFoundMsg}</div>
      ) : initial ? (
        <SimScenarioForm initial={initial} submitLabel="บันทึกการแก้ไข" onSubmit={save} />
      ) : null}
    </div>
  );
}
