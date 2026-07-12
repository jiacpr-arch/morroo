"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2, Shield } from "lucide-react";
import { createClient } from "@/lib/supabase/client";

export type AdminGateStatus = "loading" | "ok" | "denied";

// Client-side admin gate shared by every /admin/acls/** page — mirrors the
// pattern in app/admin/students/page.tsx (createClient → auth.getUser() →
// profiles.role check). Actual privileged reads/writes still go through the
// admin API routes (service role); this is UX-level gating only.
export function useAdminGate(): AdminGateStatus {
  const router = useRouter();
  const [status, setStatus] = useState<AdminGateStatus>("loading");

  useEffect(() => {
    let alive = true;
    (async () => {
      const supabase = createClient();
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        router.push("/login");
        return;
      }
      const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
      if (!alive) return;
      setStatus(profile?.role === "admin" ? "ok" : "denied");
    })();
    return () => {
      alive = false;
    };
  }, [router]);

  return status;
}

// Loading spinner / "not authorized" screen for the two non-"ok" states.
export function AdminGateScreen({ status }: { status: Exclude<AdminGateStatus, "ok"> }) {
  if (status === "loading") {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }
  return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <Shield className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
      <h1 className="text-2xl font-bold">ไม่มีสิทธิ์เข้าถึง</h1>
      <p className="text-muted-foreground mt-2">หน้านี้สำหรับผู้ดูแลระบบเท่านั้น</p>
    </div>
  );
}
