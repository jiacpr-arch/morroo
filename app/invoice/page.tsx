"use client";

import { useEffect, useState, useCallback } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { Loader2 } from "lucide-react";

export default function InvoiceLookupPage() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const sessionId = searchParams.get("session_id");
  const [attempts, setAttempts] = useState(0);

  const lookup = useCallback(async () => {
    if (!sessionId) return;

    const supabase = createClient();
    const { data } = await supabase
      .from("invoices")
      .select("id")
      .eq("stripe_session_id", sessionId)
      .maybeSingle();

    if (data?.id) {
      router.replace(`/invoice/${data.id}`);
    } else {
      setAttempts((prev) => prev + 1);
    }
  }, [sessionId, router]);

  useEffect(() => {
    lookup();
  }, [lookup]);

  useEffect(() => {
    if (attempts === 0) return;
    const timer = setTimeout(() => {
      lookup();
    }, 3000);
    return () => clearTimeout(timer);
  }, [attempts, lookup]);

  if (!sessionId) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <p className="text-muted-foreground">ไม่พบข้อมูล session</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center space-y-4">
      <Loader2 className="h-10 w-10 animate-spin text-brand mx-auto" />
      <h1 className="text-xl font-semibold">กำลังสร้างใบเสร็จ</h1>
      <p className="text-muted-foreground">กรุณารอสักครู่ ระบบกำลังประมวลผล...</p>
      {attempts > 1 && (
        <p className="text-sm text-muted-foreground">
          กำลังตรวจสอบ... (ครั้งที่ {attempts})
        </p>
      )}
    </div>
  );
}
