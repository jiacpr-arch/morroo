"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2, Shield } from "lucide-react";
import { McqForm } from "../McqForm";

interface McqSubject { id: string; name_th: string; icon: string; }

export default function NewMcqPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(true);
  const [isAdmin, setIsAdmin] = useState(false);
  const [subjects, setSubjects] = useState<McqSubject[]>([]);

  useEffect(() => {
    async function load() {
      const supabase = createClient();
      const { data: { user } } = await supabase.auth.getUser();
      if (!user) { router.push("/login"); return; }

      const { data: profile } = await supabase
        .from("profiles").select("role").eq("id", user.id).single();
      if (profile?.role !== "admin") { setLoading(false); return; }

      setIsAdmin(true);
      const { data } = await supabase
        .from("mcq_subjects").select("id, name_th, icon").order("name_th");
      setSubjects((data as McqSubject[]) || []);
      setLoading(false);
    }
    load();
  }, [router]);

  if (loading) return <div className="flex items-center justify-center min-h-[60vh]"><Loader2 className="h-8 w-8 animate-spin text-brand" /></div>;

  if (!isAdmin) return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
      <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
    </div>
  );

  return <McqForm subjects={subjects} />;
}
