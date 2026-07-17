"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { ChevronLeft, Loader2, Shield } from "lucide-react";
import SimScenarioForm, { type SimFormValues } from "../SimScenarioForm";

export default function AdminSimNewPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);

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
      setIsAdmin(profile?.role === "admin");
      setLoading(false);
    }
    init();
  }, [router]);

  async function create(values: SimFormValues, story: unknown) {
    const res = await fetch("/api/admin/sim", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        slug: values.slug,
        title: values.title,
        subtitle: values.subtitle,
        difficultyTag: values.difficultyTag,
        category: values.category,
        sourceCaseId: values.sourceCaseId,
        status: values.status,
        story,
      }),
    });
    const json = await res.json();
    if (!res.ok) throw new Error(json.error ?? "บันทึกไม่สำเร็จ");
    router.push(`/admin/sim/${json.id}`);
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
      <h1 className="mb-6 text-2xl font-bold">สร้างเคสใหม่</h1>
      <SimScenarioForm submitLabel="บันทึกเคส" onSubmit={create} showAiPanel />
    </div>
  );
}
